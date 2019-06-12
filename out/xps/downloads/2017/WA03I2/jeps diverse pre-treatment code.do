svyset [pweight=weight]

*** defining pre-treated groups: HC saw at least 1 headline, imm saw at least 5 headlines

gen headlines=.
replace headlines = q1_wave2_immig_1 + q1_wave2_immig_2 + q1_wave2_immig_3 + q1_wave2_immig_4 + q1_wave2_immig_5 + q1_wave2_immig_6 + q1_wave2_immig_7 if treat==1
replace headlines = q1_wave2_health_1 + q1_wave2_health_2 + q1_wave2_health_3 + q1_wave2_health_4 + q1_wave2_health_5 + q1_wave2_health_6 + q1_wave2_health_7 if treat==2

gen atleast1headline=.
replace atleast1headline=1 if headlines>=1
replace atleast1headline=0 if headlines==0

gen atleast5headlines=.
replace atleast5headlines=1 if headlines>=5
replace atleast5headlines=0 if headlines<5

gen imm_pretreat=.
replace imm_pretreat=1 if atleast5headlines==1 & treat==1
replace imm_pretreat=0 if atleast5headlines==0 & treat==1

gen hc_pretreat=.
replace hc_pretreat=1 if atleast1headline==1 & treat==2
replace hc_pretreat=0 if atleast1headline==0 & treat==2


*** TABLE 1: HC OVERALL, PRE-TREAT, NPT (also used for table A13)

svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2
svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2 & hc_pretreat==1
svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2 & hc_pretreat==0


*** TABLE 2: IMM OVERALL, PRE-TREAT, NPT (also used for table A14)

svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1
svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & imm_pretreat==1
svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & imm_pretreat==0


*** dummies for evening news coverage **

gen abc_e=0
replace abc_e=1 if enews_show_1==1
gen cbs_e=0
replace cbs_e=1 if enews_show_2==1
gen nbc_e=0
replace nbc_e=1 if enews_show_3==1
gen fox_e=0
replace fox_e=1 if enews_show_4==1
gen cnn_e=0
replace cnn_e=1 if enews_show_6==1
gen msnbc_e=0
replace msnbc_e=1 if enews_show_7==1

*** combining clarity & frames

gen recd_clear=0
replace recd_clear=1 if fox_e==1 | cbs_e==1 | abc_e==1 | cnn_e==1
replace recd_clear=. if treat==2

gen recd_unclear=0
replace recd_unclear=1 if nbc_e==1 | msnbc_e==1
replace recd_unclear=. if treat==2
replace recd_unclear=0 if recd_clear==1


 ** clear = 1, unclear = 2; anyone receiving both classified as "clear"
gen coverage_type=.
replace coverage_type=1 if recd_clear==1
replace coverage_type=2 if recd_clear==0 & recd_unclear==1


 ** one-sided imm coverage: fox, cbs; two-sided: abc, nbc, msnbc, cnn

gen imm_coverage12=.
replace imm_coverage12=1 if fox_e==1 | cbs_e==1
replace imm_coverage12=2 if abc_e==1 | nbc_e==1 | msnbc_e==1 | cnn_e==1
replace imm_coverage12=. if treat==2

gen clear_onesided=0
replace clear_onesided=1 if coverage_type==1 & imm_coverage12==1
replace clear_onesided=. if treat==2

gen clear_twosided=0
replace clear_twosided=1 if coverage_type==1 & imm_coverage12==2
replace clear_twosided=. if treat==2

gen unclear_twosided=0
replace unclear_twosided=1 if coverage_type==2 & imm_coverage12==2
replace unclear_twosided=. if treat==2


*** TABLE 3: CLEAR/NOT & ONE-SIDED/TWO-SIDED

svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_onesided==1 & imm_pretreat==1
svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_twosided==1 & imm_pretreat==1
svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & unclear_twosided==1 & imm_pretreat==1



**** APPENDIX TABLES ****

** for appx section 2 figures, see "jeps diverse pre-treatment code appxf1f2.do"


