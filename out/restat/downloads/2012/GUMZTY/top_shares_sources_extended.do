set more off 

*Oct 29 revision: This revision will separate the MI Process into 4 steps to let us run it piece by piece 
*April 8 revision: This revision allows us to run the GB2 process for tax-units
*April 15: cumulative shares doesn't work when there are percentiles with 0 share.  So using alternate method. 

clear 
set mem 1300m 
set matsize 500 
global data = "/rdcprojects/co1/co00524/data/data_out/" 
global tempdat = "/rdcprojects/co1/co00524/data/data_out/Temporary_data" 
global savepoint = "/rdcprojects/co1/co00524/jeffwork/pgb2_output/left_tr_gb2" 
global GB2estimates = "/rdcprojects/co1/co00524/jeffwork/MI_GB2/GB2_estimates" 
global output = "/rdcprojects/co1/co00524/jeffwork/MI_GB2/Release_output" 
sysdir set PERSONAL "/rdcprojects/co1/co00524/statacode/" 

************************ 
* Get data into shape 
************************ 
/*
insheet using "/rdcprojects/co1/co00524/data/data_out/int_hhmatch.txt", clear
gen groupq = 0
replace groupq = 1 if year<88 & hhtype==2
replace groupq = 1 if year>=88 & year<94 & htype==9
replace groupq = 1 if year>=94 & (hrhtype==9 | hrhtype==10)
rename hhseq h_id
replace year = year+1900
keep year h_id groupq
sort year h_id
compress
save $data/hhmatch_groupq.dta, replace

insheet using "/rdcprojects/co1/co00524/data/data_out/early_hh.txt", clear
gen groupq = 0
replace groupq = 1 if year<74 & hhtype==4
replace groupq = 1 if year>=74 & year<=75 & hhtype==2
rename hhseq h_id
replace year = year + 1900
keep year h_id groupq
sort year h_id
compress
append using $data/hhmatch_groupq.dta
save $data/hhmatch_groupq.dta, replace

*Create the early family file to merge in;
insheet using "/rdcprojects/co1/co00524/data/data_out/early_fam.txt", clear
replace year = year + 1900
rename fid sfid2
save "$data/early_fam.dta", replace

********
* FORMAT THE UNADJUSTED INTERNAL DATA FILE;
********

insheet using "/rdcprojects/co1/co00524/data/data_out/int_tax.txt", clear 
save "$data/int_ps_comparison_working_shares_all.dta", replace 
use "$data/int_ps_comparison_working_shares_all.dta", clear
sort year hhseq 
rename hhseq h_id 
gen military = 0 
replace military = 1 if pstat == 2 
replace h_id = h_id-300000 if year>=1988 
sort year h_id 
compress  
save $data/int_ps_comparison_working_shares.dta, replace 

*Join the current public weights for years after 2005 
joinby year h_id perid using "$data/public_weights_merge.dta", unmatched(master) 
drop _merge 
replace pwgt = wgt if year>=2005 & wgt!=. 
drop wgt 

*Drop group quarters and military 
joinby year h_id using "$data/hhmatch_groupq.dta", unmatched(master) 
sort year h_id 
by   year h_id: egen mil_hh=sum(military) 
replace mil_hh=1 if mil_hh>1 & mil_hh!=. 
keep if groupq==0 & mil_hh==0 
rename h_id hhseq 
compress 
save $data/int_ps_comparison_working_shares.dta, replace 

drop _merge
joinby year hhseq sfid2 using "$data/early_fam.dta", unmatched(master)
drop _merge
replace sfid = sfid2 if year<=1974

*Pull the family weights - which are the weight of the family reference person 
sort year hhseq sfid 
by year hhseq sfid: egen famhead = min(perid) 
by year hhseq sfid: gen famsize = _N 
gen temp = pwgt if perid==famhead 
by year hhseq sfid: egen fwgt = max(temp) 
drop temp   


rename sfid2 subfam

*Assign adult children to their own subfamily if not a reference person or spouse of family 
* note that spouse isn't present or else would be own subfamily with spouse already
* note that 1974-1987 people in primary family have no famrel, only hhrel so need a separate line to capture
* children/other relatives in the primary family
replace subfam = perid + 12 if age>=20 & ((famrel>=3 & famrel<=24) | (famrel>=27 & famrel<=31)) & year<=1973
replace subfam = perid + 12 if age>=20 & (hhrel==4 | hhrel==5) & famtype==0 & year>=1974 & year<=1987  
replace subfam = perid + 12 if age>=20 & (famrel==3 | famrel==4) & year>=1974 & year<=1987 
replace subfam = perid      if age>=20 & (famrel==3 | famrel==4) & year>=1988 

*Assign ever-married children to their own subfamily IF not reference person or spouse of family (i.e. are child or other 
*relative) ... note that spouse isn't present or else would be own subfamily with spouse already
replace subfam = perid + 12 if age<=19 & married>=2 & married<=7 & ((famrel>=3 & famrel<=24) | (famrel>=27 & famrel<=31))    & year<=1973
replace subfam = perid + 12 if age<=19 & married<8 & (hhrel==4 | hhrel==5)   & famtype==0 & year>=1974 & year<=1987  
replace subfam = perid + 12 if age<=19 & married<8 & (famrel==3 | famrel==4) & year<=1975 & year<=1987 
replace subfam = perid      if age<=19 & married<7 & (famrel==3 | famrel==4) & year>=1988 

*Calculate age of oldest subfamily member 
sort year hhseq subfam 
by year hhseq subfam: egen maxage = max(age) 

*Determine if anybody is ever-married in the subfamily 
gen temp = 0 
replace temp = 1 if (year<=1973 & married>=2) | (year>=1974 & year<=1987 & married<=7) | (year>=1988 & married<=6) 
by year hhseq subfam: egen anymarried = max(temp) 
drop temp 

/* 
* OPTION 1 
*Drop if there are no ever-married individuals or single individuals over 20 in the subfamily 
drop if anymarried==0 & maxage<=19 

*OPTION 2 (since can't keep income from under-19 year olds in option 1) 
*Drop if max age under 15, which is the minimum age to record income in the CPS 
drop if maxage<15 
*/ 

