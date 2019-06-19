version 9
clear
capture program drop _all
set memory 50m
capture log close
set more off

****26.09.2007 RB *******************************************
* This do-file reads aggregate capital data for around 60
* manufactoring sectors (cap_gr)from 1970-2004. Make index
* with base year 2001 and gen. a deflated measure of
* sectoral capital. Save in {industri}NAcapitaldata.dta
* To be merged onto industry data using aar and cap_gr.
* Correspondence list from NA-sectors to isic at end of file
************************************************************


* Data is aggregate capital data from national accounts at
* a sectoral level corresponding to 3 digit NACE. The original
* excel file from SSB is in Paper2\Data\kapitaldata and is called
* kapitl_beholdning_industri.xls and it also contains a sheet with
* description of the codes used for the sectors. This description 
* is used to allocate sectors to our ISIC codes.
* Capital numbers is net capital stock in mill kr, for each year given 
* in current price and last years price. 1970-2004.
* Had to "reshape" data manually in excel first
* Redone 24.04.2008 after receving data also for 2005

	insheet using ${empdecomp}kopiaggkaptall.csv, delimit(";") names
	*rename v1 aar
	*rename v2 nace 
	label var v3 "Capital value in last y price"
	label var v4 "capital value in this y price"
	des
	sum
	sort nace aar
	drop if nace==.
	tsset nace aar

* Generate variable showing price increase from last year
	gen p_inc=(v4-v3)/v3
	sum p_inc

* Set base year =2001
	gen index=100 if aar==2001
* Generate index after 2001 by adding price increases
	replace index=L.index*(1+p_inc) if aar>2001
	assert index==. if aar<2001
	assert index!=. if aar>2000
* Generate index for years before 2001
	gsort nace -aar
	replace index=index[_n-1]/(1+p_inc[_n-1]) if aar<2001
	sort nace aar

* Generate deflated values of capitalstock (v4) in 2001 prices
	gen sectorcap=(v4/index)*100
	assert sectorcap==v4 if aar==2001
	label var sectorcap "values of capital stock in mill 2001 kr from Nat.Acc."
	rename v4 sectorcap_nom
* Correspondence between the nace sectors in NA-data, and isic sectors
* Based on reading description in excel file from SSB with sectors in 
* National accounts data (the nace variable) and isic codes

* Here: generate a capital grouping cap_gr for the different nace
* codes, and then generate a similar one for the isic codes in manufacturing
* statistics, then the capital data here can be merged onto 
* manufacturing statistics using aar and cap_gr.
	sort aar nace

	bys aar: gen n=_n
	bys aar: gen N=_N
tab N
	assert n==1 if nace==23151

	bys nace: egen low=min(n)
	bys nace: egen high=max(n)
	assert low==high
	drop low high
	* of the 64 sectors in the NA-capital data, 3 are not
	* found in the isic grouping: nace 23223=cap_gr 23, 
	* 23371-372=cap_gr 63,64 and 23321 and 23323 has to be combined
	drop if nace==23223 | nace==23371 | nace==23372
	list n if aar==1970 & nace==23321
	*(50)
	list n if aar==1970 & nace==23323
	*(51)
	replace n=50 if n==51
	rename n cap_gr
	bys aar: egen x=sum(sectorcap) if nace==23321 | nace==23323
	assert x==. if cap_gr!=50
	replace sectorcap=x if x!=. & cap_gr==50
	drop x
	bys aar: egen x=sum(sectorcap_nom) if nace==23321 | nace==23323
	replace sectorcap_nom=x if x!=. & cap_gr==50
	drop if nace==23323
	tsset aar cap_gr
	keep aar cap_gr sectorcap*
	* base year is 2001
	sort aar cap_gr
	save ${industri}NAcapitaldata.dta, replace
	

capture log close
exit

* The corresponding cap_gr based on isic codes is:
	* though not to be used in this do-file
	* need naering, isic4 isic3
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
	replace cap_gr=56 if naering==38241 
	replace cap_gr=57 if isic4==3842
	replace cap_gr=58 if isic4==3845
	replace cap_gr=59 if isic4==3844 | isic4==3849
	replace cap_gr=60 if isic4==3812 | isic3==332
	replace cap_gr=61 if isic4==3901
	replace cap_gr=62 if isic4==3902 | isic4==3903 | isic4==3909











	




