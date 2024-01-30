.macro getInt(%des)
  li $v0, 5
  syscall
  move %des, $v0
.end_macro

.macro printInt(%src)
  move $a0, %src
  li $v0, 1
  syscall
.end_macro

.macro printStr(%str)
  la $a0, %str
  li $v0, 4
  syscall
.end_macro

.macro push(%src)
  subi $sp, $sp, 4
  sw %src, 0($sp)
.end_macro

.macro pop(%des)
  lw %des, 0($sp)
  addi $sp, $sp, 4
.end_macro

.macro getadr(%ans, %i, %j)
    mul %ans, %i, 8        #ans=i*50
    add %ans, %ans, %j      #ans+=j
    sll %ans, %ans, 2       #ans=ans*4
.end_macro

.macro end
  li $v0, 10
  syscall
.end_macro

.data 
  g: .space 256
  vis: .space 40
  
.text
main:
  getInt($s1)
  getInt($s2)
   
  li $t0, 0
  for1:
    beq $t0, $s2, for1_end

    getInt($t1)
    getInt($t2)
    subi $t1, $t1, 1
    subi $t2, $t2, 1

    li $t4, 1
    getadr($t3, $t1, $t2)
    sw $t4, g($t3)
    getadr($t3, $t2, $t1)
    sw $t4, g($t3)
    
    addi $t0, $t0, 1
    j for1
  for1_end:

  li $a0, 0
  li $s5, 0
  jal hamilton

  out:
  printInt($s5)
  end

hamilton:
  li $t4, 1
  mul $t2, $a0, 4
  sw $t4, vis($t2)

  li $t0, 0
  li $t1, 1
  check:
    beq	$t0, $s1, check_end

    sll $t2, $t0 ,2
    lw $t3, vis($t2)
    and	$t1, $t1, $t3

    addi $t0, $t0, 1
    j check
  check_end:
  
  getadr($t2, $a0, $zero)
  lw $t3, g($t2)
  and $t1, $t1, $t3

  re:
    beq $t1, $zero, not_re

    li $s5, 1
    j out
    pop($ra)
    pop($t0)
    pop($a0)
    jr $ra

  not_re:
  
  li $t0, 0
  search:
    beq $t0, $s1, search_end
    
    sll $t2, $t0, 2
    lw $t3, vis($t2)
    bne $t3, $zero, not_dfs
    getadr($t2, $a0, $t0)
    lw $t3, g($t2)
    beq $t3, $zero, not_dfs

    push($a0)
    push($t0)
    push($ra)
    
    move $a0, $t0
    jal hamilton

    pop($ra)
    pop($t0)
    pop($a0)
    
    not_dfs:
    addi $t0, $t0, 1
    
    j search
  search_end:

  mul $t2, $a0, 4
  sw $zero, vis($t2)

  jr $ra
