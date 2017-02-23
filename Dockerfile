FROM frolvlad/alpine-glibc

RUN apk add python --no-cache

COPY sipp/sipp_coreonly /usr/share/clearwater/bin/
COPY clearwater-sip-stress-coreonly.root/usr/share/clearwater/bin/run_stress /usr/share/clearwater/bin/
COPY clearwater-sip-stress-coreonly.root/usr/share/clearwater/sip-stress/*.xml /usr/share/clearwater/sip-stress/

ENTRYPOINT ["/usr/share/clearwater/bin/run_stress"]
