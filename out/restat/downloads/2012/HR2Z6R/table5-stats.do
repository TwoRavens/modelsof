capture log close;
#delimit;
set more off;
clear;

*new (may 2009) table 5;
*two-limit tobits;

log using table5-stats.log, replace;

use cru;

drop if rprem<=250;
drop if rprem==.;

gen ratio=sprem/income;


gen cratio=ratio;

gen sramax=7000;
replace sramax=7313 if year==88;
replace sramax=7627 if year==89;
replace sramax=7979 if year==90;
replace sramax=8475 if year==91;
replace sramax=8728 if year==92;
replace sramax=8994 if year==93;
replace sramax=9240 if year==94;
replace sramax=9240 if year==95;
replace sramax=9500 if year==96;

gen topped=0;
replace topped=1 if sprem>=sramax;
replace topped=0 if sprem==.;

tab year topped if cratio>0, row col;

replace cratio=sramax/income if topped==1;

gen ocratio=cratio;

gen toohi=(cratio>=.25);
gen toolow=(cratio<0);
replace cratio=. if toohi==1;
replace cratio=. if toolow==1;



replace cratio=cratio*100;
replace ocratio=ocratio*100;
replace sra=(cratio>0);


summ sra topped ratio cratio ocratio;
corr cratio ocratio ratio;



drop cr cr2;
gen cr=cru+cri;
gen cr2=cru2+cri;

gen cravg=avg_cru+avg_cri;
gen cravg2=avg_cru2+avg_cri;

gen lrincome=log(rincome);

gen research=0;
replace research=1 if carnegie=="R1";
replace research=1 if carnegie=="R2";

gen doctoral=0;
replace doctoral=1 if carnegie=="D1";
replace doctoral=1 if carnegie=="D2";

gen compreh=0;
replace compreh=1 if carnegie=="C1";
replace compreh=1 if carnegie=="C2";

gen libarts=0;
replace libarts=1 if carnegie=="L1";
replace libarts=1 if carnegie=="L1";
replace libarts=1 if carnegie=="LA1";

gen gotchars=1;
replace gotchars=0 if female==.;
replace gotchars=0 if phd==.;
replace gotchars=0 if nonwhite==.;
replace gotchars=0 if humanity==.;
replace gotchars=0 if  socsci==.;
replace gotchars=0 if  lifesci==.;
replace gotchars=0 if physsci==.;
replace gotchars=0 if business==.;
replace gotchars=0 if engineer==.;
replace gotchars=0 if profschl==.;

sum gotchars;

summ cratio if cratio>0 & cratio~=.;
corr sra cratio cr2 cri cru2 gotchars ;


gen rat1=cratio;
gen rat2=cratio;
replace rat1= . if cratio<=0;
replace rat2= 0 if cratio<=0;
replace rat2= . if topped==1;




gen inc_10k=income/10000;
replace eagesq=eage*eage/100;
replace eagecu=eage*eage*eage/1000;
gen linc_age=(eage-50)*lrincome;

gen y86=(year==86);
gen y87=(year==87);
gen y88=(year==88);
gen y89=(year==89);
gen y90=(year==90);
gen y91=(year==91);
gen y92=(year==92);
gen y93=(year==93);
gen y94=(year==94);
gen y95=(year==95);
gen y96=(year==96);

drop if cratio==.;
drop if eage<45;
drop if eage>=65;


*add full controls + person chars;

drop if gotchars==0;
drop if variable_cru==1;

gen cratio_pos=cratio;
replace cratio_pos=. if cratio<=0;

*baseline table 4, col 9;

summ sra cratio cratio_pos cr cri cru;
summ sra cratio cratio_pos cr cri cru if female==0;
summ sra cratio cratio_pos cr cri cru if female==1;

*by field;
gen humss=humanity+socsci;
gen profbiz=profschl+business;
gen remainder=1-humss-profbiz;
summ sra cratio cratio_pos cr cri cru if humss==1;
summ sra cratio cratio_pos cr cri cru if profbiz==1;
summ sra cratio cratio_pos cr cri cru if remainder==1;

gen lowinc=(lrincome<11.153);
gen lowsen=(seniority<20.04);
gen under55=(eage<55);
gen age5561=(eage>=55)*(eage<=61);
gen over61=(eage>61);
summ sra cratio cratio_pos cr cri cru if lowinc==0;
summ sra cratio cratio_pos cr cri cru if lowinc==1;
summ sra cratio cratio_pos cr cri cru if under55==1;
summ sra cratio cratio_pos cr cri cru if age5561==1;
summ sra cratio cratio_pos cr cri cru if over61==1;

