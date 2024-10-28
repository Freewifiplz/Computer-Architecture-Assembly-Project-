# Navid Alvey
# Dots & Boxes Project
# CS 2340.004
# Nhut Nguyen
# 4/27/23


# Make sure to select: Settings > Assemble all files in directory

.include "play.asm"

.text

main:
	
	jal printBoard # Jump and link to the printBoard function to print the game board
	
	jal play # Jump and link to the play function to play the game
	
	jal printBoard # Jump and link to the printBoard function to print the updated game board after playing the game
	
	lw $t0,yourScore # Load the value of the yourScore variable into temporary register $t0.
	

	
	lw $t1,myScore # Load the value of the myScore variable into temporary register $t1.
	
	
	
	bgt $t0,$t1,who  # Branch and go to the label who if the value in $t0 is greater than the value in $t1.
	

	
		li $v0,4 # Load the value 4 into register $v0, which indicates the "print string" system call.
		la $a0,p1 #Load the address of the string "p1" into register $a0, which will be printed by the system call.
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
