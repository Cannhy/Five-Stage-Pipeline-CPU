.data
array: .space 256  #8*8*4 bits
book: .space 32 #8*4 bits
.macro  getindex(%ans, %i, %j)
    sll %ans, %i, 3            
    add %ans, %ans, %j         
    sll %ans, %ans, 2          
.end_macro
.macro push(%src)
    sw      %src, 0($sp)
    subi    $sp, $sp, 4
.end_macro

.macro pop(%des)
    addi    $sp, $sp, 4
    lw      %des, 0($sp) 
.end_macro

.text
input:
li $v0,5
syscall
move $s0, $v0
li $v0,5
syscall
move $s1, $v0

li  $t0, 0    
li $s3,1                  
in_i:                           
beq $t0, $s1, in_i_end
li  $v0, 5
syscall
move $t1,$v0
li  $v0, 5
syscall
move $t2,$v0
subi $t1, $t1, 1
subi $t2, $t2, 1
getindex($t3, $t1, $t2)
sw  $s3, array($t3)
getindex($t3,$t2,$t1)
sw $s3, array($t3)
addi $t0, $t0, 1
j   in_i
in_i_end:
li  $t0, 0
jal dfs

out:
move $a0, $v0
li $v0, 1
syscall
li $v0,10
syscall
dfs:
push($ra)
move $a0, $t0  # $a0 = x
li $t5,1       # $t5 is flag 
li $t7,1    
push($a0)   # $t7 is constant 1   $t0,$t1,$t2 can be use
sll $a0, $a0, 2
sw $t7, book($a0)
pop($a0)
li $t1,0     # $t6 is xunhuanbianliang
loop_1:
beq $t1, $s0, loop_1_end
sll $t2, $t1, 2
 lw $a1, book($t2)
 mult $a1, $t5
 mflo $t5
 addi $t1, $t1, 1
 j loop_1
 loop_1_end:
 getindex($s3,$a0,$0)
 lw $s3, array($s3)    
 mult $s3,$t5
 mflo $t5
 beq $t5,$t7, scf
 li $a1, 0            #$a1 is i
 loop_2:
 sub $t9, $a1, $s0
 bgez $t9, loop_2_end
 getindex($t2,$a0,$a1)
 push($a1)
 sll $a1, $a1, 2
 lw $t1, book($a1)
 pop($a1)
 lw $t3, array($t2)
 beq $t1,$0,G
 addi $a1, $a1, 1
 j loop_2
 G:
 beq $t3,$t7,next
 addi $a1, $a1, 1
 j loop_2
 next:
 move $t0, $a1
 jal dfs
 addi $a1, $a1, 1
 j loop_2
 scf:
 li $v0, 1
 j out
 loop_2_end:
 push($a0)      # $a0 = x
 sll $a0, $a0, 2
 sw $0, book($a0)
pop($ra)	
 li $v0, 0
 jr $ra