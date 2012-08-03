
import os
import shutil
import argparse
import zipfile
import json
import urllib2
from cStringIO import StringIO
from ponygateway.constants import DEFAULT_DEVTOOLS_PATH

LATEST_URL =  "http://storage.googleapis.com/chromium-browser-continuous/Mac/LAST_CHANGE"
TOOLS_URL_TEMPLATE = "http://storage.googleapis.com/chromium-browser-continuous/Mac/%s/devtools_frontend.zip"

args = None

def parse_args():
    global args

    parser = argparse.ArgumentParser(description='Chrome Developer Tools Downloader for PonyDebugger')
    parser.add_argument('dirname', nargs='?', help='path to download and extract devtools', default=DEFAULT_DEVTOOLS_PATH)
    parser.add_argument('-f', '--force', help='if dirname already exists, then replace directory', action='store_true')
    parser.add_argument('-l', '--latest', help='install the lastest dev tools instead of a known good version', action='store_true')

    args = parser.parse_args()

def main():
    parse_args()

    if os.path.exists(args.dirname):
        if args.force:
            print "Removing directory", os.path.abspath(args.dirname)
            shutil.rmtree(args.dirname)
        else:
            print "Directory %s exists. Run with --force (-f) to overwrite the directory." % args.dirname
            return
    
    if args.latest:
        version = urllib2.urlopen(LATEST_URL).read()
    else:
        version = 152100

    tools_url = TOOLS_URL_TEMPLATE % version 
    print "Downloading %s" % tools_url

    tools_stream = StringIO(urllib2.urlopen(tools_url).read())

    extract_dir = args.dirname
    print "Extracting to %s" % extract_dir

    tools_zip = zipfile.ZipFile(tools_stream, 'r')
    tools_zip.extractall(path=extract_dir)

