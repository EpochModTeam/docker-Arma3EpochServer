## Docker based All-In-One install of Arma 3 Epoch Linux Server (Experimental)


1. First install https://www.docker.com/. 

2. Start by pulling the docker image: https://hub.docker.com/r/epochmodteam/arma3epochserver/

```
docker pull epochmodteam/arma3epochserver
```

3. Then start the server:
```
docker run --rm -e STEAM_USERNAME='your@email.net' -e STEAM_PASSWORD='YourPassW0rd' --privileged -p 2302-2306:2302-2306/udp -it epochmodteam/arma3epochserver
```

Change the STEAM_USERNAME and STEAM_PASSWORD before running, as you must login to be able to download Arma 3 server files and workshop mods.

If you want to persist data add the ```-v C:\Docker\data:/data``` option below and change the folder "C:\Docker\data" to a location you want to store the redis database.
```
docker run --rm -e STEAM_USERNAME='your@email.net' -e STEAM_PASSWORD='YourPassW0rd' --privileged -v C:\Docker\data:/data -p 2302-2306:2302-2306/udp -it epochmodteam/arma3epochserver
```

You can alternatively add a "credentials" file to the location you are running the command from and instead of specifying ```-e STEAM_USERNAME='your@email.net' -e STEAM_PASSWORD='YourPassW0rd'``` via command line use:
```--env-file credentials```

```
STEAM_USERNAME=your@email.net
STEAM_PASSWORD=YourPassW0rd
```

To add scripts and additional files, mount the folder with your content and add your commands to the ```PRESCRIPT``` variable:
```
docker run --rm -e STEAM_USERNAME='your@email.net' -e STEAM_PASSWORD='YourPassW0rd' --privileged -v C:\yourFiles\:/extraFiles -e PRESCRIPT"cp /extraFiles/epoch.Altis.pbo /arma3/mpmissions" -p 2302-2306:2302-2306/udp -it epochmodteam/arma3epochserver 
```
This will execute before running the server.