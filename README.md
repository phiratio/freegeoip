```bash
git clone git@github.com:phiratio/freegeoip.git
cd freegeoip
docker build --no-cache -t freegeoip_local -f ./Dockerfile .
docker run --rm -p 127.0.0.1:8079:8080 freegeoip_local

# test it
curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://127.0.0.1:8079/json/69.192.66.35

```
```
HTTP/1.1 200 OK
Content-Type: application/json
Vary: Origin
X-Database-Date: ...
Date: ...
Content-Length: 213

{"ip":"69.192.66.35","country_code":"NL","country_name":"Netherlands","region_code":"","region_name":"","city":"","zip_code":"","time_zone":"Europe/Amsterdam","latitude":52.3824,"longitude":4.8995,"metro_code":0}
```
