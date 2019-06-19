qui log using BHPS-2-Coding.log, text replace
/* ------------------------------------------------------------------------ ** 
    C. Wunder, A. Wiencierz, J. Schwarze, H. Küchenhoff:    
    Well-being over the life span: semiparametric evidence from British 
    and German longitudinal data

    Data source:        British Household Panel Survey (BHPS), years 1996-2008.
    Data organization:  person-year observations    
    Description:        Generates and re-codes variables retrieved from the BHPS.
                        The file "BHPS-1-Retrieval.bhps" needs to be executed 
                        before.
    ----------------------------------------------------------------------- 

    Description of variables:

    ls                  life satisfaction (7-point scale)
    age                 age
    female              female = 1; male = 0
    ln_hhinc            log of net household income
    ln_hhnpers          log of household size
    bad_health          health problems: yes = 1; 
    educ_mid            education: mid = 1; otherwise = 0 
    educ_high           education: high = 1; otherwise = 0
    jstat_ausb          in school = 1; otherwise = 0
    jstat_empl          (self-)employed = 1; otherwise = 0
    jstat_unem          unemployed = 1; otherwise = 0
    jstat_reti          retired = 1; otherwise = 0
    mstat2              coupled = 1; otherwise = 0
    mstat3              widowed = 1; otherwise = 0
    mstat4              divorced = 1; otherwise = 0
    mstat5              separated = 1; otherwise = 0
    mstat6              single = 1; otherwise = 0
    attr_in_1           attrition in 1 = 1; otherwise = 0
    attr_in_2           attrition in 2 = 1; otherwise = 0
    attr_in_3           attrition in 3 = 1; otherwise = 0
    period2-period10    wave indicators (year 2001 omitted)     
** ------------------------------------------------------------------------ */  
version 10
use "BHPS-long.dta", clear
drop if year < 1996 | year == 2001
mvdecode _all, mv( -9=.a \ -8=.b \ -7=.c \ -6=.d \ -5=.e \ -4=.f \ -3=.g \ -2=.h \ -1=.i )

/*  --------( Coding of variables )---------------------------------------- */

gen         interview = (ivfio==1 | ivfio==3)
sort        pid year
by pid:     gen attr_in_1 = interview[_n+1]==0
by pid:     gen attr_in_2 = interview[_n+2]==0 
by pid:     gen attr_in_3 = interview[_n+3]==0
replace     attr_in_1 = 0 if year==2006 | year==2000
replace     attr_in_2 = 0 if year==2006 | year==2005 | year==1999
replace     attr_in_3 = 0 if year==2006 | year==2005 | year==2004 | year==1998
gen         age     = year - doby 
gen         agesq   = age^2/10^2
gen         agecub  = age^3/10^3
gen         agequa  = age^4/10^4
gen         ln_hhinc    = ln(hrfihhmn)      
gen         ln_hhnpers  = ln(hrhhsize)      
qui tab     irhlstat, gen(srh)              
gen         bad_health = irhlprba==1 | irhlprbb==1 | irhlprbc==1 | irhlprbd==1 | ///
            irhlprbe==1 | irhlprbf==1 | irhlprbg==1 | irhlprbh==1 | ///
            irhlprbi==1 | irhlprbj==1 | irhlprbk==1 | irhlprbl==1 | /// 
            irhlprbm==1
qui tab     irhlprb bad_health
gen         educ_low = irqfedhi==12 if (irqfedhi!=11 & irqfedhi!=13)
gen         educ_high = irqfedhi>=1 & irqfedhi<=4 if (irqfedhi!=11 & irqfedhi!=13)
gen         educ_mid  = irqfedhi>=5 & irqfedhi<=10 if (irqfedhi!=11 & irqfedhi!=13)
gen         jstat_empl= irjbstat==1 | irjbstat==2  | irjbstat==10
gen         jstat_unem = irjbstat==3            
gen         jstat_reti = irjbstat==5            
gen         jstat_ausb = irjbstat==7            
gen         jstat_nonw = irjbstat>=5 & (irjbstat<=6 | irjbstat==8 | irjbstat==10)
qui tab     iamastat, gen(mstat)            
replace     mstat1=1 if mstat7==1       
gen         female = sex==2             
ren         irlfsato ls 
qui su      doby                    
gen         cohort = doby - r(min)
gen         cohortsq = cohort^2
qui tab     year, gen(period)               

