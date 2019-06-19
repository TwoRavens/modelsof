clear
#delimit;
set mem 300m;

***table 2 - columns 3 & 4***;

local outname = "table2b";
use setupd, clear;
sort childid;
merge childid using weights;
tab _m;
drop _m;

drop tba tma tgs;
tab b1hghstd, gen(teducdum);
drop teducdum1;
drop tcdum*;
qui tab tcert, gen(tcdum);

***mean p1 test scores***;
egen t1 = sum(readp1), by(tchid);
egen t2 = count(readp1), by(tchid);
gen readpbar = (t1-readp1)/(t2-1);
drop t1 t2;
label var readpbar "average p1 read to child everyday in class";
egen t1 = sum(chbookp1), by(tchid);
egen t2 = count(chbookp1), by(tchid);
gen chbookbar = (t1-chbookp1)/(t2-1);
drop t1 t2;
label var chbookbar "average p1 # books in class";

***organize vars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome p1wicmom p1wicchd fstampp1 readp1 chbookp1 chaudp1 agec2";
local xbarcov = "xbar1-xbar29";
local tvars = "aget1 lovteach tmale twhite teducdum* tyrsch tyrskin totyrstchkp tcdum2-tcdum5 classsize";
capture drop zm;
egen zm = rmiss(`xindcov' `xbarcov' `tvars' tchid schid);
keep if zm == 0;

**********loop by depvar************;
local n = 1;
while `n' <= 2 {;

	capture	drop depvar depvarl1 depvarbar;
	if `n' == 1 {;
		gen depvar = readp4;
		gen depvarl1 = readp1;
		gen depvarbar = readpbar;
		local ln = "readp";
	};
	else if `n' == 2 {;
		gen depvar = chbookp4;
		gen depvarl1 = chbookp1;
		gen depvarbar = chbookbar;
		local ln = "chbook";
	};
	replace depvar = . if depvarl1 == . | depvarbar == .;
 
 	***setup outreg***;
	reg depvar prekhs prekhsbar depvarl1 depvarbar;
	outreg using "`outname'/`ln'", replace se bracket 3aster nolabel ctitle("setup");

 	***FE + VA***;
	areg depvar depvarl1 prekhs prekhsbar `xindcov' `xbarcov' `tvars' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln'");
 
local n = `n' + 1;
};
