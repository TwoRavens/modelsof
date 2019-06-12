/******************************************************************************
The following .do file contains the code needed to replicate (most) of our
conjoint experiment analyses. This do file focuses on the analyses using 
relative measures of proximity. Here, we ultimately reshape the data so that
each row is a respondent/vignette pairing. Note that we also provide the 
panel attrition analyses here. 

Elsewhere in Online Appendix we fully stack the data so that each row is a 
respondent/candidate pairing, yielding double the number of rows. This data 
is used in the analyses presented in Figures OA8 and OA9 as well as in 
Table OA6 and Figure OA12. The code for those analyses is presnted in a different 
do file because it requires a differnet reshape process and coding procedure. 

The code below will code relevant variables, investiate panel attrition 
(e.g. Figures OA1 and OA2), reshape and clean the data for analysis
and analyze it. 

	ssc install coefplot
	ssc install combomarginsplot
	ssc install grc1leg


******************************************************************************/

clear
cd "C:\Users\Joshua\Dropbox\Work\Isssue Importance and Voting Paper\Dataverse"
use "Conjoint Experiment Data.dta"
set more off

			***************************************
			****Individiaul Level Variables********
			***************************************	
			***************************************

********Background Variables
	label var responseid "Respondent ID (Survey 1)"
	label var finished_2 "Finished (Survey 2)"
	label var _merge "Merge Status"
			
*TPP Randomization Variables
	label def tpmanip 1 "Baseline" 2 "Low Importance" 3 "High Importance"
	gen tpp_manip = . 
	replace tpp_manip = 1 if dobrfl_23 == "TPP (1)"
	replace tpp_manip = 1 if dobrfl_23 == "TPP (2)"
	replace tpp_manip = 1 if dobrfl_23 == "TPP (3)"
	replace tpp_manip = 1 if dobrfl_23 == "TPP (4)"
	replace tpp_manip = 2 if dobrfl_23 == "TPP Low Imp (1)"
	replace tpp_manip = 2 if dobrfl_23 == "TPP Low Imp (2)"
	replace tpp_manip = 2 if dobrfl_23 == "TPP Low Imp (3)"
	replace tpp_manip = 2 if dobrfl_23 == "TPP Low Imp (4)"
	replace tpp_manip = 3 if dobrfl_23 == "TPP High Imp (1)"
	replace tpp_manip = 3 if dobrfl_23 == "TPP High Imp (2)"
	replace tpp_manip = 3 if dobrfl_23 == "TPP High Imp (3)"
	replace tpp_manip = 3 if dobrfl_23 == "TPP High Imp (4)"
	label var tpp_manip "TPP Importance Manipulation"	
	label values tpp_manip tpmanip
		
				************************
				****Issue Attitudes*****	
				************************
	
***Recoded so that high = conservative stereotyped responses

label def opp_high 1 "Strongly Support" 2 "Moderately Support" 3 "Somewhat Support" ///
	4 "Neither" 5 "Somewhat Oppose" 6 "Moderately Oppose" 7 "Strongly Oppose"

**Immigration
	/**
	Statement: Illegal immigrants brought to the US as children should be allowed 
				to apply for citizenship.
	high = oppose
	**/

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

			
		************************
		****Issue Importance****	
		************************
**we randomized the order of the question and response options, hence
**the complicated code below
**Code so that high = extremely important

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
			
*Importance	
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
	
				************************
				*********TPP************
				************************
	
*Issue Attitude
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
			
				*****************************
				****Background Variables*****
				*****************************

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

*Ideology
	mvdecode ideology_1, mv(-99=.a)
	rename ideology_1 ideol 
	label def ideo 1 "Ext. Liberal" 2 "Moderately Liberal" 3 "Slightly Liberal" ///
		4 "Moderate" 5 "Slightly Conservative" 6 "Moderately Conservative" 7 "Extremely Conservative"
	label values ideol ideo
	label var ideol "Ideology"
	
	recode ideol (1=1) (2=1) (3=1) (4=2) (5=3) (6=3) (7=3), gen(ideol_3)
	label def ideo1 1 "Liberal" 2 "Moderate" 3 "Conservative"
	label values ideol_3 ideo1
	
	by finished, sort: tab ideol_3
	by finished_2, sort: tab ideol_3
	by finished, sort: summ ideol
	by finished_2, sort: summ ideol
	
*Vote Choice/Candidate Preference

	*Did R Vote?
		recode vote (1=1) (2=0) (-99=.), gen(voted)
		label def vot 1 "Voted" 0 "Did Not Vote"
		label values voted vot
		label var voted "Voted?"
		
		by finished, sort: tab voted
		by finished_2, sort: tab voted

	*Vote Choice
		mvdecode votechoice, mv(-99=.a)
		label def votc 1 "Donald Trump" 2 "Hillary Clinton" 3 "Evan McMullin" ///
			4 "Jill Stein" 5 "Gary Johnson" 6 "Other" 
		label values votechoice votc
		
		by finished, sort: tab votechoice
		by finished_2, sort: tab votechoice
	
	*Candidate Preference (non-voters)
		label var pref "Candidate Pref.?"
		label def pre 1 "Yes" 2 "No"
		label values pref pre
		
		label values pref_choice votc
		
		by finished, sort: tab pref
		by finished, sort: tab pref_choice
		by finished_2, sort: tab pref
		by finished_2, sort: tab pref_choice
		

