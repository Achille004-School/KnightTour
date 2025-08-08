#!/usr/bin/env python3
"""
Knight's Tour Output Validator

This script validates the output from the RISC-V Knight's Tour implementation.
It checks if each sequence of moves is a valid knight's tour.

DISCLAIMER: This script is AI-generated and rewiewed by me. But still, do not consider it as my own work.
"""

def parse_moves(move_string):
    """Parse a string of moves like 'a1 c2 e1 d3...' into coordinates"""
    moves = move_string.strip().split()
    coordinates = []
    
    for move in moves:
        if len(move) != 2:
            continue
        col_char = move[0].lower()
        row_char = move[1]
        
        if col_char < 'a' or col_char > 'z' or row_char < '1' or row_char > '9':
            continue
            
        col = ord(col_char) - ord('a')
        row = int(row_char) - 1
        coordinates.append((row, col))
    
    return coordinates

def is_valid_knight_move(pos1, pos2):
    """Check if moving from pos1 to pos2 is a valid knight move"""
    row1, col1 = pos1
    row2, col2 = pos2
    
    row_diff = abs(row1 - row2)
    col_diff = abs(col1 - col2)
    
    # Knight moves: (2,1) or (1,2) in any direction
    return (row_diff == 2 and col_diff == 1) or (row_diff == 1 and col_diff == 2)

def validate_knight_tour(coordinates, board_size):
    """Validate a complete knight's tour"""
    errors = []
    
    # Check if we have the right number of moves
    expected_moves = board_size * board_size
    if len(coordinates) != expected_moves:
        errors.append(f"Expected {expected_moves} moves, got {len(coordinates)}")
        return False, errors
    
    # Check if all positions are within bounds
    for i, (row, col) in enumerate(coordinates):
        if row < 0 or row >= board_size or col < 0 or col >= board_size:
            errors.append(f"Move {i+1}: Position ({row}, {col}) is out of bounds for {board_size}x{board_size} board")
    
    # Check if all positions are unique (visited exactly once)
    visited = set()
    for i, pos in enumerate(coordinates):
        if pos in visited:
            errors.append(f"Move {i+1}: Position {pos} was already visited")
        visited.add(pos)
    
    # Check if we visit all squares
    expected_positions = {(r, c) for r in range(board_size) for c in range(board_size)}
    if visited != expected_positions:
        missing = expected_positions - visited
        extra = visited - expected_positions
        if missing:
            errors.append(f"Missing positions: {missing}")
        if extra:
            errors.append(f"Extra positions: {extra}")
    
    # Check if consecutive moves are valid knight moves
    for i in range(len(coordinates) - 1):
        pos1 = coordinates[i]
        pos2 = coordinates[i + 1]
        if not is_valid_knight_move(pos1, pos2):
            errors.append(f"Move {i+1} to {i+2}: Invalid knight move from {pos1} to {pos2}")
    
    return len(errors) == 0, errors

def format_move(row, col):
    """Convert (row, col) coordinates to chess notation like 'a1'"""
    return chr(ord('a') + col) + str(row + 1)

def print_board(coordinates, board_size):
    """Print a visual representation of the tour on the board"""
    board = [[0 for _ in range(board_size)] for _ in range(board_size)]
    
    for i, (row, col) in enumerate(coordinates):
        if 0 <= row < board_size and 0 <= col < board_size:
            board[row][col] = i + 1
    
    print("Board visualization (numbers show move order):")
    print("   " + " ".join(chr(ord('a') + i) for i in range(board_size)))
    
    for row in range(board_size - 1, -1, -1):
        print(f"{row + 1:2d} ", end="")
        for col in range(board_size):
            if board[row][col] == 0:
                print(" . ", end="")
            else:
                print(f"{board[row][col]:2d} ", end="")
        print()
    print()

def get_board_size():
    """Get the board size from user input"""
    while True:
        try:
            size = int(input("Enter the board size (e.g., 5 for 5x5 board): "))
            if size < 3:
                print("Board size must be at least 3x3. Please try again.")
                continue
            return size
        except ValueError:
            print("Please enter a valid number.")

