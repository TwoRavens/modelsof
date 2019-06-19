clear
#delimit;
set mem 300m;

***table 3 - panel a, columns 3-6***;

local outname = "table3c";
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
capture drop controlbar extprobbar learnbar interpbar intprobbar;
egen t1 = sum(controlt1), by(tchid);
egen t2 = count(controlt1), by(tchid);
gen controlbar = (t1)/(t2);
drop t1 t2;
label var controlbar "average t1 control score in class";
egen t1 = sum(extprobt1), by(tchid);
egen t2 = count(extprobt1), by(tchid);
gen extprobbar = (t1)/(t2);
drop t1 t2;
label var extprobbar "average t1 extprob score in class";
egen t1 = sum(learnt1), by(tchid);
egen t2 = count(learnt1), by(tchid);
gen learnbar = (t1)/(t2);
drop t1 t2;
label var learnbar "average t1 learn score in class";
egen t1 = sum(interpt1), by(tchid);
egen t2 = count(interpt1), by(tchid);
gen interpbar = (t1)/(t2);
drop t1 t2;
label var interpbar "average t1 interp score in class";
egen t1 = sum(intprobt1), by(tchid);
egen t2 = count(intprobt1), by(tchid);
gen intprobbar = (t1)/(t2);
drop t1 t2;
label var intprobbar "average t1 intprob score in class";

***var p1 test scores***;
egen tt = sd(controlt1), by(tchid);
gen controlvar = tt^2;
drop tt;
egen tt = sd(extprobt1), by(tchid);
gen extprobvar = tt^2;
drop tt;
egen tt = sd(learnt1), by(tchid);
gen learnvar = tt^2;
drop tt;
egen tt = sd(interpt1), by(tchid);
gen interpvar = tt^2;
drop tt;
egen tt = sd(intprobt1), by(tchid);
gen intprobvar = tt^2;
drop tt;

***organize vars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 chbookp1 chaudp1 agec2";
local xbarcov = "xbar1-xbar29";
local tvars = "aget1 lovteach tmale twhite teducdum* tyrsch tyrskin totyrstchkp tcdum2-tcdum5 classsize";
capture drop zm;
egen zm = rmiss(`xindcov' `xbarcov' `tvars' tchid schid);
keep if zm == 0;

sort tchid;
by tchid: gen sid = _n;

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
	areg depvarbar `tvars' if sid == 1 [w=bycw0], robust absorb(schid);
	test aget1 lovteach tmale twhite teducdum2 teducdum3 tyrsch tyrskin totyrstchkp tcdum2 tcdum3 tcdum4 tcdum5 classsize;
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln'") addstat("F", r(F), "P>F", r(p)) adec(3);
 
local n = `n' + 1;
};
