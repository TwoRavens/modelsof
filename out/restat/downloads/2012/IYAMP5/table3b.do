clear
#delimit;
set mem 300m;

***table 3 - panel b, columns 1 & 2***;

local outname = "table3b";
use setupd2, clear;
sort childid;
merge childid using weights;
tab _m;
drop _m;

drop tba tma tgs;
tab b4hghstd, gen(teduc4dum);
drop teduc4dum1;
drop tc4dum*;
qui tab tcert, gen(tc4dum);

***mean p2 test scores***;
capture drop mathbar readbar;
egen t1 = sum(mathtc2), by(tch4id);
egen t2 = count(mathtc2), by(tch4id);
gen mathbar = (t1)/(t2);
drop t1 t2;
label var mathbar "average p2 math score in class";
egen t1 = sum(readtc2), by(tch4id);
egen t2 = count(readtc2), by(tch4id);
gen readbar = (t1)/(t2);
drop t1 t2;
label var readbar "average p2 read score in class";

***var p2 test scores***;
egen tt = sd(mathtc2), by(tch4id);
gen mathvar = tt^2;
drop tt;
egen tt = sd(readtc2), by(tch4id);
gen readvar = tt^2;
drop tt;

***school ID***;
gen sch4id = real(s4_id);
replace sch4id = . if sch4id > 9900;

***organize vars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 chbookp1 chaudp1 agec2";
local xbarcov = "xbar1-xbar29";
local x4barcov = "x4bar1-x4bar29";
local tvars = "aget1 lovteach tmale twhite teducdum* tyrsch tyrskin totyrstchkp tcdum2-tcdum5 classsize";
local t4vars = "aget4 twhite4 teduc4dum* tyrsch4 tyrsfst4 totyrstchkp4 tc4dum2-tc4dum5 class4size";
capture drop zm;
egen zm = rmiss(`xindcov' `x4barcov' `t4vars' tch4id sch4id);
keep if zm == 0;

sort tch4id;
by tch4id: gen sid = _n;

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
	areg depvarbar `t4vars' if sid == 1 [w=c24cw0], robust absorb(sch4id);
	test aget4 twhite4 teduc4dum2 teduc4dum3 tyrsch4 tyrsfst4 totyrstchkp4 tc4dum2 tc4dum3 tc4dum4 tc4dum5 class4size;
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln'") addstat("F", r(F), "P>F", r(p)) adec(3);
 
local n = `n' + 1;
};