*Political Interest
	label def inte 1 "Not Interested at All" 2 "Slightly Interested" 3 "Moderately Interested" ///
		4 "Very Interested" 5 "Extremely Interested"
	gen interest = . 
	replace interest = 1  if interest1 == 5
	replace interest = 2  if interest1 == 4
	replace interest = 3  if interest1 == 3
	replace interest = 4  if interest1 == 2
	replace interest = 5  if interest1 == 1
	replace interest = 1 if interest2 == 5
	replace interest = 2 if interest2 == 4
	replace interest = 3 if interest2 == 3
	replace interest = 4 if interest2 == 2
	replace interest = 5 if interest2 == 1
	label var interest "Political Interest"
	label values interest inte
	
	by finished, sort: summ interest
	by finished, sort: tab interest		
	by finished_2, sort: summ interest
	by finished_2, sort: tab interest
	
*Age
*we asked people to give their age and, of course, some did this in 
*non-numerical formats. hence we need to replace with the year manually
*and then de-string

	gen birth1 = birth
	replace birth1 = "1980" if birth1 == "9/9/1980"
	replace birth1 = "1985" if birth1 == ",1985"
	replace birth1 = "1981"   if birth1 == "09 08 1981"
	replace birth1 = "1985"  if birth1 == "10/1/1985"
	replace birth1 = "1983"   if birth1 == "10/10/1983"
	replace birth1 = "1982"    if birth1 == "10/11/1982"
	replace birth1 = "1962"   if birth1 == "10/17/1962"
	replace birth1 = "1985"   if birth1 == "11 de febrero de 1985"
	replace birth1 = "1978"   if birth1 == "7/04/1978"
	replace birth1 = "1987"   if birth1 == "19/09/1987"
	replace birth1 = "1997"   if birth1 == "1997 08 10"
	replace birth1 = "1980"   if birth1 == "2/21/1980"
	replace birth1 = "1984"   if birth1 == "28/03/1984"
	replace birth1 = "1958"   if birth1 == "4/14/1958"
	replace birth1 = "1982"   if birth1 == "5 4 1982"
	replace birth1 = "1982"   if birth1 == "5/10/1982"
	replace birth1 = "1977"   if birth1 == "6/14/1977"
	replace birth1 = "1970"   if birth1 == "9/1/1970"
	replace birth1 = "1978" if birth1 == "17/04/1978"
	replace birth1 = "."   if birth1 == "good"
	replace birth1 = "."   if birth1 == "very good"
	replace birth1 = "-99" if birth1 == "."
	destring birth1, gen(birth2)
	mvdecode birth2, mv(-99=.a)
	label var birth2 "Birth Year"
	
	gen age = 2016 - birth2
	label var age "Age" 
	
	by finished, sort: summ age, detail
	by finished_2, sort: summ age, detail
	
	gen age_cat = .
	replace age_cat = 1  if age >= 18  & age <= 24
	replace age_cat = 2  if age >= 25  & age <= 34
	replace age_cat = 3  if age >= 35  & age <= 44
	replace age_cat = 4  if age >= 45  & age <= 54
	replace age_cat = 5  if age >= 55  & age <= 64
	replace age_cat = 6  if age >= 65  & age <= 73
	label var age_cat "Age (Categorical)"
	label def ag1 1 "18-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65+"
	label values age_cat ag1
	
	by finished, sort: tab age_cat
	by finished_2, sort: tab age_cat

    
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
	

*Income
	mvdecode income, mv(-99=.a)
	label var income "Household Income"
	label def inc 1 "<10,000" 2 "10,000-19,999" 3 "20,000-29,999" 4 "30,000-39,999" ///
		5 "40,000-49,999" 6 "50,000-59,999" 7 "60,000-69,999" 8 "70,000-79,999" ///
		9 "80,000-89,999" 10 "90,000-99,9999" 11 "100,000-149,999" 12 "150,000+"
	label values income inc
		
		
	by finished, sort: summ income, detail
	by finished_2, sort: summ income, detail
		
	
*Occupation
	label def occ1 1 "Working (paid employee)" 2 "Working (self-employed)" 3 "Not Working (temp laid off)" ///
		4 "Not Working (looking for work)" 5 "Not working (retired)" 6 "Not working (disabled)" ///
		7 "Not Working (other)" 8 "Prefer Not to Answer" 
		label values occupation occ1
		mvdecode occupation, mv(-99=.a)
		
		by finished, sort: tab occupation
		by finished_2, sort: tab occupation


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
	
	
	
*Education
	label def edu 1 "<HS" 2 "HS Grad" 3 "Some College, No Degree" 4 "Associate" 5 "Bachelor's" 6 "Master's" 7 "Doctoral" 8 "Professional"
	label values education edu
	mvdecode education, mv(-99=.a)
	
	by finished, sort: tab education
	by finished_2, sort: tab education

	label def ed1 1 "HS Grad & Below" 2 "Some College" 3" Associate Degree" 4 "Bachelor's Degree" 5 "Advanced Degree"
	gen educ = .
	replace educ = 1 if education >=1 & education <= 2
	replace educ = 2 if education == 3
	replace educ = 3 if education == 4 
	replace educ = 4 if education == 5
	replace educ = 5 if education >= 6 & education <= 7
	label var educ "Education"
	label values educ ed1
				
				
			/***************************************
			Panel Attrition: 
			Here, we analyze who participated in 
			both waves versus just the first. 
			Figures OA1 and OA2
			***************************************/
				
recode _merge (1=1) (3=0), gen(attrition)
label def attrit 0 "Participated in Both Surveys" 1 "Participtaed in Only Survey 1"
label values attrition attrit
tab attrition

logit attrition i.gender i.race_eth i.educ income c.age partyid pid_imp ideol interest i.relig1
	estimates store DEMO
	margins, dydx(*) post
	estimates store DEMOCOEF
	
coefplot DEMO, bylabel(Coefficient) ||  DEMOCOEF, bylabel(AME) ||, scheme(s1mono) xline(0, lpattern(dash)) drop(_cons) byopts(xrescale)

