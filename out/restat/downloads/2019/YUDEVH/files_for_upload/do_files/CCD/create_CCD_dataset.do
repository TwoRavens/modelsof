*This program inputs all of the F-33, CCD, and other data, cleans it, and creates all variables, then saves as create cleaned_combined_ccd.dta

log using dataset, replace

insheet using fiscal_8687.csv
gen year1=1987
save nces_fiscal_8690, replace
clear

insheet using fiscal_8788.csv
gen year1=1988
append using nces_fiscal_8690
save nces_fiscal_8690, replace
clear

insheet using fiscal_8889.csv
gen year1=1989
append using nces_fiscal_8690
save nces_fiscal_8690, replace
clear

insheet using fiscal_8990.csv
gen year1=1990
append using nces_fiscal_8690
save nces_fiscal_8690, replace
clear

insheet using fiscal_9091.csv
gen year1=1991
append using nces_fiscal_8690
save nces_fiscal_8690, replace

destring ncesid, replace force
drop if ncesid==.
drop  yrenrollment fiscalyearend yrdata

gen censusid= substr(idcensus,1,9)
destring censusid, replace


* Create Total Revenue and Expenditure Figures

for x in any t01 t02 t06 t09 t15 t40 t41 t99 d11 d23 a09 a10 u22 u97 a12 c21 c24 ///
c25 c26 b26 c23 c27 t02 d23 t06 t09 e12 f12 g12 e13 j12 j13 e17 e07 d11 d21 ///
e08 e09 e15 e27 j11 j15 e11 e10 u20 u99: replace x=0 if x==.



replace c21=c21-c25-c26-c24

gen frev=c25+c26+b21
gen srev=c21+c27
gen lrev=t01+t02+t09+t15+t40+t41+t99+d11+d21+a09+a10+u20+u99+a12+c24
gen trev=frev+srev+lrev
gen tcapital=f12+g12
gen cexp_inst=e13+j12+j13
gen cexp_ss=e15+e17+e07+e08+e09+e15+e27+j11+j15
gen cexp_o=e11+e10
gen cexp=e12+j12+j13+j11+j15
gen texp=cexp+tcapital+l12+m12+q11+i86

* rename idcensus censusid
rename v33 denrl
rename t02 plcont
rename d23 olcont
rename t01 ptax_rev 
rename t09 stax_rev
rename f12 construction
rename f41 ltdebt_efy
rename h19 ltdebt_bfy
rename f21 ltdebt_issued
rename f31 ltdebt_retired
rename g15 capland
rename e17 cexp_ssp
rename e07 cexp_ssis
rename e08 cexp_ssga 
rename e09 cexp_sssa



drop if schlev>3
sort ncesid year1
qui by ncesid year1: gen obs=_N
drop if obs>1
drop obs

for x in any srev lrev trev frev tcapital cexp cexp_ss cexp_o ///
cexp_inst texp plcont olcont ptax_rev stax_rev construction ltdebt_efy ///
ltdebt_bfy ltdebt_issued ltdebt_retired capland cexp_ssp cexp_ssis cexp_ssga ///
cexp_sssa: replace x=x*1000

keep censusid ncesid year1 name schlev srev lrev trev frev tcapital cexp cexp_ss cexp_o ///
cexp_inst texp denrl plcont olcont ptax_rev stax_rev construction ltdebt_efy ///
ltdebt_bfy ltdebt_issued ltdebt_retired capland cexp_ssp cexp_ssis cexp_ssga ///
cexp_sssa  

compress
drop if year1==1990
save nces_fiscal_8690, replace
clear

**********************************************************************


use nces_fiscal
drop if year1==1991
append using nces_fiscal_8690
drop E15 E27
drop if denrl==0

* Drop Charter Schools
drop if agchrt=="01"
drop if agchrt=="1"

* Replace missing censusid's where possible. Most missing obs are from 1993 and 1994

gen double temp=censusid if year==1995
egen double temp1=max(temp), by(ncesid)
replace censusid=temp1 if year==1993 & censusid==.
replace censusid=temp1 if year==1994 & censusid==.
drop temp*


* Merge with nonfiscal data 

sort ncesid year1
qui by ncesid year1: gen obs=_N
drop if obs>1
drop obs

