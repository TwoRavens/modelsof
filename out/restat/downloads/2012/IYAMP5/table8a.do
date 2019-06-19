clear
#delimit;
set mem 300m;

***table 8 - panel a***;

local outname = "table8a";
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

***organize vars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome p1wicmom p1wicchd fstampp1 readp1 chbookp1 chaudp1 agec4";
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
		gen depvar = mathtc4;
		gen depvarl1 = mathtc1;
		gen depvarbar = mathbar;
		local ln = "math";
	};
	else if `n' == 2 {;
		gen depvar = readtc4;
		gen depvarl1 = readtc1;
		gen depvarbar = readbar;
		local ln = "read";
	};
	replace depvar = . if depvarl1 == . | depvarbar == .;
 
 	***setup outreg***;
	reg depvar prekhs prekhsbar depvarl1 depvarbar;
	outreg using "`outname'/`ln'", replace se bracket 3aster nolabel ctitle("setup");

 	***FE + VA***;
	areg depvar depvarl1 prekhs prekhsbar [w=c1_5fc0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln' c1");
 
	areg depvar depvarl1 prekhs prekhsbar `xindcov' [w=c1_5fc0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln' c2");
 
	areg depvar depvarl1 prekhs prekhsbar `xindcov' `xbarcov' [w=c1_5fc0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln' c3");
 
	areg depvar depvarl1 prekhs prekhsbar `xindcov' `xbarcov' `tvars' [w=c1_5fc0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln' c4");
 
local n = `n' + 1;
};
