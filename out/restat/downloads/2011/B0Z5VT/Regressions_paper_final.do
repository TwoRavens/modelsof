/*
This program runs the regressions and tables presented in "Credit Chains and Sectoral Comovement"
Claudio Raddatz, The World Bank, 2010
*/

capture clear matrix
clear
capture log close
set mem 200m
set matsize 5000
clear
eststo clear

use creditchains_final


capture program drop interact
program define interact
     gen `1'x`2' = `1'*`2'
     label var `1'x`2' "Interaction `1' and `2'"
end

set more off

/*The following macro defines the sample*/
global sample "ind1~=ind2 & extendedsample==1"
local suffix "test" 					/*Defines extensions for the files' names: Tables will be saved with the name in the paper plus this extension*/
local addBGD = 0				/*Bangladesh is an outlier, this flag determines whether to include it in the sample*/	
/*Define the trade credit variables*/

if `addBGD'==1 {
        replace InvPaymax = InvPay_ica if wbcode=="BGD" *Careful not to keep this afterwards
        replace Stdmax       = Std_ica  if wbcode=="BGD"
       }

replace corriip=. if wbcode=="LKA" /*LKA outlier in IIP regressions. Elimination is not crucial.*/

local Stdbtpay "Stdmax"
local InvPayturn "InvPaymax"



foreach v of varlist DemStdpay rdems DemStdpayCC {
    capture interact `v' `Stdbtpay'
    capture interact `v' loggdp8000
    capture interact `v' logopenwdi8000
}

*Interactions for the inverse measures

gen lpvtc = logpvtc8000

foreach v of varlist rdems DemPayCC_inv DemPayCCUK_inv DemPayCC_invmat {
    capture interact `v' `InvPayturn'
    capture interact `v'x`InvPayturn' lpvtc
    if "`v'"~="rdems" {
        capture interact `v' loggdp8000
            capture interact `v' logopenwdi8000
    }
}

capture interact DemPayCC_inv INVPAY
capture replace InvPay_amadeus = . if wbcode=="HUN" | wbcode=="ISL" | wbcode=="GRC" | wbcode=="PRT"
capture interact DemPayCC_inv InvPay_amadeus
capture interact DemPayCC_inv stmktcap8000
capture interact DemPayCC_invmat InvPayMatmax
capture interact buy `InvPayturn'
capture interact sell `InvPayturn'
capture interact distinvsa logpvtc8000
capture interact distance_exf80 logpvtc8000
capture interact distancecapemp logkapw8099
capture interact distancegini sdgth_rgdpl
capture interact DemPayCC_inv sdgth_rgdpl
capture interact DemPayCC_inv sdgth_rgdpl8000
capture interact DemPayCC_inv logpvtc8000
capture interact DemPayCC_invx`InvPayturn' `Stdbtpay'
capture interact BPay_inv `InvPayturn'
capture interact DemPayCC_test `InvPayturn'
capture qui gen DemPayCC_diff = DemPayCC_inv - DemPayCC_test
capture interact DemPayCC_diff `InvPayturn'
capture interact BackwdPayCC InvPaymax



preserve

collapse corr corriip rdems DemPayCC DemPayCC_inv DemStdpayCC DemPayCC_invx`InvPayturn' DemStdpayCCx`Stdbtpay' lognestab1 lognestab2 share1 share2 buy /*
*/ sell invsa_1 invsa_2 distinvsa  distance_exf80 distancecapemp distdur distancegini /*
*/ (p50) Corr=corr Corriip=corriip if $sample, by(ind1 ind2 ind_ij)

     replace distancecapemp = distancecapemp/1000


*Summary statistics


sort rdems
gen ntmp1 = _N-_n +1
sort DemPayCC
gen ntmp2 = _N-_n +1
sort DemPayCC_inv
gen ntmp3 = _N-_n +1
sort DemStdpayCC
gen ntmp4 = _N-_n +1
local Nsectors = _N

save Distances_Industry_pairs, replace

*Defining industries with high and low distance for future reference

levelsof ind_ij if ntmp3<=20, local(closeindustries)
levelsof ind_ij if ntmp3>=`Nsectors'-20, local(farindustries)


log using Summary_Stats_`suffix', replace

