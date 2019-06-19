/*********************************
This do file uses data on patent citations to construct citations flows to proxy for knowledge spillovers
Patents data were purchased by the LSE Department of Geography and Environment for projects related to knowledge diffusion
The data cannot be shared but can be obtained from CESPRI at Bocconi University
This do file maps technology classes onto industrial sectors using a probabilistic mapping based on the sector/industry of manufacture (hence SOM in the do file name)
The mapping between technology and sectors of manufacture was originally created by Silverman and can be accessed via the internet
More information is contained in the Web Appendix of this manuscript
An alternative mapping using industry of use can be used. This was also worked out by Silverman and can be access through his website
**********************************/

clear all
set mem 2g
set maxvar 30000
set matsize 10000
set more off


global home "Y:\53523_Sorting"
global working "$home\Working"
global output "$working\Data\Coaggl"
global pata_data "$output\Patent_data\EP--CESPRI--UKITALY\raw_uki"
global syntax "Y:\53523_Sorting\Syntax\Coaggl\patent_data"
global work_data "Y:\53523_Sorting\Working\Data\Coaggl\Patent_data"
global temp "$working\Coaggl"

*********************************************************************
*Constructing a usable data of UK patents 
use "$pata_data\ipcmain.dta", clear
codebook punr
sort punr
by punr: gen n=_n
keep if n==1
count
keep punr 
sort punr

merge 1:m punr using "$pata_data\punr_codinv2.dta"
codebook  punr if _merge==3
codebook  codinv2 if _merge==3
drop if _merge==2
sort  codinv2
drop _merge

merge m:1 codinv2 using "$pata_data\codinv2_cy.dta"
drop if _merge==2
codebook punr
codebook punr if codinv2!=.
drop _merge
sort punr
save "$pata_data\part1.dta", replace

***********************
*This is a set of patents associated to their multiple inventors
***********************

***********************
*The code below gets additional information about applicants' nationality for 571 patents that do not have an inventor information
***********************

use "$pata_data\punr_codfirm.dta", clear
sort codfirm
merge m:1 codfirm using "$pata_data\applicants_anonymous.dta"

codebook codfirm if _merge==3
keep if _merge==3
keep  punr codfirm ctry_code
sort punr  codfirm

by punr: egen count=count(punr)
tab count

by punr: gen d=1 if ctry_code!=ctry_code[_n-1] & _n!=1
tab d
by punr: egen max=max(d)
tab max
*Only in 190 cases patents have been filed by more than one applicants and these applicants have different nationalities. These are dropped

drop if max!=.
sort punr
by punr: gen n=_n
keep if n==1
save "$pata_data\part2.dta", replace

********************
*Merge this dataset with the data with information on nationality of inventors
********************

use "$pata_data\part1.dta", clear
sort punr
merge m:1 punr using "$pata_data\part2.dta"
drop if _merge==2
drop _merge d count max n

codebook punr
codebook punr if  codinv2!=.
codebook punr if  codinv2==. &  codfirm!=.
tab  ctry_code if  codinv2==. &  codfirm!=.

*For the 571 patents that do not have inventor information, we have applicants information; 546 are in the UK

*Determine GB patents
sort punr
gen gb=1 if incy=="GB"
sort punr
by punr: egen max=max(gb)
gen gb2=max

gen gb3=gb2
replace gb3=1 if gb2==. & ctry_code=="GB" & incy==""
*This recodes patents with no inventors to GB if the applicant is in GB

*This alternative recodes to GB all patents that either do not have an inventor, or have a non-UK inventor but UK appliacnt
*The gain from previous classification is 11,000 patents or 8%
gen gb4=gb2
replace gb4=1 if gb2==. & ctry_code=="GB" 

keep if gb4==1
drop gb gb2 max 

*Less than 1% of the patents with different gb3 and gb4 has inventors of different nationality
sort punr
by punr: gen d=1 if incy!= incy[_n-1] & _n!=1 & gb3!=gb4
by punr: egen max=max(d)

drop d max
sort punr
by punr: gen n=_n
keep if n==1
keep  punr incy ctry_code gb3 gb4 codfirm

sort punr
save "$syntax\punr_id_gbpatents.dta", replace

********************
*Merge with patent classifications and with patent year of application

