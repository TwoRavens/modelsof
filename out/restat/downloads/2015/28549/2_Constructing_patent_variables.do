

************************************************************************************************************
***
***								REPLICATION FILE FOR ETS INNOVATION PAPER
***
************************************************************************************************************

// IDENTIFY POLLUTION CONTROL PATENTS (as in POPP 2006)

create table pct_all_patents as
    select distinct 
			b.appln_id
    from patstat.tls209_appln_ipc as b
	where
-- pollution control technology (Popp 2006)
   b.ipc_class_symbol like 'F23C   6/04%'
or b.ipc_class_symbol like 'F23C   9%'
or b.ipc_class_symbol like 'F23C  10%'
or b.ipc_class_symbol like 'F23C 101%'
or b.ipc_class_symbol like 'B01D  53/56%'
or b.ipc_class_symbol like 'B01D  53/60%'
or b.ipc_class_symbol like 'B01D  53/86%'
or b.ipc_class_symbol like 'B01J  29/06%'
or b.ipc_class_symbol like 'B01D  53/14%'
or b.ipc_class_symbol like 'B01D  53/50%'
or b.ipc_class_symbol like 'B01D  53/34%'
or b.ipc_class_symbol like 'B01D  53/74%'	
;


// CONSTRUCT ANNUAL PATENT COUNTS AT EPO (FOR FIGURES 1-3 AND DESCRIPTIVE STATISTICS)

use patstat/TLS201_APPLN, clear
keep appln_auth ipr_type appln_nr appln_id appln_year
keep if appln_auth=="EP"
keep if ipr_type=="PI"
* Identify climate change mitigation patents according to EPO's Y02 definition (see Appendix C of the paper)
* Note: at the time of the redaction of the paper, only subclasses Y02C and Y02E were available from the EPO.
* New classes have recently been made available: Y02B (buildings) and Y02T (transportation)
mmerge appln_id using patstat/Y02_patents, unmatched(master) 
gen green_pat_Y02 = (_merge==3)
* Identify climate change mitigation patents according to extended definition combining Y02 category and selected IPC classification codes (see Appendix C of the paper)
mmerge appln_id using patstat/low_carbon_patents, unmatched(master)
gen green_pat_Y02_IPC = (_merge==3)
* Identify pollution control technologies (PCT) patents as defined by Popp (2006) - see above
mmerge appln_id using patstat/PCT_patents, unmatched(master) 
gen pct_pat = (_merge==3)
// some appln_nr have several appln_id - get rid of duplicates
bysort appln_nr : egen max_green_pat_Y02 = max(green_pat_Y02)
replace green_pat_Y02 = max_green_pat_Y02
bysort appln_nr : egen max_green_pat_Y02_IPC = max(green_pat_Y02_IPC)
replace green_pat_Y02_IPC = max_green_pat_Y02_IPC
bysort appln_nr : egen max_pct_pat = max(pct_pat)
replace pct_pat = max_pct_pat
bysort appln_nr : egen min_appln_year = min(appln_year)
replace appln_year = min_appln_year
drop appln_id _merge max_* min_appln_year _m
duplicates drop
gen x=1
bysort year : egen tot_epo_green_pat_Y02 = sum(green_pat_Y02) 
bysort year : egen tot_epo_green_pat_Y02plus = sum(green_pat_Y02_IPC) 
bysort year : egen tot_epo_pct_pat = sum(pct_pat)
bysort year : egen tot_epo_pat = sum(x)
keep year *_EPO
duplicates drop
drop if year==.
drop if year==9999
gen share_greenpat_epo_Y02 = tot_epo_green_pat_Y02/ tot_epo_pat
gen share_greenpat_epo_Y02plus = tot_epo_green_pat_Y02plus/ tot_epo_pat
gen share_greenpat_epo_PCT = tot_epo_pct_pat/ tot_epo_pat
save paper/EPO_patents, replace



