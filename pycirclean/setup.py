#!/usr/bin/python3
# -*- coding: utf-8 -*-
from setuptools import setup

setup(
    name='pdfid_clone',
    version='0.2.4',
    author=['Didier Stevens'],
    maintainer_email='code@seamustuohy.com',
    url='https://github.com/seamustuohy/pdfid_clone',
    description='This tool is not a PDF parser, but it will scan a file to look for certain PDF keywords, allowing you to identify PDF documents that contain (for example) JavaScript or execute an action when opened. PDFiD will also handle name obfuscation..',
    packages=['pdfid'],
    dependency_links=[
        'https://github.com/seamustuohy/pdfid_clone.git',
        'git+https://github.com/grierforensics/officedissector.git'
    ],
    install_requires=[
        'lxml',
        'exifread',
        'pillow',
        'olefile',
        'oletools'
        ]
)
