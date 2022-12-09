import benchmark: BenchmarkRunner;
import std.stdio;
import std.range: empty;
import std.algorithm.searching: maxElement;
import std.conv : to;
import std.algorithm.sorting: sort;
import std.algorithm.iteration: sum;

void solve(string[] range) {
	ulong[] results;
	ulong[] results2;
	foreach (line; range) {
		if (line.length < 4) {
			continue;
		}
		// Init char counter
		for(int i = 0; i < line.length-4; ++i) {
			byte[char] tmp;
			for (int j = 0; j < 4; ++j) {
				tmp[line[i+j]] = 1;
			}
			if (tmp.length == 4) {
				results ~= (i + 4);
				break;
			}
		}
		
		for(int i = 0; i < line.length-4; ++i) {
			byte[char] tmp;
			for (int j = 0; j < 14; ++j) {
				tmp[line[i+j]] = 1;
			}
			if (tmp.length == 14) {
				results2 ~= (i + 14);
				break;
			}
		}
		
	}
	
	writeln("My solution for part 1: ", results[0]);
	writeln("My solution for part 2: ", results2[0]);
	
}

mixin BenchmarkRunner!("input.txt", solve);
