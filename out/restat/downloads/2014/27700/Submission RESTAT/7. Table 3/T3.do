clear
cd "H:\Superstars\Submission RESTAT\"

*************************** PART I **********************************
*******************This program generages the share with *************
****comparative advantage for Balassa index using 15 industries*************
****and the share that lose comparative advantage when superstars are removed***
****columns one through 4 of table 3, it also generates the tests at the bottom of table 3****
*****results for the t-test will appear on the screen*****



****Use Global to get results****
***Remove * to do for each****

****for no 1 firm assign global ssnr2****

*global shares_nr shares_nr1
*global sharenr sharenr1

****for no top 2 assign global ssnr2 ****

*global shares_nr shares_nr2
*global sharenr sharenr2

****for no top5 assign global ssnr5***

global shares_nr shares_nr5
global sharenr sharenr5

***generate global shares for denominator of RCA***

insheet using "7. Table 3\input\agexports.csv", clear
rename reporteriso3 reporter
rename productcode hs2
rename tradevaluein1000usd value
keep if reporter=="All"
replace value=0 if value==.
collapse(mean) value, by(hs2)
**drop oil and unclassified goods***
drop if hs2==27 
drop if hs2>97
rename value world

sort hs2
keep hs2 world
***create industries***
g str industry=""
replace ind="Food" if hs2>=1 & hs2<=24
replace ind="Mineral" if hs2>=25 & hs2 <=27
replace ind="Chemicals" if hs2>=28 & hs2 <=38
replace ind="Plast Rub" if hs2>=39 & hs2 <=40
replace ind="Wood" if (hs2>=44 & hs2 <=46) 
replace ind="Paper" if (hs2>=47 & hs2 <=49) 
replace ind="Textiles" if (hs2>=50 & hs2 <=59) 
replace ind="Apparel" if (hs>=41 & hs2<=43)|(hs2>=60 & hs2 <=67)
replace ind="Glass" if hs2>=68 & hs2 <=70
replace ind="Prec. Met" if hs2==71
replace ind="Metals" if hs2>=72 & hs2 <=83
replace ind="Mach" if hs2==84 
replace ind="Elecmach" if  hs2==85
replace ind="Transport" if hs2>=86 & hs2 <=89
replace ind="Misc" if ind==""

collapse(sum) world, by(ind)

egen total=sum(world)
gen ishare=world/total
keep ind ishare
sort ind
save "7. Table 3\world.dta", replace


***merge with comtrade for regressions to create RCA****

insheet using "7. Table 3\input\agexports.csv", clear
rename reporteriso3 reporter
rename productcode hs2
rename tradevaluein1000usd value
replace value=0 if value==.
collapse(mean) value, by(reporter hs2)
drop if hs2==27 
drop if hs2>97
sort reporter hs2

***merge with superstar shares***
merge reporter hs2 using "7. Table 3\input\\$shares_nr.dta"
*keep if _merge==3

replace $sharenr=0 if $sharenr==.
gen value_no=value*(1-$sharenr)
drop if value==.
sort hs2

g str industry=""
replace ind="Food" if hs2>=1 & hs2<=24
replace ind="Mineral" if hs2>=25 & hs2 <=27
replace ind="Chemicals" if hs2>=28 & hs2 <=38
replace ind="Plast Rub" if hs2>=39 & hs2 <=40
replace ind="Wood" if (hs2>=44 & hs2 <=46) 
replace ind="Paper" if (hs2>=47 & hs2 <=49) 
replace ind="Textiles" if (hs2>=50 & hs2 <=59) 
replace ind="Apparel" if (hs>=41 & hs2<=43)|(hs2>=60 & hs2 <=67)
replace ind="Glass" if hs2>=68 & hs2 <=70
replace ind="Prec. Met" if hs2==71
replace ind="Metals" if hs2>=72 & hs2 <=83
replace ind="Mach" if hs2==84 
replace ind="Elecmach" if  hs2==85
replace ind="Transport" if hs2>=86 & hs2 <=89
replace ind="Misc" if ind==""