tabstat rdems ntmp1 if ntmp1<=20 | ntmp1>=`Nsectors'-20, by(ind_ij) notot stat(mean)
tabstat DemPayCC ntmp2 if ntmp2<=20 | ntmp2>=`Nsectors'-20, by(ind_ij) notot stat(mean)
tabstat DemPayCC_inv ntmp3 if ntmp3<=20 | ntmp3>=`Nsectors'-20, by(ind_ij) notot stat(mean)
tabstat DemStdpayCC ntmp4 if ntmp4<=20 | ntmp4>=`Nsectors'-20, by(ind_ij) notot stat(mean)

tw hist DemPayCC_inv, frac bstyle(p1bar) saving(CCDistance_histogram, replace) xtitle(Credit Chain Distance)

tw hist rdems, frac bstyle(p1bar) saving(IODistance_histogram, replace) xtitle(Input-Output Distance)

log off

restore




*=========================================================
*4.- Considering the whole credit chain
*=========================================================

*For regressions with the Payables turnover measure go to the 12-28-07 version of the program

*Summary statistics in the main sample

*capture log on

tabstat  `InvPayturn' `Stdbtpay' quality if $sample, by(wbcode) stat(mean) notot

tabstat corr corriip rgdpl8000 if $sample, by(wbcode) stat(mean)

tabstat corr corriip if $sample, by(wbcode) stat(count)

*log off

*Re-labeling variables before regressions

label var lognestab1 "(log) Number of establishments industry 1"
label var lognestab2 "(log) Number of establishments industry 2"
label var share1 "Share of manufacturing VA industry 1"
label var share2 "Share of manufacturing VA industry 2"
label var gth_iip1 "Average growth industry 1"
label var gth_iip2 "Average growth industry 2"
label var sdgth_iip1 "Standard deviation growth industry 1"
label var sdgth_iip2 "Standard deviation growth industry 2"
label var gth_vareal1 "Average growth industry 1"
label var gth_vareal2 "Average growth industry 2"
label var sdgvar1 "Standard deviation growth industry 1"
label var sdgvar2 "Standard deviation growth industry 2"
label var DemPayCC_invx`InvPayturn' "Credit Chain Linkage (Payables Financing)"
label var DemStdpayCCx`Stdbtpay' "Credit Chain Linkage (Short term debt to Payables)"
label var DemVar "Correlation from differences in shocks volatilities"
label var DemPayCC_invxloggdp8000 "Generic Credit Chain Linkage X (log) GDP per capita"
label var DemPayCC_invxsdgth_rgdpl8000 "Generic Credit Chain Linkage X Growth Volatility"
label var DemPayCC_invx`InvPayturn'xlpvtc "Credit Chain Linkage X Financial Development"
label var DemPayCC_invxlogopenwdi8000 "Generic Credit Chain Linkage X Trade Openness"
label var distinvsaxlogpvtc8000 "Dist. liquidity needs X Financial Development"
label var distance_exf80xlogpvtc8000 "Dist. lexternal finance X Financial Development"
label var distancecapempxlogkapw8099 "Dist. capital per employee X Capital per Worker"
label var DemPayCC_invxInvPay_amadeus "Credit Chain Linkage from Amadeus (Payable Financing)"
label var DemPayCC_invxstmktcap8000 "Generic Credit Chain Linkage X Stock Market Cap."

//Renaming variables for presentation in vertical mode
label var DemPayCC_invmatxInvPayMatmax "Credit Chain Linkage"
label var DemPayCC_invxINVPAY "Credit Chain Linkage"
label var DemPayCC_invxInvPay_amadeus "Credit Chain Linkage"
label var DemPayCCUK_invx`InvPayturn' "Credit Chain Linkage"
label var DemInvPayCC_c05 "Credit Chain Linkage"


