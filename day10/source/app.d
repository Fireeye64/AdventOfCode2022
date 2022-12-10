import benchmark: BenchmarkRunner;
import std.stdio;
import std.range: empty;
import std.conv : to;
import std.algorithm.iteration: sum;

enum STRENGTH_CYCLE_BASE = 20;
enum STRENGTH_CYCLE_LENGTH = 40;
enum CRT_SYMBOLS = 40;
enum CRT_LINES = 6;
enum SPRITE_LENGTH = 3;

void solve(string[] range) {
	long cycle = 1;
	long register = 1;
	long[] signal_strengths;
	long[string] execution_duration;
	execution_duration["noop"] = 1;
	execution_duration["addx"] = 2;
	char[STRENGTH_CYCLE_LENGTH][CRT_LINES] crt_output;
	foreach(i; 0..CRT_LINES) {
		crt_output[i][] = ' ';
	}
	foreach (line; range) {
		if (line.empty) {
			continue;
		}
		string instruction = line[0..4];
		long cycles_left_till_spike = STRENGTH_CYCLE_LENGTH - ((cycle - STRENGTH_CYCLE_BASE) % STRENGTH_CYCLE_LENGTH);
		if (cycles_left_till_spike > STRENGTH_CYCLE_LENGTH) {
			cycles_left_till_spike -= STRENGTH_CYCLE_LENGTH;
		}
		if ((cycles_left_till_spike == STRENGTH_CYCLE_LENGTH) || (cycles_left_till_spike < execution_duration[instruction])) {
			if (cycles_left_till_spike < STRENGTH_CYCLE_LENGTH) {
				signal_strengths ~= (cycle + cycles_left_till_spike) * register;
			} else {
				signal_strengths ~= cycle * register;
			}
		}
		foreach (i; 0 .. execution_duration[instruction]) {
			if (((cycle+i) % CRT_SYMBOLS >= register) && ((cycle+i) % CRT_SYMBOLS) < register + SPRITE_LENGTH ) {
				crt_output[(cycle+i-1)/40][((cycle+i-1) % CRT_SYMBOLS)] = '#';
			}
		}
		if (instruction == "addx") {
			register += to!long(line[5..$]);
		}
		cycle += execution_duration[instruction];
	}
	writeln("My solution for part 1: ", signal_strengths.sum);
	writeln("My solution for part 2:");
	foreach (crt_line; crt_output) {
		writeln(crt_line);
	}
}

mixin BenchmarkRunner!("input.txt", solve);
