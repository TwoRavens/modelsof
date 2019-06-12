clear
set more off

cap log close
log using read_add.log,replace

/* traffic scores data*/
clear

insheet using ../TRAFFIC_20160122.csv
desc
rename m15_score m15_traffic
rename m30_score m30_traffic
rename m50_score m50_traffic
rename m75_score m75_traffic
rename m100_score m100_traffic

egen std_traffic50=std(m50_traffic)
egen std_traffic15=std(m15_traffic)
egen std_traffic30=std(m30_traffic)

gen certdate=date(certificate_date, "MDY")
format certdate %d


gen certificate=1 if certdate~=.
replace certificate=0 if certdate==.

rename addressid firstaddress
sort firstaddress certdate
by firstaddress: gen certnum=_n

preserve
keep if certificate==0
save nocert.dta,replace
restore
keep if certificate==1

drop certificate_date
drop if certdate<0

sort firstaddress certdate
by firstaddress: keep if _n==1
sort firstaddress

append using nocert.dta
count

label var certdate "Date of First Certificate"

label var firstaddress "Address of first lead test"

drop certnum certificate_date
sort firstaddress
rename firstaddress address_id
sort address_id
save traffic_add.dta,replace
desc



/* LEAD*/
clear
import delimited LESS_20151221.csv
desc


drop if no_link==1
drop no_link

/* drop duplicates*/

sort pid address_id draw_date test_result
quietly by pid address_id draw_date test_result: gen dup=cond(_N==1,0,_n)
 
tab dup
drop if dup>1

 
gen lead_date=date(draw_date, "YMD")
format lead_date %d
gen lead_year=year(lead_date)
list lead_date draw_date in 1/10
drop draw_date


gen approxdob=(lead_date)-30.5*age_at_test
format approxdob %d

rename pid pid_num
gen pid=string(pid_num)

drop if pid==""
drop if test_result==.

sort pid age_at test_method
by pid age_at: gen n=_n
by pid age_at: gen N=n[_N]
gen keep=1 if N==1
* keep all with one test per month

replace keep=1 if test_method=="V" & N>1
* keep all those with a venous sample

gen venous=test_method=="V"
gen capillary=test_method=="C"

by pid age_at: egen sumv=sum(venous)
by pid age_at: gen hasv=1 if sumv>=1 & sumv~=. 

by pid age_at: replace keep=0 if test_meth=="C" & hasv==1
* drop capillary if have a venous sample in same month

gen vtest_result=test_result
replace vtest_result=. if venous==0
label var vtest_result "Venous test result"


gen ctest_result=test_result
replace ctest_result=. if capillary==0
label var ctest_result "Capillary test result"


sort pid age_at test_result
by pid age_at: replace keep=1 if sumv==0 & _n==1
by pid age_at: replace keep=0 if sumv==0 & _n~=1
*if only capillary test results, keep lowest one

tab keep
drop if keep==0


by pid age_at: egen haskeep=sum(keep)

tab haskeep
bysort pid age_at: egen maxvtest=max(test_result) if sumv>1 & sumv~=.
bysort pid age_at: egen avgvtest=mean(test_result) if sumv>1 & sumv~=. 
*if more than one venous sample in same month, measure the max and the average

gen maxlead=test_result
replace maxlead=maxvtest if maxvtest~=. 

gen avglead=test_result
replace avglead=avgvtest if avgvtest~=. 

bysort pid age_at: keep if _n==1
summ avglead maxlead

gen num=1
gen over5= maxlead>=5 if maxlead!=. 
gen over10=maxlead>=10 & maxlead~=. 

gen over5b=avglead>=5 & avglead~=. 
gen over10b=avglead>=10 & avglead~=. 

table lead_year, c (mean avglead mean maxlead mean over5 mean over10 count num)
table lead_year, c (mean over5b mean over10b)


sort pid lead_date
by pid:replace approxdob=approxdob[1]

gen birth_year=year(approxdob)

gen fips=substr(geo,-8,1)
tab fips


keep pid address_id age_at_test fips test_method sumv test_result vtest_result ctest_result maxlead lead_year geo approxdob lead_date

/* geometric mean*/

gen avglead_forg=test_result+1
replace avglead_forg=1 if avglead_forg==. 

*egen lead_geom=gmean(avglead_forg), by(pid)

gen lead_geom=. 



/* means*/

sort pid age_at_test

by pid: gen firsttract=geo[1]
by pid: gen firstaddress=address_id[1]
by pid: gen firstfips=fips[1]
by pid: gen firstdatetest=lead_date[1]

drop fips avglead_forg lead_year


/* merge the traffic data on for each test*/

sort address_id
merge address_id using traffic_add.dta
tab _merge

drop if _merge==2
drop _merge

sort pid age_at_test
by pid age_at_test: keep if _n==1

/* fix this*/

cap drop test_method std* brownfield highway maxlead sumv
reshape wide test_result vtest_result ctest_result geo lead_date lead_geom* address_id  m15* m30* m50* m75* m100* certificate certdate, i(pid) j(age_at_test)



egen leadlevel=rowmean(test_result*)
egen leadvenous=rowmean(vtest_result*)
egen leadcapil=rowmean(ctest_result*)
summ leadlevel leadvenous leadcapil
label var leadlevel "Average Lead Level"
label var leadvenous "Average of all venous tests"
label var leadcapil "Average of all capillary tests"
label var firstdatetest "Date of first lead test"
 


format firstdatetest %d
gen lead_year=year(firstdatetest)

egen avg15_tr=rowmean(m15_traffic*)
egen avg30_tr=rowmean(m30_traffic*)
egen avg50_tr=rowmean(m50_traffic*)
egen avg75_tr=rowmean(m75_traffic*)
egen avg100_tr=rowmean(m100_traffic*)

egen avg15=rowmean(m15_road*)
egen avg30=rowmean(m30_road*)
egen avg50=rowmean(m50_road*)
egen avg75=rowmean(m75_road*)
egen avg100=rowmean(m100_road*)


gen less=1
sort pid
save less_add.dta,replace
