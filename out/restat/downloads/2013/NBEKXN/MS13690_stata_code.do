/*======================================================================================================*\ 
| Program: Innovative Capability and Financing Constraints for Innovation - More Money, More Innovation?                                                 
| Authors: Hanna Hottenrott & Bettina Peters                                               
| Version: March 2011                                                                  
\*======================================================================================================*/ 
                                                                                          
clear all
cap log close                                                                             
set mem 100m                                                                              
set matsize 800                                                                           
set more off                                                                              
version 11
                                                                                           
cd "C:\Users\n06030\Desktop\REStat_Docs"
                                                                                          
use rawdata.dta                                            
log using "results_final_MS13690.log", replace                                    


/*==========================================================================*\ 
| Variables Description (Var names in paper in paratheses):  

| lfdnr      Company ID      
| inno       Dummy: 1 if firm is involved in innovation activities in 2004-2006 (INNO)
| fambes     Family-owned company dummy (FAMCOM) 
| group      Group membership dummy (GROUP)
| bonitaet   Credit rating (RATING)
| hhi        Herfindahl index of industry concentration (COMP)
| ost        Regional dummy (EAST)
| ag         Legal form dummy (PUBLIC)
| person     Legal form dummy (PRIVATE) 
| gmbh       Legal form dummy (LIMITED) 
| divers     Product range diversification (DIVERS) 
| br         Industry
| fue        R&D expenditure in 2006, in Mill. €
| L1fue      R&D expenditure in 2005, in Mill. €
| iages      Innovation expenditure, in Mill. €
| profit     Profit-Turnover-Ratio (categorial variable, 8 classes)
| plzd       Product life cycle, in years
| bges       Number of Employees, in head counts          
| alt        Firm age, in years 
| respond    Function of respondent
| L1exint    Lagged export intensity in 2005 (EXINT)
| um         Turnover in 2006, in Mill €.
| L1um       Turnover in 2005, in Mill €.
| mkost      Material and energy costs in 2006, in Mill €. (used for calculation of pcm and pcm2)
| L1mkost    Material and energy costs in 2005, in Mill €. (used for calculation of lpcm2)
| bkost      Labour costs in 2006, in Mill €. (used for calculation of pcm and pcm2) 
| L1bkost    Labour costs in 2005, in Mill €. (used for calculation of lpcm2) 
| bhsp       Share of highly qualified personnel (used for definition of B)
| mneu       Market novelty dummy (used for definition of B)
| fueb       R&D employees (used for definition of B)
| wb         Training expenditures (used for definition of B)
| sv         Tangible assets in 2006 (beginning of year)
| L1sv       Tangible assets in 2005 (beginning of year)
\*===============================================================================*/  


/*================================================================================*\ 
|            V A R I A B L E   D E F I N I T I O N       
\*================================================================================*/  

*****************************************************
*** ENDOGENOUS VARIABLES 
*****************************************************

**********
* con: constrained yes/no
**********

* current innovative firms that would not invest in innovation
    gen p1m0=0 if mittel2!=.
    replace p1m0=1 if inno==1 & mittel2==0
    
* current innovative firms that would invest in innovation
    gen p1m1=0 if mittel2!=.
    replace p1m1=1 if inno==1 & mittel2==1
    
* current non-innovative firms that would invest in innovation
    gen p0m1=0 if mittel2!=.
    replace p0m1=1 if inno==0 & mittel2==1
    
* current non-innovative firms that would not invest in innovation
    gen p0m0=0 if mittel2!=.
    replace p0m0=1 if inno==0 & mittel2==0

* define constrained firm 
    gen ptype=.
    replace ptype=1 if p0m0==1 
    replace ptype=2 if p1m0==1
    replace ptype=3 if p1m1==1
    replace ptype=4 if p0m1==1
    
    tab ptype
    tab ptype,m

    gen con=0 if ptype!=.
    replace con=1 if inlist(ptype, 3,4)
    tab con
    tab con ptype

    label var con "constraints measure (dummy)(CON)"        


*******************************************
* atype: degree of financial constraints 
* 0: no additional innovation
* 1: additional innovation besides others
* 2: exclusively additional innovation
*******************************************

    gen type=.
    replace type=1 if mittel2==0 & (mittel1==1 | mittel3==1 | mittel4==1 | mittel5==1)
    replace type=2 if mittel2==1 & (mittel1==1 | mittel3==1 | mittel4==1 | mittel5==1)
    replace type=3 if mittel2==1 & (mittel1!=1 & mittel3!=1 & mittel4!=1 & mittel5!=1)

    recode type (1=0) (2=1) (3=2)
    tab type
    label var type "degree of constraints (TYPE)"        


*****************************************************
*** EXPLANATORY VARIABLES 
*****************************************************

* rename a few variables to variable names used in paper
    
    rename bonitaet rating
    label var rating "credit rating index in 2006"
    rename fambes famcom
    label var famcom "1 if company is family owned"
    rename hhi comp
    label var comp "Hirschman Herfindahl indix"
    rename ost east
    label var east "firm located in East Germany"
     
    rename ag public
    label var public "public company (PUBLIC)"
    rename person private
    label var private "private company (PRIVATE)"
    rename gmbh limited
    label var limited "limited company (LIMITED)"

    global legal3 "private public limited" 
    global legal "limited public" 

    
******************************
* industry dummies 
******************************

    tab br, gen(br_)
    global id "br_1 br_2 br_3 br_4 br_5 br_6 br_7 br_8 br_10 br_11 br_12 br_13 br_14 br_15"

    label var br_1 "mining"
    label var br_2 "food/tobacco" 
    label var br_3 "textiles"
    label var br_4 "paper/wood/print" 
    label var br_5 "chemical" 
    label var br_6 "plastics/rubber" 
    label var br_7 "glas/ceramics" 
    label var br_8 "metal" 
    label var br_9 "machinery" 
    label var br_10 "electr. eng." 
    label var br_11 "medicine/optic/processing" 
    label var br_12 "vehicles" 
    label var br_13 "furniture" 
    label var br_14 "energy/water" 
    label var br_15 "construction" 
    

*******************************************
* number of employees, in log 
*******************************************

    rename bges size
    label var size "firm size (SIZE)"

    gen lnsize=log(size)
    label var lnsize "log firm size (lnSIZE)"


*******************************************
* firm age, in log 
*******************************************

    rename alt age
    label var age "firm age (AGE)"
    
    gen lnage = log(age+1)  
    label var lnage "log firm age (lnAGE)"


