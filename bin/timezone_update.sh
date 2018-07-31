#!/usr/bin/env bash
#set -e

[ ! -z $DEBUG  ] && set -x


if [ ! -z "$TZ" ]; then
   if [ ! -f  /etc/timezone ] || [ "$TZ" != "$(cat /etc/timezone)" ]; then
		echo "$TZ" > /etc/timezone
		rm /etc/localtime
		dpkg-reconfigure -f noninteractive tzdata
	fi
fi
