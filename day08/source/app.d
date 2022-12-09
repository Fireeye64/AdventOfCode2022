import benchmark: BenchmarkRunner;
import std.stdio;
import std.range: empty, transposed;
import std.array;
import std.conv: to;

char[] buildPlateauArray(ref char[] row) {
	ulong l = row.length;
	char[] left_to_right;
	char[] right_to_left;
	char[] result;
	left_to_right.length = l;
	right_to_left.length = l;
	result.length = l;
	foreach (i; 0 .. l) {
		if (i == 0) {
			left_to_right[i] = row[i];
			right_to_left[l-i-1] = row[l-i-1];
			continue;
		}
		if (row[i] > left_to_right[i-1]) {
			left_to_right[i] = row[i];
		} else {
			left_to_right[i] = left_to_right[i-1];
		}
		if (row[l-i-1] > right_to_left[l-i]) {
			right_to_left[l-i-1] = row[l-i-1];
		} else {
			right_to_left[l-i-1] = right_to_left[l-i];
		}
	}
	foreach (i; 0 .. l) {
		if (left_to_right[i] < right_to_left[i]) {
			result[i] = left_to_right[i];
		} else {
			result[i] = right_to_left[i];
		}
	}
	return result;
}

long getVisibilityScore(ref char[][] map, long i, long j) {
	char cell_value = map[i][j];
	long total = 1;
	foreach (x; 1 .. i + 1) {
		if (map[i-x][j] >= cell_value) {
			total *= x;
			break;
		}
		if (i-x == 0) {
			total *= x;
		}
	}
	foreach (x; 1 .. map.length - i) {
		if (map[i+x][j] >= cell_value) {
			total *= x;
			break;
		}
		if (i+x == map.length - 1) {
			total *= x;
		}
	}
	foreach (x; 1 .. j + 1) {
		if (map[i][j-x] >= cell_value) {
			total *= x;
			break;
		}
		if (j - x == 0) {
			total *= x;
		}
	}	
	foreach (x; 1 .. map[i].length - j) {
		if (map[i][j+x] >= cell_value) {
			total *= x;
			break;
		}
		if (j+x == map[i].length - 1) {
			total *= x;
		}
	}
	return total;
}

void solve(string[] range) {
	char[][] tree_map;
	// Transfer into a 2d array first for random range access
	foreach (line; range) {
		if (line.empty) {
			continue;
		}
		tree_map ~= line.dup;
	}
	// Part 1
	// Build plateau arrays
	char[][] row_plateau_map;
	char[][] column_plateau_map;
	foreach (row; tree_map) {
		row_plateau_map ~= buildPlateauArray(row);
	}
	// I assume the input is square to make my life easier
	auto transposed_tree_map = transposed(tree_map.dup);
	foreach (column; transposed_tree_map) {
		char[] ref_array = to!(char[])(column.array);
		column_plateau_map ~= buildPlateauArray(ref_array);
	}
	// Calculate visible trees
	ulong visible_trees = 0;
	ulong invisible_trees = 0;
	long vis_score = 0;
	foreach (i, row; tree_map) {
		foreach (j, current_symbol; row) {
			if ((i == 0) || (i == tree_map.length - 1) || (j == 0) || (j == row.length - 1)) {
				visible_trees += 1;
				continue;
			}
			// Tree below plateau level
			if (current_symbol < row_plateau_map[i][j] && current_symbol < column_plateau_map[j][i]) {
				invisible_trees += 1;
			// Tree level with plateau or at the edge of it
			} else {
				if ((column_plateau_map[j][i-1] < column_plateau_map[j][i]) ||
				(column_plateau_map[j][i+1] < column_plateau_map[j][i]) ||
				(row_plateau_map[i][j-1] <  row_plateau_map[i][j]) ||
				( row_plateau_map[i][j+1] <  row_plateau_map[i][j])) {
					visible_trees += 1;
				} else {
					invisible_trees += 1;
				}
				// Do the part 2 calculation cause we're already having a loop
				long tmp = getVisibilityScore(tree_map, i, j);
				if (tmp > vis_score) {
					vis_score = tmp;
				}
			}
		}
	}
	writeln("My solution for part1: ", visible_trees);
	writeln("My solution for part2: ", vis_score);
}

mixin BenchmarkRunner!("input.txt", solve);
