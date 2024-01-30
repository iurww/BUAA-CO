.data
  a: .space 400  #10*10*4
  b: .space 400
  c: .space 400
  spa: .asciiz " "
  ent: .asciiz "\n"
            
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

.macro printStr(%str)
  li $v0, 4
  la $a0, %str
  syscall
.end_macro

.macro getadr(%res, %i, %j)
  mul %res, %i, 10
  add %res, %res, %j
  sll %res, %res, 2
.end_macro

.text
  getInt($s0)
  
  li $t0, 0
  for_ini1:
  beq $t0, $s0, for_ini1_end
   
    li $t1, 0
    for_inj1:
    beq $t1, $s0, for_inj1_end
    
      getInt($t5)
      getadr($t2, $t0, $t1)
      sw $t5, a($t2)
 
    addi $t1, $t1, 1
    j for_inj1 
    for_inj1_end:

  addi $t0, $t0, 1
  j for_ini1 
  for_ini1_end:


  li $t0, 0
  for_ini2:
  beq $t0, $s0, for_ini2_end
   
    li $t1, 0
    for_inj2:
    beq $t1, $s0, for_inj2_end
    
      getInt($t5)
      getadr($t2, $t0, $t1)
      sw $t5, b($t2)
 
    addi $t1, $t1, 1
    j for_inj2 
    for_inj2_end:

  addi $t0, $t0, 1
  j for_ini2 
  for_ini2_end:


  li $t0, 0
  ci:
  beq $t0, $s0, ci_end
   
    li $t1, 0
    cj:
    beq $t1, $s0, cj_end
    
      li $t2, 0
      ck:
      beq $t2, $s0, ck_end
        getadr($t3, $t0, $t2)
        lw $s2, a($t3)
        getadr($t3, $t2, $t1)
        lw $s3, b($t3)
        getadr($t3, $t0, $t1)
        lw $s1, c($t3)

        mul $s2, $s2, $s3
        add $s1, $s1, $s2
        
        sw $s1, c($t3)
 
      addi $t2, $t2, 1
      j ck 
      ck_end:
 
    addi $t1, $t1, 1
    j cj 
    cj_end:

  addi $t0, $t0, 1
  j ci 
  ci_end:

  li $t0, 0
  outi:
  beq $t0, $s0, outi_end
   
    li $t1, 0
    outj:
    beq $t1, $s0, outj_end
    
      getadr($t2, $t0, $t1)
      lw $t3, c($t2)
      printInt($t3)
      printStr(spa)

    addi $t1, $t1, 1
    j outj
    outj_end:

  printStr(ent)  
  addi $t0, $t0, 1
  j outi 
  outi_end:

  

  li $v0, 10
  syscall