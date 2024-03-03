.text
li $v0 5
syscall
li $t0,400
move $s0,$v0
divu $s0,$t0
mfhi $t1
bgtz $t1, _panduan
li $a0,1
li $v0,1
syscall
li $v0, 10
syscall

_no:
li $a0,0
li $v0,1
syscall
li $v0, 10
syscall

_panduan:
li $t0,4
divu $s0,$t0
mfhi $t1
bgtz $t1, _no
li $t0,100
divu $s0,$t0
mfhi $t1
bgtz $t1, _yes
li $a0,0
li $v0,1
syscall
li $v0, 10
syscall
_yes:
li $a0,1
li $v0,1
syscall
li $v0, 10
syscall