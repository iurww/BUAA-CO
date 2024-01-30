.data
enter: .asciiz "\n"

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

.text
  getint($s0)
  getint($s1)

  li $t0, 153
  li $t1, 370
  li $t2, 371
  li $t3, 407

  blt $t0, $s0, end1
  bge $t0, $s1, end1
  printint($t0)
  printstr(enter)
  end1:

  blt $t1, $s0, end2
  bge $t1, $s1, end2
  printint($t1)
  printstr(enter)
  end2:

  blt $t2, $s0, end3
  bge $t2, $s1, end3
  printint($t2)
  printstr(enter)
  end3:

  blt $t3, $s0, end4
  bge $t3, $s1, end4
  printint($t3)
  printstr(enter)
  end4:

  li $v0, 10
  syscall




