version 10
clear
set memory 400m
capture log close
set more off

***31.01.2006***RBal**************************************************
* Make tables with desc. stats of full time workers and their plants
* A. foreign versus domestic plants (20%)
* B. local versus foreign MNEs versus domestic MNEs
*********************************************************************
*** Rev 03.05.2006 * Make tenure into years
***REV 16.02.2009: New addition at end of file: based on referee comment:
* Make new table (workerchar3.tex) to replace table 2 in the paper. 

	use ${pap4data}wagereg1temp.dta
	* remember there are only full time workers in this panel
	replace eduy=9 if eduy==0 | eduy==.
	gen erf=max(0,age-eduy-7)
* Drop very low wages for full-time workers 
	drop if realwage<12000
	keep aar pid bnr realwage tenure erf age eduy  dommne formne v13 KINT LPROD skillshare femshare isic3
	rename KINT kint
	rename LPROD lp
	* labour productivity and capital intesity are not in logs
* Tenure into years
	replace tenure=tenure/12
	gen MNE=2 if dommne==1
	replace MNE=1 if formne==1
	replace MNE=0 if formne!=1 & dommne!=1
	assert MNE!=.

	save ${pap4data}temp2.dta, replace

/*
* A.
* Compare foreign versus domestic unconditional averages
* put them in a matrix table that can be exported to tex.file
* 2 variables should be collapsed by plant and totutenl;
* femshare and skillshare
	#delimit ;
 	collapse (mean) realwage tenure erf age eduy 
		(sd) x1=realwage x2=tenure x3=erf x4=age x5=eduy  
		(count) N1=realwage N2=tenure N3=erf N4=age N5=eduy, by(FD);
	#delimit cr
	mkmat realwage tenure erf age eduy if FD==0, matrix(A)
	matrix A1=A'
	matrix colname A1="Dommean"
	matrix rownames A1="Realwage" "Tenure" "Experience" "Age" "Education" 
	mkmat x1 x2 x3 x4 x5 if FD==0, matrix(B)
	matrix B1=B'
	matrix colname B1="Domsd"
	mkmat N1 N2 N3 N4 N5 if FD==0, matrix(C)
	matrix C1=C'
	matrix colname C1="DomN"
	mkmat realwage tenure erf age eduy if FD==1, matrix(D)
	matrix D1=D'
	matrix colname D1="Formean"
	mkmat x1 x2 x3 x4 x5 if FD==1, matrix(E)
	matrix E1=E'
	matrix colname E1="Forsd"
	mkmat N1 N2 N3 N4 N5 if FD==1, matrix(F)
	matrix F1=F'
	matrix colname F1="ForN"
* Put the matrices togehter into ""
	matrix G=A1,B1,C1,D1,E1,F1
* Part of the table with plant level characteristics
	matrix drop A B C D E F
	use ${pap4data}temp2.dta, clear
	bys bnr aar: gen n=_n
	keep if n==1
	keep aar bnr FD dommne formne v13 lp kint skillshare femshare
	#delimit ;
	collapse (mean) v13 lp kint skillshare femshare 
		(sd) x1=v13 x2=lp x3=kint x4=skillshare x5=femshare  
		(count) N1=v13 N2=lp N3=kint N4=skillshare N5=femshare, by(FD);
	#delimit cr
	mkmat v13 lp kint skillshare femshare if FD==0, matrix(A)
	matrix A2=A'
	matrix rownames A2="Size" "LP" "Kint" "Skillshare" "Femshare" 
	mkmat x1 x2 x3 x4 x5 if FD==0, matrix(B)
	matrix B2=B'
	mkmat N1 N2 N3 N4 N5 if FD==0, matrix(C)
	matrix C2=C'
	mkmat v13 lp kint skillshare femshare if FD==1, matrix(D)
	matrix D2=D'
	mkmat x1 x2 x3 x4 x5 if FD==1, matrix(E)
	matrix E2=E'
	mkmat N1 N2 N3 N4 N5 if FD==1, matrix(F)
	matrix F2=F'
* Put the matrices togehter into ""
	matrix H=A2,B2,C2,D2,E2,F2
	matrix J=G\H
	matrix list J
* Export as table
	outtable using ${pap4tab}workerchar1, mat(J) nobox center f(%9.2f) replace caption("Worker and plant characteristics 1990-2000: foreign and domestic plants")
	matrix drop _all
*/

