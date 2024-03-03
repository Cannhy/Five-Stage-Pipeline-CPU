.macro end
    li      $v0, 10
    syscall
.end_macro

.macro getInt(%des)
    li      $v0, 5
    syscall
    move    %des, $v0
.end_macro

.macro printInt(%src)
    move    $a0, %src
    li      $v0, 1
    syscall
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
main:
    getInt($s0)
 
    move    $a0, $s0
    
    fac:
    jal     factorial
    addi $s0, $s0, -1
    move $a0, $s0
    add $s1, $s1, $v0
    bne $a0, $0,  fac 
    printInt($s1)
    end

factorial:

    push($ra)
    push($t0)

    move    $t0, $a0

    bne     $t0, 1, else

    if:
        li      $v0, 1
        j       if_end  

    else:
        subi    $t1, $t0, 1
        move    $a0, $t1
        jal     factorial
        mult    $t0, $v0
        mflo    $v0
    if_end:

    pop($t0)
    pop($ra)

    jr  $ra