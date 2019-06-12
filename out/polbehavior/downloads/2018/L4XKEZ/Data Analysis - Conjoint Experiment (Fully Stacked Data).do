/******************************************************************************
The following .do file contains the code needed to replicate the analyses reported
in Online Appendix A using the fully stacked version of the data. This data 
is used in the analyses presented in Figures OA8 and OA9 as well as in 
Table OA6 and Figure OA12. 

	ssc install coefplot
	ssc install combomarginsplot
	ssc install grc1leg


******************************************************************************/

clear
cd "C:\Users\Joshua\Dropbox\Work\Isssue Importance and Voting Paper\Dataverse"
use "Conjoint Experiment Data.dta"
set more off

			***************************************
			****Individiaul Level Controls*********
			***************************************	
			***************************************

********Background Variables
	label var responseid "Respondent ID (Survey 1)"
	label var finished_2 "Finished (Survey 2)"
	label var _merge "Merge Status"
	
	*TPP Randomization
	label def tpmanip 1 "Baseline" 2 "Low Importance" 3 "High Importance"
	gen tpp_manip = . 
	replace tpp_manip = 1 if dobrfl_23 == "TPP (1)"
	replace tpp_manip = 1 if dobrfl_23 == "TPP (2)"
	replace tpp_manip = 1 if dobrfl_23 == "TPP (3)"
	replace tpp_manip = 1 if dobrfl_23 == "TPP (4)"
	replace tpp_manip = 2 if dobrfl_23 == "TPP Low Imp (1)"
	replace tpp_manip = 2 if dobrfl_23 == "TPP  Low Imp (2)"
	replace tpp_manip = 2 if dobrfl_23 == "TPP  Low Imp (3)"
	replace tpp_manip = 2 if dobrfl_23 == "TPP  Low Imp (4)"
	replace tpp_manip = 3 if dobrfl_23 == "TPP High Imp (1)"
	replace tpp_manip = 3 if dobrfl_23 == "TPP High Imp (2)"
	replace tpp_manip = 3 if dobrfl_23 == "TPP High Imp (3)"
	replace tpp_manip = 3 if dobrfl_23 == "TPP High Imp (4)"
	label var tpp_manip "TPP Importance Manipulation"	
	label values tpp_manip tpmanip

*********Individual Characteristics

*PID
	mvdecode party, mv(-99=.a)
	label def par 1 "Republican" 2 "Democrat" 3 "Independent" 5 "No Preference" 
	label values party par
	label var party "PID"
	
	gen party1 = .
	replace party1 = 1 if party == 1
	replace party1 = 2 if party == 2
	replace party1 = 3 if party >=3 & party <= 5
	label var party1 "PID"
	label def par1 1 "Republican" 2 "Democrat" 3 "Ind/No Pref"
	label values party1 par1
	
	label def str 1 "Strong" 2 "Not Strong"
	label def lea 1 "Republican" 2 "Democrat" 3 "Neither"
	
	label values dem_strong str
	label values repstrong str
	label values lean lea
	
	gen partyid = .
	replace partyid = 1 if party1 == 2 & dem_strong == 1
	replace partyid = 2 if party1 == 2 & dem_strong == 2
	replace partyid = 3 if party1 == 3 & lean == 2
	replace partyid = 4 if party1 == 3 & lean == 3
	replace partyid = 5 if party1 == 3 & lean == 1
	replace partyid = 6 if party1 == 1 & repstrong == 2
	replace partyid = 7 if party1 == 1 & repstrong == 1
	label var partyid "Party ID"
	label def par2 1 "Strong Dem" 2 "Not Strong Dem" 3 "Lean Dem" 4 "Ind./No Pref" ///
		5 "Lean Rep" 6 "Not Strong Rep" 7 "Strong Rep"
	label values partyid par2
	
	by finished, sort: tab party
	by finished_2, sort: tab party 
	
	by finished, sort: summ partyid
	by finished_2, sort: summ partyid
	
	
*PID  Strength: Extremity & Imp
	recode partyid (1=4) (7=4) (2=3) (6=3) (3=2) (5=2) (4=1), gen(party_ext)
	label var party_ext "Party ID: Extremity"
	label def pext 1 "Ind." 2 "Lean" 3 "Not Strong" 4 "Strong"
	label values party_ext pext
	
	rename pid_imp pid_imp_orig
	recode pid_imp_orig (1=5) (2=4) (3=3) (4=2) (5=1) (-99=.), gen(pid_imp)
	label values pid_imp imphigh
	label var pid_imp "PID Importance" 
	
	by finished, sort: summ pid_imp
	by finished_2, sort: summ pid_imp

    
*Gender
	recode sex (1=0) (2=1) (-99=.), gen(gender)
	label var gender "Gender" 
	label def gend 1 "Female" 0 "Male"
	label values gender gend

	by finished, sort: tab gender
	by finished_2, sort: tab gender

*Race & Hispanic
	recode hispanic (1=1) (2=0) (-99=.), gen(hisp)
	label def his 1 "Hispanic" 0 "Non-Hispanic" 
	label values hisp his
	label var hisp "Hispanic"
	
	by finished, sort: tab hisp
	by finished_2, sort: tab hisp
	
	mvdecode race, mv(-99=.a)
	label def rac 1 "White" 2 "Black" 3 "Amer. Indian/Alaska Native" 4 "Asian" 5 "Native Hawaiian/Pacific Islander" 6 "Other"
	label values race rac
	
	gen race_eth = .
	replace race_eth = 1 if race == 1 & hisp == 0
	replace race_eth = 2 if race == 2 & hisp == 0
	replace race_eth = 3 if race == 1  & hisp == 1
	replace race_eth = 3 if race == 2  & hisp == 1
	replace race_eth = 3 if race == 3  & hisp == 1
	replace race_eth = 3 if race == 4  & hisp == 1
	replace race_eth = 3 if race == 5  & hisp == 1
	replace race_eth = 3 if race == 6  & hisp == 1
	replace race_eth = 4 if race == 4 & hisp == 0
	replace race_eth = 5 if race == 3 & hisp == 0
	replace race_eth = 5 if race == 5 & hisp == 0
	replace race_eth = 5 if race == 6 & hisp == 0
	label var race_eth "Race/Ethnicity"
	label def rac1 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Other"
	label values race_eth rac1
	
	by finished, sort: tab race_eth
	by finished_2, sort: tab race_eth
		

