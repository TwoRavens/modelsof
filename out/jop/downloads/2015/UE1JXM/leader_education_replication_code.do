* Nicholas Carnes and Noam Lupu
* "What Good is a College Degree?"
* Replication code
* June 2015

version 14

********************************
* Table 1
********************************

*keep country year post5 post5college post5nocollege loggdp top1pctincomeshare strikes unemployment loginflation disputes unrest pre5college pre5nocollege loggdp_pretrans strikes_pretrans top1pctincomeshare_pretrans post3 post3college post3nocollege post1 post1college post1nocollege  loggdp_change college_college nocollege_college nocollege_nocollege loggdp strikes_change loginflation_change

use "cross-national leaders.dta", clear

xi: regress loggdp post5 i.country i.year, robust level(90)
xi: regress loggdp post5college post5nocollege i.country i.year, robust level(90)
xi: regress loggdp post5 post5college i.country i.year, robust level(90)

xi: regress top1pctincomeshare post5 i.country i.year, robust level(90)
xi: regress top1pctincomeshare post5college post5nocollege i.country i.year, robust level(90)
xi: regress top1pctincomeshare post5 post5college i.country i.year, robust level(90)

xi: regress strikes post5 i.country i.year, robust level(90)
xi: regress strikes post5college post5nocollege i.country i.year, robust level(90)
xi: regress strikes post5 post5college i.country i.year, robust level(90)

xi: regress unemployment post5 i.country i.year, robust level(90)
xi: regress unemployment post5college post5nocollege i.country i.year, robust level(90)
xi: regress unemployment post5 post5college i.country i.year, robust level(90)

xi: regress loginflation post5 i.country i.year, robust level(90)
xi: regress loginflation post5college post5nocollege i.country i.year, robust level(90)
xi: regress loginflation post5 post5college i.country i.year, robust level(90)

xi: regress disputes post5 i.country i.year, robust level(90)
xi: regress disputes post5college post5nocollege i.country i.year, robust level(90)
xi: regress disputes post5 post5college i.country i.year, robust level(90)

* Table 1a
xi: regress unrest post5 i.country i.year, robust level(90)
xi: regress unrest post5college post5nocollege i.country i.year, robust level(90)
xi: regress unrest post5 post5college i.country i.year, robust level(90)

* Table 1b
xi: regress loggdp post5 i.country i.year, robust level(90)
xi: regress loggdp post5college post5nocollege i.country i.year pre5college pre5nocollege loggdp_pretrans, robust level(90)
xi: regress loggdp post5 post5college pre5college pre5nocollege i.country i.year pre5college pre5nocollege loggdp_pretrans, robust level(90)

xi: regress top1pctincomeshare post5 i.country i.year, robust level(90)
xi: regress top1pctincomeshare post5college post5nocollege i.country i.year pre5college pre5nocollege top1pctincomeshare_pretrans, robust level(90)
xi: regress top1pctincomeshare post5 post5college i.country i.year pre5college pre5nocollege top1pctincomeshare_pretrans, robust level(90)

xi: regress strikes post5 i.country i.year, robust level(90)
xi: regress strikes post5college post5nocollege i.country i.year pre5college pre5nocollege strikes_pretrans, robust level(90)
xi: regress strikes post5 post5college i.country i.year pre5college pre5nocollege strikes_pretrans, robust level(90)

* Table 1c
xi: regress loggdp post3 i.country i.year, robust level(90)	
xi: regress loggdp post3college post3nocollege i.country i.year, robust level(90)
xi: regress loggdp post3 post3college i.country i.year, robust level(90)

xi: regress top1pctincomeshare post3 i.country i.year, robust level(90)
xi: regress top1pctincomeshare post3college post3nocollege i.country i.year, robust level(90)
xi: regress top1pctincomeshare post3 post3college i.country i.year, robust level(90)

xi: regress strikes post3 i.country i.year, robust level(90)
xi: regress strikes post3college post3nocollege i.country i.year, robust level(90)
xi: regress strikes post3 post3college i.country i.year, robust level(90)

* Table 1d
xi: regress loggdp post1 i.country i.year, robust level(90)
xi: regress loggdp post1college post1nocollege i.country i.year, robust level(90)
xi: regress loggdp post1 post1college i.country i.year, robust level(90)

xi: regress top1pctincomeshare post1 i.country i.year, robust level(90)
xi: regress top1pctincomeshare post1college post1nocollege i.country i.year, robust level(90)
xi: regress top1pctincomeshare post1 post1college i.country i.year, robust level(90)

xi: regress strikes post1 i.country i.year, robust level(90)
xi: regress strikes post1college post1nocollege i.country i.year, robust level(90)
xi: regress strikes post1 post1college i.country i.year, robust level(90)

* Table 1e
regress loggdp_change college_college nocollege_college nocollege_nocollege loggdp
regress strikes_change college_college nocollege_college nocollege_nocollege strikes
regress loginflation_change college_college nocollege_college nocollege_nocollege loginflation


********************************
* Table 2
********************************

use "US Congress.dta", clear

xi: reg V48 close i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg V48 close_college close_nocollege i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg V48 close close_college i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)

xi: reg lostelection close i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg lostelection close_college close_nocollege i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg lostelection close close_college i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)

