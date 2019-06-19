***********************************************************************
*  THIS FILE ANALYSE DATA AND REPLICATES ALL RESULTS IN MS #14539
***********************************************************************

** FIRST READ IN THE DATASETS
set more off
version 12.0
use Data, replace
* outsheet the raw data to ascii format
outfile using Data.txt, nolabel replace comma

*******************************************************
* Define all variables
*******************************************************

label variable raname		"Name of  Research Assistent"
label variable villageid    "ID number of village"
label variable subjectid    "ID number of subject"
label variable wave         "Subject wave on the day"
label variable age          "Age of child"
label variable grade  		"Grade Year of School of child" 
label variable performance	"Performance in task #Balls hit" 
label variable male       	"male"
label variable female       "Female"
label variable comp         "Choose to compete" 
label variable matrilineal  "Matrilinial"
label variable year  		"Sample year"
label variable experimenter "Id of experimenter"

**********************************************
* Define extra varialbes
**********************************************

* AGE COMPOSITION OF SUBJECT POOL
gen old=1 if age>=13
replace old=0 if age<13
generate ageC = 1
replace ageC = 2 if old==1

generate gender_culture=0
replace gender_culture = 1 if female==1 & matri==0
replace gender_culture = 2 if female==0 & matri==0
replace gender_culture = 3 if female==1 & matri==1
replace gender_culture = 4 if female==0 & matri==1
save tmpA, replace

* Label new variables
label variable old         		"More than 12 years of age" 
label variable ageC  			"Age category"
label variable gender_culture  	"Identifier for culture and gender combinations"
save sample, replace

********************************
* Do original analysis without the 2009 data
*********************************
drop if year == 2009
save tmp, replace

* Testing if we can pool data on charateristics
ttest age, by(male)
ranksum age, by(male)
ranksum age, by(matri)

***********
* Table 1
***********
g count=1
* column 1
mean comp if ageC==1, over(gender_culture)
total count if ageC==1 , over(gender_culture)
* column 2
mean comp if ageC==2, over(gender_culture)
total count if ageC==2 , over(gender_culture)

* all column
mean comp , over(gender_culture)
total count  , over(gender_culture)

* all row
mean comp , over(ageC)
total count  , over(ageC)

