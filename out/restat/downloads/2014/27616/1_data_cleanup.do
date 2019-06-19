set memory 10m

use rawdata, clear

**********************************************
*
*    Cleaning up of the raw data file
*
**********************************************

* drop blank lines and blank variables
drop if task==.  

* create a variable that includes task 4
gen taskall=task
replace taskall=taskchoose if task==4
placevar taskall, after(task)

*create missing observation for taskchoose in all but the last round
replace taskchoose=. if task~=4
forval i=1/3 {
	replace methodchoice`i'=. if methodchoice`i'==0
}

*reorder option choices in practice round from best to worst
gen tbbb=option
replace tbbb=1 if option==4 & task==0
replace tbbb=4 if option==1 & task==0
replace option=tbbb if task==0
drop tbbb

* optimality
gen optimal=(option==1)
placevar optimal, after(option)

gen timeround1=real(roundtime1)
replace timeround1=time if timeround1==.
drop roundtime1
placevar timeround1, before(roundtime2)

* rename some vars to make reshape go smoothly
foreach i of num 2/5 {
   rename roundtime`i' timeround`i'
}
foreach i of num 1/5 {
   rename option`i' optionround`i'
}

*add payoff for each option
gen payoff=0
replace payoff=82 if option==1 & pdf==0
replace payoff=69 if option==2 & pdf==0
replace payoff=60 if option==3 & pdf==0
replace payoff=49 if option==4 & pdf==0
replace payoff=80 if option==1 & pdf==1
replace payoff=75 if option==2 & pdf==1
replace payoff=72 if option==3 & pdf==1
replace payoff=68 if option==4 & pdf==1
replace payoff=63 if option==5 & pdf==1
replace payoff=61 if option==6 & pdf==1
replace payoff=59 if option==7 & pdf==1
replace payoff=57 if option==8 & pdf==1
replace payoff=55 if option==9 & pdf==1
replace payoff=53 if option==10 & pdf==1
replace payoff=50 if option==11 & pdf==1
replace payoff=48 if option==12 & pdf==1
replace payoff=47 if option==13 & pdf==1
replace payoff=45 if option==14 & pdf==1
replace payoff=36 if option==15 & pdf==1
replace payoff=32 if option==16 & pdf==1
replace payoff=80 if option==1 & pdf==2
replace payoff=73 if option==2 & pdf==2
replace payoff=66 if option==3 & pdf==2
replace payoff=65 if option==4 & pdf==2
replace payoff=63 if option==5 & pdf==2
replace payoff=61 if option==6 & pdf==2
replace payoff=59 if option==7 & pdf==2
replace payoff=58 if option==8 & pdf==2
replace payoff=57 if option==9 & pdf==2
replace payoff=56 if option==10 & pdf==2
replace payoff=54 if option==11 & pdf==2
replace payoff=51 if option==12 & pdf==2
replace payoff=44 if option==13 & pdf==2
replace payoff=42 if option==14 & pdf==2
replace payoff=39 if option==15 & pdf==2
replace payoff=35 if option==16 & pdf==2
replace payoff=79 if option==1 & pdf==3
replace payoff=71 if option==2 & pdf==3
replace payoff=68 if option==3 & pdf==3
replace payoff=64 if option==4 & pdf==3
replace payoff=63 if option==5 & pdf==3
replace payoff=61 if option==6 & pdf==3
replace payoff=60 if option==7 & pdf==3
replace payoff=58 if option==8 & pdf==3
replace payoff=57 if option==9 & pdf==3
replace payoff=54 if option==10 & pdf==3
replace payoff=53 if option==11 & pdf==3
replace payoff=49 if option==12 & pdf==3
replace payoff=46 if option==13 & pdf==3
replace payoff=43 if option==14 & pdf==3
replace payoff=38 if option==15 & pdf==3
replace payoff=36 if option==16 & pdf==3
replace payoff=78 if option==1 & pdf==4
replace payoff=72 if option==2 & pdf==4
replace payoff=69 if option==3 & pdf==4
replace payoff=67 if option==4 & pdf==4
replace payoff=66 if option==5 & pdf==4
replace payoff=62 if option==6 & pdf==4
replace payoff=60 if option==7 & pdf==4
replace payoff=57 if option==8 & pdf==4
replace payoff=55 if option==9 & pdf==4
replace payoff=53 if option==10 & pdf==4
replace payoff=52 if option==11 & pdf==4
replace payoff=48 if option==12 & pdf==4
replace payoff=46 if option==13 & pdf==4
replace payoff=43 if option==14 & pdf==4
replace payoff=41 if option==15 & pdf==4
replace payoff=34 if option==16 & pdf==4

