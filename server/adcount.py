'''This file contains code for matching urls to a list of domains
known to host ads as provided by https://easylist.to/
'''
import re
import urllib2

from BeautifulSoup import BeautifulSoup

DOMAINS_FILE = 'easylist.txt'
with open(DOMAINS_FILE) as f:
    domains = f.read().split('\n')


def get_urls_to_check(url):
    """Given a webpage url, extract urls on it to check for ads"""
    urls = []
    html_page = urllib2.urlopen(url)
    soup = BeautifulSoup(html_page)
    for link in soup.findAll('a', attrs={'href': re.compile("^http://")}):
        urls.append(link.get('href'))
    return urls


def count_ads(urls_to_check):
    """Count number of ad domains in a list of urls

    Args:
        domains ([str]): list of known ad domains.
        urls_to_check ([str]): list of urls to check.

    Returns:
        int: number of urls matched to ad domains

    """
    count = 0
    for u in urls_to_check:
        for d in domains:
            try:
                if d in u:  # check if domain is substring of url
                    count += 1
            except UnicodeDecodeError:
                pass
    return count
