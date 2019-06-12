clear

cd "/Users/bnyhan/Documents/Dropbox/Congressional staff/Replication Archive/"


/*staff descriptives*/

use "staff-descriptives.dta", clear /*due to contractual obligations required to license these data, we are unable to redistribute them in their raw form; the code used to generate these results is below, however, and we are happy to demonstrate that they replicate upon request. please contact the authors for more information.*/

count
tab cong

/*Fig 1a - staff per member by Congress*/
preserve

gen n=1
collapse (sum) n,by(person_id EntityID cong)
drop n
gen n=1
collapse (sum) n,by(EntityID cong)
su

collapse (mean) n,by(cong)

rename n allstaff
sort cong
list
save "stafferspermember.dta", replace

restore

preserve

keep if policypolitical==1

gen n=1
collapse (sum) n,by(person_id EntityID cong)
drop n
gen n=1
collapse (sum) n,by(EntityID cong)
su

collapse (mean) n,by(cong)

keep if cong>=105 /*unifying figs (a) and (b) to avoid confusion*/
sort cong

merge 1:1 cong using "stafferspermember.dta"
tab _merge
keep if cong>=105 /*unifying figs (a) and (b) to avoid confusion*/

twoway (line allstaff cong)(line n cong), ylab(0(5)25,nogrid) ymtick(1(1)25) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ytitle("Average per member") scheme(s2mono) xtitle("Congress") xlab(105(1)111) legend(lab(1 "All staff") lab(2 "Senior/policy staff"))

rm "stafferspermember.dta"

list

restore

/*descriptives - turnover*/

preserve

keep if policypolitical==1

gen n=1
collapse (sum) n,by(person_id EntityID cong)
drop n
duplicates report person_id cong
duplicates tag person_id cong,gen(duplicate)
collapse (max) duplicate,by(person_id cong)
reg duplicate i.cong
restore

preserve

keep if policypolitical==1

gen n=1
collapse (sum) n,by(person_id EntityID cong)

egen person_id_cong=group(person_id cong)

bysort person_id cong: gen numobspercong=_n

drop n
reshape wide EntityID, i(person_id_cong) j(numobspercong)

xtset person_id cong
gen leavenext=(cong+1!=f.cong)
tab leavenext if cong!=111 /*50% not observed in next congress, excludees 111 because we don't have 112*/
tab leavenext cong  if cong!=111,col chi /*rates vary from 56% exit in 104th after serving in 103 to 46% exit in 105th after serving in 104th*/

gen sameofficewithleavers=((EntityID1==f.EntityID1 & EntityID1!=.) | (EntityID1==f.EntityID2 & EntityID1!=.)  | (EntityID1==f.EntityID3 & EntityID1!=.) | (EntityID2==f.EntityID1 & EntityID2!=.) | (EntityID2==f.EntityID2 & EntityID2!=.) | (EntityID2==f.EntityID3 & EntityID2!=.) | (EntityID3==f.EntityID1 & EntityID3!=.) | (EntityID3==f.EntityID2 & EntityID3!=.) | (EntityID3==f.EntityID3 & EntityID3!=.))
tab sameofficewithleavers if cong!=111 /*45% overall*/
tab sameofficewithleavers cong  if cong!=111,col chi /*ranges from 40% for 103->104 to 50% for 108->109*/

gen sameofficenoleavers=((EntityID1==f.EntityID1 & EntityID1!=.) | (EntityID1==f.EntityID2 & EntityID1!=.)  | (EntityID1==f.EntityID3 & EntityID1!=.) | (EntityID2==f.EntityID1 & EntityID2!=.) | (EntityID2==f.EntityID2 & EntityID2!=.) | (EntityID2==f.EntityID3 & EntityID2!=.) | (EntityID3==f.EntityID1 & EntityID3!=.) | (EntityID3==f.EntityID2 & EntityID3!=.) | (EntityID3==f.EntityID3 & EntityID3!=.)) if leavenext==0
tab sameofficenoleavers if cong!=111 /*90% overall*/
tab sameofficenoleavers cong  if cong!=111,col chi /*ranges from 88% for 110->111 to 91% for 105->106 and 108->109*/

restore


/*member-staff descriptives*/

/*descriptives for senior staff*/

use "member-staff-senior.dta", clear /*due to contractual obligations required to license these data, we are unable to redistribute them in their raw form; the code used to generate these results is below, however, and we are happy to demonstrate that they replicate upon request. please contact the authors for more information.*/

gen n=1
replace les="" if les=="NA"
destring les, replace
replace ideal="" if ideal=="NA"
destring ideal, replace
gen absideal=abs(ideal)
collapse (mean) ideal absideal les (sum) n,by(icpsr cong) 
pwcorr /*corr of # of senior staff with les = -.01, corr w/ideal= .06, corr w/absideal = -.04 */

/*descriptives for senior/policy staff*/

use "member-staff-policy.dta", clear /*due to contractual obligations required to license these data, we are unable to redistribute them in their raw form; the code used to generate these results is below, however, and we are happy to demonstrate that they replicate upon request. please contact the authors for more information.*/

preserve
gen n=1
replace les="" if les=="NA"
destring les, replace
replace ideal="" if ideal=="NA"
destring ideal, replace
gen absideal=abs(ideal)
collapse (mean) ideal absideal les (sum) n,by(icpsr cong) 
pwcorr /*corr of # of policy staff with les = .02, corr w/ideal= -.06, corr w/absideal = .02 */
restore

/*collapse by cong for nostaff*/
preserve
collapse (max) nostaff,by(cong icpsr)
tab nostaff
tab nostaff cong
restore

preserve

drop if nostaff==1

replace icpsr="999999" if strpos(icpsr,"alt")!=0
destring icpsr, replace
bysort person_id: egen sdicpsr=sd(icpsr)

gen memberswitcher=(sdicpsr!=. & sdicpsr!=0)

bysort person_id: egen maxms=max(memberswitcher)

keep person_id cong maxms
duplicates drop

gen n=1

collapse (sum) n,by(person_id maxms)

su maxms

su maxms if n>4
tab maxms if n>4

restore

destring party, replace
bysort person_id: egen sdparty=sd(party)
gen diffparty=(sdparty>0 & sdparty!=. & stafffirst!="" & stafflast!="" & party!=328) /*last excludes Sanders*/

/*isolate the 43 who worked for different members on both sides rather than those who worked for a party switcher*/
drop if nostaff==1 
keep if diffparty==1
keep person_id congress stateabbrev cd dem thomas_name stafffirst stafflast icpsr
gen last4=substr(icpsr,2,4)
destring icpsr, replace
bysort person_id: egen sdicpsr=sd(icpsr)
drop if sdicpsr==0 | sdicpsr==.
destring last4, replace
bysort person_id: egen sdlast4=sd(last4)
drop if sdlast4==0 | sdlast4==.
keep person_id congress stateabbrev cd dem thomas_name stafffirst stafflast
sort stafflast cong thomas_name

gen diffparty=1
collapse (sum) diffparty,by(person_id)
replace diffparty=1 if diffparty>0 & diffparty!=.
tab diffparty
su


/*member descriptives*/
import delimited "combinedData.csv", clear
xtset icpsr cong
replace les="" if les=="NA"
destring les, replace
replace ideal="" if ideal=="NA"
destring ideal, replace
corr ideal l.ideal 
corr les l.les 
