import os
import subprocess
import sys 

def extend_parser(optparse_parser):
    optparse_parser.add_option('--ponyd-symlink', metavar='PONYD_SYMLINK_PATH', help='Optional location to symlink ponyd to. /usr/local/bin/ponyd is recommended')

def after_install(options, home_dir):
    subprocess.check_call([join(home_dir, 'bin', 'pip'),
                     'install', '-U', '-e', 'git+https://github.com/square/PonyDebugger.git#egg=ponydebugger'])

    ponyd_path = join(home_dir, 'bin', 'ponyd')


    symlink_target = options.ponyd_symlink

    if symlink_target:
        if os.path.isdir(symlink_target):
            symlink_target  = os.path.join(symlink_target, 'ponyd')

        if os.path.exists(symlink_target):
            print "Symlink to %s already exists. (continuing anyways)" % symlink_target
        try:
            print "Symlinking %s to %s" % (ponyd_path, symlink_target)
            os.symlink(ponyd_path, symlink_target)
        except:
            print >>sys.stderr, "Error creating symlink. Manually run: sudo ln -s '%s' '%s'" % (ponyd_path, symlink_target)

    subprocess.check_call([ponyd_path, 'update-devtools'])

    print "Congratulations! ponyd has been installed to %s" % ponyd_path
