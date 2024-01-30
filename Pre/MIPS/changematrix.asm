.data 
matrix: .space 10000   #50*50*4
ent: .asciiz "\n"
spa: .asciiz " "

.macro getadr(%ans, %i, %j)
    mul %ans, %i, 50        #ans=i*50
    add %ans, %ans, %j      #ans+=j
    sll %ans, %ans, 2       #ans=ans*4
.end_macro


.text
li $v0, 5
syscall
move $s0, $v0        #s0:line
li $v0, 5
syscall
move $s1, $v0        #s1:col

li $t0, 0	#i=0


for1_i:
	beq $t0, $s0, for1_i_end
	li $t1, 0	#j=0
	
	for1_j:
	beq $t1, $s1, for1_j_end

	li $v0, 5
	syscall                    #scanf(t)
	getadr($t2, $t0, $t1)      #address:i*50+j
	sw $v0, matrix($t2)        #matrix[i][j]=t

	addi $t1, $t1, 1           #j=j+1
	j for1_j
	for1_j_end:

addi $t0, $t0, 1           #i=i+1
j for1_i
for1_i_end:

move $t0, $s0	  #i=n
sub $t0, $t0, 1    #i=i-1

for2_i:
	bltz $t0, for2_i_end
	move $t1, $s1	  #j=m
	sub $t1, $t1, 1    #j=j-1
	for2_j:
	bltz $t1, for2_j_end

	getadr($t2, $t0, $t1)      #address:i*50+j
	lw $a0, matrix($t2)        #a0=matrix[i][j]
	beqz $a0, no_output        #a0==0,no output

	li $v0, 1
	move $a0, $t0  
	add $a0, $a0, 1
	syscall
	li $v0, 4
	la $a0, spa
	syscall 

	li $v0, 1
	move $a0, $t1  
	add $a0, $a0, 1
	syscall
	li $v0, 4
	la $a0, spa
	syscall 

	li $v0, 1
	lw $a0, matrix($t2) 
	syscall
	li $v0, 4
	la $a0, ent
	syscall 
 
	no_output:  
    
	sub $t1, $t1, 1           #j=j-1
	j for2_j
	for2_j_end:

sub $t0, $t0, 1           #i=i-1
j for2_i
for2_i_end:

li $v0, 10
syscall
