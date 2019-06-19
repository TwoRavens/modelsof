clear
#delimit;
set mem 100m;

***clean & process main ecls data***;

use mainfile, clear;
***merge 'classmeasures' data***;
sort childid;
merge childid using classmeasures;
tab _m;
drop _m;

***description of vars - put into mainfile_description.xls***;
*summ, sep(0);
*des;

***ubran/suburban/rural***;
gen cencity = kurban_r == 1;
gen suburb = kurban_r == 2;
for var cencity suburb: replace X = . if kurban_r == .;
label var cencity "residence in central city in base year (suburban,rural/small town)";
label var suburb "residence in suburbs (urban fringe/large town) in base year (central city,rural/small town)";
drop kurban_r r?urban;

***moved residence r3,r4,r5***;
gen mover3 = r3dest == 1;
gen mover3r4 = (r3dest == 1 | r4dest == 1);
gen mover3r4r5 = (r3dest == 1 | r4dest == 1 | r5dest == 1);
replace mover3 = . if r3dest == .;
replace mover3r4 = . if r3dest == . | r4dest == .;
replace mover3r4r5 = . if r3dest == . | r4dest == . | r5dest == . | r5dest == -1 | r5dest == -9;
label var mover3 "moved to fall 1st grade destination";
label var mover3r4 "moved to fall or spring 1st grade destination";
label var mover3r4r5 "moved to fall or spring 1st or spring 3rd grade destination";
drop r?dest;

***gender***;
gen male = gender == 1;
replace male = . if gender == -9;
label var male "1 if male, 0 if female";
drop gender;

***race/ethnicity***;
gen white = race == 1;
gen black = race == 2;
gen hisp = (race == 3 | race == 4);
gen asian = race == 5;
gen otherrace = (race >= 6 & race <= 8);
for var white black hisp asian otherrace: replace X = . if race == -9;
label var otherrace "native hawaii, other pac island; ameri ind or alaska native; > one race, nonhisp";
*drop race;

***not all in round 3, knowing test score is adequate**;
drop r3sample;

***changed schools***;
gen schgr2r4 = r4r2schg ~= 1;
replace schgr2r4 = . if r4r2schg == -1 | r4r2schg == -9 | r4r2schg == .;
gen schgr4r5 = r5r4schg ~= 1;
replace schgr4r5 = . if r5r4schg == -1 | r5r4schg == -9 | r5r4schg == .;
label var schgr2r4 "child changed schools between rounds 2 & 4";
label var schgr4r5 "child changed schools between rounds 4 & 5";
drop r4r2schg r5r4schg;

***reading/math/science scores (continuous)***;
for var c?r2* c5sscale c5stscor: replace X = . if X < 0;
for var c?r2* c5sscale c5stscor \ new readic1 readtc1 mathic1 mathtc1 readic2 readtc2 mathic2 mathtc2 readic3 readtc3 
	mathic3 mathtc3 readic4 readtc4 mathic4 mathtc4 readic5 readtc5 mathic5 mathtc5 sciic5 scitc5: ren X Y;

***self-description (1-4 scale)***;
for var c5sdq*: replace X = . if X < 0;
ren c5sdqrdc sdreadc5;
ren c5sdqmtc sdmathc5;
ren c5sdqsbc sdallsubc5;
ren c5sdqprc sdpeerrelc5;
ren c5sdqext sdextprobc5;
ren c5sdqint sdintprobc5;
drop c5sdqflg;

***teacher evaluation (1-4 or 1-5 scale)***;
drop t4karsli t4karsma t4karsge t5scint;
for var t1rarsli-t5intern: replace X = . if X < 0;
for var t1rarsli-t5intern \ new arslitt1 arsmatht1 arsgenknowt1 learnt1 controlt1 interpt1 extprobt1 intprobt1 
	arslitt2 arsmatht2 arsgenknowt2 learnt2 controlt2 interpt2 extprobt2 intprobt2 
	arslitt4 arsmatht4 arsgenknowt4 learnt4 controlt4 interpt4 extprobt4 intprobt4 
	arslitt5 arsmatht5 arsscit5 arssocstdt5 learnt5 controlt5 interpt5 extprobt5 intprobt5: ren X Y;

***bmi***;
for var c?bmi: replace X = . if X < 0;
for var c?bmi \ new bmic1-bmic5: ren X Y;

