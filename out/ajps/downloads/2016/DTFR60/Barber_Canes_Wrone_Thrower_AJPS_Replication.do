*Replication file for "Ideologically Sophisticated Donors: Which Candidates Do Individual Contributors Finance?" by Michael Barber, Brandice Canes-Wrone, and Sharece Thrower
cd "~/Desktop"
use "Barber_Canes_Wrone_Thrower_Replication_AJPS.dta", clear

merge m:1 donor_id using "Barber_Canes_Wrone_Thrower_Replication_AJPS_Sample_Weights_tomerge.dta", keepusing(weight)
drop _merge

****************Table 1****************
*Model 1 - All data
relogit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], cluster(donor_id)
*Model 2 - Same party donors
relogit donation peragsen cook same_state NetWorth Income idfold2 notwhite maleres YearBorn Edsum if sameparty == 1 [pweight=weight], cluster(donor_id)
*Model 3 - Not same party donors
relogit donation peragsen cook same_state NetWorth Income idfold2 notwhite maleres YearBorn Edsum if sameparty == 0 [pweight=weight], cluster(donor_id)
*Model 4 - In state donors
relogit donation peragsen cook sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if same_state == 1 [pweight=weight], cluster(donor_id)
*Model 5 - Out of state donors
relogit donation peragsen cook sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if same_state == 0 [pweight=weight], cluster(donor_id)

****************Table 2****************
*Model 1 - All data
relogit donation peragsen per2agchal cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], cluster(donor_id)
*Model 2 - Same party donors
relogit donation peragsen per2agchal cook same_state NetWorth Income idfold2 notwhite maleres YearBorn Edsum if sameparty == 1 [pweight=weight], cluster(donor_id)
*Model 3 - Not same party donors
relogit donation peragsen per2agchal cook same_state NetWorth Income idfold2 notwhite maleres YearBorn Edsum if sameparty == 0 [pweight=weight], cluster(donor_id)
*Model 4 - In state donors
relogit donation peragsen per2agchal cook sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if same_state == 1 [pweight=weight], cluster(donor_id)
*Model 5 - Out of state donors
relogit donation peragsen per2agchal cook sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if same_state == 0 [pweight=weight], cluster(donor_id)

****************Table 3****************
*Model 1 - All data
relogit donation peragsen matchcommf cook same_state sameparty majorityparty chair3 finance apps terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], cluster(donor_id)
*Model 2 - Committee Fixed Effects
relogit donation peragsen matchcommf cook same_state sameparty majorityparty chair3 finance apps terms  NetWorth Income idfold2 notwhite maleres YearBorn Edsum agriculture homeland armedservices banking commerce energy environment foreign judiciary rules budget health smallbusiness veterans indianaffairs [pweight=weight], cluster(donor_id)
*Model 3 - Investor donors
relogit donation peragsen matchcommf cook same_state sameparty majorityparty chair3 finance apps terms  NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if investor2==1, cluster(donor_id)
*Model 4 - Non-investor donors
relogit donation peragsen matchcommf cook same_state sameparty majorityparty chair3 finance apps terms  NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if investor2==0, cluster(donor_id)

****************Table 4****************
*Model 1 - low policy agreement
relogit donation peragsen matchcommf cook sameparty same_state  majorityparty chair3 finance apps terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum if peragsen<.4 [pweight=weight], cluster(donor_id)
*Model 2 - prior committee assignment
relogit donation peragsen matchcommf matchpricom cook sameparty same_state  majorityparty chair3 finance apps terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], cluster(donor_id)
*Model 3 - Time on committee
relogit donation peragsen matchcommf tavgf cook sameparty same_state  majorityparty chair3 finance apps terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum  [pweight=weight], cluster(donor_id)
*Model 4 - Contacting candidate
relogit donation peragsen matchcommf notcmatchcommf notcontact cook sameparty  majorityparty chair3 finance apps terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum  [pweight=weight], cluster(donor_id)
*Model 5 - Engery committee senators
relogit donation peragsen energymatch mismatch cook sameparty same_state  majorityparty chair3 finance terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum if energy==1 [pweight=weight], cluster(donor_id)

****************Table 5****************
*Model 1 - Zero inflated negative binomial, amount of donating binned by $50 amounts
zinb r50don peragsen matchcommf cook same_state sameparty  majorityparty chair3 finance apps terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum, inflate(peragsen matchcommf cook same_state sameparty  majorityparty chair3 finance apps terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum) vce(cluster donor_id)
*Marginal effects of Model 1
margins if total_donation>0, dydx(Income NetWorth) continuous
*Model 2 - Tobit, amount of donating binned by $50 amounts, for donations larger than $100
tobit r50don peragsen matchcommf cook same_state sameparty chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if total_donation >= 100, cluster(donor_id) ll(1) ul(101)
*Model 3 - Tobit, amount of donating binned by $50 amounts, for donations of all sizes and non-donors
tobit r50don peragsen matchcommf cook same_state sameparty  majorityparty chair3 finance apps terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], cluster(donor_id) ll(0) ul(101)

