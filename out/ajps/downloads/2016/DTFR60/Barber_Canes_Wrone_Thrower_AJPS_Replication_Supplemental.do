*Replication file for "Ideologically Sophisticated Donors: Which Candidates Do Individual Contributors Finance?" by Michael Barber, Brandice Canes-Wrone, and Sharece Thrower
cd "~/Desktop"
**********************************************

use "Barber_Canes_Wrone_Thrower_Replication_AJPS_Supplemental.dta", clear

merge m:1 donor_id using "Barber_Canes_Wrone_Thrower_Replication_AJPS_Sample_Weights_tomerge.dta", keepusing(weight)
drop _merge

*Supp Table A1 - descriptive statistics
sum donation peragsen if peragsen!=.

sum cook same_state sameparty if donation!=. & peragsen!=. & cook!=. & same_state!=. & sameparty!=. & NetWorth!=. & Income!=. & idfold!=. & notwhite!=. & maleres!=. & Edsum!=. & YearBorn!=. 

sum matchcommf chair3 finance apps majorityparty terms if matchcommf!=. & majorityparty!=. & chair3!=. & finance!=. & apps!=. & terms!=. & donation!=. & peragsen!=. & cook!=. & same_state!=. & sameparty!=. & NetWorth!=. & Income!=. & idfold!=. & notwhite!=. & maleres!=. & Edsum!=. & YearBorn!=. 

sum investor2 ideologue2 IK2 if donation!=. & peragsen!=. & cook!=. & same_state!=. & sameparty!=. & NetWorth!=. & Income!=. & idfold!=. & notwhite!=. & maleres!=. & Edsum!=. & YearBorn!=. 

sum NetWorth Income idfold2 notwhite malerespondent Edsum if donation!=. & peragsen!=. & cook!=. & same_state!=. & sameparty!=. & NetWorth!=. & Income!=. & idfold!=. & notwhite!=. & maleres!=. & Edsum!=. & YearBorn!=. 

****************************************
*Supp Table A2

tab same_state if donation == 1
tab sameparty if donation == 1
tab matchcommf if donation == 1

****************************************
*Supp Table A3

tab same_state sameparty if donation == 1, cell
tab matchcommf sameparty if donation == 1, cell
tab matchcommf same_state if donation == 1, cell

****************************************
*Supp Table A4

*no controls
relogit donation peragsen [pweight=weight], cluster(donor_id)
*unweighted
relogit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum, cluster(donor_id)
*regular logit
logit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum, cluster(donor_id)
*separate subgroups from survey
*st=1 is in-state donors  
relogit donation peragsen cook sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if st==1  [pweight=weight], cluster(donor_id)
*st=2 is in-state non-donors
relogit donation peragsen cook sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if st==2  [pweight=weight], cluster(donor_id)
*st=3 is out-of-state donors
relogit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if st==3  [pweight=weight], cluster(donor_id)

****************************************
*Supp Table A5

*in-state, in-party
relogit donation peragsen cook NetWorth Income idfold2 notwhite maleres YearBorn Edsum if sameparty==1 & same_state==1 [pweight=weight], cluster(donor_id)
*joint difference for in- versus out-party
relogit donation peragsen samepartyper sameparty same_state cook NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], cluster(donor_id)
*joint difference for in- versus out-of-state
relogit donation peragsen samestateper sameparty same_state cook NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], cluster(donor_id)
*fixed effect for Senators
relogit donation peragsen sameparty same_state NetWorth Income idfold2 notwhite maleres YearBorn Edsum sendum1-sendum21 [pweight=weight], cluster(donor_id)
*strong partisans
relogit donation peragsen sameparty same_state cook NetWorth Income idfold2 notwhite maleres YearBorn Edsum if DemocratStrength==1 | RepublicanStrength==1  [pweight=weight], cluster(donor_id)
*not self-reported ideologue
relogit donation peragsen sameparty same_state cook NetWorth Income idfold2 notwhite maleres YearBorn Edsum if ideologue2==0  [pweight=weight], cluster(donor_id)