*******************************************
* capital intensity 
*******************************************

    gen kapint = sv/size   
    gen kapint2 = kapint^2   
    sum kapint,d
    label var kapint "capital intensity as fixed assets/employees (KAPINT)"

    
*******************************************
* product life cycle
*******************************************

    rename plzd plc
    label var plc "product life cycle (PLC)"
    
    gen lnplc=log(plc)
    label var lnplc "log. product life cycle (lnPLC)"


*******************************************
* lagged price cost margin
*******************************************

* pcm including R&D with lag
    gen lpcm2 = (L1um-L1mkost-L1bkost+0.93*L1fue)/L1um
    sum lpcm2, d

    egen hvf = mean(lpcm2), by(gk nace2)
    replace lpcm2 = hvf if lpcm2 == .
    drop hvf
    egen hvf = mean(lpcm2), by(nace2)
    replace lpcm2 = hvf if lpcm2 == .



*******************************************
* function of respondent
*******************************************

    * binary indicators
        gen finance = 0
        replace finance   = 1 if respond==1   
        gen RD = 0    
        replace RD        = 1 if respond==2     
        gen gf = 0
        replace gf        = 1 if respond==3 
        gen kaufman = 0
        replace kaufman   = 1 if respond==4 
        gen other = 0
        replace other = 1 if respond==5  
    
        label var gf "CEO respondent (CEO)"
        label var finance "Finance respondent (FIN_DEP)"
        label var RD "R&D respondent (R&D_DEP)" 
        label var kaufman "Sales respondent (SALES_DEP)"
        label var other "Other respondent (OTHER_DEP)"
    
    * globals
        global respond5 "gf finance RD kaufman other"
        global respond "finance RD kaufman other"
    



*********************************************
* training expenditure per labour cost 
*********************************************

    gen wb_b = wb/bkost


*********************************************
* drop all relevant missing values to define estimation sample
* (including variables that are used for defining innocap and cash in the next step) 
*********************************************

    egen miss = rmiss(con type lnsize lnage lnplc br_*  east $respond comp famcom group kapint rating $legal wb_b um profit)
    drop if miss > 0      


******************************
* inno capability
******************************
    
    sum bhsp, d
    egen pablo = pctile(bhsp), p(80)  
    
    sum wb_b,d
    egen train = pctile(wb_b), p(80) 
    
    gen innocap = 0
    replace innocap = 1 if (bhsp > pablo & bhsp !=.) | (wb_b > train & wb_b !=.) 

    label var innocap "firms with high innovative capabilities (B)"     

    gen b0 = 0
    replace b0 = 1 if innocap == 0
    gen b1 = 0
    replace b1 = 1 if innocap == 1

    label var b0 "0 if firm has low innovative capabilities"     
    label var b1 "1 if firm has high innovative capabilities"     


******************************
* 3 profitability classes 
******************************

    gen M=.
    replace M=1 if profit==1
    replace M=2 if profit>1 & profit<5
    replace M=3 if profit>=5 & profit!=8 & profit!=.
    
    gen m0 = 0
    replace m0 = 1 if profit==1
    gen m1 = 0
    replace m1 = 1 if profit>1 & profit<5
    gen m2 = 0
    replace m2 = 1 if profit>=5 & profit!=8 & profit!=.


*****************************************************
* 6 interaction terms between money (M) and brain (B) 
*****************************************************
    
    gen b1m0=1 if innocap==1 & profit==1
    replace b1m0=0 if b1m0==.
    gen b1m1=1 if innocap==1 & profit>1 & profit<5
    replace b1m1=0 if b1m1==.
    gen b1m2=1 if innocap==1 & profit>=5 & profit!=8 & profit!=.
    replace b1m2=0 if b1m2==.
    gen b0m0=1 if innocap==0 & profit==1
    replace b0m0=0 if b0m0==.
    gen b0m1=1 if innocap==0 & profit>1 & profit<5
    replace b0m1=0 if b0m1==.
    gen b0m2=1 if innocap==0 & profit>=5 & profit!=8 & profit!=.
    replace b0m2=0 if b0m2==.
    
    label var b1m0 "BHML: high inno cap, low fin. resources"
    label var b1m1 "BHMM: high inno cap, medium fin. resources"
    label var b1m2 "BHMH: high inno cap, high fin. resources"
    label var b0m0 "BLML: low inno cap, low fin. resources"
    label var b0m1 "BLMM: low inno cap, medium fin. resources"
    label var b0m2 "BLMH: low inno cap, high fin. resources"
    
    global BM6 "b1m0 b1m1 b1m2 b0m0 b0m1 b0m2"
    global BM "b1m0 b1m1 b1m2 b0m0 b0m1"


    gen B1 = 1 == b1m0 ==1 | b1m1 ==1 | b1m2 ==1
    tab B1
    gen M0 = 1 == b1m0 ==1 | b0m0 ==1 
    tab M0



*******************************************
* CASH
*******************************************

* amount of cash

    gen cash=0.1*um
    gen lncash=log(cash)
    gen lncash2=log(cash)^2
    gen lncash3=log(cash)^3
    
    sum cash, d
    
    label var cash "Size of hypothetical payment (CASH)"
    label var lncash "log Size of hypothetical payment (lnCASH)"


* cash classes
    
    cap drop hv*    
    egen hv1 = pctile(lncash), p(20)
    egen hv2 = pctile(lncash), p(40)
    egen hv3 = pctile(lncash), p(60)
    egen hv4 = pctile(lncash), p(80)
        
    gen lncashc = 0
    replace lncashc = 1 if lncash < hv1
    replace lncashc = 2 if lncash >= hv1 & lncash < hv2
    replace lncashc = 3 if lncash >= hv2 & lncash < hv3
    replace lncashc = 4 if lncash >= hv3 & lncash < hv4
    replace lncashc = 5 if lncash >= hv4 & lncash != .
    
    drop hv*
    drop if lncashc == 0
    tab lncashc, gen(lncashc_)

    label var lncashc_1 "Hypothetical payment, below 0.2 pctile"
    label var lncashc_2 "Hypothetical payment, between 0.2 and 0.4 pctile"
    label var lncashc_3 "Hypothetical payment, between 0.4 and 0.6 pctile"
    label var lncashc_4 "Hypothetical payment, between 0.6 and 0.8 pctile"
    label var lncashc_5 "Hypothetical payment, above 0.8 pctile"
  
    global cashclasses5 "lncashc_1 lncashc_2 lncashc_3 lncashc_4 lncashc_5"
    global cashclasses "lncashc_2 lncashc_3 lncashc_4 lncashc_5"


