version 8
clear
set memory 500m
capture log close
capture program drop _all
log using ${pap4log}movers4, text replace

* 1. Info on no of individuals, how many stay in same plant
* 2. Keep only movers and generate experience from MNEs 
*  and direction of moves
* 3. Table of the direction of moves: simple and extended version.
* 4. Info of moves across sectors
***********************************************************************


* 1.
	use ${pap4data}wagereg1temp.dta

* Count individuals who are in the same plant all years
	sort pid aar
	quietly bys pid: gen n=_n
	quietly bys pid: gen N=_N
	quietly bys pid: egen z=sd(bnr)
	quietly replace z=0 if N==1
	
* "Total Number of matched observations"
	count
* "Total number of different individuals"
	count if n==N
* "and how many years they are observed"
	tab N if n==N
	tab N
* Individuals only observed once
	count if n==N & N==1
* "Total number of observations always in the same plant"
	count if z==0
* "Number of individuals always in the same plant"
	count if z==0 & n==N
* Individuals always in the same plant and observed more than once
	count if z==0 & n==N & N>1
* Individuals that move
	count if z>0 & n==N
* Group 5 educational categories into 3
	quietly replace education=1 if education==0
	quietly replace education=3 if education==4
* MNE indicators
	quietly gen MNE=2 if dommne==1
	quietly replace MNE=1 if formne==1
	quietly replace MNE=0 if MNE==.
* Generate indicator for experience from allMNE, dom and for MNE
	gen erf=1 if MNE!=0
	gen erfdom=1 if MNE==2
	gen erffor=1 if MNE==1

* 2.
* Drop those individuals who always stay in the same plant
	quietly drop if z==0
	count 
	count if n==N
	gen FD=(totutenl>0)
	keep aar pid bnr FD education MNE n N erf*
* Accumulated experience from MNEs for each individual
	bys pid: gen exp=sum(erf)
	assert exp!=.
	bys pid: gen expdom=sum(erfdom)
	assert expdom!=.
	bys pid: gen expfor=sum(erffor)
	assert expfor!=.
* Individuals with exp==0 have moved only between nonMNEs
	count if exp==0 & n==N
* movers only within MNEs
	count if exp==N & n==N
	count if expdom==N & n==N
	count if expfor==N & n==N

* Count the number of times people move
	sort pid aar
	gen move=1 if pid==pid[_n-1] & bnr!=bnr[_n-1]
	bys pid: egen nmove=sum(move)
	tab nmove if n==N
* Drop the individuals with 3 or more moves (still left with
* 95% of movers)
	*drop if nmove>=3
	tab MNE

* Count number of moves in total (about 100 000)
	count if move==1
* Record the direction of each move
	gen movedir=0 if move==1 & MNE==0 & MNE[_n-1]==0
	replace movedir=1 if movedir==. & move==1 & MNE==1 & MNE[_n-1]==0
	replace movedir=2 if movedir==. & move==1 & MNE==2 & MNE[_n-1]==0
	replace movedir=3 if movedir==. & move==1 & MNE==1 & MNE[_n-1]==2
	replace movedir=4 if movedir==. & move==1 & MNE==0 & MNE[_n-1]==2
	replace movedir=5 if movedir==. & move==1 & MNE==2 & MNE[_n-1]==1
	replace movedir=6 if movedir==. & move==1 & MNE==0 & MNE[_n-1]==1
	replace movedir=7 if movedir==. & move==1 & MNE==1 & MNE[_n-1]==1
	replace movedir=8 if movedir==. & move==1 & MNE==2 & MNE[_n-1]==2
* 0=nonMNE to nonMNE, 1 nonMNE to forMNE, 2 nonMNE to domMNE
* 3 domMNE to forMNE, 4 domMNE to nonMNE, 5 forMNE to domMNE
* 6 forMNE to nonMNE, 7 forMNE to forMNE, 8 domMNE to domMNE
	assert movedir!=. if move==1
	tab movedir 
* Simplify movedir to 4 categories :
* 0: between non_MNEs, 1 from nonMNEs to MNEs
* 2: from MNEs to non-MNEs, 3, between MNEs
	gen movedir2=0 if movedir==0
	replace movedir2=1 if movedir==1 | movedir==2
	replace movedir2=2 if movedir==4 | movedir==6
	replace movedir2=3 if movedir==3 | movedir==5 | movedir==7 | movedir==8
	assert movedir2!=. if move==1
	sort pid aar
	save ${pap4data}movetemp.dta, replace

