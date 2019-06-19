version 10
clear
set memory 350m
capture log close
set more off
capture program drop _all
log using ${empdecomp}generate_variables_update, text replace

* **** 26.04.2008**********************************************
* Combination of dropping procedures in check_entrydef2.do
* (dropping plants with many missing values)
* and generate_variables.do

* Previous versions merged in kapitaldatabasen and also a
* lot of work on other capital variables. Given up on that
* here. Use only cap. vars based on investment from: 
* gen_capital_update.do

* 1. Drop procedures
* 2. Generate variables, save data
* 3. Merge in price indexes, for deflating output and input, deflate
*    and save data
**************************************************************

***New 21.10.2008 RB *****************************************
* Generate Li_e number of empl including rented labour. 
* Consistent with the Li_h : hours including rented labour
* Generate deflated value added measure (v108)
**************************************************************

* 1.
*****

* Merge main panel with investment/capital data
 	use ${industri}entrycheck_update.dta
	sort bnr aar
	merge bnr aar using ${industri}k_inv_update.dta
	assert _merge==3
	drop _merge

* Gen plant count/order. n N in panel is based on panel from 1989, 
* here panel is from 1990
	drop n N 	
	bys bnr: gen n=_n
	bys bnr: gen N=_N
	count if n==N
	tab N if n==N


* Gen capital measure indicator and drop plants that never invest
	foreach t in k1 k2 k3 {
		replace `t'=0 if `t'==.
	}
	gen cap=k1+k2+k3
	bys bnr: egen cap_inv=sum(cap)
	assert cap_inv!=.
	sum cap_inv
	drop if cap_inv==0

* Drop plants that have zero or missing 50% of years they are observed 
* on one of the following variables: v13 v15 v38 v104 v106 inv: 
* employment, hours, wages, output, inputs, investmentbased capital measures

	foreach t in v13 v15 v38 v104 v106  {
		replace `t'=0 if `t'<0
		replace `t'=0 if `t'==.
	}
	foreach t in v13 v15 v38 v104 v106 {
		display " Obs dropped due to missing `t' 50% of years"
		gen null`t'=1 if `t'==0
		bysort bnr: egen ant0`t'=sum(null`t')
		drop if ant0`t'>=0.5*N 
		drop null`t' ant0`t'
	}
	foreach t in k1 k2 k3 {
		display " Obs dropped due to missing `t' 50% of years"
		gen null`t'=1 if `t'==0
		bysort bnr: egen ant0`t'=sum(null`t')
		drop if ant0`t'>=0.5*N 
		drop null`t' ant0`t'
	}

	count
	count if n==N
	* from 8160 plants til 7890
	count if entry==exit
	count if N==1

* Check on order of entries
	sum entry*
	sum exit*
	bys bnr: egen mentry1=mean(entry1)
	bys bnr: egen mexit1=mean(exit1)
	replace entry1=mentry1 if mentry1!=.
	replace exit1=mexit1 if mexit1!=.
	replace entry1=0 if entry1==.
	replace exit1=0 if exit1==.
	assert entry1>entry if entry1>0 
	assert entry1>exit1 if entry1>0 
	assert exit1<exit if exit1>0 
	
