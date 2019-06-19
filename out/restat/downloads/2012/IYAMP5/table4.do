clear
#delimit;
set mem 300m;

***table 4***;

local outname = "table4";
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
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 chbookp1 chaudp1 agec2";
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
	reg depvar prekhs prekhsbar depvarl1;
	outreg using "`outname'/`ln'", replace se bracket 3aster nolabel ctitle("setup");

	***OLS (panel a)***;
	reg depvar prekhs prekhsbar [w=bycw0], robust cluster(schid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pac1");
	
	reg depvar prekhs prekhsbar `xindcov' [w=bycw0], robust cluster(schid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pac2");
	
	reg depvar prekhs prekhsbar `xindcov' `xbarcov' [w=bycw0], robust cluster(schid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pac3");
	
	reg depvar prekhs prekhsbar `xindcov' `xbarcov' `tvars' [w=bycw0], robust cluster(schid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pac4");
	
	***VA only (panel b)***;
	reg depvar depvarl1 prekhs prekhsbar [w=bycw0], robust cluster(schid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pbc1");
	
	reg depvar depvarl1 prekhs prekhsbar `xindcov' [w=bycw0], robust cluster(schid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pbc2");
	
	reg depvar depvarl1 prekhs prekhsbar `xindcov' `xbarcov' [w=bycw0], robust cluster(schid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pbc3");
	
	reg depvar depvarl1 prekhs prekhsbar `xindcov' `xbarcov' `tvars' [w=bycw0], robust cluster(schid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pbc4");
 
 	***FE only (panel c)***;
	areg depvar prekhs prekhsbar [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pcc1");
 
	areg depvar prekhs prekhsbar `xindcov' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pcc2");
 
	areg depvar prekhs prekhsbar `xindcov' `xbarcov' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pcc3");
 
	areg depvar prekhs prekhsbar `xindcov' `xbarcov' `tvars' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pcc4");
 
 	***FE + VA (panel d)***;
	areg depvar depvarl1 prekhs prekhsbar [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pdc1");
 
	areg depvar depvarl1 prekhs prekhsbar `xindcov' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pdc2");
 
	areg depvar depvarl1 prekhs prekhsbar `xindcov' `xbarcov' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pdc3");
 
	areg depvar depvarl1 prekhs prekhsbar `xindcov' `xbarcov' `tvars' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("pdc4");
 
local n = `n' + 1;
};
