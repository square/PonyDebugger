import abc
import re

import argparse

class ArgBaseError(Exception): pass
class ArgGroup(object): pass

IS_ABBV = re.compile(r'^-[^-].*$')
IS_LONG_OPT = re.compile(r'^--.*$')

def to_long_opt(var_name):
    return '--' + var_name.replace('_', '-')

def to_var_name(long_opt_or_positional):
    return long_opt_or_positional.lstrip('-').replace('-', '_')

def filtered_sorted(name_arg_tuple_iter):
    return sorted(((name, arg)
                   for name, arg
                   in name_arg_tuple_iter
                   if isinstance(arg, Arg)), 
                  key=lambda (_, arg): arg.ordinal)

def register_argument(name, arg, target_parser, expected_args):
    """
    :param target_parser: written to
    :param expected_args: written to
    """

    var_name = name
    arg_names = arg.args

    # is it positional and we have to infer value?
    if len(arg.args) == 0:
        arg_names = (name,)

    # if it is a single "-f" type arg, infer the extended version
    elif len(arg.args) == 1 and IS_ABBV.match(arg.args[0]):
        arg_names = list(arg.args) + [to_long_opt(name)]
        var_name = to_var_name(name)
    else:
        # use the non-abbreviation name
        var_name = to_var_name([n for n in arg_names if not IS_ABBV.match(n)][0])

    expected_args[var_name] = name
    
    target_parser.add_argument(*arg_names, **arg.kwargs)

def register_iter(name_arg_tuple_iter, target_parser, expected_args):
    """
    :param target_parser: written to
    :param expected_args: written to
    """

    l = filtered_sorted(name_arg_tuple_iter)
    for name, arg in l:
        register_argument(name, arg, target_parser, expected_args)

def _inject_vals(name, bases, dict):
    expected_args = {}

    dict['__expectedargs__'] = expected_args

    is_subcommand = False


    for b in bases:
        if '__parser__' in b.__dict__:
            if 'command' in b.__parser__._defaults:
                b.__parser__._defaults.pop('command')
            if issubclass(b, Command) \
               and '__subparsers__' not in b.__dict__:
                b.__subparsers__ = b.__parser__.add_subparsers(help=dict.get('__doc__'))

    for b in bases:
        if hasattr(b, '__expectedargs__'):
            expected_args.update(b.__expectedargs__)

    for b in bases:
        if b is Command:
            dict['__parser__'] = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
        elif issubclass(b, Command):
            if 'command' in b.__parser__._defaults \
               and  '__subparsers__' not in b.__dict__:
                b.__parser__._defaults.pop('command')
            
            if  '__subcommand__' not in dict:
                raise ArgBaseError(name + " must have __subcommand__ or __group__ defined")


            dict['__parser__'] = b.__subparsers__.add_parser(dict['__subcommand__'],
                                                             help=dict.get('__doc__'))

            is_subcommand = True

    parser = dict['__parser__']

    register_iter(dict.iteritems(), parser, expected_args)

    # Go through all the base classes that aren't command and find attrs in
    # them.  These are mixins or group
    for b in bases:
        if '__subparsers__' not in b.__dict__ and '__group__' not in b.__dict__:
            attr_iter = ((n,getattr(b, n)) for n in dir(b)) 
            register_iter(attr_iter, parser, expected_args)


    return is_subcommand

class Ordered(object):
    _object_counter = 0
    def __init__(self):
        self.ordinal = self._object_counter
        Ordered._object_counter += 1

class MetaBase(abc.ABCMeta):
    def __new__(mcs, name, bases, dict):
        is_sub = False
        if name is not 'Command':
            is_sub = _inject_vals(name, bases, dict)

        cls = abc.ABCMeta.__new__(mcs, name, bases, dict)
        
        if name is not 'Command':
            def run_command(args):
                instance = cls(args)
                return instance()

            cls.__parser__.set_defaults(command=run_command)

        return cls


class Command(Ordered):
    __metaclass__ = MetaBase

    def __call__(self):
        raise NotImplementedError("Must override __call__ in " + self.__class__.__name__)

    def __init__(self, args):
        self.__args__ = args
        for arg_name, var_name in self.__expectedargs__.iteritems():
            setattr(self, var_name, getattr(args, arg_name))

    @classmethod
    def main(cls, *args):
        args = cls.__parser__.parse_args(*args)
        args.command(args)

class Arg(Ordered):
    def __init__(self, *args, **kwargs):
        """`args` and `kwargs` are passed on to :meth:`parser.add_argument`
        when parser is generated

        Unlike add_argument, you may omit explicit naming since the name can be
        inferred from the attribute. ex::

            foo_bar = Arg() # turns into positional add_argument('foo_bar')
            foo_bar = Arg('--foo') # gets left alone

            foo_bar = Arg('-f') # gets a long name inferred replacing the '_' with '-''s
                                # becomes add_argument('-f', '--foo-bar')

            foo_bar = Arg('abc') # gets left alone
        """
        Ordered.__init__(self)

        self.args = args;
        self.kwargs = kwargs

__all__ = ['Command', 'Arg']

