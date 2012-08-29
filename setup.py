from setuptools import setup, find_packages
import sys, os

version = '1.0'

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(
    name='ponyd',
    version=version,
    description="A remote debugging tool for native applications.",
    long_description=read('README_ponyd.rst'),
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: Apache Software License',
        'Natural Language :: English',
        'Operating System :: MacOS',
        'Programming Language :: Python :: 2.7',
    ],
    keywords='ponydebugger ponyd remote debugger',
    author='Square, Inc.',
    author_email='eng@squareup.com',
    url='https://github.com/square/PonyDebugger',
    license='Apache Licence 2.0',
    install_requires=['tornado'],
    packages=['ponyd'],
    include_package_data=True,
    zip_safe=False,
    entry_points = {
        'console_scripts': [
            'ponyd = ponyd.command:PonydCommand.main',
        ]
    }
)
