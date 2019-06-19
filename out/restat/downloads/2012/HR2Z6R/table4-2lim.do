capture log close;
#delimit;
set more off;
clear;

log using table4-2lim.log, replace;

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


summ topped ratio cratio ocratio;
corr cratio ocratio;




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

summ eage salary income rprem sprem ratio cratio sra toohi toolow;
summ cratio if cratio>0 & cratio~=.;
corr sra cratio cr cr2 cravg2 cru cru2 avg_cru2 incomebased;
corr sra cratio research doctoral compreh libarts private;

*tobit models;
*basic sample inc>10K, rprem>250, eage 45-65;

intreg rat1 rat2 eage eagesq eagecu  
       cri cru2 altplan, robust cluster (schl_id);
intreg rat1 rat2 eage eagesq eagecu  
       cr2 cru2 altplan, robust cluster (schl_id);

intreg rat1 rat2 eage eagesq eagecu   
      avg_cri avg_cru2 altplan, robust cluster (schl_id);
intreg rat1 rat2 eage eagesq eagecu   
      cravg2 avg_cru2 altplan, robust cluster (schl_id);

intreg rat1 rat2 eage eagesq eagecu  
       cri cru altplan if variable_cru==0, robust cluster (schl_id);
intreg rat1 rat2 eage eagesq eagecu  
       cr cru altplan if variable_cru==0, robust cluster (schl_id);




*add full controls;

intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
       cri cru2 y87-y96  
       research compreh libarts private altplan, robust cluster (schl_id);
intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
       cr2 cru2 y87-y96  
       research compreh libarts private altplan, robust cluster (schl_id);

intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
      avg_cri avg_cru2 y87-y96
      research compreh libarts private altplan, robust cluster (schl_id);
intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
      cravg2 avg_cru2 y87-y96
      research compreh libarts private altplan, robust cluster (schl_id);

intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
       cri cru y87-y96
       research compreh libarts private altplan if variable_cru==0
       , robust cluster (schl_id);

intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
       cr cru y87-y96
       research compreh libarts private altplan if variable_cru==0
       , robust cluster (schl_id);


drop if gotchars==0;

summ cratio if cratio>0 & cratio~=.;
corr sra cratio cr cr2 cravg2 cru cru2 avg_cru2 incomebased;
corr sra cratio research doctoral compreh libarts private altplan;

*add full controls + person chars;

intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
       cri cru2 y87-y96 
       female phd nonwhite humanity socsci lifesci physsci 
       business engineer profschl seniority
       research compreh libarts private altplan, robust cluster (schl_id);
intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
       cr2 cru2 y87-y96 
       female phd nonwhite humanity socsci lifesci physsci 
       business engineer profschl seniority
       research compreh libarts private altplan, robust cluster (schl_id);

intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
      cravg2 avg_cru2 y87-y96
       female phd nonwhite humanity socsci lifesci physsci 
       business engineer profschl seniority
      research compreh libarts private altplan, robust cluster (schl_id);
intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
      avg_cri avg_cru2 y87-y96
       female phd nonwhite humanity socsci lifesci physsci 
       business engineer profschl seniority
      research compreh libarts private altplan, robust cluster (schl_id);


intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
       cri cru y87-y96
       female phd nonwhite humanity socsci lifesci physsci 
       business engineer profschl seniority
       research compreh libarts private altplan if variable_cru==0
       , robust cluster (schl_id);
intreg rat1 rat2 lrincome eage eagesq eagecu linc_age  
       cr cru y87-y96
       female phd nonwhite humanity socsci lifesci physsci 
       business engineer profschl seniority
       research compreh libarts private altplan if variable_cru==0
       , robust cluster (schl_id);
