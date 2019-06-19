/* The program reads in the relevant data downloaded from the PSID website and transforms it as needed for the analysis in "House Price Fluctuations: 
The Role of Housing Wealth as Borrowing Collateral."  The are two blocks of code "datain" and "data_setup."  The database created by "datain" is provided 
as part of the data replication package to ease use.  If you prefer to download all the series from the PSID website yourself please contact the author for
 additional help.  The code for reading in the data is provided for information purposes only.  

In addition, the "data_setup" block includes code to merge in geographical based data that are constructed 
using the PSID Geocode data that cannot be provided online, but rather one must be obtain via a confidential data agreement with the PSID. 
Information about these data and how to obtain them can be found online at: http://simba.isr.umich.edu/restricted/Geospatial.aspx.    
The code notes where the geographic related data are merged in and what are included in the dataset  It is possible to run some of the analysis without these data. 

This program requires the MSA income data to construct income in 1997 as well as some alternative income measures that are grown out by the MSA
level income growth rate.   This code is noted below.  The analysis can be run without the 1997 income adjustment but the results may not 
be exactly the same as those reported in the sample due to the missing data  */


drop _all
clear matrix
set more off
set memory 5g



local datain =0
local data_setup = 1
local mergecex = 1


local minobs = 15

cd ~/psid/data/

/* Read in the raw data from the PSID.  Through 2005 the data are stored and sorted by variable.  After 2005 the data are read in by year. */

