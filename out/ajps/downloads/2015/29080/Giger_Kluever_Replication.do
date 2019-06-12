* ============================================================================================================
* Replication Do-File for AJPS-Article "Voting against your constituents? How lobbying affects representation"
* by Nathalie Giger and Heike Klüver, 03.02.2015
* ============================================================================================================


* ==================================================
* TABLES 2 and 3
* ==================================================

cd "C:\Users\ba9ze3-1\Dropbox\Dokumente\Papers\Schweiz IG MP Paper\Final Submission\Giger_Kluever_Replication\"
use Giger_Kluever_Replication.dta, clear


* TABLE 2
* =======

tab defect


* TABLE 3 
* =======

* Model 1
xtmelogit  defect econ_no ngo_no mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var mle  
estat ic

* Model 2
xtmelogit  defect party_econ_no party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var mle  
estat ic

* Model 3
xtmelogit  defect econ_no ngo_no party_econ_no  party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var laplace
estat ic



* ===========================================
* Figures 1 - 4 (in combination with R code)
* ===========================================

set more off

* Figure 1a
* =========
use Giger_Kluever_Replication.dta, clear

* Max and mean number of sectional groups and ttest
sum econ_no 
ttest econ_no = ngo_no

* Number of sectional groups per MP averaged across years
sort mp_id year
by mp_id year: gen mp_runner = _n
gen mp_tagger = 1 if mp_runner == 1

drop if mp_tagger == .
drop mp_tagger

by mp_id: egen econs_per_mp = mean(econ_no)

egen mp_tagger = tag(mp_id)
drop if mp_tagger ~= 1

saveold "figure1a.dta", replace


* Figure 1b
* =========
use Giger_Kluever_Replication.dta, clear

* Max and mean number of cause groups 
sum ngo_no

* Number of cause groups per MP averaged across years
sort mp_id year
by mp_id year: gen mp_runner = _n
gen mp_tagger = 1 if mp_runner == 1

drop if mp_tagger == .
drop mp_tagger

by mp_id: egen ngos_per_mp = mean(ngo_no)

egen mp_tagger = tag(mp_id)
drop if mp_tagger ~= 1

saveold "figure1b.dta", replace


* Figure 2a
* =========
use Giger_Kluever_Replication.dta, clear

* Max and mean number of sectional groups and ttest
sum party_econ_no 
ttest party_econ_no = party_ngo_no

* Number of sectional groups per MP averaged across years
sort party year
by party year: gen party_runner = _n
gen party_tagger = 1 if party_runner == 1

drop if party_tagger == .
drop party_tagger

by party: egen igs_per_party = mean(party_econ_no)

egen party_tagger = tag(party)
drop if party_tagger ~= 1

gsort - igs_per_party

saveold "figure2a.dta", replace


* Figure 2b
* =========
use Giger_Kluever_Replication.dta, clear

* Max and mean number of cause groups 
sum party_ngo_no

* Number of cause groups per MP averaged across years
sort party year
by party year: gen party_runner = _n
gen party_tagger = 1 if party_runner == 1

drop if party_tagger == .
drop party_tagger


by party: egen igs_per_party = mean(party_ngo_no)

egen party_tagger = tag(party)
drop if party_tagger ~= 1

gsort - igs_per_party

saveold "figure2b.dta", replace


* Figure 3a and 3b (in combination with R code)
* ======================================================
use Giger_Kluever_Replication.dta, clear

* Model 1
xtmelogit  defect econ_no ngo_no mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var mle  
estat ic

matrix V=e(V)
svmat V, names(vvector)
outsheet vvector* using varcov_m1.csv, comma replace

matrix b=e(b) 
svmat b, names(fixeff)
outsheet fixeff* using fixeff_m1.csv, comma replace

drop if e(sample) == 0

saveold RGraph_Data_m1.dta, replace


* Figure 4a and 4b (combination with R code)
* ======================================================
use Giger_Kluever_Replication.dta, clear

* Model 2
xtmelogit  defect party_econ_no party_ngo_no  mp_number partei_einig closevolk  closeparl  bet months2elec RefOblig  RefFak  || _all: mp_canton || party: , var mle  
estat ic

matrix V=e(V)
svmat V, names(vvector)
outsheet vvector* using varcov_m2.csv, comma replace

matrix b=e(b) 
svmat b, names(fixeff)
outsheet fixeff* using fixeff_m2.csv, comma replace

drop if e(sample) == 0

saveold RGraph_Data_m2.dta, replace


* T-Test
* ======
use Giger_Kluever_Replication.dta, clear

ttest ngo_no = econ_no
ttest party_ngo_no = party_econ_no



* =========================================
* Dataset for case studies (Tables 5 and 6)
* ========================================= 

use Giger_Kluever_Replication_Casestudy.dta, clear


* TABLE 5
* =======

bys casestudy_nr: logit defect IG_oppbi mp_number partei_einig, cl(mp_id)


* TABLE 6
* =======

bys casestudy_nr: tab parol_maj if econ
bys casestudy_nr: tab parol_maj if ngo