*OPTION 3 (split difference between option 1 and option 2): 
*Assign individuals in unmarried, under-19 headed subfamilies to the primary family in the household 
*In cases of no primary family, assign to family of oldest individual in household 
*Individuals under 15 who live alone are dropped.  Those 15 and older are kept as own subfamily 
sort year hhseq perid 
by year hhseq: egen maxhhage = max(age) 
replace subfam = 1 if anymarried==0 & maxage<=19 & maxhhage>19 
sort year hhseq subfam 
by year hhseq subfam: egen maxage2 = max(age) 

gen oldest = 1 if age==maxhhage 
by year hhseq: egen temp = sum(oldest) 
sort year hhseq oldest 
by year hhseq oldest: egen temp2 = min(perid) 
replace oldest = 0 if temp>1 & perid!=temp2 
gen temp3 = 0 
replace temp3 = subfam if oldest==1 
by year hhseq: egen oldestsubfam = max(temp3)   
replace subfam = oldestsubfam if anymarried==0 & maxage2<=19 & maxhhage>19 
drop temp temp2 temp3 

sort year hhseq subfam  
by year hhseq subfam: gen sfsize = _N 

*Adjust for the fact that I am breaking up families as originally weighted - so divide the weights to the new 
*subfamilies based on the size of their respective families 
replace fwgt = fwgt * sfsize/famsize if sfsize<=famsize  

*Drop if under 14 since can't have income 
drop if age<14 & iinc_tax==0 

gen subfamid = hhseq*100 + subfam 

sort year hhseq subfam 
by year hhseq subfam: egen finc = sum(iinc_tax) 
by year hhseq subfam: egen finc_tc = sum(idum_tax) 
by year hhseq subfam: egen fwag = sum(incwag) 
by year hhseq subfam: egen fse  = sum(incse) 
by year hhseq subfam: egen ffrm = sum(incfrm) 
by year hhseq subfam: egen fint = sum(incint) 
by year hhseq subfam: egen fdiv = sum(incdiv) 


replace finc_tc = 1 if finc_tc>=1 

replace finc = 1 if finc<=0 

*collapse to the subfamily 
collapse (mean) fwgt finc finc_tc fwag fse ffrm fint fdiv subfamid, by(year hhseq subfam) 

save "/rdcprojects/co1/co00524/data/data_out/int_PS_comparison_working_shares", replace 

