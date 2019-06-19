clear
clear matrix
set more off
set mem 5000m 
set matsize 500 
capture log close
log using /ssb/ovibos/a1/swp/kav/wk24/allreforms/sumstat.log, replace


use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92_tempcost1.dta, clear
rename annuity_skatt askatt 
rename annuity_benefits abenefits 
rename annuity_disp_faminc  adisp_faminc 

rename annuity_disp_faminc_ext2 adisp_faminc_ext2 



*symmetric 3 month window. 

*87-reform: 1.05.1987. 
gen reform87=1 if fodtaar>=mdy(5,1,1987) & fodtaar<mdy(8,1,1987)
replace reform87=0 if fodtaar<mdy(5,1,1987)& fodtaar>=mdy(2,1,1987)
tab b_month if reform87==1
tab b_month if reform87==0

*88-reform: 1.juli
gen reform88=1 if fodtaar>=mdy(7,1,1988) & fodtaar<mdy(10,1,1988)
replace reform88=0 if fodtaar<mdy(7,1,1988) & fodtaar>=mdy(4,1,1988)

tab b_month if reform88==1
tab b_month if reform88==0

*89-reform: 1.april
gen reform89=1 if fodtaar>=mdy(4,1,1989) & fodtaar<mdy(7,1,1989)
replace reform89=0 if fodtaar<mdy(4,1,1989) & fodtaar>=mdy(1,1,1989)
tab b_month if reform89==1
tab b_month if reform89==0


*90-reform: 1.5.1990: 
gen reform90=1 if fodtaar>=mdy(5,1,1990) & fodtaar<mdy(8,1,1990)
replace reform90=0 if fodtaar< mdy(5,1,1990)  & fodtaar>=mdy(2,1,1990)

tab b_month if reform90==1
tab b_month if reform90==0

*91-reform: 1.7.1991: 
gen reform91=1 if  fodtaar>=mdy(7,1,1991) & fodtaar<mdy(10,1,1991)
replace reform91=0 if fodtaar<mdy(7,1,1991) & fodtaar>=mdy(4,1,1991)
tab b_month if reform91==1
tab b_month if reform91==0


*92-reform: 1.4.1992: 
gen reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(7,1,1992)
replace reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(1,1,1992)
tab b_month if reform92==1
tab b_month if reform92==0


*93 reform: 1.april
gen reform93=1 if fodtaar>=mdy(4,1,1993) & fodtaar<mdy(7,1,1993)
replace reform93=0 if fodtaar<mdy(4,1,1993) & fodtaar>=mdy(1,1,1993)






foreach t in 87 88 89 90 91 92  {
gen nreform`t'=1 if reform`t'==0
replace nreform`t'=0 if reform`t'==1
}




*unpaid and total leave in weeks/days instead of months
gen mluptot_wk=mluptot*4


*married year before, married 14 years after
gen marryb_14=1 if marcfyb==1 & marrchf14==1
replace marryb_14=0 if marcfyb==1 & marrchf14==0


*not married year before, married 14 years after
gen not_marryb_14=1 if marcfyb==0 & marrchf14==1
replace not_marryb_14=0 if marcfyb==0 & marrchf14==0


forvalues t=1987/1992 {
replace eligible=eligible`t' if b_year==`t'
}

forvalues t=87/92 {
clear matrix
foreach c in eligible {

estpost sum `c' if reform`t'!=.  
eststo `c'_`t' 
esttab `c'_`t'  using  "/ssb/ovibos/a1/swp/kav/wk24/allreforms/table/elig_`t'.tex", label cells("mean(fmt(2))" "sd(par fmt(2))")  nostar postfoot("\end{tabular}")  replace

}
}



gen mluptot_days=mluptot_wk*7
label var mluptot_wk "weeks of unpaid leave"
label var mluptot_days "days of unpaid leave"
gen divorce=1-marryb_14
label var divorce "divorce"

gen boy=1 if kjonn==1
replace boy=0 if kjonn==2

forvalues t=87/92 {
clear matrix

preserve 
keep if reform`t'!=. & eligible==1

eststo: quietly estpost summarize mageb fageb  meduyb feduyb marcfyb boy dropout_20 skraver mlup_tot_days memp2 memptot minctot femptot finctot disp_inc_tot ggemptot gginctot nchild14 not_marryb_14 divorce askatt abenefits cost_direct 
esttab using  "/ssb/ovibos/a1/swp/kav/wk24/allreforms/table/sumstat_`t'.tex", label cells("mean(fmt(2))" "sd(par fmt(2))")  nostar postfoot("\end{tabular}")  replace

restore



}

log close




 









