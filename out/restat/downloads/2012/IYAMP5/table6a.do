clear
#delimit;
set mem 300m;

***table 6 - columns 1-4***;

local outname = "table6a";
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
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome p1wicmom p1wicchd fstampp1 readp1 chbookp1 chaudp1 agec2";
local xbarcov = "xbar1-xbar29";
local tvars = "aget1 lovteach tmale twhite teducdum* tyrsch tyrskin totyrstchkp tcdum2-tcdum5 classsize";
capture drop zm;
egen zm = rmiss(`xindcov' `xbarcov' `tvars' tchid schid);
keep if zm == 0;

**********loop by depvar************;
local n = 1;
while `n' <= 4 {;

	if `n' == 1 {;
		local ln = "control";
	};
	else if `n' == 2 {;
		local ln = "extprob";
	};
	else if `n' == 3 {;
		local ln = "interp";
	};
	else if `n' == 4 {;
		local ln = "intprob";
	};
	capture	drop depvar depvarl1 depvarbar;
	gen depvar = `ln't2;
	gen depvarl1 = `ln't1;
	gen depvarbar = `ln'bar;
	replace depvar = . if depvarl1 == . | depvarbar == .;
 
 	***setup outreg***;
	reg depvar prekhs prekhsbar depvarl1 depvarbar;
	outreg using "`outname'/`ln'", replace se bracket 3aster nolabel ctitle("setup");

 	***FE + VA***;
	areg depvar depvarl1 prekhs prekhsbar `xindcov' `xbarcov' `tvars' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln'");
 
local n = `n' + 1;
};