*rename opt to option position
forval i=1/16 {
	rename opt`i' optionposition`i'
}

*add payoff for every option chosen in a round/sub-decision and for every option in optionposition
forval i=1/5 {
	gen payoffround`i'=0
}
forval i=1/5 {
	replace payoffround`i'=82 if optionround`i'==1 & pdf==0
	replace payoffround`i'=69 if optionround`i'==2 & pdf==0
	replace payoffround`i'=60 if optionround`i'==3 & pdf==0
	replace payoffround`i'=49 if optionround`i'==4 & pdf==0
	replace payoffround`i'=80 if optionround`i'==1 & pdf==1
	replace payoffround`i'=75 if optionround`i'==2 & pdf==1
	replace payoffround`i'=72 if optionround`i'==3 & pdf==1
	replace payoffround`i'=68 if optionround`i'==4 & pdf==1
	replace payoffround`i'=63 if optionround`i'==5 & pdf==1
	replace payoffround`i'=61 if optionround`i'==6 & pdf==1
	replace payoffround`i'=59 if optionround`i'==7 & pdf==1
	replace payoffround`i'=57 if optionround`i'==8 & pdf==1
	replace payoffround`i'=55 if optionround`i'==9 & pdf==1
	replace payoffround`i'=53 if optionround`i'==10 & pdf==1
	replace payoffround`i'=50 if optionround`i'==11 & pdf==1
	replace payoffround`i'=48 if optionround`i'==12 & pdf==1
	replace payoffround`i'=47 if optionround`i'==13 & pdf==1
	replace payoffround`i'=45 if optionround`i'==14 & pdf==1
	replace payoffround`i'=36 if optionround`i'==15 & pdf==1
	replace payoffround`i'=32 if optionround`i'==16 & pdf==1
	replace payoffround`i'=80 if optionround`i'==1 & pdf==2
	replace payoffround`i'=73 if optionround`i'==2 & pdf==2
	replace payoffround`i'=66 if optionround`i'==3 & pdf==2
	replace payoffround`i'=65 if optionround`i'==4 & pdf==2
	replace payoffround`i'=63 if optionround`i'==5 & pdf==2
	replace payoffround`i'=61 if optionround`i'==6 & pdf==2
	replace payoffround`i'=59 if optionround`i'==7 & pdf==2
	replace payoffround`i'=58 if optionround`i'==8 & pdf==2
	replace payoffround`i'=57 if optionround`i'==9 & pdf==2
	replace payoffround`i'=56 if optionround`i'==10 & pdf==2
	replace payoffround`i'=54 if optionround`i'==11 & pdf==2
	replace payoffround`i'=51 if optionround`i'==12 & pdf==2
	replace payoffround`i'=44 if optionround`i'==13 & pdf==2
	replace payoffround`i'=42 if optionround`i'==14 & pdf==2
	replace payoffround`i'=39 if optionround`i'==15 & pdf==2
	replace payoffround`i'=35 if optionround`i'==16 & pdf==2
	replace payoffround`i'=79 if optionround`i'==1 & pdf==3
	replace payoffround`i'=71 if optionround`i'==2 & pdf==3
	replace payoffround`i'=68 if optionround`i'==3 & pdf==3
	replace payoffround`i'=64 if optionround`i'==4 & pdf==3
	replace payoffround`i'=63 if optionround`i'==5 & pdf==3
	replace payoffround`i'=61 if optionround`i'==6 & pdf==3
	replace payoffround`i'=60 if optionround`i'==7 & pdf==3
	replace payoffround`i'=58 if optionround`i'==8 & pdf==3
	replace payoffround`i'=57 if optionround`i'==9 & pdf==3
	replace payoffround`i'=54 if optionround`i'==10 & pdf==3
	replace payoffround`i'=53 if optionround`i'==11 & pdf==3
	replace payoffround`i'=49 if optionround`i'==12 & pdf==3
	replace payoffround`i'=46 if optionround`i'==13 & pdf==3
	replace payoffround`i'=43 if optionround`i'==14 & pdf==3
	replace payoffround`i'=38 if optionround`i'==15 & pdf==3
	replace payoffround`i'=36 if optionround`i'==16 & pdf==3
	replace payoffround`i'=78 if optionround`i'==1 & pdf==4
	replace payoffround`i'=72 if optionround`i'==2 & pdf==4
	replace payoffround`i'=69 if optionround`i'==3 & pdf==4
	replace payoffround`i'=67 if optionround`i'==4 & pdf==4
	replace payoffround`i'=66 if optionround`i'==5 & pdf==4
	replace payoffround`i'=62 if optionround`i'==6 & pdf==4
	replace payoffround`i'=60 if optionround`i'==7 & pdf==4
	replace payoffround`i'=57 if optionround`i'==8 & pdf==4
	replace payoffround`i'=55 if optionround`i'==9 & pdf==4
	replace payoffround`i'=53 if optionround`i'==10 & pdf==4
	replace payoffround`i'=52 if optionround`i'==11 & pdf==4
	replace payoffround`i'=48 if optionround`i'==12 & pdf==4
	replace payoffround`i'=46 if optionround`i'==13 & pdf==4
	replace payoffround`i'=43 if optionround`i'==14 & pdf==4
	replace payoffround`i'=41 if optionround`i'==15 & pdf==4
	replace payoffround`i'=34 if optionround`i'==16 & pdf==4
}