*Religion
	label def reli 1 "Protestant" 2 "Roman Catholic" 3 "Mormon" 4 "Orthodox" ///
		5 "Jewish" 6 "Muslim" 7 "Buddhist" 8 "Hindu" 9 "Atheist" 10 "Agnostic" ///
		11 "Something Else" 12 "Nothing in Particular"
		
	label values religion reli
	mvdecode religion, mv(-99=.a)
	
	by finished, sort: tab religion
	by finished_2, sort: tab religion
	
	gen relig1 = . 
	replace relig1 = 1 if religion >=1 & religion <=4
	replace relig1 = 2 if religion >=5 & religion <=8
	replace relig1 = 3 if religion == 11
	replace relig1 = 4 if religion >=9 & religion <=10
	replace relig1 = 4 if religion == 12
	label var relig1 "Religion" 
	label def rel2 1 "Christian" 2 "Non-Christian" 3 "Something Else" 4 "Non-Religious"
	label values relig1 rel2
	
	by finished, sort: tab relig1
	by finished_2, sort: tab relig1
	
	recode religion_imp (1=5) (2=4) (3=3) (4=2) (5=1) (-99=.), gen(rel_imp)
	label var rel_imp "Importance of Religious/Non-Religious Identity"
	label values rel_imp imphigh
	
	by finished, sort: summ rel_imp
	by finished_2, sort: summ rel_imp		
			
		
**Issue Attitudes


***Recoded so that high = conservative stereotyped responses

	**Immigration
		/**
		Statement: Illegal immigrants brought to the US as children should be allowed 
					to apply for citizenship.
		high = oppose
		**/
		
		label def opp_high 1 "Strongly Support" 2 "Moderately Support" 3 "Somewhat Support" ///
			4 "Neither" 5 "Somewhat Oppose" 6 "Moderately Oppose" 7 "Strongly Oppose"

			foreach var in path1 path2 {
				recode `var' (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) (-99=.), gen(new_`var')
				label values new_`var' opp_high
				}
				
			foreach var in path3 path4 {
				recode `var' (-99=.), gen(new_`var')
				label values new_`var' opp_high
				}

			gen path = .
			replace path = new_path1
			replace path = new_path2 if path == .
			replace path = new_path3 if path == . 
			replace path = new_path4 if path == . 
			label var path "Pathway to Citizenship"
			label values path opp_high

	**Taxes on Rich
		/**
			Statement: Taxes on those making over $250,000 a year should be increased. 
			high = oppose
		**/

		foreach var in taxes1 taxes2 {
			recode `var' (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) (-99=.), gen(new_`var')
			label values new_`var' opp_high
			}
			
		foreach var in taxes3 taxes4 {
			recode `var' (-99=.), gen(new_`var')
			label values new_`var' opp_high
			}

		gen taxes = .
		replace taxes = new_taxes1
		replace taxes = new_taxes2 if taxes == .
		replace taxes = new_taxes3 if taxes == . 
		replace taxes = new_taxes4 if taxes == . 
		label var taxes "Taxes on Rich"
		label values taxes opp_high

	**Cap & Trade
		/**
			statement: A carbon tax or cap and trade system should be 
						instituted to regulate greenhouse gas emissions. 
			high = oppose
		**/

		foreach var in cap1 cap2 {
			recode `var' (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) (-99=.), gen(new_`var')
			label values new_`var' opp_high
			}
			
		foreach var in cap3 cap4 {
			recode `var' (-99=.), gen(new_`var')
			label values new_`var' opp_high
			}

		gen captrade = .
		replace captrade = new_cap1
		replace captrade = new_cap2 if captrade == .
		replace captrade = new_cap3 if captrade == . 
		replace captrade = new_cap4 if captrade == . 
		label var captrade "Cap and Trade"
		label values captrade opp_high

	**ISIS
		/**
			Statement: The United States should deploy ground troops to combat ISIS.
			high = SUPPORT 	
		**/

		label def opp_low 7 "Strongly Support" 6 "Moderately Support" 5 "Somewhat Support" ///
			4 "Neither" 3 "Somewhat Oppose" 2 "Moderately Oppose" 1 "Strongly Oppose"

		
		foreach var in isis3 isis4 {
			recode `var' (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) (-99=.), gen(new_`var')
			label values new_`var' opp_low
			}
			
		foreach var in isis1 isis2 {
			recode `var' (-99=.), gen(new_`var')
			label values new_`var' opp_low
			}

		gen isis = .
		replace isis = new_isis1
		replace isis = new_isis2 if isis == .
		replace isis = new_isis3 if isis == . 
		replace isis = new_isis4 if isis == . 
		label var isis "ISIS"
		label values isis opp_low	
			
	*Issue Importance
		label def imphigh 1 "Not at all Imp" 2 "Slightly" 3 "Moderately" 4 "Very" 5 "Extremely"
	
		foreach var in guns1imp path1imp taxes1imp cap1imp isis1imp voucher1imp medicare1imp ///
			guns4imp path4imp taxes4imp cap4imp isis4imp voucher4imp medicare4imp {
				recode `var' (1=5) (2=4) (3=3) (4=2) (5=1) (-99=.), gen(new_`var')
				label values new_`var' imphigh
				}
		
		foreach var in guns2imp path2imp taxes2imp cap2imp isis2imp voucher2imp medicare2imp ///
			guns3imp path3imp taxes3imp cap3imp isis3imp voucher3imp medicare3imp {
				recode `var' (-99=.), gen(new_`var')
				label values new_`var' imphigh
			}
					
		gen pathimp = . 
		replace pathimp = new_path1imp 
		replace pathimp = new_path2imp if pathimp == . 
		replace pathimp = new_path3imp if pathimp == . 
		replace pathimp = new_path4imp if pathimp == . 
		label var pathimp "Immigration: Importance"
		label values pathimp imphigh
		
		gen taxesimp = . 
		replace taxesimp = new_taxes1imp 
		replace taxesimp = new_taxes2imp if taxesimp == . 
		replace taxesimp = new_taxes3imp if taxesimp == . 
		replace taxesimp = new_taxes4imp if taxesimp == . 
		label var taxesimp "Taxes on Rich: Importance"
		label values taxesimp imphigh
		
		gen capimp = . 
		replace capimp = new_cap1imp 
		replace capimp = new_cap2imp if capimp == . 
		replace capimp = new_cap3imp if capimp == . 
		replace capimp = new_cap4imp if capimp == . 
		label var capimp "Cap & Trade: Importance"
		label values capimp imphigh
		
		gen isisimp = . 
		replace isisimp = new_isis1imp 
		replace isisimp = new_isis2imp if isisimp == . 
		replace isisimp = new_isis3imp if isisimp == . 
		replace isisimp = new_isis4imp if isisimp == . 
		label var isisimp "ISIS: Importance"
		label values isisimp imphigh
		
	
	*TPP
		
		**Issue Attitude
			*High = Oppose
				*Blocks: 
				*1 = support to oppose; 2 =  oppose to support; 
				*3 = support to oppose; 4 = oppose to support
				
			label def tpp_opp 1 "Strongly Support" 2 "Moderately Support" 3 "Somewhat Support" ///
				4 "Neither" 5 "Somewhat Oppose" 6 "Moderately Oppose" 7 "Strongly Oppose" 
				
				
			foreach var in  tpp2 tpp4 tpp2low tpp4low tpp2high tpp4high {
				recode `var' (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) (-99=.), gen(new_`var')
				label values new_`var' tpp_opp
				}
				
			foreach var in tpp1 tpp3 tpp1low tpp3low tpp1high tpp3high {
				recode `var' (-99=.), gen(new_`var')
				label values new_`var' tpp_opp
				}
				
			gen tpp = .
				foreach var in new_tpp2 new_tpp4 new_tpp2low new_tpp4low new_tpp2high new_tpp4high new_tpp1 new_tpp3 new_tpp1low new_tpp3low new_tpp1high new_tpp3high {
					replace tpp = `var' if tpp == .
					}
			label values tpp tpp_opp
			label var tpp "TPP Issue Attitude"
	

		**Issue Importance**
			*recode so that high = extremely important
			*blocks:
				*1 = extreme imp to not at all ; 2 =  extreme imp to not at all 
				* 3 = not at all imp to extreme imp; 4 = not at all to extreme
			
			foreach var in tpp1imp tpp2imp tpp1implow tpp2implow tpp1imphigh tpp2imphigh {
				recode `var' (1=5) (2=4) (3=3) (4=2) (5=1) (-99=.), gen(new_`var')
				label values  new_`var' imphigh
				}
				
			foreach var in tpp3imp tpp4imp tpp3implow tpp4implow tpp3imphigh tpp4imphigh {
				recode `var' (-99=.), gen(new_`var')
				label values new_`var' imphigh
				}
			
			gen tppimp = .
				foreach var in new_tpp1imp new_tpp2imp new_tpp1implow new_tpp2implow new_tpp1imphigh new_tpp2imphigh ///
					new_tpp3imp new_tpp4imp new_tpp3implow new_tpp4implow new_tpp3imphigh new_tpp4imphigh {
					replace tppimp = `var' if tppimp == . 
				}
				label var tppimp "TPP: Importance"
				label values tppimp imphigh
	
		
			***************************************
			****Candidate Characteristics**********
			***************************************	
			***************************************


