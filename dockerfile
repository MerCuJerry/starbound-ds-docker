FROM cm2network/steamcmd:latest

USER root

ENV STEAM_ACCOUNT account
ENV STEAM_PASSWORD password
ENV MOD_IDS ()
ENV UID 1000
ENV GID 1000

# install dependencies
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove -y
RUN apt install software-properties-common lib32gcc-s1 libvorbisfile3 wget libstdc++6 -y

RUN groupadd -g $GID starbound \
    && useradd -u $UID starbound -g starbound

RUN mkdir -p /starbound

RUN chown -R starbound:starbound /starbound \
    && chown -R starbound:starbound /home/steam/steamcmd

VOLUME ["/starbound"]

USER starbound:starbound

RUN touch /starbound/installmods.txt

ENTRYPOINT ["starbound/install.sh"]
