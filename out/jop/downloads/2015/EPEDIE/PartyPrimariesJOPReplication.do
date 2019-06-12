use PartyPrimariesJOP

******TABLES IN THE MANUSCRIPT***********

**Table 1**
	reg logamount l.partydonors l.logamount , cluster (candid)
	reg partydonors l.partydonors l.logamount , cluster (candid)

	reg logamount l.partydonors l.logamount if CandQualityNoDifference ==1, cluster (candid)
	reg partydonors l.partydonors l.logamount if CandQualityNoDifference ==1, cluster (candid)
	
**Table 2**
	*Model 1*
	logit withdraw l.partydonors l.logamount l.countcandidates CandQualityJacobson q2 q3 q4 q5 q6 , cluster (raceid)

	*Model 2*
	*Dropping Candidates who had higher qualified opponent in primary*
	drop if CandQualityJacobson ==0 & CandQualityJMax ==1
	sort state democrat year quarter
	
	*Generating an exclusion restrictin for candidates with no equally qualified opponents*
	quietly by state democrat year quarter: gen dupreduced = cond(_N==1,0,_n)
	egen countcandidatesReduced=max(dupreduced), by (state democrat year quarter)
	tsset candid quarter
	*Model 2*
	logit withdraw l.partydonors l.logamount l.countcandidates  CandQualityJacobson q2 q3 q4 q5 q6 if countcandidatesReduced >1, cluster (raceid)

*Figure 1--Was created in Excel, this code provides the point estimates and the 95% confidence intervals*
	margins, at (l.partydonors=(0(8)104)) atmeans
	
clear

**Table 3**
	use PartyPrimariesJOP
	
	*Dropping non-competing candidates and identifying primary winner*
	replace primaryvote=-999999 if primaryvote==999999
	egen pvoteMAX=max(primaryvote), by (stateid democrat year)
	gen primarywinner=0
	replace primarywinner=1 if primaryvote>=pvoteMAX
	drop if primaryvote==-999999
	
	*Aggregating party donors and fundraising over the whole primary*
	collapse primarywinner CandQualityJacobson (sum) amount partydonors, by (candidate candname state year democrat )

	*Generating variable to count number of candidates on the ballot*
	sort state democrat year
	quietly by state democrat year: gen dup = cond(_N==1,0,_n)
	egen countcandidates=max(dup), by (state democrat year)
	replace countcandidates=1 if countcandidates==0

	*Generating logged fundraising and id for primary race*
	egen raceid=group(state democrat year)
	gen logamount=log(amount)
	replace logamount=0 if logamount==.
		
	*Model 1*
	logit primarywin logamount partydonors  CandQualityJacobson if countcandidates>1, cluster (raceid)

	**Generating CandQuality Difference**
	egen CandQualityJMax=max(CandQualityJacobson), by (state democrat year)

	*Identifying races where candidate with highest experience has another similar competitor*
	drop if CandQualityJacobson ==0 & CandQualityJMax ==1
	quietly by state democrat year: gen dupreduced = cond(_N==1,0,_n)
	egen countcandidatesReduced=max(dupreduced), by (state democrat year)
	
	*Model 2*
	logit primarywin logamount partydonors CandQualityJacobson if countcandidatesReduced>1, cluster (raceid)
	
**Figure 2--Was created in Excel, this code provides the point estimates and the 95% confidence intervals*
	margins, at (partydonors=(0(15)405)) atmeans

	
	
******TABLES IN THE ONLINE APPENDIX***********	
clear	
use PartyPrimariesJOP

**Table 2A**
	*Prepping data for hazard model*
	stset quarter , id(candid) f(competing=0) origin(min)
	
	*Generating lagged variables*
	gen lpartydonors=l.partydonors
	gen llogamount=l.logamount
	gen lcountcandidates=l.countcandidates

	*Model 1*
	stcox lpartydonors llogamount lcountcandidates CandQualityJacobson, cluster(raceid) nohr
	*Model 1 Hazard Ratios*
	stcox lpartydonors llogamount lcountcandidates CandQualityJacobson, cluster(raceid)