** APPX SECTION 3: % respondents by evening news channel

	svy: mean abc_e, over(treat)
	svy: mean cbs_e, over(treat)
	svy: mean nbc_e, over(treat)
	svy: mean cnn_e, over(treat)
	svy: mean fox_e, over(treat)
	svy: mean msnbc_e, over(treat)


** APPX SECTION 4: models without controls

 ** HC, no controls
	svy: reg direction R1 R2 R3 if treat==2
	svy: reg direction R1 R2 R3 if treat==2 & hc_pretreat==1
	svy: reg direction R1 R2 R3 if treat==2 & hc_pretreat==0

 ** immigration, no controls
	svy: reg direction R1 R2 R3 if treat==1
	svy: reg direction R1 R2 R3 if treat==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 if treat==1 & imm_pretreat==0


** APPX SECTION 5: models with interactions

	gen R1R2R3=.
	replace R1R2R3=0 if treat_w2==1
	replace R1R2R3=1 if treat_w2==2
	replace R1R2R3=2 if treat_w2==3
	replace R1R2R3=3 if treat_w2==4

	svy: reg direction i.R1R2R3 i.hc_pretreat R1R2R3##hc_pretreat republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2
	margins, at(hc_pretreat=(0(1)1) R1R2R3=(0,1,2,3))
	margins, dydx(R1R2R3) at(hc_pretreat=(0))
	margins, dydx(R1R2R3) at(hc_pretreat=(1))

	svy: reg direction i.R1R2R3 i.imm_pretreat R1R2R3##imm_pretreat republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1
	margins, at(imm_pretreat=(0(1)1) R1R2R3=(0,1,2,3))
	margins, dydx(R1R2R3) at(imm_pretreat=(0))
	margins, dydx(R1R2R3) at(imm_pretreat=(1))

	gen imm_coverage=.
	replace imm_coverage=1 if clear_onesided==1
	replace imm_coverage=2 if clear_twosided==1
	replace imm_coverage=3 if unclear_twosided==1

	svy: reg direction i.R1R2R3 i.imm_coverage R1R2R3##imm_coverage republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & imm_pretreat==1
	margins, dydx(R1R2R3) at(imm_coverage=(1))
	margins, dydx(R1R2R3) at(imm_coverage=(2))
	margins, dydx(R1R2R3) at(imm_coverage=(3))


** APPX SECTION 7: models with alternative thresholds 

	gen polint_highorsome=.
	replace polint_highorsome=1 if polinterest==1 | polinterest==2
	replace polint_highorsome=0 if polinterest==3 | polinterest==4

 ** table A9
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2 & polint_highorsome==1
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2 & polint_highorsome==0


 ** table A10

	gen headlines_nocourt=.
	replace headlines_nocourt = q1_wave2_health_1 + q1_wave2_health_2 + q1_wave2_health_3 + q1_wave2_health_5 + q1_wave2_health_6 + q1_wave2_health_7 if treat==2
	replace headlines_nocourt = q1_wave2_immig_1 + q1_wave2_immig_2 + q1_wave2_immig_3 + q1_wave2_immig_5 + q1_wave2_immig_6 + q1_wave2_immig_7 if treat==1

	gen headlines_nocourt_atleast1=.
	replace headlines_nocourt_atleast1=0 if headlines_nocourt==0
	replace headlines_nocourt_atleast1=1 if headlines_nocourt>=1

	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2 & headlines_nocourt_atleast1==1
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2 & headlines_nocourt_atleast1==0

 ** table A11
 
	gen headlines_atleast1notsports=.
	replace headlines_atleast1notsports=1 if q1_wave2_immig_1==1 | q1_wave2_immig_2==1 | q1_wave2_immig_4==1 | q1_wave2_immig_5==1 | q1_wave2_immig_6==1 | q1_wave2_immig_7==1
	replace headlines_atleast1notsports=0 if q1_wave2_immig_1==0 & q1_wave2_immig_2==0 & q1_wave2_immig_4==0 & q1_wave2_immig_5==0 & q1_wave2_immig_6==0 & q1_wave2_immig_7==0
	replace headlines_atleast1notsports=1 if q1_wave2_health_1==1 | q1_wave2_health_2==1 | q1_wave2_health_4==1 | q1_wave2_health_5==1 | q1_wave2_health_6==1 | q1_wave2_health_7==1
	replace headlines_atleast1notsports=0 if q1_wave2_health_1==0 & q1_wave2_health_2==0 & q1_wave2_health_4==0 & q1_wave2_health_5==0 & q1_wave2_health_6==0 & q1_wave2_health_7==0

    svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2 & headlines_atleast1notsports==1
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==2 & headlines_atleast1notsports==0

 ** table A12
 
	gen headlines_3political=.
	replace headlines_3political=0 if q1_wave2_health_1==0 | q1_wave2_immig_1==0
	replace headlines_3political=0 if q1_wave2_health_5==0 | q1_wave2_immig_5==0
	replace headlines_3political=0 if q1_wave2_health_6==0 | q1_wave2_immig_6==0
	replace headlines_3political=1 if q1_wave2_health_1==1 & q1_wave2_health_5==1 & q1_wave2_health_6==1
	replace headlines_3political=1 if q1_wave2_immig_1==1 & q1_wave2_immig_5==1 & q1_wave2_immig_6==1
 
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & headlines_3political==1
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & headlines_3political==0

	
** APPX SECTION 8: full models from main text

 ** see code for main text table 1 (A13) and table 2 (A14), above

	
