#!/bin/sh

RG=/usr/bin/git
IV=/home/dave/reps/go/bin/invaders
LFT=/home/dave/reps/libfaketime/src/libfaketime.so.1



PATTERN_REPEAT=216 #a magic number, where the invader pattern first repeats. 
START_DAY='1391983086'


if grep -q 'commit' <<< $@
then
	if ! ${IV} ${START_DAY} > /dev/null
	then
		i=$((${PATTERN_REPEAT}-1))
		while ! ${IV} ${START_DAY} $(date -d "today + ${i} days" +%s)
		do
			i=$((${i}-1))
		done
		OFFSET=$((${PATTERN_REPEAT}-${i}))
		echo "LD_PRELOAD=$LFT FAKETIME=-${OFFSET}d ${RG} ${@}"
	fi
fi

