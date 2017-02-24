#!/bin/bash
until  nohup /usr/local/bin/zmnbot.pl; do
	echo "Server bot crashed with exit code $?.  Respawning.." >&2
	sleep 1
done

