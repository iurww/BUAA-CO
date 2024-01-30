.macro getInt(%des)
  li $v0, 5
  syscall
  move %des, $v0
.end_macro

.macro printInt(%src)
  move $a0, %src
  li $v0, 1
  syscall
.end_macro

.macro push(%src)
  sw %src, 0($sp)
  subi $sp, $sp, 4
.end_macro

.macro pop(%des)
  addi $sp, $sp, 4
  lw %des, 0($sp)
.end_macro

.macro end
  li $v0, 10
  syscall
.end_macro


.text
main:
  getInt($s0)
  
  move $a0, $s0
  jal fac
  move $s1, $v0
  
  printInt($s1)
  end

fac:
  push($a0)
  push($ra)
  
  bne $a0, 1, else 
  if:
    li $v0, 1
    j if_end
  else:
    subi $a0, $a0, 1
    jal fac
  if_end:

  pop($ra)
  pop($a0)
  
  mul $v0, $v0, $a0
  jr $ra
  

    
  
  