**Splitting the Variable***
	/** Candidate Trait Characteristic Order: 
	1 = Age; 2 = gender; 3 = race; 4 = religion; 
	5 = occupation; 6 = party; 7 = military service; 8 = education
	9 = tpp; 10 = isis; 11 = cap and trade; 12 = increased taxes on rich; 
	13 = path to citizenship	
	**/
	
	foreach var in traits1a traits1b traits2a traits2b ///
		traits3a traits3b traits4a traits4b traits5a traits5b {
		split `var', p(|) destring
		}
	
	foreach var in traits5b1 traits5b2 traits5b3 traits5b4 traits5b5 ///
		traits5b6 traits5b7 traits5b8 traits5b9 traits5b10 traits5b11 ///
		traits5b12 traits5b13 {
		tab `var'
		}
		
/**the next step is to rename the traits for reshaping, 
after which new versions will be created because the originals are in 
string form currently (save for age)
**/

	*Age
	rename traits1a1 cage1  
	rename traits1b1 cage2
	rename traits2a1 cage3
	rename traits2b1 cage4
	rename traits3a1 cage5
	rename traits3b1 cage6
	rename traits4a1 cage7
	rename traits4b1 cage8
	rename traits5a1 cage9
	rename traits5b1 cage10
	
	*Candidate Gender
	rename traits1a2 cgender1
	rename traits1b2 cgender2
	rename traits2a2 cgender3
	rename traits2b2 cgender4
	rename traits3a2 cgender5
	rename traits3b2 cgender6
	rename traits4a2 cgender7
	rename traits4b2 cgender8
	rename traits5a2 cgender9
	rename traits5b2 cgender10
		
	*Candidate Race
	rename traits1a3 crace1
	rename traits1b3 crace2
	rename traits2a3 crace3
	rename traits2b3 crace4
	rename traits3a3 crace5
	rename traits3b3 crace6
	rename traits4a3 crace7
	rename traits4b3 crace8
	rename traits5a3 crace9
	rename traits5b3 crace10
	
	*Candidate Religion
	rename traits1a4 crelig1
	rename traits1b4 crelig2
	rename traits2a4 crelig3
	rename traits2b4 crelig4
	rename traits3a4 crelig5
	rename traits3b4 crelig6
	rename traits4a4 crelig7
	rename traits4b4 crelig8
	rename traits5a4 crelig9
	rename traits5b4 crelig10
		
	*Candidate Occupation
	rename traits1a5 coccup1
	rename traits1b5 coccup2
	rename traits2a5 coccup3
	rename traits2b5 coccup4
	rename traits3a5 coccup5
	rename traits3b5 coccup6
	rename traits4a5 coccup7
	rename traits4b5 coccup8
	rename traits5a5 coccup9
	rename traits5b5 coccup10
	
	*Candidate Party
	rename traits1a6 cparty1
	rename traits1b6 cparty2
	rename traits2a6 cparty3
	rename traits2b6 cparty4
	rename traits3a6 cparty5
	rename traits3b6 cparty6
	rename traits4a6 cparty7
	rename traits4b6 cparty8
	rename traits5a6 cparty9
	rename traits5b6 cparty10

	*Candidate Military  Service
	rename traits1a7 cmilitary1
	rename traits1b7 cmilitary2
	rename traits2a7 cmilitary3
	rename traits2b7 cmilitary4
	rename traits3a7 cmilitary5
	rename traits3b7 cmilitary6
	rename traits4a7 cmilitary7
	rename traits4b7 cmilitary8
	rename traits5a7 cmilitary9
	rename traits5b7 cmilitary10
	
	*Candidate Education
	rename traits1a8 ceduc1
	rename traits1b8 ceduc2
	rename traits2a8 ceduc3
	rename traits2b8 ceduc4
	rename traits3a8 ceduc5
	rename traits3b8 ceduc6
	rename traits4a8 ceduc7
	rename traits4b8 ceduc8
	rename traits5a8 ceduc9
	rename traits5b8 ceduc10
		
	*Candidate: TPP
	rename traits1a9 ctpp1
	rename traits1b9 ctpp2
	rename traits2a9 ctpp3
	rename traits2b9 ctpp4
	rename traits3a9 ctpp5
	rename traits3b9 ctpp6
	rename traits4a9 ctpp7
	rename traits4b9 ctpp8
	rename traits5a9 ctpp9
	rename traits5b9 ctpp10
	
	
	*Candidate: ISIS
	rename traits1a10 cisis1
	rename traits1b10 cisis2
	rename traits2a10 cisis3
	rename traits2b10 cisis4
	rename traits3a10 cisis5
	rename traits3b10 cisis6
	rename traits4a10 cisis7
	rename traits4b10 cisis8
	rename traits5a10 cisis9
	rename traits5b10 cisis10

	*Candidate Cap & Trade
	rename traits1a11 ccap1
	rename traits1b11 ccap2
	rename traits2a11 ccap3
	rename traits2b11 ccap4
	rename traits3a11 ccap5
	rename traits3b11 ccap6
	rename traits4a11 ccap7
	rename traits4b11 ccap8
	rename traits5a11 ccap9
	rename traits5b11 ccap10
	
	*Candidate Taxes on Rich
	rename traits1a12 ctaxes1
	rename traits1b12 ctaxes2
	rename traits2a12 ctaxes3
	rename traits2b12 ctaxes4
	rename traits3a12 ctaxes5
	rename traits3b12 ctaxes6
	rename traits4a12 ctaxes7
	rename traits4b12 ctaxes8
	rename traits5a12 ctaxes9
	rename traits5b12 ctaxes10
	
	*Candidate Path to Citizenship
	rename traits1a13 cpath1
	rename traits1b13 cpath2
	rename traits2a13 cpath3
	rename traits2b13 cpath4
	rename traits3a13 cpath5
	rename traits3b13 cpath6
	rename traits4a13 cpath7
	rename traits4b13 cpath8
	rename traits5a13 cpath9
	rename traits5b13 cpath10
	

