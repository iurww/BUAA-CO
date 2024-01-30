.data
a: .space 420
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

  li $t0, 1
  li $t2, 1
  reset:
  bgt $t0, $s0, reset_end
    sll $t1, $t0, 2
    sw $t2, a($t1)
  addi $t0, $t0, 1
  j reset
  reset_end:


  move $s2, $zero
  move $s3, $s0
  while:
  beq $s3, 0, while_end

    li $t0, 1
    for:
    bgt $t0, $s0, for_end

      sll $t1, $t0, 2
      lw $t2, a($t1)

      beq $t2, 0, not_count
        addi $s2, $s2, 1
        bne $s2, $s1, not_count
          sw $zero, a($t1)
          li $s2, 0
          subi $s3, $s3, 1
          printint($t0)
          printstr(enter)

      not_count:

    addi $t0, $t0, 1
    j for
    for_end:
  j while
  while_end:

  li $v0, 10
  syscall