* B.
* Similar table as above, but this time distinguishing 
* local domestic, foregn MNEs and domestic MNEs
	use ${pap4data}temp2.dta, clear
	keep aar pid realwage tenure erf age eduy MNE	
	#delimit ;
 	collapse (mean) realwage tenure erf age eduy 
		(sd) x1=realwage x2=tenure x3=erf x4=age x5=eduy  
		(count) N1=realwage N2=tenure N3=erf N4=age N5=eduy, by(MNE);
	#delimit cr
	mkmat realwage tenure erf age eduy if MNE==0, matrix(A)
	matrix A1=A'
	matrix colname A1="Dommean"
	matrix rownames A1="Realwage" "Tenure" "Experience" "Age" "Education" 
	mkmat x1 x2 x3 x4 x5 if MNE==0, matrix(B)
	matrix B1=B'
	matrix colname B1="Domsd"
	mkmat N1 N2 N3 N4 N5 if MNE==0, matrix(C)
	matrix C1=C'
	matrix colname C1="DomN"
	mkmat realwage tenure erf age eduy if MNE==1, matrix(D)
	matrix D1=D'
	matrix colname D1="Formnemean"
	mkmat x1 x2 x3 x4 x5 if MNE==1, matrix(E)
	matrix E1=E'
	matrix colname E1="Formnesd"
	mkmat N1 N2 N3 N4 N5 if MNE==1, matrix(F)
	matrix F1=F'
	matrix colname F1="FormneN"
	mkmat realwage tenure erf age eduy if MNE==2, matrix(G)
	matrix G1=G'
	matrix colname G1="Dommnemean"
	mkmat x1 x2 x3 x4 x5 if MNE==2, matrix(H)
	matrix H1=H'
	matrix colname H1="Dommnesd"
	mkmat N1 N2 N3 N4 N5 if MNE==2, matrix(I)
	matrix I1=I'
	matrix colname I1="DommneN"
* Put the matrices togehter into ""
	matrix J=A1,B1,C1,D1,E1,F1,G1,H1,I1
	matrix drop A B C D E F G H I
* Plant characteristics
	use ${pap4data}temp2, clear
	bys bnr aar: gen n=_n
	keep if n==1
	keep aar bnr MNE v13 lp kint skillshare femshare
	#delimit ;
	collapse (mean) v13 lp kint skillshare femshare 
		(sd) x1=v13 x2=lp x3=kint x4=skillshare x5=femshare  
		(count) N1=v13 N2=lp N3=kint N4=skillshare N5=femshare, by(MNE);
	#delimit cr
	mkmat v13 lp kint skillshare femshare if MNE==0, matrix(A)
	matrix A2=A'
	matrix rownames A2="Size" "LP" "Kint" "Skillshare" "Femshare" 
	mkmat x1 x2 x3 x4 x5 if MNE==0, matrix(B)
	matrix B2=B'
	mkmat N1 N2 N3 N4 N5 if MNE==0, matrix(C)
	matrix C2=C'
	mkmat v13 lp kint skillshare femshare if MNE==1, matrix(D)
	matrix D2=D'
	mkmat x1 x2 x3 x4 x5 if MNE==1, matrix(E)
	matrix E2=E'
	mkmat N1 N2 N3 N4 N5 if MNE==1, matrix(F)
	matrix F2=F'
	mkmat v13 lp kint skillshare femshare if MNE==2, matrix(G)
	matrix G2=G'
	mkmat x1 x2 x3 x4 x5 if MNE==2, matrix(H)
	matrix H2=H'
	mkmat N1 N2 N3 N4 N5 if MNE==2, matrix(I)
	matrix I2=I'