forval i=1/16 {
	gen payoff`i'=0
}

forval i=1/16 {
	replace payoff`i'=82 if optionposition`i'==1 & pdf==0
	replace payoff`i'=69 if optionposition`i'==2 & pdf==0
	replace payoff`i'=60 if optionposition`i'==3 & pdf==0
	replace payoff`i'=49 if optionposition`i'==4 & pdf==0
	replace payoff`i'=80 if optionposition`i'==1 & pdf==1
	replace payoff`i'=75 if optionposition`i'==2 & pdf==1
	replace payoff`i'=72 if optionposition`i'==3 & pdf==1
	replace payoff`i'=68 if optionposition`i'==4 & pdf==1
	replace payoff`i'=63 if optionposition`i'==5 & pdf==1
	replace payoff`i'=61 if optionposition`i'==6 & pdf==1
	replace payoff`i'=59 if optionposition`i'==7 & pdf==1
	replace payoff`i'=57 if optionposition`i'==8 & pdf==1
	replace payoff`i'=55 if optionposition`i'==9 & pdf==1
	replace payoff`i'=53 if optionposition`i'==10 & pdf==1
	replace payoff`i'=50 if optionposition`i'==11 & pdf==1
	replace payoff`i'=48 if optionposition`i'==12 & pdf==1
	replace payoff`i'=47 if optionposition`i'==13 & pdf==1
	replace payoff`i'=45 if optionposition`i'==14 & pdf==1
	replace payoff`i'=36 if optionposition`i'==15 & pdf==1
	replace payoff`i'=32 if optionposition`i'==16 & pdf==1
	replace payoff`i'=80 if optionposition`i'==1 & pdf==2
	replace payoff`i'=73 if optionposition`i'==2 & pdf==2
	replace payoff`i'=66 if optionposition`i'==3 & pdf==2
	replace payoff`i'=65 if optionposition`i'==4 & pdf==2
	replace payoff`i'=63 if optionposition`i'==5 & pdf==2
	replace payoff`i'=61 if optionposition`i'==6 & pdf==2
	replace payoff`i'=59 if optionposition`i'==7 & pdf==2
	replace payoff`i'=58 if optionposition`i'==8 & pdf==2
	replace payoff`i'=57 if optionposition`i'==9 & pdf==2
	replace payoff`i'=56 if optionposition`i'==10 & pdf==2
	replace payoff`i'=54 if optionposition`i'==11 & pdf==2
	replace payoff`i'=51 if optionposition`i'==12 & pdf==2
	replace payoff`i'=44 if optionposition`i'==13 & pdf==2
	replace payoff`i'=42 if optionposition`i'==14 & pdf==2
	replace payoff`i'=39 if optionposition`i'==15 & pdf==2
	replace payoff`i'=35 if optionposition`i'==16 & pdf==2
	replace payoff`i'=79 if optionposition`i'==1 & pdf==3
	replace payoff`i'=71 if optionposition`i'==2 & pdf==3
	replace payoff`i'=68 if optionposition`i'==3 & pdf==3
	replace payoff`i'=64 if optionposition`i'==4 & pdf==3
	replace payoff`i'=63 if optionposition`i'==5 & pdf==3
	replace payoff`i'=61 if optionposition`i'==6 & pdf==3
	replace payoff`i'=60 if optionposition`i'==7 & pdf==3
	replace payoff`i'=58 if optionposition`i'==8 & pdf==3
	replace payoff`i'=57 if optionposition`i'==9 & pdf==3
	replace payoff`i'=54 if optionposition`i'==10 & pdf==3
	replace payoff`i'=53 if optionposition`i'==11 & pdf==3
	replace payoff`i'=49 if optionposition`i'==12 & pdf==3
	replace payoff`i'=46 if optionposition`i'==13 & pdf==3
	replace payoff`i'=43 if optionposition`i'==14 & pdf==3
	replace payoff`i'=38 if optionposition`i'==15 & pdf==3
	replace payoff`i'=36 if optionposition`i'==16 & pdf==3
	replace payoff`i'=78 if optionposition`i'==1 & pdf==4
	replace payoff`i'=72 if optionposition`i'==2 & pdf==4
	replace payoff`i'=69 if optionposition`i'==3 & pdf==4
	replace payoff`i'=67 if optionposition`i'==4 & pdf==4
	replace payoff`i'=66 if optionposition`i'==5 & pdf==4
	replace payoff`i'=62 if optionposition`i'==6 & pdf==4
	replace payoff`i'=60 if optionposition`i'==7 & pdf==4
	replace payoff`i'=57 if optionposition`i'==8 & pdf==4
	replace payoff`i'=55 if optionposition`i'==9 & pdf==4
	replace payoff`i'=53 if optionposition`i'==10 & pdf==4
	replace payoff`i'=52 if optionposition`i'==11 & pdf==4
	replace payoff`i'=48 if optionposition`i'==12 & pdf==4
	replace payoff`i'=46 if optionposition`i'==13 & pdf==4
	replace payoff`i'=43 if optionposition`i'==14 & pdf==4
	replace payoff`i'=41 if optionposition`i'==15 & pdf==4
	replace payoff`i'=34 if optionposition`i'==16 & pdf==4
}

