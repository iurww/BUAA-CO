.macro getint(%des)
  li $v0, 5
  syscall
  move %des, $v0
.end_macro

.macro printuint(%src)
  li $v0, 36
  move $a0, %src
  syscall
.end_macro

.text
  getint($s0)

  li $s1, 0

  li $t0, 1
  fori:
  bgt $t0, $s0, fori_end
    li $s2, 1
    li $t1, 1
    forj:
    bgt $t1, $t0, forj_end

      mul $s2, $s2, $t1

    addi $t1, $t1, 1
    j forj
    forj_end:
  
  addu $s1, $s1, $s2
  addi $t0, $t0, 1
  j fori
  fori_end:
  
  printuint($s1)

  li $v0, 10
  syscall
