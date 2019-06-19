version 10
clear
capture program drop _all
set memory 350m
capture log close
set more off
log using ${empdecomp}gen_capital_update, text replace


***25.04.2008*** RB ****************************************
* Based on generate_capitalalternative.do

* Point of do-file is to generate capital variables based 
* on investment information in the manufacturing statistics. 
* Thus avoid using the fire insurance values that disappear
* in 1996 and thus would create a break in capitalvalues. 
* One measure only based on investment info, 2 other measures
* using aggregate capital stock data from National Accounts
* in the entry year for a plant. Agg. data distributed acc.
* to employment or energy use.

* Save capital values in ${industri}k_inv_update.dta. 
* Can be merged back to the main panel: entrycheck_update.dta

* Use price index from NA for new investments in machinery, 
* buildings and transport eq
*************************************************************

* Use capitalpanel made in check_entrydefinitions_update.do
use ${empdecomp}capitalpanel.dta

* Generate variable for sectors corresponding to 
* capital data from national accounts (NA_capitaldata.do)
* The corresponding cap_gr based on isic codes is:
	gen isic4=int(naering/10)
	gen isic3=int(naering/100)
	gen isic2=int(naering/1000)
	gen cap_gr=1 if isic4==3111	
	replace cap_gr=2 if isic4==3114
	replace cap_gr=3 if isic4==3113
	replace cap_gr=4 if isic4==3115
	replace cap_gr=5 if isic4==3112
	replace cap_gr=6 if isic4==3116
	replace cap_gr=7 if isic4==3122
	replace cap_gr=8 if isic4==3117 | isic4==3119 | isic4==3121 
	replace cap_gr=9 if isic3==313 | isic3==314
	replace cap_gr=10 if isic3==321
	replace cap_gr=11 if isic3==322
	replace cap_gr=12 if isic3==323 | isic3==324
	replace cap_gr=13 if naering==33111 | naering==33115
	replace cap_gr=14 if naering==33112 | naering==33119
	replace cap_gr=15 if naering==33113 | naering==33114
	replace cap_gr=16 if isic4==3312 | isic4==3319
 	replace cap_gr=17 if naering==34111 | naering==34112 | naering==34113
	replace cap_gr=18 if naering==34114 | naering==34115
	replace cap_gr=19 if isic4==3412 | isic4==3419
	replace cap_gr=20 if isic4==3422
	replace cap_gr=21 if isic4==3421
	* cap_gr 22 is not found in isic classification
	replace cap_gr=23 if isic3==354 | isic3==353 | isic4==3511
	replace cap_gr=24 if isic4==3512
	replace cap_gr=25 if isic4==3521
	replace cap_gr=26 if isic4==3522
	replace cap_gr=27 if isic4==3523
	replace cap_gr=28 if naering==35299
	replace cap_gr=29 if isic4==3513
	replace cap_gr=30 if isic3==355 | isic3==356
	replace cap_gr=31 if isic3==362
	replace cap_gr=32 if isic3==361 | isic4==3691
	replace cap_gr=33 if isic4==3692
	replace cap_gr=34 if isic4==3699
	replace cap_gr=35 if naering==37101 | naering==37102
	replace cap_gr=36 if naering==37201 
	replace cap_gr=37 if naering==37202 | naering==37203
	replace cap_gr=38 if naering==37204 | naering==37103
	replace cap_gr=39 if isic4==3813
	replace cap_gr=40 if isic4==3811
	replace cap_gr=41 if isic4==3819
	replace cap_gr=42 if isic4==3821 | naering==38299 | naering==38413 | naering==38414
	replace cap_gr=43 if isic4==3822 | isic4==3823 | naering==38249 | naering==38292
	replace cap_gr=44 if naering==35291 
	replace cap_gr=45 if naering==38291 | isic4==3833
	replace cap_gr=46 if isic4==3825
	replace cap_gr=47 if isic4==3831
	replace cap_gr=48 if naering==38391
	replace cap_gr=49 if naering==38399
	replace cap_gr=50 if isic4==3832
	* cap_gr 51 is combined with 50
	replace cap_gr=52 if isic4==3851
	replace cap_gr=53 if isic4==3852
	replace cap_gr=54 if isic4==3843
	replace cap_gr=55 if naering==38411 | naering==38412
	replace cap_gr=56 if naering==38241 | naering==38240
	replace cap_gr=57 if isic4==3842
	replace cap_gr=58 if isic4==3845
	replace cap_gr=59 if isic4==3844 | isic4==3849
	replace cap_gr=60 if isic4==3812 | isic3==332
	replace cap_gr=61 if isic4==3901
	replace cap_gr=62 if isic4==3902 | isic4==3903 | isic4==3909
	sort aar cap_gr