*******************************************
* for robustness checks 
*******************************************

** export intensity

    gen exint=(ex/um)*100
    gen l1exint=(L1ex/L1um)*100
    gen L1exint=(L1ex/L1um)*100
    cap drop hv
    egen hv=mean(L1exint), by(br gk)
    replace L1exint=hv if L1exint==.
    sum exint l1exint L1exint,d

    label var exint "export intensity 2006"
    label var l1exint "export intensity 2005"
    label var L1exint "export intensity 2005, incl. imputed values"
    
    
** assets (in logs)

    * log assets beginning of 2006
    gen lnassets = log(sv+0.0001)
    gen lnassets2 = lnassets^2
    sum lna*


    * log assets beginning of 2005
    gen llnassets = log(L1sv+0.000001)
    gen llnassets2 =  log(L1sv+0.000001)^2
    sum llna*


** innovation expenditure (in logs)

    gen lniages = ln(iages + 0.000001)
 

** R&D employee intensity 

    gen fuebp = fueb/size if size !=.
    sum fueb*
    label var fuebp "R&D employee intensity "


** Rating classes

    sum L1bonitaet, d
    drop bonic bonic_*
    
    egen hv1 = pctile(L1bonitaet), p(20)
    egen hv2 = pctile(L1bonitaet), p(40)
    egen hv3 = pctile(L1bonitaet), p(60)
    egen hv4 = pctile(L1bonitaet), p(80)
    
    gen bonic = 0
    replace bonic = 1 if L1bonitaet < hv1
    replace bonic = 2 if L1bonitaet >= hv1 & L1bonitaet < hv2
    replace bonic = 3 if L1bonitaet >= hv2 & L1bonitaet < hv3
    replace bonic = 4 if L1bonitaet >= hv3 & L1bonitaet < hv4
    replace bonic = 5 if L1bonitaet >= hv4 & L1bonitaet!=.
    
    sum L1boni*
    drop hv*
    
    tab bonic, gen(bonic_)


*******************************************
* cluster group variable
*******************************************
    
    egen cls = group(br east)




/*================================================================================*\ 
|                   D E S C R I P T I V E    S T A T I S T I C S        
\*================================================================================*/  


*******************************************
* TABLE II: Descriptive Statistics
*******************************************

* overall sample   
    sum con type $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3 

* by con    
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3: sum X if con == 0
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3: sum X if con == 1
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3: ttest X, by(con) 

* by type (not reported)
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3: sum X if type == 0
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3: sum X if type == 1
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3: sum X if type == 2
    cap drop hv
    gen hv = 0
    replace hv = 1 if type == 2 
    tab hv
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3: ttest X, by(hv) 
    

* by firms with high/low innovation capacity (not reported)
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3: ttest X, by(B1) 
    for var divers inno innoint fueint fuekon mneup fuebp M0 exint: ttest X, by(B1) 

* by firms with low/medium or high financial resources (not reported)
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3: ttest X, by(M0) 
    for var divers inno innoint fueint fuekon mneup fuebp B1 exint: ttest X, by(M0) 

* by B/M combination (not reported)
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3 divers inno innoint fueint fuekon mneup fuebp exint: sum X if b1m0 == 1
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3 divers inno innoint fueint fuekon mneup fuebp exint: sum X if b1m1 == 1
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3 divers inno innoint fueint fuekon mneup fuebp exint: sum X if b1m2 == 1
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3 divers inno innoint fueint fuekon mneup fuebp exint: sum X if b0m0 == 1
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3 divers inno innoint fueint fuekon mneup fuebp exint: sum X if b0m1 == 1
    for var $BM6 size age cash famcom group kapint rating plc east $respond5 $legal3 divers inno innoint fueint fuekon mneup fuebp exint: sum X if b0m2 == 1
    
    
* by innovative firms (not reported)
    for var b1m0 b1m1 b1m2 b0m0 b0m1 b0m2: ttest X, by(inno) 
    for var con: ttest X, by(inno)
    for var type: ttest X, by(inno)



/*================================================================================*\ 
|                           R E G R E S S I O N S       
\*================================================================================*/  
    
estimates clear

* user-written do-file to perform test on heteroskedasticity (lmtest) and normality  (normtest), see Verbeek (1998)
do "probittests.do"

* user-written command "uetest" to perform one-sided t-test   

** test H0: beta1 >= beta2 versus H1: beta1 < beta2

cap program drop uetest
program define uetest, rclass
tempvar sgn pvalue
     {
    return add
    local Var1 = "`1'"
    local Var2 = "`2'"
    local e1 = "`3'"
    local e2 = "`4'"

test `Var1'-`Var2'=0
gen `sgn'=sign(_b[`Var1']-_b[`Var2'])
gen `pvalue'=normal(`sgn'*sqrt(r(chi2)))
sum `pvalue'
return scalar pvalue`e1'`e2'=r(mean)
    }
    end


* user-written command to lm tests for heterscedasticity and normality in the probit models   

