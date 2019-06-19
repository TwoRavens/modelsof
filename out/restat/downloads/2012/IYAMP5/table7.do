clear
#delimit;
set mem 300m;

***table 7***;

local outname = "table7";
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

***percentiles of behavior***;
egen controlp90 = pctile(controlt1), p(10) by(tchid);
egen controlp75 = pctile(controlt1), p(25) by(tchid);
egen interpp90 = pctile(interpt1), p(10) by(tchid);
egen interpp75 = pctile(interpt1), p(25) by(tchid);
egen extprobp90 = pctile(extprobt1), p(90) by(tchid);
egen extprobp75 = pctile(extprobt1), p(75) by(tchid);
egen intprobp90 = pctile(intprobt1), p(90) by(tchid);
egen intprobp75 = pctile(intprobt1), p(75) by(tchid);
summ controlp90-intprobp75 controlbar extprobbar interpbar intprobbar;

***variance - to keep sample constant***;
egen tt = sd(controlt1), by(tchid);
gen controlbarvar = tt;
drop tt;
egen tt = sd(interpt1), by(tchid);
gen interpbarvar = tt;
drop tt;
egen tt = sd(extprobt1), by(tchid);
gen extprobbarvar = tt;
drop tt;
egen tt = sd(intprobt1), by(tchid);
gen intprobbarvar = tt;
drop tt;

***organize vars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 chbookp1 chaudp1 agec2";
local xbarcov = "xbar1-xbar29";
local tvars = "aget1 lovteach tmale twhite teducdum* tyrsch tyrskin totyrstchkp tcdum2-tcdum5 classsize";
capture drop zm;
egen zm = rmiss(`xindcov' `xbarcov' `tvars' tchid schid controlbar extprobbar interpbar intprobbar *barvar);
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
	reg depvar prekhs prekhsbar depvarl1 controlbar extprobbar interpbar intprobbar controlp75 extprobp75 interpp75 intprobp75 controlp90 extprobp90 interpp90 intprobp90;
	outreg using "`outname'/`ln'", replace se bracket 3aster nolabel ctitle("setup");

 	***FE + VA - mean***;
	areg depvar depvarl1 prekhs prekhsbar controlbar extprobbar interpbar intprobbar `xindcov' `xbarcov' `tvars' [w=bycw0], robust absorb(schid) cluster(tchid);
	test controlbar extprobbar interpbar intprobbar;
	local ff = r(F); local pp = r(p);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln' mean") addstat("F", `ff', "Prob > F", `pp') adec(3);
 
 	***FE + VA - p75***;
	areg depvar depvarl1 prekhs prekhsbar controlp75 extprobp75 interpp75 intprobp75 `xindcov' `xbarcov' `tvars' [w=bycw0], robust absorb(schid) cluster(tchid);
	test controlp75 extprobp75 interpp75 intprobp75;
	local ff = r(F); local pp = r(p);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln' p75") addstat("F", `ff', "Prob > F", `pp') adec(3);
 
 	***FE + VA - p90***;
	areg depvar depvarl1 prekhs prekhsbar controlp90 extprobp90 interpp90 intprobp90 `xindcov' `xbarcov' `tvars' [w=bycw0], robust absorb(schid) cluster(tchid);
	test controlp90 extprobp90 interpp90 intprobp90;
	local ff = r(F); local pp = r(p);
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln' p90") addstat("F", `ff', "Prob > F", `pp') adec(3);
 
local n = `n' + 1;
};