label var buyx`InvPayturn' "BUY distance X Payables Financing"
label var sellx`InvPayturn' "SELL distance X Payables Financing"
label var distanceginixsdgth_rgdpl "Dist. Gini intermediary shares X Overall Volatility"
label var DemPayCC_invxsdgth_rgdpl "Generic Credit Chain Dist. X Overall Volatility"
label var DemPayCC_invxlogpvtc8000 "Credit Chain Linkage X Financial Development"
label var DemPayCC_invx`InvPayturn'x`Stdbtpay' "Credit Chain Linkage X Short term debt to Payables"
label var BPay_invx`InvPayturn' "Direct Credit Chain Linkage (Payables Financing)"
label var DemPayCC_diffx`InvPayturn' "Credit Chain Linkage (Differential use)"
label var DemPayCC_testx`InvPayturn' "Credit Chain Linkage (Common use)"
label var BackwdPayCCxInvPaymax "IO Backward linkages matrix X Payables Financing"



*Main table

xi: areg  corr  DemPayCC_invx`InvPayturn'  i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"

xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn'  i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"

xi: areg  corr  lognestab1 lognestab2 share1 share2 gth_vareal1 gth_vareal2 sdgvar1 sdgvar2 DemPayCC_invx`InvPayturn'  i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"

xi: areg  corr  DemStdpayCCx`Stdbtpay' i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"

xi: areg  corr  lognestab1 lognestab2 share1 share2 DemStdpayCCx`Stdbtpay' i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"

xi: areg  corr  lognestab1 lognestab2 share1 share2 gth_vareal1 gth_vareal2 sdgvar1 sdgvar2 DemStdpayCCx`Stdbtpay'  i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"

xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' DemStdpayCCx`Stdbtpay'  i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"


esttab using Table4_`suffix'.csv, r2 replace b(3) se(3) star(* 0.1 ** 0.05 *** 0.001) drop(_Iwbcode*) /*
*/ scalars("hasindpair Industry pair FE" "hascty Country FE") nocons label order(DemPayCC_invx`InvPayturn' DemStdpayCCx`Stdbtpay' lognestab1 lognestab2 share1 share2 gth_vareal1 gth_vareal2 sdgvar1 sdgvar2)

eststo clear


*Possible plots of the relation between corr and DemPayCC_inv for sets of industries

gen dummyclose = 0
foreach i of local closeindustries {
		if "`i'"=="371384" {
			reg corr `InvPayturn' if ind_ij=="`i'" & extendedsample==1, r
			avplot `InvPayturn', ml(wbcode) xtitle(Payables Financing) ytitle(correlation) saving(graph_correlation_`i',replace)
			replace dummyclose = 1 if ind_ij=="`i'"
		}
        }
gen dummyfar = 0
foreach i of local farindustries {
		if "`i'"=="314324" {
			reg corr `InvPayturn' if ind_ij=="`i'" & extendedsample==1, r
			avplot `InvPayturn', ml(wbcode) xtitle(Payables Financing) ytitle(correlation) saving(graph_correlation_`i',replace)
			replace dummyfar= 1 if ind_ij=="`i'"
		}
        }

 *All close together versus all far together

xi: reg corr `InvPayturn' i.ind_ij if dummyclose==1 & extendedsample==1, r cl(wbcode)
avplot `InvPayturn', ml(wbcode) xtitle(Payables Financing) ytitle(correlation) saving(graph_correlation_20closer,replace)

xi: reg corr `InvPayturn' i.ind_ij if dummyfar==1 & extendedsample==1, r cl(wbcode)
avplot `InvPayturn', ml(wbcode) xtitle(Payables Financing) ytitle(correlation) saving(graph_correlation_20far,replace)


*=============================================================================================
*6.-Robustness
*=============================================================================================

*Sample Issues

*Jacknifed results

levelsof wbcode if extendedsample==1, local(countries)
levelsof ind_ij if $sample, local(industrypairs)

local ncountries: word count "`countries'"
local nindustries: word count "`industrypairs'"

local ncountries = `ncountries'-2
local nindustries = `nindustries' - 2

