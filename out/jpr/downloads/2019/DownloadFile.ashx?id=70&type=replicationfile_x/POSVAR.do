**STATA/SE 15.1**
use "POSVAR_clean.dta"

**TABLE II**
sum govagainstref civagainstref civagainstref_ind civagainstref_group nsaagainstref ///
refagainstgov refagainstgov_ind refagainstgov_group refagainstciv refagainstciv_ind ///
refagainstciv_group  refonref refonref_ind refonref_group 

**TABLE III**
gen govagainstrefd=0
replace govagainstrefd=1 if govagainstref>0

gen  civagainstrefd=0
replace civagainstrefd=1 if civagainstref>0

gen civagainstrefindd =0
replace civagainstrefindd=1 if civagainstref_ind>0

gen civagainstrefgroupd =0
replace civagainstrefgroupd=1 if civagainstref_group>0

gen groupagainstrefd =0
replace groupagainstrefd=1 if nsaagainstref>0

gen againststated =0
replace againststated=1 if refagainstgov>0

gen againststateindd =0
replace againststateindd=1 if refagainstgov_ind>0

gen againststategroupd =0
replace againststategroupd=1 if refagainstgov_group>0

gen againstcivd =0
replace againstcivd=1 if refagainstciv>0

gen againstcivindd =0
replace againstcivindd=1 if refagainstciv_ind>0

gen againstcivgroupd  =0
replace againstcivgroupd=1 if refagainstciv_group>0

gen refonrefd =0
replace refonrefd=1 if refonref>0

gen refonrefindd =0
replace refonrefindd=1 if refonref_ind>0

gen refonrefgroupd =0
replace refonrefgroupd=1 if refonref_group>0

sum govagainstrefd civagainstrefd civagainstrefindd civagainstrefgroupd groupagainstrefd ///
againststated againststateindd againststategroupd againstcivd  againstcivindd ///
againstcivgroupd  refonrefd  refonrefindd  refonrefgroupd 

**TABLE IV**
sum terroragainstref terrorbyref nsarecruitref

gen armedgrouprecruitd=0
replace armedgrouprecruitd=1 if nsarecruitref>0
sum armedgrouprecruitd

gen riotd=0
replace riotd=1 if refriot>0
sum riotd

**TABLE V**
replace nsarecruitref=1 if nsarecruitref==2
replace nsarecruitref=1 if nsarecruitref==3

logit civilconflictbin nsarecruitref democracy civilconflictneighbor lngdp
logit civilconflictbin nsarecruitref percentrefpop  democracy civilconflictneighbor lngdp