// CONSTRUCT FIRM-YEAR PATENT COUNTS 

* Start from the list of patents matched to BVDID by Orbis
* This can be downloaded from the Orbis database under a commercial license
* The file includes BvDIDnumber and Applicationnumber

use orbis/orbispatents, clear
* retrieve patent number as recorded in Patstat
gen ll=length(Applicationnumber)-9
gen appln_nr_epodoc = substr(Applicationnumber,1,ll)
* merge with Patstat TLS201_APPLN table
mmerge appln_nr_epodoc using patstat/TLS201_APPLN, ukeep(appln_id ipr_type appln_auth appln_nr) unmatched(master)
drop ll* Applicationnumber _m
destring, replace
duplicates drop
save paper/Orbis_patents_list, replace



* EPO patents linked with a BVDID

use paper/Orbis_patents_list, clear
keep if appln_auth=="EP"
keep if ipr_type=="PI"
drop  appln_auth ipr_type appln_nr_epodoc
* Identify climate change mitigation patents according to EPO's Y02 definition (see Appendix C of the paper)
* Note: at the time of the redaction of the paper, only subclasses Y02C and Y02E were available from the EPO.
* New classes have recently been made available: Y02B (buildings) and Y02T (transportation)
mmerge appln_id using patstat/Y02_patents, unmatched(master) 
gen green_pat_Y02 = (_merge==3)
* Identify climate change mitigation patents according to extended definition combining Y02 category and selected IPC classification codes (see Appendix C of the paper)
mmerge appln_id using patstat/low_carbon_patents, unmatched(master)
gen green_pat_Y02_IPC = (_merge==3)
* Identify pollution control technologies (PCT) patents as defined by Popp (2006) - see above
mmerge appln_id using patstat/PCT_patents, unmatched(master) 
gen pct_pat = (_merge==3)
// some appln_nr have several appln_id - get rid of duplicates
bysort appln_nr : egen max_green_pat_Y02 = max(green_pat_Y02)
replace green_pat_Y02 = max_green_pat_Y02
bysort appln_nr : egen max_green_pat_Y02_IPC = max(green_pat_Y02_IPC)
replace green_pat_Y02_IPC = max_green_pat_Y02_IPC
bysort appln_nr : egen max_pct_pat = max(pct_pat)
replace pct_pat = max_pct_pat
bysort appln_nr : egen min_appln_year = min(appln_year)
replace appln_year = min_appln_year
drop appln_id _merge max_* min_appln_year _m
duplicates drop
gen x=1
ren appln_year year
// generate firm-year patent counts
bysort BvD year : egen epo_green_pat_epo = sum(green_pat_Y02) 
bysort BvD year : egen epo_green_pat_epoipc = sum(green_pat_Y02_IPC) 
bysort BvD year : egen epo_total_pat = sum(x)
keep BvD year epo_*
duplicates drop  
drop if year==.
compress
save paper/BVDID_EPO_patent_counts, replace


// NOTE 1: In the paper we also use domestic patent counts in one robustness check. This is determined using the exact same piece of code but keeping if appln_auth==country where country is the BVDID's location country according to Orbis (instead of keeping if appln_auth=="EP")


// NOTE 2: In the paper we also weight patents by family size or number of forward citations in one robustness check. To obtain family size from Patstat use the following code: 

use patstat/tls218_docdb_fam, clear
mmerge appln_id using patstat/TLS201_APPLN, unmatched(master) ukeep(appln_auth)
bys docdb appln_auth: gen w = _n==1
bysort docdb : egen famsize = sum(w)
bysort appln_id : egen maxsize = max(famsize)
replace famsize = maxsize
replace famsize=1 if famsize==.
keep appln_id famsize
duplicates drop
compress
save patstat/familysize, replace 

// To obtain forward citations in Patstat use the following code: 

