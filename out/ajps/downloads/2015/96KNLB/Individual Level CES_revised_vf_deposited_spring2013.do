clear
clear matrixset mem 100mset mat 800use "/Users/peterjohnloewen/Dropbox/PMB 1/AJPS/Final Data and Do Files/CES_DATA.dta"
**creating user ID
gen RANK=runiform()
egen ID=rank(RANK), unique 
gen panel=0replace panel=1 if ces08_idnum~=. & survey~=.

gen ELECTION2006=0 if ces06_pes_a1==.
replace ELECTION2006=1 if ces06_pes_a1~=.

gen ELECTION2008=0 if ces08_pes_a1==.
replace ELECTION2008=1 if ces08_pes_a1~=.**determining if respondents liked a local candidategen LOCAL08=.replace LOCAL08=0 if ces08_pes_b8d==5replace LOCAL08=0 if ces08_pes_b8d==8replace LOCAL08=1 if ces08_pes_b8d==1gen LOCAL06=.replace LOCAL06=0 if ces06_pes_i1==5replace LOCAL06=0 if ces06_pes_i1 ==8replace LOCAL06=1 if ces06_pes_i1 ==1**determining party of the candidate they likedgen LOCALLIKE08="CON" if ces08_pes_b8e==2replace LOCALLIKE08="LIB" if ces08_pes_b8e==1replace LOCALLIKE08="NDP" if ces08_pes_b8e==3replace LOCALLIKE08="BQ" if ces08_pes_b8e==4gen LOCALLIKE06="CON" if ces06_pes_i2 ==2replace LOCALLIKE06="LIB" if ces06_pes_i2 ==1replace LOCALLIKE06="NDP" if ces06_pes_i2 ==3replace LOCALLIKE06="BQ" if ces06_pes_i2 ==4**generating variable to determine if they liked the incumbent government candidategen INCUMBENTLIKE06=.replace INCUMBENTLIKE06=0 if lib2006==1 & LOCALLIKE06~="LIB"  replace INCUMBENTLIKE06=1 if lib2006==1 & LOCALLIKE06=="LIB"gen INCUMBENTLIKE08=.replace INCUMBENTLIKE08=0 if con2008==1 & LOCALLIKE08~="CON" replace INCUMBENTLIKE08=1 if con2008==1 & LOCALLIKE08=="CON"**indicator of government incumbent
gen gov=0 if lib2006==0 & ELECTION2006==1
replace gov=0 if con2008==0  & ELECTION2008==1
replace gov=1 if lib2006==1 & ELECTION2006==1
replace gov=1 if con2008==1 & ELECTION2008==1

label variable lib2006 "Government Incumbent 2006"
label variable con2008 "Government Incumbent 2008"
label variable INCUMBENTLIKE06 "Incumbent preferred locally 2006"
label variable INCUMBENTLIKE08 "Incumbent preferred locally 2008"
label variable p2p2006 "Proposal power 2006"
label variable p2p2008 "Proposal power 2008"
label define YN 0 "No" 1 "Yes"


label values  lib2006 con2008 INCUMBENTLIKE06 INCUMBENTLIKE08 p2p2006 p2p2008 YN
**Final Analysis
tab INCUMBENTLIKE06 p2p2006 if lib2006==1 & ELECTION2006==1, col chitab INCUMBENTLIKE08 p2p2008 if con2008==1 & ELECTION2008==1, col chi

**final result for table in paper is calculated by hand based on two results immediately above

*							No propose		Propose
*~prefer incumbemt			427 (75.7%)		216 (65.9%)
*prefer incumbent			137 (24.3%)		112 (34.1%)

* chi-squared: 10.1, p=.002
* Yates':		9.53, p=.002