*add highest avialable payoff for each pdf
gen maxpayoff=0
replace maxpayoff=82 if pdf==0
replace maxpayoff=80 if pdf==1
replace maxpayoff=80 if pdf==2
replace maxpayoff=79 if pdf==3
replace maxpayoff=78 if pdf==4

*create money left on the table measure for every final decision
genl mlot=maxpayoff-pay

*must save data in pieces to create by round efficiency measures
preserve

drop if taskall==2
drop if taskall==3
save tb1, replace


restore
preserve


*tournament
keep if taskall==3
*create optimality and mlot measures for each round in multiround tasks
egen maxpayoffround1=rowmax(payoff1-payoff4) if taskall==3
egen maxpayoffround2=rowmax(payoff5-payoff8) if taskall==3
egen maxpayoffround3=rowmax(payoff9-payoff12) if taskall==3
egen maxpayoffround4=rowmax(payoff13-payoff16) if taskall==3
egen maxpayoffround5=rowmax(payoffround1-payoffround4) if taskall==3
forval i=1/5 {
	genl mlotround`i'=maxpayoffround`i'-payoffround`i' if taskall==3
}
save tb2, replace


restore


*elimination
keep if taskall==2
*create optimality and mlot measures for each round in multiround tasks
egen maxpayoffround1=rowmax(payoff1-payoff4) if taskall==2
egen maxpayoffround2=rowmax(payoffround1 payoff5-payoff7) if taskall==2
egen maxpayoffround3=rowmax(payoffround2 payoff8-payoff10) if taskall==2
egen maxpayoffround4=rowmax(payoffround3 payoff11-payoff13) if taskall==2
egen maxpayoffround5=rowmax(payoffround4 payoff14-payoff16) if taskall==2
forval i=1/5 {
	genl mlotround`i'=maxpayoffround`i'-payoffround`i' if taskall==2
}
save tb3, replace


