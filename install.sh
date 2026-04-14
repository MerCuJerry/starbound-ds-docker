#!/bin/bash
#Install the Starbound dedicated server
${STEAMCMDDIR}/steamcmd.sh \
    +force_install_dir ${STEAMAPPDIR}/ \
    +login ${STEAM_ACCOUNT} ${STEAM_PASSWORD} \
    +app_update 211820 validate \
    +quit

chmod u+x ${STEAMAPPDIR}/linux/starbound_server

#Build the mod install script
echo force_install_dir ${STEAMAPPDIR}/ >> ${STEAMAPPDIR}/installmods.txt
echo login ${STEAM_ACCOUNT} ${STEAM_PASSWORD} >> ${STEAMAPPDIR}/installmods.txt

rm ${STEAMAPPDIR}/mods/*
rm -R ${STEAMAPPDIR}/steamapps

for mod_id in ${MOD_IDS}
do
  echo workshop_download_item 211820 $mod_id >> ${STEAMAPPDIR}/installmods.txt
done

echo quit >> ${STEAMAPPDIR}/installmods.txt

#install Mods
${STEAMCMDDIR}/steamcmd.sh +runscript ${STEAMAPPDIR}/installmods.txt

#Move all content.pak files from each mod to the mods folder and rename them
for mod_id in ${MOD_IDS}
do
  if [ -f ${STEAMAPPDIR}/steamapps/workshop/content/211820/$mod_id/contents.pak ]
  then
    mv ${STEAMAPPDIR}/steamapps/workshop/content/211820/$mod_id/contents.pak ${STEAMAPPDIR}/mods/$mod_id.pak
  else
    mv -v ${STEAMAPPDIR}/steamapps/workshop/content/211820/$mod_id/* ${STEAMAPPDIR}/mods/
  fi
done

#Run the server
cd ${STEAMAPPDIR}/linux
./starbound_server

exit
