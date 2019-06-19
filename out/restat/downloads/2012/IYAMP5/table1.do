clear
#delimit;
set mem 300m;

***various descriptive stats***;
***1st section compares computed averages with teacher reported averages***;
***2nd section is summary stats overall, above/below median, & tests of differences (Table 1)***;
***3rd section is stats for missing/included obs & test of differences***;

local outname = "table1";
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
label drop p1045f p1040f;
drop if tchid == .; *must do this for clustering*;

********************************************************************;
***   compare computed averages with teacher reported averages   ***;
********************************************************************;
for var a1black a1white a1hisp a1totra a1pblk a1phis: replace X = . if X < 0;
gen a1pblack = a1black/a1totra;
gen a1pwhite = a1white/a1totra;
gen a1phisp = a1hisp/a1totra;
egen t1 = sum(male), by(tchid);
egen t2 = count(male), by(tchid);
gen pmale = t1/t2;
drop t1 t2;
egen t1 = sum(hisp), by(tchid);
egen t2 = count(hisp), by(tchid);
gen phisp = t1/t2;
drop t1 t2;
egen t1 = sum(black), by(tchid);
egen t2 = count(black), by(tchid);
gen pblack = t1/t2;
drop t1 t2;
egen t1 = sum(white), by(tchid);
egen t2 = count(white), by(tchid);
gen pwhite = t1/t2;
drop t1 t2;
for var a1pblk a1phis: replace X = X/100;
bysort tchid: gen nc = _n;
ttest pmale == cpboys if nc == 1;
ttest pwhite == a1pwhite if nc == 1;
ttest pblack == a1pblack if nc == 1;
ttest phisp == a1phisp if nc == 1;
ttest pblack == a1pblk if nc == 1;
ttest phisp == a1phis if nc == 1;
ttest a1pblack == a1pblk if nc == 1;
ttest a1phisp == a1phis if nc == 1;
summ pmale cpboys pwhite a1pwhite pblack a1pblack a1pblk phisp a1phisp a1phis if nc == 1;
drop pmale pblack phisp pwhite a1pblack a1pwhite a1phisp nc;

********************************************************************;
***   table 1. summary stats above/below median   ******************;
********************************************************************;

***define regression sample***;
drop tba tma tgs;
tab b1hghstd, gen(teducdum);
drop tcdum*;
qui tab tcert, gen(tcdum);

local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 
	readp1 chbookp1 chaudp1 agec2";
local xbarcov = "xbar1-xbar29";
local tvars = "aget1 lovteach tmale twhite teducdum* tyrsch tyrskin totyrstchkp tcdum2-tcdum5 classsize";
capture drop zm;
egen zm = rmiss(`xindcov' `xbarcov' `tvars');

***percent prek not excluding reference***;
egen t1 = sum(prekhs) if tchid ~= . & schid ~= . & zm == 0 & prekhs ~= . & mathtc1 ~= . & mathtc2 ~= . & mathbar ~= . & prekhsbar ~= ., by(tchid);
egen t2 = count(prekhs) if tchid ~= . & schid ~= . & zm == 0 & prekhs ~= . & mathtc1 ~= . & mathtc2 ~= . & mathbar ~= . & prekhsbar ~= ., by(tchid);
gen prekhsbarner = t1/t2;
label var prekhsbarner "percent of other kids in class in prek or HS not excluding reference";
drop t1 t2;
summ prekhsbarner, detail;
summ prekhsbarner prekhs if tchid ~= . & schid ~= . & zm == 0 & prekhs ~= . & mathtc1 ~= . & mathtc2 ~= . & mathbar ~= . & prekhsbar ~= .;
summ prekhsbarner prekhs if tchid ~= . & schid ~= . & zm == 0 & prekhs ~= . & mathtc1 ~= . & mathtc2 ~= . & mathbar ~= . & prekhsbar ~= . [w=bycw0];
gen prekhsbarm = prekhsbarner > .5909;
replace prekhsbarm = . if prekhsbarner == . | tchid == . | schid == . | zm ~= 0 | prekhs == . | prekhsbar == . 
	| mathtc1 == . | mathtc2 == . | mathbar == .;

***overall means (continuous vars first, discrete vars second)***;
summ mathtc2 mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* if prekhsbarm ~= . [w=bycw0], sep(0);
***below median prekbar***;
summ mathtc2 mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* if prekhsbarm == 0 [w=bycw0], sep(0);
***above median prekbar***;
summ mathtc2 mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* if prekhsbarm == 1 [w=bycw0], sep(0);

