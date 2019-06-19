#delimit;
clear; capture clear matrix;
set memory 4g;
set matsize 2000;



use "$startdir/$outputdata\usa_1percent_all.dta";


quietly do "$startdir/$dofiles\samestatevars.do";



keep if year>=1950; *exclude 1940?;



drop metaread citypop gq agemonth marrqtr widow occ1950 ind1950 ;
drop incbusfm incbus incbus00 incfarm incnonwg incss incwelfr incinvst incretir incsupp incother incearn deducts poverty uocc uocc95 uind uclasswk rocc rind rclasswk;
 drop agemarr durmarr marrno birthmo birthqtr yngch eldch nchlt5;

drop   urban metro metarea chborn nativity occ occ1990 ind ind1990 classwkr classwkrd occsoc indnaics wkswork1 wkswork2 hrswork1 hrswork2;
drop  citizen yrimmig yrsusa1 uhrswork qtrunemp wksunemp durunemp yrlastwk activity absent looking availble wrkrecal workedyr hadnajob;
drop datanum serial stateicp stateicp perwt marst raced higraded;




label drop metareadlbl gqlbl nfatherslbl nmotherslbl ncoupleslbl famunitlbl ind1950lbl;
label drop relatelbl agelbl yearlbl agemonthlbl marrqtrlbl citizenlbl occ1950lbl;
drop nfathers nmothers ncouples famunit sex relate;
*these are irrelevant b/c of the sample anyway;

*source: http://usa.ipums.org/usa-action/variableDescription.do?mnemonic=INCTOT;
*1999 dollars==1  ;

gen invcpi=.;
replace invcpi=    11.99            if year==   1940                ;
replace invcpi=    7.000             if year==   1950                 ;
replace invcpi=   5.725              if year==   1960                 ;
replace invcpi=    4.540             if year==   1970                 ;
replace invcpi=   2.314              if year==   1980                 ;
replace invcpi=    1.344             if year==   1990                 ;
replace invcpi=   0.964             if year==   2000                 ;
replace invcpi=   0.853             if year==   2005                 ;



gen cpi=1/invcpi;

gen minwage2000=5.15;
gen rminwage=minwage2000/invcpi;

*bottomcode at halftime real 2000 min wage;
gen  botcode=rminwage*500;


*clean up inctot, standardize coding;
gen inctotorig=inctot;
gen incwageorig=incwage;
gen incfamorig=ftotinc;
rename ftotinc incfam;
replace inctot=. if inctot==999999;
replace inctot=. if inctot==9999999;
replace incwage=. if incwage==9999999;
replace incfam=. if incfam==9999999;
replace incwage=. if incwage==999999;
replace incfam=. if incfam==999999;
/*
replace inctot=botcode if inctot<botcode & inctot!=.;
replace incwage=botcode if incwage<botcode & incwage!=.;
repalce incfam=botcode if incfam<botcode & incfam!=.;
*/
gen rinctot=inctot*invcpi;
gen rincwage=incwage*invcpi;
gen rfincfam=incfam*invcpi;

****merge in fips, make match with birthplace (bpl);

sort bpl;
merge bpl using "$startdir/$outputdata\fipscodes.dta";
destring fips, replace;
recast int fips;
label values fips statefiplbl;

*_merge is 1 for folks with non-specified birth states;
*_merge is 2 for US Territories;
drop if _merge<3;

*********special extra bottom codings******;

*******var(ln(number+Ynotbottomcoded));
sum inctot;
local mininctot `r(min)';
gen incdisplaced=inctot+ (0-`mininctot') +1;
sum incdisplaced;
gen logincdisplaced=log(incdisplaced);

*******var log transform (Pence);
gen s=.000001;
gen incIHS1=1/s * log(s*inctot + sqrt((s*inctot)^2+1));
replace s=.0003;
gen incIHS2=1/s * log(s*inctot + sqrt((s*inctot)^2+1));
replace s=.001;
gen incIHS3=1/s * log(s*inctot + sqrt((s*inctot)^2+1));

