// This do file is to generate four final data sets that are used in our paper to produce tables and figures. 
// Please refer to the online appendix to see the detailed instructions on the steps to construct the samples.
// As the original customs data and firm-level production data are confidential, they are not released here. 
// Please check the "ReadMe" file for data sources too. 

version 13.1

clear all
set more off
set matsize 5500

// handling orginal customs data (Note: some commands are written in simplified Chinese due to the information contained in the original data)
set more off
local i=2001
while `i'<=2006 {
use cust`i'.imp.dta, clear
gen bb=regexm(shipment, "一般贸易")
gen bb1=regexm(company, "进出口")
gen bb2=regexm(company, "贸易")
gen bb3=regexm(company, "外贸")
gen bb4=regexm(company, "外经")
gen bb5=regexm(company, "经贸")
gen bb6=regexm(company, "工贸")
gen bb7=regexm(company, "科贸")
gen bbb=regexm(coun_aim, "中华人民共和国")
keep if bb==1
drop if bb1==1|bb2==1|bb3==1|bb4==1|bb5==1|bb6==1|bb7==1
drop if bbb==1
drop if coun_aim==""
drop if quant==.|quant==0
drop if value==.|value==0
gen HS6=floor(hs_id/100)
gen year=`i'
sort year HS6
merge m:1 year HS6 using HS96.dta
keep if _merge==3
drop _merge
drop HS6
rename HS96 HS6
egen value=sum(value_year), by(year company HS6 coun_aim)
egen quant=sum(quant_year), by(year company HS6 coun_aim)
keep year company HS6 coun_aim value quant
duplicates drop year company HS6 coun_aim, force
save cust`i'.imp.country.dta, replace
local i = `i' + 1
  }
insheet using tariff_1997.csv, clear // tariff data from WTO website
duplicates drop tl avdutyrate, force
gen HS6=floor(tl/100)
drop if avdutyrate==.
bysort HS6: egen duty=mean(avdutyrate/100)
keep HS6 duty
duplicates drop HS6, force
save tariff_1997.dta, replace

use tariff.MNF_applied_rate.dta, clear // MFN tariff data from WTO website
keep if year==2001|year==2002|year==2003|year==2004|year==2005|year==2006
gen HS6=floor(hs_id/100)
sort year HS6
merge m:1 year HS6 using HS96.dta
keep if _merge==3
drop _merge
drop HS6
rename HS96 HS6
bysort year HS6: egen duty_m=mean(duty)
drop duty hs_id
rename duty_m duty
duplicates drop year HS6, force
save tariff.MNF_applied_rate.HS6.dta, replace

use tariff.MNF_applied_rate.HS6.dta, clear
gen gap=5
tsset HS6 year
bysort HS6: gen duty_d=f5.duty-duty
keep year HS6 duty_d
sort year HS6
save tariff.MNF_applied_rate.HS6.d.dta,replace

set more off
use cust2001.imp.country.dta, clear
append using cust2002.imp.country.dta
append using cust2003.imp.country.dta
append using cust2004.imp.country.dta
append using cust2005.imp.country.dta
append using cust2006.imp.country.dta
bysort year company: gen N_imp=_N
egen value1=sum(value), by(year company HS6)
egen quant1=sum(quant), by(year company HS6)
drop value quant
rename value1 value
rename quant1 quant
keep year company HS6 value quant N_imp
duplicates drop year company HS6, force
bysort year company: gen N_imp_imp=_N
sort year HS6
merge m:1 year HS6 using tariff.MNF_applied_rate.HS6.d.dta
keep if _merge==3
drop _merge
gen duty_v=value*duty_d
egen duty_m=sum(duty_v),by(year company)
egen value_m=sum(value), by(year company)
egen duty_un=mean(duty_d), by(year company)
drop duty_d duty_v
gen duty_d=duty_m/value_m
duplicates drop year company, force
keep year company duty_d duty_un N_imp_imp N_imp
sort year company
save custom.d.imp.more.dta, replace

use cust2001.imp.country.dta, clear
append using cust2002.imp.country.dta
append using cust2003.imp.country.dta
append using cust2004.imp.country.dta
append using cust2005.imp.country.dta
append using cust2006.imp.country.dta
sort HS6
merge m:1 HS6 using BEC-HS96.dta
keep if _merge==3
drop _merge
keep if SNA=="Intermediate"
sort year HS6
merge m:1 year HS6 using tariff.MNF_applied_rate.HS6.d.dta
keep if _merge==3
drop _merge
gen duty_v=value*duty_d
egen duty_m=sum(duty_v),by(year company)
egen value_m=sum(value), by(year company)
gen duty_inter_d=duty_m/value_m
duplicates drop year company HS6, force
egen duty_inter_un=mean(duty_d), by(year company)
duplicates drop year company, force
keep year company duty_inter_d duty_inter_un
sort year company
merge 1:1 year company using custom.d.imp.more.dta
drop _merge
save custom.d.imp.more.dta, replace

use cust2001.imp.country.dta, clear
append using cust2002.imp.country.dta
append using cust2003.imp.country.dta
append using cust2004.imp.country.dta
append using cust2005.imp.country.dta
append using cust2006.imp.country.dta
keep company HS6
duplicates drop company HS6, force
sort company HS6
expand 2
sort company HS6
bysort company HS6: gen year=2000+_n
replace year=2006 if year==2002
sort year HS6
merge m:1 year HS6 using tariff.MNF_applied_rate.HS6.d.dta
keep if _merge==3
drop _merge
egen duty_exo_d=mean(duty_d),by(year company)
duplicates drop year company, force
keep year company duty_exo_d
sort year company
merge 1:1 year company using custom.d.imp.more.dta
drop _merge
save custom.d.imp.more.dta, replace

use cust2001.imp.country.dta, clear
append using cust2002.imp.country.dta
append using cust2003.imp.country.dta
append using cust2004.imp.country.dta
append using cust2005.imp.country.dta
append using cust2006.imp.country.dta
sort HS6
merge m:1 HS6 using tariff.1997.dta
keep if _merge==3
drop _merge
gen duty_v=value*duty
egen duty_m=sum(duty_v),by(year company)
egen value_m=sum(value), by(year company)
gen duty97=duty_m/value_m
duplicates drop year company, force
keep year company duty97
sort year company
merge 1:1 year company using custom.d.imp.more.dta
drop _merge
save custom.d.imp.more.dta, replace

use cust2001.imp.country.dta, clear
append using cust2002.imp.country.dta
append using cust2003.imp.country.dta
append using cust2004.imp.country.dta
append using cust2005.imp.country.dta
append using cust2006.imp.country.dta
sort year HS6
merge m:1 year HS6 using tariff.MNF_applied_rate.HS6.dta
keep if _merge==3
drop _merge
gen duty_v=value*duty
egen duty_m=sum(duty_v),by(year company)
egen value_m=sum(value), by(year company)
gen duty00=duty_m/value_m
duplicates drop year company, force
keep year company duty00
sort year company
merge 1:1 year company using custom.d.imp.more.dta
drop _merge
save C:\TFP\based_on_Cai\custom.d.imp.more.dta, replace
save custom.d.imp.more.dta, replace

set more off
  local i=2001
while `i'<=2006 {
use cust`i'.exp.dta, clear
gen bb=regexm(shipment, "一般贸易")
gen bb1=regexm(company, "进出口")
gen bb2=regexm(company, "贸易")
gen bb3=regexm(company, "外贸")
gen bb4=regexm(company, "外经")
gen bb5=regexm(company, "经贸")
gen bb6=regexm(company, "工贸")
gen bb7=regexm(company, "科贸")
drop if bb1==1|bb2==1|bb3==1|bb4==1|bb5==1|bb6==1|bb7==1
keep if bb==1
gen bbb=regexm(coun_aim, "中华人民共和国")
drop if bbb==1
drop if coun_aim==""
drop if quant==.|quant==0
drop if value==.|value==0
gen HS6=floor(hs_id/100)
gen year=`i'
sort year HS6
merge m:1 year HS6 using HS96.dta
keep if _merge==3
drop _merge
drop HS6
rename HS96 HS6
egen value=sum(value_year), by(year company HS6 coun_aim)
egen quant=sum(quant_year), by(year company HS6 coun_aim)
keep year company HS6 coun_aim value quant
duplicates drop year company HS6 coun_aim, force
save cust`i'.exp.country.dta, replace
local i = `i' + 1
  }
  