***mom's education - some inconsistencies***;
for var w?momed w?daded: replace X = . if X < 0;
gen momhsdok = wkmomed == 1 | wkmomed == 2;
gen momhsgradk = wkmomed >= 3 & wkmomed <= 5;
gen momcollgradk = wkmomed >= 6;
for var momhsdok-momcollgradk: replace X = . if wkmomed == .;
gen momhsdo1 = w1momed == 1 | w1momed == 2;
gen momhsgrad1 = w1momed >= 3 & w1momed <= 5;
gen momcollgrad1 = w1momed >= 6;
for var momhsdo1-momcollgrad1: replace X = . if w1momed == .;
gen momhsdo3 = w3momed == 1 | w3momed == 2;
gen momhsgrad3 = w3momed >= 3 & w3momed <= 5;
gen momcollgrad3 = w3momed >= 6;
for var momhsdo3-momcollgrad3: replace X = . if w3momed == .;
for var momhsdo*: label var X "mom HS dropout, grade K,1,3";
for var momhsgrad*: label var X "mom HS grad or some coll/voc school, grade K,1,3";
for var momcollgrad*: label var X "mom college grad or grad school, grade K,1,3";
*drop w?momed;

***dad's education - some inconsistencies***;
gen dadhsdok = wkdaded == 1 | wkdaded == 2;
gen dadhsgradk = wkdaded >= 3 & wkdaded <= 5;
gen dadcollgradk = wkdaded >= 6;
for var dadhsdok-dadcollgradk: replace X = . if wkdaded == .;
gen dadhsdo1 = w1daded == 1 | w1daded == 2;
gen dadhsgrad1 = w1daded >= 3 & w1daded <= 5;
gen dadcollgrad1 = w1daded >= 6;
for var dadhsdo1-dadcollgrad1: replace X = . if w1daded == .;
gen dadhsdo3 = w3daded == 1 | w3daded == 2;
gen dadhsgrad3 = w3daded >= 3 & w3daded <= 5;
gen dadcollgrad3 = w3daded >= 6;
for var dadhsdo3-dadcollgrad3: replace X = . if w3daded == .;
for var dadhsdo*: label var X "dad HS dropout, grade K,1,3";
for var dadhsgrad*: label var X "dad HS grad or some coll/voc school, grade K,1,3";
for var dadcollgrad*: label var X "dad college grad or grad school, grade K,1,3";
*drop w?daded w?pared;

***mom married at birth***;
for var wkhmomar w1momar: replace X = . if X < 0;
gen momarab = wkhmomar == 1 | w1momar == 1;
replace momarab = . if wkhmomar == . & w1momar == .;
drop wkhmomar w1momar;
label var momarab "mom married at birth of child";

***resident father - biological, other, or none***;
gen fatbiop1 = p1dadtyp == 1;
gen fatothp1 = p1dadtyp == 2;
for var fatbiop1 fatothp1: replace X = . if p1dadtyp == .; 
gen fatbiop2 = p2dadtyp == 1;
gen fatothp2 = p2dadtyp == 2;
for var fatbiop2 fatothp2: replace X = . if p2dadtyp == .; 
gen fatbiop4 = p4dadtyp == 1;
gen fatothp4 = p4dadtyp == 2;
for var fatbiop4 fatothp4: replace X = . if p4dadtyp == .; 
drop p?dadtyp;
for var fatbio*: label var X "biological father resident";
for var fatoth*: label var X "other father (figure) resident";

***mom or dad foster***;
gen foster = 1 if p1hmom == 4 | p2hmom == 4 | p4hmom == 4 | p5hmom == 4 | p1hdad == 4 | p2hdad == 4 | p4hdad == 4 | 
	p5hdad == 4;
replace foster = 0 if foster == . & (p1hmom ~= . | p2hmom ~= . | p4hmom ~= . | p5hmom ~= . | p1hdad ~= . | p2hdad ~= . 
	| p4hdad ~= . | p5hdad ~= .);
drop p?hmom p?hdad;
label var foster "mom and/or dad foster parent";

***english spoken at home***;
for var wklangst w1langst: replace X = . if X < 0;
gen enghome = wklangst == 2 | w1langst == 2;
replace enghome = . if wklangst == . & w1langst == .;
drop w?langst;
label var enghome "home language of child english";

