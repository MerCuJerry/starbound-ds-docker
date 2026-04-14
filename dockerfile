FROM cm2network/steamcmd:root-trixie

ENV STEAM_ACCOUNT account
ENV STEAM_PASSWORD password
ENV MOD_IDS ()
ENV UID 1000
ENV GID 1000
ENV STEAMAPPDIR "${HOMEDIR}/starbound"

ADD install.sh $HOMEDIR/install.sh
RUN mkdir -p $STEAMAPPDIR

USER root
RUN chown -R $UID:$GID $STEAMAPPDIR && chown -R $UID:$GID $STEAMCMDDIR && chown $UID:$GID $HOMEDIR/install.sh

USER $UID:$GID
RUN chmod u+x $HOMEDIR/install.sh
RUN touch $HOMEDIR/installmods.txt

CMD ["bash", "install.sh"]