if `datain' {

use pew_0709_mergev4_apr11

#delimit ;

keep unique fweight2007 hvalue2007 amtmort2007 relhead2007 howner2007 moved2007 foodd2007 faminc2006 labinc2006 labincw2006
fout2007 fhome2007 shouse2007 sore2007 scash2007 sbond2007 svehic2007 sstk2007 sstki2007 sodebt2007 w_vehic2007
sira2007 sbusi2007 w_ore2007 w_cash2007 w_stk2007 w_bond2007 w_ore2007 w_farm2007 w_odebt2007 w_ira2007 ageh2007 agew2007
famsize2007 mstatus2007 numkids2007 hequity2007 state2007 wife2007 head2007 repair2007 wrep2007
health2007 transp2007 childcare2007 school2007 carcost2007  proptax2007 hoins2007 util2007 wrep2007 repair2007 stax2006 ftax2006
srate2006 frate2006 seqno2007 seqno2005 w_ore2009 w_cash2009 w_stk2009 w_bond2009 w_ore2009 w_farm2009 w_odebt2009 w_ira2009 w_vehic2009
sore2009 scash2009 sbond2009 svehic2009 sstk2009 sstki2009 sodebt2009 sira2009 sbusi2009 wrep2009 repair2009 amtmort2009 hvalue2009
howner2009 region2007 wksueh2006 wksuew2006 moved2009 rnhcons2007 mortpay2007 lopcar2007 lepcar2007
w1_ore2007 w1_cash2007 w1_stk2007 w1_bond2007 w1_ore2007 w1_farm2007 w1_odebt2007 w_ira2007 sstka2007;

#delimit cr

gen rpmort2007 = amtmort2007
gen rpmort2009 = amtmort2009
gen food2007 = fout2007 + fhome2007 + foodd2007

gen hlabinc2006 = labinc2006
gen wlabinc2006 = labincw2006

drop amtmort2007 amtmort2009 labinc2006 labincw2006

sort unique
merge unique using howner
drop _merge
sort unique

merge unique using rnhcons_422
drop _merge
sort unique

merge unique using labinc
drop _merge
sort unique

merge unique using age
drop _merge
sort unique

merge unique using region
drop _merge
sort unique

merge unique using taxes_upd_jun2011
drop _merge
sort unique

merge unique using moved
drop _merge
sort unique

merge unique using wrepdat
drop _merge
sort unique

merge unique using fweights
drop _merge
sort unique

merge unique using relhead
drop _merge
sort unique

merge unique using famsize
drop _merge
sort unique

merge unique using active_save_alt_416
drop _merge
sort unique

merge unique using famincr_upd
drop _merge
sort unique

merge unique using faminc_upd_jun23
drop _merge
sort unique

merge unique using psid_cons_aggs
drop _merge
sort unique

merge unique using utildat
drop _merge
sort unique

merge unique using state
drop _merge ER30001 ER30002
sort unique

merge unique using extracons0507
drop _merge
sort unique

merge unique using food
drop _merge
sort unique

merge unique using hwealth
drop _merge
sort unique

merge unique using numkids
drop _merge
sort unique

merge unique using rpmortgage_upd
drop _merge
sort unique

drop rpmort1994

merge unique using rpmortgage_1994
drop _merge
sort unique

merge unique using wealth_209
drop _merge
sort unique

merge unique using seqno
drop _merge
sort unique

merge unique using mstatus
drop _merge
sort unique

merge unique using shouse
drop _merge
sort unique

merge unique using attitudes
drop _merge
sort unique

merge unique using earncoll
drop _merge
sort unique

merge unique using refi1996dat
drop _merge
sort unique

drop ER30001 ER30002 cfweight1990 cfweight1991 cfweight1992 cfweight1993 cfweight1994 cfweight1995


*************
* Deflators *
*************

/* There are the PCE deflator downloaded in 2011 prior to the comprehensive revision in 2013.  The base year is converted to 2000 dollars */


gen         def2009         = 1.21692638
gen         def2008        =  1.21446473
gen         def2007        = 1.1751562
gen         def2006        = 1.144457935
gen         def2005        = 1.11588
gen         def2004        = 1.08392
gen         def2003        = 1.05597
gen         def2002        = 1.03542
gen         def2001        = 1.02094
gen         def2000        = 1.00
gen         def1999        = 0.97575
gen         def1998        = 0.95978
gen         def1997        = 0.95124
gen         def1996        = 0.93547
gen         def1995        = 0.91577
gen         def1994        = 0.89654
gen         def1993        = 0.87804
gen         def1992        = 0.85824
gen         def1991        = 0.83419
gen         def1990        = 0.80498
gen         def1989        = 0.76972
gen         def1988        = 0.73755
gen         def1987        = 0.70947
gen         def1986        = 0.68569
gen         def1985        = 0.66936
gen         def1984        = 0.64795
gen         def1983        = 0.62436
gen         def1982        = 0.59859
gen         def1981        = 0.5672
gen         def1980        = 0.52078
gen         def1979        = 0.47059
gen         def1978        = 0.43248
gen         def1977        = 0.4041
gen         def1976        = 0.3795
gen         def1975        = 0.3596
gen         def1974        = 0.3319
gen         def1973        = 0.3008
gen         def1972        = 0.2853
gen         def1971        = 0.2757
gen         def1970        = 0.2645
gen         def1969        = 0.2526
gen         def1968        = 0.2415


*2 years

/* Calculate multi-year deflators for use with multi-year data such as consumption and saving */

gen def2yr1997         = (def1995 + def1996)/2
gen def2yr1999         = (def1997 + def1998)/2
gen def2yr2001         = (def1999 + def2000)/2
gen def2yr2003         = (def2001 + def2002)/2
gen def2yr2005         = (def2003 + def2004)/2
gen def2yr2007         = (def2005 + def2006)/2
gen def2yr2009         = (def2007 + def2008)/2

gen def5yr1999         = (def1997 + def1998+ def1996 + def1995 + def1994)/5
gen def5yr1994         = (def1993 + def1992 + def1991 + def1990 + def1989)/5
gen def5yr1989         = (def1988 + def1987 + def1986 + def1985 + def1984)/5

gen own2own0103        = 1 if moved2003 ==1 & howner2003 ==1 & howner2001 ==1
replace own2own0103    = 0 if moved2003 ==0 & howner2003 ==1 & howner2001 ==1

gen own2own0305        = 1 if moved2005 ==1 & howner2005 ==1 & howner2003 ==1   
replace own2own0305    = 0 if moved2005 ==0 & howner2005 ==1 & howner2003 ==1

gen chgmdebt2003 = rpmort2003 - rpmort2001
gen chgmdebt2005 = rpmort2005 - rpmort2003

gen chgequity2003 = (hvalue2003-rpmort2003) - (hvalue2001-rpmort2001)
gen chgequity2005 = (hvalue2005-rpmort2005) - (hvalue2003-rpmort2003)

gen amtextra2003         = chgmdebt2003 if chgmdebt2003 >0 & own2own0103 ==0 & chgmdebt2003 ~=.
replace amtextra2003     = -chgequity2003 if own2own0103 ==1 & chgequity2003 <0 & chgequity2003  ~=.
replace amtextra2003     = 0 if amtextra2003 ==.

gen amtextra2005         = chgmdebt2005 if chgmdebt2005 >0 & own2own0305 ==0 & chgmdebt2005 ~=.
replace amtextra2005     = -chgequity2005 if own2own0305 ==1 & chgequity2005 <0 & chgequity2005  ~=.
replace amtextra2005     = 0 if amtextra2005 ==.



************************
* Combined Income Data *
************************

/* generate multi-year (after tax) income data taking into account the timing of the surveys and consumption data as discussed in the paper;  the tax data 
come from running relevant income and other information on the PSID households through TAXSIM.  See XXXXXX.do for an example of how to run the
TAXSIM program with PSID households.  Tax data are generated, stored and read in above */

*5yr

#delimit ;
gen faminc5yr1999      = (faminc1998 + faminc1997 + faminc1996 + faminc1995 + faminc1994 - stax1998*2 -ftax1998*2 -stax1996 -ftax1996 - stax1995 -ftax1995 -stax1994 -ftax1994);
gen faminc5yr1994      = (faminc1993 + faminc1992 + faminc1991 + faminc1990 + faminc1989 - stax1993 -ftax1993 -stax1992 -ftax1992 - stax1991 -ftax1991 -stax1990 -ftax1990
                           -stax1989 - ftax1989);
gen faminc5yr1989      = (faminc1988 + faminc1987 + faminc1986 + faminc1985 + faminc1984 -stax1988 -ftax1988 -stax1987 -ftax1987 -stax1986 -ftax1986 -stax1985 -ftax1985 -stax1984 -ftax1984);

#delimit cr

*2yr
gen famincr2yr1997       = (faminc1996 + faminc1995 -stax1996 -stax1995 -ftax1996 -ftax1995)/def2yr1997
gen famincr2yr1999       = (faminc1997 + faminc1998 -stax1998*2 -ftax1998*2)/def2yr1999
gen famincr2yr2001       = (faminc1999 + faminc2000 -2*stax2000 -2*ftax2000)/def2yr2001
gen famincr2yr2003       = (faminc2001 + faminc2002 -2*stax2002 -2*stax2002)/def2yr2003
gen famincr2yr2005       = (faminc2004*2 -2*stax2004 -2*ftax2004)/def2yr2005
gen famincr2yr2007       = (faminc2006*2 -stax2006*2 -ftax2006*2 )/def2yr2007

*1yr

gen famincrat1984        = (faminc1984 -ftax1984 -stax1984)/def1984
gen famincrat1985        = (faminc1985 -ftax1985 -stax1985)/def1985
gen famincrat1986        = (faminc1986 -ftax1986 -stax1986)/def1986
gen famincrat1987        = (faminc1987 -ftax1987 -stax1987)/def1987
gen famincrat1988        = (faminc1988 -ftax1988 -stax1988)/def1988
gen famincrat1989        = (faminc1989 -ftax1989 -stax1989)/def1989
gen famincrat1990        = (faminc1990 -ftax1990 -stax1990)/def1990
gen famincrat1991        = (faminc1991 -ftax1991 -stax1991)/def1991
gen famincrat1992        = (faminc1992 -ftax1992 -stax1992)/def1992
gen famincrat1993        = (faminc1993 -ftax1993 -stax1993)/def1993
gen famincrat1994        = (faminc1994 -ftax1994 -stax1994)/def1994
gen famincrat1995        = (faminc1995 -ftax1995 -stax1995)/def1995
gen famincrat1996        = (faminc1996 -ftax1996 -stax1996)/def1996
gen famincrat1999        = (faminc1998-ftax1998-stax1998)/def1998
gen famincrat2001        = (faminc2000-ftax2000-stax2000)/def2000
gen famincrat2003        = (faminc2002-ftax2002-stax2002)/def2002
gen famincrat2005        = (faminc2004-frate2004-srate2004)/def2004
gen famincrat2007        = (faminc2006-frate2006-srate2006)/def2006

*pretax adjustement

replace famincr2007 = faminc2006/def2006
replace famincr2005 = faminc2004/def2004


/* switch from a wide format database to long format database to simplify the analysis. */

#delimit ;

reshape long fweight hvalue rpmort relhead howner moved fout fhome sore scash shouse sbond svehic sstk sstki sodebt hlabinc wlabinc sira sbusi w_ore w_cash w_stk w_bond  w_farm w_odebt w_ira ageh agew famsize w_vehic stax ftax srate frate faminc5yr
mstatus numkids hequity state wife head def faminc famincr wrep repair health transp childcare school carcost housing foodd  mortpay proptax hoins rent util avg_vage wksueh wksuew earners numcol rnhcons lepcar lopcar amtextra
hrepair hfurn hrec cloth vaca famincr2yr def2yr def5yr famincrat food seqno region refi refib moneyp mmoneyp sstka w1_ore w1_cash w1_stk w1_bond  w1_farm w1_odebt w1_ira w1_vehic, i(unique) j(year);

#delimit cr

save revin_419, replace


}




if `data_setup' {


