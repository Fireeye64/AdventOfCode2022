mixin template BenchmarkRunner(alias sourceFile, alias func) {
	import std.stdio;
	import std.string : strip;
	import std.datetime.stopwatch : StopWatch, AutoStart;
	
	void main() {
		File inputFile = File(sourceFile);
		string[] inputRange;
		foreach(line; inputFile.byLine()) {
			inputRange ~= line.strip("\r").idup;
		}
		auto sw = StopWatch(AutoStart.yes);
		func(inputRange);
		sw.stop();
		writeln("Total runtime: ", sw.peek());
	}
}
