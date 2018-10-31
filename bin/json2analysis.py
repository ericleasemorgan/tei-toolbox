#!/usr/bin/python

JSON = '/Users/eric/desktop/longfellow-hiawatha-1855/longfellow-hiawatha-hvd.hn3hik-1474843664.json'

import json
from pprint import pprint

with open( JSON ) as json_data:
    d = json.load( json_data )
    pprint( d )
    
exit()
