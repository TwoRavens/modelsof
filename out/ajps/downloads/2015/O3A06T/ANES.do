**********************************
*** AJPS ANES Replication File *** 
**********************************

*** Miller, Saunders, & Farhart, 2015 ***
*** Conspiracy Endorsement as Motivated Reasoning: The Moderating Roles of Political Knowledge and Trust ***

* use "/ANES.dta"

* Run MTurk.do first
* Run ANES.do second

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
* The following variable transformations and analyses were carried out using Stata/SE 14.
* However, the datasets have been saved in Stata 12 format for Dataverse. 
* All commands used to transform the variables are included below, but are commented out.
* All variables reflected in MTurk.dta and ANES.dta have been created.
* ANES analyses begin on line 827.
* In order to create tables and figures, this do-file and ANES.do need to be run together, 
* as the analyses within the do-files have been separated by respective datasets.
* The 2012 ANES Time Series data was the original dataset "anes_timeseries_2012.dta" downloaded from ANES Data Center: 
* http://www.electionstudies.org/studypages/download/datacenter_all_NoData.php 
****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

*******************
*******************
*******************
*** Data Subset ***
*******************
*******************
*******************

* After the variables were transformed from the original ANES 2012 dataset, only the variables used in the analyses were kept.

	* keep caseid mode ///
	* libmodcon libcpre_self liberal conservative consvlib ///
	* pid_x pid6_alt pid6 ///
	* knowmed preknow_medicare ///
	* knowspend preknow_leastsp ///
	* prestimes preknow_prestimes ///
	* senterm preknow_senterm ///
	* speaker ofcrec_speaker_correct ///
	* vp ofcrec_vp_correct ///
	* pmuk ofcrec_pmuk_correct ///
	* cj ofcrec_cj_correct ///
	* housemaj knowl_housemaj ///
	* senmaj knowl_senmaj ///
	* totalknow totalknow_alt totalknow_hl ///
	* trustsocial trust_social trustsocialz ///
	* trustgov5 trustgov_trustgrev trustgov5z ///
	* trustgov3 trustgov_trustgstd trustgov3z ///
	* trustgovz totaltrustz trustspz totaltrustz_alt totaltrustz_hl ///
	* tipi_extra tipiextra tipi_resv tipiresv tipiresv2 extraversion ///
	* tipi_warm tipiwarm tipicrit2 tipi_crit tipicrit agreeableness ///
	* tipi_dep tipidep tipidisorg2 tipi_disorg tipidisorg conscientious ///
	* tipi_calm tipicalm tipianx2 tipi_anx tipianx emotstab ///
	* tipi_open tipiopen tipiconv2 tipi_conv tipiconv openness ///
	* authconsid auth_consid authobed auth_obed authcur auth_cur authind auth_ind auth ///
	* effic_carerev2 effic_carerev effic_carestd2 effic_carestd care ///
	* effic_sayrev2 effic_sayrev effic_saystd2 effic_saystd nosay ///
	* efficacy ///
	* needeval cog_opin_x ///
	* ideoextrem libcpre_self ///
	* gov_therm govtherm ftgr_fedgov ///
	* relig relig_import ///
	* educ dem_edugroup_x ///
	* income inc_incgroup_pre ///
	* female gender_respondent_x ///
	* Age age dem_age_r_x ///
	* latino dem_hisp ///
	* white dem_raceeth_x ///
	* bornus nonmain_born ///
	* deathpanel nonmain_endlife ///
	* govt911 nonmain_govt911 ///
	* katrina nonmain_hurric ///
	* conservindex libindex  ///
	* neglibindex weight_full randsplice_revisedstandard 

	* aorder

********************************
********************************
********************************
*** Variable Transformations ***
********************************
********************************
********************************

******************************
*** Unique Case Identifier ***
******************************
* The dataset includes the original ANES 2012 unique case identifiers
	* tab caseid

************
*** Mode ***
************
* The dataset includes the original ANES 2012 mode variable
* 1=ftf mode; 2=internet mode
* Analyses below reflect internet mode only
	* tab mode

*****************************
*****************************
*** Explanatory Variables ***
*****************************
*****************************

**************************
*** Conservative Dummy ***
**************************
* Analyses below are run with "consvlib" conservative dummy variable (Conservative = 1; Liberal = 0) 
* ideo3
	* gen libmodcon = .
	* replace libmodcon=1 if libcpre_self==1
	* replace libmodcon=1 if libcpre_self==2
	* replace libmodcon=1 if libcpre_self==3
	* replace libmodcon=2 if libcpre_self==4
	* replace libmodcon=3 if libcpre_self==5
	* replace libmodcon=3 if libcpre_self==6
	* replace libmodcon=3 if libcpre_self==7
	* tab libmodcon
	* label var libmodcon "Political Ideology (3 Categories)"
	* label define libmodconl 1 "Liberal" 2 "Moderate" 3 "Conservative"
	* label value libmodcon libmodconl

	* gen liberal = .
	* replace liberal=1 if libmodcon==1
	* replace liberal=0 if libmodcon==2
	* replace liberal=0 if libmodcon==3
	* tab liberal
	* label var liberal "Liberal Dummy with Moderates"
	* label define liberall 0 "Not Liberal" 1 "Liberal" 
	* label value liberal liberall 

	* gen conservative = .
	* replace conservative=1 if libmodcon==3
	* replace conservative=0 if libmodcon==2
	* replace conservative=0 if libmodcon==1	
	* tab conservative
	* label var conservative "Conservative Dummy with Moderates"
	* label define conservativel 0 "Not Conservative" 1 "Conservative" 
	* label value conservative conservativel 

* Dummy variable for only conservatives and liberals used in analyses below
	* gen consvlib = .
	* replace consvlib=1 if conservative==1
	* replace consvlib=0 if liberal==1
	* tab consvlib 
	* label define consvlibl 0 "Liberal" 1 "Conservative" 
	* label value consvlib consvlibl 
	* label var consvlib "Conservative Dummy without Moderates"
	* label define consvlibL 0 "Liberal" 1 "Conservative" 
	* label value consvlib consvlibL 

****************************
*** Party Identification ***
****************************
* The following commands are used to generate a 6 category party identification, removing independents
* "pid6" is the party identification variable used for analyses appearing in the Online Appendix Tables 4 and 5
	* recode pid_x (-2=.) (1=1 "Strong Democrat") (2=2 "Weak Democrat") (3=3 "Lean Democrat") (4=.) (5=4 "Lean Republican") (6=5 "Weak Republican") (7=6 "Strong Republican"), generate (pid6_alt)
	* gen pid6 = (pid6_alt-1)/5
	* tab pid6
	* sum pid6, d
	* label var pid6 "Party ID - No Independents (0-1 Recode of pid6_alt)"
	* label var pid6_alt "RECODE of pid_x (PRE: SUMMARY - Party ID)"

