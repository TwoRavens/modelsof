** model estimation **
** note that you will need to install the "mixlogit" ado file if you have not already **
	clear

** set your directory appropriately here **
	cd "~/Dropbox/senatePaper/data/replication/"
	use "dataComplete.dta"
	
	set more off

** execute code needed for simulation below **

	do simUtils.do

** first, let's perform the uncontrolled comparisons in Table 2 of the main text **

	tab state
	recode apply . = 3
	tab senator pastUnity if state == "RI"
	tab apply if senator == "Jack Reed"
	tab apply if senator == "Lincoln Chafee"

	tab senator pastUnity if state == "AZ"
	tab apply if senator == "John McCain"
	tab apply if senator == "Jon Kyl"

	tab senator pastUnity if state == "CA"
	tab apply if senator == "Barbara Boxer"
	tab apply if senator == "Dianne Feinstein"


** code those that know dem-rep left-right and their senator's party **
** they belong in the "restricted sample" **

	gen restrict = 1 if knowLR == 1 & knowParty == 1
	recode restrict . = 0

** create inference and preference variables **
** missing preferences will be recoded to don't know responses **
** (the compliment of preferYea and preferNay) **

	replace response = 3 if response > 2
	gen inferYea = .
	replace inferYea = 0 if response == 2
	replace inferYea = 1 if response == 1
	replace inferYea = 3 if response == 3

	gen preferYea = .
	replace preferYea = 1 if voterPreference == 1
	recode preferYea . = 0

	gen preferNay = .
	replace preferNay = 1 if voterPreference == 2
	recode preferNay . = 0

** create true vote variables **

	replace trueVote = 3 if trueVote > 2
	gen trueYea = .
	replace trueYea = 1 if trueVote == 1
	recode trueYea . = 0

	gen trueNay = .
	replace trueNay = 1 if trueVote == 2
	recode trueNay . = 0

** and now the party line variables **
	
	gen partyYea = .
	replace partyYea = 0 if partyLine == 2
	replace partyYea = 1 if partyLine == 1

** create interactions **
	
	gen trueYeaXpastUnity = trueYea*pastUnity
	gen trueYeaXfreshman = trueYea*freshman
	gen trueNayXpastUnity = trueNay*pastUnity
	gen trueNayXfreshman = trueNay*freshman
	gen partyYeaXpastUnity = partyYea*pastUnity
	gen partyYeaXfreshman = partyYea*freshman
	gen trueYeaXpartyAgree = trueYea*partyAgree
	gen trueNayXpartyAgree = trueNay*partyAgree
	gen partyYeaXpartyAgree = partyYea*partyAgree
	gen preferYeaXpartyAgree = preferYea*partyAgree
	gen preferNayXpartyAgree = preferNay*partyAgree

	gen pastUnityXpolInt = pastUnity*polInt
	gen freshmanXpolInt = freshman*polInt
	gen trueYeaXpolInt = trueYea*polInt
	gen trueNayXpolInt = trueNay*polInt
	gen partyYeaXpolInt = partyYea*polInt
	gen trueYeaXpastUnityXpolInt = trueYeaXpastUnity*polInt
	gen trueYeaXfreshmanXpolInt = trueYeaXfreshman*polInt
	gen trueNayXpastUnityXpolInt = trueNayXpastUnity*polInt
	gen trueNayXfreshmanXpolInt = trueNayXfreshman*polInt
	gen partyYeaXpastUnityXpolInt = partyYeaXpastUnity*polInt
	gen partyYeaXfreshmanXpolInt = partyYeaXfreshman*polInt

** now, we need to put the data in the form of a row for each of the three choices **
** (every choice situation is defined by a respondent, issue, senator combination) **
	
** first generate a choice id **

	egen choiceID=group(id voteName senator)

** now indicators for the vote **

	gen abort = (voteName == "abort")
	gen cafta = (voteName == "cafta")
	gen gains = (voteName == "gains")
	gen imm = (voteName == "imm")
	gen iraq = (voteName == "iraq")
	gen stem = (voteName == "stem")
	gen wage = (voteName == "wage")

