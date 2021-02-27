.data
	size: .word 9
	list: .word 25,19,128,36,56,2,4,5,6
.text

main:
	lw $t0,size		#load the value of size
	lui $at, 0x1001		#load the array
	ori $t1, $at, 36
	addi $t5,$zero,0	#the value of array pointer
	addi $t2,$zero,0 	#the value of i
	addi $t3,$zero,0	#counter=0

	print:#printing the given array without any change
		
		beq $t2,$t0,continue1	#checking whether i<size or not
		lw $t1, list($t5)	#load the value of the array of the index
		
		#print array elements
		add $a0,$zero,$t1
		addi $v0,$zero,1
		syscall
		
		add $a0,$zero,' '	#print space between array elements
		addi $v0,$zero,11	#print space between array elements
		syscall			#print space between array elements
		
		
		addi $t5,$t5,4		#increment array pointer
		addi $t2,$t2,1		#increment counter i

		j print
		
	continue1:
		
		add $a0,$zero,'\n'	#print new line
		addi $v0,$zero,11	#print new line
		syscall			#print new line
		
		#assigning values that are going to be sent to the f_iter procedure
		add $a0,$zero,$t1	#sending the first element in the array
		add $a2,$zero,$t0 	#sending the value of i
		
		jal f_iter 		#calling f_iter procedure
		
		addi $t3,$v0,0		#counter equals to the value returned by the f_iter
		addi $t2,$zero,0 	#clearing the value of i to be able to print the array again.
		addi $t5,$zero,0	#clearing the value of the array pointer

	
	print2:	#printing the array after f_iter procedure performs
	
		beq $t2,$t0,counterprint#checking whether i<size or not
		lw $t1, list($t5)
		
		#print array elements
		add $a0,$zero,$t1
		addi $v0,$zero,1
		syscall
		
		add $a0,$zero,' '	#print space between array elements
		addi $v0,$zero,11	#print space between array elements
		syscall			#print space between array elements
		
		addi $t5,$t5,4		#increment array pointer
		addi $t2,$t2,1		#increment counter i

		j print2	
		
	counterprint:
		
		add $a0,$zero,'\n'	#print new line
		addi $v0,$zero,11	#print new line
		syscall			#print new line
		
		add $a0,$zero,$t3 	#the value of counter after f_iter
		addi $v0,$zero,1
		syscall
		
		add $a0,$zero,'\n'	#print new line
		addi $v0,$zero,11	#print new line
		syscall			#print new line
		
		addi $t2,$zero,0 	#clearing the value of i to be able to print the array again.
		addi $t5,$zero,0

		
		add $a0,$zero,$t1	#sending the value at the array's first position
		add $a2,$zero,$t0	#sending the value of the size
		add $a3,$zero,$t2	#sending the value of the arrayi
	
		jal f_rec
	
		addi $t3,$v0,0		#counter equals to the value returned by the f_rec
		
		addi $t5,$zero,0	#clearing the value of the array pointer
		addi $t2,$zero,0	#clearing the value of the i 
		
		j print3

	print3:	#printing the array after f_rec procedure performs
		
		beq $t2,$t0,counterprint2	#checking whether i<size or not
		lw $t1, list($t5)
		
		#print array elements
		add $a0,$zero,$t1
		addi $v0,$zero,1
		syscall
		

		add $a0,$zero,' '	#print space between array elements
		addi $v0,$zero,11	#print space between array elements
		syscall			#print space between array elements
		
		addi $t5,$t5,4		#increment array pointer
		addi $t2,$t2,1		#increment counter i

		j print3
	
	counterprint2:
		
		add $a0,$zero,'\n'	#print new line
		addi $v0,$zero,11	#print new line
		syscall			#print new line
		
		
		add $a0,$zero,$t3 	#the value of counter after f_rec
		addi $v0,$zero,1
		syscall

				
		#end program
		addi $v0,$zero,10	#return 0;
		syscall
		
f_iter:

	add $t0,$zero,$a2	#size(n)
	add $t1,$zero,$a0	#assigning array start point 
	add $t2,$zero,$a3	# value of i
	addi $t3,$zero,0	#int count = 0;
	addi $t5,$zero,0	#for array pointer
	addi $t6,$zero,2	#for division operations
	
	for:	#for(i=0; i<n; i++)
		#the conditions that clarifies the for loop
		
		lw $t1, list($t5)
		slt $t7,$t2,$t0		#does i is less than size? if i is less than the size,a 1 is written in t7 
		bne $t7,$zero,if	#if t7 is 0,then skip the inside part and return count 
		j end
		
		if:	#if(x[i]%2 == 0)
			
			div $t1,$t6
			mfhi $t4
			beq $t4,$zero,while	#if t4 is equal to 0, then perform the operatons in the while
			j else
			
			while:			#while(x[i] != 0 && x[i]%2 == 0
				div $t1,$t6
				mfhi $t4
				bne $t1,$zero,a			#x[i]!=0
				j continue
				
			a:
			
				beq $t4,$zero,insidewhile	#x[i]%2==0
				j continue
				
				insidewhile:
				
					div $t1,$t6		#x[i]=x[i]/2
					mflo $t1
					sw $t1,list($t5)	#saving the value of the division to the array to provide persistency
					j while
					
				continue:
				
					addi $t3,$t3,1		#counter is incremented
				
					j increment		
		else:
			mult $t1,$t1
			mflo $t1
			sw $t1,list($t5)	#saving the value of the multiplication to the array to provide persistency
			
			j increment
			
		increment:			#i is incremented 
		
			addi $t2,$t2,1		#increment i
			addi $t5,$t5,4		#increment array pointer by 4
			j for
	end:	
		
	
		
		add $v0,$zero,$t3		#return the value of the counter
		jr $ra
		
