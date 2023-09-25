#!/bin/bash

echo -e "Beginning Pavlov VR update run on $(date)\n\n"

bash /home/steam/steamcmd/steamcmd.sh +force_install_dir "/home/steam/pavlovserver" +login anonymous +app_update 622970 +exit
bash /home/steam/steamcmd/steamcmd.sh +login anonymous +app_update 1007 +quit

echo -e "Ending Pavlov VR update run on $(date)\n\n"
