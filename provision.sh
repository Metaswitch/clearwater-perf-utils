#!/bin/bash

# This script provisions 5,000 users onto an all-in-one node for
# clearwater-sip-perf testing.

set -x

. /etc/clearwater/config
for DN in {2010000000..2010004999}
do
  echo sip:$DN@$home_domain,$DN@$home_domain,$home_domain,7kkzTyGW
done > users.csv

/usr/share/clearwater/crest/src/metaswitch/crest/tools/bulk_create.py users.csv
./users.create_homestead.sh > /dev/null
./users.create_xdm.sh > /dev/null