set more off
use cust2001.exp.country.dta, clear
append using cust2002.exp.country.dta
append using cust2003.exp.country.dta
append using cust2004.exp.country.dta
append using cust2005.exp.country.dta
append using cust2006.exp.country.dta
duplicates drop year company HS6 coun_aim, force
sort year HS6
merge m:1 year HS6 using OutputDefl2000-2006.HS.dta
keep if _merge==3
drop _merge
replace value=value/OutputDefl*100
sort year HS6
gen price=log(value/quant)
drop if price==.
*quality
*******************************************************
gen HS2=floor(HS6/10000)
sort HS2
merge m:1 HS2 using sigma.dta
keep if _merge==3
drop _merge
gen pq=log(quant)+sigma_m*price
egen pairdummy_ct=group(coun_aim year)
gen const=1
a2reg pq const, individual(pairdummy_ct) unit(HS6) resid(quality)
*****************************************************
drop sigma pq pairdummy_ct
gen sigma=5
gen pq=log(quant)+sigma*price
egen pairdummy_ct=group(coun_aim year)
a2reg pq const, individual(pairdummy_ct) unit(HS6) resid(wuquality)
*****************************************************
drop sigma pq pairdummy_ct
gen sigma=10
gen pq=log(quant)+sigma*price
egen pairdummy_ct=group(coun_aim year)
a2reg pq const, individual(pairdummy_ct) unit(HS6) resid(shquality)
**********************************************
drop sigma pq pairdummy_ct const
merge m:1 year HS6 using diff.HS.final.dta
keep if _merge==3
drop _merge
keep year company HS6 coun_aim diff value quant price quality wuquality shquality sigma_m
sort year company
save custom.dta, replace
*****************************************

