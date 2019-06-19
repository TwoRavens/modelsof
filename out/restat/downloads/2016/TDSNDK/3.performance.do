
*run alternative model that computes forecast based on AR model
do arforecasting.do
*run alternative model that computes forecast based CME futures
do buildfutures.do


local msamacro="la pho seattle chi sandiego denver sanfran dc vegas"
foreach j in `msamacro' {
insheet using `j'foresale.txt,clear
rename v1 my
rename v2 cs
drop v3
sort my
save `j'foresale,replace

**need to run this code separately for adjusted list price index or simple list price index. current code is setup to pull in data associated with adjusted list price index
insheet using `j'fore.txt,clear

rename v1 list1
rename v2 list2
rename v3 list3
rename v4 list4
rename v5 list5
rename v6 list6
rename v7 list7
rename v8 list8
rename v9 list9
rename v10 list10
rename v11 list11
rename v12 list12
rename v13 list13
rename v14 list14
rename v15 reportinglag
rename v16 my
drop v17

sort my
merge my using `j'foresale,nokeep
tab _merge
drop _merge
sort my
gen city="`j'"
save tempdelete`j',replace
}

local msamacro="pho seattle chi sandiego denver sanfran dc vegas"
use tempdeletela,clear
foreach j in `msamacro' {
append using tempdelete`j'
rm tempdelete`j'.dta
}



gen seas=mod(m,12)
sort city reportinglag my

gen chngcs1=cs-cs[_n-2]
gen chngcs5=cs-cs[_n-3]
gen chngcs9=cs-cs[_n-4]
gen chngcs13=cs-cs[_n-5]
gen chngcs17=cs-cs[_n-6]
gen chngcs21=cs-cs[_n-7]
gen chngcs25=cs-cs[_n-8]
gen chngcs29=cs-cs[_n-9]
gen chngcs33=cs-cs[_n-10]
gen chngcs37=cs-cs[_n-11]
gen chngcs41=cs-cs[_n-12]
gen chngcs45=cs-cs[_n-13]

gen chnglist1=list1-list3
gen chnglist5=list1-list4
gen chnglist9=list1-list5
gen chnglist13=list1-list6
gen chnglist17=list1-list7
gen chnglist21=list1-list8
gen chnglist25=list1-list9
gen chnglist29=list1-list10
gen chnglist33=list1-list11
gen chnglist37=list1-list12
gen chnglist41=list1-list13
gen chnglist45=list1-list14




gen v1=0
gen v2=0
gen v3=0

*Make Table 7 and App Table 2

forvalues l=1/4{
gen rmselistt=(chnglist1-chngcs1)^2
gen rsqt=chngcs1^2
gen ok=( my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist1-chngcs1))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}


forvalues l=5/8{
gen rmselistt=(chnglist5-chngcs5)^2
gen rsqt=chngcs5^2
gen ok=( my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist5-chngcs5))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}


forvalues l=9/12{
gen rmselistt=(chnglist9-chngcs9)^2
gen rsqt=chngcs9^2
gen ok=(my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist9-chngcs9))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}


forvalues l=13/16{
gen rmselistt=(chnglist13-chngcs13)^2
gen rsqt=chngcs13^2
gen ok=(my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist13-chngcs13))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}


forvalues l=17/20{
gen rmselistt=(chnglist17-chngcs17)^2
gen rsqt=chngcs17^2
gen ok=( my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist17-chngcs17))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}


forvalues l=21/24{
gen rmselistt=(chnglist21-chngcs21)^2
gen rsqt=chngcs21^2
gen ok=( my>=255 &reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist21-chngcs21))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}

forvalues l=25/28{
gen rmselistt=(chnglist25-chngcs25)^2
gen rsqt=chngcs25^2
gen ok=( my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist25-chngcs25))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}

forvalues l=29/32{
gen rmselistt=(chnglist29-chngcs29)^2
gen rsqt=chngcs25^2
gen ok=( my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist29-chngcs29))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}

forvalues l=33/36{
gen rmselistt=(chnglist33-chngcs33)^2
gen rsqt=chngcs25^2
gen ok=( my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist33-chngcs33))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}

forvalues l=37/40{
gen rmselistt=(chnglist37-chngcs37)^2
gen rsqt=chngcs25^2
gen ok=( my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist37-chngcs37))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}