**************************************************** 

********
* FORMAT THE INTERNAL MULTIPLE FILE;
********

insheet using "/rdcprojects/co1/co00524/data/data_out/mul_tax.txt", clear 
save "$data/mul_ps_comparison_working_shares.dta", replace 
sort year hhseq 
rename hhseq h_id 
gen military = 0 
replace military = 1 if pstat == 2 
replace h_id = h_id-300000 if year>=1988 
sort year h_id 
compress  
save $data/mul_ps_comparison_working_shares.dta, replace 


*rename variables to match current code
rename mulwag incwag
rename mulfrm incfrm
rename mulse  incse
rename mulint incint
rename muldiv incdiv
rename itax_mul iinc_tax

*Join the current public weights for years after 2005 
joinby year h_id perid using "$data/public_weights_merge.dta", unmatched(master) 
drop _merge 
replace pwgt = wgt if year>=2005 & wgt!=. 
drop wgt 

*Drop group quarters and military 
joinby year h_id using "$data/hhmatch_groupq.dta", unmatched(master) 
sort year h_id 
by   year h_id: egen mil_hh=sum(military) 
replace mil_hh=1 if mil_hh>1 & mil_hh!=. 
keep if groupq==0 & mil_hh==0 
rename h_id hhseq 
compress 
save $data/mul_ps_comparison_working_shares.dta, replace 

*Pull the family weights - which are the weight of the family reference person 
sort year hhseq sfid 
by year hhseq sfid: egen famhead = min(perid) 
by year hhseq sfid: gen famsize = _N 
gen temp = pwgt if perid==famhead 
by year hhseq sfid: egen fwgt = max(temp) 
drop temp   

*Place unrelated secondary individuals in their own family 
gen subfam = . 
replace subfam = perid + 6 if year<=1987 & famtype==1 
replace subfam = perid     if year>=1988 & famtype==5 

*Place nonfamily householders in their own family 
replace subfam = perid + 6 if year<=1987 & famtype==4 
replace subfam = perid     if year>=1988 & famtype==2 

*Assign primary family members to the primary family 
replace subfam = sfid if year<=1987 & famtype==0 
replace subfam = sfid if year>=1988 & famtype==1 

*Assign related/unrelated subfamily members to the correct subfamily 
replace subfam = sfid if year<=1987 & (famtype==2 | famtype==3) 
replace subfam = sfid if year>=1988 & (famtype==3 | famtype==4) 

*Assign adult children to their own subfamily if not a reference person or spouse of family 
replace subfam = perid + 6 if age>=20 & (hhrel==4 | hhrel==5) & famtype==0 & year<=1987  
replace subfam = perid + 6 if age>=20 & (famrel==3 | famrel==4) & year<=1987 
replace subfam = perid     if age>=20 & (famrel==3 | famrel==4) & year>=1988 

*Assign ever-married children to their own subfamily IF not reference person or spouse of family (i.e. are child or other relative) 
replace subfam = perid + 6 if age<=19 & married<8 & (hhrel==4 | hhrel==5)   & famtype==0 & year<=1987  
replace subfam = perid + 6 if age<=19 & married<8 & (famrel==3 | famrel==4) & year<=1987 
replace subfam = perid     if age<=19 & married<7 & (famrel==3 | famrel==4) & year>=1988 

*Calculate age of oldest subfamily member 
sort year hhseq subfam 
by year hhseq subfam: egen maxage = max(age) 

*Determine if anybody is ever-married in the subfamily 
gen temp = 0 
replace temp = 1 if (year<=1987 & married<=7) | (year>=1988 & married<=6) 
by year hhseq subfam: egen anymarried = max(temp) 
drop temp 

/* 
* OPTION 1 
*Drop if there are no ever-married individuals or single individuals over 20 in the subfamily 
drop if anymarried==0 & maxage<=19 

*OPTION 2 (since can't keep income from under-19 year olds in option 1) 
*Drop if max age under 15, which is the minimum age to record income in the CPS 
drop if maxage<15 
*/ 