*put data back together
use tb1, clear
append using tb2
append using tb3
sort id task

*set all round specific variables in round 1 to actual choice in one round tasks (simultaneous)
replace optionround1=option if taskall==0 | taskall==1 | taskall==4
replace payoffround1=pay if taskall==0 | taskall==1 | taskall==4
*replace choiceround1=numoption if taskall==0 | taskall==1 | taskall==4
replace timeround1=time if taskall==0 | taskall==1 | taskall==4
replace maxpayoffround1=maxpayoff if taskall==0 | taskall==1 | taskall==4
replace mlotround1=mlot if taskall==0 | taskall==1 | taskall==4

*create optimal variable for every round
forval i=1/5 {
	gen optimalround`i'=(payoffround`i'==maxpayoffround`i')
}
*make sure optimalround>1 is missing for round>1 in single round tasks
forval i=2/5 {
	replace optimalround`i'=. if taskall==0 | taskall==1 | taskall==4
}

*education
label define education 1 "High school" 2 "Some college" 3 "College" 
label values education education

gen highschool=(education==1)
gen somecollege=(education==2)
gen college=(education==3)

*demographic variables
gen male=(sex=="M")
placevar male education highschool somecollege college, after(age)

* earnings
gen int earnings=0
placevar earnings, before(earningstask1)
forval i=1/4 {
	replace earnings=earningstask`i' if numericaltaskorder==`i'
}
drop earningstask*

*time variables
rename instime instructiontime
rename exptime totaltime

*task preference rankings
forval i=1/3 {
	bys id: egen tb`i'=max(orderofmethod`i')
}
gen taskranking=.
forval i=1/3 {
	replace taskranking=tb`i' if task==`i'
}
drop tb* orderofmethod*
placevar taskranking, after(task)

gen task4ismostpreferred=(task==4 & (taskall==methodchoice1))
placevar task4ismostpreferred, after(taskranking)

* labeldata
label var numericaltaskorder "Order in which tasks were seen"
label define task 0 "Practice" 1 "Simultaneous" 2 "Elimination" 3 "Tournament" 4 "Choose"
label values task taskchoose taskall methodchoice* task
label var task "Task"
label var taskchoose "Chosen task"
label var taskall "Combined task and chosen task"
label var taskranking "Preference rank for each task"
label var taskname "Task name"
label var pdf "PDF"
label var option "Chosen option"
label var optimal "Optimal option chosen"
label var payoff "Chosen payoff"
label var time "Time spent in the task"
forval i=1/5 {
	label var optionround`i' "Option chosen in round `i'"
	label var timeround`i' "Time spent in round `i'"
	label var maxpayoffround`i' "Maximum payoff in round `i'"
	label var mlotround`i' "Money left on table local in round `i'"
	label var optimalround`i' "Optimal chosen local in round `i'"
	label var payoffround`i' "Payoff of chosen option in round `i'"
}
label var earnings "Task earnings"
forval i=1/16 {
	label var optionposition`i' "Option in position `i'"
	label var payoff`i' "Payoff in position `i'"
}
label var methodchoice1 "Most preferred task"
label var methodchoice2 "Second most preferred task"
label var methodchoice3 "Least preferred task"
label var instructiontime "Time spent on instructions"
label var totaltime "Total time spent in experiment"
label var mlot "Efficiency money left on the table, maxpayoff-pay"
label var task4ismostpreferred "The last task is the most preferred one"

sort id task

preserve



**********************************
*
*    Data to replicate table 3 
*
**********************************