/*  --------( Define sample )---------------------------------------------- */   
drop        if hrfihhmn<50
drop        if age<18   
global      exo_vars ///
            ln_hhinc        ln_hhnpers      female          bad_health      /// 
            educ_mid        educ_high       jstat_ausb      jstat_empl      ///
            jstat_unem      jstat_reti      mstat2          mstat3          ///
            mstat4          mstat5          mstat6          attr_in_1       ///
            attr_in_2       attr_in_3       period2         period3         ///
            period4         period5         period6         period7         /// 
            period8         period9         period10        
tokenize    ${exo_vars}
global      gls_exo_vars ///
            gls_`1'  gls_`2'  gls_`3'  gls_`4'  gls_`5'  gls_`6'  gls_`7'  gls_`8'  ///
            gls_`9'  gls_`10' gls_`11' gls_`12' gls_`13' gls_`14' gls_`15' gls_`16' ///
            gls_`17' gls_`18' gls_`19' gls_`20' gls_`21' gls_`22' gls_`23' gls_`24' ///
            gls_`25' gls_`26' gls_`27' gls_one
global      exo_vars_ac ///     
            ln_hhinc        ln_hhnpers      female          bad_health      ///
            educ_mid        educ_high       jstat_ausb      jstat_empl      ///
            jstat_unem      jstat_reti      mstat2          mstat3          ///
            mstat4          mstat5          mstat6          attr_in_1       ///
            attr_in_2       attr_in_3       cohort          cohortsq
tokenize    ${exo_vars_ac}
global      gls_exo_vars_ac ///
            gls_`1'  gls_`2'  gls_`3'  gls_`4'  gls_`5'  gls_`6'  gls_`7'  gls_`8'  ///
            gls_`9'  gls_`10' gls_`11' gls_`12' gls_`13' gls_`14' gls_`15' gls_`16' ///
            gls_`17' gls_`18' gls_`19' gls_`20' 
* drop observations with missing values on key variables
local vars hrfihhmn hrfihhyr hrhhsize hrnkids iamastat irjbstat ls irqfedhi ${exo_vars} year age    
foreach var of local vars {         
drop if `var'>=.
}
keep        pid year ls age* ${exo_vars} year doby cohort*  

/*  --------( Define variable labels )------------------------------------- */
label var   ln_hhinc "log of net household income"
label var   ln_hhnpers "log of household size"
label var   bad_health "health problems"
label var   educ_high "education: high"
label var   educ_mid "education: mid"
label var   jstat_empl "(self-)employed"
label var   jstat_unem "unemployed"
label var   jstat_reti "retired"
label var   jstat_ausb "in school"
label var   age "age"
label var   agesq "age squared/10^2"
label var   agecub "age cubed/10^3"
label var   agequa "age quartic/10^4"
label var   female "sex: female"
label var   mstat2 "coupled"
label var   mstat3 "widowed"
label var   mstat4 "divorced"
label var   mstat5 "separated"
label var   mstat6 "single"
label var   period1 "1996"
label var   period2 "1997"
label var   period3 "1998"
label var   period4 "1999"
label var   period5 "2000"
label var   period6 "2002"
label var   period7 "2003"
label var   period8 "2004"
label var   period9 "2005"
label var   period10 "2006"
xtset pid year
save "BHPS-raw.dta", replace

/*  --------( GLS-transformation )---------------------------------------- */
use "BHPS-raw.dta", clear
qui xtreg ls age agesq agecub $exo_vars
scalar sig_e = e(sigma_e)
scalar sig_u = e(sigma_u)
gen one=1
bysort pid: egen T_i = count(ls)    
gen double theta_i = 1 - sig_e / (sqrt(sig_e^2 + T_i*sig_u^2))
global all_vars $exo_vars ls age agesq agecub one
foreach var of global all_vars{
    bysort pid: egen im_`var' = mean(`var')
    gen gls_`var' = `var' - theta_i*im_`var'
}
drop im*
foreach var of global gls_exo_vars{
    gen _`var' = `var'
}
sort pid year
save "BHPS.dta", replace
qui log close
exit