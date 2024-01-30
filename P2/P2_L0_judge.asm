.data
  s: .space 100

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

.macro printInt(%src)
  li $v0, 1
  move $a0, %src
  syscall
.end_macro

.macro printChar(%src)
  li $v0, 11
  move $a0, %src
  syscall
.end_macro

.macro end
  li $v0, 10
  syscall
.end_macro

.text
  getInt($s0)

  li $t0, 0
  for_in:
  beq $t0, $s0, for_in_end

  getChar($t1)
  sb $t1, s($t0)
  #printChar($t1)

  addi $t0, $t0, 1  
  j for_in
  for_in_end:

  li $s1, 1

  li $t0, 0
  move $t1, $s0
  subi $t1, $t1, 1 
  for_check:
  bgt $t0, $t1, for_check_end
 
  lb $t2, s($t0)
  lb $t3, s($t1)
  beq $t2, $t3, not
      li $s1, 0
      j out
  not:

  addi $t0, $t0, 1  
  subi $t1, $t1, 1
  j for_check
  for_check_end:

  out:
  printInt($s1)

  end
  
  

