from cStringIO import StringIO
from contextlib import contextmanager
import os
import shutil
import tempfile
import urllib2
import zipfile
from ponyd.argbase import Arg
from ponyd.command import PonydCommand
from ponyd.constants import DEFAULT_DEVTOOLS_PATH


@contextmanager
def tempdir():
    """Makes a temp directory then deletes it when leaving the context"""
    dir = tempfile.mkdtemp()
    try:
        yield dir
    finally:
        shutil.rmtree(dir)


LATEST_URL = "https://www.googleapis.com/download/storage/v1/b/chromium-browser-continuous/o/Linux_x64%2FLAST_CHANGE?alt=media"
TOOLS_URL_TEMPLATE = "https://www.googleapis.com/download/storage/v1/b/chromium-browser-continuous/o/Linux_x64%2F{}%2Fchrome-linux.zip?alt=media"

INSPECTOR_PATH_PREFIX = 'chrome-linux/resources/inspector'


class Downloader(PonydCommand):
    __subcommand__ = 'update-devtools'

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
            version = 338332

        tools_url = TOOLS_URL_TEMPLATE.format(version)
        print "Downloading %s" % tools_url

        tools_stream = StringIO(urllib2.urlopen(tools_url).read())

        if os.path.exists(self.dirname):
            print "Removing existing devtools installation at %s" % self.dirname
            shutil.rmtree(self.dirname)

        extract_dir = self.dirname
        print "Extracting to %s" % extract_dir

        tools_zip = zipfile.ZipFile(tools_stream, 'r')

        names_to_extract = [n for n in tools_zip.namelist() if n.startswith(INSPECTOR_PATH_PREFIX)]

        with tempdir() as d:
            tools_zip.extractall(path=d, members=names_to_extract)
            os.rename(os.path.join(d, INSPECTOR_PATH_PREFIX), extract_dir)