*OPTION 3 (to try to split difference between option 1 and option 2): 
*Assign individuals in unmarried, under-19 headed subfamilies to the primary family in the household 
*In cases of no primary family, assign to family of oldest individual in household 
*Individuals under 15 who live alone are dropped.  Those 15 and older are kept as own subfamily 
sort year hhseq perid 
by year hhseq: egen maxhhage = max(age) 
replace subfam = 0 if year<=1987 & anymarried==0 & maxage<=19 & maxhhage>19 
replace subfam = 1 if year>=1988 & anymarried==0 & maxage<=19 & maxhhage>19 
sort year hhseq subfam 
by year hhseq subfam: egen maxage2 = max(age) 

gen oldest = 1 if age==maxhhage 
by year hhseq: egen temp = sum(oldest) 
sort year hhseq oldest 
by year hhseq oldest: egen temp2 = min(perid) 
replace oldest = 0 if temp>1 & perid!=temp2 
gen temp3 = 0 
replace temp3 = subfam if oldest==1 
by year hhseq: egen oldestsubfam = max(temp3)   
replace subfam = oldestsubfam if anymarried==0 & maxage2<=19 & maxhhage>19 
drop temp temp2 temp3 

sort year hhseq subfam  
by year hhseq subfam: gen sfsize = _N 

*Adjust for the fact that I am breaking up families as originally weighted - so divide the weights to the new 
*subfamilies based on the size of their respective families 
replace fwgt = fwgt * sfsize/famsize if sfsize<=famsize  

*Drop if under 14 since can't have income 
drop if age<14 & iinc_tax==0 

gen subfamid = hhseq*100 + subfam 

sort year hhseq subfam 
by year hhseq subfam: egen finc = sum(iinc_tax)  
by year hhseq subfam: egen fwag = sum(incwag) 
by year hhseq subfam: egen fse  = sum(incse) 
by year hhseq subfam: egen ffrm = sum(incfrm) 
by year hhseq subfam: egen fint = sum(incint) 
by year hhseq subfam: egen fdiv = sum(incdiv) 


replace finc = 1 if finc<=0 

*collapse to the subfamily 
collapse (mean) fwgt finc fwag fse ffrm fint fdiv subfamid, by(year hhseq subfam) 

save "/rdcprojects/co1/co00524/data/data_out/mul_PS_comparison_working_shares", replace 

*/
**************************************************** 

********
* FORMAT THE INTERNAL CTC FILE - NOTE this only goes back to 1975 currently;
********
/*
insheet using "/rdcprojects/co1/co00524/data/data_out/ctc_shares.txt", clear 
save "$data/ctc_ps_comparison_working_shares.dta", replace 
sort year hhseq 
rename hhseq h_id 
gen military = 0 
replace military = 1 if pstat == 2 
replace h_id = h_id-300000 if year>=1988 
sort year h_id 
compress  
save $data/ctc_ps_comparison_working_shares.dta, replace 

*rename variables to match current code
rename itax_ctc iinc_tax

*Join the current public weights for years after 2005 
joinby year h_id perid using "$data/public_weights_merge.dta", unmatched(master) 
drop _merge 
replace pwgt = wgt if year>=2005 & wgt!=. 
drop wgt 

*Drop group quarters and military 
joinby year h_id using "$data/hhmatch_groupq.dta", unmatched(master) 
sort year h_id 
by   year h_id: egen mil_hh=sum(military) 
replace mil_hh=1 if mil_hh>1 & mil_hh!=. 
keep if groupq==0 & mil_hh==0 
rename h_id hhseq 
compress 
save $data/ctc_ps_comparison_working_shares.dta, replace 

*Pull the family weights - which are the weight of the family reference person 
sort year hhseq sfid 
by year hhseq sfid: egen famhead = min(perid) 
by year hhseq sfid: gen famsize = _N 
gen temp = pwgt if perid==famhead 
by year hhseq sfid: egen fwgt = max(temp) 
drop temp   

*Place unrelated secondary individuals in their own family 
gen subfam = . 
replace subfam = perid + 6 if year<=1987 & famtype==1 
replace subfam = perid     if year>=1988 & famtype==5 

*Place nonfamily householders in their own family 
replace subfam = perid + 6 if year<=1987 & famtype==4 
replace subfam = perid     if year>=1988 & famtype==2 

*Assign primary family members to the primary family 
replace subfam = sfid if year<=1987 & famtype==0 
replace subfam = sfid if year>=1988 & famtype==1 

*Assign related/unrelated subfamily members to the correct subfamily 
replace subfam = sfid if year<=1987 & (famtype==2 | famtype==3) 
replace subfam = sfid if year>=1988 & (famtype==3 | famtype==4) 

*Assign adult children to their own subfamily if not a reference person or spouse of family 
replace subfam = perid + 6 if age>=20 & (hhrel==4 | hhrel==5) & famtype==0 & year<=1987  
replace subfam = perid + 6 if age>=20 & (famrel==3 | famrel==4) & year<=1987 
replace subfam = perid     if age>=20 & (famrel==3 | famrel==4) & year>=1988 

*Assign ever-married children to their own subfamily IF not reference person or spouse of family (i.e. are child or other relative) 
replace subfam = perid + 6 if age<=19 & married<8 & (hhrel==4 | hhrel==5)   & famtype==0 & year<=1987  
replace subfam = perid + 6 if age<=19 & married<8 & (famrel==3 | famrel==4) & year<=1987 
replace subfam = perid     if age<=19 & married<7 & (famrel==3 | famrel==4) & year>=1988 

*Calculate age of oldest subfamily member 
sort year hhseq subfam 
by year hhseq subfam: egen maxage = max(age) 

*Determine if anybody is ever-married in the subfamily 
gen temp = 0 
replace temp = 1 if (year<=1987 & married<=7) | (year>=1988 & married<=6) 
by year hhseq subfam: egen anymarried = max(temp) 
drop temp 

/* 
* OPTION 1 
*Drop if there are no ever-married individuals or single individuals over 20 in the subfamily 
drop if anymarried==0 & maxage<=19 

*OPTION 2 (since can't keep income from under-19 year olds in option 1) 
*Drop if max age under 15, which is the minimum age to record income in the CPS 
drop if maxage<15 
*/ 

