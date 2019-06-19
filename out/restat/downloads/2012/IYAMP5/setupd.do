clear
#delimit;
set mem 300m;

***set up data for regs - class averages, imputing***;

local outname = "setupd";
capture log close;
log using `outname'.log, replace;
use "procecls", clear;
count;
use "procecls" if rptkinder ~= 1, clear;
count;

**read to dummy***;
for var readp*: recode X (4=1) (1/3=0);

***set up employment status***;
gen momftp1 = empmomp1 == 1;
gen momptp1 = empmomp1 == 2;
for var momftp1 momptp1: replace X = . if empmomp1 == .;
replace empdadp1 = 5 if (fatbiop1 == 0 | fatothp1 == 0) & empdadp1 == .;
gen dadftp1 = empdadp1 == 1;
gen dadptp1 = empdadp1 == 2;
for var dadftp1 dadptp1: replace X = . if empdadp1 == .;

***father present & educ***;
gen fatpresp1 = (fatbiop1 == 1 | fatothp1 == 1);
replace fatpresp1 = . if fatbiop1 == . & fatothp1 == .;
for var dadhsdok dadhsgradk: replace X = 0 if X == . & fatpresp1 == 0;

***change rptgrd to never repeat grade***;
replace rptgrd = 1 - rptgrd;

***clean up dummies***;
for var p?wicmom p?wicchd: recode X (2=0);
drop wic;
gen wic = 1 if p1wicmom == 1 | p1wicchd == 1 | p2wicmom == 1 | p2wicchd == 1 | p3wicmom == 1 | p3wicchd == 1 | p4wicmom == 1 | p4wicchd == 1;
replace wic = 0 if wic ~= 1 & (p1wicmom == 0 | p1wicchd == 0 | p2wicmom == 0 | p2wicchd == 0 | p3wicmom == 0 | p3wicchd == 0 | p4wicmom == 0 | p4wicchd == 0);
label var wic "Mom or child ever on WIC (for respondent)";

***school ID***;
gen schid = real(s2_id);
replace schid = . if schid > 9900;

***teacher ID***;
gen str4 t1 = substr(t2_id,1,4);
gen str2 t2 = substr(t2_id,6,2);
gen tchid = real(t1)*100 + real(t2);
drop t1 t2;

***define preschool or HS***;
gen prekhs = hsprim == 1 | cbcarepk == 1;
replace prekhs = . if hsprim == .; 
label var prekhs "in preK or HS";
gen prek = cbcarepk;
replace prek = 0 if hstart == 1 & prek == 1;
label var prekhs "in preK but not HS";

******average vars within class******;
***percent prek or HS***;
egen t1 = sum(prekhs), by(tchid);
egen t2 = count(prekhs), by(tchid);
gen prekhsbar = (t1-prekhs)/(t2-1);
label var prekhsbar "percent of other kids in class in prek or HS";
drop t1 t2;
		
***mean p1 test scores***;
egen t1 = sum(mathtc1), by(tchid);
egen t2 = count(mathtc1), by(tchid);
gen mathbar = (t1-mathtc1)/(t2-1);
drop t1 t2;
label var mathbar "average p1 math score in class";
egen t1 = sum(readtc1), by(tchid);
egen t2 = count(readtc1), by(tchid);
gen readbar = (t1-readtc1)/(t2-1);
drop t1 t2;
label var readbar "average p1 read score in class";
egen t1 = sum(mathic1), by(tchid);
egen t2 = count(mathic1), by(tchid);
gen mathibar = (t1-mathic1)/(t2-1);
drop t1 t2;
label var mathibar "average p1 math IRT score in class";
egen t1 = sum(readic1), by(tchid);
egen t2 = count(readic1), by(tchid);
gen readibar = (t1-readic1)/(t2-1);
drop t1 t2;
label var readibar "average p1 read IRT score in class";
egen t1 = sum(controlt1), by(tchid);
egen t2 = count(controlt1), by(tchid);
gen controlbar = (t1-controlt1)/(t2-1);
drop t1 t2;
label var controlbar "average t1 control score in class";
egen t1 = sum(extprobt1), by(tchid);
egen t2 = count(extprobt1), by(tchid);
gen extprobbar = (t1-extprobt1)/(t2-1);
drop t1 t2;
label var extprobbar "average t1 extprob score in class";
egen t1 = sum(learnt1), by(tchid);
egen t2 = count(learnt1), by(tchid);
gen learnbar = (t1-learnt1)/(t2-1);
drop t1 t2;
label var learnbar "average t1 learn score in class";
egen t1 = sum(interpt1), by(tchid);
egen t2 = count(interpt1), by(tchid);
gen interpbar = (t1-interpt1)/(t2-1);
drop t1 t2;
label var interpbar "average t1 interp score in class";
egen t1 = sum(intprobt1), by(tchid);
egen t2 = count(intprobt1), by(tchid);
gen intprobbar = (t1-intprobt1)/(t2-1);
drop t1 t2;
label var intprobbar "average t1 intprob score in class";
egen t1 = sum(arslitt1), by(tchid);
egen t2 = count(arslitt1), by(tchid);
gen arslitbar = (t1-arslitt1)/(t2-1);
drop t1 t2;
label var arslitbar "average t1 arslit score in class";
egen t1 = sum(arsmatht1), by(tchid);
egen t2 = count(arsmatht1), by(tchid);
gen arsmathbar = (t1-arsmatht1)/(t2-1);
drop t1 t2;
label var arsmathbar "average t1 arsmath score in class";
egen t1 = sum(arsgenknowt1), by(tchid);
egen t2 = count(arsgenknowt1), by(tchid);
gen arsgenknowbar = (t1-arsgenknowt1)/(t2-1);
drop t1 t2;
label var arsgenknowbar "average t1 arsgenknow score in class";

***how many missing if not impute***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 chbookp1 
	chaudp1 agec2";
local tvars = "aget1 lovteach tmale twhite tyrsch tyrskin totyrstchkp b1hghstd tcert classsize";
capture drop zm;
egen zm = rmiss(`xindcov' `tvars');
count if prekhs ~= . & prekhsbar ~= . & mathtc1 ~=. & mathtc2 ~= . & mathbar ~= . & tchid ~= . & schid ~= .;
tab zm if prekhs ~= . & prekhsbar ~= . & mathtc1 ~=. & mathtc2 ~= . & mathbar ~= . & tchid ~= . & schid ~= .;
count if prekhs ~= . & prekhsbar ~= . & readtc1 ~=. & readtc2 ~= . & readbar ~= . & tchid ~= . & schid ~= .;
tab zm if prekhs ~= . & prekhsbar ~= . & readtc1 ~=. & readtc2 ~= . & readbar ~= . & tchid ~= . & schid ~= .;