logit attrition i.gender i.race_eth i.educ income c.age partyid pid_imp ideol interest i.relig1
	margins, at(age=(18(5)73))
	marginsplot
	
	
logit attrition i.tpp_manip tpp tppimp guns taxes path captrade isis voucher medicare gunsimp pathimp taxesimp capimp isisimp voucherimp medicareimp
	estimates store ATT
	margins, dydx(*) post
	estimates store ATT1
	
coefplot ATT, bylabel(Coefficient) ||  ATT1, bylabel(AME) ||, scheme(s1mono) xline(0, lpattern(dash)) drop(_cons) byopts(xrescale)



			
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
	
/**the next step is to rename the traits for reshaping, 
after which new versions will be created because the originals are in 
string form currently (save for age)
**/

/**the general form here is a_var1, a_var2, b_var1, and b_var2
a refers to candidate a, b to candidate b and the numerals to the vignette (1-5)**/

		*Age*
			*Vignette 1
				rename traits1a1 a_age1
				rename traits1b1 b_age1				
			*Vignette 2
				rename traits2a1 a_age2 
				rename traits2b1 b_age2
			*Vignette 3
				rename traits3a1 a_age3 
				rename traits3b1 b_age3 
			*Vignette 4
				rename traits4a1 a_age4
				rename traits4b1 b_age4
			*Vignette 5
				rename traits5a1 a_age5
				rename traits5b1 b_age5
			
		*Candidate Race
			*Vignette 1
				rename traits1a3 a_race1
				rename traits1b3 b_race1
			*Vignette 2
				rename traits2a3 a_race2	
				rename traits2b3 b_race2
			*Vignette 3
				rename traits3a3 a_race3
				rename traits3b3 b_race3
			*Vignette 4
				rename traits4a3 a_race4
				rename traits4b3 b_race4
			*Vignette 5
				rename traits5a3 a_race5
				rename traits5b3 b_race5
		
		*Candidate Religion
			*Vignette 1
				rename traits1a4 a_relig1
				rename traits1b4 b_relig1
			*Vignette 2
				rename traits2a4 a_relig2
				rename traits2b4 b_relig2
			*Vignette 3
				rename traits3a4 a_relig3
				rename traits3b4 b_relig3
			*Vignette 4
				rename traits4a4 a_relig4
				rename traits4b4 b_relig4
			*Vignette 5
				rename traits5a4 a_relig5
				rename traits5b4 b_relig5
					
		*Candidate Party
			*Vignette 1
				rename traits1a6 a_party1
				rename traits1b6 b_party1
			*Vignette 2
				rename traits2a6 a_party2
				rename traits2b6 b_party2
			*Vignette 3
				rename traits3a6 a_party3
				rename traits3b6 b_party3
			*Vignette 4
				rename traits4a6 a_party4
				rename traits4b6 b_party4
			*Vignette 5
				rename traits5a6 a_party5
				rename traits5b6 b_party5
		
		
		*Issues
			*Candidate: TPP
				*Vignette 1
					rename traits1a9 a_tpp1
					rename traits1b9 b_tpp1
				*Vignette 2
					rename traits2a9 a_tpp2
					rename traits2b9 b_tpp2
				*Vignette 3
					rename traits3a9 a_tpp3
					rename traits3b9 b_tpp3
				*Vignette 4
					rename traits4a9 a_tpp4
					rename traits4b9 b_tpp4
				*Vignette 5
					rename traits5a9 a_tpp5
					rename traits5b9 b_tpp5
			
			
			*Candidate: ISIS
				*Vignette 1
					rename traits1a10 a_isis1
					rename traits1b10 b_isis1
				*Vignette 2
					rename traits2a10 a_isis2
					rename traits2b10 b_isis2
				*Vignette 3
					rename traits3a10 a_isis3
					rename traits3b10 b_isis3
				*Vignette 4
					rename traits4a10 a_isis4
					rename traits4b10 b_isis4
				*Vignette 5
					rename traits5a10 a_isis5
					rename traits5b10 b_isis5
					
					
			*Candidate Cap & Trade
				*Vignette 1
					rename traits1a11 a_cap1
					rename traits1b11 b_cap1
				*Vignette 1
					rename traits2a11 a_cap2
					rename traits2b11 b_cap2
				*Vignette 1
					rename traits3a11 a_cap3
					rename traits3b11 b_cap3
				*Vignette 1
					rename traits4a11 a_cap4
					rename traits4b11 b_cap4
				*Vignette 1
					rename traits5a11 a_cap5
					rename traits5b11 b_cap5
			
			*Candidate Taxes on Rich
				*Vignette 1
					rename traits1a12 a_taxes1
					rename traits1b12 b_taxes1
				*Vignette 2
					rename traits2a12 a_taxes2
					rename traits2b12 b_taxes2
				*Vignette 3
					rename traits3a12 a_taxes3
					rename traits3b12 b_taxes3
				*Vignette 4
					rename traits4a12 a_taxes4
					rename traits4b12 b_taxes4
				*Vignette 5
					rename traits5a12 a_taxes5
					rename traits5b12 b_taxes5
			
			*Candidate Path to Citizenship
				*Vignette 1
					rename traits1a13 a_path1
					rename traits1b13 b_path1
				*Vignette 2
					rename traits2a13 a_path2
					rename traits2b13 b_path2
				*Vignette 3
					rename traits3a13 a_path3
					rename traits3b13 b_path3
				*Vignette 4
					rename traits4a13 a_path4
					rename traits4b13 b_path4
				*Vignette 5
					rename traits5a13 a_path5
					rename traits5b13 b_path5
			

	*Candidate Thermometer
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
		
		
		*Vignette 1
			rename therm1_1 a_therm1
			rename therm1_2 b_therm1
		*Vignette 2
			rename therm2_1 a_therm2
			rename therm2_2 b_therm2
		*Vignette 3
			rename therm3_1 a_therm3
			rename therm3_2a b_therm3
		*Vignette 4
			rename therm4_1 a_therm4
			rename therm4_2 b_therm4
		*Vignette 5
			rename therm5_1a a_therm5
			rename therm5_2a b_therm5
	
	*Candidate Choice
		/**Each choice has ~34-38 missing variables; these are first set to missing**/
		mvdecode profile1 profile2 profile3 profile4 profile5, mv(-99=.a)
				
	
