cap log close
cd "R:\GenderResearch\UCRP Experiments\Exit Poll Experiment"
log using logfor12192014.log, replace
use "data12192014.dta", clear

rename run_exp treatment
/*****
EXPLORING DATA
*****/
//tab q1_1
sum QRESP
tab QRESP
tab y_caucus14
tab gender14
//tab sexor14
tab treatment gender
tab y_run14
tab gender14

/*****
GENERATING BINARY GENDER VAR
*****/
gen male=1 if gender14==1
replace male=0 if gender14==2

gen female=0 if gender14==1
replace female=1 if gender14==2
/*****
DROP INVALID OR MISSED DV RESPONSE
*****/
drop if y_run14==5
drop if y_run14==6
tab y_run14
label drop PREECE_EXP
tab y_run14
replace y_run14=5-y_run14
tab y_run14


/*****
EXPLORING DV AND PRIMARY IVS
*****/

tab y_run14
sum y_run14
sum y_run14 if female==0
sum y_run14 if female==1

tab treatment
tab y_run14 treatment if female==1
sum y_run14

sum y_run14 if treatment==1 & female==0
sum y_run14 if treatment==1 & female==1
sum y_run14 if treatment==0 & female==0
sum y_run14 if treatment==0 & female==1

count if y_run14!=. & treatment==.
count if treatment!=. & y_run14==.


describe y_run14
drop if treatment==.
tab y_run14
drop if y_run14==.
tab y_run14

tab female
tab male
tab treatment
tab treatment female
drop if male==.
count
count if treatment==1
count if treatment==0



/*****
INITIAL TTESTS
*****/
ttest y_run14, by(treatment)
ttest y_run14 if female==1, by(treatment)
ttest y_run14 if female==0, by(treatment)

/*****
TABULATE DEMOGRAPHIC VARIABLES
*****/
tab birthyr14
tab age14
tab party14
tab partyid3
tab educ14
tab ideo14
tab relig14
tab active14
tab relig_index
tab emp14
tab race14
tab marstat14
tab income14
tab female

label dir
label list RACE MARSTAT EDUC EMP INCCOR

ttest age14, by(treatment)
ttest female, by(treatment)
gen race_white=1 if race14==5
replace race_white=0 if race_white==.&race14!=8&race14!=9
ttest race_white, by(treatment)
gen marriedpartnered=1 if marstat14==1|marstat14==4
replace marriedpartnered=0 if marriedpartnered==.&marstat14!=6&marstat14!=7
ttest marriedpartnered, by(treatment)
gen collegeorhigher=1 if educ14==4|educ14==5
replace collegeorhigher=0 if collegeorhigher==. & educ14!=6&educ14!=7
ttest collegeorhigher, by(treatment)
gen employed=1 if emp14==1|emp14==2
replace employed=0 if emp14>2 & emp14<7
ttest employed, by(treatment)
gen i40=1 if income14==1
replace i40=0 if income14==3 | income14==2
ttest i40, by(treatment)
gen i40to100=1 if income14==2
replace i40to100=0 if income14==1 | income14==3
ttest i40to100, by(treatment)
gen i100=1 if income14==3
replace i100=0 if income14==1 | income14==2
ttest i100, by(treatment)

sort male
by male: ttest age14, by(treatment)
by male: ttest race_white, by(treatment)
by male: ttest marriedpartnered, by(treatment)
by male: ttest collegeorhigher, by(treatment)
by male: ttest employed, by(treatment)
by male: ttest i40, by(treatment)
by male: ttest i40to100, by(treatment)
by male: ttest i100, by(treatment)

/*****
Table 3
*****/
ttest y_run14 if male==1, by(treatment)
ttest y_run14 if male==0, by(treatment)

ttest y_run14 if treatment==0, by(male)
ttest y_run14 if treatment==1, by(male)

gen tm = treatment*male


oprobit y_run14 male treatment tm, vce(robust)
gen race_indian=1 if race14==1
replace race_indian=0 if race14!=1 & race14!= 8 & race14!=9

gen race_asian=1 if race14==2
replace race_asian=0 if race14!=2 & race14!=8 & race14!=9

gen race_black=1 if race14==3
replace race_black=0 if race14!=3 & race14!=8 & race14!=9

gen race_hispanic=1 if race14==4
replace race_hispanic=0 if race14!=4 & race14!=8 & race14!=9

*race_white

gen race_pacific=1 if race14==6
replace race_pacific=0 if race14!=6 & race14!=8 & race14!=9

