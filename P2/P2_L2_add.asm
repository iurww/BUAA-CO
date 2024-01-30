.data
a: .space 400
s: .asciiz "The result is:\n"
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

.macro printstr(%str)
  li $v0, 4
  la $a0, %str
  syscall
.end_macro

.macro getadr(%ans, %i, %j)
  mul %ans, %i, 10
  add %ans, %ans, %j
  sll %ans, %ans, 2
.end_macro

.text
  getint($s0)
  getint($s1)

  li $t0, 0
  ina_i:
  beq $t0, $s0, ina_i_end
    
    li $t1, 0
    ina_j:
    beq $t1, $s1, ina_j_end

      getint($t2)
      getadr($t3, $t0, $t1)
      sw $t2, a($t3)

    addi $t1, $t1, 1
    j ina_j
    ina_j_end:

  addi $t0, $t0, 1
  j ina_i
  ina_i_end:


  li $t0, 0
  inb_i:
  beq $t0, $s0, inb_i_end
    
    li $t1, 0
    inb_j:
    beq $t1, $s1, inb_j_end

      getint($t2)
      getadr($t3, $t0, $t1)
      lw $t4, a($t3)
      add $t2, $t2, $t4
      sw $t2, a($t3)

    addi $t1, $t1, 1
    j inb_j
    inb_j_end:

  addi $t0, $t0, 1
  j inb_i
  inb_i_end:

  printstr(s)

  li $t1, 0
  outa_j:
  beq $t1, $s1, outa_j_end
    
    li $t0, 0
    outa_i:
    beq $t0, $s0, outa_i_end

      getadr($t3, $t0, $t1)
      lw $t2, a($t3)
      printint($t2)
      printstr(space)

    addi $t0, $t0, 1
    j outa_i
    outa_i_end:

    printstr(enter)

  addi $t1, $t1, 1
  j outa_j
  outa_j_end:

  li $v0, 10
  syscall


