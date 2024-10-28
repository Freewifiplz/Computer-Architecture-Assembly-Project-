.data
board: .asciiz "  123456789        \na . . . . . . . . .\nb . . . . . . . . .\nc . . . . . . . . .\nd . . . . . . . . .\ne . . . . . . . . .\nf . . . . . . . . .\ng . . . . . . . . .\n"
.text
printBoard: 
	li $t0,0	#  int i =0 -> number of rows must be less than 8 CHARACTERS (includes letter, spaces, & dots)
	for1:						
		beq $t0,8,endfor1           #   if (i==7)    exit outer for loop
		li $t1,0			 #   int j=0 -> number of columns must be less than 20 CHARACTERS (includes number, spaces, & dots)
		for2:
			beq $t1,20,endfor2		# if (j==20)    exit inner for loop
			mul $t3,$t0,20			
			add $t3,$t3,$t1			
			lb $t4,board($t3)		#  board[i][j]
			
			li $v0,11				# print   board[i][j]
			move $a0,$t4
			syscall
			
			addi $t1,$t1,1		# j++
			j for2			# jumps to the beginning of nested for loop after incrementing j
		endfor2:
		addi $t0,$t0,1			# i++
		j for1				# jumps to the beginning of orignal for loop after incremeting i
	endfor1:
	jr $ra
