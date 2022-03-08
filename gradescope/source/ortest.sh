#!/bin/bash
#set -x 
# Simple script to test the OR assembly fragment

# assemble ortest.S into ortest.o
if [[ -a ortest.o ]]; then rm ortest.o; fi
make ortest.o
# assemble or.S into or.o
if [[ -a or.o ]]; then rm or.o; fi
make or.o
# link ortest.o and or.o into ortest
if [[ -a ortest ]]; then rm ortest; fi
make ortest

if [[ ! -a ortest ]]; then
    echo "FAIL: ortest not made"
    echo "0/1"
    exit -1
fi

# delete output file if it exits
if [[ -a or.resbin ]]; then rm or.resbin; fi

# run gdb with commands feed from standard input
# using bash here docment support
# https://www.gnu.org/software/bash/manual/bash.html#Here-Documents
# both standard ouput and error are sent to /dev/null so things are quiet
echo "running gdb ... you will have to look in $0 to see what we are doing"

gdb ortest >/dev/null 2>&1  <<EOF
b _start
run
delete 1
set \$rip = test1
c
dump binary value or.resbin { \$rax }
set \$rip = test2
c
append binary value or.resbin { \$rax }
set \$rip = test3
c
append binary value or.resbin { \$rax }
quit
EOF

if [[ $(xxd -ps -g8 or.resbin) == '010000000000000001000000000000800100f0ffff0f0080' ]]; then
    echo PASS
    echo 1/1
else
    echo FAIL
    echo 0/1
fi
