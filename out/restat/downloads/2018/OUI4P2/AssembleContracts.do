*Assemble contract data and create dataset of obligations and spending by year

*Run commented-out code on the raw data from USAspending.gov
/*
clear
local years "00 01 02 03 04 05 06 07 08 09 10 11 12 13"
erase "ContractsAllYrs.dta"
clear
foreach x of local years {
    use FY`x', clear
   di `x'
   di "FY data"
   tostring placeofperformancezip location, replace
    *Keep if in USA
    gen country=substr(placeofperformancecountry,1,3)
    keep if country=="USA"
    drop placeofperformancecountry country
	destring dunsnumber, replace force
   
   ***create zip code variable
    *Zip of contractor
    gen zipCont=substr(zipcode,1,5)
	*Zip of performance
    gen zip=substr(placeofperformancezip,1,5)
     *How many observations have zip of performance?
    g byte hasZipPerf=(placeofperformancezip~="" & placeofperformancezip~=".")
    su hasZip
	 *state of performance
	gen statePerf=substr(statecode,1,2)
	 g byte samestate=(state==statePerf)
	 g byte spMiss=statePerf==""
 	 ta samestate if spMiss==0
   
    replace zip=zipCont if zip=="" | zip=="."
***create time variables
	 gen signDATE=date(signed,"MDY")
	 gen signMTH=month(signDATE)
	 gen signYR=year(signDATE)

	 gen compDATE=date(current,"MDY")

***drop unnecessary variables
	drop unique *date multiyear vendorname city state zipcode zipCont parent mod_parent locationcode statecode place*
	
	compress
	
   describe, short
   capture append using "ContractsAllYrs.dta"
   describe, short
   save "ContractsAllYrs.dta", replace
}
*/
use ContractsAllYrs.dta, clear
**********dropping negatives with prior positive contracts
	gen compMTH=month(compDATE)
	gen compYR=year(compDATE)

gen ABSdol=abs(dollars)
gsort zip duns ABS signDATE 


g byte flag=0
**identify contracts with other contracts of similar value
by zip duns: gen dif=abs((ABSdol-ABSdol[_n-1])/ABSdol[_n-1])
by zip duns: replace flag=abs((ABSdol-ABSdol[_n-1])/ABSdol[_n-1])<.005  & ((dollars<0 & dollars[_n-1]>0) | (dollars>0 & dollars[_n-1]<0))
su flag
  *remove flags that are duplicates
replace flag=0 if flag[_n-1]==1
su flag
by zip duns: replace flag=1 if flag[_n+1]==1
su flag
drop if flag

************now create spending data set.*************
  *first create contract identifier
  gen unique=_n
	
		gen timetocomp=compDATE-signDATE
		gen signYRM=signYR*100+signMTH
		gen compYRM=compYR*100+compMTH
		gen months=max(0,floor(timetocomp/30))
			   g byte gt2020=compYR>2020
	           su gt2020
			   drop if gt2020
	expand months
	sort unique signDATE months
	gen Spending=dollars/months
	replace Spending=dollars if months==0
	 *now create a date variable   
	by unique: gen date=signDATE+(_n-1)*30

	gen month=month(date)
	gen year=year(date)
	gen yearm=year*100+month
	
	*only one entry for dollars obligated per transaction
	by unique signDATE: gen count=_n
	replace dollars=0 if count>1
	drop count
	
	
	collapse (sum) Spending dollars, by(zip year month)

*******county-level***
/*
    merge m:1 zip using ZipCounty
    keep if _merge==3
    collapse (sum) Spending dollars, by(county year month)

save "GvtDataCountyMonthly.dta, replace
*/
*****CBSA level **********
    merge m:1 zip using ZipCBSA
     keep if _merge==3
	 
	destring cbsa, replace force
	keep if cbsa<.
	 ******Annual*******
collapse (sum) Spending dollars, by(cbsa year )
save GvtDataCBSA.dta, replace

