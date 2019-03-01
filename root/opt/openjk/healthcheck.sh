#!/bin/bash
#
# OpenJK server health check script.
#

# Set variables
OJK_DIR="/opt/openjk"
OJK_MOD="${OJK_MOD:-base}"
OJK_HOMEPATH="$OJK_DIR/homepath"
SERVERSTATS_LOG="$OJK_HOMEPATH/$OJK_MOD/serverstats.log"
PLAYERSTATS_LOG="$OJK_HOMEPATH/$OJK_MOD/playerstats.log"
TIMESTAMP=`date -u +"%Y-%m-%d %H:%M:%S"`
UPTIME_LIMIT=43200
RET=0

# Load functions
. "$OJK_DIR/functions.sh"

# Check server status
INFO=`getinfo`
if [ -z "$INFO" ]; then
	# Server didn't respond
	RET=1
else
	# Server is running
	MAPNAME=`parseinfo "$INFO" mapname`
	CUR_CLIENTS=`parseinfo "$INFO" clients`
	MAX_CLIENTS=`parseinfo "$INFO" sv_maxclients`
	echo "Connected players: $CUR_CLIENTS/$MAX_CLIENTS on $MAPNAME"

	# Log server stats
	echo "$TIMESTAMP;$MAPNAME;$CUR_CLIENTS;$MAX_CLIENTS" >> "$SERVERSTATS_LOG"
	
	# Check players count
	if [ "$CUR_CLIENTS" -eq 0 ]; then
		# Check uptime
		UPTIME=`ps -e -o comm= -o etimes= | grep openjkded | head -n 1 | awk '{ print $2 }'`
		if [ -n "$UPTIME" -a "$UPTIME" -gt "$UPTIME_LIMIT" ]; then
			# Server has been up too long
			echo "Server uptime ($UPTIME) is higher than allowed limit ($UPTIME_LIMIT)"
			RET=1
		fi
	else
		# Log player stats
		getplayers | while read SCORE PING PLAYERNAME; do
			echo "$TIMESTAMP;$PLAYERNAME;$PING;$SCORE" >> "$PLAYERSTATS_LOG"
		done
	fi
fi

exit $RET
