clear
#delimit;
set mem 300m;

***table 3 - panel a, columns 1 & 2***;

local outname = "table3a";
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
capture drop mathbar readbar;
egen t1 = sum(mathtc1), by(tchid);
egen t2 = count(mathtc1), by(tchid);
gen mathbar = (t1)/(t2);
replace mathbar = . if t2 == 1;
drop t1 t2;
label var mathbar "average p1 math score in class";
egen t1 = sum(readtc1), by(tchid);
egen t2 = count(readtc1), by(tchid);
gen readbar = (t1)/(t2);
replace readbar = . if t2 == 1;
drop t1 t2;
label var readbar "average p1 read score in class";

***var p1 test scores***;
egen tt = sd(mathtc1), by(tchid);
gen mathvar = tt^2;
drop tt;
egen tt = sd(readtc1), by(tchid);
gen readvar = tt^2;
drop tt;

***organize vars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 chbookp1 chaudp1 agec2";
local xbarcov = "xbar1-xbar29";
local tvars = "aget1 lovteach tmale twhite teducdum* tyrsch tyrskin totyrstchkp tcdum2-tcdum5 classsize";
*local tvars = "twhite teducdum* tyrsch tcdum2-tcdum5 classsize";
local t4vars = "twhite4 teduc4dum* tyrsch4 tc4dum2-tc4dum5 class4size";
local t5vars = "twhite5 teduc5dum* tyrsch5 tc5dum2-tc5dum5 class5size";
capture drop zm;
egen zm = rmiss(`xindcov' `xbarcov' `tvars' tchid schid);
keep if zm == 0;

sort tchid;
by tchid: gen sid = _n;

**********loop by depvar************;
local n = 1;
while `n' <= 4 {;

	capture	drop depvarbar;
	if `n' == 1 {;
		gen depvarbar = mathbar if mathvar ~= .;
		local ln = "mathmn";
	};
	else if `n' == 2 {;
		gen depvarbar = readbar if readvar ~= .;
		local ln = "readmn";
	};
	else if `n' == 3 {;
		gen depvarbar = mathvar;
		local ln = "mathvar";
	};
	else if `n' == 4 {;
		gen depvarbar = readvar;
		local ln = "readvar";
	};
 
 	***setup outreg***;
	reg depvarbar if sid == 1;
	outreg using "`outname'/`ln'", replace se bracket 3aster nolabel ctitle("setup");

 	***FE only***;
	areg depvarbar `tvars' if sid == 1 [w=bycw0], robust absorb(schid);
	test aget1 lovteach tmale twhite teducdum2 teducdum3 tyrsch tyrskin totyrstchkp tcdum2 tcdum3 tcdum4 tcdum5 classsize;
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln'") addstat("F", r(F), "P>F", r(p)) adec(3);
 
local n = `n' + 1;
};
