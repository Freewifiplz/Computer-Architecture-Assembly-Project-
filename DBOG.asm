# Navid Alvey
# Dots & Boxes Project
# CS 2340.004
# Nhut Nguyen
# 4/27/23


# Make sure to select: Settings > Assemble all files in directory
.data					   
gameBoard: .asciiz "  123456789        \na . . . . . . . . .\nb . . . . . . . . .\nc . . . . . . . . .\nd . . . . . . . . .\ne . . . . . . . . .\nf . . . . . . . . .\ng . . . . . . . . .\n"
message1: .asciiz "\nEnter coordinate of the first dot: "
message2: .asciiz "\nEnter coordinate of the second dot: "
store: .space 4
firstRow: .space 4
firstColumn: .space 4
secondRow: .space 4
secondColumn: .space 4
message3: .asciiz "Coordinates must be adjacent\n"
message4: .asciiz "There is already a line there.\n"
space: .byte ' '
underscore: .byte '_'
line: .byte '|'
H: .byte 'H'
C: .byte 'C'

iteration: .word 1
randomValue: .word 1
prev: .word 0
isFirstMove: .word 1

yourScore: .word 0
myScore: .word 0

player: .asciiz "player:\n"
CPU: .asciiz "CPU:\n"

p1: .asciiz "\nplayer  wins!!\n"
p2: .asciiz "\nCPU wins!!\n"
.text

main:
	
	jal printBoard # Jump and link to the printBoard function to print the game gameBoard
	
	jal play # Jump and link to the play function to play the game
	
	jal printBoard # Jump and link to the printBoard function to print the updated game gameBoard after playing the game
	
	lw $t0,yourScore # Load the value of the yourScore variable into temporary register $t0.
	
	lw $t1,myScore # Load the value of the myScore variable into temporary register $t1.
	
	bgt $t0,$t1,who  # Branch and go to the label who if the value in $t0 is greater than the value in $t1.
	
		li $v0,4 # Load the value 4 into register $v0, which indicates the "print storeing" system call.
		la $a0,p1 #Load the address of the storeing "p1" into register $a0, which will be printed by the system call.
		syscall 
	j whopass
	who:
		li $v0,4
		la $a0,p2
		syscall
	whopass:
	
	li $v0,10
	syscall

# Create 2D array with for loop	 (TAKE INTO ACCOUNT THE NUMBER OF CHARACTERS IN EACH ROW/COLUMN NOT JUST DOTS)
# for (i = 0; i < 8; i++)
	# for (j = 0; j < 20; j++)
printBoard: 
	li $t0,0	#  int i =0 -> number of rows must be less than 8 CHARACTERS (includes letter, spaces, & dots)
	for1:						
		beq $t0,8,endfor1           #   if (i==7)    exit outer for loop
		li $t1,0			 #   int j=0 -> number of columns must be less than 20 CHARACTERS (includes number, spaces, & dots)
		for2:
			beq $t1,20,endfor2		# if (j==20)    exit inner for loop
			mul $t3,$t0,20			
			add $t3,$t3,$t1			
			lb $t4,gameBoard($t3)		#  gameBoard[i][j]
			
			li $v0,11				# print   gameBoard[i][j]
			move $a0,$t4
			syscall
			
			addi $t1,$t1,1		# j++
			j for2			# jumps to the beginning of nested for loop after incrementing j
		endfor2:
		addi $t0,$t0,1			# i++
		j for1				# jumps to the beginning of orignal for loop after incremeting i
	endfor1:
	jr $ra
########### END OF printBoard

play:
# Decide who's turn it is		
	while:
	lw $t0,iteration
	bgt $t0,24,endWhile
	 
	li $t7,2
	div $t0,$t7
	mfhi $t7
	beqz $t7,turn # if the value in register $t7 is equal to zero (ie. if the current iteration count is even) it is player 2's turn
