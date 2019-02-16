'''This file contains code for matching urls to a list of domains
known to host ads as provided by https://easylist.to/
'''
DOMAINS_FILE = 'easylist.txt'
with open(DOMAINS_FILE) as f:
    domains = f.read().split('\n')


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
            if d in u:  # check if domain is substring of url
                count += 1
    return count
