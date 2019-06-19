version 10
clear
capture program drop _all
set memory 150m
capture log close
set more off
log using ${empdecomp}define_plantgroups, text replace

*****24.06.2008 RB ***************************************
* Some cleaning on change of firm numbers and totstor 
* (foreign ownership var). 
* Define x1: 8 categories of plants entry exit survivors
* dom acq and dom-for acq.
* Replace ${industri}empdecomppanel1_update.dta 
**********************************************************

	use ${industri}empdecomppanel1_update.dta, clear
	count
	sort bnr aar

	bys bnr: gen n=_n
	bys bnr: gen N=_N
	count if N==n
	count if N==n & N==1
	count if entry==exit
	count if entry==2005
	count if exit==1991

	gen y=1 if entry==2005
	replace y=1 if exit==1990 | exit==1991
	count if y==1
	drop if N==1 & y==.
	drop y

* do a limited amount of cleaning on firm number changes
* generate indicator for the type of fnr=5 in t-1, fnr=7 in t and fnr=5 in t+1
	tsset bnr aar
	gen x=1  if bnr==l.bnr & bnr==f.bnr & fnr!=l.fnr & fnr!=f.fnr & l.fnr==f.fnr
	bys bnr: egen sumx=sum(x)
	tab sumx
* if two of these occur in two consecutive years, assume the first change is the 
* definite one, hence replace the fnr in the second case
	codebook bnr if sumx==2
	replace fnr=l.fnr if sumx==2 & x==1 & l.x==1
* if there is only one, replace fnr to equal the fnr in the previous and in the following year
	codebook bnr if sumx==1
	replace fnr=l.fnr if sumx==1 & x==1
	drop x sumx

** replace those changes in totstor where over the entire plant's life there is a
* once-off change that reverts back the next period 
	gen fo=(totstor!=0)
	tsset bnr aar
	gen dfo=d.fo
	bys bnr: egen no=count(dfo) if dfo!=0
	bys bnr: egen noc=max(no)
	gen x=1 if totstor!=l.totstor & totstor!=f.totstor & l.totstor==f.totstor & l.totstor!=. & f.totstor!=. 
	bys bnr: egen sumx=sum(x)
	tab noc sumx
	tab N if noc==2 & sumx==1 
	codebook bnr if noc==2 & sumx==1 
	*list bnr fnr aar totstor naering x if sumx==1 & noc==2, sepby(bnr)
	replace totstor=f.totstor if x==1 & sumx==1 & noc==2
	drop fo dfo no noc x sumx

** replace those changes in totutenl where over the entire plant's life there is a
* once-off change that reverts back the next period 

	gen fo=(totutenl!=0)
	tsset bnr aar
	gen dfo=d.fo
	bys bnr: egen no=count(dfo) if dfo!=0
	bys bnr: egen noc=max(no)
	gen x=1 if totutenl!=l.totutenl & totutenl!=f.totutenl & l.totutenl==f.totutenl & l.totutenl!=. & f.totutenl!=.
	bys bnr: egen sumx=sum(x)
	tab noc sumx
	tab N if noc==2 & sumx==1 
	codebook bnr if noc==2 & sumx==1 
	*list bnr fnr aar totutenl naering x if sumx==1 & noc==2, sepby(bnr)
	replace totutenl=f.totutenl if x==1 & sumx==1 & noc==2
	drop fo dfo no noc x sumx

* Generate an indicator for entry and exit (plant openings and closures)
* and save empdecomppanel2.dta
	gen entrycount=1 if aar==entry 
	replace entrycount=1 if aar==entry1
	gen exitcount=1 if aar==exit 
	replace exitcount=1 if aar==exit1
	drop if entrycount==1 & exitcount==1 
	sort bnr aar
	*replace totutenl=1 if totutenl==2
	*replace totstor=1 if totstor==2
	assert totutenl!=.
	assert totstor!=.
	assert aar==entry  | aar==entry1 if n==1 & aar>1992

* 2.
* Definitions of groups of plants
	sort bnr aar
	drop n
	bys bnr: gen n=_n