def get_knight_tour_input(board_size):
    """Get knight tour solutions from user input"""
    print(f"\nEnter your knight's tour solutions for {board_size}x{board_size} board.")
    print("You can enter multiple solutions, one per line.")
    print("Format: a1 c2 e1 d3... (space-separated moves)")
    print("Press Enter on an empty line when done.")
    print()
    
    # Option to load from file
    load_file = input("Do you want to load solutions from a file? (y/n): ").strip().lower()
    if load_file in ['y', 'yes']:
        return load_tours_from_file(board_size)
    
    test_cases = []
    tour_num = 1
    
    while True:
        tour = input(f"Tour #{tour_num} (or press Enter to finish): ").strip()
        if not tour:
            break
        test_cases.append(tour)
        tour_num += 1
    
    if not test_cases:
        print("No tours entered. Exiting.")
        return None, None
    
    return test_cases, board_size

def load_tours_from_file(board_size):
    """Load knight tour solutions from a text file"""
    try:
        filename = input("Enter filename (or press Enter for 'output.txt'): ").strip()
        if not filename:
            filename = "output.txt"
        
        with open(filename, 'r') as file:
            lines = file.readlines()
        
        test_cases = []
        for line in lines:
            line = line.strip()
            # Skip empty lines and lines that look like headers
            if line and not line.startswith("Starting") and not line.startswith("="):
                # Extract just the moves part if there are extra characters
                moves_part = line
                # If the line contains other text, try to extract the moves
                if "a1" in line:
                    start_idx = line.find("a1")
                    moves_part = line[start_idx:].strip()
                test_cases.append(moves_part)
        
        if not test_cases:
            print(f"No valid tours found in {filename}")
            return None, None
        
        print(f"Loaded {len(test_cases)} tours from {filename}")
        return test_cases, board_size
        
    except FileNotFoundError:
        print(f"File {filename} not found. Please try again.")
        return get_knight_tour_input(board_size)
    except Exception as e:
        print(f"Error reading file: {e}")
        return get_knight_tour_input(board_size)

def test_knight_tour_output():
    """Test knight's tour solutions provided by user"""
    
    board_size = get_board_size()
    test_cases, board_size = get_knight_tour_input(board_size)
    
    if test_cases is None:
        return False
    
    print()
    print("=" * 60)
    print("KNIGHT'S TOUR OUTPUT VALIDATION")
    print("=" * 60)
    print()
    
    all_valid = True
    
    for i, moves_string in enumerate(test_cases, 1):
        print(f"Testing Tour #{i}:")
        print(f"Moves: {moves_string}")
        print()
        
        coordinates = parse_moves(moves_string)
        is_valid, errors = validate_knight_tour(coordinates, board_size)
        
        if is_valid:
            print("✅ VALID KNIGHT'S TOUR!")
            print_board(coordinates, board_size)
        else:
            print("❌ INVALID KNIGHT'S TOUR!")
            all_valid = False
            for error in errors:
                print(f"   ❌ {error}")
            print()
        
        print("-" * 40)
        print()
    
    if all_valid:
        print("🎉 ALL TOURS ARE VALID!")
    else:
        print("⚠️ Some tours have issues. Check the errors above.")
    
    return all_valid

def generate_test_script():
    """Generate additional test suggestions"""
    print("Additional test suggestions:")
    print("1. Test with different board sizes by running this script again")
    print("2. Test starting positions (modify STARTING_MOVE in main.s)")
    print("3. Test with invalid inputs to see how your program handles errors")
    print("4. Performance testing with larger boards (6x6, 7x7, 8x8)")
    print("5. Try different starting positions for the same board size")
    print("6. Test edge cases like minimum board size (5x5)")

def main():
    """Main function to run the knight's tour validator"""
    print("🐴♞ Knight's Tour Validator")
    print("==========================")
    print("This tool validates knight's tour solutions for any board size.")
    print()
    
    while True:
        result = test_knight_tour_output()
        
        print()
        again = input("Would you like to test another set of tours? (y/n): ").strip().lower()
        if again not in ['y', 'yes']:
            break
        print()
    
    print("\nThanks for using the Knight's Tour Validator!")
    generate_test_script()

if __name__ == "__main__":
    main()