use ~/restat_rev/data/revin_419

drop own2own0103 own2own0305 chgmdebt2003 chgmdebt2005 chgequity2003 chgequity2005

***********************************
* merge in some data in long form *
***********************************


#delimit ;

/*  THIS IS WHERE THE DATA DERIVED FROM THE GEOCODE DATA IS MERGED IN.   */
/*  The relevant variables are  

YPP:  		MSA level personal income per capita
yppg: 		MSA level personal income growth per capita
yppgf: 		MSA level personal income growth per capita--1 year ahead
R:        		MSA unemployment rate
qhpgrow8:  	House price growth in MSA over the last 2 years (FHFA data)
qhpgrow4:	House price growth in the MSA over the last year (FHFA data)

The data themselves are publicly available, but the ability to link the data to the MSA in which a household is currently residing is proprietary.  The data
are linked to the MSA in which a household lives in a given year.    XXXXX.do generates and links the relevant data and creates linkdat_upd3.dta.

*/

/*
sort unique year;
merge unique year using linkdat_upd3;
drop _merge;

sort unique;
by unique:  replace l2qhpgrow8 = qhpgrow8[_n-2] if year ==2009;

*/


* this is data on households' asset income;
sort unique year;
merge unique year using assetinc;
drop _merge;

*this is data on households' length of time in their current dwelling;

