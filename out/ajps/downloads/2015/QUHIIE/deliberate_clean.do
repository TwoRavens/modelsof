set more off
clear all

* Convert CSV files to Stata
insheet using "S4class1.csv", names clear
save "S4class1.dta", replace
insheet using "S4class2.csv", names clear
save "S4class2.dta", replace
insheet using "S4class3.csv", names clear
save "S4class3.dta", replace

* Load responses from the deliberation study.
insheet using "delib_raw.csv", names clear

merge m:1 subjid using "S4class1.dta"
rename _merge merge1
gen class = .
replace class = 1 if merge1==3
merge m:1 subjid using "S4class2.dta", update
rename _merge merge2
replace class = 2 if merge2==4
merge m:1 subjid using "S4class3.dta", update
rename _merge merge3
replace class = 3 if merge3==4

* Scale attitude variables 0-1. Note: MC was measured with three items
* in class1, but two items in classes 2 and 3.
foreach iss in cb ss gm sc af gc ii nu tx {
	gen `iss'smor = .
	}
	
foreach iss in cb ss gm sc af {
	replace `iss'smor = ((`iss'smor1 + `iss'smor2 + `iss'smor3)-3)/12 if class==1
	}

foreach iss in ss gc ii nu tx {
	replace `iss'smor = ((`iss'smor1 + `iss'smor2)-2)/8 if class==2 | class==3
	}

foreach iss in cb ss gm sc af gc ii nu tx {
	replace `iss'imp = (`iss'imp - 1) / 4
	replace `iss'relev = (`iss'relev - 1) / 4
	gen `iss'extfold = (abs(`iss'ext - 4))/3 // folded extremity measure
	}


* The task here is to pull the proper attitude-strength from time 1, 
* and insert it in issmor, which will be moral conviction for the 
* issue that was actually discussed. The variable iss1 identifies which issue 
* was discussed.

* Issue-specific MC
gen issmor = .
replace issmor = cbsmor if iss1==2
replace issmor = gcsmor if iss1==4
replace issmor = iismor if iss1==5
replace issmor = nusmor if iss1==6
replace issmor = gmsmor if iss1==7
replace issmor = sssmor if iss1==8
replace issmor = scsmor if iss1==9
replace issmor = txsmor if iss1==10
replace issmor = afsmor if iss1==11

replace issmor = .5 if gcsmor1==. & gcsmor2==3 // Manually handle one subj who only answered one of the two MC questions

* Issue-specific importance, relevance
gen issimp = .
replace issimp = cbimp if iss1==2
replace issimp = gcimp if iss1==4
replace issimp = iiimp if iss1==5
replace issimp = nuimp if iss1==6
replace issimp = gmimp if iss1==7
replace issimp = ssimp if iss1==8
replace issimp = scimp if iss1==9
replace issimp = tximp if iss1==10
replace issimp = afimp if iss1==11

gen issrelev = .
replace issrelev = cbrelev if iss1==2
replace issrelev = gcrelev if iss1==4
replace issrelev = iirelev if iss1==5
replace issrelev = nurelev if iss1==6
replace issrelev = gmrelev if iss1==7
replace issrelev = ssrelev if iss1==8
replace issrelev = screlev if iss1==9
replace issrelev = txrelev if iss1==10
replace issrelev = afrelev if iss1==11

gen issextfoldt1 = .
replace issextfoldt1 = cbextfold if iss1==2
replace issextfoldt1 = gcextfold if iss1==4
replace issextfoldt1 = iiextfold if iss1==5
replace issextfoldt1 = nuextfold if iss1==6
replace issextfoldt1 = gmextfold if iss1==7
replace issextfoldt1 = ssextfold if iss1==8
replace issextfoldt1 = scextfold if iss1==9
replace issextfoldt1 = txextfold if iss1==10
replace issextfoldt1 = afextfold if iss1==11

* Scale compromise 0-1
replace compromise = (compromise - 1) / 3

drop merge*

save "deliberate.dta", replace
