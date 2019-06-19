version 8
clear
set memory 500m
capture log close
log using ${pap4log}movers_info1, text replace
set more off

***15.04.2006***RBal**************************************************
* Comparing movers and non-movers: split the movers in 4 groups
* and compare characteristics (among those wagegrowth) for movers 
* the year they move with means of the same characteristics of 2 
* groups of stayers (within MNEs and non-MNEs). Export a table:wagechange
********************************************************************
*** Rev 03.05.2006 * Make tenure in years


* 1.
	use ${pap4data}wagereg1temp.dta
* Tenure into years
	replace tenure=tenure/12

* Individuals who are in the same plant all years; z==0
	sort pid aar
	quietly bys pid: gen n=_n
	quietly bys pid: gen N=_N
	quietly bys pid: egen z=sd(bnr)
	quietly replace z=0 if N==1
* Drop individuals observed only once
	drop if N==1
* Group 5 educational categories into 3
	quietly replace education=1 if education==0
	quietly replace education=3 if education==4
* MNE indicator: just MNE vs nonMNE
	quietly gen MNE=1 if dommne==1
	quietly replace MNE=1 if formne==1
	quietly replace MNE=0 if MNE==.
* Count the number of times people move, but this time only
* moves from 1 year to the next
	tsset pid aar
	gen move=1 if pid==L.pid & bnr!=L.bnr
	bys pid: egen nmove=sum(move)
	tab nmove if n==N
* Drop the individuals with 3 or more moves 
	drop if nmove>=3
* Indicator for the year before and after move
	gen x=1 if F.move==1 & pid==F.pid
	replace x=1 if L.move==1 & pid==L.pid 
	replace x=1 if move==1
	bys pid: egen countx=sum(x)
	tab countx if n==N & countx>0
* Record the direction of each move (recorded first year after move)
	* Simplify movedir to 4 categories :
	* 0: between non_MNEs, 1 from nonMNEs to MNEs
	* 2: from MNEs to non-MNEs, 3, between MNEs
	gen movedir=0 if move==1 & MNE==0 & L.MNE==0
	replace movedir=1 if movedir==. & move==1 & MNE==1 & L.MNE==0
	replace movedir=2 if movedir==. & move==1 & MNE==0 & L.MNE==1
	replace movedir=3 if movedir==. & move==1 & MNE==1 & L.MNE==1
	assert movedir!=. if move==1
* Generate indicator for always nonMNE stayer
	bys pid: egen x1=max(MNE)
	count if x1==0 & z==0 & n==N
* Generate indicator for MNE stayer
	bys pid: egen y=min(MNE)
	count if y==1 & z==0 & n==N
	gen MNEstay=0 if x1==0 & z==0
	replace MNEstay=1 if y==1 & z==0
* keep all obs of MNE and nonMNE stayers, and obs of move==1
* the year before and after move
	keep if MNEstay!=. | x==1
	drop n N x1 y
	quietly bys pid: gen n=_n
	quietly bys pid: gen N=_N
	count if n==N
	count if MNEstay==0 & n==N 
	count if MNEstay==1 & n==N 
	count if x==1 & N==n
	sort pid aar
* Indicator for the 2 groups of stayers and 4 groups of movers
	gen ind=movedir
	replace ind=4 if MNEstay==0
	replace ind=5 if MNEstay==1
* Generate variable for characteristics
	gen erf=max(0,age-eduy-7)
* Drop very low wages for full-time workers 
	drop if realwage<12000
* Generate lagged realwage and wagechange
	sort pid aar
	gen lag=L.realwage
	gen dw=((realwage-lag)/lag)*100
	keep aar pid bnr realwage lag dw tenure erf age eduy v13 ind
* Generate change in plant size
	bys bnr aar: egen totv13=count(pid)
	replace v13=totv13 if totv13>v13 & totv13!=.
	sort pid aar

	gen lv13=L.v13
	gen dv13=((v13-lv13)/lv13)*100
	foreach t in tenure age eduy erf {
		gen l`t'=L.`t'
	}

	save ${pap4data}movetemp.dta, replace

* What is the average wage growth for all individuals in the panel?
	sum dw


	* labour productivity is not in logs 
	

* A.
* Make tables comparing wages and wagegrowth of 4 different
* types of movers and 2 groups of stayers

	use ${pap4data}movetemp.dta, clear

	#delimit ;
 	collapse (mean) aar realwage lag dw ltenure lerf lage leduy dv13
		(sd) x1=aar x2=realwage x3=lag x4=dw x5=ltenure x6=lerf x7=lage x8=leduy x9=dv13 
		(count) N1=aar N2=realwage N3=lag N4=dw N5=ltenure N6=lerf N7=lage N8=leduy N9=dv13, by(ind);
	#delimit cr
	drop if ind==.
forvalues t=0/5 {
	mkmat aar realwage lag dw ltenure lerf lage leduy dv13 if ind==`t', matrix(A)
	matrix A1=A'
	matrix colname A1="Move`t'"
	mkmat x1 x2 x3 x4 x5 x6 x7 x8 x9 if ind==`t', matrix(B)
	matrix B1=B'
	matrix colname B1="SD`t'"
	mkmat N1 N2 N3 N4 N5 N6 N7 N8 N9 if ind==`t', matrix(C)
	matrix C1=C'
	matrix colname C1="N`t'"
	matrix part`t'=A1,B1,C1
}

	matrix A=part0,part1,part2
	matrix rownames A="Year" "Realwage" "Lagwage" "Wagegrowth" "lTenure" "lExperience" "lAge" "lEducation" "Dv13" 
	matrix list A
	matrix B=part3,part4,part5
	matrix rownames B="Year" "Realwage" "Lagwage" "Wagegrowth" "lTenure" "lExperience" "lAge" "lEducation" "Dv13" 
	matrix list B

* Not necessary to put all these variables into a table?
	egen z=rmin(N1 N2 N3 N4 N5 N6 N7 N8 N9)
	sort ind
	mkmat lag realwage dw ltenure lage leduy z , matrix(A)
	matrix list A
	matrix B=A'
	matrix colname B="Between_non-MNEs" "From_non-MNE_to_MNE" "From_MNE_to_non-MNE" "Between_MNEs" "Non-MNE_stayers" "MNE_stayers"
	matrix rowname B="Wage_before_move" "Wage_after_move" "Wagechange" "Tenure" "Age" "Education" "N"
	matrix list B
	outtable using ${pap4tab}wagechange, mat(B) nobox center f(%6.1f) replace caption("Characteristics of movers and stayers")



* B.
* Tried to repeat A by defining the movers not strictly from t-1 to t,
* but instead using the [_n-1] operator: this generates very
* different wagegrowth because we now have some movers where we 
* calc wagegrowth over 2 years, etc. Thus not a good idea to do this.




matrix drop _all
erase ${pap4data}movetemp.dta
capture log close
exit