merge 1:1 year1 ncesid using nces_nfiscal
drop if _merge==2
drop _merge

* Drop nontraditional and charter schools
drop if dtype=="4"
drop if dtype=="5"
drop if dtype=="6"
drop if dtype=="7"
drop if dtype=="8"


*************************************************
gen cpi=0
replace cpi=109.6   if year1==1986
replace cpi=113.6   if year1==1987
replace cpi=118.3   if year1==1988
replace cpi=124   if year1==1989
replace cpi=130.7 if year1==1990
replace cpi=136.2 if year1==1991
replace cpi=140.3 if year1==1992
replace cpi=144.5 if year1==1993
replace cpi=148.2 if year1==1994
replace cpi=152.4 if year1==1995
replace cpi=156.9 if year1==1996
replace cpi=160.5 if year1==1997
replace cpi=163.0 if year1==1998
replace cpi=166.6 if year1==1999
replace cpi=172.2 if year1==2000
replace cpi=177.1 if year1==2001
replace cpi=179.9 if year1==2002
replace cpi=184.0 if year1==2003
replace cpi=188.9 if year1==2004
replace cpi=195.3 if year1==2005
replace cpi=201.6 if year1==2006
replace cpi=207.3 if year1==2007
replace cpi=215.3 if year1==2008
replace cpi=214.5 if year1==2009
replace cpi=218.1 if year1==2010
replace cpi=224.9 if year1==2011
replace cpi=229.6 if year1==2012

gen deflator=237/cpi
label var cpi "Consumer Price Index"
label var deflator "2015 price deflator factor"



********************************************
qui {
* Drop nontraditional schools that splipped through
drop if ncesid==1100053 
drop if ncesid==400343
drop if ncesid==400342 
drop if strpos(name, "TECH")
drop if strpos(name, "VOCATIONAL")
drop if strpos(name, "CHARTER ACADEMY")
drop if strpos(name, "CHARTER SCHOOL")
drop if strpos(name, "REAA")
drop if strpos(name, "REGIONAL EDUCATIONAL")


replace ncesid=3131220 if ncesid==3731200
replace ncesid=3103130 if ncesid==3703150
replace ncesid=3100069 if ncesid==3708520
replace ncesid=3100093 if ncesid==3735490
replace ncesid=3175770 if ncesid==3775780
replace ncesid=3910015 if ncesid==4504462
replace ncesid=3910011 if ncesid==4504501
replace ncesid=3910013 if ncesid==4504784
replace ncesid=2000012 if ncesid==2000008
replace ncesid=2000013 if ncesid==2000009
replace ncesid=2000016 if ncesid==2000010
replace ncesid=2000017 if ncesid==2000011
replace ncesid=2000015 if ncesid==2010380
replace ncesid=2000014 if ncesid==2011070
replace ncesid=1708550 if ncesid==2308550
replace ncesid=1719800 if ncesid==2319800
replace ncesid=1721030 if ncesid==2321030
replace ncesid=1900015 if ncesid==2526220
replace ncesid=2803960 if ncesid==2803940

drop if ncesid==3706100
drop if ncesid==3716680
drop if ncesid==3727750
drop if ncesid==3727930
drop if ncesid==3734890
drop if ncesid==3750490
drop if ncesid==3770800
drop if ncesid==4216350
drop if ncesid==4818630
drop if ncesid==5101771
drop if ncesid==5316680
drop if ncesid==5331830
drop if ncesid==3110110
drop if ncesid==3737770
drop if ncesid==400136
drop if ncesid==2900024
drop if ncesid==600134
drop if ncesid==3906496
drop if ncesid==4600036
drop if ncesid==1602610
drop if ncesid==3305820
drop if ncesid==5000024
drop if ncesid==3820340
drop if ncesid==2926760
}
************************************************

nsplit ncesid, digits(2 5) gen(temp temp1)
replace fipst=temp if fipst==.
drop temp* fipst1 stid
replace ccode="" if ccode=="M"
destring ccode, replace
egen double temp=max(ccode), by(ncesid)
replace ccode=temp if ccode==. & temp~=.
drop temp*
drop if ccode==.
drop if fipst==0
sort ncesid year
qui by ncesid year: gen obs=_N
drop if obs>1
drop obs

