

#delimit;
clear; capture clear matrix;
set memory 2g;
set matsize 2000;



*****  BEGIN STATE COHORTS   *****;
forvalues y=1950(5)2005{;
if `y'!=1955 & `y'!=1965  & `y'!=1975   & `y'!=1985   & `y'!=1995{;
use "$startdir/$outputdata\cohorts_prepped", clear;
keep if year==`y';

gen myeduc=0 if (higrade<15 & higrade!=00) | educ99<10;
replace myeduc=1 if myeduc==. & (higrade==15 | educ99==10);
replace myeduc=2 if myeduc==. & ( (higrade>15 & higrade<19) | (educ99>10 & educ99<14) );
replace myeduc=3 if myeduc==. & (higrade>=19 & higrade<. | educ99>=14 & educ99<.);

if "$subsample"=="whites"{;
	keep if race==1;    };
if "$subsample"=="nonwhites"{;
      keep if race!=1;       };
if "$subsample"=="LThighschool"{;
      keep if myeduc==0    ;     };
if "$subsample"=="highschool"{;
      keep if myeduc==1   ;    };
if "$subsample"=="LTbachelors"{;
      keep if myeduc==2  ;   };
if "$subsample"=="bachelors"{;
      keep if myeduc==3  ;   };
if "$subsample"=="statestayers"{;
      keep if samestate==1  ;   };
if "$subsample"=="stateswitchers"{;
      keep if samestate==0  ;   };
if "$cohort"=="presentstate"{;
drop fips _merge;
rename bpl truebpl;
gen bpl=statefip; *just for a sec!;
sort bpl;
merge bpl using "$startdir/$outputdata\fipscodes.dta";
destring fips, replace;
recast int fips;
label values fips statefiplbl;
drop bpl;
rename truebpl bpl;
drop if _merge<3;
};
if "$subsample"=="newex"{;
};


if "$control"=="yes"{;
***this doesn't run because there are not always obs in every state and every year for, say, statestayers;
***but over in makecohorts, we don't run this by state, so I think this was just something we tried?;
/*
foreach s of numlist 1 2 4 5 6 8 9 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56{;
        replace higrade=educ99 if year==1990 | year==2000  | year==2005;
        quietly xi: reg loginc i.higrade*i.A i.race*i.A  i.age if fips==`s';
        predict eloginc if fips==`s', resid; 
        replace loginc=eloginc if fips==`s';
        drop eloginc;
        di `s';
}; */;
	 	replace higrade=educ99 if year==1990 | year==2000  | year==2005;
        quietly xi: reg loginc i.higrade*i.A i.race*i.A  i.age;
        predict eloginc, resid; 
        replace loginc=eloginc;
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
};
drop race educ99 higrade;

keep fips C A hhwt loginc isbottominc logwage isbottomwage logincfam isbottomincfam bpl statefip samestate*;
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

drop bpl statefip;
sort C A fips;

collapse (mean) probbotinc =isbottominc     (mean) probbotwage=isbottomwage (mean) probbotincfam=isbottomincfam
         (mean) meanloginc =loginc          (mean) meanlogwage=logwage      (mean) meanlogincfam=logincfam
         /*(p1)   p01loginc  =loginc          (p1)   p01logwage =logwage      (p1)   p01logincfam =logincfam*/
         (p5)   p05loginc  =loginc          (p5)   p05logwage =logwage      (p5)   p05logincfam =logincfam
         /*(p10)  p10loginc  =loginc          (p10)  p10logwage =logwage      (p10)  p10logincfam =logincfam
         (p25)  p25loginc  =loginc          (p25)  p25logwage =logwage      (p25)  p25logincfam =logincfam*/
         (p50)  p50loginc  =loginc          (p50)  p50logwage =logwage      (p50)  p50logincfam =logincfam
         /*(p90)  p90loginc  =loginc          (p90)  p90logwage =logwage      (p90)  p90logincfam =logincfam
         (p75)  p75loginc  =loginc          (p75)  p75logwage =logwage      (p75)  p75logincfam =logincfam*/
         (p95)  p95loginc  =loginc          (p95)  p95logwage =logwage      (p95)  p95logincfam =logincfam
         /*(p99)  p99loginc  =loginc          (p99)  p99logwage =logwage      (p99)  p99logincfam =logincfam*/
         (sd)   sdloginc   =loginc          (sd)   sdlogwage  =logwage      (sd)   sdlogincfam  =logincfam
         (mean) Ninc                        (mean) Nwage                    (mean) Nincfam
         (mean) samestate samestate5yaMIG samestate5ya samestate10ya samestate15ya samestate20ya samestate25ya samestate30ya		
         /*p2_5loginc=p2_5loginc_state              p97_5loginc=p97_5loginc_state
	   p2_5logwage=p2_5logwage_state            p97_5logwage=p97_5logwage_state
	   p2_5logincfam=p2_5logincfam_state        p97_5logincfam=p97_5logincfam_state*/,
        by(C A fips);
gen year=1900+(C+A)*5;
*note that fweight is equivalent to pweight here but sd is allowed for pweight;
*also note that Ninc and Nwage and Nincfam are unweighted;

gen varloginc =sdloginc ^2;
gen varlogwage=sdlogwage^2;
gen varlogincfam=sdlogincfam^2;
drop sdlog*;
recast int year;
save "$startdir/$outputdata\statecohorts_fweight_`y'$control$subsample$cohort", replace;
};
};


*****  END STATE COHORTS   *****;


use "$startdir/$outputdata\statecohorts_fweight_1950$control$subsample$cohort", clear;
append using "$startdir/$outputdata\statecohorts_fweight_1960$control$subsample$cohort";
append using "$startdir/$outputdata\statecohorts_fweight_1970$control$subsample$cohort";
append using "$startdir/$outputdata\statecohorts_fweight_1980$control$subsample$cohort";
append using "$startdir/$outputdata\statecohorts_fweight_1990$control$subsample$cohort";
append using "$startdir/$outputdata\statecohorts_fweight_2000$control$subsample$cohort";
append using "$startdir/$outputdata\statecohorts_fweight_2005$control$subsample$cohort";

tab year, gen(T);
save "$startdir/$outputdata\statecohorts_fweight$control$subsample$cohort", replace;