matrix Bcountries  = J(`ncountries',3,.)
matrix Bindustries = J(`nindustries',3,.)

local i = 1

local colnames_c ""
local colnames "coef se p"

foreach c of local countries {

    qui xi: areg  corr  DemPayCC_invx`InvPayturn' i.wbcode if $sample & wbcode~="`c'", r abs(ind_ij)
    matrix Bcountries[`i',1] = _b[DemPayCC_invx`InvPayturn']
    matrix Bcountries[`i',2] = _se[DemPayCC_invx`InvPayturn']
    matrix Bcountries[`i',3] = 2*ttail(e(df_r),abs(_b[DemPayCC_invx`InvPayturn']/_se[DemPayCC_invx`InvPayturn']))
    local colnames_c "`colnames_c' `c'"
    local i = `i'+ 1
    }

matrix rowname Bcountries = `colnames_c'
matrix colname Bcountries = `colnames'

local i = 1

local colnames_i ""

foreach j of local industrypairs {

    qui xi: areg  corr  DemPayCC_invx`InvPayturn' i.wbcode if $sample & ind_ij~="`j'", r abs(ind_ij)
    matrix Bindustries[`i',1] = _b[DemPayCC_invx`InvPayturn']
    matrix Bindustries[`i',2] = _se[DemPayCC_invx`InvPayturn']
    matrix Bindustries[`i',3] = 2*ttail(e(df_r),abs(_b[DemPayCC_invx`InvPayturn']/_se[DemPayCC_invx`InvPayturn']))
    local colnames_i "`colnames_i' `j'"
    local i = `i'+ 1
    }

matrix rowname Bindustries = `colnames_i'
matrix colname Bindustries = `colnames'


preserve

drop _all

svmat Bcountries, names(col)

gen wbcode = ""

local i = 1

foreach c of local countries {
    replace wbcode = "`c'" in `i'
    local i = `i'+1
    }

save Coefficients_dropcountry, replace

log on

tabstat coef, s(mean sd)

log off

drop _all

svmat Bindustries, names(col)

gen ind_ij = ""

local i = 1

foreach j of local industries {
    replace ind_ij = "`j'" in `i'
    local i = `i'+1
    }

save Coefficients_dropindustry, replace

log on

tabstat coef, s(mean sd)

log off

restore


/*Of main table*/
*Other sample issues

*a) High quality only

global sample "ind1~=ind2 & quality==1 & extendedsample==1" /*Broadest possible sample*/

    xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"

global sample "ind1~=ind2 & extendedsample==1" /*Main sample*/


*d) Dropping transition economies


    xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' i.wbcode if $sample & wbcode~="HUN" & wbcode~="POL" & wbcode~="CHN" , r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"


*e) Dropping 10% highest and lowest Payturn

    xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' i.wbcode if $sample & pctile_InvPaymax>=2 & pctile_InvPaymax<=9, r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"

*f) Drop 5-95 percentiles in distance

        xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' i.wbcode if $sample & pctile_DemPayCC_inv>1 & pctile_DemPayCC_inv<20, r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"

*g) Robust

        xi: rreg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' i.wbcode i.ind_ij if $sample
        eststo
        estadd local hasindpair "Yes"
        estadd local hascty "Yes"


*Various measures of correlation and creditchains
*================================================

    xi: areg  corriip  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"

*a) HPva

     xi: areg  corrHPva  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
     eststo
        estadd local hasindpair "Yes"
        estadd local hascty "Yes"

*b) Correlation transformation

     xi: areg  corr_t  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
     eststo
     estadd local hasindpair "Yes"
     estadd local hascty "Yes"

*c) Robust Correlation

     xi: areg  corr_rob  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
    eststo
     estadd local hasindpair "Yes"
     estadd local hascty "Yes"


*Alternative measures of credit-chain distance

*e) Using country level info

    xi: areg  corr  lognestab1 lognestab2 share1 share2 DemInvPayCC_c05 i.wbcode if $sample, r abs(ind_ij)
    eststo
     estadd local hasindpair "Yes"
     estadd local hascty "Yes"

*f) Using UK data

    xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCCUK_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
    eststo
     estadd local hasindpair "Yes"
     estadd local hascty "Yes"

*b) Using countries with representative measure of trade credit use

    xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invxInvPay_amadeus i.wbcode if $sample, r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"


*b) Using countries with representative measure of trade credit use

    xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invxInvPaymax DemPayCC_invxstmktcap8000 i.wbcode if $sample, r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"



*g) Using average country use after cleaning industry FE

    xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invxINVPAY i.wbcode if $sample, r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"

*h) Using Payables to Material Costs

    xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invmatxInvPayMatmax i.wbcode if $sample, r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"

*i) Using Backward Linkages

    xi: areg  corr  lognestab1 lognestab2 share1 share2 BackwdPayCCxInvPaymax i.wbcode if $sample, r abs(ind_ij)
    eststo
    estadd local hasindpair "Yes"
    estadd local hascty "Yes"
    estadd local hasn "Yes"
    estadd local hasshare "Yes"

    esttab using Table5_`suffix'.csv, r2 replace b(3) se(3) star(* 0.1 ** 0.05 *** 0.001) drop(_Iwbcode* _Iind*)  /*
*/ scalars("hasindpair Industry pair FE" "hascty Country FE") nocons label mtitles( "High Quality Sample"  "Dropping Transition Economies" "Dropping Extreme Trade Credit" "Dropping Extreme Distances" "Robust Estimation" "Correlation of IIP" "Using HP Filter" "Transformed Correlation" "Robust Correlation" "Using country level information" "Using UK input-output data" "Using data from Amadeus" "Controlling for Stock Market Cap." "Country Usage FE" "Using Payables to Material Costs" "Using IO Backward Linkages")

eststo clear
*exit

*Other dimensions of similarity
*=======================================

*(1) Buy-sell distance?


xi: areg  corr  lognestab1 lognestab2 share1 share2  DemPayCC_invx`InvPayturn' buyx`InvPayturn' sellx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"


*(2)External dependence, liquidity needs, capital intensity

xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' distance_exf80xlogpvtc8000 distinvsaxlogpvtc8000 distancecapempxlogkapw8099 i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"


*(3)Complexity-durability?


xi: areg  corr  lognestab1 lognestab2 share1 share2 distanceginixsdgth_rgdpl  DemPayCC_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"

*(7)-(8)Testing for the potential impact of non iid shocks

xi: areg  corr  lognestab1 lognestab2 share1 share2 DemVar DemPayCC_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"


xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invxsdgth_rgdpl DemPayCC_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"

esttab using Table6_`suffix'.csv, r2 replace b(3) se(3) star(* 0.1 ** 0.05 *** 0.001) drop(_Iwbcode* lognestab1 lognestab2 share1 share2) /*
*/ scalars("hasn Number of establishments both industries" "hasshare Share of total manufacturing VA both industries" "hasindpair Industry pair FE" "hascty Country FE") nocons label nomtitles

eststo clear


*==========================================
*Alternative explanations
*==========================================

* (1) Is it overall development?

 xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' DemPayCC_invxloggdp8000 i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"


* (2) Adding volatility

xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' DemPayCC_invxloggdp8000 DemPayCC_invxsdgth_rgdpl8000 i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"

*(3) Adding Financial Development

xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn'  DemPayCC_invx`InvPayturn'xlpvtc i.wbcode if $sample, r abs(ind_ij)
eststo 
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"

*(4) Adding the triple interaction with STD

xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn'  DemPayCC_invx`InvPayturn'x`Stdbtpay' i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"

*(5) Considering effect of openness

xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_invx`InvPayturn' DemPayCC_invxlogopenwdi8000 i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"


*(6) Disentangling first order and higher order effects

xi: areg  corr  lognestab1 lognestab2 share1 share2 BPay_invx`InvPayturn' DemPayCC_invx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"

*(7)Disentangling contribution of average use and relative use


xi: areg  corr  lognestab1 lognestab2 share1 share2 DemPayCC_diffx`InvPayturn' DemPayCC_testx`InvPayturn' i.wbcode if $sample, r abs(ind_ij)
eststo
estadd local hasindpair "Yes"
estadd local hascty "Yes"
estadd local hasn "Yes"
estadd local hasshare "Yes"

esttab using Table7_`suffix'.csv, r2 replace b(3) se(3) star(* 0.1 ** 0.05 *** 0.001) drop(_Iwbcode* lognestab1 lognestab2 share1 share2) /*
*/ scalars("hasn Number of establishments both industries" "hasshare Share of total manufacturing VA both industries" "hasindpair Industry pair FE" "hascty Country FE") nocons label nomtitles

eststo clear


capture log close
