clear
cd "/Users/kclay/Dropbox/Lead/lead/data sets and do files"
set more off
log using restat_replication.smcl, replace

**Merging
*City infant mortality
use cityinfmort6.dta
*Assigning lead status to cities
do masslead.do
drop if masslead==.
*Merging in city demographics
sort cityd
merge cityd using citych.dta
drop _merge
drop if masslead==.
*Merging in hardness and acidity
sort cityd
merge cityd using hardnessacidity6.dta
drop _merge
*Merging in state precipitation and temperature
*Giving DC the attributes for VA for precip and temp
replace stateicp = 40 if stateicp==98
sort stateicp
merge stateicp using statepcp.dta
drop _merge
sort stateicp
merge stateicp using statetemp.dta
drop _merge
rename avtemp statetempav
rename avpcp statepcpav

*Cleanup
drop if cityd==0
drop if masslead==0
drop if cityd==.

*Reshaping
reshape long allcount infcount pop popfive popsixty citypop white read age working workingwomen ownhome fborn momcount, i(cityd) j(year)
*Correcting some populations
replace citypop = 197 if cityd==4550 & year==1910
replace citypop = 194 if cityd==4550 & year==1905

*Merging in Typhoid and Tuberculosis
sort cityd year
merge cityd year using typtuball.dta
drop _merge
sort cityd year
**Merging completed


*Lead and acidity variables
rename masslead lead
*leadb is dummy for any lead (0=no lead, 1 = mixed or only lead)
gen leadb = 0
replace leadb=0 if lead==1
replace leadb=1 if lead==2 | lead==3
*leadc is dummy for only lead (0=no lead or mixed lead, 1 = only lead)
gen leadc = 0
replace leadc = 1 if lead==3

rename acidity ph
gen origph = ph
gen ph1 = origph-6.675
gen lnph = ln(origph-5.675)
gen lnhardness = ln(hardness)

gen lead1 = lead
replace lead1 = 4 if lead==1 & origph>7.3
replace lead1 = 5 if lead==2 & origph>7.3
replace lead1 = 6 if lead==3 & origph>7.3

gen leadlowph = 0
replace leadlowph = 1 if lead==3 & ph<=7.3

gen phharda = ph1*hardness

gen time = year - 1899
gen timeph = time*ph1

*Generating infant mortality by acidity for cities with lead pipes
gen infrate = infcount/citypop
egen acid1 = mean(infrate) if lead==3 & ph<=6.5 & infrate!=., by(year)
egen acid2 = mean(infrate) if lead==3 & ph>6.5 & ph<=7.3 & infrate!=., by(year)
egen acid3 = mean(infrate) if lead==3 & ph>7.3 & ph<=7.8& infrate!=., by(year)
egen acid4 = mean(infrate) if lead==3 & ph>7.8 & infrate!=., by(year)


*City populations
gen ncitypop = 1
replace ncitypop = 2 if citypop>214.5
replace ncitypop = 3 if citypop>357.5
replace ncitypop = 4 if citypop>804
egen leadpop = sum(citypop)if year==1900 & infrate~=., by(lead)


*Region, agglomerating other regions beyond 21 into a single region
gen nregion = 1 if region==11
replace nregion = 2 if region==12
replace nregion = 3 if region==21
replace nregion = 4 if region>21

*Generating control variables
gen adultrate = (allcount-infcount)/citypop
gen momshare = momcount/citypop
gen popfiveshare = popfive/citypop
gen popsixtyshare = popsixty/citypop
gen tyrate = typ/citypop
gen nptubrate = nptub/citypop
replace popsixtyshare = 0 if popsixtyshare==.

*Dropping cities without populations and without infant mortality
drop if citypop ==.
drop if infrate==. & year>1900
sort cityd
egen cityfreq = count(year), by(cityd)
drop if cityfreq==1 & year==1900 & infrate==.

