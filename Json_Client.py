import json,urllib2, base64
values =  {"jsonrpc" : "2.0","method":"cli","params":["show vlan"],"id":"1"}
data = json.dumps(values)
print data
request = urllib2.Request("http://<ip_addr>/jsonrpc", data, {'Content-Type': 'application/json'})
basestr = base64.encodestring('%s:%s' % ("admin", "")).replace('\n',' ')
request.add_header("Authorization", "Basic %s" % basestr)
#data = urllib.urlencode(values)
try:
    result = urllib2.urlopen(request)
    print(result.read())
except urllib2.HTTPError, e:
    print e
except urllib2.URLError, e:
    print e.args
