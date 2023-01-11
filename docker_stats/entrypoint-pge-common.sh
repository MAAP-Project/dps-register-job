#!/bin/bash

# common entrypoint tasks
. /entrypoint-common.sh

# source bash profile
source $HOME/.bash_profile

# source verdi virtualenv
if [ -e "$HOME/verdi/bin/activate" ]; then
  source $HOME/verdi/bin/activate
fi

echo "Activated verdi/bin. Finished running entrypoint-pge-common"