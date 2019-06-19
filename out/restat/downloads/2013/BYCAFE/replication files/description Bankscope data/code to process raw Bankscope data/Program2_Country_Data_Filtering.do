
clear
set memory 300m
use Databestand_Banks2.dta, clear

set more off, permanently

**************************************************************

** Create country-specific files
** local vars "AD AE AM AR AT AU AZ BD BE BH BM BO BR BS BW CA CH CI CL CN CO CR CY CZ DE DK DO DZ EC EE ES FI FR GB GH GR HK HR HU ID IE IL IN IS IT JO JP KE KR KW KY KZ LB LI LK LT LU LV MA MC MD MK MO MT MU MX MY MZ NG NL NO NP NZ OM PA PE PH PK PL PT PY RO RU SA SE SG SI SK SN SV TH TR TT TW UA US UY VE VN ZA ZM"

**************************************************************


local vars "AD AE AM AR AT AU AZ BD BE BH BM BO BR BS BW CA CH CI CL CN CO CR CY CZ DE DK DO DZ EC EE ES FI FR GB GH GR HK HR HU ID IE IL IN IS IT JO JP KE KR KW KY KZ LB LI LK LT LU LV MA MC MD MK MO MT MU MX MY MZ NG NL NO NP NZ OM PA PE PH PK PL PT PY RO RU SA SE SG SI SK SN SV TH TR TT TW UA US UY VE VN ZA ZM"
foreach var of local vars {
	preserve
	keep if countrycode=="`var'"
	save Databestand`var'.dta, replace
 	restore
	}

capture matrix drop toto
capture matrix drop totm
capture matrix drop bo
capture matrix drop bm
matrix toto = (0,0,0,0,0,0,0,0,0,0,0,0)
matrix totm = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)


****************************************************

*************** Filter data

****************************************************


local vars "AD AE AM AR AT AU AZ BD BE BH BM BO BR BS BW CA CH CI CL CN CO CR CY CZ DE DK DO DZ EC EE ES FI FR GB GH GR HK HR HU ID IE IL IN IS IT JO JP KE KR KW KY KZ LB LI LK LT LU LV MA MC MD MK MO MT MU MX MY MZ NG NL NO NP NZ OM PA PE PH PK PL PT PY RO RU SA SE SG SI SK SN SV TH TR TT TW UA US UY VE VN ZA ZM"
foreach var of local vars {
	use Databestand`var'.dta, clear
        capture set more off, permanently

	* capture log using "Schoning 2 `var'.log", replace

	count
	scalar obs1=r(N)


	tab specialism
	drop if specialism=="Investment Bank/Securities House"
	count
	scalar obs2=r(N)
	
        drop if specialism=="Medium & Long Term Credit Bank"
	count
	scalar obs3=r(N)
	
        drop if specialism=="Real Estate / Mortgage Bank"
	count
	scalar obs4=r(N)
	
        drop if specialism=="Specialised Governmental Credit Inst."
	count
	scalar obs5=r(N)

	gen type="normaal"
	replace type="boven1h" if countrycode=="BR" | countrycode=="UY" | countrycode=="MX" | countrycode=="PY" | countrycode=="MZ" 
	replace type="boven1"  if countrycode=="BY" | countrycode=="CY" | countrycode=="RO" | countrycode=="TR" | countrycode=="ZW"  
	replace type="boven2"  if countrycode=="AM" | countrycode=="AR" | countrycode=="BG" | countrycode=="CO" | countrycode=="CR" 
	replace type="boven2"  if countrycode=="DO" | countrycode=="EC" | countrycode=="GH" | countrycode=="HN" | countrycode=="JM" 
	replace type="boven2"  if countrycode=="KE" | countrycode=="MW" | countrycode=="NG" | countrycode=="PE" | countrycode=="RU" 
	replace type="boven2"  if countrycode=="UA" | countrycode=="VE" | countrycode=="ZM" 
	replace type="boven3"  if countrycode=="BO" | countrycode=="GT" | countrycode=="HU" | countrycode=="ID" | countrycode=="MD" 
	replace type="boven3"  if countrycode=="NA" | countrycode=="PL" | countrycode=="SL" | countrycode=="SV" | countrycode=="TZ" 
	replace type="boven3"  if countrycode=="UG" | countrycode=="ZA" 

	gen cII_TA=II/TA
	sum cII_TA, detail
	sort cII_TA
	list banknr period cII_TA II TA if (cII_TA<=0 | (cII_TA>=0.2 & cII_TA<.)) & type=="normaal"
	list banknr period cII_TA II TA if (cII_TA<=0 | (cII_TA>=0.3 & cII_TA<.)) & type=="boven1" 
	list banknr period cII_TA II TA if (cII_TA<=0 | (cII_TA>=0.5 & cII_TA<.)) & type=="boven2" 
	drop if (cII_TA<=0 | (cII_TA>=0.2 & cII_TA<.)) & type=="normaal"
	drop if (cII_TA<=0 | (cII_TA>=0.8 & cII_TA<.)) & type=="boven1h"
	drop if (cII_TA<=0 | (cII_TA>=0.5 & cII_TA<.)) & type=="boven1"
	drop if (cII_TA<=0 | (cII_TA>=0.4 & cII_TA<.)) & type=="boven2"
	drop if (cII_TA<=0 | (cII_TA>=0.3 & cII_TA<.)) & type=="boven3"
	*drop if cII_TA==.

	count
	scalar obs6=r(N)

	gen cEQ_TA=Equity_TA/100
	sum cEQ_TA, detail
	sort cEQ_TA
	list banknr period cEQ_TA Equity TA if cEQ_TA<=0.01 | (cEQ_TA>=0.5 & cEQ_TA<.)
	drop if (cEQ_TA<=0.01 | (cEQ_TA>=0.5 & cEQ_TA<.)) & !(countrycode=="BW" | countrycode=="DZ")
	*drop if cEQ_TA==.
    	
	count
	scalar obs7=r(N)

        gen cIE_FUN=IE/total_funding
	sum cIE_FUN, detail
	sort cIE_FUN
	list banknr period cIE_FUN IE total_funding if (cIE_FUN<=0 | (cIE_FUN>=0.2 & cIE_FUN<.)) & type=="normaal"
	list banknr period cIE_FUN IE total_funding if (cIE_FUN<=0 | (cIE_FUN>=0.3 & cIE_FUN<.)) & type=="boven1"
	list banknr period cIE_FUN IE total_funding if (cIE_FUN<=0 | (cIE_FUN>=0.5 & cIE_FUN<.)) & type=="boven2"
	drop if (cIE_FUN<=0 | (cIE_FUN>=0.2 & cIE_FUN<.)) & type=="normaal"
	drop if (cIE_FUN<=0 | (cIE_FUN>=0.8 & cIE_FUN<.)) & type=="boven1h"
	drop if (cIE_FUN<=0 | (cIE_FUN>=0.5 & cIE_FUN<.)) & type=="boven1"
	drop if (cIE_FUN<=0 | (cIE_FUN>=0.4 & cIE_FUN<.)) & type=="boven2"
	drop if (cIE_FUN<=0 | (cIE_FUN>=0.3 & cIE_FUN<.)) & type=="boven3"
	*drop if cIE_FUN==.

	count
	scalar obs8=r(N)

      replace type="normaal"
	replace type="onder"  if countrycode=="AG" | countrycode=="AU" | countrycode=="AZ" | countrycode=="BS" | countrycode=="EC" 
	replace type="onder"  if countrycode=="IE" | countrycode=="LU" | countrycode=="MU" | countrycode=="PA" | countrycode=="SG" 
	replace type="boven1" if countrycode=="AR" | countrycode=="BS" | countrycode=="JM" | countrycode=="PE" | countrycode=="UG" 
	replace type="boven1" if countrycode=="ZM" | countrycode=="MZ" 
	replace type="boven2" if countrycode=="AM" | countrycode=="AZ" | countrycode=="BO" | countrycode=="BR" | countrycode=="BW" 
	replace type="boven2" if countrycode=="BY" | countrycode=="CH" | countrycode=="CI" | countrycode=="CM" | countrycode=="CO" 
	replace type="boven2" if countrycode=="CR" | countrycode=="CS" | countrycode=="CY" | countrycode=="DK" | countrycode=="DO" 
	replace type="boven2" if countrycode=="EC" | countrycode=="EE" | countrycode=="FR" | countrycode=="GH" | countrycode=="GT" 
	replace type="boven2" if countrycode=="HN" | countrycode=="HR" | countrycode=="KE" | countrycode=="KZ" | countrycode=="LT" 
	replace type="boven2" if countrycode=="LV" | countrycode=="MD" | countrycode=="MK" | countrycode=="MW" | countrycode=="MX" 
	replace type="boven2" if countrycode=="NA" | countrycode=="NG" | countrycode=="PL" | countrycode=="PY" | countrycode=="RO" 
	replace type="boven2" if countrycode=="RU" | countrycode=="SD" | countrycode=="SL" | countrycode=="TR" | countrycode=="UA" 
	replace type="boven2" if countrycode=="UY" | countrycode=="VE" | countrycode=="ZA" 

	capture gen cPE_TA=PE/TA
	sum cPE_TA, detail
	sort cPE_TA
	list banknr period cPE_TA PE TA if (cPE_TA<=0.0001 | (cPE_TA>=0.05 & cPE_TA<.)) & type=="onder"
	list banknr period cPE_TA PE TA if (cPE_TA<=0.0005 | (cPE_TA>=0.05 & cPE_TA<.)) & type=="normaal"
	list banknr period cPE_TA PE TA if (cPE_TA<=0.0005 | (cPE_TA>= 0.1 & cPE_TA<.)) & type=="boven2"
	list banknr period cPE_TA PE TA if (cPE_TA<=0.0005 | (cPE_TA>= 0.2 & cPE_TA<.)) & type=="boven1"
	drop if (cPE_TA<=0.0001 | (cPE_TA>=0.05 & cPE_TA<.)) & type=="onder"
      drop if (cPE_TA<=0.0005 | (cPE_TA>=0.05 & cPE_TA<.)) & type=="normaal"
      drop if (cPE_TA<=0.0005 | (cPE_TA>= 0.2 & cPE_TA<.)) & type=="boven1"
      drop if (cPE_TA<=0.0005 | (cPE_TA>= 0.1 & cPE_TA<.)) & type=="boven2"
	*drop if cPE_TA==.

	count
	scalar obs9=r(N)


      replace type="normaal"
	replace type="onder"   if countrycode=="IE" | countrycode=="KY" | countrycode=="LU" | countrycode=="TN"

	replace type="boven1h" if countrycode=="AR" | countrycode=="BY" | countrycode=="BA" | countrycode=="EC" | countrycode=="MW" 
	replace type="boven1h" if countrycode=="PY" | countrycode=="TZ" | countrycode=="UG" | countrycode=="UY" | countrycode=="ZW" 

	replace type="boven1"  if countrycode=="AZ" | countrycode=="BG" | countrycode=="BR" | countrycode=="CO" | countrycode=="CS" 
	replace type="boven1"  if countrycode=="GH" | countrycode=="GT" | countrycode=="JM" | countrycode=="NG" | countrycode=="NI"
	replace type="boven1"  if countrycode=="PE" | countrycode=="RO" | countrycode=="RU" | countrycode=="UA" | countrycode=="MZ"  

	replace type="boven2"  if countrycode=="AM" | countrycode=="BO" | countrycode=="CI" | countrycode=="CL" | countrycode=="CM" 
	replace type="boven2"  if countrycode=="CR" | countrycode=="CZ" | countrycode=="DO" | countrycode=="EE" | countrycode=="GB" 
	replace type="boven2"  if countrycode=="HN" | countrycode=="HR" | countrycode=="HU" | countrycode=="KE" | countrycode=="KR" 
	replace type="boven2"  if countrycode=="KZ" | countrycode=="LT" | countrycode=="LV" | countrycode=="MD" | countrycode=="MK"
	replace type="boven2"  if countrycode=="MX" | countrycode=="NA" | countrycode=="PA" 
	replace type="boven2"  if countrycode=="PL" | countrycode=="SD" | countrycode=="SK" | countrycode=="SL" | countrycode=="SV"
	replace type="boven2"  if countrycode=="TR" | countrycode=="TT" | countrycode=="VE" | countrycode=="YE" | countrycode=="ZA" 
	replace type="boven2"  if countrycode=="ZM" | countrycode=="AG"
  
	capture gen cONIE_TA=ONIE/TA
	sum cONIE_TA, detail
	sort cONIE_TA
	list banknr period cONIE_TA ONIE TA if (cONIE_TA<=0.0001 | (cONIE_TA>=0.05 & cONIE_TA<.)) & type=="onder"
	list banknr period cONIE_TA ONIE TA if (cONIE_TA<=0.0005 | (cONIE_TA>=0.05 & cONIE_TA<.)) & type=="normaal"
	list banknr period cONIE_TA ONIE TA if (cONIE_TA<=0.0005 | (cONIE_TA>= 0.1 & cONIE_TA<.)) & type=="boven"
      drop if (cONIE_TA<=0.0001 | (cONIE_TA>=0.05 & cONIE_TA<.))  & type=="onder"
      drop if (cONIE_TA<=0.0005 | (cONIE_TA>=0.05 & cONIE_TA<.))  & type=="normaal"
      drop if (cONIE_TA<=0.0005 | (cONIE_TA>= 0.1 & cONIE_TA<.))  & type=="boven2"
      drop if (cONIE_TA<=0.0005 | (cONIE_TA>= 0.15 & cONIE_TA<.)) & type=="boven1"
      drop if (cONIE_TA<=0.0005 | (cONIE_TA>= 0.25 & cONIE_TA<.)) & type=="boven1h"
	*drop if cONIE_TA==.

	count
	scalar obs10=r(N)

	capture gen cDP_TA=Depositscustomers/TA
	sum cDP_TA, detail
	sort cDP_TA
	list banknr period cDP_TA Depositscustomers TA if cDP_TA<=0 | (cDP_TA>=0.98 & cDP_TA<.)
	drop if cDP_TA<=0 | (cDP_TA>=0.98 & cDP_TA<.)
	*drop if cDP_TA==.

	count
	scalar obs11=r(N)

	capture gen cLN_TA=loans/TA
	sum cLN_TA, detail
	sort cLN_TA
	list banknr period cLN_TA loans TA if cLN_TA<=0 | (cLN_TA>=1 & cLN_TA<.)
	drop if cLN_TA<=0 | (cLN_TA>=1 & cLN_TA<.)
	*drop if cLN_TA==.

	count
	scalar obs12=r(N)

	*tab specialism

	save Databestand`var'3.dta, replace

	matrix ao = (obs1,obs2,obs3,obs4,obs5,obs6,obs7,obs8,obs9,obs10,obs11,obs12)
   	
        matrix bo = toto
   	matrix toto = bo\ao

	*log close
	}


drop _all
svmat toto
drop in 1/1
save "schoning 101.dta",replace
outsheet using "schoning 101.csv", comma replace
clear


