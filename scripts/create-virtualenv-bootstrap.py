#!/usr/bin/python
import virtualenv
output = virtualenv.create_bootstrap_script(open('_bootstrap_contents.py').read())
f = open('bootstrap-ponyd.py', 'w').write(output)
