// input file esee_all.dta contains the variables listed below for the years 1990 to 2010, and is in panel format (ordinal is the firm identifier provided in ESEE, year was created)

use "esee_all", clear

// variables used from ESEE:
keep ordinal year naceclio pertot intfa ventas vexpor piei pieo piet pim pimi pit cim ///
	coint aemp idsit tecova rimva inm vpv vpcoint ///
	dlecva dlrva dcecva faecp ofsccp fpva dlecva dlrva dcecva faecp ofsccp dleccm dlrcm gpv gtid ///
	persoc npxnin invex pcaext

rename ordinal firmid
label var firmid "Firm ID"
label var year "Year"
gen crisis=(year>=2008)
replace crisis=. if year<2000
label var crisis "Dummy if after crisis (year>=2008)"
gen ind=naceclio
label var ind "NACECLIO industry"
rename ventas sales
gen lny=ln(sales)
label var lny "ln(sales)"
gen size=ln(sales)
label var size "ln(sales)"
gen lnexpfir=ln(vexpor)
label var lnexpfir "ln(exports)"
gen exp1=(vexpor>0)
label var exp1 "Export dummy"
label var pcaext "Percentage foreign ownership"

//investment variables
label var piei "Investment IT, % of total inv"
label var pieo "Investment buildings, % of total inv"
label var piet "Investment vehicles, % of total inv"
label var pim "Investment furniture & office equipment (not IT), % of total inv"
label var pimi "Investment machinery, % of total inv"
label var pit "Investment land, % of total inv"
label var cim "Investment tangible fixed assets, EUR"
gen inv_it=piei*cim
label var inv_it "IT investment, EUR"
gen inv_bld=pieo*cim
label var inv_bld "Building investment, EUR"
gen inv_veh=piet*cim
label var inv_veh "Vehicle investment, EUR"
gen inv_fur=pim*cim
label var inv_fur "Furniture, office equipm inv, EUR"
gen inv_mach=pimi*cim
label var inv_mach "Machinery investment, EUR"
gen inv_land=pit*cim
label var inv_land "Land investment, EUR"

gen credit=dlecva+dlrva+dcecva+faecp+ofsccp 
gen assets=fpva+ dlecva+dlrva+dcecva+faecp+ofsccp
gen creditratio=credit/assets
label var creditratio "Credit in % of assets"
gen shortfiratio=dcecva/credit
label var shortfiratio "Short term credit with fin inst/total credit"
replace dleccm=. if dleccm==0
replace dlrcm=. if dlrcm==0
gen crcost=(dleccm*dlecva+dlrcm*dlrva)/(dlecva+dlrva)
label var crcost "credit cost, %"
label var gpv "Adv in % of sales"
gen adv=gpv*sales
label var adv "Advertising spending, EUR"
label var gtid "total R&D expenses"
gen rd=gtid
label var rd "R&D expenses EUR"
gen longratio=(dlecva+dlrva)/credit
label var longratio "Long term credit/total credit"


cap drop temp
by firmid: egen temp=mean(persoc) 
gen corpgrp=(temp>1) if  temp!=. //1 if belongs to foreign group in at least in one year
label var corpgrp "Belongs to corporate group"
cap drop temp
by firmid: egen temp=mean(npxnin)
gen forplans=(temp>0) if temp!=.
label var forplans "Has foreign non-industrial plants"
cap drop temp
recode invex (2=0)
by firmid: egen temp=mean(invex)
gen forshares=(temp>0) if temp!=.
label var forshares "Has foreign shareholdings"

xtset firmid year
bysort firmid: egen foundyr=min(aemp)
bysort firmid: egen foundyr_alt=max(aemp)
gen age=year-foundyr
label var age "Age"
replace age=. if age<0
cap drop temp
gen temp=year if idsit==2 //is year of exit
bysort firmid: egen exityr=max(temp)
drop temp
replace age=. if year>=exityr

xtset firmid year
bysort firmid (year): replace naceclio = naceclio[_n-1] if naceclio == .