* Summary of zero observations
	foreach t in v13 v15 v38 v104 v106 k1 k2 k3 {
		count if `t'==0
	}

* 2.
******

* Construct input and output variables that are the basis for
* future TFP calculations

* Generate output corrected for sales taxes and subsidies: Qi
	replace v29=0 if v29==. | v29<0
	replace v30=0 if v30==. | v30<0
	gen Qi=max(0,v104-v30+v29)
	drop v30 v29 v104
	label var Qi "Plant level gross output corr. for sales-subs. and taxes"

* Variable for labour input: wagecosts pluss hired labour
* as basis for constructing cost shares
	replace v38=0 if v38==.
	replace v42=0 if v42==.
	gen Li=v38+v42
	replace Li=. if Li==0
	count if Li<0
	replace Li=. if Li<0
* Variable for labour input for use in the construction of TFP
* based on hours worked
	gen h_rent=v42/(v38/v15) 
	replace h_rent=0 if h_rent==.
	gen Li_h=v15+h_rent 
	count if v15==. | v15==0
	count if Li_h==0 | Li_h==.
	replace Li_h=. if Li_h==0
	gen e_rent=v42/(v38/v13) 
	replace e_rent=0 if e_rent==.
	gen Li_e=v13+ e_rent
	replace Li_h=. if Li_h==0
	drop h_rent e_rent
	label var Li "Total wagecosts for labour input"
	label var Li_h "Labour input in hours worked in the plant, incl rented"
	label var Li_e "Labour input in number of empl in the plant, incl rented"

* Material inputs (must subtract capital rent and hired labour)
	gen Mi=max(0,v106-v45-v42)
	replace Mi=. if Mi==0
	label var Mi "Total material costs"	
	drop v106
* Generate profitmargin variable
	gen profitmargin=(Qi-Li-Mi)/Qi
	label var profitmargin "Qi minus labour and input costs relative to Qi"


	save ${empdecomp}temppanel.dta, replace

* 3.
**********

* Based on prisdata.do: merge in price indexes, and deflate input and output

* This is done in the following steps.
* 1.A,B,C
* Use the panel to allocate all plants to a sector group 
* that corresponds with the 3 aggregation levels of price-indexes.
* A: Outputprice-index corresponding to varepris-data
* B: Investment-index corresponding to nyinvesteringer_kapital data
* C: Inputprice-index correpsonding to prodinnsats_nasjonalreg data 
* 2.A,B
* Convert the different price index data files into a form that helps
* merging the price data onto the industry-panel. 
*
* 3.A,B
* Merge the different price-indexes onto the panel. 
************************************************************************
* 1.A
* Jarle's part: groups to correspond with varepris-index (output deflator)
* See the file Vareprisindeker_industri.xls for def. of the 20 groups
* and their corresponding NACE-codes. Since we use isic-codes, I only
* use the isic-code grouping here. New data in vareprisindekser_industri_ssbnett.csv
* taken from SSBs internetpages april 2008. These are to be used for deflatng
* output. New in these data is 19 sectors instead of 20, VPgr 7 and 8 below
* are combined (grafisk industri combined with treforedling)
* Note a "mistake" in the groupings. In the excel file it is clear that
* for instance group 3 (food drinks and tobacco) includes also group 4
* (drinks and tob), but group 4 is given a seperate price index, Below 
* the group 3 index is only allocated to food, even though it also incl
* price developments in drinks and tobacco. This is done because we do 
* not have weights to split the indexes. This same problem is also 
* relevant for some of the other groups (10 and 14).
	capture gen isic2=int(naering/1000)
	capture gen isic3=int(naering/100)
	capture gen isic4=int(naering/10)
	gen VPgr=1 if isic2==21 | isic2==23 | isic2==29
	replace VPgr=4 if isic3==311 | isic3==312
	replace VPgr=3 if isic2==31 & VPgr==.
	replace VPgr=5 if isic2==32
	replace VPgr=6 if isic3==331
	replace VPgr=7 if isic3==341
	*replace VPgr=8 if isic3==342
	replace VPgr=7 if isic3==342
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
	assert VPgr!=.
	
* 1.B
* Groups to correspond with price index for investment. Data in 
* Prisindekser_nyinvesteringer_kapital.xls
	gen INVgr=1 if VPgr==1
	replace INVgr=6 if VPgr==5
	replace INVgr=7 if VPgr==6
	replace INVgr=8 if VPgr==7
	replace INVgr=9 if isic3==342
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
	assert INVgr!=.

* 1.C
* Groups to correspond with price index for inputs. Data in 
* Prodinnsats_nasjonalreg.xls
	gen INPgr=1 if INVgr==1
	replace INPgr=2 if INVgr==2 | INVgr==3 | INVgr==4 | INVgr==5
	replace INPgr=3 if INVgr==6
	replace INPgr=4 if INVgr==7
	replace INPgr=5 if INVgr==8
	replace INPgr=6 if INVgr==9
	replace INPgr=7 if INVgr==11
	replace INPgr=8 if INVgr==10
	replace INPgr=9 if INVgr==12
	replace INPgr=10 if INVgr==13
	replace INPgr=11 if INVgr==14 | INVgr==15
	replace INPgr=12 if INVgr==16	
	assert INPgr!=.
	save  ${empdecomp}temppanel.dta, replace

 
* 2.A
* Generate yearly output price index from monthly index data.
* Aggregation level is 19 index groups based on National Accounts.
* Use data taken from SSBs internet pages, april 2008, and manipulated 
* a little bit in excel
* All values must be divided by 10
clear
insheet using "C:\Paper2\Data\priser\vareprisindekser_industri_ssbnett.csv", delimit(;) names
	forvalues t=1/7 {
		assert index`t'!=.
		replace index`t'=index`t'/10
	}
	forvalues t=9/20 {
		assert index`t'!=.
		replace index`t'=index`t'/10
	}
* Take average of the monthly index-numbers to get a yearly index
	collapse index1-index20, by(aar)
	sort aar
