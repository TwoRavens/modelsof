#delimit;
clear;
set matsize 800;
set memory 200m;
set more off;




/*************************************************************************

				THE ANALYSIS:

*************************************************************************/



/*
To generate population figures for TABLE 1:  run the Cross Mexican States and Cross Gender aggregators above, then type
collapse nat nathsdo, by(birthyr);
to get the averaged cohort sizes across the different censuses.  
*/


/****************************TABLE 2********************************/
/*
Using aggregated data across Mexican States; run this only if you have run the 'state aggregator' (BUT NOT 'GENDER AGGREGATOR') above.
#delimit;
xi i.statemx i.birthyrag i.year  i.sex i.age i.agdec;
#delimit;
reg dmigperc lnathsdorat lgdprat16  lgdpratdchg  [pweight=sob];
outreg lnathsdorat lgdprat16 lgdpratdchg  using "$temp/mex8", ctitle("None") nolabel replace;
reg dmigperc lnathsdorat lgdprat16  lgdpratdchg year _Isex* [pweight=sob];
outreg lnathsdorat lgdprat16  lgdpratdchg year  _Isex* using "$temp/mex8", ctitle("OLS") nolabel append;
ivreg dmigperc lgdprat16  lgdpratdchg year _Isex* (lnathsdorat=lnatrat) [pweight=sob];
outreg lnathsdorat lgdprat16  lgdpratdchg year _Isex* using "$temp/mex8", ctitle("IV") nolabel append;
ivreg dmigperc lgdprat16  lgdpratdchg year (lnathsdorat=lnatrat) if sex==1 [pweight=sob];
outreg lnathsdorat lgdprat16  lgdpratdchg  year using "$temp/mex8", ctitle("IV,men") nolabel append;
ivreg dmigperc lgdprat16  lgdpratdchg year (lnathsdorat=lnatrat) if sex==2 [pweight=sob];
outreg lnathsdorat lgdprat16  lgdpratdchg  year using "$temp/mex8", ctitle("IV,women") nolabel append;

*/