*Vignette Timings*
rename tprof1_3 time1
rename tprof2_3 time2
rename tprof3_3 time3
rename tprof4_3 time4
rename tprof5_3 time5
	
	
			***************************************
			**********Reshaping the Data***********
			***************************************	
			***************************************
			

/**This drops those respondents that did not take part in Survey 2**/
drop if _merge == 1

/**This will keep the variables we are interested in right now**/
keep responseid finished_2 tpp_manip ///
	path taxes captrade isis tpp ///
	pathimp taxesimp capimp isisimp tppimp ///
	party partyid pid_imp party_ext ///
	ideol ideol_3 interest age age_cat ///
	gender race race_eth income religion relig1 ///
	education educ ///
	a_age* b_age* ///
	a_race* b_race* ///
	a_relig* b_relig* ///
	a_party* b_party* ///
	a_tpp* b_tpp* ///
	a_isis* b_isis* ///
	a_cap* b_cap* ///
	a_taxes* b_taxes* ///
	a_path*  b_path* ///
	a_therm* b_therm* profile* time*

/**Reshaping so that each row is a respondent/vignette**/
reshape long a_age  b_age  ///
	a_race  b_race  ///
	a_relig  b_relig  ///
	a_party  b_party  ///
	a_tpp  b_tpp  ///
	a_isis  b_isis  ///
	a_cap  b_cap  ///
	a_taxes  b_taxes  ///
	a_path   b_path  ///
	a_therm b_therm profile time , i(responseid) j(vignette)

			***************************************
			**********Coding Candidate ************
			**********Characteristics, pt. 2 ******	
			***************************************
			
	*Candidate Choice*
		/**Coded to that 1 = Candidate B, 0 = Candidate A**/
			recode profile (1=0) (2=1), gen(choice)
			label def cho 1 "Candidate B" 0 "Candidate A"
			label values choice cho
			label var choice "Candidate Choice"
	
	*Comparative Feeling Thermometers*
			gen therm_comp = b_therm - a_therm
			label var therm_comp "Comparative Thermometer"
			
			summ therm_comp 
			gen therm_comp01 = (therm_comp - r(min))/(r(max)-r(min))
			label var therm_comp01 "Comparative Thermometer"
			
	*Relative Proximity
		*Candidate Issue Stances*
			
			label def opphigh1 1 "Strongly Support"  2 "Moderately Support" 3 "Slightly Support" ///
				4 "Neither" 5 "Slightly Oppose" 6 "Moderately Oppose" 7 "Strongly Oppose"
			
			foreach var in a_tpp b_tpp a_cap b_cap a_taxes b_taxes a_path b_path {
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
		
			foreach var in a_isis b_isis {
				gen c_`var' = . 
				replace c_`var' =  7 if `var' == "Strongly support"
				replace c_`var' =  6 if `var' == "Moderately support"
				replace c_`var' =  5 if `var' == "Slightly support"
				replace c_`var' =  4 if `var' == "Neither Support Nor Oppose"
				replace c_`var' =  3 if `var' == "Slightly oppose"
				replace c_`var' =  2 if `var' == "Moderately oppose"
				replace c_`var' =  1 if `var' == "Strongly oppose"
				label values c_`var' opplow
				}
			
		
		*TPP
			gen tpp_rprox = abs(tpp - c_a_tpp) - abs(tpp - c_b_tpp)
			label var tpp_rprox "TPP" 
			
			gen tpp_rprox_euclid = [(tpp - c_a_tpp)*(tpp - c_a_tpp)] - [(tpp - c_b_tpp)*(tpp - c_b_tpp)]
				
		*Immigration
			gen imm_rprox = abs(path - c_a_path) - abs(path - c_b_path)
			label var imm_rprox "Immigration"
			
			gen imm_rprox_euclid = [(path - c_a_path)*(path - c_a_path)] - [(path - c_b_path)*(path - c_b_path)]
				
		*Taxes
			gen taxes_rprox = abs(taxes - c_a_taxes) - abs(taxes - c_b_taxes)
			label var taxes_rprox "Taxes on Rich" 
			
			gen taxes_rprox_euclid = [(taxes - c_a_taxes)*(taxes - c_a_taxes)] - [(taxes - c_b_taxes)*(taxes - c_b_taxes)]
		
		*Cap & Trade
			gen cap_rprox = abs(captrade - c_a_cap) - abs(captrade - c_b_cap)
			label var cap_rprox "Cap & Trade"
			
			gen cap_rprox_euclid = [(captrade - c_a_cap)*(captrade - c_a_cap)] - [(captrade - c_b_cap)*(captrade - c_b_cap)]
		
		*ISIS
			gen isis_rprox = abs(isis - c_a_isis) - abs(isis - c_b_isis)
			label var isis_rprox "ISIS"
			
			gen isis_rprox_euclid = [(isis - c_a_isis)*(isis - c_a_isis)] - [(isis - c_b_isis)*(isis - c_b_isis)]
			
			*Distribution
				foreach var in tpp_rprox imm_rprox taxes_rprox cap_rprox isis_rprox {
					histogram `var' , discrete scheme(s1mono) xlabel(-6(1)6) ytitle(, size(small)) title("`: var label `var''", size(medlarge)) xtitle("") 
					graph save histogram_`var', replace
					}
				
				graph combine 	"histogram_tpp_rprox.gph" "histogram_imm_rprox.gph" "histogram_taxes_rprox.gph"  ///
					"histogram_cap_rprox.gph" "histogram_isis_rprox.gph", scheme(s1mono)				
		
			*Standardized/Rescaled Versions
				foreach var in tpp_rprox imm_rprox taxes_rprox cap_rprox isis_rprox tpp_rprox_euclid imm_rprox_euclid taxes_rprox_euclid cap_rprox_euclid isis_rprox_euclid {
					summ `var' 
					gen `var'01 = (`var' - r(min))/(r(max)-r(min))
					summ `var' 
					gen `var'2sd = (`var' - r(mean))/(2*r(sd))
				}
				
				label var tpp_rprox01 "TPP"
				label var tpp_rprox2sd "TPP"
				label var imm_rprox01  "Immigration"
				label var imm_rprox2sd "Immigration"
				label var taxes_rprox01 "Taxes on Rich"
				label var taxes_rprox2sd "Taxes on Rich"
				label var cap_rprox01 "Cap & Trade"
				label var cap_rprox2sd "Cap & Trade"
				label var isis_rprox01 "ISIS"
				label var isis_rprox2sd "ISIS"
	
				label var tpp_rprox_euclid01 "TPP"
				label var tpp_rprox_euclid2sd "TPP"
				label var imm_rprox_euclid01  "Immigration"
				label var imm_rprox_euclid2sd "Immigration"
				label var taxes_rprox_euclid01 "Taxes on Rich"
				label var taxes_rprox_euclid2sd "Taxes on Rich"
				label var cap_rprox_euclid01 "Cap & Trade"
				label var cap_rprox_euclid2sd "Cap & Trade"
				label var isis_rprox_euclid01 "ISIS"
				label var isis_rprox_euclid2sd "ISIS"
		
	
	
	*Religion
		/**In analyses on the fully stacked data, it turned up that Muslim candidates were substantially less likely to be chosen
			than non-Muslim candidatess. Candidates A & B can both be Muslim, one Muslim and the other not, or
			neither Muslim. A variable is created to capture these four cases. **/
		
		*Coding the Religious Variales
			label def cre 1 "Mainline Protestant" 2 "Evangelical" 3 "Catholic" 4 "Jewish" ///
				5 "Muslim" 6 "None" 
			
			foreach var in a_relig b_relig {
				gen c_`var' = .
				replace c_`var' = 1 if `var' == "Mainline protestant" 
				replace c_`var' = 2 if `var' == "Evangelical protestant" 
				replace c_`var' = 3 if `var' == "Catholic"
				replace c_`var' = 4 if `var' == "Jewish" 
				replace c_`var' = 5 if `var' == "Muslim"
				replace c_`var' = 6 if `var' == "None"
				label var c_`var' "Candidate Religion"
				label values c_`var' cre
				}

		gen cand_muslim = .
		label def cmus 1 "Neither" 2 "Cand A Muslim" 3 "Cand B Muslim" 4 "Both Muslim"
		replace cand_muslim = 1 if c_a_relig != 5 & c_b_relig !=5
		replace cand_muslim = 2 if c_a_relig == 5 & c_b_relig !=5
		replace cand_muslim = 3 if c_a_relig !=5 & c_b_relig == 5
		replace cand_muslim = 4 if c_a_relig == 5 & c_b_relig == 5
		label var cand_muslim "Muslim Candidate?"
		label values cand_muslim cmus
	
	*Party
		*Party Affiliation
			label def cpa 1 "Democrat" 0 "Republican" 

			foreach var in a_party b_party {
				gen c_`var' = . 
				replace c_`var' = 1 if `var' == "Democrat" 
				replace c_`var' = 0 if `var' == "Republican"
				label var c_`var' "Candidate Party" 
				label values c_`var' cpa
				}

		*Partisan Match
			label def part  1 "Different Party" 2 "Same Party" 3 "Independent" 

			foreach var in c_a_party c_b_party {
				gen same_`var' = . 
				replace same_`var' = 2 if `var' == 1 & party == 2
				replace same_`var' = 2 if `var' == 0 & party == 1
				replace same_`var' = 1 if `var' == 1 & party == 1
				replace same_`var' = 1 if `var' == 0 & party == 2			
				replace same_`var' = 3 if party >=3 & party <=4
				label var same_`var' "Party Match" 
				label values same_`var' part
				gen same_`var'1 = . 
				replace same_`var'1 = 2 if `var' == 1 & partyid >=1 & partyid <= 3
				replace same_`var'1 = 2 if `var' == 0 & partyid >=5 & partyid <= 7
				replace same_`var'1 = 1 if `var' == 1 & partyid >=5 & partyid <= 7
				replace same_`var'1 = 1 if `var' == 0 & partyid >=1 & partyid <= 3
				replace same_`var'1 = 3 if partyid == 4
				label var same_`var'1 "Party Match (w/leaner)" 
				label values same_`var'1 part
				}
		
			/**While the above codes similarity for boht A and B, these are 
				simply inverses of one anther due to randomization and
				since we are predicting whether one votes for candidate B, 
				the B party version is the one that is useful
			**/
			
		*Age
			gen comp_age = b_age - a_age
			label var comp_age "candidate Age Difference" 
			summ comp_age
			gen comp_age01 = (comp_age-r(min))/(r(max)-r(min))
			label var comp_age01 "candidate Age Difference" 

		
			***************************************
			***************Analyses***************
			***************************************	
			***************************************
			
*Candidate Choice & Feeling Thermometer Relationship
	histogram therm_comp, scheme(s1mono) ///
	xtitle("Comparative Thermometer" "<-- A > B     --> B > A")
	
	logit choice c.therm_comp, cluster(responseid)
	margins, at(therm_comp=(-100(20)100))
	marginsplot, scheme(s1mono) 
	graph save "Comp Therm and Choice", replace
	graph export "Comp Therm and Choice.png" , replace
	
	
/*****************************
*Relative Proximity Analyses, incl.
Table OA3 and Figure OA10
*****************************/

/*Table OA3*/
eststo clear
eststo: regress choice tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01, cluster(responseid)
	margins, dydx(*) post
	estimates store T1
eststo: regress choice tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01 if same_c_b_party == 1, cluster(responseid)
	margins, dydx(*) post
	estimates store T2 
eststo: regress choice tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01 if same_c_b_party == 2, cluster(responseid)
	margins, dydx(*) post
	estimates store T3
eststo: regress choice tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01 if same_c_b_party == 3, cluster(responseid)
	margins, dydx(*) post
	estimates store T4 
esttab using PROX_CHOICE_BYPID.rtf, mtitles("All" "Diff Party" "Same Party" "Ind.") onecell label ar2 se star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
eststo clear
			
/*Figure OA10*/
coefplot T1, bylabel(All Respondents) || T2, bylabel(Cand B Diff Party From Resp.) || T3, bylabel(Cand B Same Party As Resp) ||  T4, bylabel(Resp. is an Independent) || ///
, scheme(s1mono) xline(0, lpattern(dash)) mlab mlabpos(12) format(%9.2g) 

graph save "Figure OA10", replace
graph export "Figure OA10.png", replace	
	

/*Comparing OLS and Logit; Including Controls*/

*Choice
eststo clear
eststo: regress choice tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01, cluster(responseid)
eststo: regress choice tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01 i.same_c_b_party i.cand_muslim c.comp_age01, cluster(responseid)
eststo: logit choice tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01, cluster(responseid)
eststo: logit choice tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01 i.same_c_b_party i.cand_muslim c.comp_age01	, cluster(responseid)
esttab using PROX_CHOICE.rtf, mtitles("OLS" "OLS" "LOGIT" "LOGIT") onecell label ar2 pr2 se star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
eststo clear

*Predicted Effects*
	logit choice tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01, cluster(responseid)
		foreach var in tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01 {
			margins, at(`var'=(0(0.25)1)) 
			marginsplot, title("`: var label `var''", size(medlarge)) scheme(s1mono) xtitle("") ytitle(, size(small))
			graph save "margins_`var'", replace
		}
								
