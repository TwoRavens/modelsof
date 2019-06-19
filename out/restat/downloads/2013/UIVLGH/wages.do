
// ------------------------------------------------------
// Calculate relative wages and relative 
// productivity for all manufacturing, continuous exporters and continuous nonexporters.
// ------------------------------------------------------

clear all
set mem 1g
set more off
global work "E:/Dropbox/Work/input_quality"

global firstyear = "1996"
global lastyear = "2005"
global employment = "employment"
global thresh = 10		// Threshold value for being an exporter = 10.000 NOK

use $work/Data/merged7_mincer, clear
destring org_f, replace
tsset org_f aar, yearly

// Drop firms which are not matched with employee data.
drop if lnVA==. | lnK==. | timeverk==0 | employment==. | kltrinn2000_o==. | Dkjonn==. | w_hat2==.

// Drop firms outside manufacturing
gen nace2 = substr(nace,1,2)
destring nace2, replace
drop if nace2<=14 | nace2>=38

// Drop firms in the sectors we don't estimate TFP
drop if nace2==16 | nace2==19 | nace2==23 | nace2==30 | nace2==32 

// Use employee data for lnL instead or hours worked from cap. db.
replace lnL = log($employment)
gen qempl = log($employment) + w_hat2	// Employment adjusted for quality (by Mincer)

// Export dummy
replace D_ex = (verdi_eks>$thresh)


// ------------------------------------------------------
// Preliminaries
// ------------------------------------------------------

sort org_f aar
gen T98 = (aar==1997 | aar==1998)
gen T00 = (aar==1999 | aar==2000)
gen T02 = (aar==2001 | aar==2002)
gen T04 = (aar==2003 | aar==2004)
gen T06 = (aar==2005)

gen i = log(invest_const)
gen k = lnK
gen x_i3 = i^3
gen x_i2 = i^2
gen x_i2k = i^2*k
gen x_ik = i*k
gen x_k2 = k^2
gen x_k2i = i*k^2
gen x_k3 = k^3

tab aar, gen(Dyear)
forvalues y = 2(1)10 {
  gen x_D`y'k = Dyear`y'*k
}

forvalues y = 2(1)10 {
  gen x_D`y'i = Dyear`y'*i
}

gen x_Exi = D_ex*i
gen x_Exk = D_ex*k

global poly1 = "{b1}*i + {b2}*k + {b3}*x_i3 + {b4}*x_i2 + {b5}*x_i2k + {b6}*x_ik + {b7}*x_k2 + {b8}*x_k2i + {b9}*x_k3"
global poly2 = "{b10}*Dyear2 + {b11}*Dyear3 + {b12}*Dyear4 + {b13}*Dyear5 + {b14}*Dyear6 + {b15}*Dyear7 + {b16}*Dyear8 + {b17}*Dyear9 + {b18}*Dyear10"
global poly3 = "{b19}*x_D2k + {b20}*x_D3k + {b21}*x_D4k + {b22}*x_D5k + {b23}*x_D6k + {b24}*x_D7k + {b25}*x_D8k + {b26}*x_D9k + {b27}*x_D10k"
global poly4 = "{b28}*x_D2i + {b29}*x_D3i + {b30}*x_D4i + {b31}*x_D5i + {b32}*x_D6i + {b33}*x_D7i + {b34}*x_D8i + {b35}*x_D9i + {b36}*x_D10i"
global poly5 = "{b37}*D_ex + {b38}*x_Exi +{b39}*x_Exk"

global Q1 = "(1 + {male}*Dkjonn)"
global Q2 = "(1 + {ten1_2}*Df_tenure01_02 + {ten2_7}*Df_tenure02_07 + {ten7_}*Df_tenure7_)"
global Q3 = "(1 + {edu11_12}*Dedu11_12 + {edu13_14}*Dedu13_14 + {edu15_16}*Dedu15_16 + {edu17_}*Dedu17_)"
global Q4 = "(1 + {exp13_19}*Dexp13_19 + {exp20_25}*Dexp20_25 + {exp26_32}*Dexp26_32 + {exp33_}*Dexp33_)"

// -------------------------------------------
// All manufacturing
// -------------------------------------------
nl (lnw =  {b0} + log($Q1*$Q2*$Q3*$Q4)) 
matrix B = get(_b)
global Cmale = B[1,2]
global Cten1_2 = B[1,3]
global Cten2_7 = B[1,4]
global Cten7_ = B[1,5]
global Cedu11_12 = B[1,6]
global Cedu13_14 = B[1,7]
global Cedu15_16 = B[1,8]
global Cedu17_ = B[1,9]
global Cexp13_19 = B[1,10]
global Cexp20_25 = B[1,11]
global Cexp26_32 = B[1,12]
global Cexp33_ = B[1,13]

nl (lnVA =  {b0} + {bl}*log($employment*$Q1*$Q2*$Q3*$Q4) + $poly1 + $poly2 + $poly3 + $poly4 + $poly5)  if  i!=.