gen race_other=1 if race14==7
replace race_other=0 if race14!=7& race14!=8 & race14!=9

gen status_married=1 if marstat14==1
replace status_married=0 if marstat14!=1 & marstat14!=6 & marstat14!=7

gen status_divorced=1 if marstat14==2
replace status_divorced=0 if marstat14!=2 & marstat14!=6 & marstat14!=7

gen status_widowed=1 if marstat14==3
replace status_widowed=0 if marstat14!=3 & marstat14!=6 & marstat14!=7

gen status_partnered=1 if marstat14==4
replace status_partnered=0 if marstat14!=4 & marstat14!=6 & marstat14!=7

gen status_single=1 if marstat14==5
replace status_single=0 if marstat14!=5 & marstat14!=6 & marstat14!=7

gen educ_lessthanhs=1 if educ14==1
replace educ_lessthanhs=0 if educ14!=1 & educ14!=6 & educ14!=7

gen educ_hs=1 if educ14==2
replace educ_hs=0 if educ14!=2 & educ14!=6 & educ14!=7

gen educ_somecollege=1 if educ14==3
replace educ_somecollege=0 if educ14!=3 & educ14!=6 & educ14!=7

gen educ_collegedegree=1 if educ14==4
replace educ_collegedegree=0 if educ14!=4 & educ14!=6 & educ14!=7

gen educ_postgrad=1 if educ14==5
replace educ_postgrad=0 if educ14!=5 & educ14!=6 & educ14!=7

gen emp_self=1 if emp14==1
replace emp_self=0 if emp14!=1 & emp14!=7 & emp14!=8

gen emp_someone_else=1 if emp14==2
replace emp_someone_else=0 if emp14!=2 & emp14!=7 & emp14!=8

gen emp_unemp=1 if emp14==3
replace emp_unemp=0 if emp14!=3 & emp14!=7 & emp14!=8

gen emp_homemaker=1 if emp14==4
replace emp_homemaker=0 if emp14!=4 & emp14!=7 & emp14!=8

gen emp_retired=1 if emp14==5
replace emp_retired=0 if emp14!=5 & emp14!=7 & emp14!=8

gen emp_student=1 if emp14==6
replace emp_student=0 if emp14!=6 & emp14!=7 & emp14!=8

gen inc_lessthan40=1 if income14==1
replace inc_lessthan40=0 if income14!=1 & income14!=9 & income14!=10

gen inc_40to100=1 if income14==2
replace inc_40to100=0 if income14!=2 & income14!=9 & income14!=10

gen inc_100plus=1 if income14==3
replace inc_100plus=0 if income14!=3 & income14!=9 & income14!=10

rename race_white bdrace_white
rename status_single bdstatus_single
rename educ_hs bdeduc_hs
rename emp_someone_else bdemp_someone_else


/*****
oprobit margins model needs to have predict(value) specified to yield meaningful results.
*****/

gen tf = treatment*female
oprobit y_run14 female treatment tf, collinear vce(robust)
margins, dydx(female treatment tf)

oprobit y_run14 female treatment tf age14 race_* status_* educ_* emp_* inc_*, collinear vce(robust)
margins, dydx(female treatment tf age14 race_* status_* educ_* emp_* inc_*) at((means)race_indian race_asian race_black race_hispanic race_pacific race_other status_married status_divorced status_widowed status_partnered educ_lessthanhs educ_somecollege educ_collegedegree educ_postgrad emp_self emp_unemp emp_homemaker emp_retired emp_student inc_lessthan40 inc_100plus)

//reg y_run14 male treatment tm, robust
//reg y_run14 male treatment tm age14 race_* status_* educ_* emp_* inc_*, robust


count

tab y_run14

gen yes=1 if y_run14==4
replace yes=0 if yes==.
gen probyes=1 if y_run14==3
replace probyes=0 if probyes==.
gen probno=1 if y_run14==2
replace probno=0 if probno==.
gen no=1 if y_run14==1
replace no=0 if no==.
/*
ttest yes 		if treatment==0, by(male)
ttest probyes 	if treatment==0, by(male)
ttest probno 	if treatment==0, by(male)
ttest no		if treatment==0, by(male)
ttest yes 		if treatment==1, by(male)
ttest probyes 	if treatment==1, by(male)
ttest probno 	if treatment==1, by(male)
ttest no		if treatment==1, by(male)

diff yes, p(treatment) t(female)
diff probyes, p(treatment) t(female)
diff probno, p(treatment) t(female)
diff no, p(treatment) t(female)
*/

