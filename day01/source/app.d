import std.stdio;
import std.string : strip;
import std.range: empty;
import std.algorithm.searching: maxElement;
import std.conv : to;
import std.algorithm.sorting: sort;
import std.algorithm.iteration: sum;

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
	caloriesTotalList.sort!("a > b");
	if (caloriesTotalList.length > 0) {
		writeln("Highest calorie count: ", caloriesTotalList[0]);
	}
	if (caloriesTotalList.length > 3) {
		writeln("Total of top 3 elements: ", sum(caloriesTotalList[0..3]));
	}
}
