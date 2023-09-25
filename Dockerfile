FROM cm2network/steamcmd:root

# Default port
ENV PORT 7500

# Host Pavlov
RUN /home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/pavlovserver +app_update 622970 +exit && chmod +x /home/steam/pavlovserver/PavlovServer.sh && chown steam:steam -R /home/steam/pavlovserver

RUN apt update && apt install -y gdb curl lib32gcc-s1 libc++-dev unzip && rm -rf /var/lib/apt/lists/*

RUN rm /usr/lib/x86_64-linux-gnu/libc++.so && ln -s /usr/lib/x86_64-linux-gnu/libc++.so.1 /usr/lib/x86_64-linux-gnu/libc++.so

USER steam

# Start Steam
RUN /home/steam/steamcmd/steamcmd.sh +login anonymous +app_update 1007 +quit
#RUN mkdir -p /home/steam/.steam/sdk64
#RUN cp /home/steam/steamcmd/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/steam/.steam/sdk64/steamclient.so
#RUN cp /home/steam/steamcmd/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/steam/pavlovserver/Pavlov/Binaries/Linux/steamclient.so

COPY pavlov_update.sh /home/steam/pavlov_update.sh
RUN mkdir /home/steam/pavlov_update_logs && touch /home/steam/pavlov_update_logs/pavlov_update.sh.log

COPY pavlov_start.sh /home/steam/pavlov_start.sh

CMD ["bash", "/home/steam/pavlov_start.sh"]