cap program drop lmtest
program define lmtest, rclass
tempvar r2_lmhet ts_lmhet 
    quietly {
    return add
    cap drop z_*
    cap drop e_*
    cap drop ydach
    cap drop zaehl
    cap drop nenn
    cap drop eins
    cap drop e
    cap drop xb
    qui probit $endog $exog
    predict xb, xb
    gen eins=1                  
    gen double e=($endog -normprob(xb))* normalden(xb) / (normprob(xb)*(1-normprob(xb))) 

    local j = wordcount("`1'")
    local myvar "`1'"
    foreach x of local myvar {
            gen z_`x'= e*xb*`x'
            }
    foreach x of global exog {
        gen e_`x'= e * `x'
        }
    qui reg eins e_* z_*, nocons
    predict ydach, xb
    egen zaehl=sum(ydach^2)
    egen nenn =sum(eins^2)
    *scalar r2_lm=zaehl/nenn
    *scalar LM=e(N)*r2_lm
    *noisily di in green "LM-Test: " in y LM in g ", df: " in y `j' in g ", p-value: " in y chiprob(`j',LM)
    gen `r2_lmhet' = zaehl/nenn
    sum `r2_lmhet'
    return scalar r2_lmhet=r(mean)
    gen `ts_lmhet' = e(N)*return(r2_lmhet)
    sum `ts_lmhet'
    return scalar ts_lmhet=r(mean)
    return scalar p_lmhet=chiprob(`j',return(ts_lmhet))
    noisily di in green "Test on heteroskedasticity (see Verbeek): " in y return(ts_lmhet) in g ", df: " in y `j' in g ", p-value: " in y return(p_lmhet)
    cap drop ydach
    cap drop zaehl
    cap drop nenn
    cap drop z_*
    *cap drop eins
    *cap drop e
    }
    end



cap program drop normtest
program define normtest, rclass
tempvar r2_lmnorm ts_lmnorm 
    quietly {
    return add
    cap drop exb2 
    cap drop exb3
    cap drop zaehl_n
    cap drop nenn_n
    cap drop ydach_n
    gen exb2=e*(xb)^2
    gen exb3=e*(xb)^3
    reg eins e_* exb2 exb3, nocons
    predict ydach_n, xb
    egen zaehl_n=sum(ydach_n^2)
    egen nenn_n =sum(eins^2)
*    scalar r2_n=zaehl_n/nenn_n
*    scalar LM_n=e(N)*r2_n
*    noisily di in green "Normalitaet-Test: " in y LM_n in g ", df: " in y 2 in g ", p-value: " in y chiprob(2,LM_n)
    gen `r2_lmnorm' = zaehl_n/nenn_n
    sum `r2_lmnorm'
    return scalar r2_lmnorm=r(mean)
    gen `ts_lmnorm' = e(N)*return(r2_lmnorm)
    sum `ts_lmnorm'
    return scalar ts_lmnorm=r(mean)
    return scalar p_lmnorm=chiprob(2,return(ts_lmnorm))
    noisily di in green "Test on normality (see Verbeek): " in y return(ts_lmnorm) in g ", df: " in y 2 in g ", p-value: " in y return(p_lmnorm)
    cap drop exb2 
    cap drop exb3
    cap drop zaehl_n
    cap drop nenn_n
    cap drop ydach_n
    }
    end

global BM "b1m0 b1m1 b1m2 b0m0 b0m1"
global id "br_2 br_3 br_4 br_5 br_6 br_7 br_8 br_9 br_10 br_11 br_12 br_13 br_14 br_15" 

    
************************************************************
* TABLE III: Probit model on being constrained yes/no (con)
************************************************************
    
** Base specification

    * ordinary probit
    global endog con 
    global exog $BM lnsize lnage lnplc east $respond comp $id
    probit $endog $exog
    lmtest "$id east"
    normtest

    * probit with clustered s.e.
    probit con $BM lnsize lnage lnplc east $respond comp $id, robust cluster(cls)
    fitstat

    dprobit con $BM lnsize lnage lnplc east $respond comp $id, robust cluster(cls)

    est store m1

    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3

    testparm br_*
    lstat



** Base specification + external finance

    global exog $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id
    probit $endog $exog
    lmtest "$id east"
    normtest

    probit con $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
    fitstat
    
    dprobit con $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
    est store m2 

    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3

    testparm br_*
    test famcom group kapint rating 
    lstat
 
 
** Base specification + external finance + Cash classes

    * ordinary probit
    global endog con 
    global exog $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $cashclasses $id
    probit $endog $exog
    lmtest "$id east"
    normtest

    probit con $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $cashclasses $id, robust cluster(cls)
    fitstat
    
    
    dprobit con $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $cashclasses $id, robust cluster(cls)
    est store m3 

    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3

    testparm br_*
    test famcom group kapint rating 
    lstat

   
    estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(3))) var(8) model(10) style(smcl) starlevels(* 0.10 ** 0.05 *** 0.01) 


************************************************************************
* TABLE IV: ordered Probit on the degree of financial constraints (type)
************************************************************************

** Preferred specification: Base specification + external finance

    oprobit type $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
    
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3
    
    testparm br_*
    test famcom group kapint rating 
    *fitstat
   
    mfx compute, predict (pr outcome(0)) varlist($BM lnsize lnage lnplc east $respond comp famcom group kapint rating)
    mfx compute, predict (pr outcome(1)) varlist($BM lnsize lnage plnplclc east $respond comp famcom group kapint rating)
    mfx compute, predict (pr outcome(2)) varlist($BM lnsize lnage lnplc east $respond comp famcom group kapint rating)


**********************************************
* TABLE V: MV probits on all response options 
**********************************************

** Preferred specification: Base specification + external finance + $legal

    set seed 1000  
    
    cmp (mittel1 = $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $legal $id) /*
    */  (mittel2 = $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $legal $id) /*
    */  (mittel3 = $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $legal $id) /*
    */  (mittel4 = $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $legal $id) /*
    */  (mittel5 = $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $legal $id), ind(4 4 4 4 4) qui tech(dfp nr) nonrtol
    
    mfx, force predict(pr equation(mittel1)) nonlinear
    mfx, force predict(pr equation(mittel2)) nonlinear
    mfx, force predict(pr equation(mittel3)) nonlinear
    mfx, force predict(pr equation(mittel4)) nonlinear
    mfx, force predict(pr equation(mittel5)) nonlinear
   
    test [mittel1]b1m0 = [mittel1]b1m1  
    test [mittel1]b1m0 = [mittel1]b1m2  
    test [mittel1]b1m1 = [mittel1]b1m2  

    test [mittel2]b1m0 = [mittel2]b1m1  
    test [mittel2]b1m0 = [mittel2]b1m2  
    test [mittel2]b1m1 = [mittel2]b1m2  

    test [mittel3]b1m0 = [mittel3]b1m1  
    test [mittel3]b1m0 = [mittel3]b1m2  
    test [mittel3]b1m1 = [mittel3]b1m2  

    test [mittel4]b1m0 = [mittel4]b1m1  
    test [mittel4]b1m0 = [mittel4]b1m2  
    test [mittel4]b1m1 = [mittel4]b1m2  

    test [mittel5]b1m0 = [mittel5]b1m1  
    test [mittel5]b1m0 = [mittel5]b1m2  
    test [mittel5]b1m1 = [mittel5]b1m2  
    
    testparm br_*
    test [mittel1] famcom [mittel1] group [mittel1] kapint [mittel1] rating 
    test [mittel2] famcom [mittel2] group [mittel2] kapint [mittel2] rating 
    test [mittel3] famcom [mittel3] group [mittel3] kapint [mittel3] rating 
    test [mittel4] famcom [mittel4] group [mittel4] kapint [mittel4] rating 
    test [mittel5] famcom [mittel4] group [mittel4] kapint [mittel4] rating 