***any other language***;
for var p?anylng: replace X = . if X < 0;
gen othlang = p1anylng;
replace othlang = p2anylng if othlang == . & p2anylng ~= .;
replace othlang = p3anylng if othlang == . & p3anylng ~= .;
replace othlang = p4anylng if othlang == . & p4anylng ~= .;
replace othlang = 0 if othlang == 2;
label var othlang "other language used at home";

***spanish as other language***;
gen splang = (p1langs1 == 1);
replace splang = . if p1langs1 == .;
label var splang "spanish is other language used at home";
drop p?prmlng p1lang* p1hmlang-p1langug p?anylng;

***number of siblings***;
gen numsibp1 = p1numsib;
recode numsibp1 (5/max=5);
gen numsibp2 = p2numsib;
recode numsibp2 (5/max=5);
gen numsibp4 = p4numsib;
recode numsibp4 (5/max=5);
gen numsibp5 = p5numsib;
recode numsibp5 (5/max=5);
drop p?numsib;
for var numsib*: label var X "number of siblings at parent interview, capped at 5";

***income***;
for var ??income: replace X = . if X < 0;
egen income = rmean(??income);
*drop ??income;
label var income "average HH income wk,w1,p2";

***income category - deal with later***;
for var ??inccat: replace X = . if X < 0;
drop ??inccat;

***head start***;
for var p1hs*: replace X = . if X < 0;
gen hstart = p1hsever == 1;
replace hstart = . if p1hsever == .;
drop p1hsever;
label var hstart "child attend head start p1";

***head start verification - some inconsistencies with p1hsever***;
gen hsver = hsattend == 3 | hsattend == 4;
label var hsver "HS verification - child attended";
gen hsveralt = hsattend >= 1 & hsattend <= 4;
label var hsveralt "HS verification alternative - child attended or center not located or repond";
for var hsver hsveralt: replace X = . if hsattend == . & hstart == .;
gen hsconfrm = hstart*hsver;
label var hsconfrm "HS confirmed - verified & reported on own";
gen hsconfrmalt = hstart*hsveralt;
label var hsconfrmalt "HS confirmed alternative - verified (alt) & reported on own";
drop hsattend;

***head start check***;
recode hscheck (2=0);
gen hstartchk = hstart*hscheck;
label var hstartchk "HS checked & reported on own";

***head start dosage***;
gen hsfullday = p1hstype == 1;
replace hsfullday = . if p1hstype == .;
drop p1hstype;
label var hsfullday "in head start full day p1";
gen hshrswk = p1hshrs;
label var hshrswk "head start hours per week";
gen hshrsday = int(p1hshrs/p1hsdays);
drop p1hshrs;
*recode hrsday (1/4=1) (5/max=2) (.=0) (*=.);
label var hshrsday "head start hours per day";
ren p1hsdays hsdayswk;
*recode hsdayswk (1/3=1) (4=2) (5/max=3);
label var hsdayswk "head start days per week";
for var hsfullday hsdayswk hshrswk hshrsday: replace X = 0 if hstart == 0;
drop p1hsfee p1hscost p1hsunit;

***immigrant - child or parent - inconsistencies in parent file***;
for var p?momcob p?dadcob p?chplac: replace X = . if X < 0;
gen immig = 1 if p2chplac == 2 | (p4momcob ~= 1 & p4momcob ~= .) | (p4dadcob ~= 1 & p4dadcob ~= .) | 
	(p5momcob ~= 1 & p5momcob ~= .) | (p5dadcob ~= 1 & p5dadcob ~= .);
replace immig = 0 if immig == .;
replace immig = . if p2chplac == . & p4momcob == . & p4dadcob == . & p5momcob == . & p5dadcob == .;
gen chimmig = 1 if p2chplac == 2;
replace chimmig = 0 if chimmig == .;
replace chimmig = . if p2chplac == .;
drop p?chplac p?momcob p?dadcob p4cbirth p2cntryb;
label var immig "child or mother or father immigrant (not born in US)";
label var chimmig "child immigrant";

***current marital status***;
for var p?curmar: replace X = . if X < 0;
for var p?curmar \ new curmarp2-curmarp5: gen Y = X == 1;
for var p?curmar \ var curmarp2-curmarp5: replace Y = . if X == .;
for var curmarp*: label var X "mom currently married";
drop p?curmar;

***child disabled - some inconsistencies***;
for var p?disabl: replace X = . if X < 0;
for var p?disabl: replace X = 0 if X == 2;
for var p?disabl \ new disablep1 disablep4 disablep5: ren X Y;