***how many missing if not impute tvars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok 
	momhsgradk dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 chbookp1 
	chaudp1 agec2";
local tvars = "";
capture drop zm;
egen zm = rmiss(`xindcov' `tvars');
count if prekhs ~= . & prekhsbar ~= . & mathtc1 ~=. & mathtc2 ~= . & mathbar ~= . & tchid ~= . & schid ~= .;
tab zm if prekhs ~= . & prekhsbar ~= . & mathtc1 ~=. & mathtc2 ~= . & mathbar ~= . & tchid ~= . & schid ~= .;
count if prekhs ~= . & prekhsbar ~= . & readtc1 ~=. & readtc2 ~= . & readbar ~= . & tchid ~= . & schid ~= .;
tab zm if prekhs ~= . & prekhsbar ~= . & readtc1 ~=. & readtc2 ~= . & readbar ~= . & tchid ~= . & schid ~= .;

***how many missing if impute magefb, earlyemp, chbookp1, grndpclose, immig & tvars***;
local xindcov = "momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp momhsdok momhsgradk dadhsdok 
	dadhsgradk numsibp1 income fatpresp1 lowbwt enghome wic fstampp1 readp1 chaudp1 agec2";
local tvars = "";
capture drop zm;
egen zm = rmiss(`xindcov' `tvars');
count if prekhs ~= . & prekhsbar ~= . & mathtc1 ~=. & mathtc2 ~= . & mathbar ~= . & tchid ~= . & schid ~= .;
tab zm if prekhs ~= . & prekhsbar ~= . & mathtc1 ~=. & mathtc2 ~= . & mathbar ~= . & tchid ~= . & schid ~= .;
count if prekhs ~= . & prekhsbar ~= . & readtc1 ~=. & readtc2 ~= . & readbar ~= . & tchid ~= . & schid ~= .;
tab zm if prekhs ~= . & prekhsbar ~= . & readtc1 ~=. & readtc2 ~= . & readbar ~= . & tchid ~= . & schid ~= .;

***impute for teacher/class vars missing & earlyemp & magefb & chbookp1 & grndpclose & immig***;
***only 1 imputation b/c std errs only underestimated for imputed vars***;
summ totyrstchkp tyrskin tyrsch magefb classsize chbookp1, detail; *match since non-normal*;
tab1 totyrstchkp tyrskin tyrsch magefb classsize chbookp1;
recode b1hghstd (3 4 5 = 3);
qui tab tcert, gen(tcdum);
ice momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk dadhsdok 
	dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 chbookp1 chaudp1 
	agec2 aget1 lovteach tmale twhite b1hghstd tba tgs tma tyrsch tyrskin totyrstchkp tcert tcdum* classsize using setupd, 
	replace m(1) seed(123456789) cc(momftp1 momptp1 dadftp1 dadptp1 cencity suburb male white black hisp 
	momhsdok momhsgradk dadhsdok dadhsgradk numsibp1 income fatpresp1 lowbwt enghome wic fstampp1 readp1 chaudp1 agec2) 
	passive(tba:b1hghstd==1 \ tgs:b1hghstd==2 \ tma:b1hghstd==3 \ tcdum1:tcert==1 \ tcdum2:tcert==2 \ tcdum3:tcert==3 \ 
	tcdum4:tcert==4 \ tcdum5:tcert==5) substitute(b1hghstd: tba tgs tma, tcert: tcdum1 tcdum2 tcdum3 tcdum4 tcdum5) 
	match(magefb classsize tyrsch tyrskin totyrstchkp chbookp1) cmd(b1hghstd grndpclose: ologit);

use setupd, clear;
***create average cov for class (using imputed values)***;
for var momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk 
	dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 
	chbookp1 chaudp1 agec2 \ new n1-n29: egen Y = sum(X), by(tchid);
for var momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk 
	dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 
	chbookp1 chaudp1 agec2 \ var n1-n29: replace Y = Y-X;
for var momftp1 momptp1 dadftp1 dadptp1 magefb grndpclose cencity suburb male white black hisp momhsdok momhsgradk 
	dadhsdok dadhsgradk numsibp1 income immig fatpresp1 earlyemp lowbwt enghome wic fstampp1 readp1 
	chbookp1 chaudp1 agec2 \ new d1-d29: egen Y = count(X), by(tchid);
for var n1-n29 \ var d1-d29 \ new xbar1-xbar29: gen Z = X/(Y-1);
drop n1-n29 d1-d29;
compress;
save, replace;
