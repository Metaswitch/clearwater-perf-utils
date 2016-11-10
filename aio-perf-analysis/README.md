# Clearwater Performance Utilities

This repository contains some tools to test and check for Clearwater performance regressions on an all-in-one node.

## Instructions

1. Set up an all-in-one node at the "baseline" software level you want to compare the performance against.
1. Provision users for perf testing by running ./provision.sh
1. Install clearwater-sip-perf, sprout-dbg, chronos-dbg and homestead-dbg
1. Install linux-image-4.4.0-36-generic and linux-tools-4.4.0-36-generic (changing GRUB's menu.lst if prompted) and reboot
1. Log back in and wait for the system to come up.
1. Run perfrun.sh repeatedly, to collect samples from multiple performance tests. `for i in {1..10}; do sudo ./perfrun.sh; done`, for example.
1. You'll now have a lot of `perf_<timestamp>` directories. Copy these off - they form your baseline.
1. Upgrade to the new software level you want to check the performance of.
1. Run perfrun.sh repeatedly, to collect samples from multiple performance tests. `for i in {1..10}; do sudo ./perfrun.sh; done`, for example.
1. You'll now have a lot of `perf_<timestamp>` directories. Copy these off into a separate directory - they form your new set of data.
1. You can now use the analysis scripts to compare your two runs:

```
python analysis.py --baseline /path/to/baseline/data/ --new /path/to/new/data/
python stack_analysis.py --baseline /path/to/baseline/data/ --new /path/to/new/data/ --component sprout
python stack_analysis.py --baseline /path/to/baseline/data/ --new /path/to/new/data/ --component homestead
python stack_analysis.py --baseline /path/to/baseline/data/ --new /path/to/new/data/ --component chronos
```
