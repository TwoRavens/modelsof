clear
#delimit;
set mem 300m;

***table 3 - panel b, column 7***;

local outname = "table3f";
use setupd2, clear;
sort childid;
merge childid using weights;
tab _m;
drop _m;
sort childid;
merge childid using parentrating, keep(p?contro);
tab _m;
drop _m;
for var p?contro: replace X = . if X < 0;

drop tba tma tgs;
tab b4hghstd, gen(teduc4dum);
drop teduc4dum1;
drop tc4dum*;
qui tab tcert, gen(tc4dum);

***mean p2 test scores***;
egen t1 = sum(p2contro), by(tch4id);
egen t2 = count(p2contro), by(tch4id);
gen pcontrobar = (t1)/(t2);
drop t1 t2;

***var p2 test scores***;
egen tt = sd(p2contro), by(tch4id);
gen pcontrovar = tt^2;
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
while `n' <= 2 {;

	capture drop depvarbar;
	if `n' == 1 {;
		local ln = "contromn";
		gen depvarbar = pcontrobar if pcontrovar ~= .;
	};
	else if `n' == 2 {;
		local ln = "controvar";
		gen depvarbar = pcontrovar;
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
