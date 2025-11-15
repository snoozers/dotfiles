#!/bin/bash
# @link https://max.io/bash.html

E=$(tput sgr0);    R=$(tput setab 1); G=$(tput setab 2); Y=$(tput setab 3);
B=$(tput setab 4); M=$(tput setab 5); C=$(tput setab 6); W=$(tput setab 7);
function e() { echo -e "$E"; }
function x() { echo -n "$E  "; }
function r() { echo -n "$R  "; }
function g() { echo -n "$G  "; }
function y() { echo -n "$Y  "; }
function b() { echo -n "$B  "; }
function m() { echo -n "$M  "; }
function c() { echo -n "$C  "; }
function w() { echo -n "$W  "; }

#putpixels
function u() {
    h="$*";o=${h:0:1};v=${h:1};
    for i in `seq $v`
    do
        $o;
    done
}

readonly pattern=(
    #灰リンゴ
    "x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x1 g1 x12 g3 x18 g3 x2 e1 x1 g1 x9 w1 x2 g1 x20 g1 x1 g1 x2 e1 x1 g1 x3 g3 x2 w1 x3 g2 x2 g1 x1 g1 x1 g3 x2 g3 x1 g3 x1 g3 x2 e1 x1 g1 x3 g1 x1 g1 x6 g1 x3 g2 x2 g1 x1 g1 x2 g1 x1 g1 x1 g1 x3 g1 x4 e1 x1 g3 x1 g4 w1 x1 w2 x1 g1 x3 g1 x3 g4 x1 g1 x1 g1 x1 g3 x1 g3 x2 e1 x8 w7 x25 e1 x7 w7 x26 e1 x6 w8 x26 e1 x6 w9 x25 e1 x7 w8 x25 e1 x8 w6 x26 e1 x9 w1 x1 w2 x27 e1 x40 e1 x40 e1 x40"\ 
    #赤リンゴ
    "x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x1 g1 x12 g3 x18 g3 x2 e1 x1 g1 x9 r1 x2 g1 x20 g1 x1 g1 x2 e1 x1 g1 x3 g3 x2 r1 x3 g2 x2 g1 x1 g1 x1 g3 x2 g3 x1 g3 x1 g3 x2 e1 x1 g1 x3 g1 x1 g1 x6 g1 x3 g2 x2 g1 x1 g1 x2 g1 x1 g1 x1 g1 x3 g1 x4 e1 x1 g3 x1 g4 r1 x1 r2 x1 g1 x3 g1 x3 g4 x1 g1 x1 g1 x1 g3 x1 g3 x2 e1 x8 r7 x25 e1 x7 r7 x26 e1 x6 r8 x26 e1 x6 r9 x25 e1 x7 r8 x25 e1 x8 r6 x26 e1 x9 r1 x1 r2 x27 e1 x40 e1 x40 e1 x40"\ 
    #毒リンゴ
    "x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x1 g1 x12 g3 x18 g3 x2 e1 x1 g1 x9 m1 x2 g1 x20 g1 x1 g1 x2 e1 x1 g1 x3 g3 x2 m1 x3 g2 x2 g1 x1 g1 x1 g3 x2 g3 x1 g3 x1 g3 x2 e1 x1 g1 x3 g1 x1 g1 x6 g1 x3 g2 x2 g1 x1 g1 x2 g1 x1 g1 x1 g1 x3 g1 x4 e1 x1 g3 x1 g4 m1 x1 m2 x1 g1 x3 g1 x3 g4 x1 g1 x1 g1 x1 g3 x1 g3 x2 e1 x8 m7 x25 e1 x7 m7 x26 e1 x6 m8 x26 e1 x6 m9 x25 e1 x7 m8 x25 e1 x8 m6 x26 e1 x9 m1 x1 m2 x27 e1 x40 e1 x40 e1 x40"\ 
    #黄リンゴ
    "x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x40 e1 x1 g1 x12 g3 x18 g3 x2 e1 x1 g1 x9 y1 x2 g1 x20 g1 x1 g1 x2 e1 x1 g1 x3 g3 x2 y1 x3 g2 x2 g1 x1 g1 x1 g3 x2 g3 x1 g3 x1 g3 x2 e1 x1 g1 x3 g1 x1 g1 x6 g1 x3 g2 x2 g1 x1 g1 x2 g1 x1 g1 x1 g1 x3 g1 x4 e1 x1 g3 x1 g4 y1 x1 y2 x1 g1 x3 g1 x3 g4 x1 g1 x1 g1 x1 g3 x1 g3 x2 e1 x8 y7 x25 e1 x7 y7 x26 e1 x6 y8 x26 e1 x6 y9 x25 e1 x7 y8 x25 e1 x8 y6 x26 e1 x9 y1 x1 y2 x27 e1 x40 e1 x40 e1 x40"\
)
img=${pattern[$(($RANDOM % ${#pattern[*]}))]}

for n in $img
do
    u $n
done
e;
exit 0;