use custom.dta, clear
merge m:1 year company using custom.d.imp.more.dta
keep if _merge==3
drop _merge
save C:\TFP\based_on_Cai\custom.d.dta, replace

clear all
cd "C:\TFP\based_on_Cai"
log using regression_CIC_data, text replace
set more off
set mem 2900m

use cie2000-2006.1.dta, clear
*drop if year==2000
*****************************************
replace TEL="" if TEL=="."
replace CRN="" if CRN=="."
replace FRDM=upper(FRDM)
*delete based on Cai and Liu
drop if TWC>TA
drop if FA>TA
drop if AABOFA>TA
drop if FRDM=="."
drop if TOC_M>"12"
drop if TOC_M<"01"
tostring year, replace
drop if TOC_Y>year
destring year, replace
sort year FRDM
bysort year FRDM: gen m=_N
drop if m>1
drop m
**********************************
gen TOC_yr=real(TOC_Y)
replace TOC_Y="" if TOC_yr<1600|TOC_yr>2006
destring TOC_Y, replace
gen age=year-TOC_Y
sort year INDTYPE
merge m:1 year INDTYPE using InputDefl2000-2006
keep if _merge==3
drop _merge
sort year INDTYPE
merge m:1 year INDTYPE using OutputDefl2000-2006
keep if _merge==3
drop _merge
********************************************
gen l=log(PERSENG)
gen k=log(FA/InputDefl*100)
gen y=log(VA/OutputDefl*100)
gen type=floor(INDTYPE/100)
sort type
merge m:1 type using cie.coefficient.dta
keep if _merge==3
drop _merge
gen TFP=y-bl_op*l-bk_op*k
drop if TFP==.
gen K_L=log(FA)-log(PERSENG)
gen wage=log(CWP/PERSENG)
***************************************************
keep year FRDM INDTYPE TFP K_L l wage age y k l SI
sort year FRDM
save variables.dta, replace

use variables.dta, clear
*************************************************
egen SI_s=sum(SI), by(year INDTYPE)
gen SI_r=SI/SI_s
gsort year INDTYPE -SI_r
bysort year INDTYPE: gen tt=_n
egen HHI=sum(SI_r^2) if tt<=50, by(year INDTYPE)
***************************************************
keep year INDTYPE HHI
duplicates drop year INDTYPE,force
sort year INDTYPE
merge 1:m year INDTYPE using variables.dta
keep if _merge==3
drop _merge
save variables.dta, replace

use cust2000-2006.exp.dta, clear 
drop if year==2000
gen bb=regexm(shipment, "一般贸易")
gen bb1=regexm(company, "进出口")
gen bb2=regexm(company, "贸易")
gen bb3=regexm(company, "外贸")
gen bb4=regexm(company, "外经")
gen bb5=regexm(company, "经贸")
gen bb6=regexm(company, "工贸")
gen bb7=regexm(company, "科贸")
drop if bb1==1|bb2==1|bb3==1|bb4==1|bb5==1|bb6==1|bb7==1
keep if bb==1
gen bbb=regexm(coun_aim, "中华人民共和国")
drop if bbb==1
drop if coun_aim==""
drop if quant==.|quant==0
drop if value==.|value==0
keep year company FRDM 
duplicates drop year company FRDM, force
bysort year FRDM: drop if _N>1
sort year FRDM
merge 1:1 year FRDM using variables.dta
keep if _merge==3
drop _merge
keep year FRDM company INDTYPE TFP K_L l wage age y k l HHI
sort year company
merge 1:m year company using custom.d.dta
keep if _merge==3
drop _merge
save Merge.Export.firm-product-country.d.dta, replace


