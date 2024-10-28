# Dots & Boxes Game in MIPS Assembly

## Description
This project implements the classic Dots & Boxes game in MIPS Assembly language. The game allows two players to connect dots on a board, aiming to complete squares and score points. The program checks for valid moves, updates the board, and tracks player scores until a winner is determined.

### 1. **Sequential Steps Mimicking Pipeline Stages**
   - The game flow follows a structured sequence similar to a pipeline. Each turn involves:
     1. Taking player input,
     2. Validating the input,
     3. Updating the board, and
     4. Displaying the updated board.
   - This order keeps operations smooth, similar to how pipelined processors handle stages in hardware.

### 2. **Minimizing Delays Between Data Loads and Usage**
   - Instructions are arranged to prevent delays by loading values into registers only when needed. This approach reduces potential data conflicts and keeps gameplay responsive.

### 3. **Efficient Branching to Manage Control Flow**
   - Conditional branching, like checking valid moves or switching turns, is optimized to reduce unnecessary jumps. By planning for common scenarios, the game minimizes the delays that would typically occur when branching in a pipeline.

### 4. **Register Management to Avoid Data Dependencies**
   - By assigning specific registers to hold values like scores and board coordinates, the code avoids repeated memory access. This reduces delays, making updates faster and smoother.

### 5. **Structured Function Calls with Stack Usage**
   - The code uses the stack to manage function calls and returns, keeping track of where each function should resume. This prevents control flow interruptions, ensuring the game runs without unexpected jumps.

## Project Structure
- **DBOG.asm**: Main game logic, including score calculation and box verification.
- **Dots&Boxes.asm**: Main entry point, initiating board display and gameplay, and determining the winner.
- **play.asm**: Core gameplay mechanics, validating moves, and managing player turns.
- **printBoard.asm**: Displays the game board in its current state.

## Requirements
- MIPS simulator (e.g., MARS or SPIM) to assemble and execute the code.
- All `.asm` files must be loaded in the simulator.

## Usage
1. Load all `.asm` files in the MIPS simulator.
2. Assemble and run `Dots&Boxes.asm`.
3. Follow the on-screen prompts to play the game.
4. The program will display the game board and announce the winner at the end of gameplay.