use "$pata_data\ipcmain.dta", clear

sort punr
by punr: egen count=count(punr)
tab count
*Very few patents repeated twice (less than 200 obs), we drop them
drop if count==2

sort punr
merge m:1 punr using "$syntax\punr_id_gbpatents.dta"

keep if _merge==3
drop _merge
*Note that patents correspond to several IPC; classified in more than one technological sector

sort punr
merge m:1 punr using "$pata_data\patanag_anonymous.dta"

drop if _merge==2
drop _merge
gen year=year(apdt)
tab year

gen year2=year(aidt)
tab year2
count if year2!=year & year2!=. 
tab year year2 if year2!=year & year2!=.
*This is the year in which the patent was filed at the world intellectual property organization
*If there are both aidt and apdt, in principle the date of filing at the WPIO is the priority. In practice it makes little difference
gen year_prty=year
replace year_prty=year2 if year2!=year & year2!=.

tab akind
drop if akind!="A"
save "$syntax\punr_characteristics_gbpatents.dta", replace

***************************************
***************************************
*Start manipulating patcitations data
***************************************
***************************************

****************************************
****************************************
*Merging directly into Euro Patents-only citations
****************************************
****************************************

use "$pata_data\patcitations_ep.dta", clear
rename ee_citing punr
sort punr
merge m:1 punr using "$syntax\punr_id_main.dta"
drop if _merge==2
rename _merge merge_ep_punr_citing

rename punr punr_ep_citing
rename ee_cited punr
sort punr
merge m:1 punr using "$syntax\punr_id_main.dta"
drop if _merge==2
rename _merge merge_ep_punr_cited

tab  merge_ep_punr_citing merge_ep_punr_cited
codebook  punr_ep_citing punr if  merge_ep_punr_citing==3 &  merge_ep_punr_cited==3
*137,000 citations merge, with 77000 citing patents and 63000 cited patents

keep if merge_ep_punr_citing==3 &  merge_ep_punr_cited==3
codebook punr 
count 

sort punr
merge m:1 punr using "$syntax\punr_characteristics_gbpatents.dta"
drop  clmn_old ipcv nclap30 ost30 ost7 count incy ctry_code akind apdt aidt iapnr status claims

local z "punr clmn nace gb3 gb4 year year2 year_prty  _merge codfirm"
foreach i of local z {
rename `i' `i'_cited
}

rename punr_ep_citing punr
sort punr
merge m:1 punr using "$syntax\punr_characteristics_gbpatents.dta"
drop  clmn_old ipcv nclap30 ost30 ost7 count incy ctry_code akind apdt aidt iapnr status claims

local z "punr clmn nace gb3 gb4 year year2 year_prty  _merge codfirm"
foreach i of local z {
rename `i' `i'_citing
}

drop progr merge_ep_punr_citing merge_ep_punr_cited
order punr_citing punr_cited *_citing *_cited _merge_citing _merge_cited 

keep if _merge_citing==3 & _merge_cited==3
count
count if  gb3_citing==1 &  gb3_cited==1

*Some restrictions
keep if  gb3_citing==1 &  gb3_cited==1
*only English inventors and English applicants when inventor is not known

*Main file uses 1987 to 2000 but in some robustness we experiment with only 
*excluding first three years of citing patents and any patent citing after 2008
*Uses priority year; if use simple year we have very few obs that differ 
drop if year_prty_citing>2000 | year_prty_citing<1987

*Experimented with different cut offs. Either 1997 or 2005 (for extended sample)
*In general exclude cited patents if they cannot be at least three years youngers, i.e. keep only before 2005
drop if year_prty_cited>1997

drop if nace_cited=="" | nace_citing==""

save "$syntax\patcit_epo_uk.dta", replace

gen ipc_citing= substr(clmn_citing,1,4)
gen ipc_cited= substr(clmn_cited,1,4)

*NOTE: drops self-citations here
drop if codfirm_citing==codfirm_cited

sort ipc_citing
by ipc_citing: egen count_citing=count(punr_citing)
sort ipc_cited
by ipc_cited: egen count_cited=count(punr_citing)
sort ipc_citing ipc_cited
by ipc_citing ipc_cited: egen count_citing_cited=count(punr_citing)
collapse (mean)  count_citing count_cited count_citing_cited , by(ipc_citing ipc_cited)