collapse(sum) value value_no , by(reporter ind)
sort ind
merge ind using "7. Table 3\world.dta"
gen hs2=ind
egen xcountry=sum(value), by(reporter)
egen xnocountry=sum(value_no), by(reporter)

**bal_all is the balassa index for all trade***
gen bal_all=(value/xcountry)/ishare

***bal_no is the balassa index excluding the top firm(s)****
gen bal_no=(value_no/(xcountry-value+value_no))/ishare

***alternative methodology as described in footnote 11***
*gen bal_no=(value_no/xnocountry)/ishare

gen our33=0

**This loop keeps our countries***
local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	foreach x of local our_ctys {
	replace our33=1 if reporter=="`x'"
		}
keep reporter value xcountry hs2 bal_all bal_no our33
duplicates drop
keep if our33==1

***This next part counts which sectors lose RCA****

ren bal_no bal_noSS
gen loseca=0
gen ca=0
***loseca is indicator for a sector that loses RCA if superstars are removed***
replace loseca=1 if (bal_all>1 & bal_noSS<1)

***ca is indicator for having RCA if all trade is included***  
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

****Gives t-test of difference in means of balassa with and without superstars****
reshape wide bal_all bal_noSS, i(reporter hs2) j(loseca)
ttest bal_all1=bal_noSS1, unpaired
restore
drop losecatot trshare SStr 

save "7. Table 3\dataforbalassa.dta", replace

*****generates table of lose RCA by industry*****************


egen losecatot=sum(loseca), by(hs2)
egen tot=sum(ca), by(hs2)
gen ssshareCA_HS2=losecatot/tot
ren tot totstri
drop loseca ca losecatot 
***make table***
keep hs2 totstri ssshareCA_HS2
duplicates drop
rename hs2 ind
sort ind
save "7. Table 3\T3P1.dta", replace

	
erase "7. Table 3\dataforbalassa.dta"
erase "7. Table 3\world.dta"



********************************** PART II ****************************************
***This file runs the CDK fixed effect regressions to generate the industry-exporter coefficients used for Table 3*****
***The coefficients from these files match the coefficients in the files, H:\Superstars\SSCDK_Allonly.csv, H:\Superstars\SSCDK_All.csv
***H:\Superstars\SSCDK_All2f.csv, H:\Superstars\SSCDK_All5f.csv


clear
clear matrix
clear mata
set maxvar 10000
clear

use "7. Table 3\input\dataforregressions.dta", clear
gen lndis=ln(distw)

char reporter[omit] "USA"
char ind[omit] "Animal"
char partner[omit] "USA"
xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*lndis i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
outreg2 using "7. Table 3\SSCDK_All10-8.txt", noas label(insert) ctitle("ALL")replace


***Create values without superstars*****

gen lnvalue2=lnvalue

local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	
	foreach x of local our_ctys {
	replace lnvalue=lnvalue_no1 if reporter=="`x'"
	xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*lndis i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
	outreg2 using "7. Table 3\SSCDK_All10-8.txt", noas label(insert) ctitle("`x'")append
	replace lnvalue=lnvalue2 if reporter=="`x'"
	}
	
	
********Do for no 2**********

use "7. Table 3\input\dataforregressions_2m.dta", clear

gen lndis=ln(distw)
char reporter[omit] "USA"
char ind[omit] "Animal"
char partner[omit] "USA"
xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*lndis i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
outreg2 using "7. Table 3\SSCDK_All2r.txt", noas label(insert) ctitle("ALL")replace


***Create values without superstars*****

gen lnvalue2=lnvalue

local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	
	foreach x of local our_ctys {
	replace lnvalue=lnvalue_no2 if reporter=="`x'"
	xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*lndis i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
	outreg2 using "7. Table 3\SSCDK_All2r.txt", noas label(insert) ctitle("`x'")append
	replace lnvalue=lnvalue2 if reporter=="`x'"
	}
	
	********Do for no 5**********

