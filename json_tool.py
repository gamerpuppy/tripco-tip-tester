import json
import sys
import urllib
import urllib.request

URL = sys.argv[1]
ENDPOINT = sys.argv[2]

method = "POST"
data = None
if ENDPOINT == "/api/config":
    method = "GET"
else:
    data = sys.stdin.buffer.read()

req = urllib.request.Request(url=URL+ENDPOINT, data=data, method=method)
req.add_header('Content-Type', 'application/json')

try:
    resp =  urllib.request.urlopen(req)
    parsed = json.loads(resp.read())
    print(json.dumps(parsed, indent=4, sort_keys=True))

except urllib.error.HTTPError as err:
    print(err.code)


