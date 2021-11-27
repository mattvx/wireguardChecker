#!/bin/bash

data_today="$(date)"

# Check if the service actually exists by running a command
if ! command -v wg-quick &>/dev/null; then
	printf 'Wireguard not found!\n'
	exit
fi

	# If it exists and is active...
	if [ "$(systemctl is-active wg-quick@wg0)" == "active" ]; then
		printf 'Service is up and running!\n'
        	printf '%s - Wireguard is up and running!\n' "$data_today" > log.txt
	
	# If it exists but is not active... Try to restart
	elif [ "$(systemctl is-active wg-quick@wg0)" == "inactive" ]; then
		printf 'Found stopped service! Trying to restart...\n'
		printf '%s - Found stopped service! Trying to restart...\n' "$data_today" > log.txt

		# Checks if the command actually works
		if ! sudo systemctl start --quiet wg-quick@wg0; then
			printf 'something went wrong while starting Wireguard\n'
			printf '%s - Something went wrong while starting Wireguard\n' "$data_today" >> log.txt
			python3 /home/rocky/folder/mailer.py			
			exit
		else
			printf '...Service started!\n'
			printf '...Service started!\n' >> log.txt
		fi
	fi

	# Check if the service is enabled
	if [ "$(systemctl is-enabled wg-quick@wg0)" == "disabled" ]; then
		printf 'Service is not enabled!\n...enabling!\n'
		# Check if enabling the service fails...
		if ! sudo systemctl enable --quiet wg-quick@wg0; then
			printf 'Something went wrong while enabling the service.'
		else
			printf 'Service now enabled!'
			printf '%s - Found disabled service, now enabled!' "$data_today"  >> log.txt
			python3 /home/rocky/folder/mailer.py
			exit
		fi
	else
		printf 'Service enabled!'
		printf '%s - Service is enabled!' "$data_today" >> log.txt
		python3 /home/rocky/folder/mailer.py
		exit
		fi