*keep variables needed to replicate table 3
keep id age male numericaltaskorder task taskall pdf option optimal pay mlot time earnings instructiontime totaltime education highschool somecollege college 

save data_file1, replace

restore



**********************************************
*
*    Data to replicate table 5 
*
**********************************************

*formatting of data for table 5 needs to be done in steps, one for each round and then remerge all rounds

*Tournament

preserve

*first round
keep if task==3
keep id numericaltask task taskall option age male pdf optionposition* optionround* payoff*
drop payoff
gen round=1
forval i=1/16 {
	rename optionposition`i' availableoption`i'
}
drop option
rename optionround1 option
drop optionround*
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option availableoption
*keep round 1 options
keep if tb>=1 & tb<=4
drop tb
save tb1, replace

restore
preserve

*second round
keep if task==3
keep id numericaltask task taskall option age male pdf optionposition* optionround* payoff*
drop payoff
gen round=2
forval i=1/16 {
	rename optionposition`i' availableoption`i'
}
drop option
rename optionround2 option
drop optionround*
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option availableoption
*keep round 2 options
keep if tb>=5 & tb<=8
drop tb
save tb2, replace

restore
preserve

*third round
keep if task==3
keep id numericaltask task taskall option age male pdf optionposition* optionround* payoff*
drop payoff
gen round=3
forval i=1/16 {
	rename optionposition`i' availableoption`i'
}
drop option
rename optionround3 option
drop optionround*
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option availableoption
*keep round 3 options
keep if tb>=9 & tb<=12
drop tb
save tb3, replace

restore
preserve

*fourth round
keep if task==3
keep id numericaltask task taskall option age male pdf optionposition* optionround* payoff*
drop payoff
gen round=4
forval i=1/16 {
	rename optionposition`i' availableoption`i'
}
drop option
rename optionround4 option
drop optionround*
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option availableoption
*keep round 4 options
keep if tb>=13 & tb<=16
drop tb
save tb4, replace

restore
preserve

*final round
keep if task==3
keep id numericaltask task taskall option age male pdf optionround* payoffround*
gen round=5
drop option
rename optionround5 option
forval i=1/4 {
	rename optionround`i' availableoption`i'
	rename payoffround`i' payoff`i'
}
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option availableoption payoffround*
drop tb
save tb5, replace

restore

*Elimination

preserve

*first round
keep if task==2
keep id numericaltask task taskall option age male pdf optionposition* optionround* payoff*
drop payoff
gen round=1
gen chosen_lastround=0
drop option
rename optionround1 option
drop optionposition5-optionposition16 optionround* payoff5-payoff16 
forval i=1/4 {
	rename optionposition`i' availableoption`i'
}
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option availableoption 
drop tb
save tb6, replace

restore
preserve

*second round
keep if task==2
keep id numericaltask task taskall option age male pdf optionposition* optionround* payoff* payoffround*
drop payoff
gen round=2
gen lastroundoption=optionround1
drop option
rename optionround2 option
rename optionround1 availableoption1
drop payoff1-payoff4 payoff8-payoff16
rename payoffround1 payoff1
forval i=5/7 {
	rename optionposition`i' availableoption`i'
}
drop optionround* optionposition* payoffround*
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option
gen chosen_lastround=(lastroundoption==availableoption)
drop lastroundoption availableoption  
drop tb
save tb7, replace

restore
preserve

*third round
keep if task==2
keep id numericaltask task taskall option age male pdf optionposition* optionround* payoff* payoffround*
drop payoff
gen round=3
gen lastroundoption=optionround2
drop option
rename optionround3 option
rename optionround2 availableoption1
drop payoff1-payoff7 payoff11-payoff16
rename payoffround2 payoff1
forval i=8/10 {
	rename optionposition`i' availableoption`i'
}
drop optionround* optionposition* payoffround*
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option
gen chosen_lastround=(lastroundoption==availableoption)
drop lastroundoption availableoption  
drop tb
save tb8, replace

restore
preserve

