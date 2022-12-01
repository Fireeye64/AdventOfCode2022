import std.stdio;
import std.string : strip;
import std.range: empty;
import std.algorithm.searching: maxElement;
import std.conv : to;

long[] caloriesTotalList;

void main() {
	long tmpCalories = 0;
	File inputFile = File("input.txt");
	auto range = inputFile.byLine();
	foreach (line; range) {
		if ((line.strip().empty) && (tmpCalories > 0)) {
			caloriesTotalList ~= tmpCalories;
			tmpCalories = 0;
		} else {
			tmpCalories += to!long(line.strip());
		}
	}
	if (caloriesTotalList.length > 0) {
		writeln(maxElement(caloriesTotalList));
	}
}