* Testing differences
* From Column 1 to 2
foreach AgeC in 2 {
	foreach GC in 1 2 3 4 {
		display "Looking at gender_culture `GC' by age group `AgeC'"
		prtest comp if (ageC==1 | ageC==`AgeC') & gender_culture==`GC', by(ageC)
			
	}
}

* aggregate
ksmirnov comp if (ageC==1 | ageC==2), by(ageC)

* Rows 1 to 2, 3 and 4
foreach GC in 2 3 4 {
	foreach AgeC in 1 2  {
		display "Looking at age group `AgeC' by gender_culture `GC' "
		prtest comp if (gender_culture==1 |  gender_culture==`GC') & ageC==`AgeC', by(gender_culture)
	}
}

* Rows 2 to 3 
foreach GC in 3 4 {
	foreach AgeC in  1 2 {
		display "Looking at age group `AgeC' by gender_culture `GC' "
		prtest comp if (gender_culture==2 |  gender_culture==`GC') & ageC==`AgeC', by(gender_culture)
		
	}
}

* Rows 3 to 4
foreach GC in 4 {
	foreach AgeC in 1 2 {
		display "Looking at age group `AgeC' by gender_culture `GC' "
		prtest comp if (gender_culture==3 |  gender_culture==`GC') & ageC==`AgeC', by(gender_culture)
	}
}

* aggregate
prtest comp if (gender_culture==1 | gender_culture==2), by(gender_culture)
prtest comp if (gender_culture==1 | gender_culture==3), by(gender_culture)
prtest comp if (gender_culture==1 | gender_culture==4), by(gender_culture)
prtest comp if (gender_culture==2 | gender_culture==3), by(gender_culture)
prtest comp if (gender_culture==2 | gender_culture==4), by(gender_culture)
prtest comp if (gender_culture==3 | gender_culture==4), by(gender_culture)

**********
* Difference in difference 
**********
generate ageC_D = ageC-1
generate old_female = ageC_D * female
generate old_matri = ageC_D * matri
reg comp ageC_D female old_female	if matri==0
reg comp ageC_D female old_female	if matri==1
reg comp ageC_D matri old_matri		if female==0
reg comp ageC_D matri old_matri		if female==1
save sample2, replace

***********
* FIGURE 1
***********
* generate names such that they can be set beside each other
generate comp_male=.
generate comp_female=.
replace comp_male = comp if male==1
replace comp_female = comp if female==1
generate bartext=""
replace bartext = "1. Below 13 Years" if ageC==1
replace bartext = "2. Over  13 Years" if ageC==2

graph bar (mean) comp_male comp_female if matri==0, over(bartext) bargap(-20) legend( off ) ytitle("Compete") title("Patriarchal" ) blabel(bar, position(inside) format(%9.2f) color(white)) saving(temp_patri, replace) scheme(sj)
graph bar (mean) comp_male comp_female if matri==1, over(bartext) bargap(-20) legend( label(1 "Male") label(2 "Female") )  ytitle("Compete") title("Matrilineal" ) blabel(bar, position(inside) format(%9.2f) color(white)) saving(temp_matri, replace) scheme(sj)
graph combine temp_patri.gph temp_matri.gph, col(1) xcommon title(Frequency of Individuals who Compete) subtitle("By Culture, Age Group and Gender") saving("FIGURE_1.gph", replace)
graph export figure1.tif, replace

************
* ON THE  OPTIMALITY OF CHOICES
************
use sample2, replace
sort matri
egen ID = seq()
save tmp, replace

* Find the last ID number of Khasi
sum ID if matr==0
local maxM = r(max)

* Find the first ID number of Kharbi
sum ID if matr==1
local minP = r(min)

* Find the first ID number of Kharbi
local maxP = r(max)

keep if matri ==1 
keep ID performance
save tmpM, replace
use tmp, replace
keep if matri ==0 
keep ID performance
save tmpP, replace

* Number of draws per subject
set seed 1234
local s = 1000

qui forvalues y = 1(1)`maxP' { 
		forvalues x = 1(1)`s' { 
				if `y' < `minP' {
				use tmpM, clear
				}
				if `y' > `maxM' {
				use tmpP, clear
				}
				drop if ID==`y'
				generate random = uniform()
				sort random
				sample 1, count
				* now count number of 0's
				egen n_0 =  anymatch(performance), values(0)
				egen n_1 =  anymatch(performance), values(1)
				egen n_2 =  anymatch(performance), values(2)
				egen n_3 =  anymatch(performance), values(3)
				egen n_4 =  anymatch(performance), values(4)
				egen n_5 =  anymatch(performance), values(5)
				drop performance
				collapse (mean) n_*
				save sim_`x', replace
		}
		use sim_1, clear
		forvalues x = 2(1)`s' { 
				append using sim_`x'
		}
		collapse (mean) n_*
		generate ID = `y'
		save freq`y', replace
		noi display "Subject `y'"
}


* Append into one big file
use freq1, clear
forvalues y = 2(1)`maxP' { 
	append using freq`y'
}
shell erase sim_*
shell erase freq*
save winprob, replace

use tmp, replace
merge m:m ID using winprob

* Now calculate the winning probability, and the tie probability
generate winprob = 0
replace winprob = winprob + n_0 if performance ==1
replace winprob = winprob + n_1 if performance ==2
replace winprob = winprob + n_2 if performance ==3
replace winprob = winprob + n_3 if performance ==4
replace winprob = winprob + n_4 if performance ==5

generate tieprob = 0
replace tieprob = n_0 if performance ==0
replace tieprob = n_1 if performance ==1
replace tieprob = n_2 if performance ==2
replace tieprob = n_3 if performance ==3
replace tieprob = n_4 if performance ==4
replace tieprob = n_5 if performance ==5