*********************************
*** Political Knowledge Index ***
*********************************
* Political knowledge index - recoded each into 0 (wrong) vs. 1 (correct), then averaged them using the row average
* 10-item index

	* gen knowmed = .
	* replace knowmed=1 if preknow_medicare==1
	* replace knowmed=0 if preknow_medicare==-9
	* replace knowmed=0 if preknow_medicare==-2
	* replace knowmed=0 if preknow_medicare==2
	* replace knowmed=0 if preknow_medicare==3
	* replace knowmed=0 if preknow_medicare==4
	* tab knowmed 
	* label var knowmed "0-1 Dummy Recode of preknow_medicare: What is Medicare"
	* label define knowmedl 0 "Not Correct" 1 "Correct" 
	* label value knowmed knowmedl 

	* gen knowspend = .
	* replace knowspend=1 if preknow_leastsp==1
	* replace knowspend=0 if preknow_leastsp==-9
	* replace knowspend=0 if preknow_leastsp==-2
	* replace knowspend=0 if preknow_leastsp==2
	* replace knowspend=0 if preknow_leastsp==3
	* replace knowspend=0 if preknow_leastsp==4
	* tab knowspend 
	* label var knowspend "0-1 Dummy Recode of preknow_leastsp: Pgm Fed govt spends least"
	* label define knowspendl 0 "Not Correct" 1 "Correct" 
	* label value knowspend knowspendl 

	* gen prestimes = .
	* replace prestimes=1 if preknow_prestimes==2
	* replace prestimes=0 if preknow_prestimes==-9
	* replace prestimes=0 if preknow_prestimes==-2
	* replace prestimes=0 if preknow_prestimes==0
	* replace prestimes=0 if preknow_prestimes==1
	* replace prestimes=0 if preknow_prestimes==3
	* replace prestimes=0 if preknow_prestimes==4
	* replace prestimes=0 if preknow_prestimes==5
	* replace prestimes=0 if preknow_prestimes==6
	* replace prestimes=0 if preknow_prestimes==7
	* replace prestimes=0 if preknow_prestimes==8
	* replace prestimes=0 if preknow_prestimes==9
	* replace prestimes=0 if preknow_prestimes==10
	* replace prestimes=0 if preknow_prestimes==12
	* replace prestimes=0 if preknow_prestimes==15
	* tab prestimes 
	* label var prestimes "0-1 Dummy Recode of preknow_prestimes: Number of times pres can be elected"
	* label define prestimesl 0 "Not Correct" 1 "Correct" 
	* label value prestimes prestimesl 

	* gen senterm = .
	* replace senterm=1 if preknow_senterm==6
	* replace senterm=0 if preknow_senterm<=5
	* replace senterm=0 if preknow_senterm==5
	* replace senterm=0 if preknow_senterm==7
	* replace senterm=0 if preknow_senterm>=7
	* tab senterm 
	* label var senterm "0-1 Dummy Recode of preknow_senterm: Years senators elected"
	* label define senterml 0 "Not Correct" 1 "Correct" 
	* label value senterm senterml 

	* gen speaker = .
	* replace speaker=1 if ofcrec_speaker_correct==1
	* replace speaker=0 if ofcrec_speaker_correct==0
	* tab speaker 
	* label var speaker "0-1 Dummy Recode of ofcrec_speaker_correct: Correct for Speaker of the House Boehner"
	* label define speakerl 0 "Not Correct" 1 "Correct" 
	* label value speaker speakerl 

	* gen vp = .
	* replace vp=1 if ofcrec_vp_correct==1
	* replace vp=0 if ofcrec_vp_correct==0
	* tab vp 
	* label var vp "0-1 Recode of ofcrec_vp_correct: Correct for Vice Pres Biden "
	* label define vpl 0 "Not Correct" 1 "Correct" 
	* label value vp vpl 
 
	* gen pmuk = .
	* replace pmuk=1 if ofcrec_pmuk_correct==1
	* replace pmuk=0 if ofcrec_pmuk_correct==0
	* tab pmuk 
	* label var pmuk "0-1 Dummy Recode of ofcrec_pmuk_correct: Correct for PM of UK Cameron"
	* label define pmukl 0 "Not Correct" 1 "Correct" 
	* label value pmuk pmukl 

	* gen cj = .
	* replace cj=1 if ofcrec_cj_correct==1
	* replace cj=1 if ofcrec_cj_correct==.5
	* replace cj=0 if ofcrec_cj_correct==0
	* tab cj
	* label var cj "0-1 Dummy Recode of ofcrec_cj_correct: Correct Supreme Ct. Justice Roberts"
	* label define cjl 0 "Not Correct" 1 "Correct" 
	* label value cj cjl 

	* gen housemaj = .
	* replace housemaj=1 if knowl_housemaj==2
	* replace housemaj=0 if knowl_housemaj==-9
	* replace housemaj=0 if knowl_housemaj==-8
	* replace housemaj=0 if knowl_housemaj==1
	* tab housemaj 
	* label var housemaj "0-1 Dummy Recode of knowl_housemaj: Pty w/ most members in House before election"
	* label define housemajl 0 "Not Correct" 1 "Correct" 
	* label value housemaj housemajl

	* gen senmaj = .
	* replace senmaj=1 if knowl_senmaj==1
	* replace senmaj=0 if knowl_senmaj==-9
	* replace senmaj=0 if knowl_senmaj==-8
	* replace senmaj=0 if knowl_senmaj==2
	* tab senmaj 
	* label var senmaj "0-1 Dummy Recode of knowl_senmaj: Pty w/ most members in Senate before election"
	* label define senmajl 0 "Not Correct" 1 "Correct" 
	* label value senmaj senmajl 

* "totalknow" is the political knowledge index used in the analyses below
	* egen totalknow = rowmean(knowmed knowspend prestimes senterm speaker vp pmuk cj housemaj senmaj)
	* tab totalknow 
	* label var totalknow "0-1 Political Knowledge Index (Avg of 10 pol knowledge items)"

* The following code is used to create the high/low knowledge split used in Appendix C
* Appendix C analyses are included below
	* tab totalknow if mode == 2 [aw=weight_full]
	* gen totalknow_alt = totalknow if mode == 2
	* tab totalknow_alt [aw=weight_full]
	* label var totalknow_alt "Recode of totalknow for Internet Mode Only"

	* recode totalknow_alt (.59/1=1 "High") (0/.51=0 "Low") (.=.), generate(totalknow_hl)
	* tab totalknow_hl if mode==2 [aw=weight_full]
	* label var totalknow_hl "High/Low Split for Political Knowledge: Recode of totalknow_alt"