**Figure 1A**
	stcurv, surv at( lpartydonors=0) at1(lpartydonors=50) at2(lpartydonors=100)
	
**Table 3A**
	logit withdraw l.partydonors l.logamount l.countcandidates CandQualityJacobson q2 q3 q4 q5 q6 if countcandidates>1, cluster (raceid)

**Figure 2A**
	*Dropping non-competing candidates and identifying primary winner*
	replace primaryvote=-999999 if primaryvote==999999
	egen pvoteMAX=max(primaryvote), by (stateid democrat year)
	gen primarywinner=0
	replace primarywinner=1 if primaryvote>=pvoteMAX
	drop if primaryvote==-999999
	
	*Aggregating party donors and fundraising over the whole primary*
	collapse primarywinner CandQualityJacobson (sum) amount partydonors, by (candidate candname state year democrat )

	*Generating variable to count number of candidates*
	sort state democrat year
	quietly by state democrat year: gen dup = cond(_N==1,0,_n)
	egen countcandidates=max(dup), by (state democrat year)
	replace countcandidates=1 if countcandidates==0

	*Generating exclusion restrictions to identify party preferred candidates only*
	egen pdMAX=max(partydonors), by (state democrat year)
	gen pctpd=partydonors/pdMAX
	replace pctpd=0 if pctpd==. & partydonors==0
	
	**Figure 2A**
	hist partydonors if countcandidates >1 & partydonors <1510 & pctpd >.99999, percent width (10)
	
**Table 4A**
	clear
	use PartyPrimariesJOP

	logit withdraw l.pctMaxPartyDonors l.pctMaxAmount l.countcandidates CandQualityJacobson q2 q3 q4 q5 q6 , cluster (raceid)

**Table 5A**
	*Generating and merging total number of party donors to primary candidates in primary race*
	collapse (sum) partydonors, by (raceid quarter)
	rename partydonors totalpartydonors
	sort raceid quarter
	save totalpartydonorsquarter, replace

	*Merging that data to full dataset*
	use PartyPrimariesJOP
	sort raceid quarter
	merge m:1 raceid quarter using totalpartydonorsquarter
	
	*Generating each candidate's percent of party donors
	gen pctTotalPD=partydonors/totalpartydonors
	replace pctTotalPD=0 if partydonors==0 & pctTotalPD==.
	
	xtset candid quarter
	
	*Model 1*
	logit withdraw l.pctTotalPD l.logamount l.countcandidates CandQualityJacobson q2 q3 q4 q5 q6 , cluster (raceid)

**Table 6A**
	clear
	use PartyPrimariesJOP
	
	*Dropping non-competing candidates and identifying primary winner*
	replace primaryvote=-999999 if primaryvote==999999
	egen pvoteMAX=max(primaryvote), by (stateid democrat year)
	gen primarywinner=0
	replace primarywinner=1 if primaryvote>=pvoteMAX
	drop if primaryvote==-999999
	
	*Aggregating party donors and fundraising over the whole primary*
	collapse primarywinner CandQualityJacobson (sum) amount partydonors, by (candidate candname state year democrat )

	*Generating variable to count number of candidates*
	sort state democrat year
	quietly by state democrat year: gen dup = cond(_N==1,0,_n)
	egen countcandidates=max(dup), by (state democrat year)
	replace countcandidates=1 if countcandidates==0

	egen raceid=group(state democrat year)
	
	*Generating Candidate's percentage of leading fundraiser and party donors*
	egen pdMAX=max(partydonors), by (state democrat year)
	egen amountMAX=max(amount), by (state democrat year)
	gen pctMaxPartyDonors=partydonors/pdMAX
	gen pctAmountMax= amount/amountMAX
	replace pctAmountMax =0 if pctAmountMax ==.
	replace pctMaxPartyDonors =0 if pctMaxPartyDonors ==.
	
	*Model 1*
	logit primarywin pctAmountMax pctMaxPartyDonors CandQualityJacobson if countcandidates>1, cluster (raceid)