*sort inctot;
*twoway (connected incIHS1 inctot) (connected incIHS2 inctot) (connected incIHS3 inctot);


******;
gen loginc=log(inctot);
gen logwage=log(incwage);
gen logincfam=log(incfam);

replace loginc=log(botcode) if inctot<=botcode & inctot!=.;
replace logwage=log(botcode) if incwage<=botcode & incwage!=.;
replace logincfam=log(botcode) if incfam<=botcode & incfam!=.;
replace logwage=. if empstat==3;
replace loginc=. if empstat==3;
replace logincfam=. if empstat==3;
*replace loginc=. if inctot<=botcode & inctot!=.;
*replace logwage=. if incwage<=botcode & incwage!=.;
*replace logincfam=. if incfam<=botcode & incfam!=.;
gen isbottomwage=0 if incwage!=. & empstat!=3;
gen isbottominc=0 if inctot!=. & empstat!=3;
gen isbottomincfam=0 if incfam!=. & empstat!=3;
replace isbottomwage=1 if  incwage<=botcode & incwage!=. & empstat!=3;
replace isbottominc= 1 if  inctot <=botcode & inctot!=. & empstat!=3;
replace isbottomincfam= 1 if  incfam <=botcode & incfam!=. & empstat!=3;

gen logincrace=loginc;
*check employment status by bottomcode, note I've dropped bottomcoders from distribution;


*************Coarse Bins for age, cohorts, state, and years;
gen A=1 if age>=25 & age<=29;
quietly replace A=2 if age>=30 & age<=34;
quietly replace A=3 if age>=35 & age<=39;
quietly replace A=4 if age>=40 & age<=44;
quietly replace A=5 if age>=45 & age<=49;
quietly replace A=6 if age>=50 & age<=54;
quietly replace A=7 if age>=55 & age<=59;

tab A, gen(A);


gen C=1 if cohort>=1881 & cohort<=1885;
quietly replace C=2 if cohort>=1886 & cohort<=1890;
quietly replace C=3 if cohort>=1891 & cohort<=1895;
quietly replace C=4 if cohort>=1896 & cohort<=1900;
quietly replace C=5 if cohort>=1901 & cohort<=1905;
quietly replace C=6 if cohort>=1906 & cohort<=1910;
quietly replace C=7 if cohort>=1911 & cohort<=1915;
quietly replace C=8 if cohort>=1916 & cohort<=1920;
quietly replace C=9 if cohort>=1921 & cohort<=1925;
quietly replace C=10 if cohort>=1926 & cohort<=1930;
quietly replace C=11 if cohort>=1931 & cohort<=1935;
quietly replace C=12 if cohort>=1936 & cohort<=1940;
quietly replace C=13 if cohort>=1941 & cohort<=1945;
quietly replace C=14 if cohort>=1946 & cohort<=1950;
quietly replace C=15 if cohort>=1951 & cohort<=1955;
quietly replace C=16 if cohort>=1956 & cohort<=1960;
quietly replace C=17 if cohort>=1961 & cohort<=1965;
quietly replace C=18 if cohort>=1966 & cohort<=1970;
quietly replace C=19 if cohort>=1971 & cohort<=1975;
quietly replace C=20 if cohort>=1976 & cohort<=1980;

tab C, gen(C);

tab year, gen(T);
compress _all;

save "$startdir/$outputdata\cohorts_prepped", replace;

*/;

*****  BEGIN STATE COHORTS   *****;