use Merge.Export.firm-product-country.d.dta, clear
replace N_imp=log(N_imp)
encode FRDM, gen(t)
egen pairdummy=group(FRDM HS6 coun_aim)
tsset pairdummy year
bysort pairdummy: gen N_d=f5.N_imp-N_imp
bysort pairdummy: gen K_L_d=f5.K_L-K_L
bysort pairdummy: gen wage_d=f5.wage-wage
bysort pairdummy: gen l_d=f5.l-l
bysort pairdummy: gen TFP_d=f5.TFP-TFP
bysort pairdummy: gen price_d=f5.price-price
replace diff=1-diff
save Merge.Export.firm-product-country.final.d.dta, replace

use Merge.Export.firm-product-country.final.d.dta, clear
egen value1=sum(value), by(year FRDM HS6)
egen quant1=sum(quant), by(year FRDM HS6)
duplicates drop year FRDM HS6, force
drop price value quant
rename value1 value 
rename quant1 quant
gen price=log(value/quant)
drop TFP_d K_L_d l_d wage_d price_d pairdummy N_d
egen pairdummy=group(FRDM HS6)
sort pairdummy year
tsset pairdummy year
bysort pairdummy: gen N_d=f5.N_imp-N_imp
bysort pairdummy: gen TFP_d=f5.TFP-TFP
bysort pairdummy: gen K_L_d=f5.K_L-K_L 
bysort pairdummy: gen wage_d=f5.wage-wage
bysort pairdummy: gen l_d=f5.l-l
bysort pairdummy: gen price_d=f5.price-price 
bysort pairdummy: gen price_dd=price-l5.price
sort year FRDM
save Merge.Export.firm-product.final.d.dta, replace




**** generate final data set at firm-product-country level for the difference estimation of the whole customs sample  
use custom.dta, clear
merge m:1 year company using custom.d.imp.more.dta
keep if _merge==3
drop _merge
sort year HS6
merge m:1 year HS6 using tariff.dta
keep if _merge==3
drop _merge
replace diff=1-diff
gen HS2=floor(HS6/10000)
egen pairdummy=group(company HS6 coun_aim)
tsset pairdummy year
bysort pairdummy: gen N_d=f5.N_imp-N_imp
bysort pairdummy: gen price_d=f5.price-price
bysort pairdummy: gen quality_d=f5.msquality-msquality
bysort pairdummy: gen duty_in_d=f5.duty_in-duty_in
bysort pairdummy: gen duty_out_d=f5.duty_out-duty_out
keep year company HS6 coun_aim price_d price duty_d duty_un duty_exo_d duty_inter_d duty_in_d duty_out_d diff N_d
keep if year==2001|year==2006
save custom.final.fpc.dta, replace 

**** generate final data set at firm-product level for the difference estimation of the whole customs sample 
use custom.dta, clear
merge m:1 year company using custom.d.imp.more.dta
keep if _merge==3
drop _merge
replace diff=1-diff
gen HS2=floor(HS6/10000)
egen value1=sum(value), by(year company HS6)
egen quant1=sum(quant), by(year company HS6)
duplicates drop year company HS6, force
drop price value quant
rename value1 value 
rename quant1 quant
gen price=log(value/quant)
sort year HS6
merge m:1 year HS6 using tariff.dta
keep if _merge==3
drop _merge
egen pairdummy=group(company HS6)
replace N_imp=log(N_imp)
tsset pairdummy year
bysort pairdummy: gen price_d=f5.price-price
bysort pairdummy: gen N_d=f5.N_imp-N_imp
bysort pairdummy: gen duty_in_d=f5.duty_in-duty_in
bysort pairdummy: gen duty_out_d=f5.duty_out-duty_out
keep year company HS6 price_d price duty_d duty_un duty_exo_d duty_inter_d duty_in_d duty_out_d diff N_d
keep if year==2001|year==2006
save custom.final.fp.dta, replace

**** generate final data set at firm-product-country level for the difference estimation of the merged sample 
clear all
set more off
use Merge.Export.firm-product-country.final.d.dta, clear
keep year FRDM type duty00 duty_d
sort year FRDM duty_d duty00
drop if duty_d==.
duplicates drop year FRDM, force
bysort year type: gen num=_N-1
bysort year type: egen duty00m=sum(duty00)
bysort year type: egen duty_dm=sum(duty_d)
gen duty00s=(duty00m-duty00)/num
gen duty_ds=(duty_dm-duty_d)/num
keep year FRDM duty00s duty_ds
save other-firm.duty_d.dta, replace

