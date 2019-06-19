clear
#delimit;
set mem 300m;

***table 3 - panel a, column 7***;

local outname = "table3e";
use setupd, clear;
sort childid;
merge childid using weights;
tab _m;
drop _m;
sort childid;
merge childid using parentrating, keep(p?contro p?learn p?social p?sadlon p?impuls);
tab _m;
drop _m;
for var p?contro p?learn p?social p?sadlon p?impuls: replace X = . if X < 0;

***mean p1 test scores***;
egen t1 = sum(p1contro), by(tchid);
egen t2 = count(p1contro), by(tchid);
gen pcontrobar = (t1)/(t2);
drop t1 t2;
egen t1 = sum(p1learn), by(tchid);
egen t2 = count(p1learn), by(tchid);
gen plearnbar = (t1)/(t2);
drop t1 t2;
egen t1 = sum(p1social), by(tchid);
egen t2 = count(p1social), by(tchid);
gen psocialbar = (t1)/(t2);
drop t1 t2;
egen t1 = sum(p1sadlon), by(tchid);
egen t2 = count(p1sadlon), by(tchid);
gen psadlonbar = (t1)/(t2);
drop t1 t2;
egen t1 = sum(p1impuls), by(tchid);
egen t2 = count(p1impuls), by(tchid);
gen pimpulsbar = (t1)/(t2);
drop t1 t2;

***var p1 test scores***;
egen tt = sd(p1contro), by(tchid);
gen pcontrovar = tt^2;
drop tt;

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

sort tchid;
by tchid: gen sid = _n;

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
	areg depvarbar `tvars' if sid == 1 [w=bycw0], robust absorb(schid);
	test aget1 lovteach tmale twhite teducdum2 teducdum3 tyrsch tyrskin totyrstchkp tcdum2 tcdum3 tcdum4 tcdum5 classsize;
	outreg using "`outname'/`ln'", append se bracket 3aster nolabel ctitle("`ln'") addstat("F", r(F), "P>F", r(p)) adec(3);
 
local n = `n' + 1;
};