use "7. Table 3\input\dataforregressions_5m.dta", clear


char reporter[omit] "USA"
char ind[omit] "Animal"
char partner[omit] "USA"
xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*distw i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
outreg2 using "7. Table 3\SSCDK_All5.txt", noas label(insert) ctitle("ALL")replace


***Create values without superstars*****

gen lnvalue2=lnvalue

local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	
	foreach x of local our_ctys {
	replace lnvalue=lnvalue_no5 if reporter=="`x'"
	xi: areg lnvalue i.reporter*i.ind i.partner*i.ind i.ind*distw i.ind*rta i.ind*contig i.ind*comlang_off, robust absorb(reppar)
	outreg2 using "7. Table 3\SSCDK_All5.txt", noas label(insert) ctitle("`x'")append
	replace lnvalue=lnvalue2 if reporter=="`x'"
	}


	

********************************** PART III *********************************
************************Table 3 CDK***********************
***this file produces the share of industries that lose CDK_RCA when superstars are removed**********
***first part does for no top firm, then for no 2 firms, then no 5, then merges files************


***file is CDK coefficients using all data generated from the file CDK regressions****
***before running file sort the output file by VARIABLES and delete all missing values in excel, save as csv file***********
insheet using "7. Table 3\input\SSCDK_All1f.csv", clear
gen type=substr(variables, 1, 9)
keep if type=="_IrepXind"
gen country=substr(labels, 11, 3)
gen ind=substr(labels,27,.)
drop variables labels type 
gen all2=exp(all)
drop all
ren all2 all
egen mdelta=mean(all)
egen mdeltaind=mean(all), by(ind)
egen mdeltac=mean(all), by(country)
***rmp is the numerator for CDK_RCA for each country****
gen rmp=all/mdeltac
egen mrmpc=mean(rmp), by(ind)
gen rmpca=mdeltaind/mdelta
egen countall=count(all), by(country)
**this command makes the variable names, which show coefficients for each country without top firm, the same as the reporter names***
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
***the top part of the file calculated RCA using all countries, now we use only our countries, to calculate RCA without the top firm**