***********************
*** Trust Questions ***
***********************
* The following commands were used to generate the standardized "totaltrustz" index used in the analyses below. 
* The trust index is the only variable not placed on a 0-1 scale within the analyses below.

	* gen trustsocial = .
	* replace trustsocial=1 if trust_social==1
	* replace trustsocial=.75 if trust_social==2
	* replace trustsocial=.50 if trust_social==3
	* replace trustsocial=.25 if trust_social==4
	* replace trustsocial= 0 if trust_social==5
	* tab trustsocial 
	* label var trustsocial "0-1 Reverse Code of trust_social: How often can people be trusted"

	* egen trustsocialz=std(trustsocial) 
	* tab trustsocialz
	
	* gen trustgov5 = .
	* replace trustgov5=1 if trustgov_trustgrev==1
	* replace trustgov5=.75 if trustgov_trustgrev==2
	* replace trustgov5=.50 if trustgov_trustgrev==3
	* replace trustgov5=.25 if trustgov_trustgrev==4
	* replace trustgov5= 0 if trustgov_trustgrev==5
	* tab trustgov5 
	* label var trustgov5 "0-1 Recode of trustgov_trustgrev: How often trust govt in Washington to do what is right"

	* egen trustgov5z=std(trustgov5)
	* tab trustgov5z

	* gen trustgov3 = .
	* replace trustgov3=1 if trustgov_trustgstd==1
	* replace trustgov3=.66 if trustgov_trustgstd==2
	* replace trustgov3=.33 if trustgov_trustgstd==3
	* replace trustgov3=0 if trustgov_trustgstd==4
	* tab trustgov3 
	* label var trustgov3 "0-1 Recode of trustgov_trustgstd: How often trust govt in Washington to do what is right"

	* egen trustgov3z=std(trustgov3)
	* tab trustgov3z 

	* gen trustgovz = .
	* replace trustgovz = trustgov5z if randsplice_revisedstandard == 1
	* replace trustgovz = trustgov3z if randsplice_revisedstandard == 2
	* tab trustgovz
	* label var trustgovz "Comb trustgov5z & trustgov3z for totaltrustz (using randsplice_revisedstandard)"

* "totaltrustz" is the continuous generalized trust index used in the analyses below
	* gen totaltrustz = (trustgovz + trustsocialz)/2
	* tab totaltrustz
	* label var totaltrustz "Generalized Trust Index (Avg of trustgovz & trustsocialz)"

* The following code is used to create the high/low knowledge split used in graphing
	* gen trustspz = .
	* replace trustspz=0 if totaltrustz<=0
	* replace trustspz=1 if totaltrustz>=0
	* tab trustspz
	* label var trustspz "0-1 High/Low Trust Split (Recode of totaltrustz)"
	* label define trustspzl 0 "Low" 1 "High" 
	* label value trustspz trustspzl 

* The following code is used to create the high/low trust split used in Appendix C
	* tab totaltrustz if mode == 2 [aw=weight_full]
	* gen totaltrustz_alt = totaltrustz if mode == 2
	* tab totaltrustz_alt [aw=weight_full]
	* label var totaltrustz_alt "Recode of totaltrustz for Internet Mode Only"

	* recode totaltrustz_alt (.1713793/2.715207=1 "High") (-1.88187/-.1451830=0 "Low") (.=.), generate(totaltrustz_hl)
	* tab totaltrustz_hl if mode==2 [aw=weight_full]
	* label var totaltrustz_hl "High/Low Split for Generalized Trust: Recode of totaltrustz_alt"

************
*** TIPI ***
************
* To change values for missing data before transforming the TIPI variables:
	* recode tipi_resv (-6=.) (-7=.) (-9=.)
	* recode tipi_extra (-6=.) (-7=.) (-9=.)
	* recode tipi_warm (-6=.) (-7=.) (-9=.)
	* recode tipi_crit (-6=.) (-7=.) (-9=.)
	* recode tipi_dep (-6=.) (-7=.) (-9=.)
	* recode tipi_disorg (-6=.) (-7=.) (-9=.)
	* recode tipi_anx (-6=.) (-7=.) (-9=.)
	* recode tipi_calm (-6=.) (-7=.) (-9=.)
	* recode tipi_open (-6=.) (-7=.) (-9=.)
	* recode tipi_conv (-6=.) (-7=.) (-9=.)
	
* Extraversion
	* gen tipiextra = (tipi_extra - 1)/6
	* tab tipi_extra tipiextra
	
	* gen tipiresv2 = tipi_resv
	* recode tipiresv2 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1)
	* gen tipiresv = (tipiresv2 - 1)/6
	* tab tipi_resv tipiresv

	* gen extraversion = (tipiresv + tipiextra)/2
	* tab extraversion

* Agreeableness
	* gen tipiwarm = (tipi_warm - 1)/6
	* tab tipi_warm tipiwarm

	* gen tipicrit2 = tipi_crit
	* recode tipicrit2 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1)
	* gen tipicrit = (tipicrit2 - 1)/6
	* tab tipi_crit tipicrit

	* gen agreeableness = (tipiwarm + tipicrit)/2
	* tab agreeableness

* Conscientiousness
	* gen tipidep = (tipi_dep - 1)/6
	* tab tipi_dep tipidep

	* gen tipidisorg2 = tipi_disorg
	* recode tipidisorg2 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1)
	* gen tipidisorg = (tipidisorg2 - 1)/6
	* tab tipi_disorg tipidisorg

	* gen conscientious = (tipidep + tipidisorg)/2
	* tab conscientious

* Emotional Stability
	* gen tipicalm = (tipi_calm - 1)/6
	* tab tipi_calm tipicalm

	* gen tipianx2 = tipi_anx
	* recode tipianx2 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1)
	* gen tipianx = (tipianx2 - 1)/6
	* tab tipi_anx tipianx

	* gen emotstab = (tipicalm + tipianx)/2
	* tab emotstab