* 3.
program define direction
* Collapse to count the number of moves in each direction
* by education
	collapse (count) pid, by(movedir education)
	drop if movedir==.
* Count total moves, and by education

	egen tot=sum(pid)
	bys education: egen toted=sum(pid)
* Count total moves by direction
	bys movedir: egen totdir=sum(pid)	
* Generate total shares
	gen share= (totdir/tot)*100
* Generate shares by education
	gen shareed=(pid/toted)*100


* Put the data into a matrix table
	sort movedir education

mkmat share if education==1, mat(A1)
mkmat tot if education==1 & movedir==0, mat(A2)
matrix A=A1\A2

mkmat shareed if education==1, mat(B1)
mkmat toted if education==1 & movedir==0, mat(B2)
matrix B=B1\B2

mkmat shareed if education==2, mat(C1)
mkmat toted if education==2 & movedir==0, mat(C2)
matrix C=C1\C2

mkmat shareed if education==3, mat(D1)
mkmat toted if education==3 & movedir==0, mat(D2)
matrix D=D1\D2

matrix E=A,B,C,D
matrix colnames E=All 1 2 3
end
direction
#delimit ;
matrix rownames E="Within_non-MNEs"  "From_non-MNE_to_foreign_MNE"  "From_non-MNE_to_domestic_MNE" 
 "From_domestic_MNE_to_foreign_MNE"  "From_domestic_MNE_to_non-MNE"  "From_foreign_MNE_to_domestic_MNE"  
"From_foreign_MNE_to_non-MNE"  "Within_foreign_MNEs" "Within_domestic_MNEs";
#delimit cr
matrix list E
outtable using ${pap4tab}movers, mat(E) nobox center f(%9.2f) replace caption("Direction of mobility for incidents of plant change")

* Simplified table
	use ${pap4data}movetemp.dta, clear
	drop movedir
	rename movedir2 movedir
	direction
#delimit ;
matrix rownames E="Between_non-MNEs"  "From_non-MNE_to_MNE"  "From_MNE_to_non-MNE" 
 "Between_MNEs" "Total_moves";
#delimit cr
matrix list E
outtable using ${pap4tab}movers_simple, mat(E) nobox center f(%9.2f) replace caption("Direction of mobility for incidents of plant change")


* 4. 
* Need to merge in variable naering
	forvalues t=1990/2000 {
		use ${pap4data}match`t'.dta, clear
		keep aar pid naering
		sort pid aar
		save ${pap4data}temp`t'.dta, replace
	}
	use ${pap4data}temp1990.dta, clear
	forvalues t=1991/2000 {
		append using ${pap4data}temp`t'.dta
	}
	sort pid aar
	merge pid aar using ${pap4data}movetemp.dta
	tab _merge
	assert _merge!=2
	keep if _merge==3
	drop _merge
	gen isic4=int(naering/10)
	gen isic3=int(naering/100)
	gen isic2=int(naering/1000)
	save ${pap4data}movetemp.dta, replace
	forvalues t=1990/2000 {
		erase ${pap4data}temp`t'.dta
	}
	assert naering!=.

* Generate indicator for moves within or across sectors
	use ${pap4data}movetemp.dta, clear
	sort pid aar
	gen withinsect=4 if move==1 & isic4==isic4[_n-1]
	replace withinsect=3 if move==1 & isic3==isic3[_n-1] & withinsect==.
	replace withinsect=2 if move==1 & isic2==isic2[_n-1] & withinsect==.
	count if withinsect!=.
	replace withinsect=0 if move==1 & withinsect==.
	collapse (count) pid, by(education withinsect)
	drop if withinsect==.

* Count total moves, and by education
	egen tot=sum(pid)
	bys education: egen toted=sum(pid)
* Replace withinsect 2 and 3 with correct numbers
	bys education: egen sect2=sum(pid) if withinsect!=0
	bys education: egen sect3=sum(pid) if withinsect>2
	replace pid=sect2 if withinsect==2
	replace pid=sect3 if withinsect==3
* total moves by sector
	bys withinsect: egen totsect=sum(pid)
* Generate total share moves with sectors
	gen share= (totsect/tot)*100
* Generate shares by education
	gen shareed=(pid/toted)*100

list

* Data not worth putting into a table. 



erase ${pap4data}movetemp.dta
capture log close
exit