sort unique year;
merge unique year using tenure;
drop _merge;


*******************************;
* Create additional variables *;
*******************************;


*FINANCIAL WEALTH and related;
gen totalfw          = (w_ore + w_farm + w_stk + w_cash + w_bond - w_odebt + w_vehic +w_ira)/def  ;  
replace totalfw      = (w_ore + w_farm + w_stk + w_cash + w_bond - w_odebt + w_vehic)/def if year ==1984;
gen liqw             = (w_stk + w_cash -w_odebt)/def;
gen liqw_alt         = (w_stk + w_cash )/def;
gen liqw_jl           = w_cash/def;
gen iliqw            = (w_ore + w_farm  + w_bond + w_vehic +w_ira)/def ;

* above extreme values are set to missing rather than zero...  do again here to see if makes difference;

gen totalfw1          = (w1_ore + w1_farm + w1_stk + w1_cash + w1_bond - w1_odebt + w1_vehic +w1_ira)/def  ;  
replace totalfw1      = (w1_ore + w1_farm + w1_stk + w1_cash + w1_bond - w1_odebt + w1_vehic)/def if year ==1984;
gen liqw1             = (w1_stk + w1_cash -w1_odebt)/def;
gen liqw_alt1         = (w1_stk + w1_cash )/def;
gen liqw_jl1           = w1_cash/def;
gen iliqw1            = (w1_ore + w1_farm  + w1_bond + w1_vehic +w1_ira)/def ;




