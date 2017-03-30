# Docker based All-In-One install of Arma 3 Epoch Linux Server (Experimental)

https://hub.docker.com/r/epochmodteam/arma3epochserver/

How to start:

```
docker pull epochmodteam/arma3epochserver
```

Start from Windows Host:
```
docker run --rm -e STEAM_USERNAME='your@email.net' -e STEAM_PASSWORD='YourPassW0rd' --privileged -v C:\Docker\data:/data -p 2302-2405:2302-2405/udp -it epochmodteam/arma3epochserver
```

Change the STEAM_USERNAME and STEAM_PASSWORD as you must login to be able to download Arma 3 files and workshop mods.

Also change the folder "C:\Docker\data" to a location you want to store the redis database.