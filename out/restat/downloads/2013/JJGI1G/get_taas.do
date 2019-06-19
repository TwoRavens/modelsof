
cap log close
clear
program drop _all

*cap do ${fmartorell_home}top_program

set mem 1000m

*log using ${fmartorell_home}remediation/programs/get_taas.log, replace
log using ${d1}log/get_taas.log, replace




/* ---------------------------------------------------------------------------------------------
*Stack all TAAS datasets from 191 to 197
----------------------------------------------------------------------------------------------*/

forvalues y=191/200 {
 foreach admin in fal spr sum ret {
  disp "`y' `admin'"
  cap confirm file "${fmartorell_home}from_cheel/data/taas`y'_x_`admin'.dta"  /* confirm that the datset exists */
  if _rc==0 {
   use "${fmartorell_home}from_cheel/data/taas`y'_x_`admin'.dta", clear
   keep if unique==1
   cap confirm var ethnic
   if _rc~=111 & `y'<193 {
     gen byte nethnic=1*(ethnic=="I")+2*(ethnic=="A")+3*(ethnic=="B")+4*(ethnic=="H")+5*(ethnic=="W")
     replace nethnic=. if nethnic==0 /* if ethnic is not I A B H W, set it to missing */
     drop ethnic
     rename nethnic ethnic
    }
   else if _rc~=111 & `y'>192 {
     destring ethnic, force replace
   }

   
   gen nsex=1 if sex=="M"
   replace nsex=0 if sex=="F"
   drop sex
   rename nsex sex

   keep if ((mscode=="S" & rawmth>0) + (rscode=="S" & rawred>0))>0
   gen byte admin=1*("`admin'"=="fal")+2*("`admin'"=="spr")+3*("`admin'"=="sum")+4*("`admin'"=="ret")
   gen byte taasyear=`y'-192

   cap confirm var ethnic
   if (_rc==0) keep altpid sex  bthday ethnic rawmth rawred *scode admin taasyear
   else keep altpid sex  bthday /* ethnic */ rawmth rawred *scode admin taasyear
   qui compress

   if (`y'==191 & "`admin'"=="fal") {
	*save "${fmartorell_home}data/taas_with_score.dta", replace
	save "${d1}data/taas_with_score.dta", replace
   }
   else {
    *qui append using "${fmartorell_home}data/taas_with_score.dta"
	qui append using "${d1}data/taas_with_score.dta"
    *save "${fmartorell_home}data/taas_with_score.dta", replace
	save "${d1}data/taas_with_score.dta", replace
   }
  
  }  /* close if file exists condition */
   qui log close
   *qui log using ${fmartorell_home}remediation/programs/get_taas.log, append
   qui log using ${d1}log/get_taas.log, append
   
 } /* close admin loop */
} /* close year loop */






******
*First, assess validity of matching altpid sex
******
sort altpid  bthday
by altpid: gen num=_N
by altpid: gen sbthday=bthday[1]==bthday[_N]
sort altpid  ethnic
by altpid: gen sethnic=ethnic[1]==ethnic[_N] if ethnic[1]~=. & ethnic[_N]~=.
egen tag=tag(altpid ) if num>1
summ sethnic sbthday if tag==1

sort altpid taasyear admin
by altpid: keep if _n==1


drop sbthday sethnic tag
gen bmo=substr(bthday,1,2)
gen bda=substr(bthday,3,4)
gen byr=substr(bthday,5,6)

destring bmo-byr, force replace
replace byr=byr+1900 if byr<100

d
qui compress


*save "${fmartorell_home}data/taas_with_score.dta", replace
save "${d1}data/taas_with_score.dta", replace

log close