use Merge.Export.firm-product-country.final.d.dta, clear
merge m:1 HS6 using quality.var.dta
keep if _merge==3
drop _merge
merge m:1 HS6 using VK_index.dta
drop if _merge==2
drop _merge
sort year HS6
merge m:1 year HS6 using tariff.dta
keep if _merge==3
drop _merge
merge m:1 year FRDM using other-firm.duty_d.dta
drop if _merge==2
drop _merge
gen wuprice_net=price-wuquality
gen shprice_net=price-shquality
gen price_net=price-quality
bysort year HS6 coun_aim: egen value_yc=sum(value)
gen share=value/value_yc
gen share_l=log(value/value_yc)
tsset pairdummy year
bysort pairdummy: gen share_d=f5.share-share
bysort pairdummy: gen price_net5_d=f5.wuprice_net-wuprice_net
bysort pairdummy: gen quality5_d=f5.wuquality-wuquality
bysort pairdummy: gen price_net10_d=f5.wuprice_net-wuprice_net
bysort pairdummy: gen quality10_d=f5.wuquality-wuquality
bysort pairdummy: gen price_net_d=f5.price_net-price_net
bysort pairdummy: gen quality_d=f5.quality-quality
bysort pairdummy: gen duty_in_d=f5.duty_in-duty_in
bysort pairdummy: gen duty_out_d=f5.duty_out-duty_out
keep year FRDM HS6 coun_aim price_d quality_d quality5_d quality10_d duty_d duty_un duty_exo_d duty_inter_d duty_in_d duty_out_d diff TFP_d K_L_d l_d wage_d N_d HHI ///
price_net_d price_net5_d price_net10_d duty97 duty00 share_d duty00s duty_ds y TFP K_L l wage N_imp price var GK_ind pairdummy value quant sigma_m
keep if year==2001|year==2006
save Merge.final.fpc.dta, replace


**** generate final data set at firm-product level for the difference estimation of the merged sample 
use Merge.Export.firm-product.final.d.dta, clear
merge m:1 HS6 using quality.var.dta
keep if _merge==3
drop _merge
merge m:1 HS6 using VK_index.dta
drop if _merge==2
drop _merge
sort year HS6
merge m:1 year HS6 using tariff.dta
keep if _merge==3
drop _merge
tsset pairdummy year
bysort pairdummy: gen duty_in_d=f5.duty_in-duty_in
bysort pairdummy: gen duty_out_d=f5.duty_out-duty_out
replace price_d=price_dd if price_dd!=.
egen value_ss=sum(value) if price_d!=., by(year FRDM)
gen share=value/value_ss
sort pairdummy year
tsset pairdummy year
bysort pairdummy: gen sharem=(f5.share+share)/2
bysort year FRDM: egen pi_d=sum(sharem*price_d)
sort FRDM year TFP_d
keep year FRDM HS6 coun_aim price_d duty_d duty_un duty_exo_d duty_inter_d duty_in_d duty_out_d diff TFP_d K_L_d l_d wage_d N_d HHI ///
duty97 duty00 TFP K_L l wage N_imp price pi_d var GK_ind pairdummy value quant
keep if year==2001|year==2006
save Merge.final.fp.dta, replace


**** protecting firm identity information before releasing final datasets:

use custom.final.fp.dta, clear
egen company1=group(company)
move company1 year
* generate a concordance between company name (in Chinese) and company1
duplicates drop company company1, force
keep company1 company
save cumstom.company.concordance.dta, replace

***
use custom.final.fp.dta, clear
merge m:1 company using cumstom.company.concordance.dta
drop _merge
drop company
ren company1 company
move company year
save custom.final.fp.dta, replace

***
use custom.final.fpc.dta, clear
merge m:1 company using cumstom.company.concordance.dta
drop _merge
drop company
ren company1 company
move company year
save custom.final.fpc.dta, replace

***

***
use Merge.final.fpc.dta, clear
egen FRDM1=group(FRDM)
move FRDM1 year
* generate a concordance between firm's corporate representative code and FRDM1
duplicates drop FRDM FRDM1, force
keep FRDM FRDM1
save FRDM.concordance.dta, replace

***
use Merge.final.fp.dta, clear
merge m:1 FRDM using FRDM.concordance.dta
drop _merge
drop FRDM
ren FRDM1 FRDM
move FRDM year
save Merge.final.fp.dta, replace

***
use Merge.final.fpc.dta, clear
merge m:1 FRDM using FRDM.concordance.dta
drop _merge
drop FRDM
ren FRDM1 FRDM
move FRDM year
save Merge.final.fpc.dta, replace