***public or private school***;
for var s2ksctyp s?sctyp: replace X = . if X < 0;
for var s2ksctyp s?sctyp: recode X (1/3=1) (4=0);
for var s2ksctyp s?sctyp \ new privschs2-privschs5: ren X Y;
for var privsch*: label var X "private school (catholic, other relig, other) s2-5";

***repeated grade - can I use t5glvl?***;
replace t5glvl = . if t5glvl < 0;
gen rptgrd = (t5glvl >= 1 & t5glvl <= 3) | t5glvl == 7;
replace rptgrd = . if t5glvl == .;
drop t5glvl;
label var rptgrd "repeated grade - not in 3rd grade at 3rd grade survey (t5glvl 1-3,7)";

***repeat kindergarten***;
replace p1firkdg = . if p1firkdg < 0;
gen rptkinder = p1firkdg == 2;
replace rptkinder = . if p1firkdg == .;
drop p1firkdg;
label var rptkinder "repeat kindergarten";

***ever in poverty***;
gen everpov = wkpov_r == 1 | w1povrty == 1 | w3povrty == 1;
replace everpov = . if wkpov_r == . & w1povrty == . & w3povrty == .;
*drop w?pov*;
label var everpov "family ever below poverty threshold k,1,3";

***WIC - mother or child***;
for var p?wicmom p?wicchd: replace X = . if X < 0;
gen wic = p1wicmom == 1 | p2wicmom == 1 | p3wicmom == 1 | p4wicmom == 1 | 
	p1wicchd == 1 | p2wicchd == 1 | p3wicchd == 1 | p4wicchd == 1;
replace wic = . if p1wicmom == . & p2wicmom == . & p3wicmom == . & p4wicmom == . & 
	p1wicchd == . & p2wicchd == . & p3wicchd == . & p4wicchd == .;
*drop p?wicmom p?wicchd;
label var wic "Mom or child ever on WIC (for respondent)";

***afdc***;
replace p1anyaid = . if p1anyaid < 0;
gen afdcscb = p1anyaid == 1;
replace afdcscb = . if p1anyaid == .;
label var afdcscb "since child born, anyone in HH receive afdc (p1)";

***current afdc***;
for var p?afdc: replace X = . if X < 0;
for var p?afdc \ new afdcp1 afdcp2 afdcp4 afdcp5: ren X Y;
for var afdcp*: recode X (2=0);
for var afdcp*: label var X "anyone in HH receive afdc/tanf in past 12 months";

***food stamps***;
for var p?fstamp p1fstam2: replace X = . if X < 0;
gen foodstmp = p1fstamp == 1 | p2fstamp == 1 | p4fstamp == 1 | p5fstamp == 1 | p1fstam2 == 1;
replace foodstmp = . if p1fstamp == . & p2fstamp == . & p4fstamp == . & p5fstamp == . & p1fstam2 == .;
for var p?fstamp \ new fstampp1 fstampp2 fstampp4 fstampp5: ren X Y;
for var fstampp*: recode X (2=0);
for var fstampp*: label var X "anyone in HH receive foodstamp in past 12 months";
drop p1fstam2 p1whenfs p?mofdst p5reqfs;
label var foodstmp "anyone in HH ever receive foodstamp";

***any public aide or below poverty***;
gen poor = foodstmp == 1 | afdcscb == 1 | wic == 1 | everpov == 1;
replace poor = . if foodstmp == . & afdcscb == . & wic == . & everpov == .;
label var poor "ever afdc, foodstamp, WIC, AFDC - use for HS eligibility";
gen pooralt = wic == 1 | everpov == 1;
replace pooralt = . if wic == . & everpov == .;
label var pooralt "ever poverty or WIC - use for HS eligibility";

***school lunch***;
for var p?schllu: replace X = . if X < 0;
for var p?schllu \ new schllup2 schllup4 schllup5: ren X Y;
for var schllup*: recode X (2=0);
for var schllup*: label var X "child's school offer lunch";
for var p?lunchs \ var p?rlunch: replace X = 0 if Y == 2 & X == -1;
for var p?lunchs: replace X = . if X < 0;
for var p?lunchs \ new flunchp2 flunchp4 flunchp5: ren X Y;
for var flunchp*: recode X (2=0);
for var flunchp*: label var X "child receive free or reduced price lunch at school";
drop p?freerd p?numlnc p?rlunch;