** now expand the data so we have three rows for each choice - copy all existing data to each row **
	
	expand 3
	
** create some choice dummmies  **
	
	bysort choiceID: gen alt = _n
	gen yes = (alt == 1)
	gen no = (alt == 2)
	gen dk = (alt == 3)
	
** create the choice variable that will be the DV in the estimation **
	
	gen newdv=inferYea
	recode newdv 3=3 1=1 0=2
	gen choice  = (newdv == alt)
	
** we will adapt the mixlogit command to our task here **
** remember, to replicate the mlogit in clogit format, everything gets interacted with dummies
** indicating the choice (with one omitted category: we wil  leave out DK - making it the baseline) **

** it will work like this... **	   
 
   gen yes_trueYea = yes*trueYea
   gen yes_partyYea = yes*partyYea

   gen no_trueYea = no*trueYea
   gen no_partyYea = no*partyYea

** however, we can do this more efficiently, by just creating a vaector of covariates **
** and creating the choice interactions in a simple loop **
	   
** first, a simple mlogit model **
** disregarding the hierarchical data structure **
** this also leaves in all voters lacking the heuristic inputs **
** remember to excute lines 151-168 all together ** 
** first, the most simple mlogit model (table a4.1 in the appendix)**

	local vars "trueYea trueNay partyYea pastUnity freshman trueYeaXpastUnity trueYeaXfreshman trueNayXpastUnity trueNayXfreshman partyYeaXpastUnity partyYeaXfreshman preferYea preferNay"
	  
	local newvarlist "choice"
	foreach dd of local vars {
	 
		capture drop yes_`dd'
		gen yes_`dd'=`dd'*yes
		capture drop no_`dd'
		gen no_`dd'=`dd'*no
		
		local newvarlist "`newvarlist' yes_`dd' no_`dd'"
	  
	}

	clogit `newvarlist' yes no, group(choiceID),  if restrict == 1

    tempname b V sig dfsig
    matrix `b' = e(b)                            /* 1 x k vector         */
    matrix `V' = e(V)                            /* k x k variance matrix*/
    local N = `e(N)'                             /* save # observations  */

	capture drop bbt*
    _simp, b(`b') v(`V') s(5000) g(bbt) 

	saveold "simpleModelBetas.dta", version(12) replace


** the following bit estimates the model with error clustered at different levels **
** and saves the results to a csv that allows the researcher to compare across specifictaions **
** in order to choose the most appropriate levels to model **

	  set more off
	  local vars "trueYea trueNay partyYea pastUnity freshman polInt trueYeaXpastUnity trueYeaXfreshman trueNayXpastUnity trueNayXfreshman partyYeaXpastUnity partyYeaXfreshman pastUnityXpolInt freshmanXpolInt trueYeaXpolInt trueNayXpolInt partyYeaXpolInt trueYeaXpastUnityXpolInt trueYeaXfreshmanXpolInt trueNayXpastUnityXpolInt trueNayXfreshmanXpolInt partyYeaXpastUnityXpolInt partyYeaXfreshmanXpolInt preferYea preferNay partyAgree trueYeaXpartyAgree trueNayXpartyAgree partyYeaXpartyAgree preferYeaXpartyAgree preferNayXpartyAgree female race income edu"
	              
	  local newvarlist "choice"
	  foreach dd of local vars {
	 
		capture drop yes_`dd'
		gen yes_`dd'=`dd'*yes
		capture drop no_`dd'
		gen no_`dd'=`dd'*no
		
		
		local newvarlist "`newvarlist' yes_`dd' no_`dd'"
	  
	  }
	  
	capture drop sen_issue	
	egen sen_issue=group(senator voteName)
	
	eststo clear
	capture drop _est_*
	set more off 
	
	eststo: clogit `newvarlist' yes no, group(choiceID) 
	eststo: clogit `newvarlist' yes no, group(choiceID) vce(cluster senator)
	eststo: clogit `newvarlist' yes no, group(choiceID) vce(cluster voteName)
	eststo: clogit `newvarlist' yes no, group(choiceID) vce(cluster id)
	eststo: clogit `newvarlist' yes no, group(choiceID) vce(cluster state)
	eststo: clogit `newvarlist' yes no, group(choiceID) vce(cluster sen_issue)
	
	esttab using seClusterResults.csv, replace plain noparentheses se ///
		title(Column Label is Clustering Variable) ///
		nonumbers mtitles("None" "Senator" "Issue" "Respondent" "State" "Sen_Issue" ) 

	
** now the full model presented in table A2.3 **
** these are the coefficients we will use to make all of the graphics **
** we estimate this only for those with the heuristic's informational inputs **
** this model will likely take 24+ hours to converge... **

** remember to excute the remainder of thise script all together ** 

	  set more off
	  local vars "trueYea trueNay partyYea pastUnity freshman polInt trueYeaXpastUnity trueYeaXfreshman trueNayXpastUnity trueNayXfreshman partyYeaXpastUnity partyYeaXfreshman pastUnityXpolInt freshmanXpolInt trueYeaXpolInt trueNayXpolInt partyYeaXpolInt trueYeaXpastUnityXpolInt trueYeaXfreshmanXpolInt trueNayXpastUnityXpolInt trueNayXfreshmanXpolInt partyYeaXpastUnityXpolInt partyYeaXfreshmanXpolInt preferYea preferNay partyAgree trueYeaXpartyAgree trueNayXpartyAgree partyYeaXpartyAgree preferYeaXpartyAgree preferNayXpartyAgree female race income edu abort gains imm iraq stem wage"
	  
	  local newvarlist "choice"
	  foreach dd of local vars {
	 
		capture drop yes_`dd'
		gen yes_`dd'=`dd'*yes
		capture drop no_`dd'
		gen no_`dd'=`dd'*no
		
		
		local newvarlist "`newvarlist' yes_`dd' no_`dd'"
	  
	  }
	  
	  mixlogit `newvarlist', group(choiceID) rand(yes no) corr,  if restrict == 1
	  
	  mixlbeta yes no, saving("randomBetasCorrIssueDum.dta")

	  mixlcov
	  mixlcov, sd
		
	  mixlpred predicted
      by choiceID, sort: egen predMax=max(predicted)
      gen predMax1 = round(predMax, 0.0001)
      gen predicted1 = round(predicted, 0.0001)
	  gen predChoice = predicted1 == predMax1
	  replace predChoice = . if predicted == .
	  tab predChoice

	  tab predChoice choice
	  tab predChoice choice if alt < 3

      gen predCorrect = predChoice == choice if choice == 1 & predChoice != 1
	  tab predCorrect if predChoice != .
	  tab predCorrect if predChoice != . & alt < 3
	  
	  by id, sort: gen nvals = _n == 1 if predicted != .
	count if nvals

      tempname b V sig dfsig
      matrix `b' = e(b)                            /* 1 x k vector         */
      matrix `V' = e(V)                            /* k x k variance matrix*/
      local N = `e(N)'                             /* save # observations  */

	  capture drop bbt*
      _simp, b(`b') v(`V') s(5000) g(bbt) 

	  saveold "dataCompleteWithBetas.dta", version(12) replace

** now estimate the media-derived unity models for table a4.2 in the appendix and figure a4.2 **

	gen maverickXpolInt = maverick*polInt
	gen trueYeaXmaverick = trueYea*maverick
	gen trueNayXmaverick = trueNay*maverick
	gen trueYeaXmaverickXpolInt = trueYeaXmaverick*polInt
	gen trueNayXmaverickXpolInt = trueNayXmaverick*polInt
	gen partyYeaXmaverick = partyYea*maverick
	gen partyYeaXmaverickXpolInt = partyYeaXmaverick*polInt
		
	  set more off
	  local vars "trueYea trueNay partyYea maverick polInt trueYeaXmaverick trueNayXmaverick partyYeaXmaverick maverickXpolInt trueYeaXpolInt trueNayXpolInt partyYeaXpolInt trueYeaXmaverickXpolInt trueNayXmaverickXpolInt partyYeaXmaverickXpolInt preferYea preferNay partyAgree trueYeaXpartyAgree trueNayXpartyAgree partyYeaXpartyAgree preferYeaXpartyAgree preferNayXpartyAgree female race income edu abort gains imm iraq stem wage"
	  
	  local newvarlist "choice"
	  foreach dd of local vars {
	 
		capture drop yes_`dd'
		gen yes_`dd'=`dd'*yes
		capture drop no_`dd'
		gen no_`dd'=`dd'*no
		
		
		local newvarlist "`newvarlist' yes_`dd' no_`dd'"
	  
	  }
	  
	  mixlogit `newvarlist', group(choiceID) rand(yes no) corr,  if restrict == 1
	  
      tempname b V sig dfsig
      matrix `b' = e(b)                            /* 1 x k vector         */
      matrix `V' = e(V)                            /* k x k variance matrix*/
      local N = `e(N)'                             /* save # observations  */

	  capture drop bbt*
      _simp, b(`b') v(`V') s(5000) g(bbt) 

	  saveold "dataMaverickCompleteWithBetas.dta", version(12) replace

** now estimate the full model with ALL respondents **
** remember to excute the remainder of thise script all together ** 

	  set more off
	  local vars "trueYea trueNay partyYea pastUnity freshman polInt trueYeaXpastUnity trueYeaXfreshman trueNayXpastUnity trueNayXfreshman partyYeaXpastUnity partyYeaXfreshman pastUnityXpolInt freshmanXpolInt trueYeaXpolInt trueNayXpolInt partyYeaXpolInt trueYeaXpastUnityXpolInt trueYeaXfreshmanXpolInt trueNayXpastUnityXpolInt trueNayXfreshmanXpolInt partyYeaXpastUnityXpolInt partyYeaXfreshmanXpolInt preferYea preferNay partyAgree trueYeaXpartyAgree trueNayXpartyAgree partyYeaXpartyAgree preferYeaXpartyAgree preferNayXpartyAgree female race income edu abort gains imm iraq stem wage"
	  
	  local newvarlist "choice"
	  foreach dd of local vars {
	 
		capture drop yes_`dd'
		gen yes_`dd'=`dd'*yes
		capture drop no_`dd'
		gen no_`dd'=`dd'*no
		
		
		local newvarlist "`newvarlist' yes_`dd' no_`dd'"
	  
	  }
	  
	  mixlogit `newvarlist', group(choiceID) rand(yes no) corr
	  
      tempname b V sig dfsig
      matrix `b' = e(b)                            /* 1 x k vector         */
      matrix `V' = e(V)                            /* k x k variance matrix*/
      local N = `e(N)'                             /* save # observations  */

	  capture drop bbt*
      _simp, b(`b') v(`V') s(5000) g(bbt) 

	  saveold "dataCompleteWithBetasCorrIssueDumAllFULLSAMPLE.dta", version(12) replace

** this is the partisan match model (table a4.3 in the appendix) **
** first, a simple mlogit model **
** disregarding the hierarchical data structure **
** this also leaves in all voters lacking the heuristic inputs **
** remember to excute lines 151-168 all together ** 
** first, the most simple mlogit model (table a4.1 in the appendix)**

	gen trueYeaXstatePartySupport = trueYea*statePartySupport
	gen trueNayXstatePartySupport = trueNay*statePartySupport
	gen partyYeaXstatePartySupport = partyYea*statePartySupport
	
	local vars "trueYea trueNay partyYea pastUnity freshman statePartySupport trueYeaXpastUnity trueYeaXfreshman trueNayXpastUnity trueNayXfreshman partyYeaXpastUnity partyYeaXfreshman trueYeaXstatePartySupport trueNayXstatePartySupport partyYeaXstatePartySupport preferYea preferNay"
	  
	local newvarlist "choice"
	foreach dd of local vars {
	 
		capture drop yes_`dd'
		gen yes_`dd'=`dd'*yes
		capture drop no_`dd'
		gen no_`dd'=`dd'*no
		
		local newvarlist "`newvarlist' yes_`dd' no_`dd'"
	  
	}

	clogit `newvarlist' yes no, group(choiceID), if restrict == 1