nsplit ccode, digits(2 3) gen(fipst1 fips_county)


*************************************************
* Drop DC and Hawaii
drop if fipst==11
drop if fipst==15

* Merge in County Poverty Data
replace fips_county=25 if ncesid==1200390
replace fips_county=187 if ncesid==1900028
replace fips_county=186 if ncesid==2929400
replace fips_county=186 if ncesid==2929370 
replace fips_county=231 if fipst==2 & fips_county==105
replace fips_county=231 if fipst==2 & fips_county==232
replace fips_county=231 if fipst==2 & fips_county==230
replace fips_county=231 if fipst==2 & fips_county==282
replace fips_county=261 if fipst==2 & fips_county==260
replace fips_county=261 if fipst==2 & fips_county==80
merge m:1 fipst fips_county using cpov_7090
drop if _merge==2
drop _merge

* Merge in County Income Data

replace fips_county=13 if fipst==2 & fips_county==10
replace fips_county=185 if fipst==2 & fips_county==40

merge m:1 fipst fips_county using county_income
drop if _merge==2
drop _merge
save ccd_8612_all, replace

* Merge in County Demographics
merge m:1 fipst fips_county using county_vars80
drop if _merge==2
drop _merge


* Merge in district level covariates

merge 1:1 ncesid year1 using nces_demographics
drop if _merge==2
drop _merge

* Merge in NYC demographics
merge 1:1 ncesid year1 using nyc
drop if _merge==2
drop _merge

for x in any  white black hisp asian fle tstudent: replace x=x_nyc if year1>=2006 & ncesid==3620580
for x in any  lep: replace x=x_nyc if year1>=2007 & ncesid==3620580

for x in any  fte_teachers aides guidance lea_admin lea_admins ///
sch_admin sch_admins sss_staff oss  teachers: replace x=x_nyc if year1>=2008 & ncesid==3620580

drop *_nyc fipst1 name1

rename mhhinc90 cmhhinc90
rename mhhinc80 cmhhinc80
rename mhhinc70 cmhhinc70

label var cmhhinc90 "County Median HH Inc 1989"
label var cmhhinc80 "County Median HH Inc 1979"
label var cmhhinc70 "County Median HH Inc 1969"


nsplit ncesid, digits(2 5) gen(temp temp1)
replace ncesid1=temp1 if ncesid1==.
drop temp*


******************************************************************************************************
* Merge in Cleaned FTE and Enrollment data
merge 1:1 ncesid year using ptratio_data
drop if _merge==2
drop _merge


* Merge in FTE and Enrollment based on School-level files
merge 1:1 ncesid year1 using fte_denrl_data
drop if _merge==2
drop _merge

*****************************************************************************************************
* Data Cleaning

replace denrl=1838 if ncesid==631170 & year1==2012


*DROP IF EVER BELOW 200 ENROLLMENT;
gen pop_lt_200 = denrl<200
egen ever_lt_200 = max(pop_lt_200), by(ncesid)
drop if ever_lt_200==1
drop ever_lt_200


* Follow Sample Restrictions of LRS (2017)
replace denrlf=denrl if denrlf==.
egen mean_enrl=mean(denrl), by(ncesid)
su ncesid

drop if denrl>2*mean_enrl

sort ncesid year1
by ncesid: gen lag1 = denrl[_n-1] if year1==year1[_n-1]+1
gen pcenrl=(denrl-lag1)/lag1

drop if pcenrl>.15 & pcenrl~=.
drop if pcenrl<-.15 & pcenrl~=.
su ncesid


drop lag1 pcenrl* 

* Create Outcomes

* Create per-pupil and real measures

drop srev_cap capne capoe capie capland ltdebt_bfy ltdebt_issued ///
ltdebt_retired cexp_ssom cexp_ssst cexp_ssbco cexp_ssns agchrt stax_rev ///
leaid stab state

rename ltdebt_efy ltdebt


* Create per pupil amounts
rename ptax_rev ptax

for x in any trev frev srev lrev ptax texp cexp tcapital cexp_inst ///
cexp_ss cexp_ssp cexp_ssis cexp_ssga cexp_sssa cexp_o: gen rx_pp=(x/denrl)*deflator