gen rstot    = (sore + scash+ sbusi + svehic + sira + sstki + sodebt + sbond)/def2yr if year >=2001;
gen rstoth   = (sore + scash+ sbusi + svehic + sira + sstki + sodebt + sbond + shouse)/def2yr if year >=2001;

replace rstot    = (sore + scash+ sbusi + svehic + sira + sstki + sodebt + sbond)/def5yr if year < 2001;
replace rstoth   = (sore + scash+ sbusi + svehic + sira + sstki + sodebt + sbond + shouse)/def5yr if year <2001;


local vars "shouse sore sira scash sbond svehic sstk sstki sbusi sodebt";
 
foreach x of local vars {;

gen     r`x' = `x'/def5yr if year < 2001;
replace r`x' = `x'/def2yr if year  >=2001;

};




*HOUSING RELATED WEALTH ;

* first recode extreme values;
replace hvalue = . if hvalue ==9999998 | hvalue == 9999999;


gen ltv             = rpmort/hvalue;
gen rhvalue         = hvalue/def;
replace hequity     = hvalue - rpmort if rpmort ~=. & hvalue ~=.;

* in 1994 some folks have topcoded mortgage debt adn relative small house values (230000)... drop these people;
replace hequity = . if hequity == -9769997;

gen rhequity        = hequity/def;

gen rrpmort         = rpmort/def;

*PSID Consumption measures;


gen pexpn  = (health/2 +transp + childcare + school +carcost + util + foodd + fhome + fout)/def if year >=1999; 
gen pexpnf = (health/2 +transp + childcare + school +carcost + util + foodd + fhome + fout 
+ hrepair + hfurn + hrec + cloth +vaca)/def if year == 2005 | year==2007;

gen rhealth = (health/2)/def;
gen rtransp = transp/def;
gen rchildcare = childcare/def;
gen rschool = school/def;
gen rcarcost = carcost/def;
gen rutil = util/def;
gen rfood = (foodd + fhome + fout)/def;
gen rhrepair = hrepair/def;
gen rhfurn = hfurn/def;
gen rhrec = hrec/def;
gen rcloth = cloth/def;
gen fvaca = vaca/def;
gen rfoodd = foodd/def;
gen rfhome = fhome/def;
gen rfout  = fout/def;


* INCOME;

#delimit cr

gen labincr = (hlabinc + wlabinc)/def
gen hlabincr = hlabinc/def
gen wlabincr = wlabinc/def

gen fearner =1 if wlabinc >0 & wlabinc ~=.
replace fearner = 0 if wlabinc ==0 | wlabinc ==.

gen hearner =1 if hlabinc >0 & hlabinc ~=.
replace hearner = 0 if hlabinc ==0 |  hlabinc ==.

egen numearn = rowtotal(fearner hearner)

rename ay rotherinc
rename ay3 rotherincma3


** adjust the timing of the income data**

/*Note that the PSID records income data for the year prior to the survey year.  The data read in according to the year
 in which they  are earned so income reported in the1999 survey, for example, is recorded as 1998 income.  This creates
 some timing issues that have to be dealt with around the 1997 and 1999 surveys when the PSID switched from yearly to biennially. 
To ease in the analysis these data are re-assinged to the survey year for 1997 onward since there are not other data
avialable in the off year 1998 etc and the timing for all the analysis uses the survey years only for simplicity */

* adjust the timing for comparison purposes in calculating low income -- 1998 income pulled forward into 1999 etc
* 1999 lag is really 1996 income

sort unique

by unique: gen labincr_adj      = labincr[_n-1]  if labincr  ==. & year >=1997
by unique: gen hlabincr_adj     = hlabincr[_n-1] if hlabincr ==. & year >=1997
by unique: gen wlabincr_adj     = hlabincr[_n-1] if hlabincr ==. & year >=1997

replace labincr_adj      = labincr  if year <1997
replace hlabincr_adj     = hlabincr if year <1997
replace wlabincr_adj     = hlabincr if year <1997


