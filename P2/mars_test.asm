.data
num: .word 1 2 3 4
a: .space 20
s: .asciiz "abcdefghi"
enter: .asciiz "\n"

.macro printStr(%str)
  li $v0, 4
  la $a0, %str
  syscall
.end_macro

.macro printInt(%src)
  li $v0, 1
  move $a0, %src
  syscall
.end_macro

.text
  la $t0, num
  lw $t1, 0($t0)
  printInt($t1)
  printStr(enter)
  lw $t1, 4($t0)
  printInt($t1)
  printStr(enter)
  lw $t1, 8($t0)
  printInt($t1)
  printStr(enter)
  