**Table 7A**
	clear
	use PartyPrimariesJOP
	
	*Dropping non-competing candidates and identifying primary winner*
	replace primaryvote=-999999 if primaryvote==999999
	egen pvoteMAX=max(primaryvote), by (stateid democrat year)
	gen primarywinner=0
	replace primarywinner=1 if primaryvote>=pvoteMAX
	replace primaryvote=999999 if primaryvote==-999999
	drop if primaryvote==999999

	*Aggregating party donors and fundraising over the whole primary*
	collapse primarywinner CandQualityJacobson (sum) amount partydonors, by (candidate candname state year democrat )

	*Generating variable to count number of candidates*
	sort state democrat year
	quietly by state democrat year: gen dup = cond(_N==1,0,_n)
	egen countcandidates=max(dup), by (state democrat year)
	replace countcandidates=1 if countcandidates==0

	*Generating logged fundraising and primary race identifier*
	egen raceid=group(state democrat year)
	gen logamount=log(amount)
	replace logamount=0 if logamount==.

	save PrimaryOutcomeData, replace
	
	*Generating Total Party Donors in Primary Race*
	collapse (sum) partydonors , by (raceid)
	rename partydonors totalpartydonors
	sort raceid
	save totalpartydonorsfullcampaign, replace
	
	*Merging Total Party Donors in Primary Race to Aggregated Data
	use PrimaryOutcomeData
	sort raceid
	merge m:1 raceid using totalpartydonorsfullcampaign
	
	*Generating Candidate's percentage of total party donors
	gen pctTotalPD=partydonors/totalpartydonors
	replace pctTotalPD=0 if partydonors==0 & pctTotalPD==.
	
	*Model 1*
	logit primarywin logamount pctTotalPD CandQualityJacobson if countcandidates>1, cluster (raceid)
	
**Table 8A**
	clear
	use PartyPrimariesJOP
	
	*Dropping non-competing candidates*
	replace primaryvote=-999999 if primaryvote==999999
	egen pvoteMAX=max(primaryvote), by (stateid democrat year)
	gen primarywinner=0
	replace primarywinner=1 if primaryvote>=pvoteMAX
	drop if primaryvote==-999999

	*Aggregating party donors and fundraising over the whole primary*
	collapse primarywinner CandQualityJacobson (sum) amount partydonors, by (candidate candname state year democrat )

	*Generating variable to count number of candidates*
	sort state democrat year
	quietly by state democrat year: gen dup = cond(_N==1,0,_n)
	egen countcandidates=max(dup), by (state democrat year)
	replace countcandidates=1 if countcandidates==0

	*Generating logged fundraising and primary race identifier*
	egen raceid=group(state democrat year)
	gen logamount=log(amount)
	replace logamount=0 if logamount==.

	*Generating Exclusion restriction to only look at party favored candidates*
	egen pdMAX=max(partydonors), by (state democrat year)
	gen pctpd=partydonors/pdMAX
	replace pctpd=0 if pctpd==. & partydonors==.
	
	*Merge with outside spending data*
	sort year state democrat candname
	merge 1:1 year state democrat candname using OutsideSupport

	save OutsideSupportMerged, replace

	*Combine spending for opponent and against candidate
	gen OppoSupport=oppooutagainst+oppooutsupport
	replace OppoSupport=0 if OppoSupport==.
	gen CandSupport=candoutsupport+candoutagainst
	replace CandSupport=0 if CandSupport==.
	
	*Generate logged support and opposition*
	gen LogOppoSupport=log(OppoSupport)
	replace LogOppoSupport=0 if LogOppoSupport==.
	gen LogCandSupport=log(CandSupport)
	replace LogCandSupport=0 if LogCandSupport==.

	*Model 1*
	logit primarywinner closestopponentspd closestopponentsfundpct LogOppoSupport LogCandSupport CandQualityJacobson if countcandidate>1 & pctpd ==1