*fourth round
keep if task==2
keep id numericaltask task taskall option age male pdf optionposition* optionround* payoff* payoffround*
drop payoff
gen round=4
gen lastroundoption=optionround3
drop option
rename optionround4 option
rename optionround3 availableoption1
drop payoff1-payoff10 payoff14-payoff16
rename payoffround3 payoff1
forval i=11/13 {
	rename optionposition`i' availableoption`i'
}
drop optionround* optionposition* payoffround*
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option
gen chosen_lastround=(lastroundoption==availableoption)
drop lastroundoption availableoption  
drop tb
save tb9, replace

restore
preserve

*fifth round
keep if task==2
keep id numericaltask task taskall option age male pdf optionposition* optionround* payoff* payoffround*
drop payoff
gen round=5
gen lastroundoption=optionround4
drop option
rename optionround5 option
rename optionround4 availableoption1
drop payoff1-payoff13
rename payoffround4 payoff1
forval i=14/16 {
	rename optionposition`i' availableoption`i'
}
drop optionround* optionposition* payoffround*
reshape long availableoption payoff, i(id) j(tb)
gen chosen=(option==availableoption)
drop option
gen chosen_lastround=(lastroundoption==availableoption)
drop lastroundoption availableoption 
drop tb
save tb10, replace


clear
*put all the files back together
forval i=1/10 {
	append using tb`i'
}
drop payoffround*
replace chosen_lastround=0 if task==3

gen csevar=id*1000+task*100+taskall*10+round
replace payoff=payoff/100

save data_file2, replace

restore



**********************************************
*
*    Data to replicate tables 2, 4, and 6 
*
**********************************************

*need to save the data in pieces, separate file for each multiple round experiment, then recombine together
*need to define a new variable -- call it finalchoice which picks up the final decision -- only relevant for multiple round decisions, for others it will always be 1

preserve

keep id task taskall optimal mlot optimalround* mlotround*
keep if task==1
reshape long optimalround mlotround, i(id) j(round)
save tb1, replace

restore
preserve

keep id task taskall optimal mlot optimalround* mlotround*
keep if task==2
reshape long optimalround mlotround, i(id) j(round)
save tb2, replace

restore
preserve

keep id task taskall optimal mlot optimalround* mlotround*
keep if task==3
reshape long optimalround mlotround, i(id) j(round)
save tb3, replace

restore
preserve

keep id task taskall optimal mlot optimalround* mlotround*
keep if task==4
reshape long optimalround mlotround, i(id) j(round)
save tb4, replace

clear
forval i=1/4 {
	append using tb`i'
}

label var round "Round of a multiround task"
label var optimal "Chosen option in task is optimal"
label var mlot "Money left on the table for option chosen in the task"
label var optimalround "Chosen option is a local optimum"
label var mlotround "Money left on the table local in the round"

sort id task round
*drop additional obs created for single round tasks
drop if task==.

save data_file3, replace

restore



**********************************************
*
*    Data to replicate tables 7 and 8 
*
**********************************************

drop optionround1-optionround5 timeround1-timeround5 optionposition1-optionposition16 payoff1-payoff16 payoffround1-payoffround5 maxpayoffround1-maxpayoffround5 mlotround1-mlotround5 optimalround1-optimalround5 task4ismostpreferred
reshape wide taskall optimal numericaltaskorder taskchoose taskname taskranking pdf option pay payoff maxpayoff mlot time earnings methodchoice1-methodchoice3, i(id) j(task)

drop methodchoice*0 methodchoice*1 methodchoice*2 methodchoice*3
rename methodchoice14 mostpreferredmethod
rename methodchoice24 middlepreferredmethod
rename methodchoice34 leastpreferredmethod
label values mostpreferredmethod middlepreferredmethod leastpreferredmethod task
placevar mostpreferredmethod middlepreferredmethod leastpreferredmethod, after(id)


*create measures picking out in which tasks subject did unambiguously best
*used to see whether they selected that task in the last round
*the measure picks out the task in which the subject did better than all else, regardless of whether the optimum was selected
*based on the ordinal ranking of the chosen option
gen unambest=0
replace unambest=1 if (option1<option2 & option1<option3)
replace unambest=2 if (option2<option1 & option2<option3)
replace unambest=3 if (option3<option1 & option3<option2)

keep id time1 time3 mostpreferred unambest

save data_file4, replace



