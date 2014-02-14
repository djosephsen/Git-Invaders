Git-Invaders
============


	   #   #       ####        ##    
	  #######     ######     ######  
	 ########## ##########  ## ## ###
	### ### ### ### ## ### ##########
	# ####### # ########## #  #  #  #
	# #     # #   # ## #     # ## #  
	             #      #   # #  # # 


Git invaders is the collection of software I will to maintain an infinitely
scrolling space-invaders github contribution graph. 

## hax!

Yeah, I know, my github graph is the sacred record of my productivity, and I
shouldn't mess around with it or people won't take me seriously. I'm sorry, but
having had this idea, I can't not do it, so here's the deal: 

I'm not going to contrive meaningless commits to make this work, all the work
you see on the graph was real work done by me and committed to github.com, and
not some cron job drawing pretty pictures by committing space changes.

## How?

tldr; I'm spoofing the timestamp of some of my commits so they look like they
actually happened in the past. I'm only doing this on certain days when I need
there to be a "blank spot" on my contribution graph. (The longer story of how
this works is actually pretty cool, so you should read more (I even blogged the
[whole
story](http://www.skeptech.org/blog/2014/02/11/the-part-where-I-hack-my-github-graph/)
if you have a few minutes)).

There are three pieces to this puzzle. The first is a Go program that models
the 'invaders' data structure, and given epoch seconds for the day you start as
arg1, it returns 0 if it's ok to git commit today, and 1 if it's not ok to 
commit today. 

The second is a shell wrapper for git that intercepts my commit commands and,
if I shouldn't commit to github today, it conspires with the system dynamic
linker, and a C library that wraps the date-related system calls and *lies* to
git about what day it currently is. Harsh I know.  If today isn't a "blank day"
or the command isn't commit, the shell wrapper just passes everything through
unchanged to the real git client.

The third is the C shared object file that lies to the git client when it makes
the requisite system calls to discover the system time. I kludged this up
myself before discovering [libfaketime](https://github.com/wolfcw/libfaketime),
which is vastly superior, so I switched to using it instead. 

Using the three of these together, the process is transparent to me on a day to
day basis.  I commit and push as I normally do, and my git client draws space
invaders in my graph for me (As of Feb/March 2014, I'm just barely getting
started, so it doesn't look like much yet).  If you're interested in drawing
something in your contributions graph, you should be able to clone this repo,
and change the data structure inside the Go program to draw whatever sort of
endlessly repeating pattern you'd like in your github graph.  If you do, drop a
comment in here, I'd love to see it!

## invaders.go

It takes two arguments, a start day and 'today' in epoc seconds. You may omit
the second argument and it'll assume you mean today IRL, but the start day is
required.  Simply put, tell it when you started, and it'll exit 0 if you should
commit today, or 1 if you shouldn't. Tell it when you intend to start and some
arbitrary day after that, and it'll exit 0 if you should commit that day or 1 if
you shouldn't. 

Install it like this: 

	go get github.com/djoephsen/Git-Invaders 

Run it like you started 1 month ago like this on
Linux: 

	invaders $(date -d '1 month ago' +%s)

or like this on Darwin:

	invaders $(date -v-1M +%s)

use it in a shell script like this: 

	if invaders ${START}; then echo YES!; else echo NO!; fi

## git-wrapper.sh

This wrapper is intended to replace your git command (although you still need
the original git binary so don't rm it. Check the header for system specific
locations to things like libfaketime, and the real git binary etc..

I installed it like this: 

	echo [ -e "${GOPATH}/src/github.com/djosephsen/Git-Invaders/git-wrapper.sh" ] && alias git="${GOPATH}/src/github.com/djosephsen/Git-Invaders/git-wrapper.sh" > ~/.bashrc

Protip: If you export DEBUG, it'll give you debugging output so you can see it
working.

## libfaketime

The wrapper assumes you have
[libfaketime](github.com/djosephsen/Git-Invaders/git-wrapper.sh") installed
somewhere. What an awesome tool! 

Caveat Emtor: I had trouble using their 'faketime' wrapper on OSX 10.9.1. My shell
wrapper doesn't use their faketime wrapper and works fine for me on 10.9.1. 
