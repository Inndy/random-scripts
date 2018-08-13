#!/usr/bin/env python3
"""
log:
    255.255.255.255 - - [20/Feb/2015:16:03:26 +0800] "POST /wp-login.php HTTP/1.1" 200 4081 "-" "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.14) Gecko/20110201 Firefox/2.0.0.14"
    
example:
    log-cat.py "{0:32}{5:6}{8}" access.log

output:
    255.255.255.255                 200   Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.14) Gecko/20110201 Firefox/2.0.0.14
"""

import sys

def parse_line(l):
    '''
    parse one line of log

        - assume there is 2 arguments at least
        - "String with double quotes", [ String within brackets ], just-string
    '''
    res = []

    i = 0
    length = len(l)

    while i < length:
        if l[i] == '"': # " String with double quotes "
            p = l.find('"', i + 1)
            if p == -1: return None
            res.append(l[i+1 : p])
            i = p + 2
        elif l[i] == '[': # [ String within brackets ]
            p = l.find(']', i + 1)
            if p == -1: return None
            res.append(l[i+1:p])
            i = p + 2
        else: # Just-String-W/O-Spaces
            p = l.find(' ', i + 1)
            if p == -1:
                res.append(l[i:])
                break
            else:
                res.append(l[i:p])
            i = p + 1

    return res

def format_line(f, l):
    return l if not f else f.format(*parse_line(l))

def main(argv):
    if len(argv) == 1:
        print('Usage: %s "{0} {1} just format!" [files] ...' % argv[0],
              file = sys.stderr)
        return 1
    elif len(argv) == 2:
        files = [ sys.stdin ]
    else:
        files = [ open(f) for f in argv[2:] ]

    fmt = argv[1]

    for f in files:
        for l in f.readlines():
            print(format_line(fmt, l.strip()))

if __name__ == '__main__':
    ret = main(sys.argv)
    if ret != None and ret != 0: # non-zero exit code
        exit(ret)
