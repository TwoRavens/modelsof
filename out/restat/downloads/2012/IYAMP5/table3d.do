clear
#delimit;
set mem 300m;

***table 3 - panel b, columns 3-6***;

local outname = "table3d";
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
capture drop controlbar extprobbar learnbar interpbar intprobbar;
egen t1 = sum(controlt2), by(tch4id);
egen t2 = count(controlt2), by(tch4id);
gen controlbar = (t1)/(t2);
drop t1 t2;
label var controlbar "average t1 control score in class";
egen t1 = sum(extprobt2), by(tch4id);
egen t2 = count(extprobt2), by(tch4id);
gen extprobbar = (t1)/(t2);
drop t1 t2;
label var extprobbar "average t1 extprob score in class";
egen t1 = sum(learnt2), by(tch4id);
egen t2 = count(learnt2), by(tch4id);
gen learnbar = (t1)/(t2);
drop t1 t2;
label var learnbar "average t1 learn score in class";
egen t1 = sum(interpt2), by(tch4id);
egen t2 = count(interpt2), by(tch4id);
gen interpbar = (t1)/(t2);
drop t1 t2;
label var interpbar "average t1 interp score in class";
egen t1 = sum(intprobt2), by(tch4id);
egen t2 = count(intprobt2), by(tch4id);
gen intprobbar = (t1)/(t2);
drop t1 t2;
label var intprobbar "average t1 intprob score in class";

***var p2 test scores***;
egen tt = sd(controlt2), by(tch4id);
gen controlvar = tt^2;
drop tt;
egen tt = sd(extprobt2), by(tch4id);
gen extprobvar = tt^2;
drop tt;
egen tt = sd(learnt2), by(tch4id);
gen learnvar = tt^2;
drop tt;
egen tt = sd(interpt2), by(tch4id);
gen interpvar = tt^2;
drop tt;
egen tt = sd(intprobt2), by(tch4id);
gen intprobvar = tt^2;
drop tt;

***school ID***;
gen sch4id = real(s4_id);
replace sch4id = . if sch4id > 9900;

***organize vars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 chbookp1 chaudp1 agec2";
local xbarcov = "xbar1-xbar29";
local tvars = "aget1 lovteach tmale twhite teducdum* tyrsch tyrskin totyrstchkp tcdum2-tcdum5 classsize";
local t4vars = "aget4 twhite4 teduc4dum* tyrsch4 tyrsfst4 totyrstchkp4 tc4dum2-tc4dum5 class4size";
capture drop zm;
egen zm = rmiss(`xindcov' `xbarcov' `t4vars' tch4id sch4id);
keep if zm == 0;

sort tch4id;
by tch4id: gen sid = _n;

**********loop by depvar************;
local n = 1;
while `n' <= 8 {;

	capture drop depvarbar;
	if `n' == 1 {;
		local ln = "controlmn";
		gen depvarbar = controlbar if controlvar ~= .;
	};
	else if `n' == 2 {;
		local ln = "extprobmn";
		gen depvarbar = extprobbar if extprobvar ~= .;
	};
	else if `n' == 3 {;
		local ln = "interpmn";
		gen depvarbar = interpbar if interpvar ~= .;
	};
	else if `n' == 4 {;
		local ln = "intprobmn";
		gen depvarbar = intprobbar if intprobvar ~= .;
	};
	else if `n' == 5 {;
		local ln = "controlvar";
		gen depvarbar = controlvar;
	};
	else if `n' == 6 {;
		local ln = "extprobvar";
		gen depvarbar = extprobvar;
	};
	else if `n' == 7 {;
		local ln = "interpvar";
		gen depvarbar = interpvar;
	};
	else if `n' == 8 {;
		local ln = "intprobvar";
		gen depvarbar = intprobvar;
	};
 
 	***setup outreg***;
	reg depvarbar prekhsbar if sid == 1;
	outreg using "`outname'/`ln'", replace se bracket 3aster nolabel ctitle("setup");

 	***FE only***;
	areg depvarbar `t4vars' if sid == 1 [w=c24cw0], robust absorb(sch4id);
	test aget4 twhite4 teduc4dum2 teduc4dum3 tyrsch4 tyrsfst4 totyrstchkp4 tc4dum2 tc4dum3 tc4dum4 tc4dum5 class4size;
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln'") addstat("F", r(F), "P>F", r(p)) adec(3);
 
local n = `n' + 1;
};
