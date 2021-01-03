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
import pdftotext
import csv
import os.path
import logging
logging.basicConfig(level=logging.ERROR)
log = logging.getLogger(__name__)


def main():
    args = parse_arguments()
    set_logging(args.verbose, args.debug)    
    for path in args.paths:
        indicators = get_pdf(path, ignore_missing=False)
        if args.output is not False:
            write_indicators(indicators, args.output)
        else:
            print_indicator(results, ignore_missing)
        

def get_pdf(path, ignore_missing=False):
    observables = []
    with open(path, 'rb') as pdf_file:
        pdf = pdftotext.PDF(pdf_file)
        raw_text = "\n\n".join(pdf)
        results = extract.extract_observables(raw_text)
        return results

def write_indicators(results, output_path):
    with open(os.path.abspath(output_path), "w+") as out:
        iwrite = csv.writer(out)
        iwrite.writerow(['type', 'indicator'])
        for indicator_type,indicators in results.items():
            if len(indicators) != 0:
                for i in indicators:
                    iwrite.writerow([indicator_type, i])

def print_indicator(results, ignore_missing=False):
    for indicator_type,indicators in results.items():
        if ignore_missing is True:
            if len(indicators) != 0:
                print("\n\n=== {0} ===".format(indicator_type))
                for i in indicators:
                    print(i)
        else:
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
    parser = argparse.ArgumentParser("Get indicators from a local PDF.")
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
    parser.add_argument("--output", "-o",
                        help="output file path",
                        default=False)
    parser.add_argument('paths', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    return args

if __name__ == '__main__':
    main()

## EXAMPLE
## In a folder full of folders with APT pdf's get all the indicators and write them to a file
# for folder in ~/APT/* ; do
#     for pdf in "${folder}/"*.pdf; do
#         python3 get_indicators_from_pdf.py -o "/home/user/APT/indicators/$(basename ${pdf}).csv" "${pdf}";
#     done
# done
