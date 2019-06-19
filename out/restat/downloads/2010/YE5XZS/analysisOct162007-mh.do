 /*analysis.do-- 	Reads yrdata.dta--
	Reads yrdata96
	Creates input for tables in paper
		
To do
1. go back to match.do and create a variable that identifies if person ever attneded school.
Now attsch is just in month kept
*/

clear
program drop _all
pause on
set more off
****************************Parameters to set******************************
* Panel
	global p 96
	global date=substr("$S_DATE",4,3)+ltrim(substr("$S_DATE",1,2))
	global user mh
* keep obs with valid sipp and der obs in t and t-1
	global balanced=1
* Generate plots
	global plots=1
***************************************************************************
program define persons
	display "Number of persons"
	sort seq obs
	qui by seq:gen first=_n==1
	sum seq matched if first==1
	drop first
end
if "$user"=="pg"{
	global x= "/Users/gottscha/Desktop/Parallel Share Folder/Measurement error/Minh paper\PG output"
		* Minh uses $x and $y. they are same directory for me
		global y= "${x}"
	cd "$x"
	log using  "${x}\analysis$p$S_DATE.log",replace
		display "$S_DATE  $S_TIME"
	set mem 90m
*	use "C:\Documents and Settings\GOTTSCHA\My Documents\Measurement error\Minh paper\data\yrdata$p.dta", clear
	use "/Users/gottscha/Desktop/Parallel Share Folder/Measurement error/Minh paper/data/yrdata$p.dta", clear
*Pseudo DER data
	qui gen der=exp(10.5+.78*invnormal(uniform()))
	qui gen matched=1
		
	persons
	sum
}