graph combine "margins_tpp_rprox01" "margins_imm_rprox01" "margins_taxes_rprox01" "margins_cap_rprox01" "margins_isis_rprox01", scheme(s1mono)
			
					
*Comp Thermometer
eststo clear
eststo: regress therm_comp01 tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01 , cluster(responseid)
eststo: regress therm_comp01 tpp_rprox01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01 i.same_c_b_party i.cand_muslim c.comp_age01 , cluster(responseid)
esttab using PROX_THERM.rtf, onecell label ar2 pr2 se star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
eststo clear
	
	
/*****************************
Moderation Analyses
Figure 4 in text
Table OA4
Figure OA12
*****************************/
	
foreach var in pathimp taxesimp capimp isisimp tppimp {
	summ `var' 
	gen `var'01 = (`var' - r(min))/(r(max)-r(min))
	}
label var pathimp01 "Immigration: Importance"
label var taxesimp01 "Taxes on Rich: Importance"
label var capimp01 "Cap & Trade: Importance"
label var isisimp01 "ISIS: Importance"
label var tppimp01 "TPP: Importance"
	
	
eststo clear
eststo: regress choice c.tpp_rprox01##c.tppimp01, cluster(responseid)
	margins, dydx(tpp_rprox01) at(tppimp01=(0(0.25)1)) saving(TPP1, replace)
