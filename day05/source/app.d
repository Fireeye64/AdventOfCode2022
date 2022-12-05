import benchmark: BenchmarkRunner;
import std.stdio;
import std.range: empty;
import std.conv : to;
import std.regex;
import std.algorithm.mutation: reverse;
import std.math.rounding: ceil;

void solve(string[] range) {
	char[][] stacks9000;
	char[][] stacks9001;
	long totalStacks = to!long(ceil((range[0].length + 1)/4.));
	long dataStartIdx = 0;
	stacks9000.length = totalStacks;
	stacks9001.length = totalStacks;
	// Move data into stacks
	foreach (x, line; range) {
		if (line == "") {
			dataStartIdx = x + 1;
			break;
		}
		foreach (i; 0 .. totalStacks) {
			long pos = i * 4 + 1;
			if ((line[pos] >= '0') && (line[pos] <= '9')) {
				break;
			}
			if (line[pos] != ' ') {
				stacks9000[i] ~= line[pos];
				stacks9001[i] ~= line[pos];
			}
		}
	}
	// Correct stacks
	foreach(ref x; stacks9000) {
		x.reverse;
	}
	foreach(ref x; stacks9001) {
		x.reverse;
	}
	// Move stacks
	auto ctr = ctRegex!(`move ([0-9]+) from ([0-9]+) to ([0-9]+)`);
	foreach (line; range[dataStartIdx .. $]) {
		if (line.empty) {
			continue;
		}
		auto m = matchFirst(line, ctr);
		if (m.empty) {
			continue;
		}
		long toPop = to!long(m[1]);
		long source = to!long(m[2]) - 1;
		long target = to!long(m[3]) - 1;
		stacks9000[source][$ - toPop .. $].reverse;
		stacks9000[target] ~= stacks9000[source][$ - toPop .. $];
		stacks9001[target] ~= stacks9001[source][$ - toPop .. $];
		stacks9000[source].length -= toPop;
		stacks9001[source].length -= toPop;
	}
	write("My solution for part 1: ");
	foreach(s; stacks9000) {
		write(s[$-1]);
	}
	write("\n");
	write("My solution for part 2: ");
	foreach(s; stacks9001) {
		write(s[$-1]);
	}
	write("\n");
}

mixin BenchmarkRunner!("input.txt", solve);