forvalues y=1950(5)2005{;
if `y'!=1955 & `y'!=1965  & `y'!=1975   & `y'!=1985   & `y'!=1995{;

use "$startdir/$outputdata\cohorts_prepped", clear;


keep if year==`y';
if "$control"=="yes"{;


        replace higrade=educ99 if year==1990 | year==2000  | year==2005;
        quietly xi: reg loginc i.higrade*i.A i.race*i.A  i.age;
        predict eloginc, resid; 
        replace loginc=eloginc;
        drop eloginc;

        replace higrade=educ99 if year==1990 | year==2000  | year==2005;
        quietly  xi: reg loginc i.higrade*i.A  i.age  if race==1|race==2;
        predict eloginc if race==1|race==2, resid;
        tab race;
        sort race;
        by race: sum eloginc;
        replace logincrace=eloginc if race==1|race==2;
        drop eloginc;

	  quietly  xi: reg logwage i.higrade*i.A i.race*i.A  i.age ;
        predict elogwage, resid;
        replace logwage=elogwage;
        drop elogwage;

        quietly  xi: reg logincfam i.higrade*i.A i.race*i.A  i.age i.famsize i.nchild ;
        predict elogincfam, resid;
        drop _I*;
        replace logincfam=elogincfam;
        drop elogincfam;

	  quietly  xi: reg logincdisplaced i.higrade*i.A i.race*i.A  i.age ;
        predict elogincdisplaced, resid;
        replace logincdisplaced=elogincdisplaced;
        drop elogincdisplaced;

	  quietly  xi: reg incIHS1 i.higrade*i.A i.race*i.A  i.age ;
        predict eincIHS1, resid;
        replace incIHS1=eincIHS1;
        drop eincIHS1;

	  quietly  xi: reg incIHS2 i.higrade*i.A i.race*i.A  i.age ;
        predict eincIHS2, resid;
        replace incIHS2=eincIHS2;
        drop eincIHS2;

	  quietly xi: reg incIHS3 i.higrade*i.A i.race*i.A  i.age ;
        predict eincIHS3, resid;
        replace incIHS3=eincIHS3;
        drop eincIHS3; 
};
drop educ99 higrade;

keep fips race C A hhwt loginc isbottominc logwage isbottomwage logincfam logincrace isbottomincfam bpl statefip logincdisplaced incIHS1 incIHS2 incIHS3 samestate*;
gen hhwtround=round(hhwt/20);
keep if loginc!=. | logwage!=. | logincfam!=.;
keep if hhwt!=0;
drop hhwt;
expand hhwtround;
compress;
sort C A fips;

egen Ninc = count(loginc), by(C A fips);
egen Nwage=count(logwage), by(C A fips);
egen Nincfam=count(logincfam), by(C A fips);

egen p2_5loginc_state=pctile(loginc) , p(2.5) by(C A fips);
egen p97_5loginc_state=pctile(loginc) , p(97.5) by(C A fips);
egen p2_5logwage_state=pctile(logwage) , p(2.5) by(C A fips);
egen p97_5logwage_state=pctile(logwage) , p(97.5) by(C A fips);
egen p2_5logincfam_state=pctile(logincfam) , p(2.5) by(C A fips);
egen p97_5logincfam_state=pctile(logincfam) , p(97.5) by(C A fips);
egen p2_5logincdisplaced_state=pctile(logincdisplaced) , p(2.5) by(C A fips);
egen p97_5logincdisplaced_state=pctile(logincdisplaced) , p(97.5) by(C A fips);
egen p2_5incIHS1_state=pctile(incIHS1) , p(2.5) by(C A fips);
egen p97_5incIHS1_state=pctile(incIHS1) , p(97.5) by(C A fips);
egen p2_5incIHS2_state=pctile(incIHS2) , p(2.5) by(C A fips);
egen p97_5incIHS2_state=pctile(incIHS2) , p(97.5) by(C A fips);
egen p2_5incIHS3_state=pctile(incIHS3) , p(2.5) by(C A fips);
egen p97_5incIHS3_state=pctile(incIHS3) , p(97.5) by(C A fips);

gen logincwhites=logincrace if race==1;
gen logincblacks=logincrace if race==2;
gen isbottomincwhites=isbottominc if race==1;
gen isbottomincblacks=isbottominc if race==2;

drop race;

egen p2_5logincwhites_state=pctile(logincwhites) , p(2.5) by(C A fips);
egen p97_5logincwhites_state=pctile(logincwhites) , p(97.5) by(C A fips);
egen p2_5logincblacks_state=pctile(logincblacks) , p(2.5) by(C A fips);
egen p97_5logincblacks_state=pctile(logincblacks) , p(97.5) by(C A fips);


drop bpl statefip;
sort C A fips;

collapse (mean) probbotinc =isbottominc     (mean) probbotwage=isbottomwage (mean) probbotincfam=isbottomincfam 
         (mean) meanloginc =loginc          (mean) meanlogwage=logwage      (mean) meanlogincfam=logincfam
         (p1)   p01loginc  =loginc          (p1)   p01logwage =logwage      (p1)   p01logincfam =logincfam
         (p5)   p05loginc  =loginc          (p5)   p05logwage =logwage      (p5)   p05logincfam =logincfam
         (p10)  p10loginc  =loginc          (p10)  p10logwage =logwage      (p10)  p10logincfam =logincfam
         (p25)  p25loginc  =loginc          (p25)  p25logwage =logwage      (p25)  p25logincfam =logincfam
         (p50)  p50loginc  =loginc          (p50)  p50logwage =logwage      (p50)  p50logincfam =logincfam
         (p90)  p90loginc  =loginc          (p90)  p90logwage =logwage      (p90)  p90logincfam =logincfam
         (p75)  p75loginc  =loginc          (p75)  p75logwage =logwage      (p75)  p75logincfam =logincfam
         (p95)  p95loginc  =loginc          (p95)  p95logwage =logwage      (p95)  p95logincfam =logincfam
         (p99)  p99loginc  =loginc          (p99)  p99logwage =logwage      (p99)  p99logincfam =logincfam
         (sd)   sdloginc   =loginc          (sd)   sdlogwage  =logwage      (sd)   sdlogincfam  =logincfam

         (mean) meanincIHS1 =incIHS1          (mean) meanincIHS2=incIHS2      (mean) meanincIHS3=incIHS3
         (p1)   p01incIHS1  =incIHS1          (p1)   p01incIHS2 =incIHS2      (p1)   p01incIHS3 =incIHS3
         (p5)   p05incIHS1  =incIHS1          (p5)   p05incIHS2 =incIHS2      (p5)   p05incIHS3 =incIHS3
         (p10)  p10incIHS1  =incIHS1          (p10)  p10incIHS2 =incIHS2      (p10)  p10incIHS3 =incIHS3
         (p25)  p25incIHS1  =incIHS1          (p25)  p25incIHS2 =incIHS2      (p25)  p25incIHS3 =incIHS3
         (p50)  p50incIHS1  =incIHS1          (p50)  p50incIHS2 =incIHS2      (p50)  p50incIHS3 =incIHS3
         (p90)  p90incIHS1  =incIHS1          (p90)  p90incIHS2 =incIHS2      (p90)  p90incIHS3 =incIHS3
         (p75)  p75incIHS1  =incIHS1          (p75)  p75incIHS2 =incIHS2      (p75)  p75incIHS3 =incIHS3
         (p95)  p95incIHS1  =incIHS1          (p95)  p95incIHS2 =incIHS2      (p95)  p95incIHS3 =incIHS3
         (p99)  p99incIHS1  =incIHS1          (p99)  p99incIHS2 =incIHS2      (p99)  p99incIHS3 =incIHS3
         (sd)   sdincIHS1   =incIHS1          (sd)   sdincIHS2  =incIHS2      (sd)   sdincIHS3  =incIHS3

         (mean) meanlogincdisplaced =logincdisplaced         
         (p1)   p01logincdisplaced  =logincdisplaced          
         (p5)   p05logincdisplaced  =logincdisplaced          
         (p10)  p10logincdisplaced  =logincdisplaced          
         (p25)  p25logincdisplaced  =logincdisplaced          
         (p50)  p50logincdisplaced  =logincdisplaced          
         (p90)  p90logincdisplaced  =logincdisplaced          
         (p75)  p75logincdisplaced  =logincdisplaced          
         (p95)  p95logincdisplaced  =logincdisplaced          
         (p99)  p99logincdisplaced  =logincdisplaced          
         (sd)   sdlogincdisplaced   =logincdisplaced          

         (mean) Ninc                        (mean) Nwage                    (mean) Nincfam
         (mean) probbotincblacks=isbottomincblacks     (mean) probbotincwhites =isbottomincwhites
         (count) Nincwhites=logincwhites Nincblacks=logincblacks  
         (mean) meanlogincblacks=logincblacks meanlogincwhites=logincwhites
         (sd)  sdlogincblacks=logincblacks  sdlogincwhites=logincwhites
         (p1)  p01logincblacks=logincblacks p01logincwhites=logincwhites
         (p5)  p05logincblacks=logincblacks p05logincwhites=logincwhites
         (p10) p10logincblacks=logincblacks p10logincwhites=logincwhites
         (p25) p25logincblacks=logincblacks p25logincwhites=logincwhites
         (p50) p50logincblacks=logincblacks p50logincwhites=logincwhites
         (p90) p90logincblacks=logincblacks p90logincwhites=logincwhites
         (p75) p75logincblacks=logincblacks p75logincwhites=logincwhites
         (p95) p95logincblacks=logincblacks p95logincwhites=logincwhites
         (p99) p99logincblacks=logincblacks p99logincwhites=logincwhites
         (mean) samestate samestate5yaMIG samestate5ya samestate10ya samestate15ya samestate20ya samestate25ya samestate30ya		
         p2_5loginc=p2_5loginc_state              p97_5loginc=p97_5loginc_state
	   p2_5logwage=p2_5logwage_state            p97_5logwage=p97_5logwage_state
	   p2_5logincfam=p2_5logincfam_state        p97_5logincfam=p97_5logincfam_state
         p2_5incIHS1=p2_5incIHS1_state            p97_5incIHS1=p97_5incIHS1_state
	   p2_5incIHS2=p2_5incIHS2_state            p97_5incIHS2=p97_5incIHS2_state
	   p2_5incIHS3=p2_5incIHS3_state            p97_5incIHS3=p97_5incIHS3_state
	   p2_5logincdisplaced=p2_5logincdisplaced_state        p97_5logincdisplaced=p97_5logincdisplaced_state
         p97_5logincblacks=p97_5logincblacks_state p2_5logincblacks=p97_5logincblacks_state 
         p97_5logincwhites=p97_5logincwhites_state p2_5logincwhites=p2_5logincwhites_state,
        by(C A fips);
gen year=1900+(C+A)*5;
*note that fweight is equivalent to pweight here but sd is allowed for pweight;
*also note that Ninc and Nwage and Nincfam are unweighted;

gen varloginc =sdloginc ^2;
gen varlogwage=sdlogwage^2;
gen varlogincfam=sdlogincfam^2;
gen varincIHS1 =sdincIHS1 ^2;
gen varincIHS2=sdincIHS2^2;
gen varincIHS3=sdincIHS3^2;
gen varlogincdisplaced=sdlogincdisplaced^2;
gen varlogincwhites=sdlogincwhites^2;
gen varlogincblacks=sdlogincblacks^2;

drop sd*;
recast int year;
save "$startdir/$outputdata\statecohorts_fweight_`y'$control", replace;
};
};


