#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright © 2021 seamus tuohy, <code@seamustuohy.com>
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

import logging
logging.basicConfig(level=logging.ERROR)
log = logging.getLogger(__name__)

from polyglot.text import Text
import feedparser
import six
from google.cloud import translate_v2 as translate
import sqlite3
import datetime
import uuid
import time

def main():
    args = parse_arguments()
    set_logging(args.verbose, args.debug)
    # store datetime.datetime objects not in ISO representation, but as a Unix timestamp.
    sqlite3.register_adapter(datetime.datetime, adapt_datetime)
    if args.rss_feed is not None:
        raw_rss = args.rss_feed
        feed = feedparser.parse(args.rss_feed)
    else:
        with open(args.rss_path, 'r') as fp:
            raw_rss = fp.read()
            feed = feedparser.parse(raw_rss)
    if args.create_database is True:
        create_database(args.database)
    conn = sqlite3.connect(args.database)
    for entry in feed.get('entries', []):
        try:
            _title = entry.get("title", None)
            _text = Text(_title)
            _lang = _text.detect_language()
            if _lang != 'en':
                _translated = translate_str(_title, conn)
                raw_rss = raw_rss.replace(_title, _translated)
                update_site_logs(_title, entry.get('link'), conn)
        except TypeError:
            # If there is no title this errors out
            continue
    print(raw_rss)

def update_site_logs(text, url, conn):
    c = conn.cursor()
    now = datetime.datetime.now()
    vals = (url, text, now)
    c.execute('INSERT INTO site_trans VALUES (?,?,?)', vals)
    conn.commit()
    c.close()

def translate_str(string, conn):
    existing_translation = get_already_translated(string, conn)
    if existing_translation is not None:
        return existing_translation[3]
    else:
        translated = translate_text_with_google('en', string, conn)
        save_translation(string,
                         translated["source_lang"],
                         translated["translation"],
                         conn)
        return translated["translation"]

def adapt_datetime(ts):
    return time.mktime(ts.timetuple())

def translate_text_with_google(target, text, conn):
    """Translates text into the target language.

    Target must be an ISO 639-1 language code.
    See https://g.co/cloud/translate/v2/translate-reference#supported_languages
    """
    translate_client = translate.Client()
    if isinstance(text, six.binary_type):
        text = text.decode("utf-8")
    # Text can also be a sequence of strings, in which case this method
    # will return a sequence of results for each text.
    log_google_trans_request(text, conn)
    result = translate_client.translate(text, target_language=target)
    return {'translation':result["translatedText"],
            'original':result["input"],
            'source_lang':result["detectedSourceLanguage"]}

def log_google_trans_request(text, conn):
    """Record that we made a request to google translate"""
    c = conn.cursor()
    now = datetime.datetime.now()
    vals = (text, now)
    c.execute('INSERT INTO google_trans VALUES (?,?)', vals)
    conn.commit()
    c.close()

def get_already_translated(string, conn):
    """Get existing translation, if it exists, and update # times seen value.

    Increases seen_count by one every time it is run.
    """
    c = conn.cursor()
    original = (string,)
    c.execute('SELECT * FROM translations WHERE original=?', original)
    item = c.fetchone()
    if item is not None:
        updated_seen = item[-1] + 1
        sql_update_query = """Update translations set seen_count = ?  where uuid = ?"""
        c.execute(sql_update_query, (updated_seen, item[0]))
        conn.commit()
    c.close()
    return item

def create_database(dbpath):
    conn = sqlite3.connect(dbpath)
    c = conn.cursor()
    c.execute('''CREATE TABLE translations (UUID text PRIMARY KEY, original text, lang text, translated text, first_seen text, seen_count int)''')
    c.execute('''CREATE TABLE google_trans (to_translate text, date text)''')
    c.execute('''CREATE TABLE site_trans (url text, to_translate text, date text)''')
    conn.commit()
    c.close()

def get_new_uuid(cursor):
    found_unique = False
    while found_unique is not True:
        ID = str(uuid.uuid4()).replace('-','')
        cursor.execute("SELECT * FROM translations WHERE UUID = ?", (ID,))
        if cursor.fetchone() is None:
            found_unique = True
            return ID

def save_translation(original, lang, translated, conn):
    now = datetime.datetime.now()
    c = conn.cursor()
    uuid = get_new_uuid(c)
    now = datetime.datetime.now()
    vals = (uuid, original, lang, translated, now, 1)
    c.execute('INSERT INTO translations VALUES (?,?,?,?,?,?)', vals)
    conn.commit()
    c.close()

# Command Line Functions below this point

def set_logging(verbose=False, debug=False):
    if debug == True:
        log.setLevel("DEBUG")
    elif verbose == True:
        log.setLevel("INFO")

def parse_arguments():
    parser = argparse.ArgumentParser("rss translate")
    parser.add_argument("--verbose", "-v",
                        help="Turn verbosity on",
                        action='store_true')
    parser.add_argument("--debug", "-d",
                        help="Turn debugging on",
                        action='store_true')
    parser.add_argument("--rss_path", "-rp",
                        help="path to an rss feed",
                        default="/var/RSS/feed.rss")
    parser.add_argument("--rss_feed", "-f",
                        help="data from an rss feed")
    parser.add_argument("--database", "-dp",
                        help="path to database",
                        default='/DB/translation.db')
    parser.add_argument("--create_database", "-c",
                        help="create a database from scratch",
                        action='store_true')

    args = parser.parse_args()
    return args

if __name__ == '__main__':
    main()
