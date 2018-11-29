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

	# Log player stats
	getplayers | while read SCORE PING PLAYERNAME; do
		echo "$TIMESTAMP;$PLAYERNAME;$PING;$SCORE" >> "$PLAYERSTATS_LOG"
	done
fi

exit $RET
