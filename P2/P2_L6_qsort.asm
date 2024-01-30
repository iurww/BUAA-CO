.data
a: .space 4020
space: .asciiz " "

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

.macro printstr(%str)
  li $v0, 4
  la $a0, %str
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

.text
main:
  getint($s0)
  li $t0, 1
  in:
  bgt $t0, $s0, in_end
    getint($t1)
    sll $t2, $t0, 2
    sw $t1, a($t2)
  addi $t0, $t0, 1
  j in
  in_end:

  li $a0, 1
  move $a1, $s0
  jal qsort

  li $t0, 1
  out:
  bgt $t0, $s0, out_end
    sll $t2, $t0, 2
    lw $t1, a($t2)
    printint($t1)
    printstr(space)
  addi $t0, $t0, 1
  j out
  out_end:

  li $v0, 10
  syscall

qsort:
  blt $a0, $a1, notreturn
    jr $ra
  notreturn:

  move $t0, $a0
  subi $t0, $t0, 1
  move $t1, $a1
  addi $t1, $t1, 1
  add $t2, $t0, $t1
  srl $t2, $t2, 1
  sll $t3, $t2, 2
  lw $t3, a($t3)

  while:
  bge $t0, $t1, while_end
    doi:
      addi $t0, $t0, 1
      sll $t2, $t0, 2
      lw $t4, a($t2)
    blt $t4, $t3, doi
    doj:
      subi $t1, $t1, 1
      sll $t2, $t1, 2
      lw $t4, a($t2)
    bgt $t4, $t3, doj

    bge $t0, $t1, notswap
      sll $t5, $t0, 2
      lw $t7, a($t5)
      sll $t6, $t1, 2
      lw $t8, a($t6)
      sw $t8, a($t5)
      sw $t7, a($t6)
    notswap:

  j while
  while_end:

  push($a0)
  push($a1)
  push($ra)
  move $a1, $t1
  jal qsort
  pop($ra)
  pop($a1)
  pop($a0)

  push($a0)
  push($a1)
  push($ra)
  move $a0, $t1
  addi $a0, $a0, 1
  jal qsort
  pop($ra)
  pop($a1)
  pop($a0)

  jr $ra
     
  



