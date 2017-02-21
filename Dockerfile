FROM frolvlad/alpine-glibc

RUN apk add libgcc --no-cache
RUN apk add ncurses5-libs --no-cache
RUN apk add python --no-cache

# Some libraries aren't available in apk - copy them on directly
COPY libraries/libtinfo.so.5 /usr/lib/
COPY libraries/ld-linux-x86-64.so.2 /usr/lib/

COPY sipp/sipp_coreonly /usr/share/clearwater/bin/
COPY clearwater-sip-stress-coreonly.root/usr/share/clearwater/bin/run_stress /usr/share/clearwater/bin/
COPY clearwater-sip-stress-coreonly.root/usr/share/clearwater/sip-stress/*.xml /usr/share/clearwater/sip-stress/

# Just get the help text out for now as a demo
CMD ["/usr/share/clearwater/bin/run_stress", "-h"]
#CMD ["/usr/share/clearwater/bin/sipp_coreonly", "-h"]
