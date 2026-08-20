#!/bin/bash
# Setting UID AND GID
if [ ! -z "$PUID" ] && [ "$PUID" != "$(id -u steam)" ]; then
    usermod -o -u "$PUID" steam
fi
if [ ! -z "$PGID" ] && [ "$PGID" != "$(id -g steam)" ]; then
    groupmod -o -g "$PGID" steam
fi

chown -R steam:steam ${HOMEDIR}

su - steam
#Install the Starbound dedicated server
if ${SKIP_INSTALL} != "false"
then
  echo "Skipping steamcmd installation and update"
else
  echo "Installing and updating Starbound dedicated server with steamcmd"
  su - steam -c "${STEAMCMDDIR}/steamcmd.sh \
      +force_install_dir ${STEAMAPPDIR}/ \
      +login ${STEAM_ACCOUNT} ${STEAM_PASSWORD} \
      +app_update 211820 validate \
      +quit"

  chmod u+x ${STEAMAPPDIR}/linux/starbound_server

  #Build the mod install script
  su - steam -c "echo force_install_dir ${STEAMAPPDIR}/ >> ${STEAMAPPDIR}/installmods.txt"
  su - steam -c "echo login ${STEAM_ACCOUNT} ${STEAM_PASSWORD} >> ${STEAMAPPDIR}/installmods.txt"

  rm ${STEAMAPPDIR}/mods/*
  rm -R ${STEAMAPPDIR}/steamapps

  for mod_id in ${MOD_IDS}
  do
    su - steam -c "echo workshop_download_item 211820 $mod_id >> ${STEAMAPPDIR}/installmods.txt"
  done

  su - steam -c "echo quit >> ${STEAMAPPDIR}/installmods.txt"

  #install Mods
  su - steam -c "${STEAMCMDDIR}/steamcmd.sh +runscript ${STEAMAPPDIR}/installmods.txt"

  #Move all content.pak files from each mod to the mods folder and rename them
  for mod_id in ${MOD_IDS}
  do
    if [ -f ${STEAMAPPDIR}/steamapps/workshop/content/211820/$mod_id/contents.pak ]
    then
      su - steam -c "mv ${STEAMAPPDIR}/steamapps/workshop/content/211820/$mod_id/contents.pak ${STEAMAPPDIR}/mods/$mod_id.pak"
    else
      su - steam -c "mv -v ${STEAMAPPDIR}/steamapps/workshop/content/211820/$mod_id/* ${STEAMAPPDIR}/mods/"
    fi
  done
fi

#Run the server
cd ${STEAMAPPDIR}/linux
su - steam -c "./starbound_server"

exit
