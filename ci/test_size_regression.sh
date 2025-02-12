#!/bin/bash

# Checks the absolute size and the relative size increase of a file.

MAX_SIZE=7300000 # 7.3MB
MAX_PERC=2.0

if [ `uname` == "Darwin" ]
then
    SIZE1=$(stat -f "%z" "$1")
    SIZE2=$(stat -f "%z" "$2")
else
    SIZE1=$(stat -c "%s" "$1")
    SIZE2=$(stat -c "%s" "$2")
fi
PERC=$(bc <<< "scale=2; ($SIZE2 - $SIZE1)/$SIZE1 * 100")

echo "The new binary is $PERC % different in size compared to main."
echo "The new binary is $SIZE2 bytes."

if [ $SIZE2 -gt $MAX_SIZE ]
then
    echo "The current size ($SIZE2) is larger than the maximum size ($MAX_SIZE)."
    exit 1
fi

if [ $(bc <<< "scale=2; $PERC >= $MAX_PERC") -eq 1 ]
then
    echo "The percentage increase ($PERC) is larger then the maximum percentage increase ($MAX_PERC)."
    exit 1
fi
