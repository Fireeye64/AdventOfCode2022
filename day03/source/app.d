import std.stdio;

void main() {
	File inputFile = File("input.txt");
	auto range = inputFile.byLine();
	byte[char] duplicateCheck;
	int[char] occurrenceCheck;
	bool foundDuplicate = false;
	long resultSum = 0;
	long resultOccurrence = 0;
	int i = 2;
	foreach (char[] line; range) {
		i = (i + 1) % 3;
		duplicateCheck.clear;
		foundDuplicate = false;
		if (i == 0) {
			occurrenceCheck.clear;
		}
		// Process first half of the line
		foreach(char c; line[0 .. ((line.length-1)/2)]) {
			// Part 1
			duplicateCheck[c] = 1;
			// Part 2 intermediate
			if (c !in occurrenceCheck) {
				occurrenceCheck[c] = 0;
			}
			occurrenceCheck[c] = occurrenceCheck[c] | (1 << i);
		}
		// Process second half of the line
		foreach(char c; line[((line.length-1)/2) .. $-1]) {
			// Part 1
			if ((!foundDuplicate) && (c in duplicateCheck)) {
				foundDuplicate = true;
				long tmp = c - 'a';
				if (tmp < 0) {
					tmp = c - 'A' + 26;
				}
				resultSum += (tmp + 1);
			}
			// Part 2 intermediate
			if (c !in occurrenceCheck) {
				occurrenceCheck[c] = 0;
			}
			occurrenceCheck[c] = occurrenceCheck[c] | (1 << i);
		}
		// Part 2 final
		if (i == 2) {
			foreach(c, value; occurrenceCheck) {
				if (value == 7) {
					long tmp = c - 'a';
					if (tmp < 0) {
						tmp = c - 'A' + 26;
					}
					resultOccurrence += (tmp + 1);
				}
			}
		}
	}
	writeln("My total score for part 1: ", resultSum);
	writeln("My total score for part 2: ", resultOccurrence);

}
