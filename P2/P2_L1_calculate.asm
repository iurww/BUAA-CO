.data
h: .space 404
c: .space 404
space: .asciiz " "
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

.macro getchar(%des)
  li $v0, 12
  syscall
  move %des, $v0
.end_macro

.macro printchar(%src)
  li $v0, 11
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
  li $s1, 0

  li $t0, 0
  in:
  beq $t0, $s0, in_end
    getchar($t7) 
    li $s2, 0

    li $t1, 1
    find:
    bgt $t1, $s1, find_end
      
      sll $t2, $t1, 2
      lw $t3, h($t2)
      bne $t3, $t7, notadd
        lw $t4, c($t2)
        addi $t4, $t4, 1
        sw $t4, c($t2)
        li $s2, 1
        j find_end
      notadd:
      
    addi $t1, $t1, 1
    j find
    find_end:
    bne $s2, 0, notaddnew
      addi $s1, $s1, 1
      sll $t2, $s1, 2
      sw $t7, h($t2)
      li $t3, 1
      sw $t3, c($t2)
    notaddnew:
    
  addi $t0, $t0, 1
  j in
  in_end:

  li $t0, 1
  out:
  bgt $t0, $s1, out_end
    sll $t2, $t0, 2
    lw $t1, h($t2)
    printchar($t1)
    printstr(space)
    lw $t1, c($t2)
    printint($t1)
    printstr(enter)
  addi $t0, $t0, 1
  j out
  out_end:

  li $v0, 10
  syscall