.data 
matrix: .space 10000 #50*50*4 bits
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

.macro  getindex1(%ans, %i, %j)
    li $t7,50
    multu %i,$t7
    mflo %ans                   # %ans = %i * 50
    add %ans, %ans, %j          # %ans = %ans + %j
    sll %ans, %ans, 2           # %ans = %ans * 4
.end_macro
.macro  getindex2(%ans, %i, %j)
    addi $t5,%i,-1
    li $t6,50
    multu $t5,$t6
    mflo %ans                   # %ans = %i * 50
    add %ans, %ans, %j  
    add %ans, %ans, -1          # %ans = %ans + %j
    sll %ans, %ans, 2           # %ans = %ans * 4
.end_macro

.text
li  $v0, 5
syscall
move $s0, $v0                
li  $v0, 5
syscall
move $s1, $v0                
li  $t0, 0

in_i:
beq $t0, $s0, in_i_end
li  $t1, 0
in_j:                         
beq $t1, $s1, in_j_end
li  $v0, 5
syscall                        
getindex1($t2, $t0, $t1)        
sw  $v0, matrix($t2)            
addi $t1, $t1, 1
j   in_j
in_j_end:
addi $t0, $t0, 1
j   in_i
in_i_end:

move  $t0, $s0
out_i:
beq $t0, $0, out_i_end
move $t1,$s1
out_j:
beq $t1, $0, out_j_end
getindex2($t2, $t0, $t1)
lw $a0,matrix($t2)
bne $a0, $0, out                     
addi $t1, $t1, -1
j   out_j
out_j_end:                     
addi $t0, $t0, -1
j   out_i

out_i_end:
li  $v0, 10
syscall
out:
move $a0,$t0
li  $v0, 1
syscall
la  $a0, str_space
li  $v0, 4
syscall 
move $a0,$t1
li  $v0, 1
syscall
la  $a0, str_space
li  $v0, 4
syscall 
lw  $a0, matrix($t2)
li  $v0, 1
syscall
la  $a0, str_enter
li  $v0, 4
syscall 
addi $t1, $t1, -1
j   out_j