*Standardizing some control variables to have mean 0, sd 1
egen ntyph = std(tyrate)
drop tyrate
rename ntyph tyrate

egen nnptub = std(nptubrate)
drop nptubrate
rename nnptub nptubrate

egen nstatetempav = std(statetempav)
drop statetempav
rename nstatetempav statetempav

egen nstatepcpav = std(statepcpav)
drop statepcpav
rename nstatepcpav statepcpav

*Labeling variables
label var acid1 "Lowest pH"
label var acid2 "Second lowest pH"
label var acid3 "Third lowest pH"
label var acid4 "Fourth lowest pH"
label var ph "pH"
label var hardness "Hardness"
label var lead "Lead"
label define lead 1 "No lead"  2 "Mixed lead"  3 "Lead only"
label var lead1 "Lead by Acidity"
label define lead1 1 "No lead,pH<=7.3"  2 "Mixed lead,pH<=7.3"  3 "Lead only,pH<=7.3" 4 "No lead,pH>7.3"  5 "Mixed lead,pH>7.3"  6 "Lead only,pH>7.3"
label var nregion "Region"
label define nregion 1 "New England"  2 "Mid-Atlantic"  3 "East North Central" 4 "All other"
label var statepcpav "Precipitation"
label var statetempav "Temperature"
label var lnhardness "ln(hardness)"
label var lnph "ln(pH-5.675)"
label var ph1 "pH-6.675"
label var tyrate "Typhoid"
label var nptubrate "NonPulm Tuberculosis"
label var white "Share White"
label var fborn "Share Foreign Born"
label var momshare "Share Women 20-40"
label var age "Age"
label var popfive "Share Ages 2-5"
label var popsixty "Share Age > 60"
label var ncitypop "City Population"
label define ncitypop 1 "Citypop Q1"  2 "Citypop Q2"  3 "Citypop Q3" 4 "Citypop Q4"

*Table 1: Health Effects from Troesken

*Table 2: Summary Statistics
sum infrate adultrate ph hardness tyrate nptubrate momshare fborn white citypop statepcp statetemp if year==1900 & infrate!=.
sum lead* if year==1900 & infrate!=. & lead==1
sum lead* if year==1900 & infrate!=. & lead==2
sum lead* if year==1900 & infrate!=. & lead==3

*Figure 1 Schock

*Figure 2
sort year
line acid1 acid2 acid3 acid4 year, xtitle("Year") ytitle("Infant Mortality Rate per 100 population ")

*Table 3: Lead Pipes
reg leadc i.ncitypop lnph lnhardness statepcpav statetempav i.nregion tyrate if year==1900 & infrate~=., robust
outreg2 using table3, bdec(3) ctitle("Lead Only")  excel replace
*Column 2a: In the second column leadlowph was incorrectly specified, such that the effect was to use leadc as the dependent variable
reg leadc i.ncitypop lnhardness statepcpav statetempav i.nregion tyrate if year==1900 & infrate~=., robust
outreg2 using table3, bdec(3) ctitle("Lead Only and Low pH")  excel append
*Column 2b: This is the regression that should have been run for column 2. Nothing is statistically significant. 
reg leadlowph i.ncitypop lnhardness statepcpav statetempav i.nregion tyrate if year==1900 & infrate~=., robust
outreg2 using table3, bdec(3) ctitle("Lead Only and Low pH")  excel append
ologit lead i.ncitypop lnph lnhardness statepcpav statetempav i.nregion tyrate if year==1900 & infrate~=., robust
outreg2 using table3, bdec(3) ctitle("Lead Only")  excel append label