forvalues l=41/44{
gen rmselistt=(chnglist41-chngcs41)^2
gen rsqt=chngcs25^2
gen ok=( my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist41-chngcs41))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}

forvalues l=45/48{
gen rmselistt=(chnglist45-chngcs45)^2
gen rsqt=chngcs25^2
gen ok=( my>=255 & reportinglag==`l' )
replace rmselistt=. if ok!=1
replace rsqt=. if ok!=1
egen rmselist=mean(rmselistt)
egen rsqtmean=mean(rsqt)
gen rsq=1-rmselist/(rsqtmean)
replace rmselist=sqrt(rmselist)


gen maelistt=abs((chnglist45-chngcs45))
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)

replace v1=rmselist in `l'
replace v2=maelist in `l'
replace v3=rsq in `l'

drop rmse* ok mae* rsq*
}


outsheet v1 v2 v3  using absoluteperformace.xls if v1!=. in 1/45,nonames replace

**make graphs for select forecast horizons, appendix figures 5-8
gen year=floor((my+1)/12)+1988
gen month=mod(my+1,12)+1
gen day=1

gen time=mdy(month,day,year)
format time %dmY

local msamacro="la pho seattle chi sandiego denver sanfran dc vegas"
foreach j in `msamacro' {
line chngcs1 chnglist1 time if my>=255 & reportinglag==1 &city=="`j'",  lcolor(black  gs10) saving(`j'_a.gph,replace) legend(order(1 "Case-Shiller" 2 "Adj. List Price"  )) xtitle("") title("`j'") ylabel(-.08 (.02) .06) 
}

graph combine chi_a.gph dc_a.gph denver_a.gph la_a.gph pho_a.gph sandiego_a.gph sanfran_a.gph seattle_a.gph vegas_a.gph,rows(3) ysize(9) xsize(7) iscale(.5) 
graph export graphs_fore2m.ps,replace
!ps2pdf graphs_fore2m.ps graphs_fore2m.pdf

local msamacro="la pho seattle chi sandiego denver sanfran dc vegas"
foreach j in `msamacro' {
line chngcs9 chnglist9 time if my>=255 & reportinglag==9 &city=="`j'",  lcolor(black  gs10) saving(`j'_a.gph,replace) legend(order(1 "Case-Shiller" 2 "Adj. List Price"  )) xtitle("") title("`j'") ylabel(-.16 (.04) .12) 
}

graph combine chi_a.gph dc_a.gph denver_a.gph la_a.gph pho_a.gph sandiego_a.gph sanfran_a.gph seattle_a.gph vegas_a.gph,rows(3) ysize(9) xsize(7) iscale(.5) 
graph export graphs_fore4m.ps,replace
!ps2pdf graphs_fore4m.ps graphs_fore4m.pdf



**COMPARE TO ALTERNATIVE FORECASTING MODEL
sort  my city
merge my city using forecastingresults.dta,nokeep

save ttttt.dta,replace

***********************************************
**CALCULATE PANEL VERSION OF DIEBOLD-MARIANO TEST
***********************************************

*Table 8
*treat each city as independent observation.  sum(s)/sqrt(N) is standard normal
local msamacro="la pho seattle chi sandiego denver sanfran dc vegas"
foreach k in `msamacro' {
forvalues j=1/6{
local q=(`j'-1)*4+1
use /href/scratch2/ttttt.dta,clear
keep if reportinglag==`q' & city=="`k'"
tsset my
dmariano chngcs`q' chnglist`q' chngcs`q'hat ,kernel(bartlett)
dmariano chngcs`q' chnglist`q' chngcs`q'hat ,kernel(bartlett) crit(mae)
display `q'
}
}


**FUTURES ANALYSIS
use ttttt.dta,replace
*these cities do not have cme futures so drop them
drop if city=="seattle" | city=="pho"


local msamacro="la chi sandiego denver sanfran dc vegas"
foreach j in `msamacro' {
drop _merge
sort my city
merge my city using /futures/`j'futures,nokeep update

tab _merge
}


*2month change in case shiller list error
forvalues l=1/4{
gen listerror`l'=chngcs1-chnglist1
}

*3month change in case shiller
forvalues l=5/8{
gen listerror`l'=chngcs5-chnglist5
}

forvalues l=9/12{
gen listerror`l'=chngcs9-chnglist9
}

