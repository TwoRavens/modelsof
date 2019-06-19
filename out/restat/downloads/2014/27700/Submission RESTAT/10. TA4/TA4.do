clear
cd "H:\Superstars\Submission RESTAT\"


*PART I
*******************This program generages share with *************
****comparative advantage for Balassa index using broad industries*************

clear

****Use Global to get results****
***Remove * to do for each****

****for no 1 firm assign global ssnr2****

global shares_nr shares_nr1m
global sharenr sharenr1

****for no top 2 assign global ssnr2 ****

*global shares_nr shares_nr2m
*global sharenr sharenr2

****for no top5 assign global ssnr5***

*global shares_nr shares_nr5m
*global sharenr sharenr5

***generate global shares for denominator of RCA***
use "10. TA4\input\agexportsm.dta", clear
rename reporteriso3 reporter
rename productcode isic2
rename tradevaluein1000usd value
keep if reporter=="All"
replace value=0 if value==.
collapse(mean) value, by(isic2)
g str ind=""
replace ind="Food" if isic2>=15 & isic2<=16
replace ind="Textiles" if isic2==17 
replace ind="Apparel" if isic2>=18 & isic2 <=19
replace ind="Wood" if isic2==20
replace ind="Paper" if isic2==21 | isic2==22
replace ind="Chemicals" if isic2>=23 & isic2 <=24 
replace ind="Rubber" if isic2==25
replace ind="Stone" if isic2==26
replace ind="Metal" if isic2>=27 & isic2 <=28
replace ind="Machinery" if isic2==29
replace ind="Electical" if (isic2>=30 & isic2 <=33) 
replace ind="Transport" if (isic2>=34 & isic2 <=35) 
drop if ind==""
collapse(sum) value, by(ind)

rename value world

sort ind
keep ind world
egen total=sum(world)
gen ishare=world/total
keep ind ishare
sort ind
save "10. TA4\input\worldm.dta", replace


***merge with comtrade for regressions to create RCA****
use "10. TA4\input\ourexportsm.dta", clear
rename reporteriso3 reporter
rename productcode isic2
rename tradevaluein1000usd value
replace value=0 if value==.
collapse(mean) value, by(reporter isic2)



***merge with superstar shares***
merge reporter isic2 using "10. TA4\input\\$shares_nr.dta"
*keep if _merge==3

replace $sharenr=0 if $sharenr==.
gen value_no=value*(1-$sharenr)
drop if value==.

g str ind=""
replace ind="Food" if isic2>=15 & isic2<=16
replace ind="Textiles" if isic2==17 
replace ind="Apparel" if isic2>=18 & isic2 <=19
replace ind="Wood" if isic2==20
replace ind="Paper" if isic2==21 | isic2==22
replace ind="Chemicals" if isic2>=23 & isic2 <=24 
replace ind="Rubber" if isic2==25
replace ind="Stone" if isic2==26
replace ind="Metal" if isic2>=27 & isic2 <=28
replace ind="Machinery" if isic2==29
replace ind="Electical" if (isic2>=30 & isic2 <=33) 
replace ind="Transport" if (isic2>=34 & isic2 <=35) 
drop if ind==""

collapse(sum) value value_no , by(reporter ind)
sort ind
merge ind using "10. TA4\input\worldm.dta"
gen hs2=ind
egen xcountry=sum(value), by(reporter)
egen xnocountry=sum(value_no), by(reporter)
gen bal_all=(value/xcountry)/ishare
***liberal****
gen bal_no=(value_no/(xcountry-value+value_no))/ishare
***conservative***
*gen bal_no=(value_no/xnocountry)/ishare
gen our33=0

**This loop keeps our countries***
local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	foreach x of local our_ctys {
	replace our33=1 if reporter=="`x'"
		}
keep reporter value xcountry hs2 bal_all bal_no our33
duplicates drop
drop if bal_all==0
keep if our33==1

***For SS****
*****strict*****

