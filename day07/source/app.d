import benchmark: BenchmarkRunner;
import std.stdio;
import std.range: empty;
import std.algorithm.searching: maxElement;
import std.conv : to;
import std.algorithm.sorting: sort;
import std.algorithm.iteration: sum, map;
import std.regex;
import std.array: join, replicate, array;
import std.string: indexOf;

class Directory {
	string name;
	Directory parent;
	long[string] files;
	Directory[string] children;

	@property long total_size() {
		long total = 0;
		foreach(d; this.children) {
			total += d.total_size;
		}
		return total + sum(this.files.values);
	}
	
	this(string name) {
		this.name = name;
	}
	
	this(string name, Directory parent) {
		this.name = name;
		this.parent = parent;
	}
	
	string prettyFormat(long level = 0) {
		string[] result;
		result ~= ("  ".replicate(level) ~ "- " ~ this.name);
		foreach(d; this.children) {
			result ~= d.prettyFormat(level+1);
		}
		foreach(fn, fs; this.files) {
			result ~= ("  ".replicate(level+1) ~ "- " ~ fn ~ " " ~ to!string(fs));
		}
		return result.join("\r\n");
	}
	
	override string toString() {
		return this.prettyFormat(0);
	}
	
	void addFile(string name, long size) {
		if (name !in this.files) {
			this.files[name] = size;
		}
	}
	
	void addDirectory(string name) {
		if (name !in this.children) {
			this.children[name] = new Directory(name, this);
		}
	}
	
	Directory[] findAllDirectoriesWithinBudget(long allowance) {
		Directory[] result;
		if (this.total_size <= allowance) {
			result ~= this;
		}
		foreach(d; this.children) {
			result ~= d.findAllDirectoriesWithinBudget(allowance);
		}
		return result;
	}

	Directory[] findAllDirectoriesAboveBudget(long allowance) {
		Directory[] result;
		if (this.total_size >= allowance) {
			result ~= this;
		}
		foreach(d; this.children) {
			result ~= d.findAllDirectoriesAboveBudget(allowance);
		}
		return result;
	}
}

Directory root;
Directory current_directory;

void solve(string[] range) {
	root = new Directory("/");
	current_directory = root;
	foreach (line; range) {
		if (line.empty) {
			continue;
		}
		if (line[0..4] == "$ cd") {
			if (line[5] == '/') {
				current_directory = root;
			} else if (line[5..$] == "..") {
				current_directory = current_directory.parent;
			} else {
				current_directory = current_directory.children[line[5..$]];
			}
		} else if (line[0..4] == "$ ls") {
			current_directory.files.clear;
			current_directory.children.clear;
		} else {
			long split = line.indexOf(" ");
			if (split == -1) {
				continue;
			}
			if (line[0..split] == "dir") {
				current_directory.addDirectory(line[split+1 .. $]);
			} else {
				current_directory.addFile(line[split+1..$], to!long(line[0..split]));
			}
		}
	}
	Directory[] part1 = root.findAllDirectoriesWithinBudget(100_000);
	writeln("My solution for part 1: ", part1.map!(a => a.total_size).sum);
	Directory[] part2 = root.findAllDirectoriesAboveBudget(8_381_165);
	writeln("My solution for part 2: ", part2.map!(a => a.total_size).array.sort[0]);
}

mixin BenchmarkRunner!("input.txt", solve);
