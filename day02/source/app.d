import std.stdio;

void main() {
	File inputFile = File("input.txt");
	auto range = inputFile.byLine();
	long totalScoreAction = 0;
	long totalScoreOutcome = 0;
	foreach (char[] line; range) {
		if (line.length == 4) {
			int myChoice = line[2] - 'X';
			int opponentChoice = line[0] - 'A';
			// Part 1
			totalScoreAction += (myChoice + 1);
			if (opponentChoice == myChoice) {
				totalScoreAction += 3;
			} else if ((opponentChoice + 1) % 3 == myChoice) {
				totalScoreAction += 6;
			}
			//Part 2
			totalScoreOutcome += (myChoice * 3) + 1;
			if (myChoice == 2) {
				totalScoreOutcome += (opponentChoice + 1) % 3;
			} else if (myChoice == 1) {
				totalScoreOutcome += opponentChoice;
			} else {
				totalScoreOutcome += (opponentChoice + 2) % 3;
			}
		} else {
			writeln("Encountered mismatched line: '", line, "'");
		}
	}
	writeln("My total score for part 1: ", totalScoreAction);
	writeln("My total score for part 2: ", totalScoreOutcome);
}