*Candidate Thermometer
		/**rename so common and include in reshape
		i.e. therm1, therm2, therm3 etc. 
		original: therm1_1 = thermometer for candidate A in vignette 1
		therm1_2 = therm of candidate B in Vignette 1, etc. 
		**/
	
	foreach var in therm1_1 therm1_2 therm2_1 therm2_2 therm3_1 ///
		therm3_2 therm4_1 therm4_2 therm5_1 therm5_2 {
		describe `var'
		tab `var'
			}
		/**For some reason, therm3_2 therm5_1 and therm5_2 are string variables
		rather than bytes; this may be due to the presence of a couple of 
		NA responses; these must be replaced and then the variable 
		destringed
		**/
		replace therm3_2 = "." if therm3_2 == "NA"
		destring therm3_2, gen(therm3_2a)
		
		replace therm5_1 = "." if therm5_1 == "NA"
		destring therm5_1, gen(therm5_1a)
		
		replace therm5_2 = "." if therm5_2 == "NA"
		destring therm5_2, gen(therm5_2a)
	
	rename therm1_1 ctherm1
	rename therm1_2 ctherm2
	rename therm2_1 ctherm3
	rename therm2_2 ctherm4
	rename therm3_1 ctherm5
	rename therm3_2a ctherm6
	rename therm4_1 ctherm7
	rename therm4_2 ctherm8
	rename therm5_1a ctherm9
	rename therm5_2a ctherm10
	
	foreach var in ctherm* {
		describe `var'
		}
	
	
*Candidate Choice
	foreach var in profile1 profile2 profile3 profile4 profile5 {
		tab `var'
	}
	
	/**Each choice hsa ~34-38 missing variables; these are first set to missing**/
	mvdecode profile1 profile2 profile3 profile4 profile5, mv(-99=.a)
	
	/**Then a DV is created for each candidate, which = 1 if the 
		respondent selected the cnaiddate in question
		profile* = 1 if Candidate A chosen;  = 2 if Candidate B is chosen**/
	
	*Vignette 1
		*Choice1 = Candidate A from Vignette 1
		gen choice1 =. 
		replace choice1 = 1 if profile1 == 1
		replace choice1 = 0 if profile1 == 2
		*Choice2 = Candidate B from Vignette1
		gen choice2 = . 
		replace choice2 = 1 if profile1 == 2
		replace choice2 = 0 if profile1 == 1

	*Vignette 2
		*Choice3 = Candidate A from Vignette2
		gen choice3 =. 
		replace choice3 = 1 if profile2 == 1
		replace choice3 = 0 if profile2 == 2
		*Choice4 = Candidate B from Vignette2
		gen choice4 =. 
		replace choice4 = 1 if profile2 == 2
		replace choice4 = 0 if profile2 == 1
	
	*Vignette 3
		*Choice 5: Candidate A
		gen choice5 = . 
		replace choice5 = 1 if profile3 == 1
		replace choice5 = 0 if profile3 == 2
		*Choice 6: Candidate B
		gen choice6 = . 
		replace choice6 = 1 if profile3 == 2
		replace choice6 = 0 if profile3 == 1
		
	*Vignette 4
		*Choice 7: Candidate A
		gen choice7 = . 
		replace choice7 = 1 if profile4 == 1
		replace choice7 = 0 if profile4 == 2
		*Choice 8: Candidate B
		gen choice8 = . 
		replace choice8 = 1 if profile4 == 2
		replace choice8 = 0 if profile4 == 1
	
	*Vignette 5
		*Choice 9: Candidate A
		gen choice9 = . 
		replace choice9 = 1 if profile5 == 1
		replace choice9 = 0 if profile5 == 2
		*Choice 10: Candidate B
		gen choice10 = . 
		replace choice10 = 1 if profile5 == 2
		replace choice10 = 0 if profile5 == 1

			***************************************
			**********Reshaping the Data***********
			***************************************	
			***************************************

