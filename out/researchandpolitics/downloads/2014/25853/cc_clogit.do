* Replication file for Arzheimer/Evans (2014) Research and Politics, 'Candidate geolocation and voter choice in the 2013 English County Council elections'

* Authors: Kai Arzheimer and Jocelyn Evans

* Date: 7 March 2014


** Number of respondents in analytical sample

use cc_data.dta
keep if an_sample ==1
by id,sort: gen nvals = _n ==1
count if nvals

** Generate table of candidate location by party [Table 1]
use cc_data.dta, clear
keep if cand_sample == 1
bysort voter_ED: egen first = min(id)
keep if first == id

capture save ED_temp.dta

tab contiguity partychoice, column chi2 

*** Conditional logit models [Table 2 and Appendix Table 2A]

** Home division dummy model (I) 
use cc_data.dta, clear

clogit votechoice conservatives libdems ukip feeling homeward incumbent, group(id) cluster(voter_ED)
	est store home

** Contiguity model (II)
clogit votechoice conservatives libdems ukip feeling i.contiguity incumbent, group(id) cluster(voter_ED)
	est store contig

** Straight-line model (III)
clogit votechoice conservatives libdems ukip feeling distance incumbent, group(id) cluster(voter_ED)
	est store straight
	
** Log-distance model (IIIA)

* Correct 0 distances before log transform
tab distance if distance < .5
gen disttemp = distance
recode disttemp (0 = 0.025)
gen log_distance = ln(disttemp)

* Model
clogit votechoice conservatives libdems ukip feeling log_distance incumbent, group(id) cluster(voter_ED)
	est store log_straight

** Straight-line model with interactions (IVA)

* Generate case specific interaction terms( see help(asprvalue) )
gen conservativesXdistance = conservatives*distance
gen libdemsXdistance = libdems*distance
gen ukipXdistance = ukip*distance

* Model
clogit votechoice conservatives libdems ukip feeling distance incumbent conservativesXdistance libdemsXdistance ukipXdistance, group(id) cluster(voter_ED)
	est store level1_straight
	
** Empty model (0), with listwise sample identified from full model
gen empty_id = e(sample)
clogit votechoice conservatives libdems ukip, group(id) cluster(voter_ED), if empty_id == 1
	est store empty

** Produce Table 2 
local tableoptions = `", label title(Conditional Logit)  nomtitles replace coeflabels (incumbent "Incumbency") se star(* 0.1 ** 0.01 *** 0.001) pr2 bic"'
local tablemodels "empty home contig straight"
esttab `tablemodels' using "clogit-table.txt"  `tableoptions'

** Produce Table 2A

local tableoptions = `", label title(Conditional Logit)  nomtitles replace coeflabels (incumbent "Incumbency") se star(* 0.1 ** 0.01 *** 0.001) pr2 bic"'
local tablemodels "log_straight level1_straight"
esttab `tablemodels' using "clogit-table_appendix.txt"  `tableoptions'


*** Simulations [Table 3, Table 3A and Table 4]

** Straight line distance simulations [Table 3]

est restore straight

capture program drop matrixappend

program define matrixappend
	matrix vote = r(p)*100
	matrix prob = prob \ vote'
end program

* Real results

asprvalue, cat(conservatives libdems ukip) base(labour) rest(asmean)
matrix prob = r(asv)
matrixappend

* Sim: Everyone is local (average 5.1km from voter)
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 5.1 5.1 5.1 5.1) rest(asmean)
matrixappend

* Sim: Conservative not local (moved to 20km from voter)
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 20 5.1 5.1 5.1) rest(asmean)
matrixappend
* Sim: LibDem not local (")
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 5.1 20 5.1 5.1) rest(asmean)
matrixappend
* Sim: UKIP not local (")
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 5.1 5.1 20 5.1) rest(asmean)
matrixappend
* Sim: Labour not local (")
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 5.1 5.1 5.1 20) rest(asmean)
matrixappend

* Rename rows
matrix rownames prob = feeling distance incumbent real s1 s2 s3 s4 s5

* Table output
local proboptions = `", label replace coeflabel (feeling "Party feeling" distance "Straight-line distance" incumbent "Incumbent party" real "Real" s1 "Scenario 1" s2 "Scenario 2" s3 "Scenario 3" s4 "Scenario 4" s5 "Scenario 5")"'
esttab matrix(prob,fmt(a3)) using "probabilities-table.txt" `proboptions' 


