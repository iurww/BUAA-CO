.data
a: .space 4020
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
  
  li $t0, 1
  in:
  bgt $t0, $s0, in_end
    getint($t1)
    sll $t2, $t0, 2
    sw $t1, a($t2)
  addi $t0, $t0, 1
  j in
  in_end:

  getint($s1)
  
  li $t0, 1
  out:
  bgt $t0, $s1, out_end
    getint($t1)
    jal bs
    printint($s2)
    printstr(enter)
  addi $t0, $t0, 1
  j out
  out_end:

  li $v0, 10
  syscall

bs:
  li $s2, 0
  li $t4, 1
  move $t5, $s0
  while:
  bgt $t4, $t5, while_end
    add $t3, $t4, $t5
    srl $t3, $t3, 1
    sll $t6, $t3, 2
    lw $t7, a($t6)
    bge $t7, $t1, elif
      add $t4, $t3, 1
      j else_end
    elif:
    ble $t7, $t1, else
      sub $t5, $t3, 1
      j else_end
    else:
      li $s2, 1
      jr $ra
    else_end:
  j while
  while_end:
  jr $ra
  