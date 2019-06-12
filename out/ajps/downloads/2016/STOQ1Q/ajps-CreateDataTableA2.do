// This do-file contains the stata code for creating the Analysis Dataset
// used in the analyses presented in Table A2 of the Supplementary Information Appendix. 
// The original data source is Valdataarkivet 1948-1970, collected by Göran Gustavsson, and 
// this data can be ordered from Swedish National Data Service (www.snd.gu.se). 
 
set more off
cd C:/Users/lindgren_ko/Dropbox/

use "Utbildningsprojekt/SNDData/SNDValData/Valdataarkivet1948_1970/0148.dta", clear
	
// Rename the variables
		rename v5 EligVoters_1948
		rename v6 Votes_1948
		rename v7 ValidVotes_1948
		rename v8 VotesRight_1948
		rename v9 VotesFarmers_1948
		rename v10 VotesLiberal_1948
		rename v11 VotesSocDem_1948
		rename v12 VotesKom_1948
		rename v13 VotesOth_1948
		
		rename v14 EligVoters_1950
		rename v15 Votes_1950
		rename v16 ValidVotes_1950
		rename v17 VotesRight_1950
		rename v18 VotesFarmers_1950
		rename v19 VotesLiberal_1950
		rename v20 VotesSocDem_1950
		rename v21 VotesKom_1950
		rename v22 VotesOth_1950
		
		rename v23 EligVoters_1952
		rename v24 Votes_1952
		rename v25 ValidVotes_1952
		rename v26 VotesRight_1952
		rename v27 VotesFarmers_1952
		rename v28 VotesLiberal_1952
		rename v29 VotesSocDem_1952
		rename v30 VotesKom_1952
		rename v31 VotesOth_1952
		
		rename v32 EligVoters_1954
		rename v33 Votes_1954
		rename v34 ValidVotes_1954
		rename v35 VotesRight_1954
		rename v36 VotesFarmers_1954
		rename v37 VotesLiberal_1954
		rename v38 VotesSocDem_1954
		rename v39 VotesKom_1954
		rename v40 VotesOth_1954
		
		rename v41 EligVoters_1956
		rename v42 Votes_1956
		rename v43 ValidVotes_1956
		rename v44 VotesRight_1956
		rename v45 VotesFarmers_1956
		rename v46 VotesLiberal_1956
		rename v47 VotesSocDem_1956
		rename v48 VotesKom_1956
		rename v49 VotesOth_1956
		
		rename v50 EligVoters_1958
		rename v51 Votes_1958
		rename v52 ValidVotes_1958
		rename v53 VotesRight_1958
		rename v54 VotesCenterP_1958
		rename v55 VotesLiberal_1958
		rename v56 VotesSocDem_1958
		rename v57 VotesKom_1958
		rename v58 VotesOth_1958
		
		rename v68 EligVoters_1960
		rename v69 Votes_1960
		rename v70 ValidVotes_1960
		rename v71 VotesRight_1960
		rename v72 VotesCenterP_1960
		rename v73 VotesLiberal_1960
		rename v74 VotesSocDem_1960
		rename v75 VotesKom_1960
		rename v76 VotesOth_1960
		
		rename v77 EligVoters_1962
		rename v78 Votes_1962
		rename v79 ValidVotes_1962
		rename v80 VotesRight_1962
		rename v81 VotesCenterP_1962
		rename v82 VotesLiberal_1962
		rename v83 VotesSocDem_1962
		rename v84 VotesKom_1962
		rename v85 VotesOth_1962
		
		rename v86 EligVoters_1964
		rename v87 Votes_1964
		rename v88 ValidVotes_1964
		rename v89 VotesRight_1964
		rename v90 VotesCenterP_1964
		rename v91 VotesLiberal_1964
		rename v92 VotesKDS_1964
		rename v93 VotesSocDem_1964
		rename v94 VotesKom_1964
		rename v95 VotesOth_1964
		rename v96 VotesMS_1964
		
		rename v98 EligVoters_1966
		rename v99 Votes_1966
		rename v100 ValidVotes_1966
		rename v101 VotesRight_1966
		rename v102 VotesCenterP_1966
		rename v103 VotesLiberal_1966
		rename v104 VotesKDS_1966
		rename v105 VotesSocDem_1966
		rename v106 VotesKom_1966
		rename v107 VotesOth_1966
		rename v108 VotesMS_1966
		
		rename v110 EligVoters_1968
		rename v111 Votes_1968
		rename v112 ValidVotes_1968
		rename v113 VotesRight_1968
		rename v114 VotesCenterP_1968
		rename v115 VotesLiberal_1968
		rename v116 VotesKDS_1968
		rename v117 VotesSocDem_1968
		rename v118 VotesVPK_1968
		rename v119 VotesOth_1968
		rename v120 VotesS68_1968
		

	keep v4 *_*
	
