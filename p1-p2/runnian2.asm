.data
matrix: .space 10000
space: .asciiz " "
enter: .asciiz "\n"
.macro getindex(%x,%y,%z)
    mult %y, $a2
    mflo $s1
    add %x, $s1, %z
    sll %x, %x, 2
.end_macro
.text
li $v0, 5
syscall
move $a1, $v0    #a1 is hangshu
li $v0, 5
syscall
move $a2, $v0    #a2 is lieshu
li $t0, 0
in_i:
beq $t0, $a1, in_i_end
li $t1,0
in_j:
beq $t1, $a2, in_j_end
getindex($t3, $t0, $t1)
li $v0, 5
syscall
sw $v0, matrix($t3)
addi $t1, $t1, 1
j in_j
in_j_end:
addi $t0, $t0, 1
j in_i
in_i_end:
move $t0, $a1
addi $t0, $t0, -1
out_i:
bltz $t0, out_i_end
move $t1, $a2
addi $t1, $t1, -1
out_j:
bltz $t1, out_j_end
getindex($t3, $t0, $t1)
lw $t3, matrix($t3)
bnez $t3, out
addi $t1, $t1, -1
j out_j
out_j_end:
addi $t0, $t0, -1
j out_i
out_i_end:
li $v0, 10
syscall
out:
move $a0, $t0
addi $a0, $a0, 1
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
move $a0, $t1
addi $a0, $a0, 1
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
move $a0, $t3
li $v0, 1
syscall
la $a0, enter
li $v0, 4
syscall
addi $t1, $t1, -1
j out_j