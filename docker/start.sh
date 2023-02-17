#!/usr/bin/env bash

function stop_apache {
  apache_pid="$1"

  if [ -e "$apache_pid" ];then
    kill -TERM `cat "$apache_pid"`
    rm -rf "$apache_pid"
  fi
}

stop_apache '/run/apache2/apache2.pid'
stop_apache '/usr/local/apache2/logs/httpd.pid'

apachectl -D FOREGROUND
exit 0
