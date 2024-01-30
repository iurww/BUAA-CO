.data
s1: .asciiz "move disk "
s2: .asciiz " from "
s3: .asciiz " to "
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

.macro printchar(%src)
  li $v0, 11
  move $a0, %src
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
  
  move $a0, $s0
  li $a1, 65
  li $a2, 66
  li $a3, 67
  jal hanoi

  li $v0, 10
  syscall

hanoi:
  bne $a0, 0, not_return
    push($ra)
    jal print1
    jal print2
    pop($ra)
    jr $ra
  not_return:  

  push($a0)
  push($a1)
  push($a2)
  push($a3)
  push($ra)
  subi $a0, $a0, 1
  jal hanoi
  pop($ra)
  pop($a3)
  pop($a2)
  pop($a1)
  pop($a0)
  
  push($ra)
  jal print1
  pop($ra) 

  push($a0)
  push($a1)
  push($a2)
  push($a3)
  push($ra)
  subi $a0, $a0, 1
  move $t0, $a1
  move $a1, $a3
  move $a3, $t0
  jal hanoi
  pop($ra)
  pop($a3)
  pop($a2)
  pop($a1)
  pop($a0)

  push($ra)
  jal print2
  pop($ra) 

  push($a0)
  push($a1)
  push($a2)
  push($a3)
  push($ra)
  subi $a0, $a0, 1
  jal hanoi
  pop($ra)
  pop($a3)
  pop($a2)
  pop($a1)
  pop($a0)

  jr $ra

print1:
  push($a0)
  printstr(s1)
  pop($a0)
  printint($a0)
  push($a0)
  printstr(s2)
  printchar($a1)
  printstr(s3)
  printchar($a2)
  printstr(enter)
  pop($a0)
  jr $ra

print2:
  push($a0)
  printstr(s1)
  pop($a0)
  printint($a0)
  push($a0)
  printstr(s2)
  printchar($a2)
  printstr(s3)
  printchar($a3)
  printstr(enter)
  pop($a0)
  jr $ra