* Openness
	* gen tipiopen = (tipi_open - 1)/6
	* tab tipi_open tipiopen

	* gen tipiconv2 = tipi_conv
	* recode tipiconv2 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1)
	* gen tipiconv = (tipiconv2 - 1)/6
	* tab tipi_conv tipiconv

	* gen openness = (tipiopen + tipiconv)/2
	* tab openness

	* label var tipianx "0-1 Recode of tipianx2: TIPI anxious, easily upset"

	* label var tipianx2 "Reverse Code of tipi_anx: TIPI anxious, easily upset"
	* label define tipianx2l 1 "Extremely well " 2 "Somewhat well" 3 "A little well" 4 "Neither poorly nor well" 5 "A little poorly" 6 "Somewhat poorly" 7 "Extremely poorly"
	* label value tipianx2 tipianx2l 	
	
	* label var tipicalm "0-1 Recode of tipi_calm: TIPI calm, emotionally stable"

	* label var tipiconv "0-1 Recode of tipiconv2: TIPI conventional, uncreative"
	
	* label var tipiconv2 "Reverse Code of tipi_conv: TIPI conventional, uncreative"
	* label define tipiconv2l 1 "Extremely well " 2 "Somewhat well" 3 "A little well" 4 "Neither poorly nor well" 5 "A little poorly" 6 "Somewhat poorly" 7 "Extremely poorly"
	* label value tipiconv2 tipiconv2l 
	
	* label var tipicrit "0-1 Recode of tipicrit2: TIPI critical, quarrelsome"

	* label var tipicrit2 "Reverse Code of tipi_crit: TIPI critical, quarrelsome"
	* label define tipicrit2l 1 "Extremely well " 2 "Somewhat well" 3 "A little well" 4 "Neither poorly nor well" 5 "A little poorly" 6 "Somewhat poorly" 7 "Extremely poorly"
	* label value tipicrit2 tipicrit2l 

	* label var tipidep "0-1 Recode of tipi_dep: TIPI dependable, self-disciplined"

	* label var tipidisorg "0-1 Recode of tipidisorg2: TIPI disorganized, careless"

	* label var tipidisorg2 "Reverse Code of tipi_disorg: TIPI disorganized, careless"
	* label define tipidisorg2l 1 "Extremely well " 2 "Somewhat well" 3 "A little well" 4 "Neither poorly nor well" 5 "A little poorly" 6 "Somewhat poorly" 7 "Extremely poorly"
	* label value tipidisorg2 tipidisorg2l
	
	* label var tipiextra "0-1 Recode of tipi_extra: TIPI extraverted, enthusiastic"

	* label var tipiopen "0-1 Recode of tipi_open: TIPI open to new experiences"

	* label var tipiresv "0-1 Recode of tipiresv2: TIPI reserved, quiet"

	* label var tipiresv2 "Reverse Code of tipi_resv: TIPI reserved, quiet"
	* label define tipiresv2l 1 "Extremely well " 2 "Somewhat well" 3 "A little well" 4 "Neither poorly nor well" 5 "A little poorly" 6 "Somewhat poorly" 7 "Extremely poorly"
	* label value tipiresv2 tipiresv2l 
	
	* label var tipiwarm "0-1 Recode of tipi_warm: TIPI sympathetic, warm"
	
	* label var extraversion "TIPI Extraversion 0-1 (Avg of tipiresv & tipiextra)"
	* label var agreeableness "TIPI Agreeableness 0-1 (Avg of tipiwarm & tipicrit)"
	* label var conscientious "TIPI Conscientiousness 0-1 (Avg of tipidep & tipidisorg)"
	* label var emotstab "TIPI Emotional Stability 0-1 (Avg of tipicalm & tipianx)"
	* label var openness "TIPI Openness 0-1 (Avg of tipiopen & tipiconv)"

* Analyses below include all 5 TIPI variables: 
* extraversion 
* agreeableness 
* conscientious 
* emotstab 
* openness
	
************************
*** Authoritarianism ***
************************
* Authoritarianism index
* Varables are coded 0,1
* Independence, curiosity, self-reliance, and being considerate are low authoritarian
* Respect for elders, good manners, obedience, and well behaved are high authoritarian

* Well behaved/considerate
	* gen authconsid = .
	* replace authconsid=0 if auth_consid==1
	* replace authconsid=1 if auth_consid==2
	* tab authconsid
	* label var authconsid "Auth 0-1 Recode of auth_consid: Well-Behaved"
	* label define authconsidl 0 "Being Considerate" 1 "Well Behaved" 
	* label value authconsid authconsidl 

* Obedience/self-reliance
	* gen authobed = .
	* replace authobed=1 if auth_obed==1
	* replace authobed=0 if auth_obed==2
	* tab authobed
	* label var authobed "Auth 0-1 Recode of auth_obed: Obedience"
	* label define authobedl 0 "Self-Reliance" 1 "Obedience" 
	* label value authobed authobedl 

* Good manners/Curiosity
	* gen authcur = .
	* replace authcur=0 if auth_cur==1
	* replace authcur=1 if auth_cur==2
	* tab authcur
	* label var authcur "Auth 0-1 Recode of auth_cur: Good Manners"
	* label define authcurl 0 "Curiosity" 1 "Good Manners" 
	* label value authcur authcurl 

* Respect for elders/independence
	* gen authind = .
	* replace authind=0 if auth_ind==1
	* replace authind=1 if auth_ind==2
	* tab authind
	* label var authind "Auth 0-1 Recode of auth_ind: Respect for Elders"
	* label define authindl 0 "Independence" 1 "Respect for Elders" 
	* label value authind authindl

* "auth" is the authoritarianism variable used in the analyses below
	* egen auth = rowmean(authconsid authobed authcur authind)
	* tab auth
	* label var auth "Authoritarianism 0-1 (Avg of authconsid authobed authcur authind)"

*************************
*** External Efficacy ***
*************************
* Combined effic_carerev and effic_carestd; combined effic_sayrev and effic_saystd
* Combined care and nosay into an external efficacy index 
* Coded such that higher values = more efficacy

	* gen effic_carerev2 = .
	* replace effic_carerev2=1 if effic_carerev==1
	* replace effic_carerev2=.75 if effic_carerev==2
	* replace effic_carerev2=.5 if effic_carerev==3
	* replace effic_carerev2=.25 if effic_carerev==4
	* replace effic_carerev2=0 if effic_carerev==5
	* tab effic_carerev2 effic_carerev
	* label var effic_carerev2 "0-1 Reverse Recode of effic_carerev: Pub officials dont care what people think"

	* gen effic_carestd2 = .
	* replace effic_carestd2=1 if effic_carestd==5
	* replace effic_carestd2=.75 if effic_carestd==4
	* replace effic_carestd2=.5 if effic_carestd==3
	* replace effic_carestd2=.25 if effic_carestd==2
	* replace effic_carestd2=0 if effic_carestd==1
	* tab effic_carestd2 effic_carestd
	* label var effic_carestd2 "0-1 Recode of effic_carestd: Pub officials dont care what people think"

	* gen care = . 
	* replace care = effic_carerev2 if randsplice_revisedstandard == 1
	* replace care = effic_carestd2 if randsplice_revisedstandard == 2
	* tab care
	* label var care "Comb effic_carerev2 & effic_carestd2 for efficacy (using randsplice_revisedstandard)"

	* gen effic_sayrev2 = .
	* replace effic_sayrev2=1 if effic_sayrev==1
	* replace effic_sayrev2=.75 if effic_sayrev==2
	* replace effic_sayrev2=.5 if effic_sayrev==3
	* replace effic_sayrev2=.25 if effic_sayrev==4
	* replace effic_sayrev2=0 if effic_sayrev==5
	* tab effic_sayrev2 effic_sayrev
	* label var effic_sayrev2 "0-1 Reverse Recode of effic_sayrev: Have no say about what govt does"

	* gen effic_saystd2 = .
	* replace effic_saystd2=1 if effic_saystd==5
	* replace effic_saystd2=.75 if effic_saystd==4
	* replace effic_saystd2=.5 if effic_saystd==3
	* replace effic_saystd2=.25 if effic_saystd==2
	* replace effic_saystd2=0 if effic_saystd==1
	* tab effic_saystd2 effic_saystd
	* label var effic_saystd2 "0-1 Recode of effic_saystd: Have no say about what govt does"

	* gen nosay = . 
	* replace nosay = effic_sayrev2 if randsplice_revisedstandard == 1
	* replace nosay = effic_saystd2 if randsplice_revisedstandard == 2
	* tab nosay
	* label var nosay "Comb effic_sayrev2 & effic_saystd2 for efficacy (using randsplice_revisedstandard)"
	