/**This drops those respondents that did not take part in Survey 2**/
drop if _merge == 1

/**This will keep the variables we are interested in right now**/
keep responseid finished_2 gender hisp race race_eth ///
	party partyid pid_imp religion relig1 religion_imp ///
	cage* cgender* crace* coccup* cparty* cmilitary* ceduc* ///
	ctpp* cisis* ccap* ctaxes* cpath* crelig* ctherm* choice* ///
	path taxes captrade isis ///
	pathimp taxesimp capimp isisimp ///
	tpp_manip tpp tppimp 
	
		
/**reshape code**/
reshape long cage cgender crace crelig coccup cparty cmilitary ceduc ///
	ctpp cisis ccap ctaxes cpath ctherm choice time , i(responseid) j(cand)

	
			***************************************
			**********Coding Candidate ************
			**********Characteristics, pt. 2 ******	
			***************************************

	*Recoding ctherm on 0-1 scale
		gen ctherm01 =ctherm/100
		label var ctherm01 "Feeling Thermometer"
		
		label var choice "Candidate Choice"
			
/**Since the candidate characteristics (save for age) were string variables, they will be coded
	now after reshaping due to the simpler nature of the task**/
	
	*Candidate Age
		label var cage "Age"
	*Candidate Gender*
		gen c_gender = . 
		replace c_gender = 1 if cgender == "Female"
		replace c_gender = 0 if cgender == "Male"
		label def cgen 1 "Female" 0 "Male" 
		label values c_gender cgen
		label var c_gender "Candidate Gender"
	*Candidate Race
		gen c_race = .
		replace c_race = 1 if crace == "White"
		replace c_race = 2 if crace == "African American"
		replace c_race = 3 if crace == "Hispanic"
		replace c_race = 4 if crace == "Asian American"
		label def cra 1 "White" 2 "African American" 3 "Hispanic" 4 "Asian American"
		label values c_race cra
		label var c_race "Candidate Race"
		
	*Candidate Religion
		gen c_relig = .
		label def cre 1 "Mainline Protestant" 2 "Evangelical" 3 "Catholic" 4 "Jewish" ///
			5 "Muslim" 6 "None" 
		replace c_relig = 1 if crelig == "Mainline protestant" 
		replace c_relig = 2 if crelig == "Evangelical protestant" 
		replace c_relig = 3 if crelig == "Catholic"
		replace c_relig = 4 if crelig == "Jewish" 
		replace c_relig = 5 if crelig == "Muslim"
		replace c_relig = 6 if crelig == "None"
		label values c_relig cre
		label var c_relig "Candidate Religion"
	
		recode c_relig (1=0) (2=0) (3=0) (4=0) (5=1) (6=0), gen(c_relig1)
		label var c_relig1 "Candidate Religion"
		label def cre1 1 "Muslim" 0 "Non-Muslim"
		label values c_relig1 cre1
	
	*Candidate Occupation
		gen c_occ = .
		label def cop 1 "Governor" 2 "Member of Congress" 3 "Senator" 4 "CEO"
		replace c_occ = 1 if coccup == "State Governor"
		replace c_occ = 2 if coccup == "Member of Congress" 
		replace c_occ = 3 if coccup == "U.S. Senator" 
		replace c_occ = 4 if coccup == "CEO"
		label var c_occ "Candidate Occupation"
		label values c_occ cop
			
	*Candidate Party
		gen c_party = .
		label def cpa 1 "Democrat" 0 "Republican" 
		label var c_party "Candidate Party"
		replace c_party = 1 if cparty == "Democrat" 
		replace c_party = 0 if cparty == "Republican"
		label values c_party cpa
		
		gen same_party = .
		replace same_party = 1 if c_party == 1 & party == 2
		replace same_party = 1 if c_party == 0 & party == 1
		replace same_party = 2 if c_party == 1 & party == 1
		replace same_party = 2 if c_party == 0 & party == 2			
		replace same_party = 3 if party >=3 & party <=4
		label var same_party "Party Match" 
		label def part 1 "Same Party" 2 "Different Party" 3 "Independent" 
		label values same_party part
			

	*Candidate Military Service
		gen c_military = . 
		label def cmil 1 "Served in Military" 0 "Did Not Serve"
		replace c_military = 1 if cmilitary == "Served" 
		replace c_military = 0 if cmilitary == "Did not serve"
		label values c_military cmil
		label var c_military "Candidate Military Service"
	
	*Candidate Education
		gen c_educ = .
		label var c_educ "Candidate Education"
		label def ced 1 "Community College" 2 "Small College" 3 "State University" 4 "Ivy League" 
		replace c_educ = 1 if ceduc == "Community college"
		replace c_educ = 2 if ceduc == "Small college"
		replace c_educ = 3 if ceduc == "State university"
		replace c_educ = 4 if ceduc == "Ivy League university"
		label values c_educ ced	
	
	*Candidate Issues
		/**The coding of each variable is akin to the individual level coding, 
			such that high = conservative
			*high=oppose for: tpp, cap& trade, taxes on rich, pathway
			*high=support for: isis, **/
		
		label def opphigh1 1 "Strongly Support"  2 "Moderately Support" 3 "Slightly Support" ///
			4 "Neither" 5 "Slightly Oppose" 6 "Moderately Oppose" 7 "Strongly Oppose"
		
		foreach var in ctpp ccap ctaxes cpath {
			gen c_`var' = . 
			replace c_`var' =  1 if `var' == "Strongly support"
			replace c_`var' =  2 if `var' == "Moderately support"
			replace c_`var' =  3 if `var' == "Slightly support"
			replace c_`var' =  4 if `var' == "Neither Support Nor Oppose"
			replace c_`var' =  5 if `var' == "Slightly oppose"
			replace c_`var' =  6 if `var' == "Moderately oppose"
			replace c_`var' =  7 if `var' == "Strongly oppose"
			label values c_`var' opphigh1
			}
		
		label def opplow 7 "Strongly Support"  6 "Moderately Support" 5 "Slightly Support" ///
			4 "Neither" 3 "Slightly Oppose" 2 "Moderately Oppose" 1 "Strongly Oppose"
		gen c_cisis = . 
			replace c_cisis =  7 if cisis == "Strongly support"
			replace c_cisis =  6 if cisis == "Moderately support"
			replace c_cisis =  5 if cisis == "Slightly support"
			replace c_cisis =  4 if cisis == "Neither Support Nor Oppose"
			replace c_cisis =  3 if cisis == "Slightly oppose"
			replace c_cisis =  2 if cisis == "Moderately oppose"
			replace c_cisis =  1 if cisis == "Strongly oppose"
			label values c_cisis opplow
		
		
			label var c_ctpp "TPP" 
			label var c_ccap "Cap & Trade" 
			label var c_ctaxes "Taxes on Rich" 
			label var c_cpath "Immigration"
			label var c_cisis "ISIS"
			
		*Proximity
			gen prox_tpp_inverse = abs(tpp - c_ctpp)
			gen prox_cap_inverse = abs(captrade - c_ccap)
			gen prox_taxes_inverse = abs(taxes - c_ctaxes)
			gen prox_path_inverse = abs(path - c_cpath)
			gen prox_isis_inverse = abs(isis - c_cisis)
				
				foreach var in prox_tpp_inverse prox_cap_inverse prox_taxes_inverse ///
					prox_path_inverse prox_isis_inverse {
						tab `var'
					}
			/**Proximity Scores: high = high proximity; 6 = equal position**/
			gen prox_tpp = abs(6 - prox_tpp_inverse)
				label var prox_tpp "TPP Proximity"
			gen prox_cap = abs(6- prox_cap_inverse)
				label var prox_cap "Cap & Trade Proximity"
			gen prox_taxes = abs(6 - prox_taxes_inverse)
				label var prox_taxes "Taxes on Rich Proximity"
			gen prox_path = abs(6 - prox_path_inverse)
				label var prox_path "Immigration Proximity"
			gen prox_isis = abs(6 - prox_isis_inverse)
				label var prox_isis "ISIS Proximity"
				
			
			***************************************
			***************Analyses***************
			***************************************	
			***************************************

