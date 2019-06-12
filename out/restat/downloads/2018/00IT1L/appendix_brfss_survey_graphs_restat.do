 set more off
 global mypath "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\brfss"
 use "${mypath}\raw\brfss_2012.dta", clear
destring _all, replace
save "\\rschfs1x\userrs\dbr88_RS\Documents\Selection\BRFSS\raw\brfss_2012.dta", replace
 
 
 ***Clean and format variables for use
	label  define states  1 "Alabama" 	  2 "Alaska"  4 "Arizona"   5 "Arkansas"   6 "California"  8 "Colorado"  9 "Connecticut"  10 "Delaware"   11 "District of Columbia"   12 "Florida"  13 "Georgia"   15 "Hawaii"  16 "Idaho"  17 "Illinois"  18 "Indiana"  19 "Iowa "  20 "Kansas"  21 "Kentucky"  22 "Louisiana"   23 "Maine"  24 "Maryland"  25 "Massachusetts"  26 "Michigan"  27 "Minnesota"  28 "Mississippi"  29 "Missouri"  30 "Montana"  31 "Nebraska"  32 "Nevada "  33 "New Hampshire"  34 "New Jersey"  35 "New Mexico"  36 "New York"  37 "North Carolina"  38 "North Dakota"  39 "Ohio"  40 "Oklahoma"  41 "Oregon"  42 "Pennsylvania"  44 "Rhode Island"  45 "South Carolina"  46 "South Dakota"  47 "Tennessee"  48 "Texas"  49 "Utah "  50 "Vermont "  51 "Virginia "  53 "Washington"  54 "West Virginia"  55 "Wisconsin"  56 "Wyoming"  66 "Guam "  72 "Puerto Rico" 
	label values _state states

decode _state, g(state)
replace state=trim(state)
levelsof state, local(states)

*Interview characteristics
destring iday, replace
destring imonth, replace
destring iyear, replace
*/

********ATTEMPTS GRAPH**********
cd ${mypath}/figures/attempts

g attempts=nattmpts
replace attempts=35 if attempts>=35 & attempts!=.
	label define attempts 5 "5" 10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35+"
	label values attempts attempts
**Overall histogram
histogram attempts , title("All") yline(.05 .1 .15 .2 .25 .3 .35 , lstyle(grid)) scheme(sj) xtitle("") xlabel(none) xticks(0(5)35) ytitle("Percentage") yscale(range(0.35)) yticks(0(0.05)0.35) ylabel(0(0.05)0.35, angle(horizontal) nogrid gmax) discrete fraction saving("All", replace)