use patstat/tls211_pat_publn, clear
keep appln_id pat_publn_id publn_year
bysort appln_id : egen min_publn_year = min(publn_year)
replace publn_year = min_publn_year
drop min*
ren appln_id cited_appln_id
* unmatched none -> all other patents have 0 citation
ren pat_publn_id cited_pat_publn_id
mmerge cited_pat_publn_id using patstat/tls212_citation, unmatched(none) ukeep(pat_publn_id) uif(pat_citn_seq_nr>0)
ren pat_publn_id citing_pat_publn_id
mmerge citing_pat_publn_id using patstat/tls211_pat_publn, unmatched(master) umatch(pat_publn_id) ukeep(appln_id)
drop citing_pat_publn_id pat_publn_id
duplicates drop
mmerge appln_id using patstat/TLS201_APPLN, unmatched(master) ukeep(appln_year)
ren appln_id citing_appln_id
drop _merge 
duplicates drop
compress
save patstat/citations_by_appln_id, replace
	
* Identify self-cites
use patstat/citations_by_appln_id, clear
mmerge cited_appln_id using patstat/tls207_pers_appln, umatch(appln_id) unmatched(none) uif(invt_seq_nr>0)
rename person_id person_id_cited
drop _merge 
mmerge citing_appln_id using patstat/tls207_pers_appln, umatch(appln_id) unmatched(none) uif(invt_seq_nr>0)
rename person_id person_id_citing
drop _merge 
gen x = person_id_cited == person_id_citing
bys cited_appln_id citing_appln_id: egen self_cite = sum(x)
keep if self_cite > 0
drop self_cite x person_id_cited person_id_citing
duplicates drop
save patstat/self_cites, replace

* citation counts excluding self-citations
use patstat/citations_by_appln_id, clear
mmerge cited_appln_id citing_appln_id using patstat/self_cite, unmatched(master)
drop if _merge==3
drop _merge
gen x=1
bysort cited_appln_id : egen citations = sum(x)
keep cited_appln_id citations
duplicates drop
save patstat/forward_citations, replace

// Note: patent appln_id not in patstat/forward_citations have 0 citations
// do not forget to replace citations by 0 if citations==. when merging with patent file


************  ANNUAL PATENT COUNTS FOR FIGURES 1-3 AND DESCRIPTIVE STATISTICS

* Annual patent counts for ETS companies

use common_data/orbis_patents/BVDID_EPO_patent_counts, clear
keep if year>1977 & year<2010
// identify ETS-regulated companies
mmerge BvD using ETS/CITL_BVD_list, umatch(bvdid) unmatched(master) 
gen ets_company = _m==3
keep if ets_company==1
drop _m
fillin BvD year
foreach pat in green_pat_epo green_pat_epoipc pct_pat total_pat{
	replace epo_`pat' = 0 if epo_`pat'==. 
	}
drop _fillin
bysort year : egen total_patents_ets = sum(epo_total_pat)
bysort year : egen pct_patents_ets = sum(epo_pct_pat)
bysort year : egen greenpat_epo_ets = sum(epo_green_pat_epo)
bysort year : egen greenpat_epoipc_ets = sum(epo_green_pat_epoipc)
keep year *ets
duplicates drop
gen share_greenpat_epo_ets = greenpat_epo_ets / total_patents_ets
gen share_greenpat_epoipc_ets = greenpat_epoipc_ets / total_patents_ets
gen share_pct_patents_ets = pct_patents_ets / total_patents_ets
save paper/ETS_patents, replace

* Annual patent counts for non ETS companies 

use common_data/orbis_patents/BVDID_EPO_patent_counts, clear
keep if year>1977 & year<2010
mmerge BvD using ETS/CITL_BVD_list, umatch(bvdid) unmatched(master) 
gen ets_company = _m==3
keep if ets_company==0
drop _m
fillin BvD year
foreach pat in green_pat_epo green_pat_epoipc pct_pat total_pat{
	replace epo_`pat' = 0 if epo_`pat'==. 
	}