************************************************************************************
* TABLE VI: Robustness checks using alternative measures for innovative capability
************************************************************************************

** Robustness checks are performed using the preferred specification: 
** Base specification + external finance


*********
* r1: Defining high innovative capability using qualification level only
*********

    drop b1m0 b1m1 b1m2 b0m2 b0m0 b0m1 innocap
    
    sum bhsp, d
    egen publo = pctile(bhsp), p(80)
    
    gen innocap = 0
    replace innocap = 1 if bhsp > publo & bhsp != .
    
    gen b1m0=1 if innocap==1 & profit==1
    replace b1m0=0 if b1m0==.
    gen b1m1=1 if innocap==1 & profit>1 & profit<5
    replace b1m1=0 if b1m1==.
    gen b1m2=1 if innocap==1 & profit>=5 & profit!=8
    replace b1m2=0 if b1m2==.
    gen b0m0=1 if innocap==0 & profit==1
    replace b0m0=0 if b0m0==.
    gen b0m1=1 if innocap==0 & profit>1 & profit<5
    replace b0m1=0 if b0m1==.
    gen b0m2=1 if innocap==0 & profit>5 & profit!=8
    replace b0m2=0 if b0m2==.

    global R1BM "b1m0 b1m1 b1m2 b0m0 b0m1"
    sum $R1BM

    probit con $R1BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
    fitstat

    dprobit con $R1BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
    est store r1m2
        
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3

    testparm br_*
    test famcom group kapint rating 
    lstat


*********
* r2: Defining high innovative capability using R&D intensity 
*********

    drop b1m0 b1m1 b1m2 b0m2 b0m0 b0m1 innocap publo
    
    sum fueb, d
    egen publo = pctile(fuebp), p(80)
    
    gen innocap = 0
    replace innocap = 1 if fuebp > publo & fuebp !=.

    gen b1m0=1 if innocap==1 & profit==1
    replace b1m0=0 if b1m0==.
    gen b1m1=1 if innocap==1 & profit>1 & profit<5
    replace b1m1=0 if b1m1==.
    gen b1m2=1 if innocap==1 & profit>=5 & profit!=8
    replace b1m2=0 if b1m2==.
    gen b0m0=1 if innocap==0 & profit==1
    replace b0m0=0 if b0m0==.
    gen b0m1=1 if innocap==0 & profit>1 & profit<5
    replace b0m1=0 if b0m1==.
    gen b0m2=1 if innocap==0 & profit>5 & profit!=8
    replace b0m2=0 if b0m2==.


    global R2BM "b1m0 b1m1 b1m2 b0m0 b0m1"
    sum $R2BM

    probit con $R2BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
    fitstat

    dprobit con $R2BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
    est store r2m2
        
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3

    testparm br_*
    test famcom group kapint rating 
    lstat


*********
* r3: Defining high innovative capability using prior innovation success
*********

    drop b1m0 b1m1 b1m2 b0m2 b0m0 b0m1 publo 
    
    gen b1m0=1 if mneu==1 & profit==1
    replace b1m0=0 if b1m0==.
    gen b1m1=1 if mneu==1 & profit>1 & profit<5
    replace b1m1=0 if b1m1==.
    gen b1m2=1 if mneu==1 & profit>=5 & profit!=8
    replace b1m2=0 if b1m2==.
    gen b0m0=1 if mneu==0 & profit==1
    replace b0m0=0 if b0m0==.
    gen b0m1=1 if mneu==0 & profit>1 & profit<5
    replace b0m1=0 if b0m1==.
    gen b0m2=1 if mneu==0 & profit>=5 & profit!=8
    replace b0m2=0 if b0m2==.


    global R3BM "b1m0 b1m1 b1m2 b0m0 b0m1"
    sum $R3BM

    probit con $R3BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
    fitstat

    dprobit con $R3BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
    est store r3m2
        
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3

    testparm br_*
    test famcom group kapint rating 
    lstat




**************************************************************
* TABLE VII: Probit and ordered model with sample selection 
**************************************************************

** Use original definition of innocap again

    drop b1m0 b1m1 b1m2 b0m2 b0m0 b0m1 innocap train pablo
    
    sum bhsp, d
    egen pablo = pctile(bhsp), p(80)  
    
    sum wb_b, d
    egen train = pctile(wb_b), p(80) 
    
    gen innocap = 0
    replace innocap = 1 if (bhsp > pablo & bhsp !=.) | (wb_b > train & wb_b !=.) 
     
    cap drop hv train
    
    gen b1m0=1 if innocap==1 & profit==1
    replace b1m0=0 if b1m0==.
    gen b1m1=1 if innocap==1 & profit>1 & profit<5
    replace b1m1=0 if b1m1==.
    gen b1m2=1 if innocap==1 & profit>=5 & profit!=8
    replace b1m2=0 if b1m2==.
    gen b0m0=1 if innocap==0 & profit==1
    replace b0m0=0 if b0m0==.
    gen b0m1=1 if innocap==0 & profit>1 & profit<5
    replace b0m1=0 if b0m1==.
    gen b0m2=1 if innocap==0 & profit>=5 & profit!=8
    replace b0m2=0 if b0m2==.

    global BM "b1m0 b1m1 b1m2 b0m0 b0m1"
    sum $BM


    sum inno 
    sum divers L1exint 


** for constraint yes/no(CON)

    * exclusion restriction for explaining innovation, but not financial constraints:
    * lagged export intensity, diversification
    
        set seed 123456789
    
    ** full estimation sample (lagged export intensity included imputed values) 
        cmp (con = $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id) /*
            */ (inno = lnsize lnage lnplc east comp group kapint famcom divers L1exint $id), ind(inno*4 4) qui rob cluster(cls)

    
        mfx, force predict(pr equation(con)) nonlinear
        mfx, force predict(pr equation(inno)) nonlinear
    
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3
    
    testparm br_*
    test [con] famcom [con] group [con] kapint [con] rating
         
    ** for robustness: reduced estimation sample, without imputed values for lagged export intensity (not reported)
        cmp (con = $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id) /*
            */ (inno = lnsize lnage lnplc east comp group kapint famcom divers l1exint $id), ind(inno*4 4) qui rob cluster(cls)
    
        mfx, force predict(pr equation(con)) nonlinear
        mfx, force predict(pr equation(inno)) nonlinear
    
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3
    
    testparm br_*
    test [con] famcom [con] group [con] kapint [con] rating
    
    