/*  NEED RESTRICTED DATA FOR THIS
* an alternative... growth out all mising year income using growth rate in MSA level per capita income

gen yppr = YPP/def

by unique:  gen yppgrow = log(yppr[_n+1]) - log(yppr) if year == year[_n+1] -1

*/
******************************
* Create some lagged values  *
******************************

sort unique

local lagvarlist "pexpn pexpnf earners ageh howner famincr2yr famincrat rhvalue rhequity seqno head numcol famsize mstatus rotherinc rotherincma3 rrpmort"
local lagvarlist1 "totalfw liqw liqw_alt iliqw rnhcons totalfw1 liqw1 liqw_alt1 iliqw1 liqw_jl1 liqw_jl"
local loglist    "totalfw1 liqw1 liqw_alt1 iliqw1 liqw_jl1  liqw_jl totalfw liqw liqw_alt iliqw pexpn pexpnf famincr2yr famincrat rhvalue rhequity rnhcons labincr hlabincr wlabincr labincr_adj hlabincr_adj wlabincr_adj" 
local inclist    "labincr hlabincr wlabincr"
local inclist_adj "labincr_adj hlabincr_adj wlabincr_adj"

foreach x of local lagvarlist{

by unique: gen l_`x' = `x'[_n-2] if year >=1999 & year == year[_n-2] +2
by unique: replace l_`x' = `x'[_n-1] if year <=1997 & year == year[_n-1] +1

}

foreach x of local lagvarlist{

by unique: gen lalt_`x' = `x'[_n-2] if year == year[_n-2] +2

}



* income variables without timing adjustment

foreach x of local inclist{

by unique: gen l_`x' = `x'[_n-2] if year >=1998 & year == year[_n-2] +2
by unique: replace l_`x' = `x'[_n-1] if year <=1996 & year == year[_n-1] +1
*also create one that is straight two year change  
  by unique: gen l2_`x' = `x'[_n-2] if year == year[_n-2] +2
* really only want even years for 2 year change so set other years = missing
  foreach b of numlist 1969(2)1997 {
  replace l2_`x' = . if year == `b'
}
}



* with timing adjustments

foreach x of local inclist_adj{

by unique: gen l_`x' = `x'[_n-2] if year >=1997 & year == year[_n-2] +2
by unique: replace l_`x' = `x'[_n-1] if year <=1995 & year == year[_n-1] +1
*also create one that is straight two year change
   by unique: gen l2_`x' = `x'[_n-2] if year == year[_n-2] +2
* really only want odd years for 2 year change so set other years = missing
  foreach b of numlist 1970(2)1996 {
  replace l2_`x' = . if year == `b' & year ~=1994
}

}



foreach x of local lagvarlist1{

by unique: gen l_`x' = `x'[_n-2] if year >1999 & year == year[_n-2] +2
by unique: replace l_`x' = `x'[_n-5] if (year ==1999 | year ==1994 | year ==1989) & year == year[_n-5] +5

}

local lagvarlist2 "rhequity rotherinc rotherincma3 rrpmort"

foreach x of local lagvarlist2{

by unique: gen l25_`x' = `x'[_n-2] if year >1999 & year == year[_n-2] +2
by unique: replace l25_`x' = `x'[_n-5] if (year ==1999 | year ==1994 | year ==1989) & year == year[_n-5] +5

}



foreach y of local loglist{

gen ln_`y' = log(`y')
gen ln_l_`y' = log(l_`y')
}

foreach y of local inclist{
gen ln_l2_`y' = log(l2_`y')
} 

foreach y of local inclist_adj{
gen ln_l2_`y' = log(l2_`y')
} 



local changelist    "pexpn pexpnf totalfw liqw liqw_alt rhvalue rhequity famincrat labincr hlabincr wlabincr"
local logchangelist "pexpn pexpnf totalfw liqw liqw_alt rhvalue rhequity famincrat labincr hlabincr wlabincr "
local logchangelist2 "pexpn pexpnf totalfw liqw liqw_alt rhvalue rhequity famincrat labincr hlabincr wlabincr labincr_adj hlabincr_adj wlabincr_adj"

local loglagchange  "rhvalue rhequity famincrat pexpn pexpnf"