save "$syntax\patcit_epo_uk_ipc_level.dta", replace

******************
*Start using Silevrman's data to construct probabilistic mapping
use "$work_data\IPCSICMv5.dta", clear
rename v1 ipc
rename v2 sic
rename v3 mfreq
rename v4 msicpat
rename v5 mtotpat
rename v6 mtotpatipc
drop if sic==1
keep if sic>=1010 & sic<=3999

*Note that Silverman's data maps technology to Canadian SIC. We constructed a mapping between Canadian SIC and UK SIC
gen cansic=sic
sort cansic
merge m:1 cansic using "$work_data\can_uk_sic_map.dta"
keep if _merge==3
*7 sectors ending in zero cannot be matched - we discard them here 
drop _merge
egen group=group(ipc sic)
reshape long uksic wsic, i(group)  j(coagg_sic)

gen mfreq_w=mfreq*wsic
keep if mfreq_w!=.
keep ipc uksic mfreq_w
rename uksic uksic_i

sort ipc uksic_i
by ipc uksic_i: egen mfreq_sic_i=sum(mfreq_w)
collapse (mean) mfreq_sic_i , by(ipc uksic_i)
sort ipc uksic_i
save "$work_data\i_side.dta", replace

****
use "$work_data\IPCSICMv5.dta", clear
rename v1 ipc
rename v2 sic
rename v3 mfreq
rename v4 msicpat
rename v5 mtotpat
rename v6 mtotpatipc
drop if sic==1
keep if sic>=1010 & sic<=3999

gen cansic=sic
sort cansic
merge m:1 cansic using "$work_data\can_uk_sic_map.dta"
keep if _merge==3
drop _merge
egen group=group(ipc sic)
reshape long uksic wsic, i(group)  j(coagg_sic)

gen mfreq_w=mfreq*wsic
keep if mfreq_w!=.
keep ipc uksic mfreq_w
rename uksic uksic_j

sort ipc uksic_j
by ipc uksic_j: egen mfreq_sic_j=sum(mfreq_w)
collapse (mean) mfreq_sic_j , by(ipc uksic_j)
sort ipc uksic_j
save "$work_data\j_side.dta", replace

**********************

use "$syntax\patcit_epo_uk_ipc_level.dta", clear
reshape wide  count_cited count_citing_cited, i(ipc_citing) j(ipc_cited) string
codebook ipc_citing
rename ipc_citing ipc
sort ipc
merge 1:m ipc using "$work_data\i_side.dta"
keep if _merge==3
drop _merge

rename ipc ipc_citing
egen group=group(ipc_citing uksic_i)
reshape long  count_cited count_citing_cited, i(group) j(ipc_cited) string

drop group
order  ipc_citing ipc_cited  uksic_i mfreq_sic_i  count_citing count_citing_cited count_cited
drop if count_citing_cited==.

rename uksic_i uksic_citing
rename mfreq_sic_i mfreq_sic_citing 

save "$work_data\patcit_epo_uk_ipc_level_iside.dta", replace

egen group_i=group(ipc_citing uksic_citing)
keep ipc_citing uksic_citing group_i count_citing mfreq_sic_citing 
bysort group: gen n=_n
keep if n==1
drop n
save "$work_data\group_map_iside.dta", replace


use "$work_data\patcit_epo_uk_ipc_level_iside.dta", clear
egen group=group(ipc_citing uksic_citing)
drop  ipc_citing  uksic_citing mfreq_sic_citing count_citing

reshape wide count_citing_cited, i(ipc_cited) j(group) 

codebook ipc_cited
rename ipc_cited ipc
sort ipc
merge 1:m ipc using "$work_data\j_side.dta"
keep if _merge==3
drop _merge

rename ipc ipc_cited

egen group2=group(ipc_cited uksic_j)
compress
reshape long  count_citing_cited, i(group2) j(group) 

compress
rename group group_i
sort group_i
merge m:1 group_i using "$work_data\group_map_iside.dta"
rename group_i group

