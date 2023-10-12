FROM cm2network/steamcmd:root

# Default port
ENV PORT 7500

# Install dependencies
RUN apt update && apt install -y gdb curl lib32gcc-s1 libc++-dev unzip && rm -rf /var/lib/apt/lists/*

# Fix libc++ error
RUN rm /usr/lib/x86_64-linux-gnu/libc++.so && ln -s /usr/lib/x86_64-linux-gnu/libc++.so.1 /usr/lib/x86_64-linux-gnu/libc++.so

# Change user
USER steam
RUN mkdir /home/steam/pavlovserver/
WORKDIR /home/steam/pavlovserver/

# Install Pavlov Server
RUN /home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/pavlovserver +app_update 622970 +exit && chmod +x /home/steam/pavlovserver/PavlovServer.sh

# Start Steam
RUN /home/steam/steamcmd/steamcmd.sh +login anonymous +app_update 1007 +quit

# Copy files
COPY pavlov_update.sh /home/steam/pavlov_update.sh
RUN mkdir -p /home/steam/pavlovserver/Pavlov/Saved/Config/LinuxServer /home/steam/pavlovserver/Pavlov/Saved/Mods/ \
  && touch /home/steam/pavlovserver/Pavlov/Saved/Config/mods.txt \
  && touch /home/steam/pavlovserver/Pavlov/Saved/Config/blacklist.txt \
  && touch /home/steam/pavlovserver/Pavlov/Saved/Config/whitelist.txt

COPY pavlov_start.sh /home/steam/pavlov_start.sh

CMD ["bash", "/home/steam/pavlov_start.sh"]
