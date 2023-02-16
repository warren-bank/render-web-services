#!/bin/bash

stop_all() 
{
    echo "Stopping apache"
    kill $APACHE_PID
    rm -rf /run/apache2/apache2.pid
}

trap stop_all INT TERM

apachectl -D FOREGROUND &
APACHE_PID=$!

echo "Started"
wait $APACHE_PID
trap - TERM INT
wait $APACHE_PID

echo "Done"