* Replace 0 values to missing

for x in any rtrev_pp rfrev_pp rsrev_pp rlrev_pp rptax_pp rtexp_pp rcexp_pp rtcapital_pp ///
rcexp_inst_pp rcexp_ss_pp rcexp_ssis_pp rcexp_ssga_pp rcexp_sssa_pp ///
rcexp_o_pp: replace x=. if x==0


* Drop observations with negative real state aid or missing state aid since this is our primary variable
drop if rsrev_pp<0
drop if rsrev_pp==.

gen stfips=fipst

for x in any rtrev_pp rsrev_pp rlrev_pp rtexp_pp rcexp_pp: egen mx=mean(x), by(fipst year)

for x in any rtrev_pp rsrev_pp: replace x=. if x>5*mx
for x in any rtrev_pp rsrev_pp: replace x=. if x<.2*mx

drop if rsrev_pp==.

for x in any rlrev_pp rtexp_pp rcexp_pp rcexp_inst_pp: replace x=. if rtrev_pp==.

*****************************************************************************************
* Teacher/staff data in 1992-93 - 1996-97 has one implied decimal point

for x in any aides guidance lea_admin lea_admins sch_admin sch_admins sss_staff teachers fte_teachers: ///
replace x=. if x<=0

replace teachers=. if teachers==.m

for x in any aides guidance lea_admin lea_admins sch_admin sch_admins sss_staff teachers fte_teachers: ///
replace x=x/10 if year>=1993 & year<=1997

gen fte=fte_teachers
replace fte=fte_teachers1 if fte==.
replace fte=teachers if year<1990
replace fte=. if fte<=0

* Merge in FTE data for 1987-1999
drop FTE
merge 1:1 ncesid year1 using FTE_8799
drop if _merge==2
drop _merge

* Replace missing fte data with FTE data
replace fte=FTE if fte==. & FTE~=.

replace fte=90 if ncesid==500009 & year==2008
 
replace denrlf=denrl if ncesid==4702310
replace denrlf=denrl if ncesid==400680


replace denrlf=denrl if fipst==53 & year==1991


*************************************************************************

gen ptratio1=denrlf/fte
replace ptratio1=. if ptratio1>40

drop temp

label var ptratio1 "Pupil Teacher Ratio Based only on District Data"


**********************************************************************


* Merge in 1980 District Variables from Harris et al Panel
merge m:1 ncesid using census80
replace dmedinc80=cmhhinc80 if dmedinc80==.
replace dpov80=(cpov80/100) if dpov80==.
drop if _merge==2
drop if dmedinc80==.
drop if dmedinc80==0
drop _merge

save temp, replace

************************************************************************************************************

* Create within state terciles of 1980 District Income & Poverty

/* Need to keep one observation per district and then create tercile */
sort ncesid
qui by ncesid: gen obs=_n
drop if obs>1
keep ncesid fipst dmedinc80 dpov80

egen tdinc80= xtile(dmedinc80), nq(3) by(fipst)

egen tdpov80= xtile(dpov80), nq(3) by(fipst)
*******************************

label var tdinc80 "State terciles of 1980 district median income"
label var tdpov80 "State terciles of 1980 district poverty"

save terciles80, replace
clear

****************************************************************
use temp
merge m:1 ncesid using terciles80
drop _merge

drop stfips
gen stfips=fipst
gen year=year1

merge m:1 stfips using regions
drop if _merge==2
drop _merge

save temp, replace

*******************************************************************************
* Trim off bottom and top 2 percent of ptratio and average salaries to remove outliers

keep ncesid stfips year ptratio1

for x in any ptratio1: egen xp = pctile(x), p(98.0) by(stfips year)
for x in any ptratio1: replace x=xp if x>xp & x~=.

for x in any ptratio1: egen xp = pctile(x), p(2.00) by(stfips year)
for x in any ptratio1: replace x=xp if x<xp & x~=.

for x in any ptratio1: rename x x_t

label var ptratio1_t "PTR trimming & replacing district data only"

merge 1:1 ncesid year using temp
drop _merge
save temp, replace

* Now create new ptratio variables where we drop the top and bottom observations