local our_ctys "ALB BFA BGD BGR BWA CHL CMR COL CRI DOM ECU EGY GTM IRN JOR KEN KHM LBN MAR MEX MKD MUS MWI NER NIC PAK PER SEN TZA UGA YEM ZAF"
	foreach x of local our_ctys {
	replace our33=1 if country=="`x'"
		replace no_1=exp(`x') if country=="`x'"
	}
	keep country ind all no_1 our33 mrmpc rmp mdeltac countall
	keep if our33==1
	egen mdeltacty=mean(no_1), by(country)
	
	***rat1 is the numerator of RCA_CADK for the no top firm case****
	****the numerator of the ratio is the exp of the coefficie
	****the denominator is the average industry effect, replacing the particular industry in question with the coefficient from the numerator***
	****this makes very little difference (as compared to simple average) when only one firm is out, but is important for 2 or 5 firms out, see footnote 11*****
	
	gen rat1=no_1/((mdeltac*countall-all+no_1)/countall)
	
		
	**********RMP1 is RCA_CDK for all data, RMP_no1 is the same exluding the top firm******
	gen RMP1=rmp/mrmpc
	gen RMP_no1=rat1/mrmpc

	
***gives test of difference in the means between average RCA_CDK wit CA and without CA****
***results appear in screen****
preserve
keep country ind RMP1
gen ca=0
replace ca=1 if RMP1>1
reshape wide RMP1, i(country ind) j(ca)
ttest RMP11=RMP10, unpaired

restore
	***Run this to get switches by industry***
	keep if RMP1>1
	gen switch=0
	replace switch=1 if RMP_no1<1 
	keep country ind RMP1 RMP_no1 switch
	egen ca=count(RMP1) , by(ind)
	egen tchange=sum(switch), by(ind)
	
**gives test of difference in the means between reversal group of RCA_CDK without superstars****
***results appear in screen****
preserve
keep country ind RMP1 RMP_no1 switch
keep if switch==1
reshape wide RMP1 RMP_no1, i(country ind) j(switch)
ttest RMP1 = RMP_no1, unpaired
restore

	
	keep ind ca tchange 
	duplicates drop
	replace ind="Stone" if ind=="Glass"
	sort ind ca
	gen sharelose1=tchange/ca
	keep ind ca sharelose1
	save "7. Table 3\cdk_rca1", replace
	
	****next we do the same for no top 2 and no top5 and then merge files****
insheet using "7. Table 3\input\SSCDK_All2f.csv", clear
	


gen type=substr(variables, 1, 9)
keep if type=="_IrepXind"
gen country=substr(labels, 11, 3)
gen ind=substr(labels,27,.)
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
	keep country ind all no_1 our33 mrmpc rmp mdeltac countall
	keep if our33==1
	egen mdeltacty=mean(no_1), by(country)
	gen rat1=no_1/((mdeltac*countall-all+no_1)/countall)
	
	gen RMP1=rmp/mrmpc
	gen RMP_no1=rat1/mrmpc
	
	
	
***Create table by ind***

	
	keep if RMP1>1
	gen switch=0
	replace switch=1 if RMP_no1<1
	keep country ind RMP1 RMP_no1 switch
	egen ca=count(RMP1), by(ind)
	egen tchange=sum(switch), by(ind)
	
	**gives test of difference in the means between reversal group of RCA_CDK without superstars****
***results appear in screen****
preserve
keep country ind RMP1 RMP_no1 switch
keep if switch==1
reshape wide RMP1 RMP_no1, i(country ind) j(switch)
ttest RMP1 = RMP_no1, unpaired
restore

	keep ind ca tchange
	duplicates drop
	replace ind="Stone" if ind=="Glass"
	sort ind ca
	egen sumswitch=sum(tchange)
	gen sharelose2=tchange/ca
	keep ind ca sharelose2
	save "7. Table 3\cdk_rca2", replace

	***************Now we repeat for not top 5*****

insheet using "7. Table 3\input\SSCDK_All5f.csv", comma clear


gen type=substr(variables, 1, 9)
keep if type=="_IrepXind"
gen country=substr(labels, 11, 3)
gen ind=substr(labels,27,.)
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
	gen rat1=no_1/((mdeltac*countall-all+no_1)/countall)
	gen RMP1=rmp/mrmpc
	gen RMP_no1=rat1/mrmpc
	
	
	
***Create table by ind***

	
	keep if RMP1>1
	gen switch=0
	replace switch=1 if RMP_no1<1
	keep country ind RMP1 RMP_no1 switch
	egen ca=count(RMP1), by(ind)
	egen tchange=sum(switch), by(ind)
	
	**gives test of difference in the means between reversal group of RCA_CDK without superstars****
***results appear in screen****
preserve
keep country ind RMP1 RMP_no1 switch
keep if switch==1
reshape wide RMP1 RMP_no1, i(country ind) j(switch)
ttest RMP1 = RMP_no1, unpaired
restore

	keep ind ca tchange
	duplicates drop
	sort ind
	egen sumswitch=sum(tchange)
	gen sharelose5=tchange/ca
	keep ind ca sharelose5
	sort ind ca
	merge ind ca using "7. Table 3\cdk_rca1"
	drop _m
	sort ind ca
	merge ind ca using "7. Table 3\cdk_rca2"
	drop _m
	order ind ca sharelose1 sharelose2 sharelose5
	merge 1:1 ind using "7. Table 3\T3P1.dta"
	drop _
	sort ind
	replace ind="Stone and Glass" if ind=="Glass"
	order ind totstri sss
	save "7. Table 3\T3.dta", replace
	
erase "7. Table 3\cdk_rca1.dta"
erase "7. Table 3\cdk_rca2.dta"
erase "7. Table 3\T3P1.dta"
