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

.text
  getint($s0)

  li $s1, 1

  li $t0, 2
  for:
  mul $t1, $t0, $t0
  bgt $t1, $s0, for_end
    
    div $s0, $t0
    mfhi $t2
    bnez $t2, true
      li $s1, 0
    true:

  addi $t0, $t0, 1
  j for
  for_end:

  printint($s1)

  li $v0, 10
  syscall