** for degree of constraint (TYPE)

    set seed 123456789

    cmp (type = $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id) /*
        */ (inno = lnsize lnage lnplc east comp group kapint famcom divers l1exint $id), ind(inno*5 4) qui rob cluster(cls)
    
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3


    testparm br_*
    test [type] famcom [type] group [type] kapint [type] rating
     
    mfx, force predict(pr equation(inno)) nonlinear
    mfx, force predict(pr outcome(0) equation(type)) nonlinear
    mfx, force predict(pr outcome(1) equation(type)) nonlinear
    mfx, force predict(pr outcome(2) equation(type)) nonlinear



*******************************************
* TABLE VIII: Tobits on innovation investments by CON
*******************************************

estimates clear
 
    tobit lniages lpcm2 bonic_2-bonic_5 llnassets llnassets2 lnage comp $id if con == 1, ll
    sca Ncon1=e(N)   
    sca dofcon1=e(df_r)
    est store m1 
    mfx compute, predict(e(-13.815511, .))      
    matrix bcon1=e(Xmfx_dydx)
    matrix secon1=e(Xmfx_se_dydx)
    
    testparm br_*
    
    tobit lniages lpcm2 bonic_2-bonic_5 llnassets llnassets2 lnage comp $id if con == 0, ll
    sca Ncon0=e(N)
    sca dofcon0=e(df_r)
    est store m2 
    mfx compute, predict(e(-13.815511, .))
    matrix bcon0=e(Xmfx_dydx)
    matrix secon0=e(Xmfx_se_dydx)
    testparm br_*

    estout m1 m2, cells(b(star fmt(3)) se(par fmt(3))) var(8) model(10) style(smcl) starlevels(* 0.10 ** 0.05 *** 0.01)


*** test in equality of marginal effects between equations

* for pcm
    sca mEdiff_lpcm2=bcon1[1,1]-bcon0[1,1]
    
    sca vcon1_lpcm2=(secon1[1,1]^2)*dofcon1 
    sca vcon0_lpcm2=(secon0[1,1]^2)*dofcon0 
    sca se_lpcm2=((vcon1_lpcm2+vcon0_lpcm2)/(dofcon1+dofcon0))^0.5
    sca Tstat_lpcm2=mEdiff_lpcm2/se_lpcm2
    di Tstat_lpcm2

* for rating2 
    sca mEdiff_bonic2=bcon1[1,2]-bcon0[1,2]    
    sca vcon1_bonic2=(secon1[1,2]^2)*dofcon1 
    sca vcon0_bonic2=(secon0[1,2]^2)*dofcon0 
    sca se_bonic2=((vcon1_bonic2+vcon0_bonic2)/(dofcon1+dofcon0))^0.5
    sca Tstat_bonic2=mEdiff_bonic2/se_bonic2
    di Tstat_bonic2     
                        
* for rating3 
    sca mEdiff_bonic3=bcon1[1,3]-bcon0[1,3]  
    sca vcon1_bonic3=(secon1[1,3]^2)*dofcon1 
    sca vcon0_bonic3=(secon0[1,3]^2)*dofcon0    
    sca se_bonic3=((vcon1_bonic3+vcon0_bonic3)/(dofcon1+dofcon0))^0.5 
    sca Tstat_bonic3=mEdiff_bonic3/se_bonic3
    di Tstat_bonic3     

* for rating4 
    sca mEdiff_bonic4=bcon1[1,4]-bcon0[1,4]
    sca vcon1_bonic4=(secon1[1,4]^2)*dofcon1 
    sca vcon0_bonic4=(secon0[1,4]^2)*dofcon0 
    sca se_bonic4=((vcon1_bonic4+vcon0_bonic4)/(dofcon1+dofcon0))^0.5 
    sca Tstat_bonic4=mEdiff_bonic4/se_bonic4
    di Tstat_bonic4 
    
    
* for rating5 
    sca mEdiff_bonic5=bcon1[1,5]-bcon0[1,5]    
    sca vcon1_bonic5=(secon1[1,5]^2)*dofcon1 
    sca vcon0_bonic5=(secon0[1,5]^2)*dofcon0    
    sca se_bonic5=((vcon1_bonic5+vcon0_bonic5)/(dofcon1+dofcon0))^0.5   
    sca Tstat_bonic5=mEdiff_bonic5/se_bonic5
    di Tstat_bonic5
 



*---------------------------------------------------------------------------------------
*
*           T A B E L S      A P P E N D I X  
*
*---------------------------------------------------------------------------------------

*** Table A.1 Industries and CON by industries
    tabstat con, by(br) 
    tabstat type, by(br) 
    tab type br
    tab br type, col
    tab br type, row



*** Table A.2 Profit-Margin Categories
    tab profit


  
