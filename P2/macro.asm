.data
num: .word 1 2 3 4

.macro getInt(%des)
  li $v0, 5
  syscall 
  move %des, $v0
.end_macro

.macro getChar(%des)
  li $v0, 12
  syscall
  move %des, $v0
.end_macro

.macro getStr(%des, %len)
  li $v0, 8
  la $a0, %des
  addi %len, %len, 1
  move $a1, %len
  syscall 
.end_macro

.macro printInt(%src)
  li $v0, 1
  move $a0, %src
  syscall
.end_macro

.macro printuint(%src)
  li $v0, 36
  move $a0, %src
  syscall
.end_macro

.macro printChar(%src)
  li $v0, 11
  move $a0, %src
  syscall
.end_macro

.macro printStr(%str)
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

.macro getadr(%ans, %i, %j)
    mul %ans, %i, 50        #ans=i*50
    add %ans, %ans, %j      #ans+=j
    sll %ans, %ans, 2       #ans=ans*4
.end_macro

.macro end
  li $v0, 10
  syscall
.end_macro