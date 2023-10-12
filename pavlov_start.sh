#!/bin/bash

echo "UID: $UID / GID: $(id -g)"

bash /home/steam/pavlov_update.sh

bash /home/steam/pavlovserver/PavlovServer.sh -PORT=$PORT