f_rec:
	add $t0,$zero,$a2		#n/size
	add $t1,$zero,$a0		#array's first element
	add $t2,$zero,$a3		#value of i
	addi $t6,$zero,2		#division constant
	add $t8,$zero,$a3		#array pointer
	addi $t9,$zero,4		#the constant to be able to move array pointer
	mult $t8,$t9			#multiplying i by 4 to be able to handle array pointer
	mflo $t3
	lw $t1,list($t3)		#0th element of the array is loaded
	
	j if_f_rec

	if_f_rec:	#if(i>=n)
		
		beq $t0,$t2,returnzero		#if i and n are equal then return 0
		slt $t4,$t2,$t0			#if i is less than size, then t4=1
		beq $t4,$zero,returnzero	#if t4=0,then return 0

		j ifsecond			#if n is greater than i, then perform the operations in ifsecond
		
		returnzero:		#base case
		
			addi $s0,$zero,0	#add zero to the register
			add $v0,$zero,$s0	#return to the main procedure
			jr $ra
	
	ifsecond:#if(a[i]%2 == 0)
		
		div $t1,$t6			#a[i]%2
		mfhi $t5			#mod operation
		beq $t5,$zero,while_rec		#a[i]%2==0
		j secondelse			#a[i]=0
			
		while_rec:#while(a[i] != 0 && a[i]%2 == 0)
				
			bne $t1,$zero,andwhile	#a[i]!=0
			j first_rec
				
			andwhile:
					
				div $t1,$t6		#a[i]%2
				mfhi $t5		#mod operation
				bne $t5,$zero,first_rec	#a[i]%2!=0
				j arraydiv
				
				arraydiv:
				
					div $t1,$t6 		#a[i] = a[i] / 2;
					mflo $t1
					sw $t1,list($t3)	#saving the value of the division to the array to provide persistency
				
					addi $t3,$t3,4		#increment array pointer by 4
			
		
					j while_rec	#division operation

		first_rec:
		
			addi $sp,$sp,-4		#storing address of the main procedure to the stack
			sw $ra,0($sp)
			
			add $a3,$t2,$zero	#storing the value of i to the stack (t2=i)
			addi $sp,$sp,-4
			sw $a3,0($sp)

			add $a2,$t0,$zero	#storing array size to the stack(t0=size)
			add $sp,$sp,-4
			sw $a2,0($sp)
			
			add $a0,$zero,$t1	#storing the first element of the array to the stack(t1=array's first element)
			add $sp,$sp,-4
			sw $a0,0($sp)
			
			addi $a3,$a3,1		#increment the value of i
			jal f_rec		#making a recursive call
			
			lw $a0,0($sp)		#loading the value of array's first element from the stack
			sw $zero,0($sp)
			addi $sp,$sp,4
			
			lw $a2,0($sp)		#loading the value of size from the stack
			sw $zero,0($sp)
			addi $sp,$sp,4
			
			lw $a3,0($sp)		#loading the value of i from the stack
			sw $zero,0($sp)
			addi $sp,$sp,4
			
			lw $ra,0($sp)		#loading the address of the main procedure from the stack
			sw $zero,0($sp)
			addi $sp,$sp,4
	
			addi $v0,$zero,1
			add $v0,$zero,$v0	#return the value of recursion by adding 1
			jr $ra
			
		secondelse:
		
			mult $t1,$t1		#a[i] = a[i] * a[i];
			mflo $t1		
			sw $t1,list($t3)	#saving the value of the multiplication to the array to provide persistency
			
					
			addi $t3,$t3,4		#increment the array pointer
			j second_rec
			
		second_rec:
		
			addi $sp,$sp,-4		#storing address of the main procedure to the stack
			sw $ra,0($sp)
			
			add $a3,$t2,$zero	#storing the value of i to the stack(t2=i)
			addi $sp,$sp,-4
			sw $a3,0($sp)
			
			add $a2,$t0,$zero	#storing array size to the stack(t0=size)
			add $sp,$sp,-4
			sw $a2,0($sp)
			
			add $a0,$zero,$t1	#storing the first element of the array to the stack(t1=array's first element)
			add $sp,$sp,-4
			sw $a0,0($sp)
			
			addi $a3,$a3,1		#increment the value of i
			jal f_rec		#making a recursive call
			
			lw $a0,0($sp)		#loading the value of array's first element from the stack
			sw $zero,0($sp)
			addi $sp,$sp,4
			
			lw $a2,0($sp)		#loading the value of size from the stack
			sw $zero,0($sp)
			addi $sp,$sp,4
			
			lw $a3,0($sp)		#loading the value of i from the stack
			sw $zero,0($sp)
			addi $sp,$sp,4
			
			lw $ra,0($sp)		#loading the address of the main procedure from the stack
			sw $zero,0($sp)
			addi $sp,$sp,4
			
			addi $v0,$zero,0	
			add $v0,$zero,$v0	#return the value of recursion
			jr $ra
	
