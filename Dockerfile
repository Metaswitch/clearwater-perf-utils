FROM frolvlad/alpine-glibc@sha256:88fcccb65e5a5166dde9583b0c2e7b6e418feb46697f80c1430776d431bdb494

RUN apk add python --no-cache

COPY sipp/sipp_static /usr/share/clearwater/bin/sipp_coreonly
COPY clearwater-sip-stress-coreonly.root/usr/share/clearwater/bin/run_stress /usr/share/clearwater/bin/
COPY clearwater-sip-stress-coreonly.root/usr/share/clearwater/sip-stress/*.xml /usr/share/clearwater/sip-stress/
RUN mkdir -p /var/log/clearwater-sip-stress/

ENTRYPOINT ["/usr/share/clearwater/bin/run_stress"]