*Table 4: Infants 
reg infrate i.lead##c.lnph i.nregion i.ncitypop if year==1900, robust 
outreg2 using table4, bdec(3) ctitle("Inf. Mort")  excel replace 
reg infrate i.lead##c.lnph i.nregion i.ncitypop fborn white momshare statepcpav statetempav if year==1900, robust 
outreg2 using table4, bdec(3) ctitle("Inf. Mort")  excel append
reg infrate i.lead##c.lnph i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1900, robust 
outreg2 using table4, bdec(3) ctitle("Inf. Mort")  excel append
char lead1[omit] 1
reg infrate i.lead1##c.ph1 i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1900, robust 
outreg2 using table4, bdec(3) ctitle("Inf. Mort")  excel append label

*Table 5 with hardness
reg infrate lnph i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1900 & lead==3 , robust 
outreg2 using table5, bdec(3) ctitle("Inf. Mort")  excel replace
reg infrate lnph lnhardness i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1900 & lead==3 , robust 
outreg2 using table5, bdec(3) ctitle("Inf. Mort")  excel append
char lead1[omit] 3
reg infrate i.lead1##c.ph1 i.lead1#c.hardness i.lead1#c.phharda  i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1900 & lead==3, robust 
outreg2 using table5, bdec(4) ctitle("Inf. Mort")  excel append label

*Table 6: All the years
reg infrate i.lead##c.lnph i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1900, robust 
outreg2 using table6, bdec(3) ctitle("Inf. Mort 1900")  excel replace
reg infrate i.lead##c.lnph i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1905, robust 
outreg2 using table6, bdec(3) ctitle("Inf. Mort 1905")  excel append
reg infrate i.lead##c.lnph i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1910, robust 
outreg2 using table6, bdec(3) ctitle("Inf. Mort 1910")  excel append
reg infrate i.lead##c.lnph i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1915, robust 
outreg2 using table6, bdec(3) ctitle("Inf. Mort 1915")  excel append
reg infrate i.lead##c.lnph i.nregion i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav if year==1920, robust 
outreg2 using table6, bdec(3) ctitle("Inf. Mort 1920")  excel append label

*Table 7: Non-infant (the variable is titled adult rate, but is actually non-infant mortality.)
replace popsixty = 0 if popsixty==.
reg adultrate i.lead##c.lnph i.nregion i.ncitypop if year==1900, robust 
outreg2 using table7, bdec(3) ctitle("Non-Inf. Mort")  excel replace
reg adultrate i.lead##c.lnph i.nregion i.ncitypop tyrate nptubrate fborn white age popfive popsixty statepcpav statetempav if year==1900, robust 
outreg2 using table7, bdec(3) ctitle("Non-Inf. Mort")  excel append
reg adultrate i.lead1##c.ph1 i.nregion i.ncitypop tyrate nptubrate fborn white age popfive popsixty statepcpav statetempav if year==1900, robust 
outreg2 using table7, bdec(3) ctitle("Non-Inf. Mort")  excel append label

*Table 1A With city FE (in appendix)
reg infrate i.nregion#c.time i.lead#c.time i.cityd if ph~=. , robust cluster(cityd)
outreg2 using table1a, bdec(4) ctitle("Inf. Mort")  excel replace
reg infrate i.nregion#c.time i.lead#c.time i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav i.cityd if ph~=. , robust cluster(cityd)
outreg2 using table1a, bdec(4) ctitle("Inf. Mort")  excel append
reg infrate i.nregion#c.time i.lead1#c.time i.cityd if ph~=. , robust cluster(cityd)
outreg2 using table1a, bdec(4) ctitle("Inf. Mort")  excel append
reg infrate i.nregion#c.time i.lead1#c.time i.ncitypop tyrate nptubrate fborn white momshare statepcpav statetempav i.cityd if ph~=. , robust cluster(cityd)
outreg2 using table1a, bdec(4) ctitle("Inf. Mort")  excel append label

log close _all
exit


*Below is the code used to build the city characteristics data from Ipums data
****************Building data
drop _all
use "C:\kbc\Personal\Economic History\book\Misc\ipumsdata\1900census.dta" 

gen fborn = 0
replace fborn = 1 if bpld>10000
rename urbpop citypop