*****  END STATE COHORTS   *****;
*/;
clear;
************* BEGIN NATIONAL COHORTS  ************;
forvalues y=1950(5)2005{;

if `y'!=1955 & `y'!=1965  & `y'!=1975   & `y'!=1985   & `y'!=1995{;

use "$startdir/$outputdata\cohorts_prepped", clear;
keep if year==`y';

if "$control"=="yes"{;

        replace higrade=educ99 if year==1990 | year==2000  | year==2005;
        quietly xi: reg loginc i.higrade*i.A i.race*i.A  i.age;
        predict eloginc, resid;
        replace loginc=eloginc;
        drop eloginc;

        replace higrade=educ99 if year==1990 | year==2000  | year==2005;
        quietly xi: reg loginc i.higrade*i.A  i.age if race==1|race==2;
        predict eloginc if race==1|race==2, resid;
        tab race;
        sort race;
        by race: sum eloginc;
        replace logincrace=eloginc if race==1|race==2;
        drop eloginc;

	  quietly xi: reg logwage i.higrade*i.A i.race*i.A  i.age;
        predict elogwage, resid;
        replace logwage=elogwage;
        drop elogwage;

        quietly xi: reg logincfam i.higrade*i.A i.race*i.A  i.age i.famsize i.nchild;
        predict elogincfam, resid;
        drop _I*;
        replace logincfam=elogincfam;
        drop elogincfam;

	  quietly xi: reg logincdisplaced i.higrade*i.A i.race*i.A  i.age;
        predict elogincdisplaced, resid;
        replace logincdisplaced=elogincdisplaced;
        drop elogincdisplaced;

	  quietly xi: reg incIHS1 i.higrade*i.A i.race*i.A  i.age;
        predict eincIHS1, resid;
        replace incIHS1=eincIHS1;
        drop eincIHS1;

	  quietly xi: reg incIHS2 i.higrade*i.A i.race*i.A  i.age;
        predict eincIHS2, resid;
        replace incIHS2=eincIHS2;
        drop eincIHS2;

	  quietly xi: reg incIHS3 i.higrade*i.A i.race*i.A  i.age;
        predict eincIHS3, resid;
        replace incIHS3=eincIHS3;
        drop eincIHS3;

};
drop educ99 higrade;

keep fips C A hhwt loginc race logincrace isbottominc logwage isbottomwage logincfam isbottomincfam bpl statefip logincdisplaced incIHS1 incIHS2 incIHS3;
gen hhwtround=round(hhwt/20);
keep if loginc!=. | logwage!=. | logincfam!=.;
keep if loginc!=.;
keep if hhwt!=0;
expand hhwtround;
sort C A;


egen p2_5loginc_nat=pctile(loginc), p(2.5) by(C A);
egen p97_5loginc_nat=pctile(loginc) , p(97.5) by(C A);
egen p2_5logwage_nat=pctile(logwage) , p(2.5) by(C A );
egen p97_5logwage_nat=pctile(logwage) , p(97.5) by(C A );
egen p2_5logincfam_nat=pctile(logincfam) , p(2.5) by(C A );
egen p97_5logincfam_nat=pctile(logincfam) , p(97.5) by(C A );
egen p2_5logincdisplaced_nat=pctile(logincdisplaced), p(2.5) by(C A);
egen p97_5logincdisplaced_nat=pctile(logincdisplaced) , p(97.5) by(C A);
egen p2_5incIHS1_nat=pctile(incIHS1), p(2.5) by(C A);
egen p97_5incIHS1_nat=pctile(incIHS1) , p(97.5) by(C A);
egen p2_5incIHS2_nat=pctile(incIHS2), p(2.5) by(C A);
egen p97_5incIHS2_nat=pctile(incIHS2) , p(97.5) by(C A);
egen p2_5incIHS3_nat=pctile(incIHS3), p(2.5) by(C A);
egen p97_5incIHS3_nat=pctile(incIHS3) , p(97.5) by(C A);

gen logincwhites=logincrace if race==1;
gen logincblacks=logincrace if race==2;
gen isbottomincwhites=isbottominc if race==1;
gen isbottomincblacks=isbottominc if race==2;
drop race;

egen p2_5logincwhites_nat=pctile(logincwhites) , p(2.5) by(C A );
egen p97_5logincwhites_nat=pctile(logincwhites) , p(97.5) by(C A );
egen p2_5logincblacks_nat=pctile(logincblacks) , p(2.5) by(C A );
egen p97_5logincblacks_nat=pctile(logincblacks) , p(97.5) by(C A );


egen Ninc = count(loginc), by(C A);
egen Nwage=count(logwage), by(C A);
egen Nincfam=count(logincfam), by(C A);
sort C A;

collapse (mean) probbotinc =isbottominc     (mean) probbotwage=isbottomwage (mean) probbotincfam=isbottomincfam
         (mean) meanloginc =loginc          (mean) meanlogwage=logwage      (mean) meanlogincfam=logincfam
         (p1)   p01loginc  =loginc          (p1)   p01logwage =logwage      (p1)   p01logincfam =logincfam
         (p5)   p05loginc  =loginc          (p5)   p05logwage =logwage      (p5)   p05logincfam =logincfam
         (p10)  p10loginc  =loginc          (p10)  p10logwage =logwage      (p10)  p10logincfam =logincfam
         (p25)  p25loginc  =loginc          (p25)  p25logwage =logwage      (p25)  p25logincfam =logincfam
         (p50)  p50loginc  =loginc          (p50)  p50logwage =logwage      (p50)  p50logincfam =logincfam
         (p90)  p90loginc  =loginc          (p90)  p90logwage =logwage      (p90)  p90logincfam =logincfam
         (p75)  p75loginc  =loginc          (p75)  p75logwage =logwage      (p75)  p75logincfam =logincfam
         (p95)  p95loginc  =loginc          (p95)  p95logwage =logwage      (p95)  p95logincfam =logincfam
         (p99)  p99loginc  =loginc          (p99)  p99logwage =logwage      (p99)  p99logincfam =logincfam
         (sd)   sdloginc   =loginc          (sd)   sdlogwage  =logwage      (sd)   sdlogincfam  =logincfam

         (mean) meanincIHS1 =incIHS1          (mean) meanincIHS2=incIHS2      (mean) meanincIHS3=incIHS3
         (p1)   p01incIHS1  =incIHS1          (p1)   p01incIHS2 =incIHS2      (p1)   p01incIHS3 =incIHS3
         (p5)   p05incIHS1  =incIHS1          (p5)   p05incIHS2 =incIHS2      (p5)   p05incIHS3 =incIHS3
         (p10)  p10incIHS1  =incIHS1          (p10)  p10incIHS2 =incIHS2      (p10)  p10incIHS3 =incIHS3
         (p25)  p25incIHS1  =incIHS1          (p25)  p25incIHS2 =incIHS2      (p25)  p25incIHS3 =incIHS3
         (p50)  p50incIHS1  =incIHS1          (p50)  p50incIHS2 =incIHS2      (p50)  p50incIHS3 =incIHS3
         (p90)  p90incIHS1  =incIHS1          (p90)  p90incIHS2 =incIHS2      (p90)  p90incIHS3 =incIHS3
         (p75)  p75incIHS1  =incIHS1          (p75)  p75incIHS2 =incIHS2      (p75)  p75incIHS3 =incIHS3
         (p95)  p95incIHS1  =incIHS1          (p95)  p95incIHS2 =incIHS2      (p95)  p95incIHS3 =incIHS3
         (p99)  p99incIHS1  =incIHS1          (p99)  p99incIHS2 =incIHS2      (p99)  p99incIHS3 =incIHS3
         (sd)   sdincIHS1   =incIHS1          (sd)   sdincIHS2  =incIHS2      (sd)   sdincIHS3  =incIHS3

         (mean) meanlogincdisplaced =logincdisplaced         
         (p1)   p01logincdisplaced  =logincdisplaced          
         (p5)   p05logincdisplaced  =logincdisplaced          
         (p10)  p10logincdisplaced  =logincdisplaced          
         (p25)  p25logincdisplaced  =logincdisplaced          
         (p50)  p50logincdisplaced  =logincdisplaced          
         (p90)  p90logincdisplaced  =logincdisplaced          
         (p75)  p75logincdisplaced  =logincdisplaced          
         (p95)  p95logincdisplaced  =logincdisplaced          
         (p99)  p99logincdisplaced  =logincdisplaced          
         (sd)   sdlogincdisplaced   =logincdisplaced  

         (mean) Ninc                        (mean) Nwage                    (mean) Nincfam
         p2_5loginc=p2_5loginc_nat              p97_5loginc=p97_5loginc_nat
	   p2_5logwage=p2_5logwage_nat            p97_5logwage=p97_5logwage_nat
	   p2_5logincfam= p2_5logincfam_nat       p97_5logincfam=p97_5logincfam_nat
         p2_5incIHS1=p2_5incIHS1_nat            p97_5incIHS1=p97_5incIHS1_nat
	   p2_5incIHS2=p2_5incIHS2_nat            p97_5incIHS2=p97_5incIHS2_nat
	   p2_5incIHS3=p2_5incIHS3_nat            p97_5incIHS3=p97_5incIHS3_nat
	   p2_5logincdisplaced=p2_5logincdisplaced_nat        p97_5logincdisplaced=p97_5logincdisplaced_nat

         (count) Nincwhites=logincwhites Nincblacks=logincblacks  
         (mean) meanlogincblacks=logincblacks meanlogincwhites=logincwhites
         (mean) probbotincblacks=isbottomincblacks     (mean) probbotincwhites =isbottomincwhites
         (sd)  sdlogincblacks=logincblacks  sdlogincwhites=logincwhites
         (p1)  p01logincblacks=logincblacks p01logincwhites=logincwhites
         (p5)  p05logincblacks=logincblacks p05logincwhites=logincwhites
         (p10) p10logincblacks=logincblacks p10logincwhites=logincwhites
         (p25) p25logincblacks=logincblacks p25logincwhites=logincwhites
         (p50) p50logincblacks=logincblacks p50logincwhites=logincwhites
         (p90) p90logincblacks=logincblacks p90logincwhites=logincwhites
         (p75) p75logincblacks=logincblacks p75logincwhites=logincwhites
         (p95) p95logincblacks=logincblacks p95logincwhites=logincwhites
         (p99) p99logincblacks=logincblacks p99logincwhites=logincwhites

         p97_5logincblacks=p97_5logincblacks_nat p2_5logincblacks=p97_5logincblacks_nat 
         p97_5logincwhites=p97_5logincwhites_nat p2_5logincwhites=p2_5logincwhites_nat,
        by(C A);
gen year=1900+(C+A)*5;
*note that fweight is equivalent to pweight here but sd is allowed for pweight;
*also note that Ninc and Nwage are unweighted;

gen varloginc =sdloginc ^2;
gen varlogwage=sdlogwage^2;
gen varlogincfam=sdlogincfam^2;
gen varincIHS1 =sdincIHS1 ^2;
gen varincIHS2=sdincIHS2^2;
gen varincIHS3=sdincIHS3^2;
gen varlogincdisplaced=sdlogincdisplaced^2;
gen varlogincwhites=sdlogincwhites^2;
gen varlogincblacks=sdlogincblacks^2;
drop sd*;
recast int year;
save "$startdir/$outputdata\natcohorts_fweight_`y'$control", replace;
};
};
*/;
use "$startdir/$outputdata\statecohorts_fweight_1950$control", clear;
append using "$startdir/$outputdata\statecohorts_fweight_1960$control";
append using "$startdir/$outputdata\statecohorts_fweight_1970$control";
append using "$startdir/$outputdata\statecohorts_fweight_1980$control";
append using "$startdir/$outputdata\statecohorts_fweight_1990$control";
append using "$startdir/$outputdata\statecohorts_fweight_2000$control";
append using "$startdir/$outputdata\statecohorts_fweight_2005$control";

tab year, gen(T);
save "$startdir/$outputdata\statecohorts_fweight_$control", replace;
save "$startdir/$outputdata\statecohorts_fweight$control", replace;

use "$startdir/$outputdata\natcohorts_fweight_1950$control", clear;
append using "$startdir/$outputdata\natcohorts_fweight_1960$control";
append using "$startdir/$outputdata\natcohorts_fweight_1970$control";
append using "$startdir/$outputdata\natcohorts_fweight_1980$control";
append using "$startdir/$outputdata\natcohorts_fweight_1990$control";
append using "$startdir/$outputdata\natcohorts_fweight_2000$control";
append using "$startdir/$outputdata\natcohorts_fweight_2005$control";

tab year, gen(T);
save "$startdir/$outputdata\natcohorts_fweight$control", replace;
*/
