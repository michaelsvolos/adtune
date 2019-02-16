curl http://104.40.74.37:5000/count_ads/ -X POST \
  -H "Content-Type: application/json" \
  -d '{"url":"https://youtube.com"}'

curl http://104.40.74.37:5000/count_ads/ -X POST \
  -H "Content-Type: application/json" \
  -d '{"url":"https://www.cnet.com/"}'
