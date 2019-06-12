* ====================================
* Klüver/Spoon: Helping or Hurting?
* Journal of Politics
*  
* Replication Do File
* ====================================

cd "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\"
use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\KlueverSpoonHelpingorHurting.dta", clear


* Government status
tab junior
tab senior
tab opposition


* Sample characteristics: 1156 observations
distinct(country)  // 28 countries
distinct(party) // 307 parties
distinct(election_id)  // 219 elections


* Time frame: 1972 until 2017
sort next_date
order country date party date next_date




* Figure A1: Histogram
* =====================
hist next_pervote , freq  scheme(lean1) xtitle("Vote share at the next election")



* Table A.1: Relative vote share by government type
* ==================================================
sum next_pervote if junior == 1 
sum next_pervote if senior == 1 
sum next_pervote if opposition == 1 



* Table A.2: Descriptive Statistics
* =================================

sum next_pervote junior senior opposition niche_party seatshare policy_extreme_logit conflict_logit_new pervote


 
* ========================================================
* Table 1: Absolute vote share (only coalition parties)
* ========================================================

* Model 1 
* =======
use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\KlueverSpoonHelpingorHurting.dta", replace

regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new pervote if cabinet_party == 1, vce(cluster election_id)    
estimates store m1



* ==============================================================
* Table 2: Absolute vote share (coalition and opposition parties)
* ==============================================================

use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\KlueverSpoonHelpingorHurting.dta", clear


* Randomly dropping one observation per election
distinct(election_id)

set seed 987
gen r = uniform()      
by election_id opposition(r), sort: gen select = _n==1
replace select = 0 if opposition == 0


sort country date
order country election_id opposition select party


* Model 2
* =======
regress next_pervote senior opposition niche_party seatshare policy_extreme_logit conflict_logit_new pervote  if select ~= 1 
estimates store m2


* Sample (based on randomly dropping one opposition party per election)
distinct(election_id)
tab junior if e(sample) == 1
tab senior if e(sample) == 1
tab opposition if e(sample) ==1




* =============
* Figure 1
* =============

* Model 2
regress next_pervote senior opposition niche_party seatshare policy_extreme_logit conflict_logit_new pervote  if select ~= 1 
estimates store m2


matrix V=e(V)
svmat V, names(vvector)
outsheet vvector* using varcov2.csv, comma replace

matrix b=e(b) 
svmat b, names(fixeff)
outsheet fixeff* using fixeff2.csv, comma replace

drop if e(sample) == 0

keep next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new pervote

saveold m2.dta, replace




* =======================================
* Pledges Case Study
* =======================================

use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\KlueverSpoonHelpingorHurting_Pledges_Germany.dta", clear


* Descriptives
tab fulfill party, col V chi2


* Figure 2
* ========
graph combine "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Pledges\cducsu.gph" "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Pledges\fdp.gph", ycommon scheme(s2mono) 
graph save Graph "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Pledges\fig2.gph", replace 




* ===========================
* Misperception Case Study
* ===========================

use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\cses4.dta"

keep if D1004 == "DEU_2013"



* Chapel Hill positions
* =====================
gen ches_cdu2014 = 5.9230771
gen ches_csu2014 = 7.2307692
gen ches_fdp2014 = 6.5384617

egen pos_cdu = mean(D3013_A) if D3013_A <= 10
egen pos_csu = mean(D3013_E) if D3013_E <= 10
egen pos_fdp = mean(D3013_F) if D3013_F <= 10

gen dist_cdu = abs(ches_cdu2014 - pos_cdu)
gen dist_csu = abs(ches_csu2014 - pos_csu)
gen dist_fdp = abs(ches_fdp2014 - pos_fdp)

order dist* pos* D3013_A D3013_E D3013_F 

list ches* pos* dist* if _n == 1




**** =======================================
**** APPENDIX 
**** =======================================

use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\KlueverSpoonHelpingorHurting.dta", clear


* Original model
regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new pervote if cabinet_party == 1, vce(cluster election_id)    



* Table A.3: Outlier analysis
* ============================

regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new pervote if cabinet_party == 1 

dfbeta
list  _dfbeta_1 country date party  if abs( _dfbeta_1) > 2/sqrt(460)

regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new pervote if cabinet_party == 1  & abs( _dfbeta_1) <= 2/sqrt(460) , vce(cluster election_id)



* Table A.4 Controling for cabinet reshuffling
* ============================================

regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new cabchange pervote if cabinet_party == 1, vce(cluster election_id) 



* Table A.5 Interaction with party type
* =====================================
gen junior_niche = junior * niche
regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new junior_niche pervote if cabinet_party == 1, vce(cluster election_id) 