eststo: regress choice c.tpp_rprox01##c.tppimp01 imm_rprox01 taxes_rprox01 cap_rprox01 isis_rprox01 i.same_c_b_party i.cand_muslim c.comp_age01, cluster(responseid)
	margins, dydx(tpp_rprox01) at(tppimp01=(0(0.25)1)) saving(TPP2, replace)

eststo: regress choice c.imm_rprox01##c.pathimp01, cluster(responseid)
	margins, dydx(imm_rprox01) at(pathimp01=(0(0.25)1)) saving(IMM1, replace)
eststo: regress choice c.tpp_rprox01 c.imm_rprox01##c.pathimp01 taxes_rprox01 cap_rprox01 isis_rprox01 i.same_c_b_party i.cand_muslim c.comp_age01, cluster(responseid)
	margins, dydx(imm_rprox01) at(pathimp01=(0(0.25)1)) saving(IMM2, replace)

eststo: regress choice c.taxes_rprox01##c.taxesimp01, cluster(responseid)
	margins, dydx(taxes_rprox01) at(taxesimp01=(0(0.25)1)) saving(TAXES1, replace)
eststo: regress choice c.tpp_rprox01 c.imm_rprox01 c.taxes_rprox01##c.taxesimp01 cap_rprox01 isis_rprox01 i.same_c_b_party i.cand_muslim c.comp_age01, cluster(responseid)
	margins, dydx(taxes_rprox01) at(taxesimp01=(0(0.25)1)) saving(TAXES2, replace)

eststo: regress choice  c.cap_rprox01##c.capimp01, cluster(responseid)
	margins, dydx(cap_rprox01) at(capimp01=(0(0.25)1)) saving(CAP1, replace)

eststo: regress choice c.tpp_rprox01 c.imm_rprox01 taxes_rprox01 c.cap_rprox01##c.capimp01 isis_rprox01 i.same_c_b_party i.cand_muslim c.comp_age01, cluster(responseid)
	margins, dydx(cap_rprox01) at(capimp01=(0(0.25)1)) saving(CAP2, replace)