//Transform data from wide to long format
reshape long EligVoters_ Votes_ ValidVotes_ VotesSocDem_ VotesOth_ ///
	VotesFarmers_ VotesLiberal_ VotesKom_ VotesRight_ ///
	VotesVPK_ VotesCenterP_ VotesMS_ VotesS68_ VotesKDS_, i(v4) j(Ar)
	
	rename *_ *
	rename v4 Kommun60
	
	gen InvalidVotes = Votes-ValidVotes
		
foreach var of varlist Votes* {
	replace `var'=0 if `var'==.
}
	
	gen Turnout = (ValidVotes)/(EligVoters)

// Add municipality codes from the 1960 census to these data
		gen sKomVD48_70 = string(Kommun60, "%04.0f")
		merge m:1 sKomVD48_70 using "Distance/Data/Grunddata/KommunerValData48_70.dta"
		drop _merge
		drop Kommun60
		rename sKomFoB60 Kommun60
		destring Kommun60, gen(kommun60)
		
// Add data on reform timing from a dataset constructed by Helena Holmlund
		merge m:1 kommun60 using "Swedish Reform\GRRPaper\SNDdata\slutgiltiga_reformkommuner_fob60.dta"
		
		gen ReformYear = firstcohort+11
		gen RefStatus = (Ar>=ReformYear) if ReformYear<.
		
		rename Ar Year
		
		drop v1 v2 v3 v4 _merge 
		rename Kommun60 MunCode_1960
		
		drop if EligVoters==.
		drop kommun60 firstcohort60
		drop if Year==1968
		
	// There were some municipality mergers during this time, create indicators
	// that keep track of these mergers.
		gen MergedMun=MunCode_1960
		gen MergedYear=.
		replace MergedMun="1011" if MunCode_1960=="1010"
		replace MergedYear=1963 if MunCode_1960=="1010"
		replace MergedMun="1163" if MunCode_1960=="1127"
		replace MergedYear=1962 if MunCode_1960=="1127"
		replace MergedMun="1262" if MunCode_1960=="1223"
		replace MergedYear=1963 if MunCode_1960=="1223"
		replace MergedMun="1282" if MunCode_1960=="1211"
		replace MergedYear=1959 if MunCode_1960=="1211"
		replace MergedMun="1421" if MunCode_1960=="1422"
		replace MergedYear=1962 if MunCode_1960=="1422"
		replace MergedMun="1538" if MunCode_1960=="1539"
		replace MergedYear=1961 if MunCode_1960=="1539"
		replace MergedMun="1766" if MunCode_1960=="1735"
		replace MergedYear=1963 if MunCode_1960=="1735"
		replace MergedMun="1861" if MunCode_1960=="1812"
		replace MergedYear=1963 if MunCode_1960=="1812"
		replace MergedMun="1864" if MunCode_1960=="1822"
		replace MergedYear=1962 if MunCode_1960=="1822"
		replace MergedMun="1884" if MunCode_1960=="1817"
		replace MergedYear=1965 if MunCode_1960=="1817"
		replace MergedMun="1861" if MunCode_1960=="1811"
		replace MergedYear=1965 if MunCode_1960=="1811"
		replace MergedMun="1907" if MunCode_1960=="1908"
		replace MergedYear=1963 if MunCode_1960=="1908"
		replace MergedMun="2031" if MunCode_1960=="2032"
		replace MergedYear=1963 if MunCode_1960=="2032"
		replace MergedMun="2085" if MunCode_1960=="2016"
		replace MergedYear=1963 if MunCode_1960=="2016"
		replace MergedMun="2062" if MunCode_1960=="2036"
		replace MergedYear=1959 if MunCode_1960=="2036"
		replace MergedMun="2183" if MunCode_1960=="2119"
		replace MergedYear=1959 if MunCode_1960=="2119"
		replace MergedMun="2117" if MunCode_1960=="2116"
		replace MergedYear=1963 if MunCode_1960=="2116"
		replace MergedMun="2184" if MunCode_1960=="2131"
		replace MergedYear=1965 if MunCode_1960=="2131"
		replace MergedMun="2161" if MunCode_1960=="2125"
		replace MergedYear=1963 if MunCode_1960=="2125"
		replace MergedMun="2281" if MunCode_1960=="2209"
		replace MergedYear=1965 if MunCode_1960=="2209"
		replace MergedMun="2284" if MunCode_1960=="2232"
		replace MergedYear=1963 if MunCode_1960=="2232"
		replace MergedMun="2206" if MunCode_1960=="2207"
		replace MergedYear=1963 if MunCode_1960=="2207"
		replace MergedMun="2231" if MunCode_1960=="2230"
		replace MergedYear=1963 if MunCode_1960=="2230"
		replace MergedMun="2281" if MunCode_1960=="2205"
		replace MergedYear=1965 if MunCode_1960=="2205"
		replace MergedMun="2281" if MunCode_1960=="2261"
		replace MergedYear=1965 if MunCode_1960=="2261"
		replace MergedMun="2310" if MunCode_1960=="2311"
		replace MergedYear=1963 if MunCode_1960=="2311"
		replace MergedMun="2480" if MunCode_1960=="2406"
		replace MergedYear=1965 if MunCode_1960=="2406"
		replace MergedMun="2462" if MunCode_1960=="2424"
		replace MergedYear=1965 if MunCode_1960=="2462"

	//In 1957 the Farmers' party changed name to the Centre party, merge the votes for these two parties
		replace VotesFarmers=VotesFarmers+VotesCenterP
		
		drop VotesVPK
	
		gen LeftShare=(VotesSocDem+VotesKom)/ValidVotes
		gen RightShare=(VotesRight+VotesS68+VotesMS+VotesLiberal)/ValidVotes
		gen FarmShare=VotesFarmers/ValidVotes
	