* According to totutenl: the sum of foreign owners have more than 20% of shares
	* domestic and foreign entrants (1)and 2
	quietly gen x3=1 if entrycount==1 & exitcount==. & totutenl==0
	quietly replace x3=2 if x3==. & entrycount==1 & exitcount==. & totutenl>0
	* domestic and foreign exits (3)4
	quietly replace x3=3 if x3==. & exitcount==1 & entrycount==. & totutenl==0
	replace x3=4 if x3==.& exitcount==1 & entrycount==. & totutenl>0	
	* domestic and foreign stayers (5)6
	replace x3=5 if entrycount==. & exitcount==. & x3==. & totutenl==0 & totutenl[_n-1]==0 & bnr==bnr[_n-1]
	replace x3=6 if entrycount==. & exitcount==. & x3==. & totutenl>0 & totutenl[_n-1]>0 & bnr==bnr[_n-1]
	*first year obs for stayers
	replace x3=5 if entrycount==. & exitcount==. & x3==. & n==1 & totutenl==0 & totutenl[_n+1]==0 & bnr==bnr[_n+1]
	replace x3=6 if entrycount==. & exitcount==. & x3==. & n==1 & totutenl>0 & totutenl[_n+1]>0 & bnr==bnr[_n+1]
	replace x3=5 if entrycount==. & exitcount==. & x3==. & n==1 & totutenl==0 & bnr==bnr[_n+1] & aar<=1992
	replace x3=6 if entrycount==. & exitcount==. & x3==. & n==1 & totutenl>0 & bnr==bnr[_n+1] & aar<=1992
	assert x3!=. if n==1 
	* domestic-domestic acquisitions
	replace x3=7 if x3==5 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	* foreign-foreign acquisitions
	replace x3=8 if x3==6 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	* foreign-domestic acquisitions
	replace x3=9 if entrycount==. & exitcount==. & x3==. & totutenl==0 & totutenl[_n-1]>0 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	replace x3=9 if entrycount==. & exitcount==. & x3==. & totutenl==0 & totutenl[_n-1]>0 & bnr==bnr[_n-1]
	* domestic-foreign acquisitions
	replace x3=10 if entrycount==. & exitcount==. & x3==. & totutenl>0 & totutenl[_n-1]==0 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	replace x3=10 if entrycount==. & exitcount==. & x3==. & totutenl>0 & totutenl[_n-1]==0 & bnr==bnr[_n-1]
	label var x3 "1 domE 2 forE 3 domEX 4 forEX 5 domS 6 forS, 7 dom-domA, 8 for-forA, 9 for-domA, 10 dom-forA"
	assert x3!=.

* According to totstor: the largest foreign owner has more than 20% of shares
	* domestic and foreign entrants (1)and 2
	quietly gen x4=1 if entrycount==1 & exitcount==. & totstor==0
	quietly replace x4=2 if x4==. & entrycount==1 & exitcount==. & totstor>0
	* domestic and foreign exits (3)4
	quietly replace x4=3 if x4==. & exitcount==1 & entrycount==. & totstor==0
	replace x4=4 if x4==. & exitcount==1 & entrycount==. & totstor>0	
	* domestic and foreign stayers (5)6
	replace x4=5 if entrycount==. & exitcount==. & x4==. & totstor==0 & totstor[_n-1]==0 & bnr==bnr[_n-1]
	replace x4=6 if entrycount==. & exitcount==. & x4==. & totstor>0 & totstor[_n-1]>0 & bnr==bnr[_n-1]
	*first year obs for stayers
	replace x4=5 if entrycount==. & exitcount==. & x4==. & n==1 & totstor==0 & totstor[_n+1]==0 & bnr==bnr[_n+1]
	replace x4=6 if entrycount==. & exitcount==. & x4==. & n==1 & totstor>0 & totstor[_n+1]>0 & bnr==bnr[_n+1]
	replace x4=5 if entrycount==. & exitcount==. & x4==. & n==1 & totstor==0 & bnr==bnr[_n+1] & aar<=1992
	replace x4=6 if entrycount==. & exitcount==. & x4==. & n==1 & totstor>0 & bnr==bnr[_n+1] & aar<=1992
	assert x4!=. if n==1 
	* domestic-domestic acquisitions
	replace x4=7 if x4==5 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	* foreign-foreign acquisitions
	replace x4=8 if x4==6 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	* foreign-domestic acquisitions
	replace x4=9 if entrycount==. & exitcount==. & x4==. & totstor==0 & totstor[_n-1]>0 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	replace x4=9 if entrycount==. & exitcount==. & x4==. & totstor==0 & totstor[_n-1]>0 & bnr==bnr[_n-1]
	* domestic-foreign acquisitions
	replace x4=10 if entrycount==. & exitcount==. & x4==. & totstor>0 & totstor[_n-1]==0 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	replace x4=10 if entrycount==. & exitcount==. & x4==. & totstor>0 & totstor[_n-1]==0 & bnr==bnr[_n-1]
	label var x4 "as x3 but based on largest foreign owner-share"