* "efficacy" is the external efficacy variable used in the analyses below
	* gen efficacy = (care + nosay)/2
	* tab efficacy
	* label var efficacy "0-1 External Efficacy (Avg of care & nosay)"


**************************
*** Need for Cognition ***
**************************
* N/A for ANES 2012

************************
*** Need to Evaluate ***
************************
* Higher values = higher need to evaluate 
	* gen needeval = .
	* replace needeval=0 if cog_opin_x==1
	* replace needeval=.25 if cog_opin_x==2
	* replace needeval=.50 if cog_opin_x==3
	* replace needeval=.75 if cog_opin_x==4
	* replace needeval=1 if cog_opin_x==5
	* tab needeval
	* label var needeval "0-1 Recode of Need to Evaluate cog_opin_x: # opinions R has compared to avg prsn"

* "needeval" is the need to evaluate variable used in the analyses below

*****************************
*** Ideological Extremity ***
*****************************
* The following command folds ideo7 without moderates and places it on a 0-1 scale to create an ideological extremity variable
	* gen ideoextrem = .
	* replace ideoextrem=1 if libcpre_self==1
	* replace ideoextrem=1 if libcpre_self==7
	* replace ideoextrem=.5 if libcpre_self==2
	* replace ideoextrem=.5 if libcpre_self==6
	* replace ideoextrem=0 if libcpre_self==3
	* replace ideoextrem=0 if libcpre_self==5
	* tab ideoextrem
	* label var ideoextrem "0-1 Ideological Extremity Recode of libcpre_self"

* "ideoextrem" is the ideological extremity variable used in the analyses below

******************************
*** Federal Gov't Attitude ***
******************************
* ANES analyses utilize a federal government feeling thermometer
	* tab ftgr_fedgov
	* gen gov_therm = ftgr_fedgov
	* recode gov_therm (-2=.) (-6=.) (-7=.) (-8=.) (-9=.)
	* tab gov_therm
	* label var gov_therm "Recode of ftgr_fedgov for missing values"

	* gen govtherm = gov_therm/100
	* tab govtherm
	* label var govtherm "0-1 Recode of gov_therm: Feeling thermometer - Fed govt in Washington"

* "govtherm" is the federal government attitude variable (feeling thermometer) used in the analyses below

*******************
*** Religiosity ***
*******************
* The following command recodes the religious importance variable from the 2012 ANES time series
	* gen relig = .
	* replace relig=1 if relig_import==1
	* replace relig=0 if relig_import==2
	* tab relig
	* label var relig "0-1 Recode of relig_import: Is religion important part of R life"
	* label define religl 0 "Not Important" 1 "Important" 
	* label value relig religl

* "relig" is the religiosity variable used in the analyses below

*****************
*** Education ***
*****************
* The following command recodes the level of education demographic summary variable from the 2012 ANES time series
	* gen educ = .
	* replace educ=0 if dem_edugroup_x==1
	* replace educ=.25 if dem_edugroup_x==2
	* replace educ=.5 if dem_edugroup_x==3
	* replace educ=.75 if dem_edugroup_x==4
	* replace educ=1 if dem_edugroup_x==5
	* tab educ
	* label var educ " 0-1 Recode of dem_edugroup_x: Level of Education"

* "educ" is the level of education variable used in the analyses below

**************
*** Income ***
**************
* The following command recodes the level of income demographic summary variable from the 2012 ANES time series
	* gen income = inc_incgroup_pre
	* recode income (-2=.) (-8=.) (-9=.)
	* tab income
	* recode income (1/4=0) (5/8=.25) (9/14=.5) (15/22=.75) (23/28=1)
	* tab income
	* label var income "0-1 Recode of inc_incgroup_pre: Family Income"


* "income" is the income variable used in the analyses below

**************
*** Gender ***
**************
* The following command recodes the gender demographic summary variable from the 2012 ANES time series
	* gen female = .
	* replace female=1 if gender_respondent_x==2
	* replace female=0 if gender_respondent_x==1
	* tab female
	* label var female "Female Dummy Variable (Recode of gender_respondent_x)"
	* label define femalel 0 "Male" 1 "Female" 
	* label value female femalel 

* "female" is the gender dummy variable used in the analyses below

***********
*** Age ***
***********
* The following command recodes the age demographic summary variable from the 2012 ANES time series
	* gen Age = dem_age_r_x
	* recode Age (-2=.)
	* gen age = (Age-17)/73
	* tab age
	* label var Age "Recode of dem_age_r_x: Age in Years"
	* label var age "0-1 Recode of Age"

* "age" is the age variable used in the analyses below

**************
*** Latino ***
**************
* The following command recodes the demographic variable asking identification as Spanish, Hispanic, or Latino from the 2012 ANES time series
	* gen latino = .
	* replace latino=1 if dem_hisp==1
	* replace latino=0 if dem_hisp==2
	* tab latino
	* label var latino "0-1 Spanish, Latino, Hispanic Dummy Variable Recode of dem_hisp"
	* label define latinol 0 "No" 1 "Yes" 
	* label value latino latinol 

* "latino" is the dummy variable for those who identified as Spanish, Hispanic, or Latino used in the analyses below

**************
*** White ***
**************
* The following command recodes the race demographic summary variable from the 2012 ANES time series
	* gen white = .
	* replace white=1 if dem_raceeth_x==1
	* replace white=0 if dem_raceeth_x==2
	* replace white=0 if dem_raceeth_x==3
	* replace white=0 if dem_raceeth_x==4
	* tab white
	* label var white "White Dummy Variable Recode of dem_raceeth_x"
	* label define whitel 0 "Not White" 1 "White" 
	* label value white whitel 

* "white" is the race dummy variable used in the analyses below

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

***************************
***************************
***************************
*** Dependent Variables ***
***************************
***************************
***************************

