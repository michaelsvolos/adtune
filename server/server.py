import argparse
import atexit
import os
import subprocess
import time

from adcount import count_ads, get_urls_to_check
from apscheduler.scheduler import Scheduler  # TODO fix import
from flask import Flask, request, send_file

WAV_DIR = 'wavs'
app = Flask(__name__)
cron = Scheduler(daemon=True)
# Explicitly kick off the background thread
cron.start()


@cron.interval_schedule(minutes=10)
def cleanup_wavs():
    """Delete wavs older than 5 minutes."""
    files = os.listdir(WAV_DIR)
    for filename in files:
        timestamp = int(filename.split('.')[0])
        if time.time() - timestamp > 60 * 5:
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
        urls_to_check = get_urls_to_check(content['url'])
    count = count_ads(urls_to_check)
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
    content = request.get_json(silent=True)
    if 'urls' in content:
        count = count_ads(content['urls'])
    else:
        count = content['count']

    filename = os.path.join(WAV_DIR, str(time.time()) + '.wav')
    subprocess.call(['chuck', 'chuck/test:'+filename, '--silent'])
    return send_file(filename, mimetype='audio/wav', as_attachment=True)


# Shutdown your cron thread if the web process is stopped
atexit.register(lambda: cron.shutdown(wait=False))


if __name__ == "__main__":
    args = get_args()
    if args.prod:
        app.run(host='0.0.0.0')
    else:
        app.run(host='0.0.0.0', debug=True)