** Straight line distance (party interaction) simulations [Table 3A]

est restore level1_straight

capture program drop matrixappend

program define matrixappend
	matrix vote = r(p)*100
	matrix prob = prob \ vote'
end program

* Real results

asprvalue, cat(conservatives libdems ukip) base(labour) rest(asmean)
matrix prob = r(asv)
matrixappend

* Sim: Everyone is local (average 5.1km from voter)
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 5.1 5.1 5.1 5.1) rest(asmean)
matrixappend

* Sim: Conservative not local (moved to 20km from voter)
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 20 5.1 5.1 5.1) rest(asmean)
matrixappend
* Sim: LibDem not local (")
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 5.1 20 5.1 5.1) rest(asmean)
matrixappend
* Sim: UKIP not local (")
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 5.1 5.1 20 5.1) rest(asmean)
matrixappend
* Sim: Labour not local (")
asprvalue, cat(conservatives libdems ukip) base(labour) x(distance 5.1 5.1 5.1 20) rest(asmean)
matrixappend


* Rename rows
matrix rownames prob = feeling distance incumbent real s1 s2 s3 s4 s5

* Table output
local proboptions = `", label replace coeflabel (feeling "Party feeling" distance "Straight-line distance" incumbent "Incumbent party" real "Real" s1 "Scenario 1" s2 "Scenario 2" s3 "Scenario 3" s4 "Scenario 4" s5 "Scenario 5")"'
esttab matrix(prob,fmt(a3)) using "probabilities-table_dist_level1.txt" `proboptions' 


** Home division simulations [Table 4]
est restore home

capture program drop matrixappend

program define matrixappend
	matrix vote = r(p)*100
	matrix prob = prob \ vote'
end program

* Real results

asprvalue, cat(conservatives libdems ukip) base(labour) rest(asmean)
matrix prob = r(asv)
matrixappend

* Sim: Everyone is in the home division
asprvalue, cat(conservatives libdems ukip) base(labour) x(homeward 1 1 1 1) rest(asmean)
matrixappend

* Sim: Conservative not home
asprvalue, cat(conservatives libdems ukip) base(labour) x(homeward 0 1 1 1) rest(asmean)
matrixappend
* Sim: LibDem not home
asprvalue, cat(conservatives libdems ukip) base(labour) x(homeward 1 0 1 1) rest(asmean)
matrixappend
* Sim: UKIP not home
asprvalue, cat(conservatives libdems ukip) base(labour) x(homeward 1 1 0 1) rest(asmean)
matrixappend
* Sim: Labour not home
asprvalue, cat(conservatives libdems ukip) base(labour) x(homeward 1 1 1 0) rest(asmean)
matrixappend


* Rename rows
matrix rownames prob = feeling homeward incumbent real s1 s2 s3 s4 s5

* Table output
local proboptions = `", label replace coeflabel (feeling "Party feeling" homeward "Home division" incumbent "Incumbent party" real "Real" s1 "Scenario 1" s2 "Scenario 2" s3 "Scenario 3" s4 "Scenario 4" s5 "Scenario 5")"'
esttab matrix(prob,fmt(a3)) using "probabilities-table_home.txt" `proboptions' 


*** Home division interaction model [not reported] - generic code which can be used for party / feeling interactions replacing 'homeward' with 'feeling'

** Generate case specific interaction terms( see help(asprvalue) )

gen conservativesXhomeward = conservatives*homeward
gen libdemsXhomeward = libdems*homeward
gen ukipXhomeward = ukip*homeward

** Home-division model with party / distance interactions 
clogit votechoice conservatives libdems ukip feeling homeward incumbent conservativesXhomeward libdemsXhomeward ukipXhomeward, group(id) cluster(voter_ED)
	est store level1_home
	
** Produce table
local tableoptions = `", label title(Conditional Logit)  nomtitles replace coeflabels (incumbent "Incumbency") se star(* 0.1 ** 0.01 *** 0.001) pr2 bic"'
local tablemodels "home level1_home"
esttab `tablemodels' using "County_clogit-table_level1_home.txt"  `tableoptions'

/* cc_clogit.do ends here */