xi: reg bills_enacted_AVG close i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg bills_enacted_AVG close_college close_nocollege i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg bills_enacted_AVG close close_college i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)

* Table 2a
xi: reg V48 nonclose i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg V48 nonclose_college nonclose_nocollege i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg V48 nonclose nonclose_college i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)

xi: reg lostelection nonclose i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg lostelection nonclose_college nonclose_nocollege i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg lostelection nonclose nonclose_college i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)

xi: reg bills_enacted_AVG nonclose i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg bills_enacted_AVG nonclose_college nonclose_nocollege i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: reg bills_enacted_AVG nonclose nonclose_college i.V46 i.V47 state_* chamber if first_congress==1 & V46>=901, robust level(90)

* Table 2b
xi: regress V48 college rep i.V11 i.V46 i.V47 i.V19 V9 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: regress lostelection college rep i.V11 i.V46 i.V47 i.V19 V9 state_* chamber if first_congress==1 & V46>=901, robust level(90)
xi: regress bills_enacted_AVG college rep i.V11 i.V46 i.V47 i.V19 V9 state_* chamber if first_congress==1 & V46>=901, robust level(90)


********************************
* Table 3
********************************

use "Brazil mayors audit.dta", clear

xi: reg broad close i.term i.regions,  cluster(id_city) level(90)
xi: reg broad closecollege closenocollege i.term i.regions,  cluster(id_city) level(90)
xi: reg broad close closecollege i.term i.regions,  cluster(id_city) level(90)

xi: reg narrow close i.term i.regions,  cluster(id_city) level(90)
xi: reg narrow closecollege closenocollege i.term i.regions,  cluster(id_city) level(90)
xi: reg narrow close closecollege i.term i.regions,  cluster(id_city) level(90)

xi: reg fraction_broad close i.term i.regions,  cluster(id_city) level(90)
xi: reg fraction_broad closecollege closenocollege i.term i.regions,  cluster(id_city) level(90)
xi: reg fraction_broad close closecollege i.term i.regions,  cluster(id_city) level(90)

xi: reg fraction_narrow close i.term i.regions,  cluster(id_city) level(90)
xi: reg fraction_narrow closecollege closenocollege i.term i.regions,  cluster(id_city) level(90)
xi: reg fraction_narrow close closecollege i.term i.regions,  cluster(id_city) level(90)

use "Brazil mayors economic.dta", clear

xi: reg gdpvariable close i.election_year i.state, cluster(name)
xi: reg gdpvariable closecollege closenocollege i.election_year i.state, cluster(name)
xi: reg gdpvariable close closecollege i.election_year i.state, cluster(name)

use "Brazil mayors elect.dta", clear

xi: reg reelected close i.year i.state , cluster(id) level(90)
xi: reg reelected closecollege closenocollege i.year i.state, cluster(id) level(90)
xi: reg reelected close closecollege i.year i.state, cluster(id) level(90)

use "Brazil mayors audit.dta", clear

* Table 3a
xi: logit broad close i.term i.regions,  cluster(id_city) level(90)
xi: logit broad closecollege closenocollege i.term i.regions,  cluster(id_city) level(90)
xi: logit broad close closecollege i.term i.regions,  cluster(id_city) level(90)

xi: logit narrow close i.term i.regions,  cluster(id_city) level(90)
xi: logit narrow closecollege closenocollege i.term i.regions,  cluster(id_city) level(90)
xi: logit narrow close closecollege i.term i.regions,  cluster(id_city) level(90)

* Table 3b
xi: reg broad college i.term i.regions female age i.party_name,  cluster(id_city) level(90)
xi: reg narrow college i.term i.regions female age i.party_name,  cluster(id_city) level(90)
xi: reg fraction_broad college i.term i.regions female age i.party_name,  cluster(id_city) level(90)
xi: reg fraction_narrow college i.term i.regions female age i.party_name,  cluster(id_city) level(90)

* Table 3c
xi: reg broad close i.term i.regions pop literacy urb income,  cluster(id_city) level(90)
xi: reg broad closecollege closenocollege i.term i.regions pop literacy urb income,  cluster(id_city) level(90)
xi: reg broad close closecollege i.term i.regions pop literacy urb income,  cluster(id_city) level(90)

xi: reg narrow close i.term i.regions pop literacy urb income,  cluster(id_city) level(90)
xi: reg narrow closecollege closenocollege i.term i.regions pop literacy urb income,  cluster(id_city) level(90)
xi: reg narrow close closecollege i.term i.regions pop literacy urb income,  cluster(id_city) level(90)

xi: reg fraction_broad close i.term i.regions pop literacy urb income,  cluster(id_city) level(90)
xi: reg fraction_broad closecollege closenocollege i.term i.regions pop literacy urb income,  cluster(id_city) level(90)
xi: reg fraction_broad close closecollege i.term i.regions pop literacy urb income,  cluster(id_city) level(90)

xi: reg fraction_narrow close i.term i.regions pop literacy urb income,  cluster(id_city) level(90)
xi: reg fraction_narrow closecollege closenocollege i.term i.regions pop literacy urb income,  cluster(id_city) level(90)
xi: reg fraction_narrow close closecollege i.term i.regions pop literacy urb income,  cluster(id_city) level(90)