keep ncesid stfips year ptratio1

for x in any ptratio1: egen xp = pctile(x), p(98.0) by(stfips year)
for x in any ptratio1: replace x=. if x>xp & x~=.

for x in any ptratio1: egen xp = pctile(x), p(2.00) by(stfips year)
for x in any ptratio1: replace x=. if x<xp & x~=.

for x in any ptratio1: rename x x_d

label var ptratio1_d "PTR dropping outliers district data only"

merge 1:1 ncesid year using temp
drop _merge
save temp, replace

* Merge in additional district and county variables from 1980 for controls


merge m:1 ncesid using dvars80_may18
drop if _merge==2
drop _merge

merge m:1 ccode using county_pown80
drop if _merge==2
drop _merge

******************************************************************************

* Drop unnessesay variables
drop trev frev srev lrev texp cexp tcapital cexp_inst sal_inst cexp_ss cexp_ssp cexp_ssis cexp_ssga cexp_sssa cexp_o ///
plcont ptax olcont construction ltdebt aides guidance lea_admin lea_admins sch_admin sch_admins ///
sss_staff oss mean_enrl lag1 pcenrl lag1s pcenrls lep fle asian hisp black white pfle mrtrev_pp mrsrev_pp ///
mrlrev_pp mrtexp_pp mrcexp_pp tstudent FTE fte_teachers teachers fte_teachers1

*SAVE DATASET FOR STACKED DD .DO FILE
save stacked_dd.dta

# delimit ;

*MERGE IN STATE-LEVEL VARIABLES AND TAX AND EXPENDITURE LIMITS;
mmerge stfips year using state_vars_may18, t(n:1);
drop if _merge==2;

mmerge stfips using tels, t(n:1);
drop if _merge==2;


****** SAMPLE RESTRICTIONS *******;

*DROP IF MISSING POPULATION;
drop if ctpop80==.;

*Arizona Missing revenune data for 1987-1989;
drop if fipst==4 & year1==1987;
drop if fipst==4 & year1==1988;

*DROP ONE OBSERVATION THAT HAS MISSING LOCAL REVENUE;
drop if rlrev==.;

*Drop Alaska;
drop if fipst==2;

*DROP IF EVER BELOW 250 ENROLLMENT;
gen pop_lt_250 = denrl<250;
egen ever_lt_250 = max(pop_lt_250), by(ncesid);
drop if ever_lt_250==1;
drop ever_lt_250;


*** CREATE ONE DUMMY FOR MAIN SAMPLE THAT DROPS KS, KY, MO, TX AND MI AND WY ***;

gen KS_KY_MO_TX_MI_WY = inlist(fipst,20,21,29,48,26,56);
gen MI_WY = inlist(fipst,26,56);

*CREATE DUMMY FOR BEING AFTER 2008 (GREAT RECESSION);
gen great_recession = year1>2008;


*MERGE ON UNION POWER DATA;
mmerge stfips using union_power, t(n:1) ukeep(cb_index union_score_nospend);
drop if _merge~=3;

*MERGE IN 0/1 MANDATORY CB MEASURE;
preserve;
insheet using union_strength.csv, clear comma names;
keep stfips cb_law;
tempfile temp1;
save "`temp1'";
restore;
mmerge stfips using "`temp1'", t(n:1);
drop _merge;

*RENAME CB MEASURES;
rename cb_law upm1;
rename cb_index upm2;

* Terciles of 1980 District Median Income;
drop if tdinc80==.;
tab tdinc80, gen(q80_);

*CREATE STANDARDIZED UNION POWER INDEX FOR ALL SAMPLES;
egen upm3=std(union_score_nospend) if KS_KY_MO_TX_MI_WY==0 & great_recession==0;
egen upm3gr=std(union_score_nospend) if KS_KY_MO_TX_MI_WY==0;
egen upm3_nomiwy=std(union_score_nospend) if MI_WY==0 & great_recession==0;
egen upm3_nt3=std(union_score_nospend) if KS_KY_MO_TX_MI_WY==0 & great_recession==0 & q80_3==0;

*MERGE IN 3 VALUE INDICES;
mmerge stfips using cb_index_may18, t(n:1) umatch(fipst);
drop if _merge~=3;

