** this script estimates the models for: **
** "Legislative Review and Party Differentiation in Coalition Governments" **
** first, set your directory and read in the data **
	
	clear
	set more off
	cd ""

	use "replication.dta", clear
	
** let's replicate martin and vanbgerg 2005 first to see that **
** our review dynamics are similar to thei sample **

	preserve
		bysort marker: egen allChange = sum(art_changes)
		bysort marker: egen shadowChair = max(chair)
		bysort marker: egen juniorMinister = max(jm)

		gen oppChair = shadowChair == 1 & ministerchair == 0
	
		sort marker
		drop if marker == marker[_n-1]
		menbreg allChange ministerdistance juniorMinister  minority daysInReview articles expire || cabinet:
		eststo mv2005
	
		menbreg allChange ministerdistance juniorMinister minority  ministerchair oppositionChair daysInReview articles expire|| cabinet:
		eststo ourModel
	
** uncomment the following to record the output to csv **

*		# delimit ;
*			esttab mv2005 ourModel
*			using repMartinVanberg.csv, se nostar scalars(ll)
*			nodepvars nomtitles replace compress plain;
*		#delimit cr
	
	restore

** those results are quite similar, substantively **

** now, let's estimate the regression models from Table 2 **
	
		mepoisson art_changes popdivCab articles daysInReview expire i.catCountry || marker:
		eststo simple
		predict simplePred
		gen simpleDev = abs(simplePred - art_changes)
		sum (simpleDev)
		mepoisson art_changes popdivCab cmpdivCab jmfocal chair ministerchair partnerchair  ministerdistance seats cabParties minority articles daysInReview expire i.catCountry || marker:
		eststo full
		predict fullPred
		gen fullDev = abs(fullPred - art_changes)
		sum (fullDev)

** uncomment the following to record the output to csv **
*		# delimit ;
*			esttab simple full
*			using mainresults.csv, se nostar scalars(ll)
*			nodepvars nomtitles replace compress plain;
*		#delimit cr
