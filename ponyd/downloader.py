import argparse
import json
import os
import shutil
import urllib2
import zipfile

from cStringIO import StringIO

from ponyd.constants import DEFAULT_DEVTOOLS_PATH
from ponyd.command import PonydCommand
from ponyd.argbase import Arg

LATEST_URL =  "http://storage.googleapis.com/chromium-browser-continuous/Mac/LAST_CHANGE"
TOOLS_URL_TEMPLATE = "http://storage.googleapis.com/chromium-browser-continuous/Mac/%s/devtools_frontend.zip"

class Downloader(PonydCommand):
    __subcommand__  = 'update-devtools'

    dirname = Arg(nargs='?',
                  help='path to download and extract devtools',
                  default=DEFAULT_DEVTOOLS_PATH)
    force = Arg('-f', '--force',
                help='if dirname already exists, then replace directory',
                action='store_true')
    latest = Arg('-l', '--latest',
                 help='install the lastest dev tools instead of a known good version',
                 action='store_true')

    def __call__(self):
        if os.path.exists(self.dirname):
            if self.force:
                print "Removing directory", os.path.abspath(self.dirname)
                shutil.rmtree(self.dirname)
            else:
                print "Directory %s exists. Run with --force (-f) to overwrite the directory." % self.dirname
                return
        
        if self.latest:
            version = urllib2.urlopen(LATEST_URL).read()
        else:
            version = 152100

        tools_url = TOOLS_URL_TEMPLATE % version 
        print "Downloading %s" % tools_url

        tools_stream = StringIO(urllib2.urlopen(tools_url).read())

        extract_dir = self.dirname
        print "Extracting to %s" % extract_dir

        tools_zip = zipfile.ZipFile(tools_stream, 'r')
        tools_zip.extractall(path=extract_dir)

