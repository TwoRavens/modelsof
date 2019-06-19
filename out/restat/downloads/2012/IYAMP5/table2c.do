clear
#delimit;
set mem 300m;

***table 2 - columns 5 & 6***;

local outname = "table2c";
use setupd2, clear;
sort childid;
merge childid using weights;
tab _m;
drop _m;

drop tba tma tgs tba4 tma4 tgs4;
tab b1hghstd, gen(teducdum);
tab b4hghstd, gen(teduc4dum);
drop teducdum1 teduc4dum1;
drop tcdum* tc4dum*;
qui tab tcert, gen(tcdum);
qui tab tcert4, gen(tc4dum);

***school ID***;
gen sch4id = real(s4_id);
replace sch4id = . if sch4id > 9900;

***organize vars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome p1wicmom p1wicchd fstampp1 readp1 chbookp1 chaudp1 agec2";
local xbarcov = "xbar1-xbar29";
local x4barcov = "x4bar1-x4bar29";
local tvars = "aget1 lovteach tmale twhite teducdum* tyrsch tyrskin totyrstchkp tcdum2-tcdum5 classsize";
local t4vars = "aget4 twhite4 teduc4dum* tyrsch4 tyrsfst4 totyrstchkp4 tc4dum2-tc4dum5 class4size";
capture drop zm;
egen zm = rmiss(`xindcov' `xbarcov' `x4barcov' `tvars' `t4vars' tchid tch4id prekhsbar prekhs4bar);
keep if zm == 0;

**********loop by depvar************;
local n = 1;
while `n' <= 2 {;

	capture	drop depvar depvarl1 depvarbar;
	if `n' == 1 {;
		gen depvar = mathtc2;
		gen depvarl1 = mathtc1;
		gen depvarbar = mathbar;
		local ln = "math";
	};
	else if `n' == 2 {;
		gen depvar = readtc2;
		gen depvarl1 = readtc1;
		gen depvarbar = readbar;
		local ln = "read";
	};
	replace depvar = . if depvarl1 == . | depvarbar == .;
 
 	***setup outreg***;
	reg depvar prekhs prekhsbar prekhs4bar depvarl1 depvarbar;
	outreg using "`outname'/`ln'", replace se bracket 3aster nolabel ctitle("setup");

 	***FE + VA***;
	areg depvar depvarl1 prekhs prekhs4bar `xindcov' `x4barcov' `t4vars' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln'");
 
local n = `n' + 1;
};