test _b[/male] = $Cmale
test _b[/ten1_2] = $Cten1_2
test _b[/ten2_7] = $Cten2_7
test _b[/ten7_] = $Cten7_
test _b[/edu11_12] = $Cedu11_12
test _b[/edu13_14] = $Cedu13_14
test _b[/edu15_16] = $Cedu15_16
test _b[/edu17_] = $Cedu17_
test _b[/exp13_19] = $Cexp13_19
test _b[/exp20_25] = $Cexp20_25
test _b[/exp26_32] = $Cexp26_32
test _b[/exp33_] = $Cexp33_

// -------------------------------------------
// Exporters
// -------------------------------------------

// Regress only on continuous exporters/non-exporters
egen tmp1 = total(D_ex), by(org_f)
egen tmp2 = count(org_f), by(org_f)
gen tmp3 = tmp1/tmp2
gen AllEx = (tmp3==1)
gen AllNonEx = tmp1==0
drop tmp?

nl (lnw =  {b0} + log($Q1*$Q2*$Q3*$Q4)) if AllEx == 1 
matrix B = get(_b)
global Cmale = B[1,2]
global Cten1_2 = B[1,3]
global Cten2_7 = B[1,4]
global Cten7_ = B[1,5]
global Cedu11_12 = B[1,6]
global Cedu13_14 = B[1,7]
global Cedu15_16 = B[1,8]
global Cedu17_ = B[1,9]
global Cexp13_19 = B[1,10]
global Cexp20_25 = B[1,11]
global Cexp26_32 = B[1,12]
global Cexp33_ = B[1,13]

nl (lnVA =  {b0} + {bl}*log($employment*$Q1*$Q2*$Q3*$Q4) + $poly1 + $poly2 + $poly3 + $poly4 + $poly5) if AllEx == 1 & i!=.

test _b[/male] = $Cmale
test _b[/ten1_2] = $Cten1_2
test _b[/ten2_7] = $Cten2_7
test _b[/ten7_] = $Cten7_
test _b[/edu11_12] = $Cedu11_12
test _b[/edu13_14] = $Cedu13_14
test _b[/edu15_16] = $Cedu15_16
test _b[/edu17_] = $Cedu17_
test _b[/exp13_19] = $Cexp13_19
test _b[/exp20_25] = $Cexp20_25
test _b[/exp26_32] = $Cexp26_32
test _b[/exp33_] = $Cexp33_

matrix BB = get(_b)
global Exprmale = BB[1,3]
global Exprten1_2 = BB[1,4]
global Exprten2_7 = BB[1,5]
global Exprten7_ = BB[1,6]
global Expredu11_12 = BB[1,7]
global Expredu13_14 = BB[1,8]
global Expredu15_16 = BB[1,9]
global Expredu17_ = BB[1,10]
global Exprexp13_19 = BB[1,11]
global Exprexp20_25 = BB[1,12]
global Exprexp26_32 = BB[1,13]
global Exprexp33_ = BB[1,14]

//
// Nonexporters
//

nl (lnw =  {b0} + log($Q1*$Q2*$Q3*$Q4)) if AllNonEx == 1
matrix B = get(_b)
global Cmale = B[1,2]
global Cten1_2 = B[1,3]
global Cten2_7 = B[1,4]
global Cten7_ = B[1,5]
global Cedu11_12 = B[1,6]
global Cedu13_14 = B[1,7]
global Cedu15_16 = B[1,8]
global Cedu17_ = B[1,9]
global Cexp13_19 = B[1,10]
global Cexp20_25 = B[1,11]
global Cexp26_32 = B[1,12]
global Cexp33_ = B[1,13]

nl (lnVA =  {b0} + {bl}*log($employment*$Q1*$Q2*$Q3*$Q4) + $poly1 + $poly2 + $poly3 + $poly4 + $poly5) if AllNonEx == 1 & i!=.

test _b[/male] = $Cmale
test _b[/ten1_2] = $Cten1_2
test _b[/ten2_7] = $Cten2_7
test _b[/ten7_] = $Cten7_
test _b[/edu11_12] = $Cedu11_12
test _b[/edu13_14] = $Cedu13_14
test _b[/edu15_16] = $Cedu15_16
test _b[/edu17_] = $Cedu17_
test _b[/exp13_19] = $Cexp13_19
test _b[/exp20_25] = $Cexp20_25
test _b[/exp26_32] = $Cexp26_32
test _b[/exp33_] = $Cexp33_

test _b[/male] = $Exprmale
test _b[/ten1_2] = $Exprten1_2
test _b[/ten2_7] = $Exprten2_7
test _b[/ten7_] = $Exprten7_
test _b[/edu11_12] = $Expredu11_12
test _b[/edu13_14] = $Expredu13_14
test _b[/edu15_16] = $Expredu15_16
test _b[/edu17_] = $Expredu17_
test _b[/exp13_19] = $Exprexp13_19
test _b[/exp20_25] = $Exprexp20_25
test _b[/exp26_32] = $Exprexp26_32
test _b[/exp33_] = $Exprexp33_


log close