save wincheck, replace

* Now calculate the ex post optimal decisions
use wincheck, replace
gen lossprob=1-winprob-tieprob

******************************************
* Optimal Decisions Rule:
* 
* Subject will enter the tournament if:
* Pr(win)3x+Pr(tie)x>x
* Pr(win)3x>Pr(win)x+Pr(loss)x
* Pr(win)2x>Pr(loss)x
* Pr(win)/Pr(loss)>1/2
* Let p=pr(win) and t=pr(tie), then p/(1-p-t)>1/2=>3p+t>1 is the decision rule for entering the tournament. 
********************************************** 

gen comp_opt=1 if 3*winprob+tieprob>1 & winprob~=. & tieprob~=. 
gen indifferent=1 if 3*winprob+tieprob==1 & winprob~=. & tieprob~=. 
gen pr_opt=1 if 3*winprob+tieprob<1 & winprob~=. & tieprob~=. 
drop if winprob==. | tieprob==. 
gen optdec=1 if comp_opt==1
replace optdec=0 if pr_opt==1

gen 	correct=1 if optdec==1 & comp==1
replace correct=1 if optdec==0 & comp==0
replace correct=0 if correct~=1
replace correct=. if optdec==.

gen 	overenter=1 if optdec==0 & comp==1
replace overenter=0 if overenter~=1

gen 	underenter=1 if optdec==1 & comp==0
replace underenter=0 if under~=1

* Gender Differences in Rational Choice?

prtest correct, by(female)
prtest correct if female==1, by(matri)
prtest correct if male==1, by(matri)

* By Society, Gender, Age:
prtest overenter, by(male) 
prtest overenter if old==1, by(male)

tab overenter if old==1 & matri==0 & female==1
tab underenter if old==1 & matri==0 & female==1

*Types of Decision Errors:

gen type=1 if overenter==1
replace type=-1 if underenter==1
replace type=0 if overenter==0 & underenter==0 


tab type if old==1 & matri==0 & female==1
tab type if old==0 & matri==0 & female==1

* Are they different?

tab type matri if old==1 & female==1, chi2 column

tab type matri if old==1 & female==0, chi2 column

tab type matri if old==0 & female==1, exact

tab type matri if old==0 & female==0, exact

****************************************
**********
* ADDITIONAL FIGURES R1 - NOT FOR PUBLICATION
***********
use sample2, replace
generate comp_male=.
generate comp_female=.
replace comp_male = comp if male==1
replace comp_female = comp if female==1
generate bartext=""
drop ageC old
gen old=1 if age>=12
replace old=0 if age<12
generate ageC = 1
replace ageC = 2 if old==1
replace bartext = "1. Below 12 Years" if ageC==1
replace bartext = "2. Over  12 Years" if ageC==2
graph bar (mean) comp_male comp_female if matri==0, over(bartext) bargap(-20) legend( off ) ytitle("Compete") title("Patriarchal" ) blabel(bar, position(inside) format(%9.2f) color(white)) saving(temp_patri, replace) scheme(sj)
graph bar (mean) comp_male comp_female if matri==1, over(bartext) bargap(-20) legend( label(1 "Male") label(2 "Female") )  ytitle("Compete") title("Matrilineal" ) blabel(bar, position(inside) format(%9.2f) color(white)) saving(temp_matri, replace) scheme(sj)
graph combine temp_patri.gph temp_matri.gph, col(1) xcommon title(Frequency of Individuals who Compete) subtitle("By Culture, Age Group and Gender") saving("FIGURE_R1.gph", replace)
graph export figureR1.tif, replace