ren bal_no bal_noSS
gen loseca=0
gen ca=0
replace loseca=1 if (bal_all>1 & bal_noSS<1)  
replace ca=1 if bal_all>1

preserve
***gives test of difference in the means between average RCA before and after removal of superstars****
keep reporter hs2 ca bal_all
reshape wide bal_all, i(reporter hs2) j(ca)
ttest bal_all0=bal_all1, unpaired

restore

egen losecatot=sum(loseca)
egen tot=sum(ca)
gen ssshareCA=losecatot/tot
gen trshare=loseca*value
egen SStr=sum(trshare)
gen CAtrade=ca*value
egen CAtot=sum(CAtrade)
gen sstrade=SStr/CAtot
egen totaltr=sum(value)
gen CAsharetot=CAtot/totaltr
gen SSsharetot=SStr/totaltr
ren tot totstr
****Gives RCA in losing and not losing industries***
preserve
***gives average RCA by loseca ****
keep if ca==1
keep reporter hs2 ca loseca bal_all bal_noSS
reshape wide bal_all bal_noSS, i(reporter hs2) j(loseca)
ttest bal_all1=bal_noSS1, unpaired
restore
drop losecatot trshare SStr 

save "10. TA4\input\dataforbalassa.dta", replace

*****generates table of lose RCA by industry*****************


egen losecatot=sum(loseca), by(hs2)
egen tot=sum(ca), by(hs2)
gen ssshareCA_HS2=losecatot/tot
ren tot totstri
drop loseca ca losecatot 
***make table***
keep hs2 ssshareCA_HS2 totstri 
duplicates drop
rename hs2 ind
save "10. TA4\input\TA4a.dta", replace

*PART II
clear
clear matrix
clear mata
set memory 1000m
set maxvar 10000
clear

use "10. TA4\input\dataforregressions_m.dta", clear

char reporter[omit] "USA"
char ind[omit] "Apparel"
char partner[omit] "USA"
xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*distw i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
outreg2 using "10. TA4\input\SSCDK_Allm.txt", noas label(insert) ctitle("ALL")replace


***Create values without superstars*****

gen lnvalue2=lnvalue

local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	
	foreach x of local our_ctys {
	replace lnvalue=lnvalue_no1 if reporter=="`x'"
	char reporter[omit] "USA"
	char ind[omit] "Apparel"
	char partner[omit] "USA"
	xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*distw i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
	outreg2 using "10. TA4\input\SSCDK_Allm.txt", noas label(insert) ctitle("`x'")append
	replace lnvalue=lnvalue2 if reporter=="`x'"
	}
	
	
********Do for no 2**********
use "10. TA4\input\dataforregressions_2m.dta", clear


char reporter[omit] "USA"
char ind[omit] "Apparel"
char partner[omit] "USA"
xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*distw i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
outreg2 using "10. TA4\input\SSCDK_All2m.txt", noas label(insert) ctitle("ALL")replace


***Create values without superstars*****

gen lnvalue2=lnvalue

local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	
	foreach x of local our_ctys {
	replace lnvalue=lnvalue_no2 if reporter=="`x'"
	char reporter[omit] "USA"
	char ind[omit] "Apparel"
	char partner[omit] "USA"
	xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*distw i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
	outreg2 using "10. TA4\input\SSCDK_All2m.txt", noas label(insert) ctitle("`x'")append
	replace lnvalue=lnvalue2 if reporter=="`x'"
	}
	
	********Do for no 5**********

use "10. TA4\input\dataforregressions_5m.dta", clear

char reporter[omit] "USA"
char ind[omit] "Apparel"
char partner[omit] "USA"
xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*distw i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
outreg2 using "10. TA4\input\SSCDK_All5m.txt", noas label(insert) ctitle("ALL")replace


***Create values without superstars*****

gen lnvalue2=lnvalue

local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	
	foreach x of local our_ctys {
	replace lnvalue=lnvalue_no5 if reporter=="`x'"
	char reporter[omit] "USA"
	char ind[omit] "Apparel"
	char partner[omit] "USA"
	xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*distw i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
	outreg2 using "10. TA4\input\SSCDK_All5m.txt", noas label(insert) ctitle("`x'")append
	replace lnvalue=lnvalue2 if reporter=="`x'"
	}
	