* Conspiracy Questions; Recoded variables 0-1, high levels = high endorsement

	* gen bornus = .
	* replace bornus=0 if nonmain_born==1
	* replace bornus=.33 if nonmain_born==2
	* replace bornus=.66 if nonmain_born==3
	* replace bornus=1 if nonmain_born==4
	* tab bornus
	* label var bornus "0-1 Recode of nonmain_born: Was the President born in the U.S."

	* gen deathpanel = .
	* replace deathpanel=0 if nonmain_endlife==4
	* replace deathpanel=.33 if nonmain_endlife==3
	* replace deathpanel=.66 if nonmain_endlife==2
	* replace deathpanel=1 if nonmain_endlife==1
	* tab deathpanel
	* label var deathpanel "0-1 Recode of nonmain_endlife: Does Health Care Act authorize end-of-life decisions"

	* gen govt911 = .
	* replace govt911=0 if nonmain_govt911==4
	* replace govt911=.33 if nonmain_govt911==3
	* replace govt911=.66 if nonmain_govt911==2
	* replace govt911=1 if nonmain_govt911==1
	* tab govt911
	* label var govt911 "0-1 Recode of nonmain_govt911: Did US govt know abt 9/11 in advance"

	* gen katrina = .
	* replace katrina=0 if nonmain_hurric==4
	* replace katrina=.33 if nonmain_hurric==3
	* replace katrina=.66 if nonmain_hurric==2
	* replace katrina=1 if nonmain_hurric==1
	* tab katrina
	* label var katrina "0-1 Recode of nonmain_hurric: Did govt direct Katrina flooding to poor areas"

* Conservative Conspiracy Index:	
	* gen conservindex = (bornus + deathpanel)/2
	* tab conservindex
	* label var conservindex "Conservative Conspiracy Index (Avg of bornus & deathpanel)"

* Liberal Conspiracy Index:
	* gen libindex = (govt911 + katrina)/2
	* tab libindex
	* label var libindex "Liberal Conspiracy Index (Avg of govt911 & katrina)"

* "conservindex" is the dependent variable measuring the Conservative Conspiracy Index in the analyses below
* "libindex" is the dependent variable measuring the Liberal Conspiracy Index in the analyses below

* Dependent variable for the unrelated regression analyses below
	* gen neglibindex=-1*libindex
	* label var neglibindex "DV for Unrelated Regression (-1*libindex)"

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

* The following descriptions and analyses follow the order of the article, unless otherwise noted. 

*******************************************
*******************************************
*******************************************
*** Description of Studies and Measures ***
*******************************************
*******************************************
*******************************************

******************
*** ANES Study ***
******************

* ANES N for liberals and conservatives on only internet mode
* Conservatives 60% (p. 21)
tab consvlib if mode == 2 [aw=weight_full] 

* Dependent variables, see above

* Explanatory variables, see above

* Reliability of knowledge index:
alpha knowmed knowspend prestimes senterm speaker vp pmuk cj housemaj senmaj if mode==2 

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

***************
***************
***************
*** Results ***
***************
***************
***************

**************************************************************************
*** A Snapshot of the Two Datasets: More Similarities than Differences ***
**************************************************************************

* See Appendix B below for Descriptive Statistics for Demographics – MTurk and ANES

* Knowledge means/standard deviations for conservatives and liberals
	* Conservatives
sum totalknow if consvlib==1 & mode == 2 [aw=weight_full]
	* Liberals
sum totalknow if consvlib==0 & mode == 2 [aw=weight_full] 

* Trust means/standard deviations for conservatives and liberals
	* Conservatives
sum totaltrustz if consvlib==1 & mode == 2 [aw=weight_full]
	* Liberals
sum totaltrustz if consvlib==0 & mode == 2 [aw=weight_full] 

******************************************************************************************
*** H1: Conservatives Endorse Ideologically-Consistent Conspiracies More than Liberals ***
******************************************************************************************

* See Table 1 
* See Table 2 (columns 1-4)

* Unrelated Regression Analyses
svyset [pweight=weight_full]
svy: reg conservindex consvlib totalknow totaltrustz extraversion agreeableness conscientious emotstab openness auth efficacy needeval ideoextrem govtherm relig educ income female age latino white if mode == 2
estimates store dv1

svy: reg neglibindex consvlib totalknow totaltrustz extraversion agreeableness conscientious emotstab openness auth efficacy needeval ideoextrem govtherm relig educ income female age latino white if mode == 2
estimates store dv2

suest dv1 dv2, svy

test [dv1]consvlib=[dv2]consvlib

********************************************
*** H2: The Moderating Role of Knowledge ***
********************************************

* See Table 2 (columns 5-8) and Figure 1 

************************************************************
*** H3: The Joint Moderating Role of Knowledge and Trust ***
************************************************************

* See Table 2 (columns 9-12) and Figures 2 and 3


****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

**************
**************
**************
*** Tables ***
**************
**************
************** 

************************************************************************************************
************************************************************************************************
************************************************************************************************
*** Table 1. Means on Conspiracy Items and Indices Separately for Conservatives and Liberals ***
************************************************************************************************
************************************************************************************************
************************************************************************************************

* Conservative Conspiracy Index - bornus deathpanel
	* bornus - Was Barack Obama born in the U.S.?
robvar bornus, by(consvlib)
ttest bornus, by(consvlib) level(95) unequal
	* deathpanel - Death panels?	
robvar deathpanel, by(consvlib)
ttest deathpanel, by(consvlib) level(95) unequal

robvar conservindex, by(consvlib)
ttest conservindex, by(consvlib) level(95) unequal

* Liberal Conspiracy Index - govt911 katrina
	* katrina - Fed gov't intentionally breached flood levees during Hurricane Katrina
robvar katrina, by(consvlib)
ttest katrina, by(consvlib) level(95) unequal
	* govt911 - Gov't knew about 9/11 prior to attacks
robvar govt911, by(consvlib)
ttest govt911, by(consvlib) level(95) unequal

robvar libindex, by(consvlib)
ttest libindex, by(consvlib) level(95) 


*************************************************************
*************************************************************
*************************************************************
*** Table 2. Effect of Ideology, Knowledge, Trust, and their Interactions on Conspiracy Endorsement 
*************************************************************
*************************************************************
*************************************************************

**************************
*** Main Effect Models ***
**************************
	* Conservative Conspiracy Index
reg conservindex consvlib ///
totalknow totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store m2
	* Liberal Conspiracy Index
reg libindex consvlib ///
totalknow totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store m4

******************************************************
*** 2-way Interactive Models with Ideo x Knowledge ***
******************************************************
	* Conservative Conspiracy Index
reg conservindex i.consvlib##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust)
estimates store m6
	* Liberal Conspiracy Index
reg libindex i.consvlib##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store m8

**************************************************************
*** 3-way Interactive Models with Ideo x Knowledge x Trust ***
**************************************************************
	* Conservative Conspiracy Index
reg conservindex i.consvlib##c.totaltrustz##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust)
estimates store m10
	* Liberal Conspiracy Index
reg libindex i.consvlib##c.totaltrustz##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store m12

* Where m1, m3, m5, m7, m9, and m11 estimates are from MTurk.do
esttab m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 using "Table 2.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)
* Table 2 reflects our variables of interest. Control variables were not reported within the table.
* These models are provided in full within the Online Appendix. 

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

***************
***************
***************
*** Figures ***
***************
***************
*************** 

