FROM cm2network/steamcmd:latest

USER root

ENV STEAM_ACCOUNT account
ENV STEAM_PASSWORD password
ENV MOD_IDS ()
ENV UID 1000
ENV GID 1000

RUN groupadd -g $GID starbound \
    && useradd -u $UID starbound -g starbound

RUN mkdir -p /starbound

RUN chown -R starbound:starbound /starbound \
    && chown -R starbound:starbound /home/steam/steamcmd

VOLUME ["/starbound"]

USER starbound:starbound

ADD install.sh /starbound/install.sh
RUN chmod u+x /starbound/install.sh
RUN touch /starbound/installmods.txt

ENTRYPOINT ["starbound/install.sh"]
