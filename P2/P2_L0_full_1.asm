.data
ans: .space 40
vis: .space 40
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

.macro push(%src)
  subi $sp, $sp, 4
  sw %src, 0($sp)
.end_macro

.macro pop(%des)
  lw %des, 0($sp)
  addi $sp, $sp, 4
.end_macro

.text
main:
  li $t9, 1

  getInt($s0)
  move $a1, $zero,
  jal dfs

  li $v0, 10
  syscall


dfs:
  bne $a1, $s0, notout

    li $t0, 0
    out:
    beq $t0, $s0, out_end

        sll $t1, $t0, 2
        lw $t2, ans($t1)
        printInt($t2)
        printStr(spa)

    addi $t0, $t0, 1
    j out
    out_end:
    printStr(ent)
    jr $ra

  notout:

  li $t0, 1
  search:
  bgt $t0, $s0, search_end
   
    sll $t1, $t0, 2
    lw $t2, vis($t1)
    beq $t2, 1, notdfs
    
    sw $t9, vis($t1)

    sll $t1, $a1, 2
    sw $t0, ans($t1)

    push($a1)
    push($t0)
    push($ra)
    add $a1, $a1, 1
    jal dfs
    pop($ra)
    pop($t0)
    pop($a1)

    sll $t1, $t0, 2
    sw $zero, vis($t1)

    notdfs:


  addi $t0, $t0, 1
  j search
  search_end:

  jr $ra
  