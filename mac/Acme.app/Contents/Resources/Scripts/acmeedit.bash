#!/usr/bin/env bash -l

export PLAN9="${PLAN9:-/usr/local/plan9}"
if ! echo :$PATH: | grep -q :$PLAN9/bin:; then
	PATH=$PATH:$PLAN9/bin
fi
export LESS=
export LESSCHARSET=utf-8
export EDITOR=E
export VISUAL=$EDITOR

export SHELL=/bin/bash

if ! pgrep -q plumber; then
	plumber
	function cleanup() {
		pkill plumber
	}
	cat "$PLAN9/plumb/basic" | 9p write plumb/rules
else
	function cleanup() {
		:
	}
fi
trap 'cleanup; exit 1' 1 2 3 15

font=/mnt/font/Verdana/12a/font

if ! pgrep -q acme; then
	acme -a -c 1 -f "$font" "$@"
fi

cleanup
