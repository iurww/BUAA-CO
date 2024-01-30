.data
  f: .space 4020

.macro getInt(%des)
  li $v0, 5
  syscall
  move %des, $v0
.end_macro

.macro printInt(%src)
  li $v0, 1
  move $a0, %src
  syscall
.end_macro

.text
  getInt($s0)
  li $t0, 1
  sw $t0, f($zero)
  li $t5, 1000000
 
  li $s2, 0
  li $t0, 2
  fori:
  bgt $t0, $s0, fori_end
    
    li $s1, 0

    li $t1, 0
    forj:
    bgt $t1, $s2, forj_end
      
      lw $t3, f($t1)
      mul $t3, $t3, $t0
      add $t3, $t3, $s1

      div $t3, $t5
      mflo $s1
      mfhi $t3

      sw $t3, f($t1)

    addi $t1, $t1, 4
    j forj
    forj_end:

    while:
    beq $s1, 0, while_end
      addi $s2, $s2, 4
      div $s1, $t5
      mflo $s1
      mfhi $t3
      sw $t3, f($s2)
      j while
    while_end:
  
  addi $t0, $t0, 1
  j fori
  fori_end:

  move $t0, $s2
  lw $t1, f($t0)
  printInt($t1)

  subi $t0, $t0, 4
  out:
  blt $t0, 0, out_end

    lw $t1, f($t0)
    jal print

  subi $t0, $t0, 4
  j out
  out_end: 
  

  li $v0, 10
  syscall

print:
  ble $t1, 99999, elseif1
    printInt($t1)
    jr $ra
  elseif1:
  ble $t1, 9999, elseif2
    printInt($zero)
    printInt($t1)
    jr $ra
  elseif2:
  ble $t1, 999, elseif3
    printInt($zero)
    printInt($zero)
    printInt($t1)
    jr $ra
  elseif3:
  ble $t1, 99, elseif4
    printInt($zero)
    printInt($zero)
    printInt($zero)
    printInt($t1)
    jr $ra
  elseif4:
  ble $t1, 9, elseif5
    printInt($zero)
    printInt($zero)
    printInt($zero)
    printInt($zero)
    printInt($t1)
    jr $ra
  elseif5:
    printInt($zero)
    printInt($zero)
    printInt($zero)
    printInt($zero)
    printInt($zero)
    printInt($t1)
    jr $ra

  