* According to totutenl: the sum of foreign owners have more than 50% of shares
	* domestic and foreign entrants (1)and 2
	gen fo=(totutenl==1)
	quietly gen x5=1 if entrycount==1 & exitcount==. & fo==0
	quietly replace x5=2 if x5==. & entrycount==1 & exitcount==. & fo==1
	* domestic and foreign exits (3)4
	quietly replace x5=3 if x5==. & exitcount==1 & entrycount==. & fo==0
	replace x5=4 if x5==.& exitcount==1 & entrycount==. & fo==1	
	* domestic and foreign stayers (5)6
	replace x5=5 if entrycount==. & exitcount==. & x5==. & fo==0 & fo[_n-1]==0 & bnr==bnr[_n-1]
	replace x5=6 if entrycount==. & exitcount==. & x5==. & fo==1 & fo[_n-1]==1 & bnr==bnr[_n-1]
	*first year obs for stayers
	replace x5=5 if entrycount==. & exitcount==. & x5==. & n==1 & fo==0 & fo[_n+1]==0 & bnr==bnr[_n+1]
	replace x5=6 if entrycount==. & exitcount==. & x5==. & n==1 & fo==1 & fo[_n+1]==1 & bnr==bnr[_n+1]
	replace x5=5 if entrycount==. & exitcount==. & x5==. & n==1 & fo==0 & bnr==bnr[_n+1] & aar<=1992
	replace x5=6 if entrycount==. & exitcount==. & x5==. & n==1 & fo==1 & bnr==bnr[_n+1] & aar<=1992
	assert x5!=. if n==1 
	* domestic-domestic acquisitions
	replace x5=7 if x5==5 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	* foreign-foreign acquisitions
	replace x5=8 if x5==6 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	* foreign-domestic acquisitions
	replace x5=9 if entrycount==. & exitcount==. & x5==. & fo==0 & fo[_n-1]==1 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	replace x5=9 if entrycount==. & exitcount==. & x5==. & fo==0 & fo[_n-1]==1 & bnr==bnr[_n-1]
	* domestic-foreign acquisitions
	replace x5=10 if entrycount==. & exitcount==. & x5==. & fo==1 & fo[_n-1]==0 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	replace x5=10 if entrycount==. & exitcount==. & x5==. & fo==1 & fo[_n-1]==0 & bnr==bnr[_n-1]
	label var x5 "as x3, based on 50% foreign ownership threshold"

	drop fo
* According to totstor: the largest foreign owner has more than 50% of shares
	gen fo=(totstor==1)
	* domestic and foreign entrants (1)and 2
	quietly gen x6=1 if entrycount==1 & exitcount==. & fo==0
	quietly replace x6=2 if x6==. & entrycount==1 & exitcount==. & fo==1
	* domestic and foreign exits (3)4
	quietly replace x6=3 if x6==. & exitcount==1 & entrycount==. & fo==0
	replace x6=4 if x6==. & exitcount==1 & entrycount==. & fo==1	
	* domestic and foreign stayers (5)6
	replace x6=5 if entrycount==. & exitcount==. & x6==. & fo==0 & fo[_n-1]==0 & bnr==bnr[_n-1]
	replace x6=6 if entrycount==. & exitcount==. & x6==. & fo==1 & fo[_n-1]==1 & bnr==bnr[_n-1]
	*first year obs for stayers
	replace x6=5 if entrycount==. & exitcount==. & x6==. & n==1 & fo==0 & fo[_n+1]==0 & bnr==bnr[_n+1]
	replace x6=6 if entrycount==. & exitcount==. & x6==. & n==1 & fo==1 & fo[_n+1]==1 & bnr==bnr[_n+1]
	replace x6=5 if entrycount==. & exitcount==. & x6==. & n==1 & fo==0 & bnr==bnr[_n+1] & aar<=1992
	replace x6=6 if entrycount==. & exitcount==. & x6==. & n==1 & fo==1 & bnr==bnr[_n+1] & aar<=1992
	assert x6!=. if n==1 
	* domestic-domestic acquisitions
	replace x6=7 if x6==5 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	* foreign-foreign acquisitions
	replace x6=8 if x6==6 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	* foreign-domestic acquisitions
	replace x6=9 if entrycount==. & exitcount==. & x6==. & fo==0 & fo[_n-1]==1 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	replace x6=9 if entrycount==. & exitcount==. & x6==. & fo==0 & fo[_n-1]==1 & bnr==bnr[_n-1]
	* domestic-foreign acquisitions
	replace x6=10 if entrycount==. & exitcount==. & x6==. & fo==1 & fo[_n-1]==0 & fnr!=fnr[_n-1] & bnr==bnr[_n-1]
	replace x6=10 if entrycount==. & exitcount==. & x6==. & fo==1 & fo[_n-1]==0 & bnr==bnr[_n-1]
	label var x6 "as x3 but based on largest foreign owner-share >50%"
	drop fo

	forvalues t=3/6 {
		assert x`t'!=. 
		tab aar  x`t'  if aar>1991 & aar<2005
	}
	* we will not use defs x3-x6 in 1990


* Look at correspondence between dummy for domestic mne and x3 x4
	tab x3 dommne if aar>1991 & aar<2005
	tab x4 dommne_stor if aar>1991 & aar<2005
	tab x5 dommne if aar>1991 & aar<2005
	tab x6 dommne_stor if aar>1991 & aar<2005

* Based on the tables above we should be able to argue that the dommne distinction is not interesting
* most of these are domestic survivors, 

	sort bnr aar
	drop n N
	save ${industri}empdecomppanel1_update.dta, replace
	* we keep 1990 in the panel only to generate change in
	* employment and TFP further on. Events based on totstor
	* can only be defined from 1991, since we don't have this
	* variable before 1990

log close
exit