****************************************
*Supp Table A6

*maximum donation of $200
relogit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if maxdon<201, cluster(donor_id)
*donation above $200
relogit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if maxdon>200 & maxdon!=., cluster(donor_id)
*above $2000
relogit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if maxdon>2000 & maxdon!=., cluster(donor_id)
*now based on total donations to all candidates in cycle
relogit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if total_donation_all>20000 & total_donation_all!=. [pweight=weight], cluster(donor_id)
*1 Senator only
relogit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if numsens==1  [pweight=weight], cluster(donor_id)
*At least 10 donations 
relogit donation peragsen cook same_state sameparty NetWorth Income idfold2 notwhite maleres YearBorn Edsum if numdonation>9 & numdonation!=. [pweight=weight], cluster(donor_id)

****************************************
*Supp Table A7
*fixed effects by Senator
relogit donation peragsen sameparty same_state matchcommf NetWorth Income idfold2 notwhite maleres YearBorn Edsum sendum1-sendum21 [pweight=weight], cluster(donor_id)
*unweighted
relogit donation peragsen sameparty same_state cook matchcommf chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum, cluster(donor_id)
*not self-reported investor, joint model
relogit donation peragsen sameparty same_state cook inv2match notinv2match investor2 chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], cluster(donor_id)
*excluding donors currently not employed
relogit donation peragsen sameparty same_state cook matchcommf chair3 finance apps majorityparty terms  NetWorth Income idfold2 notwhite maleres YearBorn Edsum if Emsum==1 [pweight=weight], cluster(donor_id)
*just cook==3 & cook==4, to look at effect of terms for more competitive races
relogit donation peragsen sameparty matchcommf chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum same_state if (cook==3 | cook==4) [pweight=weight], cluster(donor_id)

****************************************
*Supp Table A8 - Excludes different category in each column*
relogit donation peragsen matchcommf cook same_state sameparty majorityparty  terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if banking==0, cluster(donor_id)

relogit donation peragsen matchcommf cook same_state sameparty majorityparty  terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if commerce==0, cluster(donor_id)

relogit donation peragsen matchcommf cook same_state sameparty majorityparty  terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if health==0, cluster(donor_id)

relogit donation peragsen matchcommf cook same_state sameparty majorityparty  terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum[pweight=weight] if judiciary==0, cluster(donor_id)

relogit donation peragsen matchcommf cook same_state sameparty majorityparty  terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if finance==0, cluster(donor_id)

relogit donation peragsen matchcommf cook same_state sameparty majorityparty  terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if apps==0, cluster(donor_id)

****************************************
*Supp Table A9  

*tobit set to $200, rather than $100 minimum
tobit r50don peragsen sameparty same_state cook  matchcommf  chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight] if total_donation>0, cluster(donor_id) ll(5) ul(101)

*Zero inflated negative binomial
zinb total_donation peragsen sameparty same_state cook matchcommf chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], inflate(peragsen sameparty same_state cook matchcommf chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum ) vce(cluster donor_id) zip 

*ordinal ranking at $100 ranges
zinb r100don peragsen sameparty same_state cook matchcommf chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], inflate(peragsen sameparty same_state cook matchcommf chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum ) vce(cluster donor_id) zip 

*ordinal ranking at $500 range
zinb ramount500 peragsen sameparty same_state cook matchcommf chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum [pweight=weight], inflate(peragsen sameparty same_state cook matchcommf chair3 finance apps majorityparty terms NetWorth Income idfold2 notwhite maleres YearBorn Edsum ) vce(cluster donor_id) zip 

****************************************
*Supp Table A10 
probit gave_obama peragobama idfold2 NetWorth Income notwhite maleres YearBorn Edsum, cluster(donor_id)