eststo: regress choice c.isis_rprox01##c.isisimp01, cluster(responseid)
	margins, dydx(isis_rprox01) at(isisimp01=(0(0.25)1)) saving(ISIS1, replace)

eststo: regress choice c.tpp_rprox01 c.imm_rprox01 taxes_rprox01 cap_rprox01 c.isis_rprox01##c.isisimp01 i.same_c_b_party i.cand_muslim c.comp_age01, cluster(responseid)
	margins, dydx(isis_rprox01) at(isisimp01=(0(0.25)1)) saving(ISIS2, replace)

esttab using CHOICE_IMP_INT.rtf, onecell label ar2 se star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
eststo clear
	
***Graphing: 
	*Combomarginsplot for the two models by issue
		*TPP
			combomarginsplot TPP1 TPP2, scheme(s1mono) yline(0, lpattern(dash)) labels("No Controls" "With Controls") title(TPP) xtitle(Importance)
			graph save "TPP Inter", replace
		*Immigration
			combomarginsplot IMM1 IMM2, scheme(s1mono) yline(0, lpattern(dash)) labels("No Controls" "With Controls") title(Immigration) xtitle(Importance)
			graph save "IMM Inter", replace
		*Taxes on Rich
			combomarginsplot TAXES1 TAXES2, scheme(s1mono) yline(0, lpattern(dash)) labels("No Controls" "With Controls") title(Taxes on Rich) xtitle(Importance)
			graph save "TAX Inter", replace
		*Cap & Trade
			combomarginsplot CAP1 CAP2, scheme(s1mono) yline(0, lpattern(dash)) labels("No Controls" "With Controls") title(Cap & Trade) xtitle(Importance)
			graph save "CAP Inter", replace
		*ISIS
			combomarginsplot ISIS1 ISIS2, scheme(s1mono) yline(0, lpattern(dash)) labels("No Controls" "With Controls") title(ISIS) xtitle(Importance)
			graph save "ISIS Inter", replace
					
		*Grc1leg : Figure OA4
			grc1leg "TPP Inter" "IMM Inter" "TAX Inter" "CAP Inter" "ISIS Inter" , ycommon scheme(s1mono)  pos(4) ring(0)
				/*the legend was then manually transformed into 2 rows and positioned, before saving*/
			
*Interaction by Party (Figure OA12)*
eststo clear
eststo: regress choice c.tpp_rprox01##c.tppimp01##i.same_c_b_party, cluster(responseid)
		margins, dydx(tpp_rprox01) at(tppimp01=(0(0.25)1)) by(same_c_b_party) 
		marginsplot, xdim(tppimp01) scheme(s1mono) by(same_c_b_party) byopts(rows(1) title(TPP))  xtitle("") yline(0, lpattern(dash))
		graph save "TPP-PID-IMP", replace
eststo: regress choice c.imm_rprox01##c.pathimp01##i.same_c_b_party, cluster(responseid)
		margins, dydx(imm_rprox01) at(pathimp01=(0(0.25)1)) by(same_c_b_party) 
		marginsplot, xdim(pathimp01) scheme(s1mono) by(same_c_b_party) byopts(rows(1) title(Immigration))  xtitle("") yline(0, lpattern(dash))
		graph save "IMM-PID-IMP", replace
eststo: regress choice c.taxes_rprox01##c.taxesimp01##i.same_c_b_party, cluster(responseid)
		margins, dydx(taxes_rprox01) at(taxesimp01=(0(0.25)1)) by(same_c_b_party) 
		marginsplot, xdim(taxesimp01) scheme(s1mono) by(same_c_b_party) byopts(rows(1) title(Taxes on Rich))  xtitle("") yline(0, lpattern(dash))
		graph save "TAXES-PID-IMP", replace
eststo: regress choice c.cap_rprox01##c.capimp01##i.same_c_b_party, cluster(responseid)
		margins, dydx(cap_rprox01) at(capimp01=(0(0.25)1)) by(same_c_b_party) 
		marginsplot, xdim(capimp01) scheme(s1mono) by(same_c_b_party) byopts(rows(1) title("Cap & Trade"))  xtitle("") yline(0, lpattern(dash))
		graph save "CAP-PID-IMP", replace
	
eststo: regress choice c.isis_rprox01##c.isisimp01##i.same_c_b_party, cluster(responseid)
		margins, dydx(isis_rprox01) at(isisimp01=(0(0.25)1)) by(same_c_b_party) 
		marginsplot, xdim(isisimp01) scheme(s1mono) by(same_c_b_party) byopts(rows(1) title(ISIS))  xtitle("") yline(0, lpattern(dash))
		graph save "ISIS-PID-IMP", replace
esttab using CHOICE_IMP_INT_PID.rtf,  onecell label ar2 se star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace
eststo clear

graph combine "TPP-PID-IMP" "IMM-PID-IMP" "CAP-PID-IMP" "TAXES-PID-IMP" "ISIS-PID-IMP", rows(3) scheme(s1mono)


/*************************
TPP Manipulation Analyses
Table OA5, 
Figure OA11
**************************/

eststo clear
eststo: regress choice c.tpp_rprox01##c.tppimp, cluster(responseid)
eststo: regress choice c.tpp_rprox01##i.tpp_manip, cluster(responseid)
eststo: regress choice c.tpp_rprox01##c.tppimp##i.tpp_manip, cluster(responseid)
	
		/*To run the 2SLS with the interaction term, we first manually created the 
		  endogenous interaction ("inter") and created interactions between the exogenous
		  variable (proximity) and the instrument (treatment assignment). We then 
		  ran a standard 2SLS model, with the interaction and importance measure as endogenous*/
		
			tabulate tpp_manip, gen(tpp_m)
			gen inter = tppimp * tpp_rprox01
			gen inst1_exog = tpp_m2*tpp_rprox01
			gen inst2_exog = tpp_m3*tpp_rprox01
			