***insurance***;
for var p2cover p?noinsu p?priins p?chip p?medaid p?milhea p?agovpg: replace X = . if X < 0;
for var p2cover p?priins p?chip p?medaid p?milhea p?agovpg: recode X (2=0);
for var p?noinsu: recode X (2=1) (1=0);
for var p2cover p?noinsu \ new chhinsp2 chhinsp4 chhinsp5: ren X Y;
for var chhinsp*: label var X "child has any health insurance";
for var p?priins \ new chprhinsp4 chprhinsp5: ren X Y;
for var chprhinsp* \ var chhinsp4 chhinsp5: replace X = 0 if Y == 0;
for var chprhinsp*: label var X "child has private health insurance";
drop p?chip p?medaid p?milhea p?agovpg;

***birthweight***;
for var p1weigh*: replace X = . if X < 0;
gen lowbwt = 1 if p1weighp <= 5;
replace lowbwt = . if p1weighp == 5 & p1weigho > 8 & p1weigho ~= .;
replace lowbwt = . if p1weigh5 == 1;
replace lowbwt = 1 if p1weigh5 == 2;
replace lowbwt = 0 if lowbwt == . & (p1weighp ~= . | p1weigh5 ~= .);
*drop p1weigh*;
label var lowbwt "low birthweight <= 5.5 lbs";

***parent's health***;
for var p?health: replace X = . if X < 0;
for var p?health \ new healthp2 healthp5: ren X Y;
for var healthp*: label var X "parent's health status (1=e,2=vg,3=g,4=f,5=p)";

***child's health***;
for var p?hscale: replace X = . if X < 0;
for var p?hscale \ new healthc1 healthc4 healthc5: ren X Y;
for var healthc*: label var X "child's health status (1=e,2=vg,3=g,4=f,5=p)";

***routine doctor visit***;
for var p?doctor: replace X = . if X < 0;
for var p?doctor \ new doctorp2 doctorp4 doctorp5: ren X Y;
for var doctorp*: label var X "how long since child seen doctor for routine visit (1=never, 2=<6mos, 3=6-12mos, 4=1-2yr, 5=>2yr)"; 

***dental visit***;
for var p?dentis: replace X = . if X < 0;
for var p?dentis \ new dentistp2 dentistp4 dentistp5: ren X Y;
for var dentistp*: label var X "how long since child seen dentist (1=never, 2=<6mos, 3=6-12mos, 4=1-2yr, 5=>2yr)"; 

***age of mother at first birth***;
replace p1hmafb = . if p1hmafb < 0;
ren p1hmafb magefb;
label var magefb "age of mom at 1st birth";

***# of grandparents alive***;
for var p1clsgrn p1lvgran: replace X = . if X < 0;
ren p1lvgran numgrndp;
label var numgrndp "# of grandparents alive 0-4,>5";
ren p1clsgrn grndpclose;
label var grndpclose "# of grandparents child close relationship to 0-4,>5";

***early maternal employment***;
for var w?hearly: replace X = . if X < 0;
gen earlyemp = wkhearly == 1 | w1hearly == 1;
replace earlyemp = . if wkhearly == . & w1hearly == .;
drop w?hearly;
label var earlyemp "mom worked b/w child's birth & kindergarten";

***employment status of m&d at p1***;
for var p1h?emp: replace X = . if X < 0;
for var p1h?emp \ new empmomp1 empdadp1: ren X Y;

***home stimulation***;
for var p?chlboo p?chlaud p?readbo p?homecm: replace X = . if X < 0;
for var p?chlboo p?chlaud p?readbo p?homecm \ new chbookp1 chbookp4 chbookp5 chaudp1 readp1 readp4 readp5 
	homecmp2 homecmp4 homecmp5: ren X Y;

***child care other than HS***;
*replace p1cever = . if p1cever < 0;
*gen othcc = p1cever == 1;
*replace othcc = . if p1cever == .;
*drop p1cever;
*label var othcc "child attended care other than HS";

***age first in child care***;
*for var p1cage*: replace X = . if X < 0;
*gen agemocc = p1cagemo + p1cageyr*12;
*drop p1cage*;
*label var agemocc "age in mos first enrolled any day care, nursery/preschool, etc. on regular basis";