* I want base year to be 2001, since this is base year for the 
* price index for investment. indexN[YEAR] defines baseyear. 25=2001
	forvalues y=1/7 {
		scalar basisindex`y'=index`y'[25]
		display basisindex`y'
	}
	forvalues x=1/7 {
	replace index`x'=(index`x'/basisindex`x')*100
	}
	forvalues y=9/20 {
		scalar basisindex`y'=index`y'[25]
		display basisindex`y'
	}
	forvalues x=9/20 {
	replace index`x'=(index`x'/basisindex`x')*100
	}

* Save temporarily in a form that is conducive to merging
* the price data onto the industry panel later.
	reshape long index, i(aar) j(VPgr)
	label var VPgr "group aggregation for output pr index (NA)"
	rename index VPindex
	label var VPindex "varepris=output-price-index from NA"
	sort aar VPgr
	save ${priser}temp1.dta, replace


* 2.B
* Convert the yearly price increases for inputs at sector level into
* an input-price-index. Aggregation leve is 12 NA groups. Base year
* is 2001
***26.04.2008****
* Leser inn nye prisendringsdata fra nasjonalregnskapet
* mottatt fra SSB: Karin Snesrud 25 april 08
* Dette er til bruk for prisendring på output
* Alle tall må deles på 10 for at de skal bli riktige
**********************
clear
insheet using "C:\Paper2\Data\priser\produktinnsatsprisendring.csv", delimit(;) names
destring, replace
rename v1 aar
forvalues t=2/13 {
	replace v`t'=v`t'/10
}
	rename v2 INPindex1
	rename v3 INPindex2
	rename v4 INPindex3
	rename v5 INPindex4
	rename v6 INPindex5
	rename v7 INPindex6
	rename v8 INPindex7
	rename v9 INPindex8
	rename v10 INPindex9
	rename v11 INPindex10
	rename v12 INPindex11
	rename v13 INPindex12

	forvalues t=1/12 {
		rename INPindex`t' growth`t'
	}

	forvalues t=1/12 {
		gen INPindex`t'=100 if aar==2001
	}

	gsort -aar
	forvalues t=1/12 {
		replace INPindex`t'=INPindex`t'[_n-1]/(1+growth`t'[_n-1]/100) if INPindex`t'[_n-1]!=. 
	}
	sort aar
	forvalues t=1/12 {
		replace INPindex`t'=INPindex`t'[_n-1]*(1+growth`t'/100) if aar>2001
	}
	forvalues t=1/12 {
		drop growth`t'
	}

* Save temporarily in a form that is conducive to merging
* the price data onto the industry panel later.
	reshape long INPindex, i(aar) j(INPgr)
	label var INPgr "group aggregation for input price index (NA)"
	label var INPindex "input-priceindex from NA"
	sort aar INPgr
	save ${priser}temp2.dta, replace


* 3.A
* Merge output-price index onto the industry data panel.
	use ${empdecomp}temppanel.dta, clear
	sort aar VPgr
	merge aar VPgr using ${priser}temp1.dta, _merge(prismerge)
	drop if aar>2005 | aar<1990
	tab prismerge
	drop if prismerge==2
	drop prismerge
	
* 3.B
* Merge in the input price index
	sort aar INPgr
	merge aar INPgr using ${priser}temp2.dta, _merge(prismerge)
	drop if aar>2005 | aar<1990
	tab prismerge
	assert INPgr==1 if prismerge==2
	drop if prismerge==2
	drop prismerge isic2 isic3 isic4


	erase ${priser}temp1.dta
	erase ${priser}temp2.dta

	foreach t in VPindex INPindex {
		assert `t'!=. 
	}


* Deflate output and input variables
	gen Qidef=(Qi/VPindex)*100
	assert Qidef!=. if Qi!=. 
	gen Midef=(Mi/INPindex)*100
* Generate deflated value addef
	gen VAdef=(v108/VPindex)*100
	drop *index *gr
	quietly compress
	sort bnr aar


save ${industri}entrycheck_update.dta, replace
erase ${empdecomp}temppanel.dta
erase ${industri}k_inv_update.dta

* Merge in consumer price index to deflated wagecosts and rental costs
	sort aar
save ${industri}entrycheck_update.dta, replace
	merge aar using ${empdecomp}kpi.dta, keep(kpi)
	quietly gen wagecost=(v38)*(100/kpi)
	quietly gen rentcost=(v42)*(100/kpi)
	quietly gen totwagecost=(Li)*(100/kpi)
	label var wagecost "Deflated wagecosts for own employees"
	label var rentcost "Deflated costs for rented labour"
	label var wagecost "Deflated wagecosts for own employees"

drop _merge
sort bnr aar
save ${industri}entrycheck_update.dta, replace

capture log close
exit