# If the value in register $t7 is not equal to zero (ie. if the current iteration count is odd) it is player 1's turn
	# Output player 1
		li $v0,4
		la $a0,player
		syscall
		
		j turn_over
		
	# Output player 2
	turn:
		li $v0,4
		la $a0,CPU
		syscall
	turn_over:
	#  read the first dot
	# Output "Enter coordinate of the first dot:"
	li $v0,4
	la $a0,message1
	syscall
	
	li $v0,8
	la $a0,store
	li $a1,4
	syscall
	
	#convert storeing to firstRow and firstColumn
	li $t0,0				
	lb $t0,store($t0)			
	addi $t0,$t0,-96	# subtract 97 to map 'a' to 0, 'b' to 1, and so on
	sb $t0,firstRow				
	
	li $t0,1
	lb $t0,store($t0)
	sub $t0, $t0, '0' 	# convert ASCII digit to actual number
	sb $t0,firstColumn
	
	# read the second dot
	# Output "Enter coordinate of the seecond dot:"
	li $v0,4
	la $a0,message2
	syscall
	
	li $v0,8
	la $a0,store
	li $a1,4
	syscall
	
	#convert storeing to secondRow and secondColumn
	li $t0,0
	lb $t0,store($t0)
	addi $t0,$t0,-96	# subtract 97 to map 'a' to 0, 'b' to 1, and so on
	sb $t0,secondRow
	
	li $t0,1
	lb $t0,store($t0)
	sub $t0, $t0, '0'		# convert ASCII digit to actual number
	sb $t0,secondColumn
	
	##################### --------------------------- LOGICAL PROGRAMMING-----------------------------
	
	lb $t0,firstRow
	lb $t1,secondRow
	lb $t2,firstColumn
	lb $t3,secondColumn
	
	bne $t0,$t1,else1
		
		addi $t4,$t3,1
		subi $t5,$t3,1
		
		beq $t2,$t4,col_adjacent
		bne $t2,$t5,else3
		col_adjacent:
			blt $t2,$t3,min
			move $t4,$t3
			j min_found
			min: move $t4,$t2		## ## ##   $t4 = min($t2,$t3)
			min_found:
			
			# if( gameBoard[firstRow][min*2+1]==' ')
			mul $t5,$t0,20			##  $t5 = firstRow*20    for getting the row number
			
			mul $t9,$t4,2			# $t9=min*2
			addi $t9,$t9,1			# $t9= min*2+1
			
			add $t6,$t5,$t9			#####  $t6= gameBoard(firstRow*20+(min*2+1))
			
			lb $t7,gameBoard($t6)		# $t7= gameBoard($t6)
			
			lb $t8,space
			bne $t7,$t8,else4		## if( $t7 !=$t8) go to else4
				
				lb $t8,underscore
				sb $t8,gameBoard($t6)
				
				##  if( firstRow!=4)
				beq $t0,4,check_upper_box
					addi $t5,$t0,1
					mul $t5,$t5,10		### $t5=firstRow+1
					
					mul $t9,$t4,2		# $t9=min*2
					add $t6,$t5,$t9     # address of  gameBoard[row+1][min*2]
					
					lb $t7,gameBoard($t6)
					lb $t8,line
					
					bne $t7,$t8,check_upper_box
					
					add $t9,$t9,1  		#$t9=min*2+1
					add $t6,$t5,$t9			# address of  gameBoard[row+1][min*2+1]
					
					lb $t7,gameBoard($t6)
					lb $t8,underscore
					
					bne $t7,$t8,check_upper_box
					
					add $t9,$t9,1
					add $t6,$t5,$t9			# address of  gameBoard[row+1][min*2+2]
					
					lb $t7,gameBoard($t6)
					lb $t8,line
					
					bne $t7,$t8,check_upper_box
						add $t9,$t9,-1
						add $t6,$t5,$t9			# address of  gameBoard[row+1][min*2+1]
						
						####  if(iteration%2==0)
						lw $t8,iteration
						li $t7,2
						div $t8,$t7
						mfhi $t8
						
						bnez $t8,fill_with_C1
							lb $t7,H
							sb $t7,gameBoard($t6)
							
							lw $t7,yourScore
							addi $t7,$t7,1
							sw $t7,yourScore
							
							j check_upper_box
						fill_with_C1:
							lb $t7,C
							sb $t7,gameBoard($t6)
							
							lw $t7,myScore
							addi $t7,$t7,1
							sw $t7,myScore
						
					
				check_upper_box:
				## if( firstRow !=1)
				beq $t0,1,upper_box_checking_finished
					mul $t5,$t0,10
					mul $t9,$t4,2
					add $t6,$t5,$t9
					lb $t7,gameBoard($t6)
					lb $t8,line
					
					bne $t7,$t8,upper_box_checking_finished
					addi $t9,$t9,2	
					add $t6,$t5,$t9
					lb $t7,gameBoard($t6) 
					lb $t8,line
					
					bne $t7,$t8,upper_box_checking_finished
					addi $t5,$t0,-1
					mul $t5,$t5,10
					mul $t9,$t4,2
					addi $t9,$t9,1
					add $t6,$t5,$t9
					lb $t7,gameBoard($t6) 
					lb $t8,space
					
					beq $t7,$t8,upper_box_checking_finished
						mul $t5,$t0,10
						add $t6,$t5,$t9
						
						####  if(iteration%2==0)
						lw $t8,iteration
						li $t7,2
						div $t8,$t7
						mfhi $t8
						
						bnez $t8,fill_with_C2
							lb $t7,H
							sb $t7,gameBoard($t6)
							
							lw $t7,yourScore
							addi $t7,$t7,1
							sw $t7,yourScore
							
							j upper_box_checking_finished
						fill_with_C2:
							lb $t7,C
							sb $t7,gameBoard($t6)
							
							lw $t7,myScore
							addi $t7,$t7,1
							sw $t7,myScore
						
				upper_box_checking_finished:
				
				####  call  printBoard
				addi $sp,$sp,-4
				sw $ra,4($sp)
				
				jal printBoard
				
				lw $ra,4($sp)
				addi $sp,$sp,4
				
				#####   iteration++  
				lw $t0,iteration
				addi $t0,$t0,1
				sw $t0,iteration
				
				j next
			else4:
				li $v0,4
				la $a0,message4
				syscall
				j next
		else3:
		li $v0,4
		la $a0,message3
		syscall
		
		j next
	else1:
		bne $t2,$t3,coor_not_adjacent   #if(firstColumn!=secondColumn) goto coor_not_adjacent 	if firstColumn and secondColumn are the same = |
		addi $t4,$t1,1
		addi $t5,$t1,-1
		beq $t0,$t4,row_equal
		bne $t0,$t5,coor_not_adjacent
		row_equal:
			bgt $t0,$t1,max
			move $t4,$t1
			j max_found
			max: move $t4,$t0             ###  $t4=max($t0,$t1)
			max_found:
			
			mul $t5,$t4,20     		###  $t5= max*10         
			mul $t9,$t2,2                #  $t9 =$t2*2
			
			add $t6,$t5,$t9             #### address in gameBoard element
			
			lb $t7,gameBoard($t6)
			lb $t8,line
			
			beq $t7,$t8,line_there
				sb $t8,gameBoard($t6)
				
				# if(firstColumn!=4)
				beq $t2,4,check_left_box
					addi $t9,$t9,1
					add $t6,$t5,$t9
					lb $t7,gameBoard($t6)
					lb $t8,underscore
					
					bne $t7,$t8,check_left_box
					
					subi $t5,$t4,1
					mul $t5,$t5,10
					add $t6,$t5,$t9
					lb $t7,gameBoard($t6)
					lb $t8,space
					
					beq $t7,$t8,check_left_box 
					
					mul $t5,$t4,10
					addi $t9,$t9,1
					add $t6,$t5,$t9
					lb $t7,gameBoard($t6)
					lb $t8,line
					
					bne $t7,$t8,check_left_box
						addi $t9,$t9,-1
						add $t6,$t5,$t9
						
						####  if(iteration%2==0)
						lw $t8,iteration
						li $t7,2
						div $t8,$t7
						mfhi $t8
						
						bnez $t8,fill_with_C3
							lb $t7,H
							sb $t7,gameBoard($t6)
							
							lw $t7,yourScore
							addi $t7,$t7,1
							sw $t7,yourScore
							
							j check_left_box
						fill_with_C3:
							lb $t7,C
							sb $t7,gameBoard($t6)
							
							lw $t7,myScore
							addi $t7,$t7,1
							sw $t7,myScore
				
				check_left_box:
				# if(firstColumn!=1)
				beq $t2,1,checking_left_box_finished
					mul $t5,$t4,10
					mul $t9,$t2,2
					addi $t9,$t9,-1
					add $t6,$t5,$t9
					lb $t7,gameBoard($t6)
					lb $t8,underscore
					
					bne $t7,$t8,checking_left_box_finished
					
					addi $t5,$t4,-1
					mul $t5,$t5,10
					add $t6,$t5,$t9
					lb $t7,gameBoard($t6)
					lb $t8,space
					
					beq $t7,$t8,checking_left_box_finished
					
					mul $t5,$t4,10
					addi $t9,$t9,-1
					add $t6,$t5,$t9
					lb $t7,gameBoard($t6)
					lb $t8,line
					
					bne $t7,$t8,checking_left_box_finished
						addi $t9,$t9,1
						add $t6,$t5,$t9
						
						####  if(iteration%2==0)
						lw $t8,iteration
						li $t7,2
						div $t8,$t7
						mfhi $t8
						
						bnez $t8,fill_with_C4
							lb $t7,H
							sb $t7,gameBoard($t6)
							
							lw $t7,yourScore
							addi $t7,$t7,1
							sw $t7,yourScore
							
							j checking_left_box_finished
						fill_with_C4:
							lb $t7,C
							sb $t7,gameBoard($t6)
							
							lw $t7,myScore
							addi $t7,$t7,1
							sw $t7,myScore
				    
				checking_left_box_finished:
				
				####  call  printBoard
				addi $sp,$sp,-4
				sw $ra,4($sp)
				
				jal printBoard
				
				lw $ra,4($sp)
				addi $sp,$sp,4
				
				
				#####   iteration++  
				lw $t0,iteration
				addi $t0,$t0,1
				sw $t0,iteration
				
				j next
			line_there:
				li $v0,4
				la $a0,message4
				syscall
				j next
		coor_not_adjacent:
			li $v0,4
			la $a0,message3
			syscall
	next:
	j while
	
	endWhile:
	jr $ra