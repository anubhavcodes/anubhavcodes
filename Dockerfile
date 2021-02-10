FROM debian:latest

WORKDIR /srv

RUN apt-get -qq  update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends libstdc++6 python-pygments git ca-certificates asciidoc curl \
	&& rm -rf /var/lib/apt/lists/*

ENV HUGO_VERSION 0.64.1
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.deb

RUN curl -sL -o /tmp/hugo.deb \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
    dpkg -i /tmp/hugo.deb && \
    rm /tmp/hugo.deb

COPY . .

RUN hugo -D

EXPOSE 1313

ENV HUGO_BASE_URL http://localhost:1313

CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0

FROM nginx

EXPOSE 80

COPY public/ /usr/share/nginx/html

COPY conf/nginx/site.conf /etc/nginx/sites-enabled/default
