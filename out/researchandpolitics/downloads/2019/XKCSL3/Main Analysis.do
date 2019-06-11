********************************************************************************
********************************************************************************
****************** On the Measurement of Conspiracy Beliefs ********************
********************************************************************************
********************************************************************************

****
** Open "Raw Data.dta"
****

********************************************************************************

****
** Recode and construct variables
****

* Conspiratorial predispositions
gen noaccident = q26_1
replace noaccident = . if noaccident == 6
recode noaccident (1=4) (2=3) (7=2) (4=1) (5=0)

gen lies = q26_2
replace lies = . if lies == 6
recode lies (1=0) (2=1) (7=2) (4=3) (5=4)

gen secrets = q26_3
replace secrets = . if secrets == 6
recode secrets (1=4) (2=3) (7=2) (4=1) (5=0)

gen outsideint = q26_28
replace outsideint = . if outsideint == 6
recode outsideint (1=4) (2=3) (7=2) (4=1) (5=0)

factor noaccident-outsideint, ipf

gen conspiracism = noaccident + lies + secrets + outsideint


* Party identification 
gen pid1 = q27
gen pid2rep = q28
gen pid2dem = q29
gen pid2ind = q30

gen pid = -3 if pid2dem == 1
replace pid = -2 if pid2dem == 2
replace pid = -1 if pid2ind == 2
replace pid = 0 if pid2ind == 3
replace pid = 0 if pid2ind == 4
replace pid = 1 if pid2ind == 1
replace pid = 2 if pid2rep == 2
replace pid = 3 if pid2rep == 1

gen rep = 0 if pid == -3
replace rep = 0 if pid == -2
replace rep = 0 if pid == -1
replace rep = 1 if pid == 1
replace rep = 1 if pid == 2
replace rep = 1 if pid == 3

gen pidstrength = abs(pid)


* Ideology
gen ideo = q31 - 4
replace ideo = . if ideo > 3

gen conserv = 1 if ideo > 0
replace conserv = 0 if ideo < 0

gen ideostrength = abs(ideo)


* Conspiracy question wording experiment
gen fincrisis1 = q48
recode fincrisis1 (15=4) (16=3) (9=2) (10=1)
gen fincrisis2 = q68
recode fincrisis2 (15=4) (16=3) (9=2) (10=1)

gen banking1 = q66
recode banking1 (4=4) (6=3) (3=2) (2=1)
gen banking2 = q67
recode banking2 (4=4) (6=3) (3=2) (2=1)

gen jadehelm1 = q69
recode jadehelm1 (4=4) (5=3) (3=2) (2=1)
gen jadehelm2 = q71
recode jadehelm2 (4=4) (5=3) (3=2) (2=1)
	

* Education 
gen edu = q59


* Race
gen black = 0
replace black = 1 if q57 == 2

gen hispanic = 0
replace hispanic = 1 if q57 == 3


* Gender
gen female = q56 - 1


********************************************************************************

****
** Empirical analysis
****

* Sample characteristics, Table 1
sum pid ideo edu age female black


* Treatment effects, Table 2
gen fintreat = 0
replace fintreat = 1 if fincrisis2 != .
egen fincrisistot = rowmax(fincrisis1 fincrisis2)
reg fincrisistot fintreat rep conspiracism
reg fincrisistot i.rep##i.fintreat conspiracism

gen banktreat = 0
replace banktreat = 1 if banking2 != .
egen bankingtot = rowmax(banking1 banking2)
reg bankingtot banktreat rep conspiracism
reg bankingtot i.rep##i.banktreat conspiracism

gen jadetreat = 0
replace jadetreat = 1 if jadehelm2 != .
egen jadetot = rowmax(jadehelm1 jadehelm2)
reg jadetot jadetreat rep conspiracism
reg jadetot i.rep##i.jadetreat conspiracism


* Pairwise correlations between conspiracy beliefs, Table 3
pwcorr fincrisis1 fincrisis2 banking1 banking2 jadehelm1 jadehelm2


* Referenced supplemental analyses with conspiracism interactions
reg fincrisistot i.rep##i.fintreat c.conspiracism##i.fintreat

reg bankingtot i.rep##i.banktreat c.conspiracism##i.banktreat

reg jadetot i.rep##i.jadetreat c.conspiracism##i.jadetreat

