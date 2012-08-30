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
                  help='path to download and extract devtools (default: %s)' % DEFAULT_DEVTOOLS_PATH,
                  default=DEFAULT_DEVTOOLS_PATH)
    latest = Arg('-l', '--latest',
                 help='install the lastest dev tools instead of a known good version',
                 action='store_true')

    def __call__(self):
        if self.latest:
            version = urllib2.urlopen(LATEST_URL).read()
        else:
            version = 152100

        tools_url = TOOLS_URL_TEMPLATE % version 
        print "Downloading %s" % tools_url

        tools_stream = StringIO(urllib2.urlopen(tools_url).read())


        if os.path.exists(self.dirname):
            print "Removing existing devtools installation at %s" % self.dirname
            shutil.rmtree(self.dirname)

        extract_dir = self.dirname
        print "Extracting to %s" % extract_dir

        tools_zip = zipfile.ZipFile(tools_stream, 'r')
        tools_zip.extractall(path=extract_dir)