* need to make sure to take timing/averaging into effect

foreach z of local changelist{
gen d_`z' = `z'- l_`z'
replace d_`z' = d_`z'/2 if year >=1998 
}

foreach z of local logchangelist2{
gen dl_`z' = ln_`z'- ln_l_`z'
replace dl_`z' = dl_`z'/2 if year >=1998 

}

foreach z of local inclist{
gen dl2_`z'     = ln_`z'- ln_l2_`z'
gen dl2_`z'_avg = (ln_`z'- ln_l2_`z')/2
}

foreach z of local inclist_adj{
gen dl2_`z'     = ln_`z'- ln_l2_`z'
gen dl2_`z'_avg = (ln_`z'- ln_l2_`z')/2
}


local altlist "rnhcons"

foreach z of local altlist{
gen d_`z' = `z'- l_`z'
replace d_`z' = d_`z'/2 if year >1999 
replace d_`z' = d_`z'/5 if year <=1999 

gen dl_`z' = ln_`z'- ln_l_`z'
replace dl_`z' = dl_`z'/2 if year >1999
replace dl_`z' = dl_`z'/5 if year <=1999

}


sort unique
foreach y of local logchangelist{
by unique: gen l_d_`y' = d_`y'[_n-2] if year >=1999 & year == year[_n-2]+2
by unique: replace l_d_`y' = d_`y'[_n-1] if year <=1997 & year == year[_n-1]+1

by unique: gen l_dl_`y'     = dl_`y'[_n-2] if year >=1999 & year == year[_n-2]+2
by unique: replace l_dl_`y' = dl_`y'[_n-1] if year <=1997 & year == year[_n-1]+1

}


*****************************
* create lead income growth *
*****************************

* need to create a 1997 income variable to make things easier in terms of calculating growth rates etc


/* Restristed DATA needed for some of this INCOME code */

sort unique year
*by unique:  gen ypprg = log(yppr) -log(yppr[_n-1]) if year == year[_n-1] +1
*by unique:  gen labincr_adj2 = labincr[_n-1]*(1+ ypprg) if year == 1997
*by unique:  gen hlabincr_adj2 = hlabincr[_n-1]*(1+ ypprg) if year == 1997
by unique:  replace labincr_adj = labincr if year ==1998
by unique:  replace hlabincr_adj = hlabincr if year ==1998

*grow out family income as well
*by unique:  replace famincrat = famincrat[_n-1]*(1+ ypprg) if year == 1997



*drop 1996 for both samples, 1995 as well for lead4... adjust 1998 income to get that growth rate correct

foreach y of local inclist_adj{
by unique:  gen le2_`y' = `y'[_n+2] if year ~=1996 & year ~=1995 & year == year[_n+2]-2
by unique:  gen le4_`y' = `y'[_n+4] if year ~=1995 & year == year[_n+4]-4
}



/* RESTRICTED DATA are needed for this
by unique: replace le2_labincr = labincr_adj2[_n+2] if year ==1995 & year == year[_n+2]-2
by unique: replace le2_hlabincr = hlabincr_adj2[_n+2] if year ==1995 & year == year[_n+2]-2
*/

foreach y of local inclist_adj{
gen dl_le2_`y' = (log(le2_`y') - log(`y'))/2
gen dl_le4_`y' = (log(le4_`y') - log(`y'))/4
egen avg_dl_le_`y' = rowmean(dl_le2_`y' dl_le4_`y')
}




************************************
* create a measure of average/permanent income *
************************************

* want average labor income and average labor income growth-- for this timing doesn't matter much
* two year changes have been annualized 

sort unique
by unique: egen numobs = count(ln_labincr)

local inclist    "labincr hlabincr wlabincr "

foreach y of local inclist{
by unique: egen avg_`y'     = mean(ln_`y')
by unique: egen avg_`y'_rtr = mean(ln_`y') if numobs > `minobs'
by unique: egen sd_`y'      = sd(ln_`y')
by unique: egen sd_`y'_rtr  = sd(ln_`y') if numobs > `minobs'

by unique: egen avg_d`y'     = mean(dl_`y')
by unique: egen avg_d`y'_rtr = mean(dl_`y') if numobs > `minobs'
by unique: egen sd_d`y'      = sd(dl_`y')
by unique: egen sd_d`y'_rtr  = sd(dl_`y') if numobs > `minobs'
}



