/*Modified to run on one folder*/

clear
set mem 300m
use comprehensive_2006.dta

*Keeping only manufactures

keep if sector == 1

*Building the measures

*Checking positive numbers for the main items

*Sales:

forv i=1/3 {
		replace c274a`i'y = . if c274a`i'y<0
		replace c281o`i'y = . if c281o`i'y<0
		replace c274b`i'y = . if c274b`i'y<0
		replace c274e`i'y = . if c274e`i'y<0
		replace c274j`i'y = . if c274j`i'y<0
		replace c282d`i'y = . if c282d`i'y<0
		replace c282c`i'y = . if c282c`i'y<0
}

gen laborcost1    = c274j1y
gen laborcost2    = c274j2y
gen laborcost3    = c274j3y

gen matcost1   	= c274b1y
gen matcost2   	= c274b2y
gen matcost3   	= c274b3y

gen matpur1   	= c274d1y
gen matpur2   	= c274d2y
gen matpur3   	= c274d3y

gen encost1       = c274e1y
gen encost2       = c274e2y
gen encost3       = c274e3y

gen totcomp1    = c262a3/1000 /*Need to put it in thousands*/

gen sales1 = c274a1y
gen sales2 = c274a2y
gen sales3 = c274a3y

replace laborcost2 = . if laborcost1==. & totcomp1~=.
replace laborcost3 = . if laborcost1==. & totcomp1~=.
replace laborcost1 = totcomp1 if laborcost1==. & totcomp1~=.

gen istotcomp  = laborcost1==totcomp1 & laborcost1~=.

replace matcost2 = matpur2 if matcost1==. & matpur1~=.
replace matcost3 = matpur3 if matcost1==. & matpur1~=.
gen ismatpur = matcost1==. & matpur1~=.
replace matcost1  = matpur1 if matcost1==. & matpur1~=.


gen recturn1_1 =   sales1/(0.5*( c281o1y+ c281o2y))

gen recturn1_2 =   sales2/(0.5*( c281o2y+ c281o3y))

egen Recturn1 = rmean(recturn1_1 recturn1_2)

gen recturn2_1 =   sales1/c281o1y

gen recturn2_2 =   sales2/c281o2y

gen recturn2_3 =   sales3/c281o3y

egen Recturn3 = rmean(recturn2_1 recturn2_2 recturn2_3)

gen cgs1y = matcost1 + laborcost1 + encost1
gen cgs2y = matcost2+ laborcost2 + encost2
gen cgs3y = matcost3 + laborcost3 + encost3


//Added 10-17-08

gen  mcost2cgs1y = matcost1/cgs1y

gen mcost2cgs2y = matcost2/cgs2y

gen mcost2cgs3y = matcost3/cgs3y

gen payturn_mat1 = matcost1/(0.5*( c282d1y+ c282d2y))

gen payturn_mat2 = matcost2/(0.5*( c282d2y+ c282d3y))

gen payturn1_1 = cgs1y/(0.5*( c282d1y+ c282d2y))

gen payturn1_2 = cgs2y/(0.5*( c282d2y+ c282d3y))

//Added 12-28-07

gen invpayturn1_1 = 1/payturn1_1

gen invpayturn1_2 = 1/payturn1_2

//Added 10-17-08

gen invpayturn_mat1 = 1/payturn_mat1

gen invpayturn_mat2 = 1/payturn_mat2


gen payturn2_1 = cgs1y/c282d1y

gen payturn2_2 = cgs2y/c282d2y

gen payturn2_3 = cgs3y/c282d3y


egen Payturn1 = rmean(payturn1_1 payturn1_2)

egen Payturn2 = rmean(payturn2_1 payturn2_2 payturn2_3)

egen InvPayturn1 = rmean(invpayturn1_1 invpayturn1_2)  //12/28/07

egen Payturn_mat = rmean(payturn_mat1 payturn_mat2)

egen InvPayturn_mat = rmean(invpayturn_mat1 invpayturn_mat2)

egen Mcost2cgs = rmean(mcost2cgs1y mcost2cgs2y mcost2cgs3y)


gen stdpay_1 =  c282c1y/c282d1y

gen stdpay_2 =  c282c2y/c282d2y

gen stdpay_3 =  c282c3y/c282d3y

egen Stdbtpay = rmean(stdpay_1 stdpay_2 stdpay_3)

rename c_abbr wbcode

collapse (p50) Recturn* Payturn* InvPayturn* Stdbtpay Mcost (count) nrec1 = Recturn1 nrec3 = Recturn3 npay1 = Payturn1 npay2 = Payturn2 npaymat = Payturn_mat ninvpay1 = InvPayturn1 ninvpaymat = InvPayturn_mat nstd= Stdbtpay nmcost2cgs=Mcost2cgs (sum) istotcomp ismatpur, by(wbcode income)

// Renaming the variables (12/28/07)

rename Recturn1 Rec1_ica
rename Recturn3 Rec3_ica
rename Payturn1 Pay1_ica
rename Payturn2 Pay2_ica
rename InvPayturn1 InvPay_ica
rename Stdbtpay Std_ica
rename Payturn_mat Paymat_ica
rename InvPayturn_mat InvPaymat_ica
rename Mcost2cgs Mcost2cgs_ica

rename nrec1 nrec1ICA
rename nrec3 nrec3ICA
rename npay1 npay1ICA
rename npay2 npay2ICA
rename ninvpay1 ninvpayICA
rename nstd nstdICA
rename npaymat npaymatICA
rename ninvpaymat ninvpaymatICA


label var Rec1_ica      "Receivables Turnover from ICA (version 1)"
label var Rec3_ica      "Receivables Turnover from ICA (version 3)"

label var Pay1_ica       "Payables Turnover from ICA (version 1)"
label var Pay2_ica       "Payables Turnover from ICA (version 2)"
label var InvPay_ica    "Inverse Payables Turnover from ICA (version 1)"
label var Paymat_ica    "Payables turnover from ICA (material cost version1)"
label var InvPaymat_ica    "Inverse Payables turnover from ICA (material cost version1)"
label var Mcost2cgs_ica "Ratio of material cost (estimate) to cost of goods sold from ica"


label var Std_ica           "Stdbtpay from ICA"

label var nrec1ICA        "Number of manuf firms with data for rec1 in ICA"
label var nrec3ICA         "Number of manuf firms with data for rec3 in ICA"

label var npay1ICA        "Number of manuf firms with data for pay1 in ICA"
label var npay2ICA         "Number of manuf firms with data for pay2 in ICA"
label var ninvpayICA      "Number of manuf firms with data for invpay1 in ICA"
label var ninvpaymatICA      "Number of manuf firms with data for invpaymat in ICA"
label var npaymatICA      "Number of manuf firms with data for ipaymat in ICA"


label var nstdICA           "Number of manuf firms with data for std in ICA"

drop if wbcode==""
save Trade_credit_use_by_country_ICA_2006, replace