drop _fillin
bysort year : egen total_patents_nonets = sum(epo_total_pat)
bysort year : egen pct_patents_nonets = sum(epo_pct_pat)
bysort year : egen greenpat_epo_nonets = sum(epo_green_pat_epo)
bysort year : egen greenpat_epoipc_nonets = sum(epo_green_pat_epoipc)
keep year *nonets
duplicates drop
gen share_greenpat_epo_nonets = greenpat_epo_nonets / total_patents_nonets
gen share_greenpat_epoipc_nonets = greenpat_epoipc_nonets / total_patents_nonets
gen share_pct_patents_nonets = pct_patents_nonets / total_patents_nonets
save paper/nonETS_patents, replace


* Annual patent counts for ETS companies FROM TREATED GROUP only

use common_data/orbis_patents/BVDID_EPO_patent_counts, clear
keep if year>1977 & year<2010
mmerge BvD using ETS/CITL_BVD_list, umatch(bvdid) unmatched(master) 
gen ets_company = _m==3
keep if ets_company==1
mmerge BvD using paper/matched_sample, umatch(bvdid) unmatched(none) ukeep(bvd)
drop _m
fillin BvD year
foreach pat in green_pat_epo green_pat_epoipc pct_pat total_pat{
	replace epo_`pat' = 0 if epo_`pat'==. 
	}
drop _fillin
bysort year : egen total_patents_treat = sum(epo_total_pat)
bysort year : egen pct_patents_treat = sum(epo_pct_pat)
bysort year : egen greenpat_epo_treat = sum(epo_green_pat_epo)
bysort year : egen greenpat_epoipc_treat = sum(epo_green_pat_epoipc)
keep year *treat
duplicates drop
gen share_greenpat_epo_treat = greenpat_epo_treat / total_patents_treat
gen share_greenpat_epoipc_treat = greenpat_epoipc_treat / total_patents_treat
gen share_pct_patents_treat = pct_patents_treat / total_patents_treat
save paper/ETS_patents_treatedgroup, replace

* Annual patent counts for non ETS companies FROM CONTROL GROUP only

use common_data/orbis_patents/BVDID_EPO_patent_counts, clear
keep if year>1977 & year<2010
mmerge BvD using ETS/CITL_BVD_list, umatch(bvdid) unmatched(master) 
gen ets_company = _m==3
keep if ets_company==0
mmerge BvD using paper/matched_sample, umatch(bvdid) unmatched(none) ukeep(bvd)
drop _m
fillin BvD year
foreach pat in green_pat_epo green_pat_epoipc pct_pat total_pat{
	replace epo_`pat' = 0 if epo_`pat'==. 
	}
drop _fillin
bysort year : egen total_patents_ctrl = sum(epo_total_pat)
bysort year : egen pct_patents_ctrl = sum(epo_pct_pat)
bysort year : egen greenpat_epo_ctrl = sum(epo_green_pat_epo)
bysort year : egen greenpat_epoipc_ctrl = sum(epo_green_pat_epoipc)
keep year *ctrl
duplicates drop
gen share_greenpat_epo_ctrl = greenpat_epo_ctrl / total_patents_ctrl
gen share_greenpat_epoipc_ctrl = greenpat_epoipc_ctrl / total_patents_ctrl
gen share_pct_patents_ctrl = pct_patents_ctrl / total_patents_ctrl
save paper/ETS_patents_controlgroup, replace


************ 

* Merge above data sets & construct variables for graphs

use paper/EPO_patents, clear
mmerge year using paper/ETS_patents, unmatched(master)
mmerge year using paper/nonETS_patents, unmatched(master)
mmerge year using paper/ETS_patents_treatedgroup, unmatched(master)
mmerge year using paper/ETS_patents_controlgroup, unmatched(master)
mmerge year using paper/oil_price, unmatched(master)
drop _m
keep if year<2010
save paper/data_for_graphs, replace
outsheet using paper/data_for_graphs.csv, replace comma