// A number of municipalities were merged during the period 1952-1966, treat these
// municipalities as one unity during the entire period.

foreach var of varlist EligVoters Votes ValidVotes VotesRight VotesCenterP VotesLiberal VotesKDS VotesSocDem VotesOth VotesS68 VotesFarmers VotesKom VotesMS {
	
	bysort MergedMun Year: egen m`var'=total(`var')
}
		gen mLeftShare=(mVotesSocDem+mVotesKom)/mValidVotes
		gen mRightShare=(mVotesRight+mVotesS68+mVotesMS+mVotesLiberal)/mValidVotes
		gen mFarmShare=mVotesFarmers/mValidVotes
		gen mTurnout=mVotes/mEligVoters
		
		bysort MergedMun Year: egen mCompSchool=max(RefStatus)
		bysort MergedMun Year: egen mReformYear=min(ReformYear)
		
		gen Window=Year-ReformYear
		gen mWindow=Year-mReformYear
		
		rename RefStatus CompSchool
		
		keep LeftShare RightShare FarmShare Turnout MunCode Year ReformYear Window ///
		mLeftShare mRightShare mFarmShare mTurnout Year mReformYear mWindow MergedMun ///
		CompSchool mCompSchool
		
		label var LeftShare "Share of votes left parties" 
		label var RightShare "Share of votes right parties" 
		label var FarmShare "Share of votes the Farmers' party" 
		label var Turnout "Voter turnout" 
		label var MunCode "Municipality code according to the census 1960"
		label var Year "Year of the election" 
		label var ReformYear "Year of reform implementation" 
		label var Window "Year-ReformYear" 
		label var mLeftShare "Share of votes left parties, merged mun." 
		label var mRightShare "Share of votes right parties, merged mun." 
		label var mFarmShare "Share of votes the Farmers' party, merged mun." 
		label var mTurnout "Voter turnout, merged mun-" 
		label var mReformYear "Year of reform implementation, merged mun." 
		label var mWindow "Year-mReformYear"
		label var MergedMun "Municipality identity in 1966"
		label var CompSchool "Is the school reform implemented?"
		label var mCompSchool "Is the school reform implemented?, merged mun."
		
		order MunCode Year
		save "Swedish Reform/GRRPaper/AJPSSub/AJPSRevision/AcceptedManuscript/ReplicationFiles/MunAnalysis/ajps-DataTableA2.dta", replace
		

	
	
	exit
	
