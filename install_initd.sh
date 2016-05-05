#!/bin/bash
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

ln -fs "${PWD}/debian/init/plexHue" /etc/init.d/plexHue
update-rc.d plexHue defaults
update-rc.d plexHue enable
