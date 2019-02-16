# Adtune server

This repo holds code for a `flask` server that:

1.  counts number of ads on a webpage
2.  serves an mp3 to the client

# Setup
1.  create and activate `virtualenv`
```
virtualenv .env -p python2.7
source .env/bin/activate
```
2.  install requirements
```
pip install -r requirements.txt
```

# Running
```
python server.py
```

## Flask
https://medium.freecodecamp.org/how-to-build-a-web-application-using-flask-and-deploy-it-to-the-cloud-3551c985e492

## TODO
-   [ ] create count server route
-   [ ] get the urls to compare
-   [ ] create mp3 server route
-   [ ] call chuck generate