if "$user"=="mh"{
#delimit ;
set mem 750m;
global y="C:\projects\RRC\" ;

log using "${y}\analysis-$p-$date.log",replace;
display "$date $S_DATE  $S_TIME";
use "${y}\yrdata96",clear;
renvars, upper;
if $p==84{;
/**keep if YEAR==1983|YEAR==1984|YEAR==1985|YEAR==1986;**/
keep if YEAR==1984|YEAR==1985;
};
if $p==90{;
/*keep if YEAR==1989|YEAR==1990|YEAR==1991|YEAR==1992 ;*/
keep if YEAR==1990|YEAR==1991;
};
if $p==93{;
/*keep if YEAR==1993|YEAR==1994|YEAR==1995|YEAR==1996  ;*/
keep if YEAR==1994|YEAR==1995;
};
if $p==96{;
keep if YEAR==1996|YEAR==1997|YEAR==1998|YEAR==1999 ;
};

tostring SUID PPENTRY PPPNUM, usedisplayformat replace;
gen str19 NUMID=SUID+PPENTRY+PPPNUM;
dups NUMID,terse;
sort NUMID;
save "${y}\yrdata-$p-a",replace;


use C:\RRC\data\admin\derfile\RAE-$p-Taxinc,clear;
renvars, upper;
/*gen str19 NUMID=ID_SUID+ID_NTRY+ID_PNUM;
keep if NUMID~="";
dups NUMID;*/
if "$p"=="84"{;
/*replace RAE1983=1.7289156626506*RAE1983;*/
replace RAE1984=1.65736284889317*RAE1984;
replace RAE1985=1.6003717472119*RAE1985;
/*replace RAE1986=1.57116788321168*RAE1986;*/

};
if "$p"=="90"{;
/*replace RAE1989=1.38870967741935*RAE1989;*/
replace RAE1990=1.31752104055088*RAE1990;
replace RAE1991=1.26431718061674*RAE1991;
/*replace RAE1992=1.22736992159658*RAE1992;*/
};
if "$p"=="93"{;
/*replace RAE1993=1.1916955017301*RAE1993;*/
replace RAE1994=1.16194331983806*RAE1994;
replace RAE1995=1.12992125984252*RAE1995;
/*replace RAE1996=1.09751434034417*RAE1996;*/
};
if "$p"=="96"{;
replace RAE1996=1.09751434034417*RAE1996;
replace RAE1997=1.07289719626168*RAE1997;
replace RAE1998=1.05644171779141*RAE1998;
replace RAE1999=1.03361344537815*RAE1999;
};
keep if NUMID ~="";

if $p==84{;
/*keep NUMID RAE1983 RAE1984 RAE1985 RAE1986;*/
keep NUMID RAE1984 RAE1985;
};
if $p==90{;
/*keep NUMID RAE1989 RAE1990 RAE1991 RAE1992;*/
keep NUMID RAE1990 RAE1991;
};
if $p==93{;
/*keep NUMID RAE1993 RAE1994 RAE1995 RAE1996 ;*/
keep NUMID RAE1994 RAE1995;
};
if $p==96{;
keep NUMID RAE1996 RAE1997 RAE1998 RAE1999 ;
};
reshape long RAE,i(NUMID) j(YEAR);
sort NUMID;
merge NUMID using "${y}\yrdata-$p-a";
tab _merge;
gen MATCHED=(_merge==3);
tab MATCHED;
tab MATCHED ATTSCH;

drop _merge;
gen WHITE=(NONWHITE==0);

keep NUMID RAE FEMALE WHITE BLACK HISPANIC MATCHED YEAR ATTSCH;
summ;
reshape wide RAE  ATTSCH,i(NUMID) j(YEAR);

/**top coding values above above 150K are replaced by
mean of values above 150K for each of the groups by
gender, ethnicity, race, match status--total of 24 categories
of topcodes for each of the 4 years

Female  White   Black   Hispanic        Matched
0       0       0       0               0
0       0       0       0               1
0       0       0       1               0
0       0       0       1               1
0       0       1       0               0
0       0       1       0               1
0       0       1       1               0
0       0       1       1               1
0       1       0       0               0
0       1       0       0               1
0       1       0       1               0
0       1       0       1               1
1       0       0       0               0
1       0       0       0               1
1       0       0       1               0
1       0       0       1               1
1       0       1       0               0
1       0       1       0               1
1       0       1       1               0
1       0       1       1               1
1       1       0       0               0
1       1       0       0               1
1       1       0       1               0
1       1       0       1               1


**/

/**local i=96;
while `i'<=99 {;
       quietly summ RAE19`i' if RAE19`i'>=150000, detail;
       gen topcode`i'=r(mean);
       replace RAE19`i'=topcode`i' if RAE19`i'>=150000;
       local i=`i'+1;
       };**/

tab MATCHED;
local i=1996;
while `i'<=1999 {;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==0&HISPANIC==0&MATCHED==1 ;    gen topcode`i'=r(mean); replace topcode`i'=r(mean) if FEMALE==0&WHITE==0&BLACK==0&HISPANIC==0&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==0&HISPANIC==0&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==0&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==0&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==0&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==0&HISPANIC==0&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==0&BLACK==0&HISPANIC==0&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==0&HISPANIC==0&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==0&HISPANIC==0&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==0&BLACK==0&HISPANIC==0&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==0&HISPANIC==0&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==0&HISPANIC==1&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==1&HISPANIC==0&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==0&BLACK==1&HISPANIC==1&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==1&BLACK==0&HISPANIC==0&MATCHED==1&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==0 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==0; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==0&topcode`i'~=.;
 quietly summ RAE`i' if RAE`i'>=150000&FEMALE==1&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==1 ; replace topcode`i'=r(mean) if FEMALE==1&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==1; replace RAE`i'=topcode`i' if RAE`i'>=150000&FEMALE==1&WHITE==1&BLACK==0&HISPANIC==1&MATCHED==1&topcode`i'~=.;
local i=`i'+1;
};


save "${y}\Aged-Earnings-Analysis-File-$p-$date",replace;
renvars, presub(RAE DER);
reshape long DER  ATTSCH,i(NUMID) j(YEAR);
sort NUMID;
merge NUMID using "${y}\yrdata-$p-a";
tab _merge;
tab MATCHED;
tab MATCHED _merge;
tab MATCHED ATTSCH,missing;

drop _merge;

renvars, lower;
save "${y}\Temp-File-$p-$date",replace;
#delimit cr
}
********************--START COMMON SECTION--***********************
display "Panel= $p"
display "Date= $date"
display "User= $date"
display "Balanced panel= $balanced"


* Sample cuts--
*	Note: 
*		validearn==1 indicates 12 month of valid earn, including yrearn==0
*		dropped 40 person years with yrhours=0 but yrean>0
	keep if  female==0 & age>=25 & age<=62 & attsch==0 & validearn==1 & yrearn>0 & yrhours1>0
	drop attsch validearn
display "All cases with valid earnings"
	persons

*Create vars
 	recode hicomp 1/11=11
	rename yrearn sipp
	label var sipp "SIPP"
	label var der "DER"
	qui gen lnder=ln(der) if der>0
	qui gen lnsipp=ln(sipp) if sipp>0

* 	Imputation methods
      qui gen byte impute=imp_none==0
	label var impute "Imputed"
	label var imphotdeck "Hot-deck"
	label var implogic "Logical"
	label var impprevwave "Prev wave "

*	Non-imputed sipp variable
	qui gen lnsippni=lnsipp
		qui replace lnsippni=. if impute==1
*		label var lnsippni "SIPP-not imputed"

*	Measurement error
		qui gen diff=lnsipp-lnder
		qui gen diffni=lnsippni-lnder
	
*	Lagged values
	sort seq obs
	global t=1
	while $t<=3{
		qui by seq:gen lnder_$t=lnder[_n-$t] if year==year[_n-$t]+$t 
		qui by seq:gen lnsipp_$t=lnsipp[_n-$t] if year==year[_n-$t]+$t 
		qui by seq:gen lnsippni_$t=lnsippni[_n-$t] if year==year[_n-$t]+$t 
		qui by seq:gen diff_$t=diff[_n-$t] if year==year[_n-$t]+$t 
		qui by seq:gen diffni_$t=diffni[_n-$t] if year==year[_n-$t]+$t 
*		qui by seq:gen rlnder_$t=rlnder[_n-$t] if year==year[_n-$t]+$t 
*		qui by seq:gen rlnsipp_$t=rlnsipp[_n-$t] if year==year[_n-$t]+$t 
		global t=$t+1
	}
	quietly gen validni=(diffni~=. & diffni_1~=.)

*****Labels 
	label var lnder "E*(t)"
	label var lnsipp "E(t)"
	label var lnsippni "Non-imp E(t)"
	label var lnder_1 "E*(t-1)"
	label var lnsipp_1 "E(t-1)"
	label var lnsippni_1 "Non-imp E(t-1)"
	label var diff "v"
	label var diff_1 "mu"
	label var diffni "Non-imp v"
	label var diffni_1 "Non-imp mu"


display "*****Means, sd and mobility --DER cases before cut on match and balanced****"	 
	*
	display "Table A1-- Col 1--All"
		sum  lnder
		regress lnder lnder_1
	table year ,c(mean lnder sd lnder n lnder)col row
*********Descriptives on matches
	sum matched
	table agecat,c(mean matched)
	*Descriptives (possibly add to Table 1)
	* All persons
		sum 
		tabulate hicomp


display "******Remaining analysis only on matched cases with valid SIPP and DER earnings**********"
	keep if matched==1
	persons
	if $balanced==1{
		display "**********Valid obs in t and t-1 for der and sipp*********"
		keep if diff~=. & diff_1~=.
	}
display "Matched balanced cases with valid earnings"
	persons
	*
	display "Table A2-- Col 2--Matched"
		sum  lnder
		regress lnder lnder_1
	table year ,c(mean lnder sd lnder n lnder)col row

	*
	display "Descriptives for Table 1"
		* All persons
			sum 
			tabulate hicomp
		* Non-imputed
			sum if impute==0
			tabulate hicomp if impute==0

display "Dist of imputation methods"
	sum impute imp_none imphotdeck implogic impprevwave 
	drop imphotdeck implogic impprevwave imp_none

*Get epsilon--residuals from mobility equation
	qui regress lnder lnder_1
		predict eps,resid
		label var eps "e in mob eq"
	qui regress lnder lnder_1 if diffni~=.
		predict epsni,resid
		label var epsni "e in mob eq run on non-imputed"

	*Create lagged values
	sort seq obs
	global t=1
	while $t<=2{
		qui by seq:gen eps_$t=eps[_n-$t] if year==year[_n-$t]+$t 
		qui by seq:gen epsni_$t=epsni[_n-$t] if year==year[_n-$t]+$t 
		global t=$t+1
	}


display "Means and sd for Table 2"	 
	sum  lnder lnsipp diff lnder_1 lnsipp_1 diff_1 eps
	sum  lnder lnsippni diffni lnder_1 lnsippni_1 diffni_1 epsni if diffni~=.
	sum diff,detail
display "test diff in means"	
	ttest lnder=lnsipp
	ttest lnder=lnsippni
display "test diff in variances"
	sdtest lnder==lnsipp
	sdtest lnder==lnsippni

display "Perm component of measurement errorfor structure of measurement error section""
	qui by seq: egen diff_perm=mean(diff)
	qui by seq: egen count=count(diff_1)
	qui by seq: gen first=_n==1
	
	sum diff diff_1 diff_perm if first==1
	bysort count: sum diff diff_1 diff_perm if first==1
	
*Not used
	table year ,c(mean lnder mean lnsipp mean diff mean lnsippni mean diffni)col row
	table year ,c(sd lnder sd lnsipp sd lnsippni)col row


*********************************Mobility Measures*******************************
display "Table S --not sure if will use"
*Shorrocks Measure from 96 panel
	if $p==96{
		qui gen sipp2yr=sipp if(year==1997|year==1998)
		qui gen der2yr=der if(year==1997|year==1998)
		sort seq obs
		by seq:egen sippvalid97_98=count(sipp2yr)
		by seq:egen dervalid97_98=count(der2yr)
		by seq:egen xxsipp=sum(sipp2yr)
		by seq:egen xxder=sum(der2yr)
		qui gen lnsipp97_98=ln(xxsipp) if sippvalid97_98==2 & sipp2yr~=.
		qui gen lnder97_98=ln(xxder) if dervalid97_98==2 & der2yr~=.
		drop xxder xxsipp dervalid97_98 sippvalid97_98 der2yr sipp2yr
		display "Shorrocks Mobility"
		table year if lnsipp97_98~=., c(mean lnsipp sd lnsipp sd lnsipp97_98 n lnsipp97_98)
		table year if lnder97_98~=., c(mean lnder sd lnder sd lnder97_98 n lnder97_98)
	}

display "Correlations"
	pwcorr diff diff_1 eps lnder lnder_1 lnsipp lnsipp_1,obs
	pwcorr diffni diffni_1 epsni lnder lnder_1 lnsippni lnsippni_1 if validni==1,obs
	bysort year: pwcorr lnder lnder_1 lnsipp lnsipp_1 lnsippni lnsippni_1
display "Covariance structure"
	pwcorr lnder  lnder_1 lnder_2 lnder_3,obs
	pwcorr lnsipp  lnsipp_1 lnsipp_2 lnsipp_3,obs
	pwcorr lnsippni  lnsippni_1 lnsippni_2 lnsippni_3,obs
	pwcorr diff  diff_1 diff_2 diff_3,obs
	pwcorr diffni  diffni_1 diffni_2 diffni_3,obs
	pwcorr eps eps_1 eps_2,obs
	pwcorr epsni epsni_1 epsni_2,obs
display "Possibly use to estimate changing covariance structure" 
	bysort year: pwcorr lnder  lnder_1 lnder_2 lnder_3,obs
	bysort year: pwcorr lnsipp  lnsipp_1 lnsipp_2 lnsipp_3,obs
	bysort year: pwcorr lnsippni  lnsippni_1 lnsippni_2 lnsippni_3,obs
*
display "Mobility regressions--Table 4"
	estimates drop _all
	regress lnder lnder_1
		estimates store lnder
	regress lnsipp lnsipp_1
		estimates store lnsipp
	regress lnsippni lnsippni_1
		estimates store lnsippni
	xi:regress lnder lnder_1 black hispanic i.agecat i.hicomp
		estimates store lnder_cov
	xi:regress lnsipp lnsipp_1 black hispanic i.agecat i.hicomp
		estimates store lnsipp_cov
	xi:regress lnsippni lnsippni_1 black hispanic i.agecat i.hicomp
		estimates store lnsippni_cov

	estout * using "${y}\mobility$p$date$user.txt",replace cells(b(fmt(%8.3f)) se(fmt(%6.3f)))/*
        	*/ style(fixed) stats(r2 N ,fmt(%6.3f %5.0f ))/*
		*/title (Table --Mobility Regressions)eqlabels()
		
display " Regression for within between demo varaince"
display " Used for comparison in conclusion"
	 xi:regress lnsipp  black hispanic i.agecat i.hicomp
	 xi:regress lnsipp i.hicomp
	 regress lnsipp  black hispanic
	 
	 xi:regress lnder  black hispanic i.agecat i.hicomp
	 xi:regress lnder i.hicomp
	 regress lnder black hispanic 
	
display "Correlations for Table 4"
	pwcorr lnder lnder_1
	xi:pcorr lnder lnder_1 black hispanic i.agecat i.hicomp
	pwcorr lnsipp lnsipp_1
	xi:pcorr lnsipp lnsipp_1 black hispanic i.agecat i.hicomp
	pwcorr lnsippni lnsippni_1
	xi:pcorr lnsippni lnsippni_1 black hispanic i.agecat i.hicomp
	
display "Structure of Measurement error regressions--Table 6"
	estimates drop _all
	regress diff lnder
 		estimates store diff
	regress diff_1 lnder_1
 		estimates store diff_1
	regress diff diff_1
 		estimates store diffa
	regress diff eps 
 		estimates store diffb
	regress eps diff
 		estimates store eps
	regress eps diff_1
 		estimates store epsa
	
	regress diffni lnder if validni==1
		estimates store diffni
	regress diffni_1 lnder_1 if validni==1
 		estimates store diffni_1
	regress diffni diffni_1 if validni==1
 		estimates store diffnia
	regress diffni epsni if validni==1
 		estimates store diffnib
	regress epsni diffni if validni==1
 		estimates store epsni
	regress epsni diffni_1 if validni==1
 		estimates store epsnia
	estout * using "${y}\erroract$p$date$user.txt",replace cells(b(fmt(%5.3f)) se( fmt(%5.3f)))/*
        	*/ style(fixed) stats(r2 N,fmt(%6.3f %5.0f)) modelwidth(7)/*
		*/title (Table --Structure of Measurement Error) eqlabels() 

* Corr Observed and measurement error
	estimates drop _all
	regress diff lnsipp
 		estimates store diff
	regress diff_1 lnsipp_1
 		estimates store diff_1
	regress diff lnsipp_1
 		estimates store diffa
	regress diffni lnsippni if validni==1
 		estimates store diffni
	regress diffni_1 lnsippni_1 if validni==1
 		estimates store diffni_1
	regress diffni lnsippni_1 if validni==1
 		estimates store diffnia
	estout * using "${y}\errorobs$p$date$user.txt",replace cells(b(fmt(%8.3f)) se(par fmt(%6.3f)))/*
        	*/ style(fixed) stats(N r2,fmt(%5.0f %6.3f))/*
		*/title (Table --Observed Earnings and Measurement Error) eqlabels() 

*************Demographic differences*******************************
*
display "Means and sd by demo characteristics for Table 3"
	table black ,c(mean lnder mean lnsipp mean diff mean lnsippni mean diffni)col row
	table black ,c(sd lnder sd lnsipp sd diff sd lnsippni sd diffni)col row
	display "test diff in means"	
		bysort black:ttest lnder=lnsipp
		by black:ttest lnder=lnsippni
	display "test diff in variances"
		by black:sdtest lnder==lnsipp
		by black:sdtest lnder==lnsippni

	table hispanic ,c(mean lnder mean lnsipp mean diff mean lnsippni mean diffni)col row
	table hispanic ,c(sd lnder sd lnsipp sd diff sd lnsippni sd diffni)col row
	display "test diff in means"	
		bysort hispanic:ttest lnder=lnsipp
		by hispanic:ttest lnder=lnsippni
	display "test diff in variances"
		by hispanic:sdtest lnder==lnsipp
		by hispanic:sdtest lnder==lnsippni
		
	table agecat ,c(mean lnder mean lnsipp mean diff mean lnsippni mean diffni)col row
	table agecat ,c(sd lnder sd lnsipp sd diff sd lnsippni sd diffni)col row
	display "test diff in means"	
		bysort agecat:ttest lnder=lnsipp
		by agecat:ttest lnder=lnsippni
	display "test diff in variances"
		by agecat:sdtest lnder==lnsipp
		by agecat:sdtest lnder==lnsippni

	table hicomp ,c(mean lnder mean lnsipp mean diff mean lnsippni mean diffni)col row
	table hicomp ,c(sd lnder sd lnsipp sd diff sd lnsippni sd diffni)col row
	display "test diff in means"	
		bysort hicomp:ttest lnder=lnsipp
		by hicomp:ttest lnder=lnsippni
	display "test diff in variances"
		by hicomp:sdtest lnder==lnsipp
		by hicomp:sdtest lnder==lnsippni

 display "***********************Start***************************************"
 display "******Duplicates the regression coef from the log file for Table 5"
 display "*****Not clear why this was done since give same reuluts**********"
	
	char black [omit] 0
	char hispanic [omit] 0
	char agecat [omit] 30
	char hicomp [omit] 11

	estimates drop _all
	*By race ethinicity
		xi:regress lnder i.black*lnder_1
			estimates store der_black
		xi:regress lnsipp i.black*lnsipp_1
			estimates store sipp_black
		xi:regress lnsippni i.black*lnsippni_1
			estimates store sippni_black

		xi:regress lnder  i.hispanic*lnder_1
			estimates store der_hispanic
		xi:regress lnsipp i.hispanic*lnsipp_1
			estimates store sipp_hispanic
		xi:regress lnsippni i.hispanic*lnsippni_1
			estimates store sippni_hispanic
	*By age group
		xi:regress lnder i.agecat*lnder_1
			estimates store der_agecat
		xi:regress lnsipp i.agecat*lnsipp_1
			estimates store sipp_agecat
		xi:regress lnsippni i.agecat*lnsippni_1
			estimates store sippni_agecat
	*By ed
		xi:regress lnder i.hicomp*lnder_1
			estimates store der_hicomp
		xi:regress lnsipp i.hicomp*lnsipp_1
			estimates store sipp_hicomp
		xi:regress lnsippni i.hicomp*lnsippni_1
			estimates store sippni_hicomp
	* Conditonal on full vector
		xi:regress lnder i.black*lnder_1  /*
			*/ i.hispanic*lnder_1 i.agecat*lnder_1 i.hicomp*lnder_1
			estimates store der_all
		xi:regress lnsipp i.black*lnsipp_1  /*
			*/ i.hispanic*lnsipp_1 i.agecat*lnsipp_1 i.hicomp*lnsipp_1
			estimates store sipp_all
		xi:regress lnsippni i.black*lnsippni_1  /*
			*/ i.hispanic*lnsippni_1 i.agecat*lnsippni_1 i.hicomp*lnsippni_1
			estimates store sippni_all
		
	estout * using "${y}\demo$p$date$user.txt",replace cells(b(fmt(%8.3f)) se(fmt(%6.3f)))/*
        	*/ style(fixed) stats(r2 N ,fmt(%6.3f %5.0f ))/*
		*/title (Table --Demographic Regressions)eqlabels()

*- to get rsquared for table
	bysort black: pwcorr lnder lnder_1 lnsipp lnsipp_1 lnsippni lnsippni_1
	bysort hispanic: pwcorr lnder lnder_1 lnsipp lnsipp_1 lnsippni lnsippni_1
	bysort agecat: pwcorr lnder lnder_1 lnsipp lnsipp_1 lnsippni lnsippni_1
	bysort hicomp: pwcorr lnder lnder_1 lnsipp lnsipp_1 lnsippni lnsippni_1
display "***********************End duplication Table 5 ***************************************"
	
****************Plots **********************************************
/* Plots--To keep manageable 	
		get perecentiles of x variable
		get means  and percentiles of y within each percentile of x
	plot
*/
program define earn_lagearn 
	while "`1'"~= ""{
	preserve
	xtile pctile=ln`1'_1,nq(100)
	collapse (mean)ln`1'_1 ln`1' diff /*
		*/ (p10)p10ln`1'=ln`1' (p90)p90ln`1'=ln`1',by(pctile)
	*saves data to be plotted in excel
		save plots`1'$p$date$user, replace
	*Plot earn against lagged earn
		qui gen byte trunc=(pctile>2 & pctile<98)
		scatter ln`1' p10ln`1' p90ln`1' ln`1'_1 if trunc==1,connect(l l 1)/*
			*/ clpattern(solid dash dash) m(i i i)/*
			*/ sort saving(ln`1'$p$date$user,replace) title(Mean ln`1')
	restore
	macro shift
	}
