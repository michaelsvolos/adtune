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
For local:
```
python server.py
```

For remote dev:
```
python server.py --prod
```

For prodduction:
```
sh start.sh
```

## Flask
https://medium.freecodecamp.org/how-to-build-a-web-application-using-flask-and-deploy-it-to-the-cloud-3551c985e492

## TODO
-   [x] create count server route
-   [x] get the urls to compare
-   [x] create mp3 server route
-   [x] call chuck generate
-   [ ] fun music
-   [ ] send filename? https://stackoverflow.com/questions/41543951/how-to-change-downloading-name-in-flask
-   [ ] get static ip
-   [ ] handle shit like reddit
-   [x] mp3 management
-   [x] gunicorn