***************************************************************************************************************************************
***************************************************************************************************************************************
***************************************************************************************************************************************
*** Figure 1. Effect of Knowledge on Endorsement of Conservative Conspiracy Theories (Conservative Index) *****************************
*** for Conservatives and Liberals and on Endorsement of Liberal Conspiracy Theories (Liberal Index) for Conservatives and Liberals ***
***************************************************************************************************************************************
***************************************************************************************************************************************
***************************************************************************************************************************************

******************************************************
*** 2-way Interactive Models with Ideo x Knowledge ***
******************************************************
	* Conservative Index
reg conservindex i.consvlib##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
margins, dydx(totalknow) at(consvlib=(0(1)1))

margins, at(totalknow=(0(.1)1)) over(consvlib)
marginsplot, title("ANES", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) ///
	legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Conservative Index", col(white)) ///
	legend(textfirst) ///
	text(.51 .5 ".10 (.04)") ///
    text(.17 .5 "-.34 (.04)") ///	
	scheme(s1mono)
graph save conpolknow_con_anes_bw.gph, replace

	* Liberal Index
reg libindex i.consvlib##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
margins, dydx(totalknow) at(consvlib=(0(1)1))

margins, at(totalknow=(0(.1)1)) over(consvlib)
marginsplot, title("ANES", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) ///
	legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Liberal Index", col(white)) ///
	legend(textfirst) ///
	text(.44 .5 "-.21 (.04)") ///
    text(.26 .5 "-.21 (.04)") ///
	scheme(s1mono)
graph save libpolknow_con_anes_bw.gph, replace

