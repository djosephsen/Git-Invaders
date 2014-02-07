#!/bin/sh

PATTERN_REPEAT=216 #a magic number, where the invader pattern first repeats. 
START_DAY='1391983086'
RG=/usr/bin/git
IV=${HOME}/reps/go/bin/invaders
DFTL=/usr/local/Cellar/libfaketime/0.9.5/lib/faketime/libfaketime.1.dylib
LFTL=${HOME}/reps/libfaketime/src/libfaketime.so.1
ARCH=$(uname)

function debug {
#echo $@ to stderr if DEBUG is set
	[ "${DEBUG}" ] && echo "$@">&2
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

		if [ "${ARCH}" == Darwin ]
		then
			DYLD_FORCE_FLAT_NAMESPACE=1 DYLD_INSERT_LIBRARIES=${DFTL} FAKETIME="-${OFFSET}d" ${RG} "${@}"
			debug " Invaders Gitwrapper Execing: DYLD_FORCE_FLAT_NAMESPACE=1 DYLD_INSERT_LIBRARIES=${DFTL} FAKETIME=\"-${OFFSET}d\" ${RG} ${@}"
		elif [ "${ARCH}" == Linux ]
		then
			LD_PRELOAD=${LFTL} FAKETIME="-${OFFSET}d" ${RG} "${@}"
			debug "Invaders Gitwrapper Execing: LD_PRELOAD=${LFTL} FAKETIME=\"-${OFFSET}d\" ${RG} ${@}"
		else
			error "ARCH not detected (neither Linux nor Darwin)"
		fi
	fi
else
	${RG} "${@}"
fi