* Merge in sectoral capitaldata
	merge aar cap_gr using ${industri}NAcapitaldata.dta
	drop if aar<1972
	drop if aar>2005
	tab _merge 
	drop if _merge==2 /* 1 obs*/
	assert _merge==3
	drop _merge
* Generate sum of employment by year and cap_gr
	bys aar cap_gr: egen totv13=sum(v13)
* each plants share of tot employment in its cap-gr and year
	gen share13=v13/totv13
	assert share13>=0
	assert share13<=1 if v13!=.
* distribute capital according to empl share
	* transform capital to 1000 kr
	replace sectorcap=sectorcap*1000
	gen capshare=share13*sectorcap
	assert capshare<=sectorcap if sectorcap!=.

* Generate sum of energyuse by year and cap_gr
	* replace 4 negative values to positive
	replace v34=abs(v34) if v34<0
	bys aar cap_gr: egen totv34=sum(v34)
* each plants share of tot energy use in its cap-gr and year
	gen share34=v34/totv34
	assert share34>=0
	assert share34<=1 if v34!=.

* distribute capital according to energy-use-share
	gen capshare_energy=share34*sectorcap
	assert capshare_energy<=sectorcap if sectorcap!=. & v34!=.
	sum capshare*, det
	pwcorr capshare capshare_energy, star(5)	
	* the 2 capital share measures have corr coeff 0.85, 
	* there are more zeros with energy use. Mean and max of capital
	* values is of the same order of magnitude

* Investment variables
***********************
* Variables v50-v71 should not be negative according to definition

* Investment, acquisitions of machinery, tools, transport eq. 
* and "inventar": v50-53
	* According to Jarles doc. 50+51+52+53 should equal 117+118
	* and 50+53=117. v53=. in 96,97,98 then info lies in v50

		foreach t in v50 v51 v52 v53 {
			count if `t'<0
			replace `t'=0 if `t'==.
		}
		gen x117=v50+v53
		assert v117==x117
		gen x118=v51+v52
		assert x118==v118
		drop x117 x118
		count if v117<0
		count if v118<0
	gen x=1 if v117<0 | v118<0
	bys bnr: egen neg=min(x)
	*list aar bnr v50-v53 v117 v118 if neg==1
	* Based on browsing of the very few relevant plants: 
	* replace the negative with its abs value
	foreach t in v50 v51 v52 v53 {
		replace `t'=abs(`t') if `t'<0
	}
	replace v118=v51+v52
	replace v117=v50+v53
	drop x neg
		
* Investment in buildings and production plants: v54-57
	* v54 v55 are velfare buildings and housing; should not be 
	* counted as productive capital. Thus I choose to ignore these
	* variables and ignore the chance that v55 lies in v56 from 1999
	foreach t in 54 55 56 57 {
		display " # of obs with v`t'<0"
		count if v`t'<0
		sum v`t'
		replace v`t'=0 if v`t'==.
	}
	drop v54 v55
	gen x=1 if v56<0 | v57<0
	bys bnr: egen neg=min(x)
	*list aar bnr v117 v118 v56 v57 if neg==1
	* According to J-doc. sum 54 to v57 =v119, but here
	* use sum v56+v57
* Based on browsing: replace negatives of v56, v57 with abs value
	foreach t in v56 v57 {
		replace `t'=abs(`t') if `t'<0
	}
	drop x neg
* Deinvestment or sales of machinery, equipment, "inventar": 
* All negative observations are small, replace with abs value
	foreach t in v64 v65 v66 v67 v70 v71{
		count if `t'<0	
		replace `t'=0 if `t'==.
		sum `t' if `t'<0, det
		replace `t'=abs(`t') if `t'<0
	}
	
* Rented capital v46 v47, replace negatives (45 and 49 obs) with abs value
	replace v46=abs(v46) if v46<0
	replace v47=abs(v47) if v47<0
	replace v46=0 if v46==.
	replace v47=0 if v47==.


