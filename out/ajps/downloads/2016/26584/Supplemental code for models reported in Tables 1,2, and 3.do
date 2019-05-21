************ AJPS - "False Consciousness" Models(Last updated on 1/19/16 by Chris Johnston) ************

******** All models below were run using the indicated data from the AJPS dataverse 		   ********
******** in 64-bit Stata/MP 12.1 (4 cores) on a PC running Windows 10 with an Intel Core 	   ********
******** i7-4790 CPU @ 3.60 GHz and 8 GB of RAM. The log files for these runs are posted at    ********
******** the AJPS dataverse.																   ********

***** Data: Meritocracy Replication Data - Table 1 (for Table 1 - Whites Only) *****

** Model reported in paper: Logit model w/ random intercept & random slope **

xtmelogit meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==1 || fips: income_i, cov(unstruct)

** Alternative specifications **

* Linear probability model w/clustered ses *

reg meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==1, cluster(fips)

* Logit model w/ clustered ses *

logit meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==1, cluster(fips)

* Linear probability model w/ random intercept *

xtmixed meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==1 || fips: , 

* Logit model w/ random intercept *

xtmelogit meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==1 || fips: , 

* Linear probability model w/ random intercept & random slope *

xtmixed meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==1 || fips: income_i, cov(unstruct)
	

***** Data: Meritocracy Replication Data - Table 1 (for Table 1 - Non-Whites) *****
***** Note: there was a mistake in the reporting of this model. The table 	  *****
***** in the original paper states that the estimated model was a logit, but  ***** 
***** the estimates were from a linear probability model. See the erratum for *****
***** the relevant correction.											      *****

** Model reported in corrected paper: Logit model w/ random intercept & random slope **

xtmelogit meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==0 || fips: income_i, cov(unstruct)	

** Alternative specifications **

* Linear probability model w/clustered ses *

reg meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==0, cluster(fips)

* Logit model w/ clustered ses *

logit meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==0, cluster(fips)

* Linear probability model w/ random intercept *

xtmixed meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==0 || fips: , 

* Logit model w/ random intercept *

xtmelogit meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==0 || fips: , 

* Linear probability model w/ random intercept & random slope (no convergence w/ unstructured random effects) *

xtmixed meritocracy ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	survid2006 survid2007 survid2009 if white==0 || fips: income_i, 

	
***** Data: Meritocracy Replication Data - Table 2 (for Table 2) *****

** Model reported in paper: Logit model w/ random intercept **

xtmelogit divided ginicnty05_09_01 medhinc0610cnty_01 pctblk0610cnty_01 totpop0610cnty_01 pbush_01 ///
	income_i_01  Age gender education_01 partyid_01 ideology_01 religattend_01 union unemployed ///
	if white==1 || fips: ,

** Alternative specifications **

* Linear probability model w/ clustered ses *

reg divided ginicnty05_09_01 medhinc0610cnty_01 pctblk0610cnty_01 totpop0610cnty_01 pbush_01 ///
	income_i_01  Age gender education_01 partyid_01 ideology_01 religattend_01 union unemployed if white==1, cluster(fips)

* Logit model w/ clustered ses *

logit divided ginicnty05_09_01 medhinc0610cnty_01 pctblk0610cnty_01 totpop0610cnty_01 pbush_01 ///
	income_i_01  Age gender education_01 partyid_01 ideology_01 religattend_01 union unemployed if white==1, cluster(fips)	
	
* Linear probability model w/ random intercept *

xtmixed divided ginicnty05_09_01 medhinc0610cnty_01 pctblk0610cnty_01 totpop0610cnty_01 pbush_01 ///
	income_i_01  Age gender education_01 partyid_01 ideology_01 religattend_01 union unemployed ///
	if white==1 || fips: ,


***** Data: Meritocracy Replication Data - Table 3 (for Table 3) *****

** Model reported in paper: Logit model w/ random intercept & random slope **

xtmelogit havenot2 ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	if white==1 || fips: income_i , cov(unstruct)

** Alternative specifications **

* Linear probability model w/clustered ses *

reg havenot2 ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	if white==1, cluster(fips)

* Logit model w/clustered ses *

logit havenot2 ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	if white==1, cluster(fips)

* Linear probability model w/ random intercept *

xtmixed havenot2 ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	if white==1 || fips: ,

* Logit model w/ random intercept *

xtmelogit havenot2 ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	if white==1 || fips: ,

* Linear probability model w/ random intercept & random slope *

xtmixed havenot2 ginicnty income_i ginicntyXincome_i ///
	income_cnty black_cnty perc_bush04 pop_cnty educ_i age_i gender_i unemp_i union_i partyid_i ideo_i attend_i ///
	if white==1 || fips: income_i , cov(unstruct)














































