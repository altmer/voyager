#!/bin/bash

export APP="/opt/app/bin/voyager"

### Run database setup, then start the app in the foreground

if [ "$1" = 'init' ]; then
  $APP eval 'Voyager.Release.migrate()' && $APP start
else
  $APP "$@"
fi