* Summary of variables
	* Machinery/tools etc: Invest: v50,v53, sale: v64,v67
	* Transport/cars: Invest: v51,v52, sale: v65,v66
		* Some crossovers between machinery and cars late 90s,: ignore?
	* Buildings: Invest: v56,v57, sale: v70,v71
	* Hired capital: v46 buildings, v47 machinery and transport
	sort bnr aar
	save ${empdecomp}temppanel.dta, replace

* Generate groups corresponding to the investment price index, 
* based on output price index (from prisdata.do)
	gen VPgr=1 if isic2==21 | isic2==23 | isic2==29
	replace VPgr=4 if isic3==311 | isic3==312
	replace VPgr=3 if isic2==31 & VPgr==.
	replace VPgr=5 if isic2==32
	replace VPgr=6 if isic3==331
	replace VPgr=7 if isic3==341
	replace VPgr=8 if isic3==342
	replace VPgr=11 if isic3==351
	replace VPgr=9 if isic3==353
	replace VPgr=12 if isic3==355 | isic3==356
	replace VPgr=10 if isic2==35 & VPgr==.
	replace VPgr=13 if isic2==36
	replace VPgr=15 if isic3==372
	replace VPgr=14 if isic2==37 & VPgr==.
	replace VPgr=16 if isic3==381
	replace VPgr=18 if isic3==383 | isic3==385 | isic4==3285
	replace VPgr=17 if isic3==382 & VPgr==.
	replace VPgr=19 if isic3==384
	replace VPgr=20 if isic2==39 | isic3==332
	assert VPgr!=. if isic2>20 & isic2<40 & isic2!=22	
* Groups to correspond with price index for investment. Data in 
* Prisindekser_nyinvesteringer_kapital.xls
	gen INVgr=1 if VPgr==1
	replace INVgr=6 if VPgr==5
	replace INVgr=7 if VPgr==6
	replace INVgr=8 if VPgr==7
	replace INVgr=9 if VPgr==8
	replace INVgr=10 if VPgr==11
	replace INVgr=5 if isic3==313 | isic3==314
	replace INVgr=3 if isic4==3111 | isic4==3112
	replace INVgr=2 if isic4==3114 | naering==31151
	replace INVgr=4 if isic2==31 & INVgr==.
	replace INVgr=11 if isic2==36
	replace INVgr=11 if isic2==35 & INVgr==.	
	replace INVgr=12 if isic2==37
	replace INVgr=14 if naering==38411
	replace INVgr=15 if naering==38241
	replace INVgr=13 if isic2==38 & INVgr==.
	replace INVgr=16 if isic2==39 | isic3==332
	assert INVgr!=. if isic2>20 & isic2<40 & isic2!=22
	drop VPgr	
	save ${empdecomp}temppanel.dta, replace
 
* Import csv.version of excel sheet from SSB with price index
* for investment by National account sector. 
	clear
	insheet using ${priser}realkapitalprisindekser.csv, delimit(;)
	reshape long bygg transp mask, i(aar) j(INVgr)
	label var INVgr "group aggregation for investment price index (NA)"
	label var bygg "priceindex for investment in buildings (NA)"
	label var transp "priceindex for investment in transport equipm. (NA)"
	label var mask "priceindex for investment in machinery (NA)"
	sort aar INVgr
	save ${priser}temp2.dta, replace
* Price index goes back only to 1978. Alternatives for the years before:
	* a) assume price constant1972-1978, ie use index for 1978 also in
	* years 72-78
	keep if aar==1978
	drop aar
	sort INVgr
	rename bygg bygg78
	rename mask mask78
	rename transp transp78
	save ${priser}temp78.dta, replace
* Merge the investment price-index onto the panel from 1978. 
	use ${empdecomp}temppanel.dta, clear
	count
	sort aar INVgr
	merge aar INVgr using ${priser}temp2.dta, _merge(prismerge)
	tab aar prismerge
	assert prismerge==1 if aar<1978
	drop if aar>2005
* Merge the 1978 index onto the years before 1978
	sort INVgr
	merge INVgr using ${priser}temp78.dta
	sort bnr aar
	tab _merge
	replace bygg=bygg78 if aar<1978
	replace mask=mask78 if aar<1978
	replace transp=transp78 if aar<1978
	drop mask78 bygg78 transp78 _merge
	drop prismerge isic2 isic3 isic4
	drop if bnr==.
	save ${empdecomp}temppanel.dta, replace