**Candidate Choice & Feeling Thermometer
	*Regression Results
	eststo clear
	eststo: regress choice cage i.c_gender i.c_race i.c_relig i.c_occ i.c_party ///
		i.c_military i.c_educ c_ctpp c_ccap c_ctaxes c_cpath c_cisis, cluster(responseid)
			estimates store ALL
	eststo: regress ctherm01 cage i.c_gender i.c_race i.c_relig i.c_occ i.c_party ///
		i.c_military i.c_educ c_ctpp c_ccap c_ctaxes c_cpath c_cisis, cluster(responseid)
			estimates store ALL_THERM
	esttab using MARGINALEFFECTS.rtf, onecell label se ar2 star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
	eststo clear
	
	*Muslim vs. Non-Muslim*
	regress choice cage i.c_gender i.c_race i.c_relig1 i.c_occ i.c_party ///
		i.c_military i.c_educ c_ctpp c_ccap c_ctaxes c_cpath c_cisis, cluster(responseid)
	
	*Plotting the Results
		*All at Once
			coefplot ALL, bylabel(Choice) || ALL_THERM, bylabel(Feeling Them) || , scheme(s1mono) base xline(0, lpattern(dash)) ysize(8) drop(_cons) ///
				headings(cage="{bf:Age}" 0.c_gender="{bf:Gender}" 1.c_race="{bf:Race}" 1.c_relig="{bf:Religion}" 1.c_occ="{bf:Occupation}" ///
					0.c_party="{bf:Party}" 0.c_military="{bf:Military}" 1.c_educ="{bf:Education}" c_ctpp="{bf:Issues}")
					
					graph save "Marginal Effects - All", replace
					graph export "Marginal Effects - All.png"
	
