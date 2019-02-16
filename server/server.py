import argparse

from flask import Flask
from adcount import count_ads

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


if __name__ == "__main__":
    args = get_args()
    if args.prod:
        app.run(host='0.0.0.0', port=80)
    else:
        app.run(host='0.0.0.0', debug=True)
