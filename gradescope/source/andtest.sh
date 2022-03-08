#!/bin/bash
#set -x 
# Simple script to test the AND assembly fragment

# assemble andtest.S into andtest.o
if [[ -a andtest.o ]]; then rm andtest.o; fi
make andtest.o
# assemble and.S into and.o
if [[ -a and.o ]]; then rm and.o; fi
make and.o
# link andtest.o and and.o into andtest
if [[ -a andtest ]]; then rm andtest; fi
make andtest

if [[ ! -a andtest ]]; then
    echo "FAIL: andtest not made"
    echo "0/1"
    exit -1
fi

# delete output file if it exits
if [[ -a and.resbin ]]; then rm and.resbin; fi

# run gdb with commands feed from standard input
# using bash here docment support
# https://www.gnu.org/software/bash/manual/bash.html#Here-Documents
# both standard ouput and error are sent to /dev/null so things are quiet
echo "running gdb ... you will have to look in $0 to see what we are doing"

gdb andtest >/dev/null 2>&1  <<EOF
b _start
run
delete 1
set \$rip = test1
c
dump binary value and.resbin { \$rax }
set \$rip = test2
c
append binary value and.resbin { \$rax }
set \$rip = test3
c
append binary value and.resbin { \$rax }
quit
EOF

if [[ $(xxd -ps -g8 and.resbin) == 'efbeaddeefbeaddeaaaaa88aaaaaa88a00a0008000a00080' ]]; then
    echo PASS
    echo 1/1
else
    echo FAIL
    echo 0/1
fi