* PART III
***This file creates CDK entries for Table A4*****
***the first insheet is coefficients when the top firm is excluded, ****
*****the second is when top 2 are excluded, and third is when top 5 are excluded ***
*****to get the first CDK column run the file using the first insheet command***
*****to get the second CDK column run the file using the second insheet command***
*****to get the third CDK column run the file using the third insheet command***

insheet using "10. TA4\input\SSCDKman_no1.csv", clear
gen type=substr(variables, 1, 9)
keep if type=="_IrepXind"
gen country=substr(labels, 11, 3)
gen ind=substr(labels,22,.)
drop variables labels type 
gen all2=exp(all)
drop all
ren all2 all
egen mdelta=mean(all)
egen mdeltaind=mean(all), by(ind)
egen mdeltac=mean(all), by(country)
gen rmp=all/mdeltac
egen mrmpc=mean(rmp), by(ind)
gen rmpca=mdeltaind/mdelta
egen countall=count(all), by(country)
ren alb ALB
	ren bfa BFA
	ren bgd BGD
	ren bgr BGR
	ren bwa BWA
	ren chl CHL
	ren cmr CMR
	ren col COL
	ren cri CRI
	ren dom DOM
	ren ecu ECU
	ren egy EGY
	ren gtm GTM
	ren irn IRN
	ren jor JOR
	ren ken KEN
	ren khm KHM
	ren lbn LBN
	ren mar MAR
	ren mex MEX
	ren mkd MKD
	ren mus MUS
	ren mwi MWI
	ren ner NER
	ren nic NIC
	ren pak PAK
	ren per PER
	ren sen SEN
	ren tza TZA
	ren uga UGA
	ren yem YEM
	ren zaf ZAF
gen our33=0
gen no_1=.
local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	foreach x of local our_ctys {
	replace our33=1 if country=="`x'"
		replace no_1=exp(`x') if country=="`x'"
	}
	keep country ind all no_1 our33 mrmpc rmpca rmp mdeltac countall
	keep if our33==1
	egen mdeltacty=mean(no_1), by(country)
	***conservative***
	*gen rat1=no_1/mdeltacty
	***liberal***
	*gen rat1=no_1/mdeltac
	
	***in between***
	gen rat1=no_1/((mdeltac*countall-all+no_1)/countall)
	gen RMP1=rmp/mrmpc
	gen RMP_noSS=rat1/mrmpc
	
	save "10. TA4\input\TA4b.dta", replace
	***stop here and pick next***
	***to run t-test skip to bottom***
	***to create table do next part***
	
***Create table by ind***

	
	keep if RMP1>1
	gen switch=0
	replace switch=1 if RMP_noSS<1

	keep country ind RMP1 RMP_noSS switch
	egen ca=count(RMP1), by(ind)
	egen tchange=sum(switch), by(ind)
	keep ind ca tchange
	duplicates drop
	replace ind="Stone" if ind=="Glass"
	sort ind
	egen sumswitch=sum(tchange)
	gen share1=tchange/ca
		keep ind ca share1
	merge 1:1 ind using "10. TA4\input\TA4a.dta"
	drop _
	order ind tot sss
	sort ind
	save "10. TA4\TA4.dta", replace
	
***gives average RCA by RCA or no RCA ****
use "10. TA4\input\TA4b.dta", clear
keep country ind RMP1
	gen RMP0=0
	replace RMP0=1 if RMP1>1
reshape wide RMP1, i(country ind) j(RMP0)
ttest RMP10=RMP11, unpaired

use "10. TA4\input\TA4b.dta", clear
****
	gen switch=0
	keep if RMP1>1
	replace switch=1 if RMP_noSS<1 
	keep if switch==1
	keep RMP_noSS RMP1
ttest RMP_noSS=RMP1, unpaired


	
	