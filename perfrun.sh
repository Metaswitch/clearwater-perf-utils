#!/bin/bash

# This is a helper script for Clearwater performance investigations on an
# all-in-one node - it runs clearwater-sip-perf while capturing overall CPU%,
# per-pid CPU% and output from the 'perf' sampling profiler.

set -x

DIRECTORY=perf_`date +%s`
SIP_ADDR=`hostname -I`

# Restart all the services - this means that, for example, we won't get stale
# timers popping and causing different CPU usage.
service sprout restart
service homestead restart
service chronos restart
service bono restart

# Wait for services to come back up.
sleep 60

mkdir $DIRECTORY

# Start capturing data from the run in the background. sip-perf usually runs
# for about 14 minutes 30 seconds, and 840 seconds = 14 minutes.
pidstat -h 840 1 > $DIRECTORY/pidstat.out &
sar 840 1 > $DIRECTORY/sar.out &
perf record -o $DIRECTORY/sprout.perf.data -F 997 --call-graph dwarf -p `pidof sprout` -- sleep 840 &
perf record -o $DIRECTORY/homestead.perf.data -F 997 --call-graph dwarf -p `pidof homestead` -- sleep 840 &
perf record -o $DIRECTORY/chronos.perf.data -F 997 --call-graph dwarf -p `pidof chronos` -- sleep 840 &

# Kick off sip-perf - we don't end this line with & so the script now blocks
# until this finishes.
/usr/share/clearwater/bin/sip-perf $SIP_ADDR

# Print out the success/failure stats so you can easily spot if this run is
# invalid.
egrep "Failed call|Successful call" /var/log/clearwater-sipp/sip-perf.out 

# Copy off the SIPp output;
mv /var/log/clearwater-sipp/sip-perf.out $DIRECTORY
mv /var/log/clearwater-sipp/*errors.log $DIRECTORY

# Run perf report to create machine-parseable text files which say which
# functions were called most - the perf.data files are only usable on a system
# that has the original binary and debug symbols.
perf report --stdio -U -t \| -g fractal,0.5,10,callee,function -i $DIRECTORY/sprout.perf.data > $DIRECTORY/sprout.perf.report && rm $DIRECTORY/sprout.perf.data
perf report --stdio -U -t \| -g fractal,0.5,10,callee,function -i $DIRECTORY/homestead.perf.data > $DIRECTORY/homestead.perf.report && rm $DIRECTORY/homestead.perf.data
perf report --stdio -U -t \| -g fractal,0.5,10,callee,function -i $DIRECTORY/chronos.perf.data > $DIRECTORY/chronos.perf.report && rm $DIRECTORY/chronos.perf.data

# Compress these perf reports.
gzip $DIRECTORY/sprout.perf.report
gzip $DIRECTORY/homestead.perf.report
gzip $DIRECTORY/chronos.perf.report

