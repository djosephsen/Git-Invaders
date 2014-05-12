#!/bin/sh

RG=/usr/bin/git
IV=${HOME}/reps/go/bin/invaders
DFTL=/usr/local/Cellar/libfaketime/0.9.5/lib/faketime/libfaketime.1.dylib
LFTL=${HOME}/reps/libfaketime/src/libfaketime.so.1
ARCH=$(uname)
DAYBUFFER=/tmp/got_dates

function debug {
#echo $@ to stderr if DEBUG is set
	[ "${DEBUG}" ] && echo "$@">&2
}

function error {
#echo $@ to stderr if DEBUG is set
	echo "$@">&2
	exit 42
}

[ -e "${RG}" ] || error "Real git not found at $RG"
[ -e "${IV}" ] || error "Invaders not found at $IV"

DAYTMP=/tmp/foo.$(date +%s)
DAYSAGO=$(cat ${DAYBUFFER} | head -n1)
cat ${DAYBUFFER} | sed -ne '2,$p' > $DAYTMP
mv ${DAYTMP} ${DAYBUFFER}

if [ "${ARCH}" == Darwin ]
then
	DYLD_FORCE_FLAT_NAMESPACE=1 DYLD_INSERT_LIBRARIES=${DFTL} FAKETIME="-${1}d" ${RG} "${@}"
	debug " Invaders Gitwrapper Execing: DYLD_FORCE_FLAT_NAMESPACE=1 DYLD_INSERT_LIBRARIES=${DFTL} FAKETIME=\"-${DAYSAGO}d\" ${RG} ${@}"
elif [ "${ARCH}" == Linux ]
then
	LD_PRELOAD=${LFTL} FAKETIME="-${c}d" ${RG} "${@}"
	debug "Invaders Gitwrapper Execing: LD_PRELOAD=${LFTL} FAKETIME=\"-${DAYSAGO}d\" ${RG} ${@}"
else
	error "ARCH not detected (neither Linux nor Darwin)"
fi
