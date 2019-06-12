
*** This code makes Figure A1 in the appendix of Terry (2016).

use "Figure A1 data.dta", clear




tsline propregblack propblackreg propwhitereg, xlabel(1950[10]2012) ttick(1965, tpos(in)) ttext(.05 1965  "VRA ", orient(vert)) ///
	legend(label(1 "Prop. registrants Af Am") label(2 "Prop. Af Am registered") label(3 "Prop. White registered") ///
	rows(1) size(vsmall) ) ytitle("Average Across Former Confederacy", height(5))