rename cb_index1 upm4;
rename cb_index2 upm5;

*MAKE A COUPLE CHANGES TO INDICES;
replace upm1 = 0 if fipst==35;
replace upm5 = 2 if fipst==31;

**********************************;

* Prefered coding;
gen CSFR=0;
replace CSFR=1 if year>=1995&stfips==1;     /*Alabama */
replace CSFR=1 if year>=2005&stfips==5;      /* Arkansas Court 1994 Equity 2002 Adequacy implemented 2004-05*/
replace CSFR=1 if year>=1995&stfips==8;      /* Colorado 1994 Main Leg., LRS use 2000 Leg, implemented 2001*/
replace CSFR=1 if year>=1994&stfips==16 ;    /* Idaho Court 1993 implemented 1994-95 */
replace CSFR=1 if year>=2006&stfips==20;     /* Kansas Court 2005, Leg 1992 See Basai much bigger, LE */
replace CSFR=1 if year>=1991&stfips==21;     /* Kentucky 1989 Court Effective 1990-91, LE*/
replace CSFR=1 if year>=2003&stfips==24;     /* Maryland Leg 2002, Court 1996, LE */
replace CSFR=1 if year>=1993&stfips==25;     /* Massachusetts Court 1993, implemented 1993 */
replace CSFR=1 if year>=2007&stfips==29;     /* Missouri Court 1993, leg. adequacy in 2005, implemented 2006-07, LE */
replace CSFR=1 if year>=2006&stfips==30;     /* Montana, Court 2005 */
replace CSFR=1 if year>=1999&stfips==33;     /* NH: LRS use 2008 but Lutz 1999 */
replace CSFR=1 if year>=1998&stfips==34;     /* New Jersey Court 1990 1st (implemented 1992) 1998 Main (implemented 1999) */
replace CSFR=1 if year>=2007&stfips==36;     /* New York Court 2003 1st 2006 Main, leg. State Education Budget and Reform Act of 2007.  */
replace CSFR=1 if year>=1998&stfips==37;     /* North Carolina Court 1997 */
replace CSFR=1 if year>=2009&stfips==38;     /* North Dakota Leg 2007, LE */
replace CSFR=1 if year>=1998&stfips==39;     /* Ohio Court 1997 & 2002 with funding increase in 2001 */
replace CSFR=1 if year>=1997&stfips==47;     /* Tenessee 1992, Education Improvement Act, Fully funded 1997-98 */
replace CSFR=1 if year>=1991&stfips==48;     /* Texas Court 1989 1st, 1992 Main Court, LE */
replace CSFR=1 if year>=1999&stfips==50;     /* Vermont Leg 2003 (2004-05),Court 1997 (1998-99) */
replace CSFR=1 if year>=2011&stfips==53;     /* Washington Court, McCleary v. State, Adequacy, LE */
replace CSFR=1 if year>=1996&stfips==56;     /* Wyoming LRS use 2001 Leg but 1995 was Major Court Case */

*CREATE DUMMY FOR STATE AT SOME POINT HAS SFR;
egen treated_state = max(CSFR), by(stfips);

*CREATE STANDARDIZED UNION POWER INDEX ON SAMPLE OF TREATED STATES ONLY (ts for "treated states");
egen upm3_ts=std(union_score_nospend) if KS_KY_MO_TX_MI_WY==0 & great_recession==0 & treated_state==1;