*OPTION 3 (to try to split difference between option 1 and option 2): 
*Assign individuals in unmarried, under-19 headed subfamilies to the primary family in the household 
*In cases of no primary family, assign to family of oldest individual in household 
*Individuals under 15 who live alone are dropped.  Those 15 and older are kept as own subfamily 
sort year hhseq perid 
by year hhseq: egen maxhhage = max(age) 
replace subfam = 0 if year<=1987 & anymarried==0 & maxage<=19 & maxhhage>19 
replace subfam = 1 if year>=1988 & anymarried==0 & maxage<=19 & maxhhage>19 
sort year hhseq subfam 
by year hhseq subfam: egen maxage2 = max(age) 

gen oldest = 1 if age==maxhhage 
by year hhseq: egen temp = sum(oldest) 
sort year hhseq oldest 
by year hhseq oldest: egen temp2 = min(perid) 
replace oldest = 0 if temp>1 & perid!=temp2 
gen temp3 = 0 
replace temp3 = subfam if oldest==1 
by year hhseq: egen oldestsubfam = max(temp3)   
replace subfam = oldestsubfam if anymarried==0 & maxage2<=19 & maxhhage>19 
drop temp temp2 temp3 

sort year hhseq subfam  
by year hhseq subfam: gen sfsize = _N 

*Adjust for the fact that I am breaking up families as originally weighted - so divide the weights to the new 
*subfamilies based on the size of their respective families 
replace fwgt = fwgt * sfsize/famsize if sfsize<=famsize  

*Drop if under 14 since can't have income 
drop if age<14 & iinc_tax==0 

gen subfamid = hhseq*100 + subfam 

sort year hhseq subfam 
by year hhseq subfam: egen finc = sum(iinc_tax)  
by year hhseq subfam: egen fwag = sum(incwag) 
by year hhseq subfam: egen fse  = sum(incse) 
by year hhseq subfam: egen ffrm = sum(incfrm) 
by year hhseq subfam: egen fint = sum(incint) 
by year hhseq subfam: egen fdiv = sum(incdiv) 


replace finc = 1 if finc<=0 

*collapse to the subfamily 
collapse (mean) fwgt finc fwag fse ffrm fint fdiv subfamid, by(year hhseq subfam) 

save "/rdcprojects/co1/co00524/data/data_out/ctc_psmul_PS_comparison_working_shares", replace 

*/

**************************************************** 

*Now just generate the statistics.  Run this portion 3 times, commenting out the unused datasets; 