**Creating a seperate histogram for each state
local i=2
foreach c of local states {
	di "`c'"
	di "`c'" 
		if `i'>=49 {
		local x_options `" xtitle("Number of call attempts") xticks(0(5)35) xlabel(5(5)35, valuelabel)"'
		}
		else if `i'<49 {
			local x_options `" xtitle("") xlabel(none) xticks(0(5)35)"'
		}
		if  (mod(`i',8)==1 & "`i'"!="1") | ("`c'"=="All") {
		local y_options `" ytitle("Percentage") yscale(range(0.35)) yticks(0(0.05)0.35) ylabel(0(0.05)0.35, angle(horizontal) nogrid gmax) "'
		}
		else if (mod(`i',8)!=1  & "`c'"!="All") | `i'==1 {
			local y_options `" ytitle("") yscale(range(0.35)) yticks(0(0.05)0.35)  ylabel(none)"'
		}
		di `i'
		di `"`y_options'"'
		di `"`x_options'"'



	histogram attempts if state=="`c'" ,  fraction discrete  saving("`c'", replace) title("`c'") yline(.05 .1 .15 .2 .25 .3 .35 , lstyle(grid)) scheme(s2mono) `x_options' `y_options'
	local ++i
}
cd "${mypath}\figures\attempts\"

graph combine All.gph Alabama.gph Alaska.gph Arizona.gph Arkansas.gph California.gph Colorado.gph Connecticut.gph Delaware.gph "District of Columbia.gph" Florida.gph Georgia.gph Guam.gph Hawaii.gph Idaho.gph Illinois.gph Indiana.gph Iowa.gph Kansas.gph Kentucky.gph Louisiana.gph Maine.gph Maryland.gph Massachusetts.gph Michigan.gph Minnesota.gph Mississippi.gph Missouri.gph Montana.gph Nebraska.gph Nevada.gph "New Hampshire.gph" "New Jersey.gph" "New Mexico.gph" "New York.gph" "North Carolina.gph" "North Dakota.gph" Ohio.gph Oklahoma.gph Oregon.gph Pennsylvania.gph "Puerto Rico.gph" "Rhode Island.gph" "South Carolina.gph" "South Dakota.gph" Tennessee.gph Texas.gph Utah.gph Vermont.gph Virginia.gph Washington.gph "West Virginia.gph" Wisconsin.gph Wyoming.gph, scheme(sj) imargin(vsmall) iscale(.3)

graph export ${mypath}\figures\attempts\attempts_2012.pdf, as(pdf) replace

*/

*****DAYS OF THE MONTH GRAPH*******
cd ${mypath}/figures/daysofmonth

***Overall histogram
histogram iday, title("All") yline(.02 .04 .06 .08 .10 .12 , lstyle(grid)) scheme(sj) xtitle("") xlabel(none) xticks(0(5)30) ytitle("Percentage") yscale(range(0.12)) yticks(0(0.02)0.12) ylabel(0(0.02)0.12, angle(horizontal) nogrid gmax) discrete fraction saving("All", replace)
local i=2
***Looping over the states
foreach c of local states {
di "`c'"
di "`c'" 
	if `i'>=49 {
	local x_options `" xtitle("Day of month") xticks(0(5)30) xlabel(0(5)30)"'
	}
	else if `i'<49 {
		local x_options `" xtitle("") xlabel(none) xticks(0(5)30)"'
	}
	if  (mod(`i',8)==1 & "`i'"!="1") | ("`c'"=="All") {
	local y_options `" ytitle("Percentage") yscale(range(0.12)) yticks(0(0.02)0.12) ylabel(0(0.02)0.12, angle(horizontal) nogrid gmax)  yticks(0(0.02)0.12) "'
	}
	else if (mod(`i',8)!=1  & "`c'"!="All") | `i'==1 {
		local y_options `" ytitle("") yscale(range(0.12)) yticks(0(0.02)0.12)  ylabel(none)"'
	}
	di `i'
	di `"`y_options'"'
	di `"`x_options'"'


histogram iday if state=="`c'" ,  fraction discrete  saving("`c'", replace) title("`c'") yline(.02 .04 .06 .08 .10 .12 , lstyle(grid)) scheme(s2mono) `x_options' `y_options'
local ++i
}
cd "${mypath}\figures\daysofmonth\"

graph combine All.gph Alabama.gph Alaska.gph Arizona.gph Arkansas.gph California.gph Colorado.gph Connecticut.gph Delaware.gph "District of Columbia.gph" Florida.gph Georgia.gph Guam.gph Hawaii.gph Idaho.gph Illinois.gph Indiana.gph Iowa.gph Kansas.gph Kentucky.gph Louisiana.gph Maine.gph Maryland.gph Massachusetts.gph Michigan.gph Minnesota.gph Mississippi.gph Missouri.gph Montana.gph Nebraska.gph Nevada.gph "New Hampshire.gph" "New Jersey.gph" "New Mexico.gph" "New York.gph" "North Carolina.gph" "North Dakota.gph" Ohio.gph Oklahoma.gph Oregon.gph Pennsylvania.gph "Puerto Rico.gph" "Rhode Island.gph" "South Carolina.gph" "South Dakota.gph" Tennessee.gph Texas.gph Utah.gph Vermont.gph Virginia.gph Washington.gph "West Virginia.gph" Wisconsin.gph Wyoming.gph, scheme(sj) imargin(vsmall) iscale(.3)
graph export ${mypath}\figures\daysofmonth\idays_2012.pdf, as(pdf) replace





*/


*******MONTH GRAPHS*****
cd ${mypath}/figures/month

label define months 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values imonth months

***Overall histogram
histogram imonth, title("All") yline(.04 .08 .12 .16 , lstyle(grid)) scheme(sj) xtitle("") xlabel(none) xticks(1(3)10) ytitle("Percentage") yscale(range(0.16)) yticks(0(0.04)0.16) ylabel(0(0.04)0.16, angle(horizontal) nogrid gmax) discrete fraction saving("All", replace)
local i=2

***Looping over the states
foreach c of local states {
di "`c'"
di "`c'" 
	if `i'>=49 {
	local x_options `" xtitle("Month") xticks(1(3)10) xlabel(1 4 7 10, valuelabel)"'
	}
	else if `i'<49 {
		local x_options `" xtitle("") xlabel(none) xticks(1(3)10)"'
	}
	if  (mod(`i',8)==1 & "`i'"!="1") | ("`c'"=="All") {
	local y_options `" ytitle("Percentage") yscale(range(0.16)) yticks(0(0.04)0.16) ylabel(0(0.04)0.16, angle(horizontal) nogrid gmax)  "'
	}
	else if (mod(`i',8)!=1  & "`c'"!="All") | `i'==1 {
		local y_options `" ytitle("") yscale(range(0.16)) yticks(0(0.04)0.16)  ylabel(none)"'
	}
	di `i'
	di `"`y_options'"'
	di `"`x_options'"'


histogram imonth if state=="`c'" ,  fraction discrete  saving("`c'", replace) title("`c'") yline(.04 .08 .12 .16 , lstyle(grid)) scheme(s2mono) `x_options' `y_options'
local ++i
}
cd "${mypath}\figures\month\"

graph combine All.gph Alabama.gph Alaska.gph Arizona.gph Arkansas.gph California.gph Colorado.gph Connecticut.gph Delaware.gph "District of Columbia.gph" Florida.gph Georgia.gph Guam.gph Hawaii.gph Idaho.gph Illinois.gph Indiana.gph Iowa.gph Kansas.gph Kentucky.gph Louisiana.gph Maine.gph Maryland.gph Massachusetts.gph Michigan.gph Minnesota.gph Mississippi.gph Missouri.gph Montana.gph Nebraska.gph Nevada.gph "New Hampshire.gph" "New Jersey.gph" "New Mexico.gph" "New York.gph" "North Carolina.gph" "North Dakota.gph" Ohio.gph Oklahoma.gph Oregon.gph Pennsylvania.gph "Puerto Rico.gph" "Rhode Island.gph" "South Carolina.gph" "South Dakota.gph" Tennessee.gph Texas.gph Utah.gph Vermont.gph Virginia.gph Washington.gph "West Virginia.gph" Wisconsin.gph Wyoming.gph, scheme(sj) imargin(vsmall) iscale(.3) 
graph export ${mypath}\figures\month\imonths_2012.pdf, as(pdf) replace
*/

******DAYS OF WEEK GRAPH*****
destring imonth iday iyear, replace
g double date=mdy(imonth, iday, iyear)
format date %td
g dow=dow(date)
label define days 0 "Sun" 1 "Mon" 2 "Tue" 3 "Wed" 4 "Thu" 5 "Fri" 6 "Sat" 
label value dow days



cd ${mypath}/figures/daysofweek

***Overall histogram
histogram dow, title("All") yline(.1 .2 .3, lstyle(grid)) scheme(sj) xtitle("") xlabel(none) xticks(0(3)6) ytitle("Percentage") yscale(range(0.35)) yticks(0(0.05)0.35) ylabel(0(0.1)0.3, angle(horizontal) nogrid gmax) discrete fraction saving("All", replace)
local i=2

**Looping over the states
foreach c of local states {
di "`c'"
di "`c'" 
	if `i'>=49 {
	local x_options `" xtitle("Day of week") xticks(0(3)6) xlabel(0 3 6, valuelabel)"'
	}
	else if `i'<49 {
		local x_options `" xtitle("") xlabel(none) xticks(0(3)6)"'
	}
	if  (mod(`i',8)==1 & "`i'"!="1") | ("`c'"=="All") {
	local y_options `" ytitle("Percentage") yscale(range(0.35)) yticks(0(0.5)0.35) ylabel(0(0.1)0.3, angle(horizontal) nogrid gmax)  "'
	}
	else if (mod(`i',8)!=1  & "`c'"!="All") | `i'==1 {
		local y_options `" ytitle("") yscale(range(0.35)) yticks(0(0.05)0.35)  ylabel(none)"'
	}
	di `i'
	di `"`y_options'"'
	di `"`x_options'"'


histogram dow if state=="`c'" ,  fraction discrete  saving("`c'", replace) title("`c'") yline(.1 .2 .3 , lstyle(grid)) scheme(s2mono) `x_options' `y_options'
local ++i
}
cd "${mypath}\figures\daysofweek\"

graph combine All.gph Alabama.gph Alaska.gph Arizona.gph Arkansas.gph California.gph Colorado.gph Connecticut.gph Delaware.gph "District of Columbia.gph" Florida.gph Georgia.gph Guam.gph Hawaii.gph Idaho.gph Illinois.gph Indiana.gph Iowa.gph Kansas.gph Kentucky.gph Louisiana.gph Maine.gph Maryland.gph Massachusetts.gph Michigan.gph Minnesota.gph Mississippi.gph Missouri.gph Montana.gph Nebraska.gph Nevada.gph "New Hampshire.gph" "New Jersey.gph" "New Mexico.gph" "New York.gph" "North Carolina.gph" "North Dakota.gph" Ohio.gph Oklahoma.gph Oregon.gph Pennsylvania.gph "Puerto Rico.gph" "Rhode Island.gph" "South Carolina.gph" "South Dakota.gph" Tennessee.gph Texas.gph Utah.gph Vermont.gph Virginia.gph Washington.gph "West Virginia.gph" Wisconsin.gph Wyoming.gph, scheme(sj) imargin(vsmall) iscale(.3) 
graph export ${mypath}\figures\daysofweek\dow_2012.pdf, as(pdf) replace
*/
