/*Figure OA8*/
*All at once, continuous variables standardized at 2sd (Gelman 2008)
summ cage
gen cage2sd = (cage-r(mean))/(2*r(sd))
summ c_ctpp
gen tpp2sd = (c_ctpp-r(mean))/(2*r(sd))
summ c_cpath 
gen path2sd = (c_cpath-r(mean))/(2*r(sd))
summ c_ctaxes
gen taxes2sd = (c_ctaxes-r(mean))/(2*r(sd))
summ c_cisis 
gen isis2sd = (c_cisis-r(mean))/(2*r(sd))
summ c_ccap
gen cap2sd = (c_ccap - r(mean))/(2*r(sd))

label var tpp2sd "TPP" 
label var cap2sd "Cap & Trade" 
label var taxes2sd "Taxes on Rich" 
label var path2sd "Immigration"
label var isis2sd "ISIS"
label var cage2sd "Age" 
				
eststo clear
eststo: regress choice cage2sd i.c_gender i.c_race i.c_relig i.c_occ i.c_party ///
	i.c_military i.c_educ tpp2sd cap2sd taxes2sd path2sd isis2sd, cluster(responseid)
		estimates store ALL_2sd
eststo: regress ctherm01 cage2sd i.c_gender i.c_race i.c_relig i.c_occ i.c_party ///
	i.c_military i.c_educ tpp2sd cap2sd taxes2sd path2sd isis2sd, cluster(responseid)
		estimates store ALL_THERM_2sd
esttab using MARGINALEFFECTS_2SD.rtf, onecell label se ar2 star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
eststo clear
				
coefplot ALL_2sd, bylabel(Choice) || ALL_THERM_2sd, bylabel(Feeling Them) || , scheme(s1mono) base xline(0, lpattern(dash)) ysize(8) drop(_cons) ///
	headings(cage2sd="{bf:Age}" 0.c_gender="{bf:Gender}" 1.c_race="{bf:Race}" 1.c_relig="{bf:Religion}" 1.c_occ="{bf:Occupation}" ///
		0.c_party="{bf:Party}" 0.c_military="{bf:Military}" 1.c_educ="{bf:Education}" tpp2sd="{bf:Issues}")
		
		graph save "Marginal Effects - All 2SD", replace
		graph export "Marginal Effects - All 2SD.png"
	
			
*Relationship between thermometer and choice
logit choice c.ctherm, cluster(responseid)
margins, at(ctherm=(0(10)100)) 
marginsplot, scheme(s1mono) xtitle(Feeling Thermometer Rating of Candidate) 

	
/****Figure OA9*****/
eststo clear
eststo: regress choice i.c_party##i.party, cluster(responseid) 
	margins , dydx(c_party) by(party) post
	estimates store PID1
eststo: regress choice i.same_party, cluster(responseid)
	margins , dydx(same_party) post
	estimates store PID2
eststo: regress choice i.same_party cage i.c_gender i.c_race i.c_relig i.c_occ i.c_party ///
i.c_military i.c_educ c_ctpp c_ccap c_ctaxes c_cpath c_cisis, cluster(responseid)

esttab using COPARTISANSHIP.rtf, onecell label se ar2 star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
eststo clear

coefplot PID1,  scheme(s1mono) xline(0, lpattern(dash)) ///
	title("Effect of Cand. Party by Respondent PID", size(medium))
	graph save "PID1", replace

coefplot PID2, scheme(s1mono) xline(0, lpattern(dash))  base ///
	title("Effect of Co-Partisanship on Choice" , size(medium))
	graph save "PID2", replace
	
graph combine "PID1" "PID2" , rows(2) scheme(s1mono)
				


****Proximity
eststo clear
eststo: regress choice prox_tpp prox_cap prox_taxes prox_path prox_isis , cluster(responseid)
	estimates store PROX
eststo: regress choice prox_tpp prox_cap prox_taxes prox_path prox_isis if same_party == 1 , cluster(responseid)
	estimates store PROX_SAME
eststo: regress choice prox_tpp prox_cap prox_taxes prox_path prox_isis if same_party == 2 , cluster(responseid)
	estimates store PROX_DIFF
eststo: regress choice prox_tpp prox_cap prox_taxes prox_path prox_isis if same_party == 3, cluster(responseid)
	estimates store PROX_IND
esttab using PROX.rtf, onecell label se ar2 star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
eststo clear

coefplot PROX, bylabel(All)  || PROX_SAME , bylabel(Same Party as Cand) || ///
	PROX_DIFF, bylabel(Diff Party as Cand) || PROX_IND, bylabel(Resp. is Ind) ||, scheme(s1mono) drop(_cons) xline(0, lpattern(dash))


