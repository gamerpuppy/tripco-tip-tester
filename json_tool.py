import json
import sys
import urllib
import urllib.request

URL = sys.argv[1]
ENDPOINT = sys.argv[2]

req = None
if ENDPOINT == "/api/config":
    req = urllib.request.Request(url=URL+ENDPOINT, method="GET")
else:
    req = urllib.request.Request(url=URL+ENDPOINT, data=sys.stdin.buffer.read(), method="POST")
    req.add_header('Content-Type', 'application/json')

try:
    resp =  urllib.request.urlopen(req)
    parsed = json.loads(resp.read().decode('utf8'))
    print(json.dumps(parsed, indent=4, sort_keys=True))

except urllib.error.HTTPError as err:
    print(err.code)
