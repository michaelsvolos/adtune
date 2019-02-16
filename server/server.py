import argparse
import subprocess

from adcount import count_ads
from flask import Flask

app = Flask(__name__)


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--prod', action='store_true')
    return parser.parse_args()


@app.route("/")
def home():
    """Hello world."""
    return "Hello, World!"


@app.route("/count_ads/")  # TODO add args
def count_ads_route():
    """Server route for returning number of ads on page."""
    urls_to_check = None  # TODO get this value
    count = count_ads(urls_to_check)
    return None  # TODO set return payload


@app.rote("/create_music/")  # TODO add args
def create_music():
    """Create subprocess to render chuck mp3 and serve it"""
    subprocess.call(["ls", "-l"])  # TODO configure command
    return None  # TODO return generated file


if __name__ == "__main__":
    args = get_args()
    if args.prod:
        app.run(host='0.0.0.0')
    else:
        app.run(host='0.0.0.0', debug=True)