/****************************TABLE 3********************************/
/*
/*Basic Specification:*/
#delimit;
reg dmigperc lnathsdorat lgdprat16  lgdpratdchg    _Istatemx* [pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16  lgdpratdchg   using "$temp/mex0", ctitle("state") nocons nolabel  bdec(4) replace;
reg dmigperc lnathsdorat lgdprat16  lgdpratdchg   _Istatemx*   _Iyear* _Isex* _Ibirthag* [pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16  lgdpratdchg   using "$temp/mex0", ctitle("OLSstate,yr,sex,birthag") nocons  nolabel bdec(4)  append;
ivreg dmigperc lgdprat16  lgdpratdchg   _Istatemx*   _Iyear* _Isex*  _Ibirthag*  (lnathsdorat = lnatrat)[pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16  lgdpratdchg   using "$temp/mex0", ctitle("IVstate,yr,sex,birthag") nocons  nolabel bdec(4)  append;
ivreg dmigperc lgdprat16  lgdpratdchg   _Istatemx*   _Iyear* _Isex*  _Ibirthag*  (lnathsdorat = lnatrat) if sex==1 [pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16  lgdpratdchg   using "$temp/mex0", ctitle("IVmen") nocons  nolabel bdec(4)  append;
ivreg dmigperc lgdprat16  lgdpratdchg   _Istatemx*   _Iyear* _Isex*  _Ibirthag*  (lnathsdorat = lnatrat) if sex==2 [pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16  lgdpratdchg   using "$temp/mex0", ctitle("IVwomen") nocons  nolabel bdec(4)  append;
/*




/****************************TABLE 4********************************/
/*NETWORK EFFECTS:*/
/*Estimating interaction effects with migration networks:*/
#delimit;
egen migrt24m=mean(migrt24);
egen dist_trenm=mean(dist_tren);
egen distfronm=mean(distfron);
gen migrt24dm=migrt24-migrt24m;
gen dist_trendm=dist_tren-dist_trenm;
gen distfrondm=distfron-distfronm;
gen miglrathsdo=migrt24dm*lnathsdorat;
gen miglrat=migrt24dm*lnatrat;
gen frolrat=distfrondm*lnathsdorat;
gen trnlrathsdo=dist_trendm*lnathsdorat;
gen trnlrat=dist_trendm*lnatrat;
gen miggdprat=migrt24dm*lgdprat16;
gen trngdprat=dist_trendm*lgdprat16;
gen gdplsint=lgdprat16*lnathsdorat;
gen lsobbaseint=lsobbase*yrs16dm;
gen lgdprat16int=lgdprat16*yrs16dm;
gen lnatrat16int=lnatrat*yrs16dm;
gen lnathsdorat16int=lnathsdorat*yrs16dm;
egen m24h=pctile(migrt24), p(66);
gen m24high=0;  replace m24high=1 if migrt24>=m24h & migrt24!=.;
egen m24l=pctile(migrt24), p(33);
gen m24low=0;  replace m24low=1 if migrt24<=m24l;

#delimit;
ivreg dmigperc  lgdprat16  lgdpratdchg _Istatemx*  _Iyear* _Isex* _Ibirthag* (lnathsdorat miglrathsdo = lnatrat miglrat) [pweight=sob] , cluster(cohortid);
outreg lnathsdorat miglrathsdo lgdprat16  lgdpratdchg  using "$temp/mex7", nolabel nocons bdec(5) replace;
ivreg dmigperc lgdprat16  lgdpratdchg _Istatemx*  _Iyear* _Isex* _Ibirthag* (lnathsdorat trnlrathsdo = lnatrat trnlrat) [pweight=sob] , cluster(cohortid);
outreg lnathsdorat trnlrathsdo lgdprat16  lgdpratdchg  using "$temp/mex7", nolabel nocons bdec(5) append;
ivreg dmigperc lgdprat16  lgdpratdchg lgdprat16int  yrs16dm yrs16sq _Istatemx* _Ibirthag*  _Iyear* _Isex* _Ibirthag* (lnathsdorat lnathsdorat16int = lnatrat lnatrat16int) [pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16  lgdpratdchg  lnathsdorat16int lgdprat16int yrs16dm yrs16sq using "$temp/mex7", nolabel nocons bdec(5) append;
ivreg dmigperc lgdprat16  lgdpratdchg lgdprat16int  yrs16dm yrs16sq _Istatemx* _Ibirthag*  _Iyear* _Isex* _Ibirthag* (lnathsdorat lnathsdorat16int = lnatrat lnatrat16int) if m24high==1 [pweight=sob] , cluster(cohortid);
outreg lnathsdorat  lgdprat16  lgdpratdchg lnathsdorat16int lgdprat16int yrs16dm yrs16sq using "$temp/mex7", nolabel nocons bdec(5) append;
ivreg dmigperc lgdprat16  lgdpratdchg lgdprat16int  yrs16dm yrs16sq _Istatemx* _Ibirthag*  _Iyear* _Isex* _Ibirthag* (lnathsdorat lnathsdorat16int = lnatrat lnatrat16int) if m24low==0 & m24high==0 [pweight=sob] , cluster(cohortid);
outreg lnathsdorat  lgdprat16  lgdpratdchg lnathsdorat16int lgdprat16int yrs16dm yrs16sq using "$temp/mex7", nolabel nocons bdec(5) append;
ivreg dmigperc lgdprat16  lgdpratdchg lgdprat16int  yrs16dm yrs16sq _Istatemx* _Ibirthag*  _Iyear* _Isex* _Ibirthag* (lnathsdorat lnathsdorat16int = lnatrat lnatrat16int) if m24low==1 [pweight=sob] , cluster(cohortid);
outreg lnathsdorat  lgdprat16  lgdpratdchg lnathsdorat16int lgdprat16int yrs16dm yrs16sq using "$temp/mex7", nolabel nocons bdec(5) append;




/****************************TABLE 5********************************/
/*FOR ANALYSIS VARYING AGGREGATION:  run the following with each of the three data aggregation levels above:*/
#delimit;
ivreg dmigperc  lgdprat16  lgdpratdchg _Istatemx*  _Iyear* _Isex* _Ibirthag* (lnathsdorat=lnatrat) [pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16  lgdpratdchg  using "$temp/mex2", nolabel nocons bdec(5) replace;




/****************************TABLE 6********************************/
/*
/*Analyzing the Final STock of net Migration using only Last Cohort Observed:*/
#delimit;
egen maxage=max(age), by(cohortid);
gen last=0;
replace last=1 if age==maxage & age>40 & baseage<15;
ivreg migperc lgdprat16 lgdpratdchg  _Istatemx* _Ibirthag*  _Iyear* _Isex* (lnathsdorat = lnatrat) if last==1 [pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16 lgdpratdchg  using "$temp/mex15", nolabel nocons bdec(5) replace;
ivreg migperc lgdprat16 lgdpratdchg  _Istatemx* _Ibirthag*  _Iyear* _Isex* (lnathsdorat = lnatrat) if last==1 & sex==1 [pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16 lgdpratdchg  using "$temp/mex15", nolabel nocons bdec(5) append;
ivreg migperc lgdprat16 lgdpratdchg  _Istatemx* _Ibirthag*  _Iyear* _Isex* (lnathsdorat = lnatrat) if last==1 & sex==2 [pweight=sob] , cluster(cohortid);
outreg lnathsdorat lgdprat16 lgdpratdchg  using "$temp/mex15", nolabel nocons bdec(5) append;
drop maxage last;
*/



/************************ADDITIONAL CALCULATIONS:****************************/
/*Interpreting the marginal effects from Table 3:*/
#delimit;
egen statemn=mean(lnathsdorat), by(statemx);
gen dlnathsdorat=lnathsdorat-statemn;
egen up=pctile(dlnathsdorat), p(75);
egen down=pctile(dlnathsdorat), p(25);
gen dif=up-down;
gen sim=dif*.1443;
sum sim;


/*Generating the data which goes into the Excel simulation file:*/
/*RUN THE ACROSS MEXICO AND ACROSS GENDER AGGREGATOR ABOVE FIRST:*/
#delimit;
collapse sobbase lnatrat lnathsdorat, by(birthyr);
drop if birthyr<1960;
gen blnatrat1=lnatrat if birthyr==1960;
egen blnatrat=mean(blnatrat1);
gen dlnatrat=lnatrat-blnatrat;
gen blnathsdorat1=lnathsdorat if birthyr==1960;
egen blnathsdorat=mean(blnathsdorat1);
gen dlnathsdorat=lnathsdorat-blnathsdorat;