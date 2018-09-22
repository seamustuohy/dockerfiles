#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright © 2018 seamus tuohy, <code@seamustuohy.com>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the included LICENSE file for details.

import argparse
from cyobstract import extract
import requests
from bs4 import BeautifulSoup

import logging
logging.basicConfig(level=logging.ERROR)
log = logging.getLogger(__name__)


def main():
    args = parse_arguments()
    set_logging(args.verbose, args.debug)
    for url in args.URLS:
        get_urls(url, args.ignore_missing)


def get_urls(URL, ignore_missing=False):
    log.debug("Fetching URL: {0}".format(URL))
    r = requests.get(URL)
    soup = BeautifulSoup(r.text, 'html.parser')
    # remove all scripts
    not_content = ['script', 'head',
                   'header', 'footer',
                   'style', 'comment',
                   'foot', 'meta']
    for tag in not_content:
        [s.extract() for s in soup(tag)]
    text = soup.text
    results = extract.extract_observables(text)
    # print(results)
    for indicator_type,indicators in results.items():
        if ignore_missing is True:
            if len(indicators) != 0:
                print_indicator(indicator_type,indicators)
        else:
            print_indicator(indicator_type,indicators)

def print_indicator(indicator_type,indicators):
    print("\n\n=== {0} ===".format(indicator_type))
    for i in indicators:
        print(i)


# Command Line Functions below this point

def set_logging(verbose=False, debug=False):
    if debug == True:
        log.setLevel("DEBUG")
    elif verbose == True:
        log.setLevel("INFO")

def parse_arguments():
    parser = argparse.ArgumentParser("Print indicators from a URL.")
    parser.add_argument("--verbose", "-v",
                        help="Turn verbosity on",
                        action='store_true')
    parser.add_argument("--debug", "-d",
                        help="Turn debugging on",
                        action='store_true')
    parser.add_argument("--ignore_missing", "-i",
                        help="Don't show missing indicators sections",
                        action='store_true',
                        default=False)
    parser.add_argument('URLS', nargs='*')
    args = parser.parse_args()
    return args

if __name__ == '__main__':
    main()