***other pre-k care***;
replace p1primpk = . if p1primpk < 0;
gen pcarepk = p1primpk == 0;
gen ncbnpcarepk = (p1primpk >= 1 & p1primpk <= 4);
*gen ncbnpcarepk = (p1primpk >= 1 & p1primpk <= 4) | p1primpk >= 7;
gen hsprim = p1primpk == 5;
gen cbcarepk = (p1primpk >= 6 & p1primpk <= 8);
*gen cbcarepk = p1primpk == 6;
for var pcarepk ncbnpcarepk hsprim cbcarepk: replace X = . if p1primpk == .;
label var pcarepk "parental care pre-k";
label var ncbnpcarepk "non-HS, non-center based, non-parental care pre-k";
label var hsprim "HS primary preK care";
label var cbcarepk "non-HS center based care pre-k";
drop p1hrsprk;

***costs of prek***;
replace p1costpk = . if p1costpk < 0;
tab p1costpk if hsprim == 1 | cbcarepk == 1;
tab p1costpk if hsprim == 1;
tab p1costpk if cbcarepk == 1;
hist p1costpk if p1costpk ~= 0 & (hsprim == 1 | cbcarepk == 1) & p1costpk < 800, bin(80) saving(procecls_costpkhscb, asis replace);
hist p1costpk if p1costpk ~= 0 & (hsprim == 1) & p1costpk < 800, bin(80) saving(procecls_costpkhs, asis replace);
hist p1costpk if p1costpk ~= 0 & (cbcarepk == 1) & p1costpk < 800, bin(80) saving(procecls_costpkcb, asis replace);

***after school***;
for var p1primnw p5primnw: replace X = . if X < 0;
gen afscbcarep1 = p1primnw == 5;
gen afsnpcarep1 = (p1primnw >= 1 & p1primnw <= 4) | p1primnw >= 6;
for var afscbcarep1 afsnpcarep1: replace X = . if p1primnw == .;
gen afscbcarep5 = p5primnw == 5;
gen afsnpcarep5 = (p5primnw >= 1 & p5primnw <= 4) | p5primnw >= 6;
for var afscbcarep5 afsnpcarep5: replace X = . if p5primnw == .;
label var afscbcarep1 "after school care center based (p1)";
label var afsnpcarep1 "after school care non-center based (p1)";
label var afscbcarep5 "after school care center based (p5)";
label var afsnpcarep5 "after school care non-center based (p5)";
drop p?primnw p?carnow p?numnow p?hrsnow;

***religion****;
for var p4rrelsv p2relig: replace X = . if X < 0;
gen attrelig = p4rrelsv >= 3 & p4rrelsv <= 5;
replace attrelig = . if p4rrelsv == .;
gen disrelig = p2relig == 5;
replace disrelig = . if p2relig == .;
label var attrelig "attend religious services >= several times/month (p4)";
label var disrelig "discuss religion several times/week (p2)";
drop p2relig p2argrel p4rrelsv;

***other local svces (ymca,etc.)***;
for var p2church p2cubsct p2ymca p2frmclb p5church p5cubsct p5ymca p5frmclb: replace X = . if X < 0;
for var p2church p2cubsct p2ymca p2frmclb p5church p5cubsct p5ymca p5frmclb: recode X (2=0);
gen ymcacub4hp2 = p2cubsct == 1 | p2ymca == 1 | p2frmclb == 1;
replace ymcacub4hp2 = . if p2cubsct == . & p2ymca == . & p2frmclb == .;
gen ymcacub4hp5 = p5cubsct == 1 | p5ymca == 1 | p5frmclb == 1;
replace ymcacub4hp5 = . if p5cubsct == . & p5ymca == . & p5frmclb == .;
for var ymcacu*: label var X "attend ymca, cubscouts/daisies, or 4H for exercise (p2/5)";
drop p2aerobi p2rapid p2pubprk p2spteam p2hlthcl p2typac7 p5aerobi p5rapid p5pubprk p5spteam p5hlthcl p5typac7;

***age***;
for var r?_kage r?age: replace X = . if X < 0;
for new agec1-agec4 \ var r1_kage r2_kage r3age r4age: gen X = Y/12;
gen agec5 = r5age;
recode agec5 (1 2=8.75) (3 4=9) (5 6=9.75);
for var agec*: label var X "age of child in years at interview";
drop r?_kage r?age;

***drop extra ones not used***;
drop p4immfam p4milfam p4hsbefk p1yrsliv p1mthliv p1cage* p1cever; *yrs/mth liv mostly missing;

