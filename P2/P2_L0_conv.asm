.data
  f: .space 400  #10*10*4
  g: .space 400
  h: .space 400
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
  getInt($s0)    #m1
  getInt($s1)    #n1
  getInt($s2)    #m2
  getInt($s3)    #n2

  li $t0, 0
  inf_i:
  beq $t0, $s0, inf_i_end
  
    li $t1, 0
    inf_j:
    beq $t1, $s1, inf_j_end
      
      getInt($t5)
      getadr($t2, $t0, $t1)
      sw $t5, f($t2)

    addi $t1, $t1, 1
    j inf_j
    inf_j_end:

  addi $t0, $t0, 1
  j inf_i
  inf_i_end:


  li $t0, 0
  inh_i:
  beq $t0, $s2, inh_i_end
  
    li $t1, 0
    inh_j:
    beq $t1, $s3, inh_j_end
      
      getInt($t5)
      getadr($t2, $t0, $t1)
      sw $t5, h($t2)

    addi $t1, $t1, 1
    j inh_j
    inh_j_end:

  addi $t0, $t0, 1
  j inh_i
  inh_i_end:


  sub $s4, $s0, $s2    #m1-m2
  sub $s5, $s1, $s3    #n1-n2


  li $t0, 0
  ci:
  bgt $t0, $s4, ci_end
    
    li $t1, 0
    cj:
    bgt $t1, $s5, cj_end
    
      li $t2, 0
      ck:
      beq $t2, $s2, ck_end
        
        li $t3, 0
        cl:
        beq $t3, $s3, cl_end

          add $t4, $t0, $t2
          add $t5, $t1, $t3
          getadr($t4, $t4, $t5)
          lw $s6, f($t4)    #f[i+k][j+l]

          getadr($t4, $t2, $t3)
          lw $s7, h($t4)    #h[k][l]

          getadr($t4, $t0, $t1)
          lw $t5, g($t4)    #g[i][j]
          
          mul $s6, $s6, $s7
          add $t5, $t5, $s6
          sw $t5, g($t4)
  
        addi $t3, $t3, 1
        j cl
        cl_end:
  
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
  out_i:
  bgt $t0, $s4, out_i_end

    li $t1, 0
    out_j:
    bgt $t1, $s5, out_j_end
      
      getadr($t2, $t0, $t1)
      lw $t3, g($t2)
      printInt($t3)
      printStr(spa)

    addi $t1, $t1, 1
    j out_j
    out_j_end:
  
  printStr(ent)
  addi $t0, $t0, 1
  j out_i
  out_i_end:



  li $v0, 10
  syscall