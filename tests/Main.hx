package ;

import utest.Runner;
import utest.ui.Report;

@:keep
class Main {
	
	public static function main() {
		var runner = new Runner();
    runner.addCase(new uhx.types.MediaTypeSpec());
    Report.create(runner);
    runner.run();
	}
	
}
