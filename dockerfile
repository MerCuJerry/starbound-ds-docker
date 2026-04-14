FROM cm2network/steamcmd:latest

USER root

ENV STEAM_ACCOUNT account
ENV STEAM_PASSWORD password
ENV MOD_IDS ()
ENV UID 1000
ENV GID 1000

RUN mkdir -p /starbound

RUN chown -R $UID:$GID /starbound \
    && chown -R $UID:$GID /home/steam/steamcmd

VOLUME ["/starbound"]

USER %UID%:%GID%

ADD install.sh /starbound/install.sh
RUN chmod u+x /starbound/install.sh
RUN touch /starbound/installmods.txt

ENTRYPOINT ["starbound/install.sh"]
