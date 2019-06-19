clear
#delimit;
set mem 300m;

***table 6 - column 5***;

local outname = "table6b";
use setupd, clear;
sort childid;
merge childid using weights;
tab _m;
drop _m;
sort childid;
merge childid using parentrating, keep(p?contro);
tab _m;
drop _m;
for var p?contro: replace X = . if X < 0;

***mean p1 test scores***;
egen t1 = sum(p1contro), by(tchid);
egen t2 = count(p1contro), by(tchid);
gen pcontrobar = (t1-p1contro)/(t2-1);
drop t1 t2;

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
while `n' <= 1 {;

	if `n' == 1 {;
		local ln = "contro";
	};
	capture	drop depvar depvarl1 depvarbar;
	gen depvar = p2`ln';
	gen depvarl1 = p1`ln';
	gen depvarbar = p`ln'bar;
	replace depvar = . if depvarl1 == . | depvarbar == .;
 
 	***setup outreg***;
	reg depvar prekhs prekhsbar depvarl1 depvarbar;
	outreg using "`outname'/`ln'", replace se bracket 3aster nolabel ctitle("setup");

 	***FE + VA***;
	areg depvar depvarl1 prekhs prekhsbar `xindcov' `xbarcov' `tvars' [w=bycw0], robust absorb(schid) cluster(tchid);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln'");
 
local n = `n' + 1;
};