end

if $plots==1{
	*Earn against lagged earn
		earn_lagearn der sipp
	
	*SIPP and Error on DER
		preserve
		xtile pctile=lnder,nq(100)
		collapse (mean)lnsipp lnder diff /*
		*/ (p10)p10lnsipp=lnsipp (p90)p90lnsipp=lnsipp/*
		*/ (p10)p10diff=diff (p90)p90diff=diff,by(pctile)
	
		*saves data to be plotted in excel
		save plots_error$p$date$user, replace
	
		qui gen byte trunc=(pctile>2 & pctile<98)
		*SIPP on DER
			scatter lnsipp p10lnsipp p90lnsipp lnder if trunc==1,connect(l l 1) clpattern(solid dash dash)/*
			*/ m(i i i) sort saving(SIPP_DER$p$date$user,replace) title(lnSIPP on lnDER)
 		*Error on DER
			scatter diff p10diff p90diff lnder if trunc==1,connect(l l 1) clpattern(solid dash dash)/*
			*/ m(i i i) sort saving(diff_DER$p$date$user,replace) title(Mean Reversion)
		restore
	*Errors on lagged errors and kdens of errors
		preserve
		xtile pctile=diff_1,nq(100)
		collapse (mean)diff_1 diff eps,by(pctile)
		save plotsdiff$p$date$user, replace
		kdensity diff,saving(kden$p$date$user,replace) title(Fig 1 -- Measurement error)
		scatter diff diff_1 if pctile>5 & pctile<95,c(1 1)sort /*
			*/ saving(corr_error$p$date$user,replace) title(Correlated Measurement Error)
		restore
}

display " Transition matricies-- not used  in submission"
		xtile qder= lnder if lnder_1~=. & lnder~=.,nq(5)		
		xtile qder_1= lnder_1 if lnder_1~=. & lnder~=.,nq(5)		
		tabulate qder qder_1 ,row nofreq
	
		xtile qsipp= lnsipp if lnsipp_1~=. & lnsipp~=.,nq(5)		
		xtile qsipp_1= lnsipp_1 if lnsipp_1~=. & lnsipp~=.,nq(5)		
		tabulate qsipp qsipp_1 ,row nofreq


log close