foreach var in prox_tpp prox_cap prox_taxes prox_path prox_isis {
	regress choice c.`var'##i.same_party, cluster(responseid)
	}
			

***Importance as Moderator	(Table OA6 & Figure OA12)****
	*All
	eststo clear
	eststo: regress choice prox_tpp prox_cap prox_taxes prox_path prox_isis , cluster(responseid)
	
	eststo: regress choice c.prox_tpp##c.tppimp prox_cap prox_taxes prox_path prox_isis , cluster(responseid)
		margins, dydx(prox_tpp) at(tppimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title(TPP) xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "tpp_imp", replace
	
	eststo: regress choice prox_tpp c.prox_cap##c.capimp prox_taxes prox_path prox_isis , cluster(responseid)
		margins, dydx(prox_cap) at(capimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("Cap & Trade") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "cap_imp", replace
		

	eststo: regress choice prox_tpp prox_cap c.prox_taxes##c.taxesimp prox_path prox_isis , cluster(responseid)
		margins, dydx(prox_taxes) at(taxesimp=(1(1)5))
		marginsplot, scheme(s1mono) title("Taxes on Rich") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "taxes_imp", replace
		
		
	eststo: regress choice prox_tpp prox_cap prox_taxes c.prox_path##c.pathimp prox_isis , cluster(responseid)
		margins, dydx(prox_path) at(pathimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("Immigration") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "imm_imp", replace
		
	eststo: regress choice prox_tpp prox_cap prox_taxes prox_path c.prox_isis##c.isisimp , cluster(responseid)
		margins, dydx(prox_isis) at(isisimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("ISIS") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "isis_imp", replace
		
	esttab using PROXIMP.rtf, onecell label se ar2 star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
	eststo clear
			
	graph combine "tpp_imp" "cap_imp" "taxes_imp" "imm_imp" "isis_imp", rows(2) scheme(s1mono) xsize(8)

/*by partisanship*/
	*Co-Partisans
	eststo clear
	eststo: regress choice prox_tpp prox_cap prox_taxes prox_path prox_isis if same_party==1, cluster(responseid)
	
	eststo: regress choice c.prox_tpp##c.tppimp prox_cap prox_taxes prox_path prox_isis , cluster(responseid)
		margins, dydx(prox_tpp) at(tppimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title(TPP) xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "tpp_impS", replace
	
	eststo: regress choice prox_tpp c.prox_cap##c.capimp prox_taxes prox_path prox_isis if same_party==1 , cluster(responseid)
		margins, dydx(prox_cap) at(capimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("Cap & Trade") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "cap_impS", replace
		

	eststo: regress choice prox_tpp prox_cap c.prox_taxes##c.taxesimp prox_path prox_isis if same_party==1, cluster(responseid)
		margins, dydx(prox_taxes) at(taxesimp=(1(1)5))
		marginsplot, scheme(s1mono) title("Taxes on Rich") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "taxes_impS", replace
		
		
	eststo: regress choice prox_tpp prox_cap prox_taxes c.prox_path##c.pathimp prox_isis if same_party==1, cluster(responseid)
		margins, dydx(prox_path) at(pathimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("Immigration") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "imm_impS", replace
		
	eststo: regress choice prox_tpp prox_cap prox_taxes prox_path c.prox_isis##c.isisimp if same_party==1, cluster(responseid)
		margins, dydx(prox_isis) at(isisimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("ISIS") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "isis_impS", replace
		
	esttab using PROXIMP_SAME.rtf, onecell label se ar2 star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
	eststo clear
			
	graph combine "tpp_impS" "cap_impS" "taxes_impS" "imm_impS" "isis_impS", rows(2) scheme(s1mono) xsize(8)
	
	*different
		eststo clear
	eststo: regress choice prox_tpp prox_cap prox_taxes prox_path prox_isis if same_party==2, cluster(responseid)
	
	eststo: regress choice c.prox_tpp##c.tppimp prox_cap prox_taxes prox_path prox_isis , cluster(responseid)
		margins, dydx(prox_tpp) at(tppimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title(TPP) xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "tpp_impD", replace
	
	eststo: regress choice prox_tpp c.prox_cap##c.capimp prox_taxes prox_path prox_isis if same_party==2 , cluster(responseid)
		margins, dydx(prox_cap) at(capimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("Cap & Trade") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "cap_impD", replace
		

	eststo: regress choice prox_tpp prox_cap c.prox_taxes##c.taxesimp prox_path prox_isis if same_party==2, cluster(responseid)
		margins, dydx(prox_taxes) at(taxesimp=(1(1)5))
		marginsplot, scheme(s1mono) title("Taxes on Rich") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "taxes_impD", replace
		
		
	eststo: regress choice prox_tpp prox_cap prox_taxes c.prox_path##c.pathimp prox_isis if same_party==2, cluster(responseid)
		margins, dydx(prox_path) at(pathimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("Immigration") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "imm_impD", replace
		
	eststo: regress choice prox_tpp prox_cap prox_taxes prox_path c.prox_isis##c.isisimp if same_party==2, cluster(responseid)
		margins, dydx(prox_isis) at(isisimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("ISIS") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "isis_impD", replace
		
	esttab using PROXIMP_DIFF.rtf, onecell label se ar2 star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
	eststo clear
			
	graph combine "tpp_impD" "cap_impD" "taxes_impD" "imm_impD" "isis_impD", rows(2) scheme(s1mono) xsize(8)
	
	
	*INd
		eststo clear
	eststo: regress choice prox_tpp prox_cap prox_taxes prox_path prox_isis if same_party==3, cluster(responseid)
	
	eststo: regress choice c.prox_tpp##c.tppimp prox_cap prox_taxes prox_path prox_isis , cluster(responseid)
		margins, dydx(prox_tpp) at(tppimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title(TPP) xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "tpp_impI", replace
	
	eststo: regress choice prox_tpp c.prox_cap##c.capimp prox_taxes prox_path prox_isis if same_party==3 , cluster(responseid)
		margins, dydx(prox_cap) at(capimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("Cap & Trade") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "cap_impI", replace
		

	eststo: regress choice prox_tpp prox_cap c.prox_taxes##c.taxesimp prox_path prox_isis if same_party==3, cluster(responseid)
		margins, dydx(prox_taxes) at(taxesimp=(1(1)5))
		marginsplot, scheme(s1mono) title("Taxes on Rich") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "taxes_impI", replace
		
		
	eststo: regress choice prox_tpp prox_cap prox_taxes c.prox_path##c.pathimp prox_isis if same_party==3, cluster(responseid)
		margins, dydx(prox_path) at(pathimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("Immigration") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "imm_impI", replace
		
	eststo: regress choice prox_tpp prox_cap prox_taxes prox_path c.prox_isis##c.isisimp if same_party==3, cluster(responseid)
		margins, dydx(prox_isis) at(isisimp=(1(1)5)) 
		marginsplot, scheme(s1mono) title("ISIS") xtitle("") ytitle("") yline(0, lpattern(dash))
		graph save "isis_impI", replace
		
	esttab using PROXIMP_IND.rtf, onecell label se ar2 star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
	eststo clear
			
	graph combine "tpp_impI" "cap_impI" "taxes_impI" "imm_impI" "isis_impI", rows(2) scheme(s1mono) xsize(8)
	
	
	
	