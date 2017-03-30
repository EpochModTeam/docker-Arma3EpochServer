#!/bin/bash

ARMASVRPATH=/arma3
ARMAAPPID=107410

#:: Epoch Workshop IDs: Experimental = 455221958 Normal = 421839251
mods[455221958]='@epoch' 
servermods[558243173]='@epochhive'

#make redis config save server database to exposed /data folder to persist data on host
if [ -d "/data" ]; then
	sed -i 's@dir /var/lib/redis@dir /data@g' /etc/redis/redis.conf
fi

#start redis
service redis-server start


cd /root
# install steamcmd
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -zxvf steamcmd_linux.tar.gz
rm -f steamcmd_linux.tar.gz
cd ..


# build mod list
MODLIST=""
ARMASERVERMODS=""
for i in "${!servermods[@]}"
do
   MODLIST+="+workshop_download_item $ARMAAPPID $i "
   ARMASERVERMODS+="${servermods[$i]};"
done
ARMAMODS=""
for i in "${!mods[@]}"
do
   MODLIST+="+workshop_download_item $ARMAAPPID $i "
   ARMAMODS+="${mods[$i]};"
done

# install arma 3
/root/steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD +force_install_dir /arma3 "+app_update 233780" $MODLIST validate +quit

#link common folders
ln -s $ARMASVRPATH"/mpmissions"  $ARMASVRPATH"/MPMissions"
ln -s $ARMASVRPATH"/keys"  $ARMASVRPATH"/Keys"


# perform install of mods
for i in "${!mods[@]}"
do
	MODFILE="/root/steamapps/workshop/content/107410/$i"
	if [ -d "$MODFILE" ]; then
		# convert to mod to lowercase
		cd $MODFILE
		ls | while read upName; do loName=`echo "${upName}" | tr '[:upper:]' '[:lower:]'`; mv "$upName" "$loName"; done
   		# install client mods
		ln -s $MODFILE $ARMASVRPATH"/"${mods[$i]}
		# copy latest key to server
		cp -a -v $ARMASVRPATH"/"${mods[$i]}"/keys/." $ARMASVRPATH"/keys"
	else
	   echo "ERROR: Mod files not found for $i"
	fi
done


for i in "${!servermods[@]}"
do
	MODFILE="/root/steamapps/workshop/content/107410/$i"
	if [ -d "$MODFILE" ]; then
		# convert to mod to lowercase
		cd $MODFILE
		ls | while read upName; do loName=`echo "${upName}" | tr '[:upper:]' '[:lower:]'`; mv "$upName" "$loName"; done
		#install server mods
		ln -s $MODFILE $ARMASVRPATH"/"${servermods[$i]}
   		#special extra install for 558243173
   		if [ "$i" -eq "558243173" ]; then
   			cp -a -v $ARMASVRPATH"/"${servermods[$i]}"/epochah-example.hpp" $ARMASVRPATH"/"${servermods[$i]}"/epochah.hpp"
			cp -a -v $ARMASVRPATH"/"${servermods[$i]}"/epochconfig-example.hpp" $ARMASVRPATH"/"${servermods[$i]}"/epochconfig.hpp"
			cp -a -v $ARMASVRPATH"/"${servermods[$i]}"/epochserver-example.ini" $ARMASVRPATH"/"${servermods[$i]}"/epochserver.ini"
			#sed -i "s@Password = foobared@Password = $REDISAUTHPASS@g" $ARMASVRPATH"/${servermods[$i]}/EpochServer.ini"
			#:: copy config profile and battleye files to live
			mkdir -p $ARMASVRPATH"/sc"
			cp -a -v $ARMASVRPATH"/"${servermods[$i]}"/sc/." $ARMASVRPATH"/sc"
			cp -a -v $ARMASVRPATH"/sc/server-example.cfg" $ARMASVRPATH"/sc/server.cfg"
			cp -a -v $ARMASVRPATH"/sc/basic-example.cfg" $ARMASVRPATH"/sc/basic.cfg"
			cp -a -v $ARMASVRPATH"/sc/battleye/example-beserver.cfg" $ARMASVRPATH"/sc/battleye/beserver.cfg"
			#:: update mission files
			mkdir -p $ARMASVRPATH"/mpmissions"
			cp -a -v $ARMASVRPATH"/"${servermods[$i]}"/mpmissions/." $ARMASVRPATH"/mpmissions"
   		fi
	else
	   echo "ERROR: Mod files not found for $i"
	fi
done

# move into arma3 folder
cd /arma3

#start arma3server arma3serverprofiling

FILE=arma3serverprofiling
if [ -f $FILE ]; then
   echo "using profiling test build"
else
   FILE=arma3server
fi

./$FILE -port=2302 -profiles=/sc -mod="$ARMAMODS" -serverMod="$ARMASERVERMODS" -config="/arma3/sc/server.cfg" -cfg="/arma3/sc/basic.cfg" -name=SC -world=empty -autoinit

