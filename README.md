# Pavlov Server

This container updates Pavlov VR and Steam on start.

- Method A - Docker Compose
  ```
  # First, edit your docker-compose.yml volumes to match your directory.
  nano docker-compose.yml
  
  # And run it.
  sudo docker compose up -d
  # or sudo docker-compose up -d
  ```

- Method B - Docker
  ```
  # Build it
  docker build . -t choryuidentify/pavlov-server:latest

  # Run it.
  docker run --name pavlov -d \
    -p 7500:7500/udp \
    -p 7900:7900/udp \
    -p 9100:9100/tcp \ #optional default Rcon port
    -v $HOME/pavlov/Game.ini:/home/steam/pavlovserver/Pavlov/Saved/Config/LinuxServer/Game.ini \
    -v $HOME/pavlov/mods.txt:/home/steam/pavlovserver/Pavlov/Saved/Config/mods.txt \ #optional
    -v $HOME/pavlov/RconSettings.txt:/home/steam/pavlovserver/Pavlov/Saved/Config/RconSettings.txt \ #optional, create port forwarding as required
    -v $HOME/pavlov/blacklist.txt:/home/steam/pavlovserver/Pavlov/Saved/Config/blacklist.txt \ #optional
    -v $HOME/pavlov/whitelist.txt:/home/steam/pavlovserver/Pavlov/Saved/Config/whitelist.txt \ #optional
    -e PORT=7500 \ # optional defaults to 7500
    --restart unless-stopped \
    choryuidentify/pavlov-server:latest
  ```

The second port is always 400 higher than the defined port. If you use port 7000 you will also need to forward port 7400. Refer to the [docs](http://wiki.pavlov-vr.com/index.php?title=Dedicated_server#Firewall.2FPort_forwarding) for more infomation on ports and port forwarding.

Your game should appear on the [PC Servers List](https://pavlovhorde.com/pcServers/) & [pablub custom serbers](https://pablub.xyz/).

### Sample Game.ini
```
[/Script/Pavlov.DedicatedServer]
bEnabled=true
ServerName=MyAwesomeServer
bSecured=true
bCustomServer=true
LimitedAmmoType=2
TimeLimit=0
MapRotation=(MapId="UGC2443220615") # Survival Island
```
Note: MapIds starting with `UGC` are from the [Steam workshop](https://steamcommunity.com/app/555160/workshop/). Append `UGC` to the id from the url of the map you want to use.  
See the [docs](http://wiki.pavlov-vr.com/index.php?title=Dedicated_server#Configuring_Game.ini) for more game configuration options.

### Sample mods.txt
```
76561198057346920 # BabyArmour
```
Note: Use [Steam ID Finder](https://www.steamidfinder.com/) to look up a Steam user ID.

### RconSettings.txt
```
Password=password
Port=9100
```

### Performance

Pavlovserver is functionally single threaded (one thread does vast majority of work). More CPUs only help if you are running more servers. More clockspeed = higher performance = more users per server.

Here are some performance stats for a docker host with an Intel Core i9-9880H CPU @ 2.30GHz, 32GB ram, and a 1Gbps fiber connection. The docker host is also running a few other non Pavlov containers. This setup could comfortably run half a dozen Pavlov VR servers.

| SERVER                       | # PLAYERS | MAP                          | CPU %   | MEM USAGE / LIMIT   | MEM % | NET I/0         | BLOCK I/0     |
|------------------------------|-----------|------------------------------|---------|---------------------|-------|-----------------|---------------|
| BabyArmour - Survival Island |         0 | Survival Island              |  68.91% | 710MiB / 31.26GiB   | 2.22% | 295MB / 50. 8MB | 223MB / 142MB |
| BabyArmour - Escape The Dead |         8 | Escape The Dead: Aftermath   | 117.59% | 916.4MiB / 31.26GiB | 2.86% | 81.4MB / 297MB  | 821MB / 142MB |
| BabyArmour - Mako Reactor    |         0 | ze_FFVII_Mako_Reactor_pav_v1 |  29.76% | 505.4MiB / 31.26GiB | 1.86% | 16.2MB / 33.7MB | 356MB / 135MB |

Increasing the player load increases memory & CPU usage.

| SERVER                       | # PLAYERS | MAP                          | CPU %   | MEM USAGE / LIMIT   | MEM % | NET I/0         | BLOCK I/0     |
|------------------------------|-----------|------------------------------|---------|---------------------|-------|-----------------|---------------|
| BabyArmour - Escape The Dead |        16 | Escape The Dead: Aftermath   | 140.95% | 1.011GiB / 31.26GiB | 3.23% | 251MB / 1.28GB  | 821MB / 142MB |

Note: the other two servers are still running, I just removed them for clarity.

### Build

```
docker build -t gregology/pavlov-server:0.16 .
docker push gregology/pavlov-server:0.16
docker tag gregology/pavlov-server:0.16 gregology/pavlov-server:latest
docker push gregology/pavlov-server:latest
```