* LRS (2016) Main Coding ;
gen CSFR_LRS=0;
replace CSFR_LRS=1 if year>=2003&stfips==5;      /* Arkansas Court 1994 Equity 2002 Adequacy implemented 2004-05*/
replace CSFR_LRS=1 if year>=2005&stfips==6;	    /* California, 2004, Leg. in response to Williams case */
replace CSFR_LRS=1 if year>=2001&stfips==8 ;     /* Colorado 1994 Main Leg., LRS use 2000 Leg, implemented 2001*/
replace CSFR_LRS=1 if year>=1994&stfips==16;     /* Idaho Court 1993 implemented 1994-95 */
replace CSFR_LRS=1 if year>=2012&stfips==18;     /* Indiana Leg 2009, and 1993 was response to court case */
replace CSFR_LRS=1 if year>=2006&stfips==20;     /* Kansas Court 2005, Leg 1992 See Basai much bigger, LE */
replace CSFR_LRS=1 if year>=1991&stfips==21;     /* Kentucky 1989 Court Effective 1990-91, LE*/
replace CSFR_LRS=1 if year>=2003&stfips==24;     /* Maryland Leg 2002, Court 1996, LE */
replace CSFR_LRS=1 if year>=1994&stfips==25;     /* Massachusetts Court 1993, implemented 1993 */
replace CSFR_LRS=1 if year>=1994&stfips==29;     /* Missouri Court 1993, leg. adequacy in 2005, implemented 2006-07, LE */
replace CSFR_LRS=1 if year>=2006&stfips==30;     /* Montana, Court 2005 */
replace CSFR_LRS=1 if year>=2009&stfips==33;     /* NH: LRS use 2008 but Lutz 1999 */
replace CSFR_LRS=1 if year>=1999&stfips==34;     /* New Jersey Court 1990 1st (implemented 1992) 1998 Main (implemented 1999) */
replace CSFR_LRS=1 if year>=2007&stfips==36;     /* New York Court 2003 1st 2006 Main, leg. State Education Budget and Reform Act of 2007.  */
replace CSFR_LRS=1 if year>=1998&stfips==37;     /* North Carolina Court 1997 */
replace CSFR_LRS=1 if year>=2008&stfips==38;     /* North Dakota Leg 2007, LE */
replace CSFR_LRS=1 if year>=1998&stfips==39;     /* Ohio Court 1997 & 2002 with funding increase in 2001 */
replace CSFR_LRS=1 if year>=1996&stfips==47;     /* Tenessee 1992, Education Improvement Act, Fully funded 1997-98 */
replace CSFR_LRS=1 if year>=1993&stfips==48;     /* Texas Court 1989 1st, 1992 Main Court, LE */
replace CSFR_LRS=1 if year>=2004&stfips==50;     /* Vermont Leg 2003 (2004-05),Court 1997 (1998-99) */
replace CSFR_LRS=1 if year>=2011&stfips==53;     /* Washington Court, McCleary v. State, Adequacy, LE */
replace CSFR_LRS=1 if year>=1996&stfips==54;     /* West Virginia Court 1995, LE both before and after */
replace CSFR_LRS=1 if year>=1996&stfips==56;     /* Wyoming LRS use 2001 Leg but 1995 was Major Court Case */



*INTERACT TERICLES AND CSFR FOR OUR PREFERRED AND THE LRS CODING;
gen q1_sfr=q80_1*CSFR;
gen q2_sfr=q80_2*CSFR;
gen q3_sfr=q80_3*CSFR;
gen q1_sfr_lrs=q80_1*CSFR_LRS;
gen q2_sfr_lrs=q80_2*CSFR_LRS;
gen q3_sfr_lrs=q80_3*CSFR_LRS;

*INTERACT THOSE WITH OUR UNION POWER MEASURES;
foreach x in 1 3 3gr 3_nomiwy 5 3_nt3 3_ts {;
	gen q1_sfr_upm`x'=q80_1*CSFR*upm`x';
	gen q2_sfr_upm`x'=q80_2*CSFR*upm`x';
	gen q3_sfr_upm`x'=q80_3*CSFR*upm`x';
	gen q1_sfr_lrs_upm`x'=q80_1*CSFR_LRS*upm`x';
	gen q2_sfr_lrs_upm`x'=q80_2*CSFR_LRS*upm`x';
	gen q3_sfr_lrs_upm`x'=q80_3*CSFR_LRS*upm`x';	
};

* Control Vectors;
replace dpurban80 = curban80 if dpurban80==.;   
replace dpblack80 = cblack80 if dpblack80==.;
replace dpcol80= ccol80 if dpcol80==.;

gen trend=year-1986;
gen trend2=trend^2;

gen black_trend=dpblack80*trend;
gen urban_trend=dpurban80*trend;
gen col_trend= dpcol80*trend;

gen inc_trend=dmedinc80*trend;

* Binding TELS;
gen btel=0;
replace btel=1 if year>=btel_year & btel_year~=0;

