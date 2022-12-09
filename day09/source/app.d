import benchmark: BenchmarkRunner;
import std.stdio;
import std.range: empty;
import std.conv : to;
import std.math.algebraic: abs;
import std.algorithm.comparison: clamp;

enum TAIL_LENGTH = 9;

void solve(string[] range) {
	long[2][char] MOVE_VECTORS;
	MOVE_VECTORS['U'] = [ 0, 1];
	MOVE_VECTORS['D'] = [ 0,-1];
	MOVE_VECTORS['R'] = [ 1, 0];
	MOVE_VECTORS['L'] = [-1, 0];
	long[2][TAIL_LENGTH+1] positions = [0, 0];
	long[long[2]] history1;
	long[long[2]] history2;
	foreach (line; range) {
		if (line.empty) {
			continue;
		}
		long[2] tmp_move = MOVE_VECTORS[line[0]];
		long steps = to!long(line[2..$]);
		foreach (_; 0 .. steps) {
			positions[0][] += tmp_move[];
			foreach(i; 1..TAIL_LENGTH+1) {
				long[2] position_diff = positions[i][] - positions[i-1][];
				if ((position_diff[0].abs > 1) || (position_diff[1].abs > 1)) {
						positions[i][0] -= position_diff[0].clamp(-1, 1);
						positions[i][1] -= position_diff[1].clamp(-1, 1);
				}
			}
			history1[positions[1]] = 1;
			history2[positions[TAIL_LENGTH]] = 1;
		}
	}
	writeln("My solution for part 1: ", history1.length);
	writeln("My solution for part 2: ", history2.length);
}

mixin BenchmarkRunner!("input.txt", solve);