eststo: ivregress 2sls choice tpp_rprox01 ///
	(tppimp inter = tpp_m2 tpp_m3), cluster(responseid)
	
esttab using TPP_PROXANDIMPTREAT.rtf, onecell ar2 se label nobaselevels star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("OLS" "OLS" "OLS" "2SLS") addnotes(Standard errors clustered at respondent level.) ///
	title({\b Table XX} TPP Proximity and Importance - Survey 1 Manipulation Effects) replace

		
*Figure OA11*
			regress choice c.tpp_rprox01##c.tppimp##i.tpp_manip, cluster(responseid)
				margins, dydx(tpp_rprox01) at(tppimp=(1(1)5)) by(tpp_manip)
				marginsplot, scheme(s1mono) title("AME of TPP Proximity by" ///
					"Subj. Importance and Importance Manipulation") yline(0)
					graph save "TPP Prox by Imp and Imp Manip", replace
					graph export "TPP Prox by Imp and Imp Manip.png", replace
			
 

/**************************
Comparison of Results based on 
Vignette order
****************************/	

*Table OA7
eststo clear
eststo: regress choice c.tpp_rprox01##c.tppimp01, cluster(responseid)
	margins, dydx(tpp_rprox01) at(tppimp01=(0(0.25)1)) saving(TPP1_all, replace)
eststo: regress choice c.tpp_rprox01##c.tppimp01 if vignette == 1, cluster(responseid)
	margins, dydx(tpp_rprox01) at(tppimp01=(0(0.25)1)) saving(TPP1_first, replace)

eststo: regress choice c.imm_rprox01##c.pathimp01, cluster(responseid)
	margins, dydx(imm_rprox01) at(pathimp01=(0(0.25)1)) saving(IMM1_all, replace)

eststo: regress choice c.imm_rprox01##c.pathimp01 if vignette == 1, cluster(responseid)
	margins, dydx(imm_rprox01) at(pathimp01=(0(0.25)1)) saving(IMM1_first, replace)

eststo: regress choice c.taxes_rprox01##c.taxesimp01 , cluster(responseid)
	margins, dydx(taxes_rprox01) at(taxesimp01=(0(0.25)1)) saving(TAXES1_all, replace)	
eststo: regress choice c.taxes_rprox01##c.taxesimp01 if vignette == 1, cluster(responseid)
	margins, dydx(taxes_rprox01) at(taxesimp01=(0(0.25)1)) saving(TAXES1_first, replace)

eststo: regress choice  c.cap_rprox01##c.capimp01, cluster(responseid)
	margins, dydx(cap_rprox01) at(capimp01=(0(0.25)1)) saving(CAP1_all, replace)

eststo: regress choice  c.cap_rprox01##c.capimp01 if vignette == 1, cluster(responseid)
	margins, dydx(cap_rprox01) at(capimp01=(0(0.25)1)) saving(CAP1_first, replace)

eststo: regress choice c.isis_rprox01##c.isisimp01, cluster(responseid)
	margins, dydx(isis_rprox01) at(isisimp01=(0(0.25)1)) saving(ISIS1_all, replace)

eststo: regress choice c.isis_rprox01##c.isisimp01 if vignette == 1, cluster(responseid)
	margins, dydx(isis_rprox01) at(isisimp01=(0(0.25)1)) saving(ISIS1_first, replace)

esttab using CHOICE_IMP_INT_FIRSTvALL.rtf, onecell label ar2 se star(+ 0.10 * 0.05 ** 0.01) addnote(Standard errors clustered at respondent level.) replace ///
	mtitles("TPP:All" "TPP:1st" "Imm:All" "Imm:1st" "Taxes:All" "Taxes:1st" "Cap:All" "Cap:1st" "ISIS:All" "ISIS:1st")
	
eststo clear
	
*Figure OA14
		
combomarginsplot TPP1_all TPP1_first, scheme(plottig) labels("All Vignettes" "1st Vignette") ///
		title("TPP") ylabel(-1(0.25)1) legend(ring(0) pos(1)) plot2opts(msymbol(T))
		
		graph save "tpp vignette", replace
			
combomarginsplot IMM1_all IMM1_first, scheme(plottig) labels("All Vignettes" "1st Vignette") ///
		title("Immigration") ylabel(-1(0.25)1) legend(ring(0) pos(1)) plot2opts(msymbol(T))
		graph save "imm vignette", replace	
		
combomarginsplot TAXES1_all TAXES1_first, scheme(plottig) labels("All Vignettes" "1st Vignette") ///
		title("Taxes") ylabel(-1(0.25)1) legend(ring(0) pos(1)) plot2opts(msymbol(T))
		graph save "taxes vignette", replace
		
combomarginsplot CAP1_all CAP1_first, scheme(plottig) labels("All Vignettes" "1st Vignette") ///
		title("Cap&Trade") ylabel(-1(0.25)1) legend(ring(0) pos(1)) plot2opts(msymbol(T))
		graph save "cap vignette", replace
		
combomarginsplot ISIS1_all ISIS1_first, scheme(plottig) labels("All Vignettes" "1st Vignette") ///
		title("ISIS") ylabel(-1(0.25)1) legend(ring(0) pos(1)) plot2opts(msymbol(T))
		graph save "isis vignette", replace
		
graph combine "tpp vignette" "imm vignette" "taxes vignette" "cap vignette" "isis vignette", scheme(plotplain)
graph save "1st vs all vignettes", replace
graph export "1st vs all vignettes.png", replace
		
		
	
		

