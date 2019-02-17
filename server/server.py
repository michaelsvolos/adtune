import argparse
import atexit
import os
import subprocess
import time

from adcount import count_ads, get_urls_to_check
from apscheduler.scheduler import Scheduler
from flask import Flask, request, send_from_directory, jsonify
from urllib2 import URLError

WAV_DIR = 'wavs'
app = Flask(__name__)
cron = Scheduler(daemon=True)
# Explicitly kick off the background thread
cron.start()


@cron.interval_schedule(hours=1)
def cleanup_wavs():
    """Delete wavs older than 50 minutes."""
    files = os.listdir(WAV_DIR)
    for filename in files:
        timestamp = int(filename.split('.')[0])
        if time.time() - timestamp > 60 * 50:
            os.remove(os.path.join(WAV_DIR, filename))


def get_args():
    '''Get args'''
    parser = argparse.ArgumentParser()
    parser.add_argument('--prod', action='store_true')
    return parser.parse_args()


@app.route("/")
def home():
    """Hello world."""
    return "Hello, World!"


@app.route("/count_ads/", methods=['POST'])
def count_ads_route():
    """Server route for returning number of ads on page.

    Payload: {
        'urls': [string]  a list of urls on a webpage
        OR
        'url': string   a url to check number of ads on
    }
    """
    content = request.get_json(silent=True)
    if 'urls' in content:
        urls_to_check = content['urls']
    else:
        try:
            urls_to_check = get_urls_to_check(content['url'])
            count = count_ads(urls_to_check)
        except URLError:
            count = 1000000
    return str(count)


@app.route("/create_music/", methods=['POST'])
def create_music():
    """Create subprocess to render chuck mp3 and serve it
    Payload: {
        'urls': [string]  a list of urls on a webpage
        OR
        'count': int  number of ads on page
    }
    """
    print request.data
    content = request.get_json(silent=True)
    if 'url' in content:
        try:
            urls_to_check = get_urls_to_check(content['url'])
            count = count_ads(urls_to_check)
        except URLError:
            count = 1000000
    elif 'urls' in content:
        count = count_ads(content['urls'])
    else:
        count = content['count']
    filename = str(time.time()) + '.wav'
    subprocess.call([
        'chuck',
        'chuck/tune_gen:' + os.path.join(WAV_DIR, filename) + ':' + str(count),
        '--silent'
    ])
    if count == 1000000:
        count = 14
    return jsonify(filename=filename, count=count)
    # return send_file(filename, mimetype='audio/wav', as_attachment=True)


@app.route('/wavs/<path:path>')
def send_wav(path):
    return send_from_directory(WAV_DIR, path)


# Shutdown your cron thread if the web process is stopped
atexit.register(lambda: cron.shutdown(wait=False))

if __name__ == "__main__":
    args = get_args()
    if args.prod:
        app.run(host='0.0.0.0')
    else:
        app.run(host='0.0.0.0', debug=True)