* Make our instrument either state aid per pupil or total revenue per pupil;
gen double rev_pp=rsrev_pp;
gen lrev_pp=log(rev_pp);

foreach s in 1 3 3gr 3_nomiwy 5 3_nt3 3_ts {;
	for x in any black_trend urban_trend inc_trend col_trend btel: gen double x_upm`s'=x*upm`s';
	gen double rev_upm`s'=rsrev_pp*upm`s';
	gen lrev_upm`s'=lrev_pp*upm`s';
};


* Define Control Vectors;
foreach x of var ptratio* {;
	replace `x'=`x'*1000;
};

*Interact enrollment in initial year with trend;
egen min_year = min(year), by(ncesid);
gen temp1 = denrl if year==min_year;
egen enr = max(temp1), by(ncesid);
gen double enr_trend = enr*trend;

foreach x in 1 3 3gr 3_nomiwy 5 3_nt3 3_ts {;
	gen enr_trend_upm`x'=enr_trend*upm`x';
};

*DROP 69 DISTRICTS THAT APPEAR ONLY ONCE IN MAIN SAMPLE;
egen temp = count(ncesid) if great_recession==0 & KS_KY_MO_TX_MI_WY==0, by(ncesid);
drop if temp==1;

*MERGE IN STATE DATA FOR TABLE 5;
mmerge stfips using state_vars_sept18, t(n:1);
drop if _merge==2;

*KEEP VARIABLES WE USE;
keep 	ncesid stfips year region fipst ccode tdinc80 trend rev_pp rtrev_pp rlrev_pp rcexp_pp ptratio1 
		enr rtexp_pp rcexp_inst rcexp_ss_pp rtcapital_pp dmedinc80 curban80 cblack80 dpcol80 
		great_recession KS_KY_MO_TX_MI_WY CSFR q1_sfr_lrs q2_sfr_lrs q3_sfr_lrs q1_sfr_lrs_upm3 q2_sfr_lrs_upm3 q3_sfr_lrs_upm3 
		btel enr_trend inc_trend urban_trend black_trend col_trend q1_sfr q2_sfr q3_sfr 
		rev_upm1 enr_trend_upm1 inc_trend_upm1 urban_trend_upm1 black_trend_upm1 col_trend_upm1 q1_sfr_upm1 q2_sfr_upm1 q3_sfr_upm1 
		rev_upm3 enr_trend_upm3 inc_trend_upm3 urban_trend_upm3 black_trend_upm3 col_trend_upm3 q1_sfr_upm3 q2_sfr_upm3 q3_sfr_upm3 
		rev_upm3gr enr_trend_upm3gr inc_trend_upm3gr urban_trend_upm3gr black_trend_upm3gr col_trend_upm3gr q1_sfr_upm3gr q2_sfr_upm3gr q3_sfr_upm3gr 
		rev_upm3_nomiwy enr_trend_upm3_nomiwy inc_trend_upm3_nomiwy urban_trend_upm3_nomiwy black_trend_upm3_nomiwy col_trend_upm3_nomiwy q1_sfr_upm3_nomiwy q2_sfr_upm3_nomiwy q3_sfr_upm3_nomiwy 
		rev_upm5 enr_trend_upm5 inc_trend_upm5 urban_trend_upm5 black_trend_upm5 col_trend_upm5 q1_sfr_upm5 q2_sfr_upm5 q3_sfr_upm5 
		rev_upm3_nt3 enr_trend_upm3_nt3 inc_trend_upm3_nt3 urban_trend_upm3_nt3 black_trend_upm3_nt3 col_trend_upm3_nt3 q1_sfr_upm3_nt3 q2_sfr_upm3_nt3 q3_sfr_upm3_nt3 
		rev_upm3_ts enr_trend_upm3_ts inc_trend_upm3_ts urban_trend_upm3_ts black_trend_upm3_ts col_trend_upm3_ts q1_sfr_upm3_ts q2_sfr_upm3_ts q3_sfr_upm3_ts
		upm3 demvote1988 pop_den1990 med_inc1990 spwhite q80_1 q80_2 q80_3 MI_WY treated_state ppov plths90 pcol90 spcol90;

*SAVE CLEANED, COMBINED DATASET;
compress;
save cleaned_combined_ccd, replace;
