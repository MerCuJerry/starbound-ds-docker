FROM cm2network/steamcmd:root-trixie

USER root

ENV STEAM_ACCOUNT account
ENV STEAM_PASSWORD password
ENV MOD_IDS ()
ENV UID 1000
ENV GID 1000
ENV STEAMAPPDIR "${HOMEDIR}/starbound"

ADD install.sh $HOMEDIR/install.sh
RUN mkdir -p $STEAMAPPDIR

RUN chown -R $UID:$GID $STEAMAPPDIR && chmod -R 777 $STEAMCMDDIR

USER $UID:$GID
RUN chmod u+x $HOMEDIR/install.sh
RUN touch $HOMEDIR/installmods.txt

CMD ["bash", "install.sh"]