probit yes female treatment tf, robust
margins, dydx(female treatment tf)

probit yes female treatment tf age14 race_* status_* educ_* emp_* inc_*, robust
margins, dydx(female treatment tf age14 race_* status_* educ_* emp_* inc_*) at((means)race_indian race_asian race_black race_hispanic race_pacific race_other status_married status_divorced status_widowed status_partnered educ_lessthanhs educ_somecollege educ_collegedegree educ_postgrad emp_self emp_unemp emp_homemaker emp_retired emp_student inc_lessthan40 inc_100plus)

gen yesprobyes=1 if yes==1 | probyes==1
replace yesprobyes=0 if yesprobyes==.

probit yesprobyes female treatment tf, robust
margins, dydx(female treatment tf)

probit yesprobyes female treatment tf age14 race_* status_* educ_* emp_* inc_*, robust
margins, dydx(female treatment tf age14 race_* status_* educ_* emp_* inc_*) at((means)race_indian race_asian race_black race_hispanic race_pacific race_other status_married status_divorced status_widowed status_partnered educ_lessthanhs educ_somecollege educ_collegedegree educ_postgrad emp_self emp_unemp emp_homemaker emp_retired emp_student inc_lessthan40 inc_100plus)
oogabooga

/*****
COLLAPSE BY TREATMENT AND GENDER;
GENERATE MEAN, STANDARD DEVIATION, N
*****/
preserve
#delimit ;
collapse
	(mean) mean=y_run14
	(sd) sd=y_run14
	(count) count=y_run14
	, by(treatment male);

#delimit cr

/*****
RESHAPE WIDE FOR DEGREES OF FREEDOM 
(CONFIDENCE INTERVALS, GENDER GAP)
*****/

reshape wide mean sd count, i(treatment) j(male)

/*****
GENERATE CONFIDENCE INTERVALS

NOTE: IF WE REJECT THE NULL IN sdtest, WE NEED
	TO CALCULATE DEGREES OF FREEDOM 
	AS FOLLOWS
	
gen df = floor((sqrt(((sd1^2)/count1)+((sd0^2)/count0))^4)/((((sd0/sqrt(count0))^4)/(count0-1))+(((sd1/sqrt(count1))^4)/(count1-1))));

AND THEN MAKE CONFIDENCE INTERVALS AS FOLLOWS

gen hi = (mean0-mean1) + invttail(df,0.025)*sqrt(((sd1^2)/count1)+((sd0^2)/count0));
gen lo = (mean0-mean1) - invttail(df,0.025)*sqrt(((sd1^2)/count1)+((sd0^2)/count0));
*****/

gen hi = (mean0-mean1) + invttail(count1+count0-2,0.025)*((sqrt((((count1-1)*sd1^2)+((count0-1)*sd0^2))/(count1+count0-2))*sqrt((1/count1)+(1/count0))))
gen lo = (mean0-mean1) - invttail(count1+count0-2,0.025)*((sqrt((((count1-1)*sd1^2)+((count0-1)*sd0^2))/(count1+count0-2))*sqrt((1/count1)+(1/count0))))

gen mean=mean0-mean1
replace mean1=mean
replace mean0=mean
drop mean

reshape long mean sd count, i(treatment) j(male)

collapse (mean) mean hi lo (sum) count, by(treatment male)

#delimit ;

gen tm=1 if treatment==0;
replace tm=2 if treatment==1;
gen zero=0;
gen tzero=.5 if treatment==0;
replace tzero=3.5 if treatment==2;

twoway 	(bar mean tm if treatment==0)
		(bar mean tm if treatment==1)
		(rcap hi lo tm, color(black) lwidth(*.1) lpattern(solid))
		(line zero tzero, lpattern(dash) lwidth(*1.1))
		,
		legend(off)
		xlabel(1 "Control**" 2 "Encouragement**")
		//yscale (axis(1) range(-1,1))
		note(Note: Gender Gap is measured as the difference in means between male subjects and female subjects.)
		note( `"Note: Gender Gap is measured as the difference in means between male subjects and female"' `"subjects. * indicates p < .05 .  ** indicates p < .01"' )
		scheme(s1mono)
		xtitle("")
		ytitle("Gender Gap")
		ylabel(0 "0" -.2 "-.2" -.4 "-.4" -.6 "-.6" -.8 "-.8", angle(0))
	   ;
graph rename fig1ex1,replace;

#delimit cr
restore

cap log close