***********
* ADDITIONAL FIGURES R2 - NOT FOR PUBLICATION
***********
use sample2, replace
generate comp_male=.
generate comp_female=.
replace comp_male = comp if male==1
replace comp_female = comp if female==1
generate bartext=""
drop ageC old
gen old=1 if age>=14
replace old=0 if age<14
generate ageC = 1
replace ageC = 2 if old==1
replace bartext = "1. Below 14 Years" if ageC==1
replace bartext = "2. Over  14 Years" if ageC==2
graph bar (mean) comp_male comp_female if matri==0, over(bartext) bargap(-20) legend( off ) ytitle("Compete") title("Patriarchal" ) blabel(bar, position(inside) format(%9.2f) color(white)) saving(temp_patri, replace) scheme(sj)
graph bar (mean) comp_male comp_female if matri==1, over(bartext) bargap(-20) legend( label(1 "Male") label(2 "Female") )  ytitle("Compete") title("Matrilineal" ) blabel(bar, position(inside) format(%9.2f) color(white)) saving(temp_matri, replace) scheme(sj)
graph combine temp_patri.gph temp_matri.gph, col(1) xcommon title(Frequency of Individuals who Compete) subtitle("By Culture, Age Group and Gender") saving("FIGURE_R2.gph", replace)
graph export figureR2.tif, replace

***********
* ADDITIONAL Table R1 - NOT FOR PUBLICATION
***********
use sample2, clear
generate clusterwave = wave + villageid*100

* pooled data regression
generate patrilineal = 1 - matrilineal 
generate pf = female*patrilineal
replace age = age - 7
generate age2 = age*age
generate f_age = female*age
generate f_age2 = female*age*age
generate p_age = patrilineal*age
generate p_age2 = patrilineal*age*age
generate pf_age = female*patrilineal*age
generate pf_age2 = female*patrilineal*age*age

* TableR1
regress comp age age2 female f_age f_age2 p_a* pf_a* patri*, cluster(clusterwave) 

***********
* ADDITIONAL Table R2 - NOT FOR PUBLICATION
*********** 

* column 1
mean performance if ageC==1, over(gender_culture)
total count if ageC==1 , over(gender_culture)
* column 2
mean performance if ageC==2, over(gender_culture)
total count if ageC==2 , over(gender_culture)

* all column
mean performance , over(gender_culture)
total count  , over(gender_culture)

* all row
mean performance , over(ageC)
total count  , over(ageC)