* this is for two year changes. 

foreach y of local inclist{
by unique: egen avg_d2`y'     = mean(dl2_`y')
by unique: egen avg_d2`y'_rtr = mean(dl2_`y') if numobs > `minobs'
by unique: egen sd_d2`y'      = sd(dl2_`y')
by unique: egen sd_d2`y'_rtr  = sd(dl2_`y') if numobs > `minobs'
}

* need to do odd years as well

foreach y of local inclist_adj{
by unique: egen avg_d2`y'     = mean(dl2_`y')
by unique: egen avg_d2`y'_rtr = mean(dl2_`y') if numobs > `minobs'
by unique: egen sd_d2`y'      = sd(dl2_`y')
by unique: egen sd_d2`y'_rtr  = sd(dl2_`y') if numobs > `minobs'
}


* it is not clear that looking at log standard devations is the right way to go
* a household may see their income drop from 16000 to 13000 which is not a lot in 
* logs but is a lot in levels and likely in terms of their purchasing power

foreach y of local inclist{
by unique: egen avg_`y'_nol     = mean(`y')
by unique: egen avg_`y'_nol_rtr = mean(`y') if numobs > `minobs'
by unique: egen sd_`y'_nol      = sd(`y')
by unique: egen sd_`y'_nol_rtr  = sd(`y') if numobs > `minobs'

}


**************************************
*restrict the sample to household heads only
***************************************

keep if head ==1 & seqno ==1

****************
* generate birth cohorts *
****************

sort unique

merge unique using yrbirth
drop if _merge==2
drop _merge yearat17


rename yrbirth by

* need to calculate birth cohorts

gen coh=1 if      (by>=1920&by<1925)
replace coh=2  if (by>=1925&by<1930)
replace coh=3  if (by>=1930&by<1935)
replace coh=4  if (by>=1935&by<1940)
replace coh=5  if (by>=1940&by<1945)
replace coh=6  if (by>=1945&by<1950)
replace coh=7  if (by>=1950&by<1955)
replace coh=8  if (by>=1955&by<1960)
replace coh=9  if (by>=1960&by<1965)
replace coh=10 if (by>=1965&by<1970)
replace coh=11 if (by>=1970&by<1980)


*****************
* amt extracted *
*****************


* calcualte equity extracted...

* own2own movers  - don't need to worry re years if do after sample resticted to heads

gen         own2own = 1 if moved ==1 & l_howner ==1 & howner ==1 
replace     own2own = 0 if moved ==0 & l_howner ==1 & howner ==1 

sort unique year
by unique: gen chgmdebt     = rpmort - rpmort[_n-1]
by unique: gen chgequity    = hequity - hequity[_n-1]

gen amtextr     = chgmdebt if chgmdebt> 0 & chgmdebt ~=. & own2own ==0
replace amtextr = -chgequity if own2own ==1 & chgequity <0
replace amtextr = 0 if amtextr ==.




save revdat_tmp_fin, replace

}


* Merge in consumption data for the PSID generated using CEX data and following the method described in Blundell, Pistaferri, and Preston (2006)
* Each database contains a different consumption measure; for example, cexdat_fullxh_nor contains a measure based on total consumption excluding housing
* in the CEX;  There are also some measures such as cexdat_psid_nor, where the CEX data are imputed to match the spending definitions available in the
* PSID. 



if `mergecex' {
***************************
* Merge in CEX cons  data *
***************************

use ~/restat_rev/data/revdat_tmp_fin




sort unique year
merge unique year using  ~/restat_rev/data/cexdat_fullndbpp_nor
drop _merge

sort unique year
merge unique year using ~/restat_rev/data/cexdat_psid_b_nor
drop _merge

sort unique year
merge unique year using ~/restat_rev/data/cexdat_psid_full
drop _merge



save ~/restat_rev/data/revdat_419_wmdebt_fin, replace

}