* Table A.6 Interaction with party seat share
* ===========================================
gen junior_seatshare = junior * seatshare
regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new junior_seatshare pervote if cabinet_party == 1, vce(cluster election_id) 



* Table A.7: Rile Estimates
* =================================

regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new shift_rile pervote if cabinet_party == 1, vce(cluster election_id) 



* Table A.8: Country fixed effects
* ================================

regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new pervote i.country if cabinet_party == 1, vce(cluster election_id) 



* Table A.9: Party fixed effects
* ================================

regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new pervote i.party if cabinet_party == 1, vce(cluster election_id) 



* Table A.10: Multilevel model clustering into elections
* ======================================================

xtmixed next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new pervote if cabinet_party == 1 || election_id: , var mle 



* Table A.11: Interaction with economic performance
* ==================================================

* interaction: change in unemployment
regress next_pervote i.junior##c.change_unemployment niche_party seatshare policy_extreme_logit conflict_logit_new pervote if cabinet_party == 1, vce(cluster election_id) 

* interaction: change in GDP 
regress next_pervote i.junior##c.change_gdp niche_party seatshare policy_extreme_logit conflict_logit_new pervote if cabinet_party == 1, vce(cluster election_id) 



* Table A.12: Pledges analysis
* ============================

cd "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\"
use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\KlueverSpoonHelpingorHurting_Pledges.dta", clear


* Model 14
regress fulfill3_fully  single_party_gov senior opposition , vce(cluster party)
estimates store pledges1a

* Model 15
regress fulfill3_partly  single_party_gov senior opposition , vce(cluster party)
estimates store pledges1b

* Model 16
regress fulfill3_none  single_party_gov senior opposition , vce(cluster party)
estimates store pledges1c


* Figures
* =======

* Figure A.2: Fully fulfilled pledges
cd "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\"
use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\KlueverSpoonHelpingorHurting_Pledges.dta", clear


regress fulfill3_fully  single_party_gov senior opposition , vce(cluster party)

matrix V=e(V)
svmat V, names(vvector)
outsheet vvector* using varcov_pledges1a.csv, comma replace

matrix b=e(b) 
svmat b, names(fixeff)
outsheet fixeff* using fixeff_pledges1a.csv, comma replace

drop if e(sample) == 0

keep fulfill3_fully  single_party_gov senior opposition party
saveold pledges1a.dta, replace


* Figure A.3: Not fulfilled pledges
cd "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\"
use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\KlueverSpoonHelpingorHurting_Pledges.dta", clear

regress fulfill3_none  single_party_gov senior opposition , vce(cluster party)

matrix V=e(V)
svmat V, names(vvector)
outsheet vvector* using varcov_pledges1c.csv, comma replace

matrix b=e(b) 
svmat b, names(fixeff)
outsheet fixeff* using fixeff_pledges1c.csv, comma replace

drop if e(sample) == 0

keep fulfill3_none  single_party_gov senior opposition party
saveold pledges1c.dta, replace



* Figure A.4: Approval Ratings
* ============================

cd "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\"
use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\Approval Ratings_Germany_09-13.dta", clear

line mean_cdu mean_csu mean_fdp modate, ytitle(Approval Rating) ttitle(Oct 2009-Dec 2013)




* Table A.13: Models with opposition support parties
* ======================================================
cd "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\"
use "C:\Users\klueverh\Dropbox\Dokumente\Papers\Party context paper\Paper #8\Replication 3rd Revision\KlueverSpoonHelpingorHurting.dta", clear

set seed 123           /*  Change seed to whatever you want */
gen r = uniform()      
by election_id(r), sort: gen select = _n==1


regress next_pervote junior niche_party seatshare policy_extreme_logit conflict_logit_new opp_support pervote if select ~= 1



* Table A.14: Model excluding seat share
* ======================================================

regress next_pervote junior niche_party policy_extreme_logit conflict_logit_new pervote if cabinet_party == 1, vce(cluster election_id)     



* Table A.15: Alternative DV specifications
* ================================================

* Vote gains as the DV
regress vote_gains junior niche_party seatshare policy_extreme_logit conflict_logit_new  pervote if cabinet_party == 1, vce(cluster election_id)     

* Vote ratio as the DV
regress next_votes_rel junior niche_party seatshare policy_extreme_logit conflict_logit_new  pervote  if cabinet_party == 1, vce(cluster election_id)   



* Table A.16: Model with opposition parties without randomly dropping an observation
* ===================================================================================
regress next_pervote senior opposition niche_party seatshare policy_extreme_logit conflict_logit_new pervote , vce(cluster election_id)   