gen white = 0
replace white=1 if raced==100

egen momcount = count(sex) if sex==2 & age>=20 & age<=40, by(cityd)
egen pop = count(sex) if age<=1, by(cityd)
egen popfive = count(sex) if age<=5 & age>1, by(cityd)
egen popsixty = count(sex) if age>60, by(cityd)

collapse pop popfive popsixty citypop white age fborn momcount stateicp region* year, by(cityd)
sort cityd
save "C:\kbc\Personal\Economic History\lead\citych.dta", replace

drop _all
use "C:\kbc\Personal\Economic History\book\Misc\ipumsdata\1910census.dta" 

gen fborn = 0
replace fborn = 1 if bpld>10000

gen white = 0
replace white=1 if raced==100

egen momcount = count(sex) if sex==2 & age>=20 & age<=40, by(cityd)
egen pop = count(sex) if age<=1, by(cityd)
egen popfive = count(sex) if age<=5 & age>1, by(cityd)
egen popsixty = count(sex) if age>60, by(cityd)

collapse pop popfive popsixty citypop white age fborn momcount stateicp region* year, by(cityd)
sort cityd
append using "C:\kbc\Personal\Economic History\lead\citych.dta"
save "C:\kbc\Personal\Economic History\lead\citych.dta", replace

drop _all
use "C:\kbc\Personal\Economic History\book\Misc\ipumsdata\1920census.dta" 

gen fborn = 0
replace fborn = 1 if bpld>10000

gen white = 0
replace white=1 if raced==100

egen momcount = count(sex) if sex==2 & age>=20 & age<=40, by(cityd)
egen pop = count(sex) if age<=1, by(cityd)
egen popfive = count(sex) if age<=5 & age>1, by(cityd)
egen popsixty = count(sex) if age>60, by(cityd)

collapse pop popfive popsixty citypop white age fborn momcount stateicp region* year, by(cityd)
sort cityd
append using "C:\kbc\Personal\Economic History\lead\citych.dta"
save "C:\kbc\Personal\Economic History\lead\citych.dta", replace

replace year=1900 if year==90
replace year=1910 if year==91
replace year=1920 if year==92

drop if cityd==0
replace stateicp=61 if cityd==6930
replace region=41 if cityd==6930

sort cityd year
reshape wide pop popfive popsixty citypop white read age working workingwomen ownhome fborn momcount, i(cityd) j(year)

gen pop1905 = (pop1910+pop1900)/2
gen popfive1905 = (popfive1910+popfive1900)/2
gen popsixty1905 = (popsixty1910+popsixty1900)/2
gen citypop1905 = (citypop1910+citypop1900)/2
gen white1905 = (white1910+white1900)/2
gen read1905 = (read1910+read1900)/2
gen age1905 = (age1910+age1900)/2
gen working1905 = (working1910+working1900)/2
gen ownhome1905 = (ownhome1910+ownhome1900)/2
gen fborn1905 = (fborn1910+fborn1900)/2
gen momcount1905 = (momcount1910+momcount1900)/2
gen workingwomen1905 = (workingwomen1910+workingwomen1900)/2


gen pop1915 = (pop1910+pop1920)/2
gen popfive1915 = (popfive1910+popfive1920)/2
gen popsixty1915 = (popsixty1910+popsixty1920)/2
gen citypop1915 = (citypop1910+citypop1920)/2
gen white1915 = (white1910+white1920)/2
gen read1915 = (read1910+read1920)/2
gen age1915 = (age1910+age1920)/2
gen working1915 = (working1910+working1920)/2
gen ownhome1915 = (ownhome1910+ownhome1920)/2
gen fborn1915 = (fborn1910+fborn1920)/2
gen momcount1915 = (momcount1910+momcount1920)/2
gen workingwomen1915 = (workingwomen1910+workingwomen1920)/2

save "C:\kbc\Personal\Economic History\lead\citych.dta", replace
