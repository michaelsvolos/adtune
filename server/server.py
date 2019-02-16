from flask import Flask
from adcount import count_ads

app = Flask(__name__)


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
    app.run(host= '0.0.0.0', debug=True)
