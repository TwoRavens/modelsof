cd "~/Desktop/Research/College Sports/Data Archive/"

set more off

tempfile tempdata temp_ipeds temp_vse

cd "Raw College Data/IPEDS/"
do "import IPEDS data.do"
cd ../..
clear
cd "Raw College Data/VSE/"
do "import VSE data.do"
cd ../..
clear
cd "Raw College Data/US News/"
do "import US News data.do"
cd ../..
clear

use "Raw College Data/IPEDS/ipeds data.dta"
!rm "Raw College Data/IPEDS/ipeds data.dta"
sort unitid year
save `tempdata'
use "Raw College Data/IPEDS/ipeds_vse_crosswalk.dta"
sort unitid
merge unitid using `tempdata'
tab _merge
drop if _merge==1 | _merge==2
assert _merge==3
drop _merge
sort teamname year
save `temp_ipeds'

use "Raw College Data/VSE/vse_data.dta"
!rm "Raw College Data/VSE/vse_data.dta"

rename fiscalyear year
replace vseteamname = rtrim(vseteamname)
sort vseteamname year
save `tempdata', replace
use "Raw College Data/VSE/ipeds_vse_crosswalk.dta"
sort vseteamname
merge vseteamname using `tempdata'
tab _merge
drop if _merge==1 | _merge==2
assert _merge==3
drop _merge
sort teamname year
save `temp_vse'

use "Raw College Data/US News/usnews_data.dta"
!rm "Raw College Data/US News/usnews_data.dta"
gen year = year_of_pub - 1
drop if school=="Univ of Alabama -Birmingham" & year_of_pub==1998 & acceptance_rate==85
sort school year
save `tempdata', replace
use "Raw College Data/US News/usnews_crosswalk.dta"
sort school
merge school using `tempdata'
tab _merge
replace teamname = "Louisiana State" if school=="Louisiana State University at Baton Rouge" & _merge==2
replace teamname = "North Carolina State" if school=="North Carolina State University at Raleigh" & _merge==2
replace teamname = "North Carolina State" if school=="North Carolina State University--Raleigh*" & _merge==2
replace teamname = "Penn State" if school=="Pennsylvania State University--University Park*" & _merge==2
replace teamname = "Rutgers" if school=="Rutgers, St. U. of N.J.--N.Brun.* " & _merge==2
replace teamname = "Rutgers" if school=="Rutgers, the State University of New Jersey--New Brunswick(NJ)*" & _merge==2
replace teamname = "Illinois" if school=="University of Illinois--Urbana - Champaign*" & _merge==2
replace teamname = "North Carolina" if school=="University of North Carolina at Chapel Hill" & _merge==2
replace teamname = "North Carolina" if school=="University of North Carolina--Chapel Hill*" & _merge==2
replace teamname = "South Carolina" if school=="University of South Carolina at Columbia" & _merge==2
drop if _merge==1 | (_merge==2 & teamname=="")
assert (_merge==2 | _merge==3) & teamname!=""
drop _merge
sort teamname year

merge teamname year using `temp_vse'
tab _merge
drop _merge
sort teamname year
merge teamname year using `temp_ipeds'
tab _merge
drop _merge

*** Set clear data errors to missing

gen vse_alum_giving_rate = alumni_donors/alumni_of_record

replace alumni_giving_rate = . if teamname=="Brigham Young" & year==1993
replace alumni_giving_rate = . if teamname=="Iowa" & year==1993
replace alumni_giving_rate = . if teamname=="Kent State" & year==1995
replace alumni_giving_rate = . if teamname=="Minnesota" & year==1993
replace alumni_giving_rate = . if teamname=="Nebraska" & year==1993
replace alumni_giving_rate = . if teamname=="Ohio" & year==1995
replace alumni_giving_rate = . if teamname=="Texas" & year==1995
replace usnews_academic_rep_new = . if year==1996
replace vse_alum_giving_rate = . if teamname=="Tulsa" & year==1993

sum alumni_giving_rate top10pct acceptance_rate usnews_academic_rep_new vse_alum_giving_rate alumni_ops_athletics alumni_ops_total alumni_total_giving ops_athletics_total_ath athletics_total athletics_donors ops_athletics_total_grand total_giving_pre_2004 applicants_male applicants_female admits_male admits_female enrolled_male enrolled_female satvr25 satvr75 satmt25 satmt75 black asian hispanic

replace vse_alum_giving_rate = . if vse_alum_giving_rate>=1
replace alumni_ops_athletics = . if alumni_ops_athletics==0
replace ops_athletics_total_ath = . if ops_athletics_total_ath==0
replace athletics_total = . if athletics_total==0
replace athletics_donors = . if athletics_donors==0
replace ops_athletics_total_grand = . if ops_athletics_total_grand==0
replace athletics_donors = . if alumni_ops_athletics==0
replace athletics_donors = . if alumni_ops_athletics==0
replace enrolled_female = . if enrolled_female<150
replace black = . if black<0
replace asian = . if black<0
replace hispanic = . if black<0


*** Generate in-state vs out-of-state first time students variables

gen first_time_students_missing = first_time_students98 + first_time_students999 if first_time_students98!=. & first_time_students999!=.
replace first_time_students_missing = first_time_students98 if first_time_students98!=. & first_time_students_missing==.
replace first_time_students_missing = first_time_students999 if first_time_students999!=. & first_time_students_missing==.
gen first_time_students_total = first_time_students99
drop first_time_students98 first_time_students99 first_time_students999

gen first_time_outofstate = .
gen first_time_instate = .
foreach homestate of numlist 1 4 5 6 8 9 12 13 15 16 17 18 19 20 21 22 24 25 26 27 28 29 31 32 34 35 36 37 39 40 41 42 45 47 48 49 51 53 54 55 56 {
	replace first_time_outofstate = 0 if fips==`homestate' & first_time_students`homestate'!=.
	replace first_time_instate = first_time_students`homestate' if fips==`homestate'
}

foreach varlabel of numlist 1 2 4 5 6 8 9 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56 57 60 64 66 69 72 78 90 68 70 {
	replace first_time_outofstate = first_time_outofstate + first_time_students`varlabel' if fips!=`varlabel' & first_time_students`varlabel'!=.
}

drop first_time_students1-first_time_students70

drop fouryear maxfouryear

compress
save "college data.dta", replace
