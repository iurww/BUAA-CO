.data
g: .space 400
vis: .space 400
dx: .space 16
dy: .space 16

.macro getint(%des)
  li $v0, 5
  syscall
  move %des, $v0
.end_macro

.macro printint(%src)
  li $v0, 1		
  move $a0, %src
  syscall				
.end_macro

.macro getadr(%ans, %i, %j)
   mul %ans, %i, 10
   add %ans, %ans, %j			
   sll %ans, %ans, 2
.end_macro

.macro push(%src)
  subi $sp, $sp, 4
  sw %src, 0($sp)
.end_macro

.macro pop(%des)
  lw %des, 0($sp)
  addi $sp, $sp, 4
.end_macro

.text
main:
  li $t0, -1
  li $t1, 1
  la $t2, dx
  sw $t0, 0($t2)
  sw $zero, 4($t2)
  sw $t1, 8($t2)
  sw $zero, 12($t2)
  la $t2, dy
  sw $zero, 0($t2)
  sw $t1, 4($t2)
  sw $zero, 8($t2)
  sw $t0, 12($t2)

  getint($s0)
  getint($s1)

  li $t0, 0
  in_i:
  beq $t0, $s0, in_i_end 
    li $t1, 0
    in_j:
    beq $t1, $s1, in_j_end     
      getint($t2)
      getadr($t3, $t0, $t1)
      sw $t2, g($t3)
    add $t1, $t1, 1
    j in_j
    in_j_end:
  add $t0, $t0, 1
  j in_i
  in_i_end:

  getint($s2)
  getint($s3)
  getint($s4)
  getint($s5)
  subi $s2, $s2, 1
  subi $s3, $s3, 1
  subi $s4, $s4, 1
  subi $s5, $s5, 1

  move $a0, $s2
  move $a1, $s3
  jal dfs

  printint($s6)

  li $v0, 10
  syscall

dfs:
  bne $a0, $s4, not_return
  bne $a1, $s5, not_return
    addi $s6, $s6, 1
    jr $ra
  not_return:

  getadr($t2, $a0, $a1)
  li $t1, 1
  sw $t1, vis($t2)

  li $t0, 0
  search:
  beq $t0, 16, search_end
    lw $t1, dx($t0)
    add $t1, $t1, $a0
    lw $t2, dy($t0)
    add $t2, $t2, $a1 
    
    blt $t1, 0, notdfs
    bge $t1, $s0, notdfs
    blt $t2, 0, notdfs
    bge $t2, $s1, notdfs
    getadr($t5, $t1, $t2)
    lw $t3, vis($t5)
    bne $t3, 0, notdfs
    lw $t4, g($t5)
    bne $t4, 0, notdfs
    
    push($ra)
    push($t0)
    push($a0)
    push($a1)
    move $a0, $t1
    move $a1, $t2
    jal dfs
    pop($a1)
    pop($a0)
    pop($t0)
    pop($ra)

    notdfs:

  addi $t0, $t0, 4
  j search
  search_end:

  getadr($t2, $a0, $a1)
  sw $zero, vis($t2)
  
  jr $ra