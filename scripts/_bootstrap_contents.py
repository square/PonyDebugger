import os
import subprocess
import sys 

def extend_parser(optparse_parser):
    optparse_parser.add_option('--ponyd-symlink', metavar='PONYD_SYMLINK_PATH', help='Optional location to symlink ponyd to. /usr/local/bin/ponyd is recommended')

def after_install(options, home_dir):
    subprocess.check_call([join(home_dir, 'bin', 'pip'),
                     'install', '-U', '-e', 'git+https://github.com/square/PonyDebugger.git#egg=ponydebugger'])

    ponyd_path = join(home_dir, 'bin', 'ponyd')

    if options.ponyd_symlink:
        try:
            print "Symlinking %s to %s" % (ponyd_path, options.ponyd_symlink)
            os.symlink(, options.ponyd_symlink)
        except:
            print >>sys.stderr, "Error creating symlink" 


    subprocess.check_call(ponyd_path, 'update-devtools')