* Put the matrices togehter into ""
	matrix K=A2,B2,C2,D2,E2,F2,G2,H2,I2
	matrix M=J\K
	matrix list M
* Export as table
	outtable using ${pap4tab}workerchar2, mat(M) nobox center f(%10.2f) replace caption("Worker and plant characteristics: means of annual values 1990-2000")

************************
* NEW FEB 2009 for revision. Based on comments from referee
* make table showing deviations from industry means
	
* Columns with nonMNE means and standard deviations,
* save for use in new and revised table with MNE entries as deviations
* from nonMNE means
* Count numbers of individuals and add as row to col vektors above
	use ${pap4data}temp2.dta, clear
	keep aar pid realwage tenure erf age eduy MNE	
 	collapse (count) realwage tenure erf age eduy, by(MNE) 
	sort MNE
	egen N=rowmin(realwage tenure erf age eduy)
	*egen tot=sum(N)
	mkmat N if MNE==0, mat(a)
	matrix rownames a= "N"
	matrix A=A1\a
	matrix B=B1\a
	matrix localind=A,B
	mkmat N if MNE==1, mat(nMNE1)
	mkmat N if MNE==2, mat(nMNE2)


* Count plant numbers
	use ${pap4data}temp2, clear
	bys bnr aar: gen n=_n
	keep if n==1
	keep v13 lp kint skillshare femshare MNE	
 	collapse (count) v13 lp kint skillshare femshare, by(MNE) 
	sort MNE
	egen N=rowmin(v13 lp kint skillshare femshare)
	*egen tot=sum(N)
	mkmat N if MNE==0, mat(a)
	matrix rownames a="N"
	matrix A=A2\a
	matrix B=B2\a
	matrix localplant=A,B
	mkmat N if MNE==1, mat(nMNE1p)
	mkmat N if MNE==2, mat(nMNE2p)
	* 6 mats for further use: localind localplant nMNE1 nMNE2 nMNE1p nMNE2p	
	* the last 4 are 1x1


* Generate industry-year average of nonMNEs and plant deviation from
* industry-year averages of nonMNEs: individual characteristics
	use ${pap4data}temp2.dta, clear
	keep aar pid realwage tenure erf age eduy isic3	MNE
	foreach t in realwage tenure erf age eduy {
		bys aar isic3: egen m`t'=mean(`t') if MNE==0
		bys aar isic3: egen m3`t'=mean(m`t')
		gen dev`t'=`t'-m3`t'
		drop `t'
		rename dev`t' `t'
	}
	keep aar pid realwage tenure erf age eduy MNE	
	#delimit ;
 	collapse (mean) realwage tenure erf age eduy 
		(sd) x1=realwage x2=tenure x3=erf x4=age x5=eduy  
		(count) N1=realwage N2=tenure N3=erf N4=age N5=eduy, by(MNE);
	#delimit cr
	mkmat realwage tenure erf age eduy if MNE==0, matrix(A)
	matrix A1=A'
	matrix colname A1="Dommean"
	*matrix rownames A1="Realwage" "Tenure" "Experience" "Age" "Education" 
	mkmat x1 x2 x3 x4 x5 if MNE==0, matrix(B)
	matrix B1=B'
	matrix colname B1="Domsd"
	*mkmat N1 N2 N3 N4 N5 if MNE==0, matrix(C)
	*matrix C1=C'
	*matrix colname C1="DomN"
	mkmat realwage tenure erf age eduy if MNE==1, matrix(D)
	matrix D1=D'\nMNE1
	matrix colname D1="Formnemean"
	mkmat x1 x2 x3 x4 x5 if MNE==1, matrix(E)
	matrix E1=E'\nMNE1
	matrix colname E1="Formnesd"
	*mkmat N1 N2 N3 N4 N5 if MNE==1, matrix(F)
	*matrix F1=F'
	*matrix colname F1="FormneN"
	mkmat realwage tenure erf age eduy if MNE==2, matrix(G)
	matrix G1=G'\nMNE2
	matrix colname G1="Dommnemean"
	mkmat x1 x2 x3 x4 x5 if MNE==2, matrix(H)
	matrix H1=H'\nMNE2
	matrix colname H1="Dommnesd"
	*mkmat N1 N2 N3 N4 N5 if MNE==2, matrix(I)
	*matrix I1=I'
	*matrix colname I1="DommneN"