******'classmeasures' - added 4/23/07******;
***teacher's chars (age, educ, exp, cert)***;
*age*;
for var b?age b?teach b?enjoy b?mkdiff b?yrsch b?yrspre b?yrskin b?yrsfst b?yrs2t5 b?yrs6pl b?typcer b?hghstd: replace X = . if X < 0;
for var b1age b1teach b1enjoy b1mkdiff b1yrsch b1yrspre b1yrskin b1yrsfst b1yrs2t5 b1yrs6pl b1typcer b1hghstd \ 
	var b2age b2teach b2enjoy b2mkdiff b2yrsch b2yrspre b2yrskin b2yrsfst b2yrs2t5 b2yrs6pl b2typcer b2hghstd: 
	replace X = Y if X == . & Y ~= .;
ren b1age aget1;
*love teaching*;
gen lovteach = 1 if b1teach >= 4 & b1enjoy >= 4 & b1mkdiff >= 4 & b1teach ~= . & b1enjoy ~= . & b1mkdiff ~= .;
replace lovteach = 0 if b1teach < 4 | b1enjoy < 4 | b1mkdiff < 4;
label var lovteach "enjoy (b1enjoy), make difference (b1mkdiff), choose teach again (b1teach)";
drop b1teach b1enjoy b1mkdiff;
*gender*;
gen tmale = b1tgend == 1;
replace tmale = . if b1tgend == .;
label var tmale "teacher male";
drop b1tgend;
*race/ethnicity*;
gen twhite = 1 if b1race5 == 1 & b1hisp == 2;
replace twhite = 0 if b1race5 == 2 | b1hisp == 1;
label var twhite "teacher white, non-hispanic";
drop b1hisp b1race*;
*educ*;
gen tba = b1hghstd == 1;
gen tgs = b1hghstd == 2;
gen tma = b1hghstd >= 3;
for var tba tgs tma: replace X = . if b1hghstd == .;
*drop b1hghstd;
label var tba "teacher received BA as highest degree";
label var tgs "teacher had some grad school";
label var tma "teacher received MA or higher as highest degree";
*experience*;
ren b1yrsch tyrsch;
gen totyrstchkp = b1yrskin + b1yrsfst + b1yrs2t5 + b1yrs6pl;
label var totyrstchkp "total years teaching kindergarten plus";
ren b1yrskin tyrskin;
*cert - dummy up in reg program*;
ren b1typcer tcert;

***class chars***;
*%preschool record*;
for var a1pcpre a1totag a1pmin a1boys a1girls a2disab: replace X = . if X == -9;
ren a1pcpre tpresch;
ren a1totag classsize;
ren a1pmin cpmin;
gen cpboys = a1boys / (a1boys + a1girls);
label var cpboys "% in class boys";
ren a2disab cndisab;

***time in class***;
gen ftk = 1 if f1class == 3;
replace ftk = 0 if f1class == 1 | f1class == 2;
label var ftk "full time K";
drop f1class;
for var a1hrs a1dys: replace X = . if X == -9;
gen chrswk = a1hrs*a1dys;
label var chrswk "class hours per week (a1hrs*a1dys)";

***date exams taken/evals given***;
for var c?asmt* t?rsco*: replace X = . if X == -9;
gen datec1 = mdy(c1asmtmm,c1asmtdd,c1asmtyy);
gen datec2 = mdy(c2asmtmm,c2asmtdd,c2asmtyy);
drop c?asmt*;
label var datec1 "date of fall-k child test";
label var datec2 "date of spring-k child test";
gen datet1 = mdy(t1rscomm,t1rscodd,t1rscoyy);
gen datet2 = mdy(t2rscomm,t2rscodd,t2rscoyy);
drop t?rsco*;
label var datet1 "date of fall-k teacher eval";
label var datet2 "date of spring-k teacher eval";

***alternate behavior rating***;
for var a?behvr: replace X = . if X == -9 | X == -1;
ren a1behvr t1behvr;
ren a2behvr t2behvr;

***drop extra ones not used***;
*drop a1pblk a1phis a1boys a1girls a1otlan;
drop a2*;
drop b1yrborn b1yrs* b1??comp b1elemct b1erlyct b1othcrt;

sort childid;
compress;
save procecls, replace;

*des p?noinsu p?priins p2cover p?fstamp p1fstam2 p1whenfs p?mofdst p5reqfs p1anyaid p?wicmom p?wicchd doctorp? healthp* healthc*;

