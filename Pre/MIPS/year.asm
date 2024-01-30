.text
li $v0 5
syscall
move $s0, $v0

li $t1, 4
li $t2, 100
li $t3, 400

check:
div $s0, $t1
mfhi $t0
bgt $t0, 0, false
nop

check1:
div $s0, $t2
mfhi $t4
div $s0, $t3
mfhi $t5
bgt $t4, 0, true
beq $t5, 0, true
j false

false:
li $a0, 0
li $v0, 1
syscall
j end

true:
li $a0, 1
li $v0, 1
syscall
j end

end:
li $v0, 10
syscall