forvalues l=13/16{
gen listerror`l'=chngcs13-chnglist13
}

forvalues l=17/20{
gen listerror`l'=chngcs17-chnglist17
}

forvalues l=21/24{
gen listerror`l'=chngcs21-chnglist21
}

forvalues l=25/28{
gen listerror`l'=chngcs25-chnglist25
}

forvalues l=29/32{
gen listerror`l'=chngcs29-chnglist29
}

forvalues l=33/36{
gen listerror`l'=chngcs33-chnglist33
}

forvalues l=37/40{
gen listerror`l'=chngcs37-chnglist37
}

forvalues l=41/44{
gen listerror`l'=chngcs41-chnglist41
}

forvalues l=45/48{
gen listerror`l'=chngcs45-chnglist45
}


**make some graphs
local msamacro="la chi sandiego denver sanfran dc vegas"
foreach j in `msamacro' {
scatter error10 listerror5   time if my>=255 & reportinglag==5 &city=="`j'" & error10!=.,yline(0,lcolor(black)) connect(l l l) color(black gs10) lcolor(black gs10) saving(`j'_b2.gph,replace) legend(order(1 "CME Futures" 2 "Adj. List Price" )) xtitle("") ylabel(-.1 (.04) .1) title("`j'",size(small))
}

*title("10 Weeks in Advance of Case-Shiller Release",size(small))
graph combine la_b2.gph chi_b2.gph sandiego_b2.gph denver_b2.gph sanfran_b2.gph dc_b2.gph vegas_b2.gph,rows(3) ysize(9) xsize(7) iscale(.5) 
graph export graphs_fut4.ps,replace
!ps2pdf graphs_fut4.ps graphs_fut4.pdf


local msamacro="la chi sandiego denver sanfran dc vegas"
foreach j in `msamacro' {
scatter error6 listerror1   time if my>=255 & reportinglag==1 &city=="`j'" & error10!=.,yline(0,lcolor(black)) connect(l l l) color(black gs10) lcolor(black gs10) saving(`j'_b2.gph,replace) legend(order(1 "CME Futures" 2 "Adj. List Price" )) xtitle("") ylabel(-.1 (.04) .1) title("`j'",size(small)) 
}

*title("8 Weeks in Advance of Case-Shiller Release",size(small))
graph combine la_b2.gph chi_b2.gph sandiego_b2.gph denver_b2.gph sanfran_b2.gph dc_b2.gph vegas_b2.gph,rows(3) ysize(9) xsize(7) iscale(.5) 
graph export graphs_fut2.ps,replace
!ps2pdf graphs_fut2.ps graphs_fut2.pdf


**calculate loss functions
drop v*
gen v1=0
gen v2=0
gen v3=0
gen v4=0
forvalues l=1/48{
local j=`l'+5
gen rmselistt=listerror`l'^2
gen ok=( my>=255 & reportinglag==`l' & error`j'!=.)
replace rmselistt=. if ok!=1
egen rmselist=mean(rmselistt)
replace rmselist=sqrt(rmselist)

gen maelistt=abs(listerror`l')
replace maelistt=. if ok!=1
egen maelist=mean(maelistt)


gen rmsefuturet=error`j'^2
replace rmsefuturet=. if ok!=1
egen rmsefuture=mean(rmsefuturet)
replace rmsefuture=sqrt(rmsefuture)

gen maefuturet=abs(error`j')
replace maefuturet=. if ok!=1
egen maefuture=mean(maefuturet)

replace v1=rmselist in `l'
replace v2=rmsefuture in `l'
replace v3=maelist in `l'
replace v4=maefuture in `l'

drop rmse* ok mae*
}

gen ratio1=(v2-v1)/v2
gen ratio2=(v4-v3)/v4

**need to create test statistic here

forvalues l=1/6{
local k=(`l'-1)*4+1
local j=`k'+5
gen y1=listerror`k'^2-error`j'^2 if my>=255 & error`j'!=. & reportinglag==`k'
gen y2=abs(listerror`k')-abs(error`j') if my>=255 & error`j'!=. & reportinglag==`k'
display `l'
reg y1
reg y2
drop y1 y2
}


*Table 9 and Appendix Table 3

outsheet v1 v2 ratio1 v3 v4 ratio2 using relativeperformace.xls if v1!=. in 1/45,nonames replace