* Erase temporary price index data
	erase ${priser}temp2.dta
	erase ${priser}temp78.dta

* Generate deflated investment variables: called V50, etc
* base year is 2001 for investment price index
	foreach t in 56 57 70 71 {
		gen V`t'=v`t'/(bygg/100)
	}
	foreach t in 51 52 65 66 {
		gen V`t'=v`t'/(transp/100)
	}
	foreach t in 50 53 64 67 {
		gen V`t'=v`t'/(mask/100)
	}

* Deflated rented capital values
	gen V46=v46/(bygg/100)
	gen V47=v47/(mask/100)

* Net investment variables, deflated values, rented capital not included
	gen n_mask=V50+V53-V64-V67
	gen n_transp= V51+V52-V65-V66
	gen n_bygg=V56+V57-V70-V71
	sum n_*, det
	sort bnr aar
	save ${empdecomp}temppanel.dta, replace

* Merge in entry entry1 exit exit1 from main panel
* Note that in entrycheck_update, new entryyear has been defined for plants
* appearing in early 1990s after a 3 year absence. For consistency: must 
* use capital data from NA in all our defined entry years
	rename entry entryold
	merge bnr aar using ${industri}entrycheck_update.dta, keep(entry1 exit1 entry)
	tab aar _merge
	drop if _merge==2
	* the few m=2 are the few plants with many reentries dropped at end of 
	* check_entrydefinitions_update.do
	assert entry!=. if _merge==3
	count if entry==entryold
	replace entryold=entry if _merge==3
	drop entry
	rename entryold entry
	assert entry!=.
	bys bnr: egen maxentry=max(entry)
	bys bnr: egen minentry=min(entry)
	assert maxentry!=.
	replace entry=maxentry
	drop if aar<entry
	drop _merge maxentry minentry

* Drop plants that exit before 1979
	drop if exit<1979


* Allocate deflated capitalvalue from national accounts, 
* only to entry year of plant
	gen capshare1=capshare if aar==entry
	assert capshare1==. if aar!=entry
	replace capshare1=capshare if aar==entry1
	replace capshare1=0 if capshare1==.
	gen capshare1_energy=capshare_energy if aar==entry
	assert capshare1_energy==. if aar!=entry
	replace capshare1_energy=capshare_energy if aar==entry1
	replace capshare1_energy=0 if capshare1_energy==.
* How should the start value of capital from national accounts be depreciated?
* 2, 6 15%??? use the average of investment share in the 3 types of capital
	egen z=rsum(n_mask n_transp n_bygg)
	gen sharemask=n_mask/z
	gen sharetransp=n_transp/z
	sum sharemask sharetransp if aar>=1978	
	* sum shows maschinery 70%,transp 13 and buildings 17%
	* this makes depreciation rate for the cap values from
	* national accounts=(0,7*6%+0,13*15%+0,17*2%)=6.49%
	* This is close enough to 6%, so I choose that and add it 
	* to the machinery investment variable
	

* Fillin
	gen n1=1 if aar==entry
	gen nre=1 if aar==entry1
	replace n1=n1[_n-1]+1 if bnr==bnr[_n-1] & n1[_n-1]!=.
	count if n==n1
	count if n!=n1
	replace nre=nre[_n-1]+1 if bnr==bnr[_n-1] & nre[_n-1]!=.
	fillin bnr aar 
	bys bnr: egen entryaar=mean(entry)
	bys bnr: egen exitaar=mean(exit)
	* Drop filled in obs before entry and after exit
	quietly drop if _fillin==1 & aar<entryaar
	quietly drop if _fillin==1 & aar>exitaar
	tab _fillin
	assert _fillin==0 if aar==entryaar | aar==exitaar
	assert _fillin==0 if aar==entry1 | aar==exit1
	assert (n==1 | n1==1) if aar==entryaar
	assert nre==1 if aar==entry1
	drop if bnr==.

* Back to investment variables at plant level
* For simplicity: make investment variables=0 for filled in observations, and 
* then use PIM from entry year. Ignore reentry, thus depreciate
* capital stock all years plant is missing until it reappears
	foreach t in mask transp bygg {
		replace n_`t'=0 if n_`t'==. & _fillin==1
	}

