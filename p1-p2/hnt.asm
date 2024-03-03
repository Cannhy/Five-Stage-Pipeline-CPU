.data
connect: .asciiz "-->"
enter: .asciiz "\n"
_a: .asciiz "A"
_b: .asciiz "B"
_c: .asciiz "C"

.macro push(%a)
   sw %a, 0($sp)
   subi, $sp, $sp, 4
.end_macro

.macro pop(%a)
    addi, $sp, $sp, 4
    lw %a, 0($sp)
.end_macro

.macro swap(%a, %b)
   move $s3, %a
   move %a, %b
   move %b, $s3
.end_macro

.text
li $v0, 5
syscall
li $t0, 1        #$t0 is constant 1
move $s0, $v0
move $t2, $s0 
la $a1, _a
la $a2, _b
la $a3, _c       #$a1 is n $t1 is parameter
jal dfs
li $v0, 10
syscall

dfs:
bne $t2, $t0, dfsconti
move $a0, $a1
li $v0, 4
syscall
la $a0, connect
li $v0, 4
syscall
move $a0, $a3
li $v0, 4
syscall
la $a0, enter
li $v0, 4
syscall
jr $ra

dfsconti:
push($ra)
push($a1)
push($a2)
push($a3)
push($t2)
swap($a2,$a3)
subi $t2, $t2, 1
jal dfs

pop($t2)
pop($a3)
pop($a2)
pop($a1)
pop($ra)

push($ra)
push($a1)
push($a2)
push($a3)
push($t2)

li $t2, 1
jal dfs

pop($t2)
pop($a3)
pop($a2)
pop($a1)
pop($ra)

push($ra)
push($a1)
push($a2)
push($a3)
push($t2)

subi $t2, $t2, 1
swap($a1, $a2)

jal dfs

pop($t2)
pop($a3)
pop($a2)
pop($a1)
pop($ra)

jr $ra
