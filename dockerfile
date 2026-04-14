FROM cm2network/steamcmd:root-trixie

ENV STEAM_ACCOUNT account
ENV STEAM_PASSWORD password
ENV MOD_IDS ()
ENV STEAMAPPDIR "${HOMEDIR}/starbound"

ADD install.sh $HOMEDIR/install.sh
RUN mkdir -p $STEAMAPPDIR

USER root
RUN chown -R $PUID:$PUID $STEAMAPPDIR && chown -R $PUID:$PUID $STEAMCMDDIR && chown $PUID:$PUID $HOMEDIR/install.sh

USER $PUID:$PUID
RUN chmod u+x $HOMEDIR/install.sh
RUN touch $HOMEDIR/installmods.txt

WORKDIR ${HOMEDIR}
VOLUME ${STEAMAPPDIR}
CMD ["bash", "install.sh"]
