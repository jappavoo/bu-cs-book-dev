#!/bin/bash
#set -x 
# Simple script to test the SUM assembly fragment

# assemble sumtest.S into sumtest.o
if [[ -a sumtest.o ]]; then rm sumtest.o; fi
make sumtest.o
# assemble sum.S into sum.o
if [[ -a sum.o ]]; then rm sum.o; fi
make sum.o
# link sumtest.o and sum.o into sumtest
if [[ -a sumtest ]]; then rm sumtest; fi
make sumtest

if [[ ! -a sumtest ]]; then
    echo "FAIL: sumtest not made"
    echo "0/1"
    exit -1
fi

# delete output file if it exits
if [[ -a sum.resbin ]]; then rm sum.resbin; fi

# run gdb with commands feed from standard input
# using bash here docment support
# https://www.gnu.org/software/bash/manual/bash.html#Here-Documents
# both standard ouput and error are sent to /dev/null so things are quiet
echo "running gdb ... you will have to look in $0 to see what we are doing"

gdb sumtest >/dev/null 2>&1 <<EOF
b _start
run
delete 1
set \$rip=test1
c
dump binary value sum.resbin { \$rax, *((long long *)&SUM_POSITIVE), *((long long *)&SUM_NEGATIVE) }
set \$rip=test2
c
append binary value sum.resbin { \$rax, *((long long *)&SUM_POSITIVE), *((long long *)&SUM_NEGATIVE) }
set \$rip=test3
c
append binary value sum.resbin { \$rax, *((long long *)&SUM_POSITIVE), *((long long *)&SUM_NEGATIVE) }
set \$rip=test4
c
append binary value sum.resbin { \$rax, *((long long *)&SUM_POSITIVE), *((long long *)&SUM_NEGATIVE) }
quit
EOF

if [[ $(xxd -ps -g8 sum.resbin) == 'ffffffffffffffff0000000000000000ffffffffffffffff000000000000
00000100000000000000ffffffffffffffff56cf41030000000057cf4103
00000000ffffffffffffffff9dc641030000000057cf41030000000046f7
ffffffffffff' ]]; then
    echo PASS
    echo 1/1
else
    echo FAIL
    echo 0/1
fi
