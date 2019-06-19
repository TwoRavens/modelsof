qui log using SOEP-2-Coding.log, text replace
/* ------------------------------------------------------------------------ ** 
    C. Wunder, A. Wiencierz, J. Schwarze, H. KŸchenhoff:    
    Well-being over the life span: semiparametric evidence from British 
    and German longitudinal data

    Data source:        German Socio-Economic Panel Study (SOEP), years 1986-2007.
    Data organization:  person-year observations    
    Description:        Generates and re-codes variables retrieved from the SOEP.
                        The file "SOEP-1-Retrieval.soep" needs to be executed 
                        before.
    ----------------------------------------------------------------------- 
        
    Description of variables:

    life_sat            life satisfaction (11-point scale)
    age                 age
    female              female = 1; male = 0
    disabled            disability status: disabled = 1; otherwise = 0
    hospital            number nights stayed in hospital
    educ                years of education
    ln_netto            log of net household income
    ln_hhsize           log of household size
    german              German born = 1; otherwise = 0
    fulltime            full time employed = 1; otherwise = 0
    parttime            part time employed = 1; otherwise = 0
    unempl              unemployed = 1; otherwise = 0
    single              single = 1; otherwise = 0 
    divorced            divorced = 1; otherwise = 0 
    widowed             widowed = 1; otherwise = 0 
    west                West-Germany = 1; otherwise = 0 
    attr_in_1           attrition in 1 = 1; otherwise = 0
    attr_in_2           attrition in 2 = 1; otherwise = 0
    attr_in_3           attrition in 3 = 1; otherwise = 0
    d_year4-d_year24    wave indicators (years 1990 and 1993 are omitted)   
** ------------------------------------------------------------------------ */ 
version 10
use "age-long.dta", clear // this file is produced by SOEP-1-Retrieval.soep
mvdecode _all, mv(-3=.a \ -2=.b \ -1=.c)

/*  --------( Coding of variables )---------------------------------------- */

gen         interview = (netto>=10 & netto<=19)
sort        persnr year
by persnr:  gen attr_in_1 = interview[_n+1]==0
by persnr:  gen attr_in_2 = interview[_n+2]==0 
by persnr:  gen attr_in_3 = interview[_n+3]==0
replace     attr_in_1 = 0 if year==2007
replace     attr_in_2 = 0 if year==2006 | year==2007
replace     attr_in_3 = 0 if year==2005 | year==2006 | year==2007
gen         educ=p2292x
gen         ln_netto = log(h2743x)
gen         ln_hhsize = log(h2110x)
gen         german = (germborn==1) 
gen         fulltime =(p4718x==1)
gen         parttime =(p4718x==2 | p4718x==4)
gen         fuppes = p171x
replace     fuppes = p171x-4 if year==1984
gen         unempl =(fuppes==1)
gen         married =(p2291x==1 | p2291x==2 |p2291x==6)
gen         single =(p2291x==3)
gen         divorced =(p2291x==4)
gen         widowed =(p2291x==5)
gen         disabled =(p4648x==1)
gen         hospital = 0
replace     hospital =p497x if p497x>=1 & p497x<.
qui tab     year, gen (d_year)
gen         female = sex-1
qui su      gebjahr
gen         cohort = gebjahr - r(min)
gen         cohortsq = cohort^2
drop        agesq
gen         agesq = age^2/10^2
gen         agecub  = age^3/10^3
ren         p622x life_sat 

/*  --------( Define sample )---------------------------------------------- */               
xtset       persnr
keep        if interview==1
keep        if educ>=7
keep        if h2743x >= 100    
drop        if d_year7==1
drop        if d_year10==1 
drop        d_year7 d_year10 
drop        if yip<=2
drop        if age<18
global      xvar ///
            female      disabled    hospital    educ        ln_netto    ln_hhsize ///
            german      fulltime    parttime    unempl      single      divorced  ///
            widowed     west        attr_in_1   attr_in_2   attr_in_3   d_year4   ///
            d_year5     d_year6     d_year8     d_year9     d_year11    d_year12  ///
            d_year13    d_year14    d_year15    d_year16    d_year17    d_year18  ///
            d_year19    d_year20    d_year21    d_year22    d_year23    d_year24  
tokenize    ${xvar}
global      gls_xvar ///
            gls_`1'  gls_`2'  gls_`3'  gls_`4'  gls_`5'  gls_`6'  gls_`7'  gls_`8'  ///
            gls_`9'  gls_`10' gls_`11' gls_`12' gls_`13' gls_`14' gls_`15' gls_`16' ///
            gls_`17' gls_`18' gls_`19' gls_`20' gls_`21' gls_`22' gls_`23' gls_`24' ///
            gls_`25' gls_`26' gls_`27' gls_`28' gls_`29' gls_`30' gls_`31' gls_`32' ///
            gls_`33' gls_`34' gls_`35' gls_`36' gls_one
* drop observations with missing values on key variables
keep persnr year gebjahr life_sat age* cohort* ${xvar}
local varlist life_sat age cohort ${xvar}
foreach var of local varlist {
    drop if `var'>=. 
}

/*  --------( Define variable labels )------------------------------------- */
label var attr_in_1 "attrition in 1"
label var attr_in_2 "attrition in 2"
label var attr_in_3 "attrition in 3"
label var age "age"
label var agesq "age squared/10^2"
label var agecub "age cubed/10^3"
label var female "sex: female"
label var disabled "disability status: disabled" 
label var hospital "nights stayed in hospital"
label var educ "years of education"
label var ln_netto "log of net household income"
label var ln_hhsize "log of household size"
label var german "German"
label var fulltime "full time employed"
label var parttime "part time employed"
label var unempl "unemployed"
label var single "single"
label var divorced "divorced"
label var widowed "widowed"
label var west "West-Germany"
label var d_year4 "1987"
label var d_year5 "1988"
label var d_year6 "1989"
label var d_year8 "1991"
label var d_year9 "1992"
label var d_year11 "1994"
label var d_year12 "1995"
label var d_year13 "1996"
label var d_year14 "1997"
label var d_year15 "1998"
label var d_year16 "1999"
label var d_year17 "2000"
label var d_year18 "2001"
label var d_year19 "2002"
label var d_year20 "2003"
label var d_year21 "2004"
label var d_year22 "2005"
label var d_year23 "2006"
label var d_year24 "2007"

save raw.dta, replace

/*  --------( GLS-transformation )----------------------------------------- */
use raw.dta, clear
qui xtreg life_sat age agesq agecub ${xvar}, re
keep if e(sample)
scalar sig_e = e(sigma_e)
scalar sig_u = e(sigma_u)
gen one=1
bysort persnr: egen T_i = count(life_sat)
gen theta_i = 1 - sig_e / (sqrt(sig_e^2 + T_i*sig_u^2)) 
global all_vars $xvar life_sat age agesq agecub one
foreach var of global all_vars{
    bysort persnr: egen im_`var' = mean(`var')
    gen gls_`var' = `var' - theta_i*im_`var'
}
drop im*
foreach var of global gls_xvar{         
    gen _`var' = `var'
}
save "SOEP.dta", replace
qui log close
exit