set more off 
*use "$data/int_PS_comparison_working_shares.dta", clear 
use "$data/mul_PS_comparison_working_shares.dta", clear
*use "$data/ctc_PS_comparison_working_shares.dta", clear

gen foth = finc - fwag - fse - ffrm - fint - fdiv

global rows = "1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007"
global cols = "wag se frm div int oth" 

matrix p90p95shares = J(41,6,.)
matrix p95p99shares = J(41,6,.)
matrix top1shares   = J(41,6,.)
matrix rownames p90p95shares = $rows
matrix rownames p95p99shares = $rows
matrix rownames top1shares = $rows
matrix colnames p90p95shares = $cols
matrix colnames p95p99shares = $cols
matrix colnames top1shares = $cols

matrix poppct = J(41,1,.)
matrix rownames poppct = $rows
matrix colnames poppct = top1

forvalues yr = 1968/2008 { 
   quietly {
   preserve 
      keep if year==`yr' & fwgt>0 & fwgt<. 
      local i = `yr'-1967
      _pctile finc [aw=fwgt], percentile(90, 95, 99)
         gen pct = .
         replace pct = 0 if  finc<=r(r1)
         replace pct = 90 if finc>r(r1) & finc<=r(r2)
         replace pct = 95 if finc>r(r2) & finc<=r(r3)
         replace pct = 99 if finc>r(r3)
      sum finc [aw=fwgt] if pct==90, meanonly
      local finc = r(mean)
      sum fwag [aw=fwgt] if pct==90, meanonly
      matrix p90p95shares[`i',1] = r(mean)/`finc'
      sum fse [aw=fwgt] if pct==90, meanonly
      matrix p90p95shares[`i',2] = r(mean)/`finc'
      sum ffrm [aw=fwgt] if pct==90, meanonly
      matrix p90p95shares[`i',3] = r(mean)/`finc'
      sum fdiv [aw=fwgt] if pct==90, meanonly
      matrix p90p95shares[`i',4] = r(mean)/`finc'
      sum fint [aw=fwgt] if pct==90, meanonly
      matrix p90p95shares[`i',5] = r(mean)/`finc'
      sum foth [aw=fwgt] if pct==90, meanonly
      matrix p90p95shares[`i',6] = r(mean)/`finc'

      sum finc [aw=fwgt] if pct==95, meanonly
      local finc = r(mean)
      sum fwag [aw=fwgt] if pct==95, meanonly
      matrix p95p99shares[`i',1] = r(mean)/`finc'
      sum fse [aw=fwgt] if  pct==95, meanonly
      matrix p95p99shares[`i',2] = r(mean)/`finc'
      sum ffrm [aw=fwgt] if pct==95, meanonly
      matrix p95p99shares[`i',3] = r(mean)/`finc'
      sum fdiv [aw=fwgt] if pct==95, meanonly
      matrix p95p99shares[`i',4] = r(mean)/`finc'
      sum fint [aw=fwgt] if pct==95, meanonly
      matrix p95p99shares[`i',5] = r(mean)/`finc'
      sum foth [aw=fwgt] if pct==95, meanonly
      matrix p95p99shares[`i',6] = r(mean)/`finc'
         
      sum finc [aw=fwgt] if pct==99, meanonly
      local finc = r(mean)
      sum fwag [aw=fwgt] if pct==99, meanonly
      matrix top1shares[`i',1] = r(mean)/`finc'
      sum fse [aw=fwgt] if  pct==99, meanonly
      matrix top1shares[`i',2] = r(mean)/`finc'
      sum ffrm [aw=fwgt] if pct==99, meanonly
      matrix top1shares[`i',3] = r(mean)/`finc'
      sum fdiv [aw=fwgt] if pct==99, meanonly
      matrix top1shares[`i',4] = r(mean)/`finc'
      sum fint [aw=fwgt] if pct==99, meanonly
      matrix top1shares[`i',5] = r(mean)/`finc'
      sum foth [aw=fwgt] if pct==99, meanonly
      matrix top1shares[`i',6] = r(mean)/`finc'
      
      count
      local count = r(N)
      count if pct==99
      matrix poppct[`i',1] = r(N)/`count'
   restore
   noi disp in red "." _cont
   }
}

matrix list p90p95shares
matrix list p95p99shares
matrix list top1shares
matrix list poppct    
    