rename uksic_j  uksic_cited
rename mfreq_sic_j  mfreq_sic_cited
order  ipc_citing ipc_cited  uksic_citing mfreq_sic_citing uksic_cited mfreq_sic_cited count_citing_cited count_citing count_cited
drop _merge
sort ipc_citing ipc_cited uksic_citing uksic_cited
keep if  count_citing_cited!=.
save "$syntax\patcit_epo_uk_ipc_sector_prob_map.dta", replace

***********************************

gen count_citing_cited_pr=count_citing_cited*mfreq_sic_citing* mfreq_sic_cited
gen count_citing_pr=count_citing*mfreq_sic_citing
gen count_cited_pr=count_cited*mfreq_sic_cited

******************
*Input - how many patents is patent i quoting
*NOTE 1: self-citations were already excluded above
*NOTE 2: we only need to take 1 occurence of the IPC citing/SIC citing combination, otherwise we multiply the total "in" citations by the number of cited IPC/SIC
 
sort ipc_citing uksic_citing
by ipc_citing  uksic_citing: gen a=1 if _n==1
sort uksic_citing
by uksic_citing: egen b=sum(count_citing_pr) if a==1
by uksic_citing: egen tot_input_pr=max(b)
capture drop a b

****
sort uksic_citing uksic_cited
by uksic_citing uksic_cited: egen ij_input_pr=sum(count_citing_cited_pr) 
gen patent_in_ij_pr=ij_input_pr/tot_input_pr
sum  patent_in_ij_pr

******************
*Output - how many citations is patent i generating
*Same notes as above

sort ipc_cited uksic_cited
by ipc_cited uksic_cited: gen a=1 if _n==1

sort uksic_cited
by uksic_cited: egen b=sum(count_cited_pr) if a==1
by uksic_cited: egen tot_output_pr=max(b)
capture drop a b

***
sort uksic_citing uksic_cited
by uksic_citing uksic_cited: egen ij_output_pr=sum(count_citing_cited_pr) 
gen patent_out_ij_pr=ij_output_pr/tot_output_pr
sum  patent_out_ij_pr

collapse (mean) tot_input_pr ij_input_pr patent_in_ij_pr tot_output_pr ij_output_pr patent_out_ij_pr, by(uksic_citing uksic_cited)

save "$output\pat_citations_EPO_prob_SOM.dta", replace

*********************
use "$output\pat_citations_EPO_prob_SOM.dta", clear
rename uksic_citing sic_i
rename uksic_cited sic_j
save "$temp\citations_ij_pr.dta", replace

use "$output\pat_citations_EPO_prob_SOM.dta", clear
rename uksic_cited sic_i
rename uksic_citing sic_j
save "$temp\citations_ji_pr.dta", replace

use "$output\BSD_ij_pairs.dta", replace
*This is an extract from the coagglomeration data produced by the Coagglomeration_Metrics_TopTTWA do files that keeps sector i and j indicators in one year 
*(e.g. 2008 - it does not matter which year because in any case they are constant across years)

merge m:1 sic_i sic_j using "$temp\citations_ij_pr.dta"
drop if _merge==2
rename _merge merge_ij

rename  patent_in_ij_pr input_ij_patent_pr
rename  patent_out_ij_pr output_ij_patent_pr

merge m:1 sic_i sic_j using "$temp\citations_ji_pr.dta"
drop if _merge==2
rename _merge merge_ji

rename  patent_in_ij_pr input_ji_patent_pr
rename  patent_out_ij_pr output_ji_patent_pr

drop  ij_input_pr tot_output_pr ij_output_pr tot_input_pr

egen out_coeff_pat_pr=rowmax(output_ij_patent_pr output_ji_patent_pr) 
egen in_coeff_pat_pr=rowmax(input_ij_patent_pr input_ji_patent_pr)
egen io_coeff_pat_pr=rowmax(out_coeff_pat_pr in_coeff_pat_pr)

*****
erase "$temp\citations_ij_pr.dta"
erase "$temp\citations_ji_pr.dta"
*****

drop sic_i sic_j
local z "  input_ij_patent_pr output_ij_patent_pr merge_ij input_ji_patent_pr output_ji_patent_pr merge_ji out_coeff_pat_pr in_coeff_pat_pr io_coeff_pat_pr"
foreach i of local z {
rename `i' `i'_SOM
}

save "$output\pat_citations_EPO_coagglomeration_prob_SOM.dta", replace