* To combine graphs for Figure1:
	* gr combine conpolknow_con_mturk_bw.gph conpolknow_con_anes_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("Conservative Conspiracy Index", col(white) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure1_comb_conpolknow_con_anesmturk_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

	* gr combine lib4polknow_con_mturk_bw.gph libpolknow_con_anes_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("Liberal Conspiracy Index", col(white) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure1_comb_libpolknow_con_anesmturk_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
*** Figure 2. Effect of Knowledge on Endorsement of Conservative Conspiracy Theories (Conservative Index) *** 
*** for Conservatives and Liberals Separately for Respondents Low and High in Generalized Trust ************* 
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************

**************************************************************
*** 3-way Interactive Models with Ideo x Knowledge x Trust ***
**************************************************************
	* Conservative Index
	* Low Trust
reg conservindex i.consvlib##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if trustspz==0 & mode == 2 [aw=weight_full], vce(robust)  
margins, dydx(totalknow) at(consvlib=(0(1)1))

margins, at(totalknow=(0(.1)1)) over(consvlib)
marginsplot, title("Low Trust", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) ///
	legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Conservative Index") ///
	legend(textfirst) ///	
	text(.57 .5 ".15 (.06)") ///
    text(.18 .5 "-.43 (.06)") ///
	scheme(s1mono)
graph save conpolknow_con_lowtrust_anes_bw.gph, replace

	* High Trust
reg conservindex i.consvlib##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if trustspz==1 & mode == 2 [aw=weight_full], vce(robust) 
margins, dydx(totalknow) at(consvlib=(0(1)1))

margins, at(totalknow=(0(.1)1)) over(consvlib)
marginsplot, title("High Trust", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) ///
	legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Conservative Index", col(white)) ///
	legend(textfirst) ///
	text(.48 .5 ".07 (.05)") ///
    text(.14 .5 "-.27 (.05)") ///
	scheme(s1mono)
graph save conpolknow_con_hightrust_anes_bw.gph, replace

* To combine graphs for Figure2:
	* gr combine conpolknow_con_lowtrust_mturk_bw.gph conpolknow_con_hightrust_mturk_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("MTurk", col(black) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure2a_comb_conpolknow_con_highlow_mturk_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

	* gr combine conpolknow_con_lowtrust_anes_bw.gph conpolknow_con_hightrust_anes_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("ANES", col(black) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure2b_comb_conpolknow_con_highlow_anes_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

***************************************************************************************************
***************************************************************************************************
***************************************************************************************************
*** Figure 3. Effect of Knowledge on Endorsement of Liberal Conspiracy Theories (Liberal Index) ***
*** for Conservatives and Liberals Separately for Respondents Low and High in Generalized Trust *** 
***************************************************************************************************
***************************************************************************************************
***************************************************************************************************

**************************************************************
*** 3-way Interactive Models with Ideo x Knowledge x Trust ***
**************************************************************
	* Liberal Index
	* Low Trust
reg libindex i.consvlib##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if trustspz==0 & mode == 2 [aw=weight_full], vce(robust) 
margins, dydx(totalknow) at(consvlib=(0(1)1))

margins, at(totalknow=(0(.1)1)) over(consvlib)
marginsplot, title("Low Trust", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) ///
	legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Liberal Index") ///
	legend(textfirst) ///
	text(.51 .5 "-.21 (.07)") ///
    text(.27 .5 "-.19 (.06)") ///
	scheme(s1mono)
graph save libpolknow_con_lowtrust_anes_bw.gph, replace

	* High Trust
reg libindex i.consvlib##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if trustspz==1 & mode == 2 [aw=weight_full], vce(robust)  
margins, dydx(totalknow) at(consvlib=(0(1)1))

margins, at(totalknow=(0(.1)1)) over(consvlib)
marginsplot, title("High Trust", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) ///
	legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Liberal Index", col(white)) ///
	legend(textfirst) ///	
	text(.41 .5 "-.21 (.05)") ///
    text(.23 .5 "-.23 (.05)") ///
	scheme(s1mono)
graph save libpolknow_con_hightrust_anes_bw.gph, replace

* To combine graphs for Figure3:
	* gr combine lib4polknow_con_lowtrust_mturk_bw.gph lib4polknow_con_hightrust_mturk_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("MTurk", col(black) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure3a_comb_lib4polknow_con_highlow_mturk_bw.gph, replace
*Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

	* gr combine libpolknow_con_lowtrust_anes_bw.gph libpolknow_con_hightrust_anes_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("ANES", col(black) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure3b_comb_libpolknow_con_highlow_anes_bw.gph, replace
*Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).


****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

*************************
*************************
*************************
*** Footnote Analyses ***
*************************
*************************
*************************

******************
*** Footnote 3 ***
******************
* For full ANES analyses with combined face-to-face and internet modes, please contact the authors

******************
*** Footnote 4 ***
******************
* Iterated principal components analysis 
factor bornus deathpanel govt911 katrina if mode == 2 [aw=weight_full]
factor bornus deathpanel govt911 katrina if mode == 2 [aw=weight_full], ipf
factor bornus deathpanel govt911 katrina if mode == 2 [aw=weight_full], ipf blanks(.30)
factor bornus deathpanel govt911 katrina if mode == 2 [aw=weight_full], ipf factors(2)
factor bornus deathpanel govt911 katrina if mode == 2 [aw=weight_full], ipf factors(2) blanks(.30)

******************
*** Footnote 7 ***
******************
* See Appendix C

******************
*** Footnote 8 ***
******************
* For full ANES replication with svy suite of commands, please contact the authors

******************
*** Footnote 9 ***
******************
* See Online Appendix for tables of full models

*******************
*** Footnote 11 ***
*******************
* Another way to display the shape of the three-way interaction on the conservative index 
* is to examine the (continuous) trust x (continuous) knowledge two-way interaction separately for conservatives and liberals
* Conservative Conspiracy Index
	* Conservatives
reg conservindex c.totalknow##c.totaltrustz ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if consvlib==1 & mode == 2 [aw=weight_full], vce(robust)  
	* Liberals
reg conservindex c.totalknow##c.totaltrustz ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if consvlib==0 & mode == 2 [aw=weight_full], vce(robust)

*******************
*** Footnote 12 ***
*******************
* See Online Appendix Tables 4 and 5 for party identification models

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

******************
******************
******************
*** Appendix B ***
******************
******************
******************

* Table reports demographics limited to liberals and conservatives in the sample.
* Moderates are not included within this table. 
sum Age if mode == 2 & consvlib==0 | mode == 2 & consvlib==1 [aw=weight_full]
tab female if mode == 2 & consvlib==0 | mode == 2 & consvlib==1 [aw=weight_full] 
tab white if mode == 2 & consvlib==0 | mode == 2 & consvlib==1 [aw=weight_full] 
tab educ if mode == 2 & consvlib==0 | mode == 2 & consvlib==1 [aw=weight_full] 
	* Education categories in Appendix B reflect values where categories 1 and 2 are combined
tab income if mode == 2 & consvlib==0 | mode == 2 & consvlib==1 [aw=weight_full] 
tab latino if mode == 2 & consvlib==0 | mode == 2 & consvlib==1 [aw=weight_full] 

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

******************
******************
******************
*** Appendix C ***
******************
******************
******************

* Cell Percentages and Counts for Ideology Cross-tabbed with Low and High-Knowledge and Trust – MTurk and ANES
* Reports crosstabs by high/low splits
* The coding for the high/low trust and knowledge splits are above
bysort consvlib: tab totaltrustz_hl totalknow_hl if mode ==2 [aw=weight_full], col cell row

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

***********************
***********************
***********************
*** Online Appendix ***
***********************
***********************
***********************

*****************************************************************************
*** Online Appendix Table 1. Effect of Ideology on Conspiracy Endorsement ***
*****************************************************************************
	* Conservative Conspiracy Index
reg conservindex consvlib ///
totalknow totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store a2
	* Liberal Conspiracy Index
reg libindex consvlib ///
totalknow totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store a4

* Where a1 and a3 are estimates from MTurk.do
esttab a1 a2 a3 a4 using "Online Appendix Table 1.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)

***************************************************************************************
*** Online Appendix Table 2. Knowledge x Ideology Predicting Conspiracy Endorsement ***
***************************************************************************************
	* Conservative Conspiracy Index
reg conservindex i.consvlib##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust)
estimates store b2
	* Liberal Conspiracy Index
reg libindex i.consvlib##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store b4

* Where b1 and b3 are estimates from MTurk.do
esttab b1 b2 b3 b4 using "Online Appendix Table 2.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)

***********************************************************************************************
*** Online Appendix Table 3. Knowledge x Trust x Ideology Predicting Conspiracy Endorsement ***
***********************************************************************************************
	* Conservative Conspiracy Index
reg conservindex i.consvlib##c.totaltrustz##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust)
estimates store c2 
	* Liberal Conspiracy Index
reg libindex i.consvlib##c.totaltrustz##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval ideoextrem govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store c4

* Where c1 and c3 are estimates from MTurk.do
esttab c1 c2 c3 c4 using "Online Appendix Table 3.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)

***************************************************************************************************************
*** Online Appendix Table 4. Effect of Party Identification, Knowledge, and Trust on Conspiracy Endorsement ***
***************************************************************************************************************
**************************
*** Main Effect Models ***
**************************
	* Conservative Conspiracy Index
reg conservindex pid6 ///
totalknow totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store d2
	* Liberal Conspiracy Index
reg libindex pid6 ///
totalknow totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store d4
******************************************************
*** 2-way Interactive Models with PID x Knowledge ***
******************************************************
	* Conservative Conspiracy Index
reg conservindex c.pid6##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store d6
	* Liberal Conspiracy Index
reg libindex c.pid6##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store d8
**************************************************************
*** 3-way Interactive Models with PID x Knowledge x Trust ***
**************************************************************
	* Conservative Conspiracy Index
reg conservindex c.pid6##c.totalknow##c.totaltrustz ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust)  
estimates store d10
	* Liberal Conspiracy Index
reg libindex c.pid6##c.totalknow##c.totaltrustz ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
estimates store d12

* Where d1, d3, d5, d7, d9, and d11 are estimates from MTurk.do
esttab d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 using "Online Appendix Table 4.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)

********************************************************************************************************************************************************
*** Online Appendix Table 5. Simple Slopes for Political Knowledge Predicting Conspiracy Endorsement Across Levels of Party Identification and Trust ***
********************************************************************************************************************************************************
*****************************************************
*** 2-way Interactive Models with PID x Knowledge ***
*****************************************************
	* Conservative Conspiracy Index
reg conservindex c.pid6##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
margins, dydx(totalknow) at(pid6=(0(.2)1))	
	* Liberal Conspiracy Index
reg libindex c.pid6##c.totalknow ///
totaltrustz extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if mode == 2 [aw=weight_full], vce(robust) 
margins, dydx(totalknow) at(pid6=(0(.2)1))	
*************************************************************
*** 3-way Interactive Models with PID x Knowledge x Trust ***
*************************************************************
	* Conservative Conspiracy Index - Low Trust
reg conservindex c.pid6##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if trustspz==0 & mode == 2 [aw=weight_full], vce(robust)  
margins, dydx(totalknow) at(pid6=(0(.2)1))	
	* Conservative Conspiracy Index - High Trust
reg conservindex c.pid6##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if trustspz==1 & mode == 2 [aw=weight_full], vce(robust) 
margins, dydx(totalknow) at(pid6=(0(.2)1))	
	* Liberal Conspiracy Index - Low Trust
reg libindex c.pid6##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if trustspz==0 & mode == 2 [aw=weight_full], vce(robust) 
margins, dydx(totalknow) at(pid6=(0(.2)1))	
	* Liberal Conspiracy Index - High Trust
reg libindex c.pid6##c.totalknow ///
extraversion agreeableness conscientious emotstab openness ///
auth efficacy needeval govtherm relig educ income /// 
female age latino white if trustspz==1 & mode == 2 [aw=weight_full], vce(robust)  
margins, dydx(totalknow) at(pid6=(0(.2)1))	

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
