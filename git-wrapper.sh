#!/bin/sh

PATTERN_REPEAT=216 #a magic number, where the invader pattern first repeats. 
START_DAY='1391983086'
RG=/usr/bin/git
FT=/usr/local/bin/faketime
IV=${HOME}/reps/go/bin/invaders
ARCH=$(uname)

function debug {
#echo $@ to stderr if DEBUG is set
	[ "${DEBUG}" ] && echo $@ >&2
}

function error {
#echo $@ to stderr if DEBUG is set
	echo "$@">&2
	exit 42
}

function computeEpoc {
#return $1 days from today in epoc seconds
	if [ "${ARCH}" == "Linux" ]
	then
		echo $(date -d "today + ${1} days" +%s)
	elif [ "${ARCH}" == "Darwin" ]
	then
		echo $(date -v "+${i}d" +%s)
	else
		error "ERROR: Unknown architecture! (not linux or darwin)"
	fi
}

[ -e "${RG}" ] || error "Real git not found at $RG"
[ -e "${FT}" ] || error "Faketime not found at $FT"
[ -e "${IV}" ] || error "Invaders not found at $IV"

if grep -q 'commit' <<< $@
then
	if ! ${IV} ${START_DAY} > /dev/null
	then
		DSS=$((($(date +%s)-${START_DAY})/86400))
		i=$((${PATTERN_REPEAT} + ${DSS} ))
		debug "start: $DSS days since start, I is $i (${PATTERN_REPEAT} + ${DSS} )"
		while ! ${IV} ${START_DAY} $(computeEpoc ${i}) > /dev/null
		do
			debug "loop: I is $i"
			i=$((${i}-1))
		done
			debug "done: I is $i"
		OFFSET=$((${PATTERN_REPEAT}+${DSS}-${i}))
		echo invaders gitwrapper execing:  "${FT} -f \"-${OFFSET}d\" ${RG} ${@}"
		${FT} -f -${OFFSET}d ${RG} ${@}
	fi
fi
