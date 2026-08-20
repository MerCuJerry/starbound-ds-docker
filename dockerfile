FROM cm2network/steamcmd:root-trixie

ENV STEAM_ACCOUNT=account
ENV STEAM_PASSWORD=password
ENV MOD_IDS=()
ENV STEAMAPPDIR="${HOMEDIR}/starbound"
ENV SKIP_INSTALL=false
ENV PUID=1000
ENV PGID=1000

ADD install.sh $HOMEDIR/install.sh
RUN mkdir -p $STEAMAPPDIR

RUN chmod +x $HOMEDIR/install.sh
RUN touch $HOMEDIR/installmods.txt

WORKDIR ${HOMEDIR}
VOLUME ${STEAMAPPDIR}
CMD ["bash", "install.sh"]