* Put the matrices togehter into ""
	matrix J=localind,D1,E1,G1,H1
	matrix list J

* Plant characteristics: deviations from 3digit ind-y mean of nonMNEs
	use ${pap4data}temp2, clear

	bys bnr aar: gen n=_n
	keep if n==1
* Make deviations:
	keep aar v13 lp kint skillshare femshare isic3 MNE
	foreach t in v13 lp kint skillshare femshare {
		bys aar isic3: egen m`t'=mean(`t') if MNE==0
		bys aar isic3: egen m3`t'=mean(m`t')
		gen dev`t'=`t'-m3`t'
		drop `t'
		rename dev`t' `t'
	}
	keep aar MNE v13 lp kint skillshare femshare
	#delimit ;
	collapse (mean) v13 lp kint skillshare femshare 
		(sd) x1=v13 x2=lp x3=kint x4=skillshare x5=femshare  
		(count) N1=v13 N2=lp N3=kint N4=skillshare N5=femshare, by(MNE);
	#delimit cr
	*mkmat v13 lp kint skillshare femshare if MNE==0, matrix(A)
	*matrix A2=A'
	*matrix rownames A2="Size" "LP" "Kint" "Skillshare" "Femshare" 
	*mkmat x1 x2 x3 x4 x5 if MNE==0, matrix(B)
	*matrix B2=B'
	*mkmat N1 N2 N3 N4 N5 if MNE==0, matrix(C)
	*matrix C2=C'
	mkmat v13 lp kint skillshare femshare if MNE==1, matrix(D)
	matrix D2=D'\nMNE1p
	mkmat x1 x2 x3 x4 x5 if MNE==1, matrix(E)
	matrix E2=E'\nMNE1p
	*mkmat N1 N2 N3 N4 N5 if MNE==1, matrix(F)
	*matrix F2=F'
	mkmat v13 lp kint skillshare femshare if MNE==2, matrix(G)
	matrix G2=G'\nMNE2p
	mkmat x1 x2 x3 x4 x5 if MNE==2, matrix(H)
	matrix H2=H'\nMNE2p
	*mkmat N1 N2 N3 N4 N5 if MNE==2, matrix(I)
	*matrix I2=I'
* Put the matrices togehter into ""
	matrix K=localplant,D2,E2,G2,H2
	matrix M=J\K
	matrix list M
* Export as table
	outtable using ${pap4tab}workerchar3, mat(M) nobox center f(%10.2f) replace caption("Worker and plant characteristics: means of annual values 1990-2000")

	matrix drop _all


* Regresjonsbasert analyse med års og industri dummyer
	 log using ${pap4log}workercharacteristics, text replace

	use ${pap4data}temp2.dta, clear
* Individ karakteristika
	keep aar pid realwage tenure erf age eduy isic3	MNE
	gen dmne=(MNE==2)
	gen fmne=(MNE==1)
	foreach t in realwage tenure erf age eduy {
	qui xi: reg `t' dmne fmne i.aar i.isic3, cl(pid)
	est store `t'
	}
estimates table realwage tenure erf age eduy , keep(fmne dmne _cons) stats(N r2) star

* Plant karakteristika
	use ${pap4data}temp2.dta, clear
	bys bnr aar: gen n=_n
	keep if n==1
	keep aar bnr v13 lp kint skillshare femshare isic3 MNE
	gen dmne=(MNE==2)
	gen fmne=(MNE==1)
	foreach t in v13 lp kint skillshare femshare {
	qui xi: reg `t' dmne fmne i.aar i.isic3, cl(bnr)
	est store `t'
	}
estimates table v13 lp kint skillshare femshare, keep(fmne dmne _cons) stats(N r2) star

	erase ${pap4data}temp2.dta

capture log close 
exit