* Capital value for machinery, depr rate 6%
	* first year value
	gen cm=n_mask if n==1 | n1==1
	tsset bnr aar
	* values following years
	replace cm=L.cm*(1-0.06)+n_mask if L.cm!=.
	count if cm==.
* Capital value for transport, depr rate 15%
	* first year value
	gen ct=n_transp if n==1 | n1==1
	* values following years
	replace ct=L.ct*(1-0.15)+n_transp if L.ct!=.
	count if ct==.
* Capital value for buildings, depr rate 2%
	* first year value
	gen cb=n_bygg if n==1 | n1==1
	* values following years
	replace cb=L.cb*(1-0.02)+n_bygg if L.cb!=.
	count if cb==.

* Capital values based on investment in reentry years
	* first year value
	gen cm1=n_mask if nre==1
	* values following years
	replace cm1=L.cm1*(1-0.06)+n_mask if L.cm1!=.
	count if cm1==. & aar>=entry1
* Capital value for transport, depr rate 15%
	* first year value
	gen ct1=n_transp if nre==1 
	* values following years
	replace ct1=L.ct1*(1-0.15)+n_transp if L.ct1!=.
	count if ct1==.
* Capital value for buildings, depr rate 2%
	* first year value
	gen cb1=n_bygg if nre==1
	* values following years
	replace cb1=L.cb1*(1-0.02)+n_bygg if L.cb1!=.
	count if cb1==.
	replace cb=cb1 if cb1!=.
	replace cm=cm1 if cm1!=.
	replace ct=ct1 if ct1!=.
* Sum capital values into one variable also adding rented capital
* deflated value
	egen k_invdef=rsum(cm ct cb V46 V47)
	label var k_invdef "capital measure based on investment and PIM, deflated"

* Alternative capital measure where in addition to investment vars, 
* we also use a start value in entry year based on sectoral NA capital data
* Deflate start value as for machinery 6%, when using a start value
* do not use investment the first year, because this should be
* included in the start value
	drop cm cm1
	* First year value for machinery including startvalue from NA
	gen cm=capshare1 if n==1 | n1==1
	* values following years
	replace cm=L.cm*(1-0.06)+n_mask if L.cm!=.
	count if cm==.
	gen cm1=capshare1 if nre==1 
	* values following years
	replace cm1=L.cm1*(1-0.06)+n_mask if L.cm1!=.
	count if cm1!=.
	replace cm=cm1 if cm1!=.
	egen k_invdefNA=rsum(cm ct cb V46 V47)
	label var k_invdefNA "as k_invdef but with startv from NA distr by v13, deflated"
	drop cm cm1
	gen cm=capshare1_energy if n==1 | n1==1
	* values following years
	replace cm=L.cm*(1-0.06)+n_mask if L.cm!=.
	count if cm==.
		gen cm1=capshare1 if nre==1 
	* values following years
	replace cm1=L.cm1*(1-0.06)+n_mask if L.cm1!=.
	count if cm1!=.
	replace cm=cm1 if cm1!=.
	egen k_invdefNA_e=rsum(cm ct cb V46 V47)
	label var k_invdefNA_e "as k_invdef but with startv from NA distr by energyuse, deflated"
	drop if _fillin==1
	keep aar bnr k_invdef* n_mask n_transp n_bygg V46 V47
	sum k_inv*, det
	pwcorr k_invdef k_invdefNA k_invdefNA_e, star(1)
	drop if aar<1990
	sort bnr aar
	save ${industri}k_inv_update.dta, replace

erase ${empdecomp}temppanel.dta
erase ${empdecomp}capitalpanel.dta


	merge bnr aar using ${industri}entrycheck_update.dta
	tab _merge
	keep if _merge==3
	keep aar bnr k_invdef* n_mask n_transp n_bygg  V46 V47
	label var n_mask "deflated investment (net of sales) in machinery"
	label var n_transp "deflated investment (net of sales) in transport eq"
	label var n_bygg "deflated investment (net of sales) in buildings"
	label var V46 "rented buildings"
	label var V47 "rented machinery"
	rename k_invdef k1
	rename k_invdefNA k2
	rename k_invdefNA_e k3
	sort bnr aar
	save ${industri}k_inv_update.dta, replace

capture log close
exit





