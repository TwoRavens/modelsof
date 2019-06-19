clear
capture log close
set more 1
set mem 100m


cd C:\learning
use datdf1

* prepare a file to export to Matlab
drop if round ~= 1
keep treatment id coop ocoop match
* drop data without variation
egen foo = max(coop), by(id)
egen bar = min(coop), by(id)
drop if foo == bar
drop foo bar
* generate an id variable that starts at 1 for each treatment
sort treatment id match 
egen foo = group(id) if treatment == 1
replace foo = 0 if foo == .
egen bar = group(id) if treatment == 2
replace bar = 0 if bar == .
egen baz = group(id) if treatment == 3
replace baz = 0 if baz == .
egen qux = group(id) if treatment == 4
replace qux = 0 if qux == .
egen quux = group(id) if treatment == 5
replace quux = 0 if quux == .
egen quuux = group(id) if treatment == 6
replace quuux = 0 if quuux == .
gen id2 = foo+bar+baz+qux+quux+quuux
drop foo-quuux
sort treatment id2 match 
outsheet using dfformatlab.txt, nonames replace