*** Table A.4: Sensitivity Analysis

    **** Benchmark case: innovative capability based on formal qualification and training, 80pctile
        
        qui probit con $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
        fitstat
        dprobit con $BM lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
            
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0 b1m0  1 4  
    uetest  b0m1 b1m1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1 b1m0 1 2  
    uetest  b1m2 b1m0 1 3
    uetest  b1m2 b1m1 2 3
    
    testparm br_*
    test famcom group kapint rating 
    lstat
    


    **** Line 1: innovative capability based on formal qualification and training, mean

        sum bhsp,d
        egen pablom = mean(bhsp) 
        sum wb_b, d
        egen trainm = mean(wb_b)
        gen innocap1 = 0
        replace innocap1 = 1 if (bhsp > pablom & bhsp !=.) | (wb_b > trainm & wb_b !=.) 

        gen b1m0_s1=1 if innocap1==1 & profit==1
        replace b1m0_s1=0 if b1m0_s1==.
        gen b1m1_s1=1 if innocap1==1 & profit>1 & profit<5
        replace b1m1_s1=0 if b1m1_s1==.
        gen b1m2_s1=1 if innocap1==1 & profit>=5 & profit!=8
        replace b1m2_s1=0 if b1m2_s1==.
        gen b0m0_s1=1 if innocap1==0 & profit==1
        replace b0m0_s1=0 if b0m0_s1==.
        gen b0m1_s1=1 if innocap1==0 & profit>1 & profit<5
        replace b0m1_s1=0 if b0m1_s1==.
        gen b0m2_s1=1 if innocap1==0 & profit>=5 & profit!=8
        replace b0m2_s1=0 if b0m2_s1==.
    
        global BMs1 "b1m0_s1 b1m1_s1 b1m2_s1 b0m0_s1 b0m1_s1"
    
        qui probit con $BMs1 lnsize lnage plc east $respond comp famcom group kapint rating $id, robust cluster(cls)
        fitstat

        dprobit con $BMs1 lnsize lnage plc east $respond comp famcom group kapint rating $id, robust cluster(cls)
            
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0_s1 b1m0_s1  1 4  
    uetest  b0m1_s1 b1m1_s1  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2_s1=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1_s1 b1m0_s1 1 2  
    uetest  b1m2_s1 b1m0_s1 1 3
    uetest  b1m2_s1 b1m1_s1 2 3
    
    testparm br_*
    test famcom group kapint rating 
    lstat
    
    
    
    **** Line 2: innovative capability based on formal qualification and training, median
    
        sum bhsp,d
        egen pablo50 = pctile(bhsp), p(50)
        sum wb_b, d
        egen train50 = pctile(wb_b), p(50)
        gen innocap2 = 0
        replace innocap2 = 1 if (bhsp > pablo50 & bhsp !=.) | (wb_b > train50 & wb_b !=.) 

        gen b1m0_s2=1 if innocap2==1 & profit==1
        replace b1m0_s2=0 if b1m0_s2==.
        gen b1m1_s2=1 if innocap2==1 & profit>1 & profit<5
        replace b1m1_s2=0 if b1m1_s2==.
        gen b1m2_s2=1 if innocap2==1 & profit>=5 & profit!=8
        replace b1m2_s2=0 if b1m2_s2==.
        gen b0m0_s2=1 if innocap2==0 & profit==1
        replace b0m0_s2=0 if b0m0_s2==.
        gen b0m1_s2=1 if innocap2==0 & profit>1 & profit<5
        replace b0m1_s2=0 if b0m1_s2==.
        gen b0m2_s2=1 if innocap2==0 & profit>=5 & profit!=8
        replace b0m2_s2=0 if b0m2_s2==.
    
        global BMs2 "b1m0_s2 b1m1_s2 b1m2_s2 b0m0_s2 b0m1_s2"
    
        qui probit con $BMs2 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
        fitstat

        dprobit con $BMs2 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
            
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0_s2 b1m0_s2  1 4  
    uetest  b0m1_s2 b1m1_s2  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2_s2=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1_s2 b1m0_s2 1 2  
    uetest  b1m2_s2 b1m0_s2 1 3
    uetest  b1m2_s2 b1m1_s2 2 3
    
    testparm br_*
    lstat
    test famcom group kapint rating 


    **** Line 3: innovative capability based on formal qualification and training, 90pctile
    
        sum bhsp,d
        egen pablo90 = pctile(bhsp), p(90)
        sum wb_b, d
        egen train90 = pctile(wb_b), p(90)
        gen innocap3 = 0
        replace innocap3 = 1 if (bhsp > pablo90 & bhsp !=.) | (wb_b > train90 & wb_b !=.) 

        gen b1m0_s3=1 if innocap3==1 & profit==1
        replace b1m0_s3=0 if b1m0_s3==.
        gen b1m1_s3=1 if innocap3==1 & profit>1 & profit<5
        replace b1m1_s3=0 if b1m1_s3==.
        gen b1m2_s3=1 if innocap3==1 & profit>=5 & profit!=8
        replace b1m2_s3=0 if b1m2_s3==.
        gen b0m0_s3=1 if innocap3==0 & profit==1
        replace b0m0_s3=0 if b0m0_s3==.
        gen b0m1_s3=1 if innocap3==0 & profit>1 & profit<5
        replace b0m1_s3=0 if b0m1_s3==.
        gen b0m2_s3=1 if innocap3==0 & profit>=5 & profit!=8
        replace b0m2_s3=0 if b0m2_s3==.
    
        global BMs3 "b1m0_s3 b1m1_s3 b1m2_s3 b0m0_s3 b0m1_s3"
    
        qui probit con $BMs3 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
        fitstat

        dprobit con $BMs3 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
            
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0_s3 b1m0_s3  1 4  
    uetest  b0m1_s3 b1m1_s3  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2_s3=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1_s3 b1m0_s3 1 2  
    uetest  b1m2_s3 b1m0_s3 1 3
    uetest  b1m2_s3 b1m1_s3 2 3
    
    testparm br_*
    test famcom group kapint rating 
    lstat
    

        egen ICB = pctile(bhsp), p(80) by(nace2) 
        egen ICB_wb = pctile(wb_b), p(80) by(nace2)   
          
        gen innocap4 = 0  
        replace innocap4 = 1 if (bhsp > ICB & bhsp !=.) | (wb_b > ICB_wb & wb_b !=.) 
  
        gen b1m0_s4=1 if innocap4==1 & profit==1
        replace b1m0_s4=0 if b1m0_s4==.
        gen b1m1_s4=1 if innocap4==1 & profit>1 & profit<5
        replace b1m1_s4=0 if b1m1_s4==.
        gen b1m2_s4=1 if innocap4==1 & profit>=5 & profit!=8
        replace b1m2_s4=0 if b1m2_s4==.
        gen b0m0_s4=1 if innocap4==0 & profit==1
        replace b0m0_s4=0 if b0m0_s4==.
        gen b0m1_s4=1 if innocap4==0 & profit>1 & profit<5
        replace b0m1_s4=0 if b0m1_s4==.
        gen b0m2_s4=1 if innocap4==0 & profit>=5 & profit!=8
        replace b0m2_s4=0 if b0m2_s4==.
    
        global BMs4 "b1m0_s4 b1m1_s4 b1m2_s4 b0m0_s4 b0m1_s4"
    
        qui probit con $BMs4 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
        fitstat

        dprobit con $BMs4 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
  
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0_s4 b1m0_s4  1 4  
    uetest  b0m1_s4 b1m1_s4  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2_s4=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1_s4 b1m0_s4 1 2  
    uetest  b1m2_s4 b1m0_s4 1 3
    uetest  b1m2_s4 b1m1_s4 2 3
    
    testparm br_*
    test famcom group kapint rating 
    lstat
 



    **** Line 5: innovative capability based on formal qualification, 80pctile
    
        egen pablo80 = pctile(bhsp), p(80)
        gen innocap5 = 0
        replace innocap5 = 1 if (bhsp > pablo80 & bhsp !=.)  

        gen b1m0_s5=1 if innocap5==1 & profit==1
        replace b1m0_s5=0 if b1m0_s5==.
        gen b1m1_s5=1 if innocap5==1 & profit>1 & profit<5
        replace b1m1_s5=0 if b1m1_s5==.
        gen b1m2_s5=1 if innocap5==1 & profit>=5 & profit!=8
        replace b1m2_s5=0 if b1m2_s5==.
        gen b0m0_s5=1 if innocap5==0 & profit==1
        replace b0m0_s5=0 if b0m0_s5==.
        gen b0m1_s5=1 if innocap5==0 & profit>1 & profit<5
        replace b0m1_s5=0 if b0m1_s5==.
        gen b0m2_s5=1 if innocap5==0 & profit>=5 & profit!=8
        replace b0m2_s5=0 if b0m2_s5==.
    
        global BMs5 "b1m0_s5 b1m1_s5 b1m2_s5 b0m0_s5 b0m1_s5"
    
        qui probit con $BMs5 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
        fitstat

        dprobit con $BMs5 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
            
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0_s5 b1m0_s5  1 4  
    uetest  b0m1_s5 b1m1_s5  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2_s5=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1_s5 b1m0_s5 1 2  
    uetest  b1m2_s5 b1m0_s5 1 3
    uetest  b1m2_s5 b1m1_s5 2 3
    
    testparm br_*
    test famcom group kapint rating 
    lstat


    **** Line 6: innovative capability based on R&D intensity, 80pctile
    
        egen publo80 = pctile(fuebp), p(80)
        gen innocap6 = 0
        replace innocap6 = 1 if (fuebp > publo80 & fuebp !=.)  

        gen b1m0_s6=1 if innocap6==1 & profit==1
        replace b1m0_s6=0 if b1m0_s6==.
        gen b1m1_s6=1 if innocap6==1 & profit>1 & profit<5
        replace b1m1_s6=0 if b1m1_s6==.
        gen b1m2_s6=1 if innocap6==1 & profit>=5 & profit!=8
        replace b1m2_s6=0 if b1m2_s6==.
        gen b0m0_s6=1 if innocap6==0 & profit==1
        replace b0m0_s6=0 if b0m0_s6==.
        gen b0m1_s6=1 if innocap6==0 & profit>1 & profit<5
        replace b0m1_s6=0 if b0m1_s6==.
        gen b0m2_s6=1 if innocap6==0 & profit>=5 & profit!=8
        replace b0m2_s6=0 if b0m2_s6==.
    
        global BMs6 "b1m0_s6 b1m1_s6 b1m2_s6 b0m0_s6 b0m1_s6"
    
        qui probit con $BMs6 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
        fitstat

        dprobit con $BMs6 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
            
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0_s6 b1m0_s6  1 4  
    uetest  b0m1_s6 b1m1_s6  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2_s6=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1_s6 b1m0_s6 1 2  
    uetest  b1m2_s6 b1m0_s6 1 3
    uetest  b1m2_s6 b1m1_s6 2 3
    
    testparm br_*
    test famcom group kapint rating 
    lstat

    

    
    **** Line 7: innovative capability based on past innovation success, median
        sum mneup, d
        egen succ = pctile(mneup), p(50) 
        gen innocap7 = 0
        replace innocap7 = 1 if mneup > succ & mneup !=.
    

        gen b1m0_s7=1 if innocap7==1 & profit==1
        replace b1m0_s7=0 if b1m0_s7==.
        gen b1m1_s7=1 if innocap7==1 & profit>1 & profit<5
        replace b1m1_s7=0 if b1m1_s7==.
        gen b1m2_s7=1 if innocap7==1 & profit>=5 & profit!=8
        replace b1m2_s7=0 if b1m2_s7==.
        gen b0m0_s7=1 if innocap7==0 & profit==1
        replace b0m0_s7=0 if b0m0_s7==.
        gen b0m1_s7=1 if innocap7==0 & profit>1 & profit<5
        replace b0m1_s7=0 if b0m1_s7==.
        gen b0m2_s7=1 if innocap7==0 & profit>=5 & profit!=8
        replace b0m2_s7=0 if b0m2_s7==.
    
        global BMs7 "b1m0_s7 b1m1_s7 b1m2_s7 b0m0_s7 b0m1_s7"
    
        qui probit con $BMs7 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
        fitstat

        dprobit con $BMs7 lnsize lnage lnplc east $respond comp famcom group kapint rating $id, robust cluster(cls)
            
    ** Test H1: (1) beta1 (b1m0) > beta4 (b0m0); (2) beta2 (b1m1) > beta5 (b0m1); (3) beta3 (b1m2) > 0
    ** compare pairwise hypotheses with adjusted significance level alpha/3 (Bonferroni)
    sca bonfi10=0.1/3
    sca bonfi5=0.05/3
    sca bonfi1=0.01/3
    sca di bonfi10 bonfi5 bonfi1

    sca sidak10=1-(1-0.1)^(1/3)
    sca sidak5=1-(1-0.05)^(1/3)
    sca sidak1=1-(1-0.01)^(1/3)
    sca di sidak10 sidak5 sidak1

    ** figures " 1 4" just indicate which coefficients are tested, no other meaning
    uetest  b0m0_s7 b1m0_s7  1 4  
    uetest  b0m1_s7 b1m1_s7  2 5
    * two-sided test => one-sided test: pvalue/2 
    test b1m2_s7=0
    
          
    ** Test H2a: (1) beta1 (b1m0) > beta2 (b1m1); (2) beta1 (b1m0) > beta3 (b1m2); (3) beta2 (b1m1) > beta3 (b1m2)
    uetest  b1m1_s7 b1m0_s7 1 2  
    uetest  b1m2_s7 b1m0_s7 1 3
    uetest  b1m2_s7 b1m1_s7 2 3
    
    testparm br_*
    test famcom group kapint rating 
    lstat



*** Table A.6 Cross-Correlation Table   
    corr con type m0 m1 m2 innocap lnsize lnage $cashclasses5 famcom group kapint rating $respond5 comp plc east $legal3 inno

