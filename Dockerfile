FROM crystallang/crystal:nightly

WORKDIR /crystal-wait-group

COPY ./src/ ./src
COPY ./spec/ ./spec

CMD ["crystal", "spec", "-Dpreview_mt"]
