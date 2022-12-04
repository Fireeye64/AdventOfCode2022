import benchmark: BenchmarkRunner;
import std.stdio;
import std.string : strip;
import std.range: empty;
import std.array: array;
import std.algorithm.iteration: splitter;
import std.algorithm.sorting: sort;
import std.conv: to;

void solve(string[] range) {
	long resultContains = 0;
	long resultOverlap = 0;
	foreach (line; range) {
		if (line.strip().empty) {
			continue;
		}
		//Extract line info (Check if you can do it without array conversion later)
		auto assignments = line[0..$-1].splitter(",").array();
		auto firstAssignment = to!(long[])(assignments[0].splitter("-").array());
		auto secondAssignment = to!(long[])(assignments[1].splitter("-").array());
		firstAssignment.sort();
		secondAssignment.sort();
		//Part 1
		if ((firstAssignment[0] >= secondAssignment[0]) && (firstAssignment[1] <= secondAssignment[1]) ||
			(firstAssignment[0] <= secondAssignment[0]) && (firstAssignment[1] >= secondAssignment[1])) {
			resultContains += 1;
		}
		//Part 2
		if (!((secondAssignment[0] > firstAssignment[1]) || (firstAssignment[0] > secondAssignment[1]))) {
			resultOverlap += 1;
		}
	}
	writeln("My answer for part 1: ", resultContains);
	writeln("My answer for part 2: ", resultOverlap);
}

mixin BenchmarkRunner!("input.txt", solve);