* Testing differences
* From Column 1 to 2 
foreach AgeC in 2 {
	foreach GC in 1 2 3 4 {
		display "Looking at gender_culture `GC' by age group `AgeC'"
		ksmirnov performance if (ageC==1 | ageC==`AgeC') & gender_culture==`GC', by(ageC)
	}
}

* aggregate
ksmirnov performance if (ageC==1 | ageC==2), by(ageC)

* Rows 1 to 2, 3 and 4
foreach GC in 2 3 4 {
	foreach AgeC in 1 2 {
		display "Looking at age group `AgeC' by gender_culture `GC' "
		ksmirnov performance if (gender_culture==1 |  gender_culture==`GC') & ageC==`AgeC', by(gender_culture)
	}
}

* Rows 2 to 3 and 4
foreach GC in 3 4 {
	foreach AgeC in  1 2 {
		display "Looking at age group `AgeC' by gender_culture `GC' "
		ksmirnov performance if (gender_culture==2 |  gender_culture==`GC') & ageC==`AgeC', by(gender_culture)
	}
}

* Rows 3 to 4
foreach GC in 4 {
	foreach AgeC in  1 2 {

		display "Looking at age group `AgeC' by gender_culture `GC' "
		ksmirnov performance if (gender_culture==3 |  gender_culture==`GC') & ageC==`AgeC', by(gender_culture)
	}
}

* aggregate
ksmirnov performance if (gender_culture==1 | gender_culture==2), by(gender_culture)
ksmirnov performance if (gender_culture==1 | gender_culture==3), by(gender_culture)
ksmirnov performance if (gender_culture==1 | gender_culture==4), by(gender_culture)
ksmirnov performance if (gender_culture==2 | gender_culture==3), by(gender_culture)
ksmirnov performance if (gender_culture==2 | gender_culture==4), by(gender_culture)
ksmirnov performance if (gender_culture==3 | gender_culture==4), by(gender_culture)

*********************************
* APPENDIX B- POOLED DATA
*********************************
use sample, clear

* Testing if we can pool data on charateristics
ttest age, by(male)
ranksum age, by(male)
ranksum age, by(matri)

***********
* DATA 2009 - Table B1 
***********
g count=1
* column 1
mean comp if ageC==1, over(gender_culture)
total count if ageC==1 , over(gender_culture)
* column 2
mean comp if ageC==2, over(gender_culture)
total count if ageC==2 , over(gender_culture)

* all column
mean comp , over(gender_culture)
total count  , over(gender_culture)

* all row
mean comp , over(ageC)
total count  , over(ageC)

* Testing differences
* From Column 1 to 2
foreach AgeC in 2 {
	foreach GC in 1 2 3 4 {
		display "Looking at gender_culture `GC' by age group `AgeC'"
		prtest comp if (ageC==1 | ageC==`AgeC') & gender_culture==`GC', by(ageC)
			
	}
}

* aggregate
ksmirnov comp if (ageC==1 | ageC==2), by(ageC)

* Rows 1 to 2, 3 and 4
foreach GC in 2 3 4 {
	foreach AgeC in 1 2  {
		display "Looking at age group `AgeC' by gender_culture `GC' "
		prtest comp if (gender_culture==1 |  gender_culture==`GC') & ageC==`AgeC', by(gender_culture)
	}
}

* Rows 2 to 3 
foreach GC in 3 4 {
	foreach AgeC in  1 2 {
		display "Looking at age group `AgeC' by gender_culture `GC' "
		prtest comp if (gender_culture==2 |  gender_culture==`GC') & ageC==`AgeC', by(gender_culture)
		
	}
}

* Rows 3 to 4
foreach GC in 4 {
	foreach AgeC in 1 2 {
		display "Looking at age group `AgeC' by gender_culture `GC' "
		prtest comp if (gender_culture==3 |  gender_culture==`GC') & ageC==`AgeC', by(gender_culture)
	}
}

* aggregate
prtest comp if (gender_culture==1 | gender_culture==2), by(gender_culture)
prtest comp if (gender_culture==1 | gender_culture==3), by(gender_culture)
prtest comp if (gender_culture==1 | gender_culture==4), by(gender_culture)
prtest comp if (gender_culture==2 | gender_culture==3), by(gender_culture)
prtest comp if (gender_culture==2 | gender_culture==4), by(gender_culture)
prtest comp if (gender_culture==3 | gender_culture==4), by(gender_culture)

**********
* DATA Difference in difference 
**********

generate ageC_D = ageC-1
generate old_female = ageC_D * female
reg comp ageC_D female old_female if matri==0
reg comp ageC_D female old_female if matri==1
save sample3, replace

***********
* POOLED DATA - FIGURE B1
***********
* generate names such that they can be set beside each other
generate comp_male=.
generate comp_female=.
replace comp_male = comp if male==1
replace comp_female = comp if female==1
generate bartext=""
replace bartext = "1. Below 13 Years" if ageC==1
replace bartext = "2. Over  13 Years" if ageC==2

graph bar (mean) comp_male comp_female if matri==0, over(bartext) bargap(-20) legend( off ) ytitle("Compete") title("Patriarchal" ) blabel(bar, position(inside) format(%9.2f) color(white)) saving(temp_patri, replace) scheme(sj)
graph bar (mean) comp_male comp_female if matri==1, over(bartext) bargap(-20) legend( label(1 "Male") label(2 "Female") )  ytitle("Compete") title("Matrilineal" ) blabel(bar, position(inside) format(%9.2f) color(white)) saving(temp_matri, replace) scheme(sj)
graph combine temp_patri.gph temp_matri.gph, col(1) xcommon title(Frequency of Individuals who Compete) subtitle("By Culture, Age Group and Gender") saving("FIGURE_B1.gph", replace)
graph export figureB1.tif, replace