// TFP estimation
rename coint mat
label var mat "intermediate consumption"
rename pertot empl
gen lnemp=ln(empl)
gen grcap=tecova+rimva+inm 
label var grcap "Gross capital (tangible=land, buildings, machinery... and intangible)"
gen inv=d.grcap
replace inv=grcap if age==0 & inv==.
replace inv=grcap if year==foundyr_alt & inv==.
gen lninv=ln(inv)
gen cap=intfa 
label var cap "Total net tangible and intangible assets"
gen aa=grcap-cap
label var aa "Accum depr./reserves"
gen dep=d.aa
label var dep "Annual depreciation"
gen deprate=dep/cap
label var deprate "Annul rate of depreciation"
replace deprate=. if deprate>1 | deprate<0
bysort firmid: egen avgdeprate=mean(deprate)
replace dep=avgdeprate*cap if dep==.
replace cap=f.cap+f.dep-f.inv if cap==. 
gen lncap=ln(cap)
format %13.0g sales
by firmid: ipolate vpv year, gen(ivpv) epolate
replace vpv=ivpv if vpv==.
drop ivpv
by firmid: ipolate vpcoint year, gen(ivpcoint) epolate
replace vpcoint=ivpcoint if vpcoint==.
drop ivpcoint
bysort firmid: egen fstyr=min(year) if idsit==1
bysort firmid: egen lstyr=max(year) if idsit==1
gen salesr=1/(1+vpv/100)
gen matr=1/(1+vpcoint/100)
foreach var in sales mat {
sort firmid year
gen `var'qu=`var' if year==fstyr //don't discount for the first year
replace `var'qu=`var'*`var'r if year==fstyr+1 //discount to first year
replace `var'qu=`var'*`var'r*l.`var'r if year==fstyr+2
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r if year==fstyr+3
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r if year==fstyr+4
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r if year==fstyr+5
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r if year==fstyr+6
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r if year==fstyr+7
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r if year==fstyr+8
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r if year==fstyr+9
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r if year==fstyr+10
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r*l10.`var'r if year==fstyr+11
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r*l10.`var'r*l11.`var'r if year==fstyr+12
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r*l10.`var'r*l11.`var'r*l12.`var'r if year==fstyr+13
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r*l10.`var'r*l11.`var'r*l12.`var'r*l13.`var'r if year==fstyr+14
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r*l10.`var'r*l11.`var'r*l12.`var'r*l13.`var'r*l14.`var'r if year==fstyr+15
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r*l10.`var'r*l11.`var'r*l12.`var'r*l13.`var'r*l14.`var'r*l15.`var'r if year==fstyr+16
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r*l10.`var'r*l11.`var'r*l12.`var'r*l13.`var'r*l14.`var'r*l15.`var'r*l16.`var'r if year==fstyr+17
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r*l10.`var'r*l11.`var'r*l12.`var'r*l13.`var'r*l14.`var'r*l15.`var'r*l16.`var'r*l17.`var'r if year==fstyr+18
replace `var'qu=`var'*`var'r*l.`var'r*l2.`var'r*l3.`var'r*l4.`var'r*l5.`var'r*l6.`var'r*l7.`var'r*l8.`var'r*l9.`var'r*l10.`var'r*l11.`var'r*l12.`var'r*l13.`var'r*l14.`var'r*l15.`var'r*l16.`var'r*l17.`var'r*l18.`var'r if year==fstyr+19
format %13.0g `var'qu
}
gen lnyqu=ln(salesqu)
gen lnmatqu=ln(matqu)
levpet lnyqu, free(lnemp) proxy(lnmatqu) capital(lncap) revenue i(firmid) t(year)
predict tfp, omega
gen prod=ln(tfp)
label var prod "ln(TFP)"
compress
xtset firmid year

// industry value added in Spain, from Spanish statistical office
merge m:1 naceclio year using "spaintrade.dta", keep(master match)
drop _merge
gen lnexpeu=ln(exportusdEU25)
label var lnexpeu "ln(industry exports to EU)"
gen lnexpw=ln(exportusdWLD)
label var lnexpw "ln(industry exports to World)"

//merges with STAN data, from OECD iLibrary
merge m:1 naceclio year using "stanspain.dta", keep(master match)
drop _merge
gen lnvasp=ln(valu)
label var lnvasp "ln(industry output)"

//include industry for exiting firms
label def idsit 0 "no access" 1 "answer" 2 "exit, in liquidation, change to non-manuf activity, M&A" 3 "no collaboration"
label val idsit idsit
gen exit=.
replace exit=0 if idsit==1 | idsit==3
replace exit=1 if idsit==2
label var exit "Exit dummy"
xtset firmid year
forvalues nr=1/5 {
replace exit=f.exit if idsit==0
}
xtset firmid year
gen idsit2=(idsit==2)
bysort firmid: egen idsit2total=total(idsit2)
bysort firmid: gen idsit2sum=sum(idsit2)
replace exit=. if ((idsit2sum==1 & idsit!=2 ) |idsit2sum>1)
replace ind=l.ind if exit==1 
egen indyear=group(ind year)

drop if year<2003

save "eseecleaned.dta", replace