** APPX SECTION 10: clear & unclear code

	gen recd_unclear_alt=0
	replace recd_unclear_alt=1 if nbc_e==1 | msnbc_e==1
	replace recd_unclear_alt=. if treat==2

	gen recd_clear_alt=0
	replace recd_clear_alt=1 if fox_e==1 | cbs_e==1 | abc_e==1 | cnn_e==1
	replace recd_clear_alt=. if treat==2
	replace recd_clear_alt=0 if recd_unclear_alt==1


	 ** clear = 1, unclear = 2; anyone receiving both classified as "unclear"
	gen coverage_type_alt=.
	replace coverage_type_alt=1 if recd_clear_alt==1 & recd_unclear_alt==0
	replace coverage_type_alt=2 if recd_unclear_alt==1

	gen clear_onesided_alt=0
	replace clear_onesided_alt=1 if coverage_type_alt==1 & imm_coverage12==1
	replace clear_onesided_alt=. if treat==2

	gen clear_twosided_alt=0
	replace clear_twosided_alt=1 if coverage_type_alt==1 & imm_coverage12==2
	replace clear_twosided_alt=. if treat==2

	gen unclear_twosided_alt=0
	replace unclear_twosided_alt=1 if coverage_type_alt==2 & imm_coverage12==2
	replace unclear_twosided_alt=. if treat==2
	
 ** table A15
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_onesided_alt==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_twosided_alt==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & unclear_twosided_alt==1 & imm_pretreat==1

 ** table A16
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & coverage_type==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & coverage_type==2 & imm_pretreat==1

 ** table A17
	svy: reg direction R1 R2 R3 localeve republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_onesided==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 localeve republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_twosided==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 localeve republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & unclear_twosided==1 & imm_pretreat==1

 ** table A18
	svy: reg direction R1 R2 R3 localnewspaper republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_onesided==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 localnewspaper republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_twosided==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 localnewspaper republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & unclear_twosided==1 & imm_pretreat==1

 ** table A19
	svy: reg direction R1 R2 R3 localnewspaper localeve republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_onesided==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 localnewspaper localeve republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & clear_twosided==1 & imm_pretreat==1
	svy: reg direction R1 R2 R3 localnewspaper localeve republican_all black hispanic male educat1 educat2 educat3 educat4 educat5 married employed age if treat==1 & unclear_twosided==1 & imm_pretreat==1


** APPX SECTION 11: reporting standards

 ** table A20 & A21

	mean black, over(treat treat_w2)
	mean hispanic, over(treat treat_w2)
	mean republican_all, over(treat treat_w2)
	mean male, over(treat treat_w2)
	mean college, over(treat treat_w2)
	mean married, over(treat treat_w2)
	mean employed, over(treat treat_w2)
	mean age, over(treat treat_w2)
	mean fox, over(treat treat_w2)
	mean high_news, over(treat treat_w2)

 
 ** table A22: see "jeps diverse pre-treatment code tablea22.do"
