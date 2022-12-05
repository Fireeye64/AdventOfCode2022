import benchmark: BenchmarkRunner;
import std.stdio;
import std.range: empty;
import std.array: array, split;
import std.algorithm.sorting: sort;
import std.conv: to;
import std.string: indexOf;

void solve(string[] range) {
	long resultContains = 0;
	long resultOverlap = 0;
	foreach (line; range) {
		if (line.empty) {
			continue;
		}
		//Extract line info
		auto assignments = line.split(",");
		auto firstAssignment = to!(long[])(assignments[0].split("-"));
		auto secondAssignment = to!(long[])(assignments[1].split("-"));
		// Alternative method, much faster but less readable
		/*
		auto first = line.indexOf("-", 0);
		auto second = line.indexOf(",", first);
		auto third = line.indexOf("-", second);
		auto firstAssignment = to!(long[])([line[0..first], line[first+1 .. second]]);
		auto secondAssignment = to!(long[])([line[second+1 .. third], line[third+1 .. $]]);
		*/
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