**t-test of difference using regression to allow for clustering***;
reg mathtc2 prekhsbarm [w=bycw0], cluster(tchid);
outreg using "`outname'/med", replace pvalue noaster noparen nolabel;
foreach var of varlist mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* {;

	reg `var' prekhsbarm [w=bycw0], cluster(tchid);
	outreg using "`outname'/med", append pvalue noaster noparen nolabel;
	
};

**t-test of difference using regression to allow for clustering & adjust for school FE***;
areg mathtc2 if prekhsbarm ~= . [w=bycw0], absorb(schid);
predict eemathtc2, r;
reg eemathtc2 prekhsbarm [w=bycw0], cluster(tchid);
drop eemathtc2;
outreg using "`outname'/medadjfe", replace pvalue noaster noparen nolabel;
foreach var of varlist mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* {;

	areg `var' if prekhsbarm ~= . [w=bycw0], absorb(schid);
	predict ee`var', r;
	reg ee`var' prekhsbarm [w=bycw0], cluster(tchid);
	outreg using "`outname'/medadjfe", append pvalue noaster noparen nolabel;
	drop ee`var';
	
};

**t-test of difference using regression to allow for clustering & adjust for school FE & VA (matht1)***;
areg mathtc2 mathtc1 if prekhsbarm ~= . [w=bycw0], absorb(schid);
predict eemathtc2, r;
reg eemathtc2 prekhsbarm [w=bycw0], cluster(tchid);
drop eemathtc2;
outreg using "`outname'/medadjfeva", replace pvalue noaster noparen nolabel;
foreach var of varlist mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* {;

	areg `var' mathtc1 if prekhsbarm ~= . [w=bycw0], absorb(schid);
	predict ee`var', r;
	reg ee`var' prekhsbarm [w=bycw0], cluster(tchid);
	outreg using "`outname'/medadjfeva", append pvalue noaster noparen nolabel;
	drop ee`var';
	
};

********************************************************************;
***   chars of those with missing scores & prek   ******************;
********************************************************************;

***indicator if missing (math) scores & prek***;
gen missinfo = 0 if prekhs ~= . & prekhsbar ~= . & tchid ~= . & schid ~= . & mathtc1 ~=. & mathtc2 ~= . & mathbar ~= . & zm == 0;
replace missinfo = 1 if missinfo == .;

***not missing***;
summ mathtc2 mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* if missinfo == 0 [w=bycw0], sep(0);
***missing***;
summ mathtc2 mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* if missinfo == 1 [w=bycw0], sep(0);

**t-test differing using regression to allow for clustering***;
reg mathtc2 missinfo [w=bycw0], cluster(tchid);
outreg using "`outname'/mi", replace pvalue noaster noparen nolabel;
foreach var of varlist mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* {;

	reg `var' missinfo [w=bycw0], cluster(tchid);
	outreg using "`outname'/mi", append pvalue noaster noparen nolabel;
	
};

**t-test differing using regression to allow for clustering & adjust for school FE***;
areg mathtc2 [w=bycw0], absorb(schid);
predict eemathtc2, r;
reg eemathtc2 missinfo [w=bycw0], cluster(tchid);
drop eemathtc2;
outreg using "`outname'/miadjfe", replace pvalue noaster noparen nolabel;
foreach var of varlist mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* {;

	areg `var' [w=bycw0], absorb(schid);
	predict ee`var', r;
	reg ee`var' missinfo [w=bycw0], cluster(tchid);
	outreg using "`outname'/miadjfe", append pvalue noaster noparen nolabel;
	drop ee`var';
	
};

**t-test differing using regression to allow for clustering & adjust for school FE, VA (matht1)***;
areg mathtc2 mathtc1 [w=bycw0], absorb(schid);
predict eemathtc2, r;
reg eemathtc2 missinfo [w=bycw0], cluster(tchid);
drop eemathtc2;
outreg using "`outname'/miadjfeva", replace pvalue noaster noparen nolabel;
foreach var of varlist mathtc1 mathbar readtc2 readtc1 readbar controlt1 controlt2 extprobt1 extprobt2 interpt1 interpt2 intprobt1 
	intprobt2 p1contro p2contro prekhsbarner magefb grndpclose numsibp1 income chbookp1 chaudp1 agec2 aget1 tyrsch tyrskin 
	totyrstchkp classsize prekhs readp1 momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 tmale twhite 
	tcdum* teducdum* {;

	areg `var' mathtc1 [w=bycw0], absorb(schid);
	predict ee`var', r;
	reg ee`var' missinfo [w=bycw0], cluster(tchid);
	outreg using "`outname'/miadjfeva", append pvalue noaster noparen nolabel;
	drop ee`var';
	
};

