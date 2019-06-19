*** Stata file to finish up on arbitrage

/* MODIFY THIS LINE TO SET THE DIRECTORY */
local dir "~mainil/100_bill/100_Bill_on_the_Sidewalk/"

local datadir `dir'/SAS/output
local outdir `dir'/Stata/data
local logdir `dir'/Stata/logfiles
local graphdir `dir'/Stata/graphs

*** Data transformation
	*** Insheet each of the SAS output files
	*** Save as a stata dataset
	foreach x in a av co du k m s{
		*** Insheet: part 2: EXPORTED EXANTE NUMBERS
			insheet using `datadir'/`x'_oldEXANTE.txt, clear
			rename v1 clid
			rename v2 piid
			rename v3 lossExanteDollar
			rename v4 lossExantePct

			***If all blank, need to convert to string for later usage
			save `outdir'/`x'_oldEXANTE.dta, replace
			clear
			
			insheet using `datadir'/`x'_youngEXANTE.txt, clear
			rename v1 clid
			rename v2 piid
			rename v3 lossExanteDollar
			rename v4 lossExantePct
			***If all blank, need to convert to string for later usage
			save `outdir'/`x'_youngEXANTE.dta, replace
	*** Merge/append to full file			
			clear
			use `outdir'/`x'_oldEXANTE
			append using `outdir'/`x'_youngEXANTE
			save `outdir'/`x'_fullEXANTE.dta, replace
			clear
	}
	
	
	foreach x in a av co du k m s{
	*** Insheet: get varlist from exportIndividual macro in macros.sas
		*** Old
			insheet using `datadir'/`x'_old.txt, clear
			rename v1 undersaverMyopicV
			rename v2 undersaverExpostV
			rename v3 moneyLeaver
			rename v4 A_dum
			rename v5 AV_dum
			rename v6 CO_dum
			rename v7 DU_dum
			rename v8 K_dum
			rename v9 M_dum
			rename v10 S_dum
			rename v11 vestingExpost
			rename v12 vestingMyopic
			rename v13 age
			rename v14 tenure
			rename v15 male
			rename v16 yearpay
			rename v17 matchrtOne
			rename v18 matchrtTwo
			rename v19 marital
			
			rename v23 lossRaw
			rename v24 lossRawPct
			rename v25 clid
			rename v26 piid
			rename v27 participation
			rename v28 pstatd98
			rename v29 partdt
			rename v30 neverPart
			rename v31 totbal
			rename v32 maxMatch
			rename v33  lossUndersaverMyopicV
			rename v34 lossUndersaverMyopicVPct
			rename v35 maxMatchMyopicV
			rename v36 ataxb98
			rename v37 btaxb98
			rename v38 ataxrt98
			rename v39 btaxrt98
			rename v40 atcont98
			rename v41 btcont98
			
			*** If all blank, need to convert to string for later usage
			tostring marital, replace
			gen married = 1 if marital == "M"
				replace married = 0 if married != 1
			save `outdir'/`x'_old.dta, replace
			clear
		*** Young
			clear
			insheet using `datadir'/`x'_young.txt, clear
			rename v1 undersaverMyopicV
			rename v2 undersaverExpostV
			rename v3 moneyLeaver
			rename v4 A_dum
			rename v5 AV_dum
			rename v6 CO_dum
			rename v7 DU_dum
			rename v8 K_dum
			rename v9 M_dum
			rename v10 S_dum
			rename v11 vestingExpost
			rename v12 vestingMyopic
			rename v13 age
			rename v14 tenure
			rename v15 male
			rename v16 yearpay
			rename v17 matchrtOne
			rename v18 matchrtTwo
			rename v19 marital
			
			rename v23 lossRaw
			rename v24 lossRawPct
			rename v25 clid
			rename v26 piid
			rename v27 participation
			rename v28 pstatd98
			rename v29 partdt
			rename v30 neverPart
			rename v31 totbal
			rename v32 maxMatch
			rename v33 lossUndersaverMyopicV
			rename v34 lossUndersaverMyopicVPct
			rename v35 maxMatchMyopicV
			rename v36 ataxb98
			rename v37 btaxb98
			rename v38 ataxrt98
			rename v39 btaxrt98
			rename v40 atcont98
			rename v41 btcont98
			
			***If all blank, need to convert to string for later usage
			tostring marital, replace
			gen married = 1 if marital == "M"
				replace married = 0 if married != 1

			save `outdir'/`x'_young.dta, replace

		*** Merge/append for a full file
			clear
			use `outdir'/`x'_old
			append using `outdir'/`x'_young
			save `outdir'/`x'_full.dta, replace
			clear
	
	}

	
*** Data summary checks
log using `logdir'/master.log, replace
	foreach x in a av co du k m s{
		use `outdir'/`x'_full
		sum *
		tab male
		tab undersaverMyopicV
		tab A_dum
		tab AV_dum
		tab M_dum
		tab K_dum
		tab CO_dum
		tab DU_dum
		tab S_dum
	}
log close

*** Now, create a file of all the companies
	use `outdir'/a_full
	append using `outdir'/av_full
	append using `outdir'/co_full
	append using `outdir'/du_full
	append using `outdir'/k_full
	append using `outdir'/m_full
	append using `outdir'/s_full
	save `outdir'/all_full, replace
	clear
	
	use `outdir'/a_old
	append using `outdir'/av_old
	append using `outdir'/co_old
	append using `outdir'/du_old
	append using `outdir'/k_old
	append using `outdir'/m_old
	append using `outdir'/s_old
	save `outdir'/all_old, replace
	clear

	use `outdir'/a_young
	append using `outdir'/av_young
	append using `outdir'/co_young
	append using `outdir'/du_young
	append using `outdir'/k_young
	append using `outdir'/m_young
	append using `outdir'/s_young
	save `outdir'/all_young, replace
	clear




*** Undersaving/table-leaving figures
	set scheme sj
	foreach x in a av co du k m s {
		use `outdir'/`x'_full
		gen ageInt = int(age)
		drop if ageInt > 65
			gen x = 1
			collapse (mean) undersaverMyopicV (mean) undersaverExpostV (mean) moneyLeaver (count) x, by(ageInt)
			line moneyLeaver ageInt , title("Fraction of employees leaving money on the table" "by age, company `x'") xtitle(Age) ytitle(Fraction leaving money)
			graph save `graphdir'/`x'_leaverAge.gph, replace
			clear
	}
	foreach x in a av co du k m s {
		use `outdir'/`x'_old
		gen ageInt = int(age)
		drop if ageInt > 65
			gen x = 1
			collapse (mean) undersaverMyopicV (mean) undersaverExpostV (mean) moneyLeaver (count) x, by(ageInt)

			line undersaverMyopicV ageInt , title("Fraction of myopic undersavers by age, company `x'")  xtitle(Age) ytitle(Fraction undersaving)
			graph save `graphdir'/`x'_myopicAge.gph, replace
			line undersaverExpostV ageInt , title("Fraction of expost undersavers by age, company `x'")  xtitle(Age) ytitle(Fraction undersaving)
			graph save `graphdir'/`x'_expostAge.gph, replace
			clear
	}
	

	*** Do graphs for all companies
		use `outdir'/all_full
		gen ageInt = int(age)
		drop if ageInt > 65
			gen x = 1
			collapse (mean) undersaverMyopicV (mean) undersaverExpostV (mean) moneyLeaver (count) x, by(ageInt)
			line moneyLeaver ageInt , title("Fraction of employees leaving money on the table" "by age, all companies") xtitle(Age) ytitle(Fraction leaving money)
			graph save `graphdir'/all_leaverAge.gph, replace
			
			outsheet using `outdir'/allAge_leaverAgeData.csv, replace comma
			clear
		*** Do again, only for old
		use `outdir'/all_old
		gen ageInt = int(age)
		drop if ageInt > 65
			gen x = 1
			collapse (mean) undersaverMyopicV (mean) undersaverExpostV (mean) moneyLeaver (count) x, by(ageInt)

			line undersaverMyopicV ageInt , title("Fraction of myopic undersavers by age, all companies")  xtitle(Age) ytitle(Fraction undersaving)
			graph save `graphdir'/all_myopicAge.gph, replace
			line undersaverExpostV ageInt , title("Fraction of expost undersavers by age, all companies")  xtitle(Age) ytitle(Fraction undersaving)
			graph save `graphdir'/all_expostAge.gph, replace
			outsheet using `outdir'/oldAge_leaverAgeData.csv, replace comma
			clear
*** Run graphTranslation.do on pc
	

*** Now, do the probit with expost as dependent, old only
	use `outdir'/all_old
	gen log_ten = log(tenure)
	gen log_sal = log(yearpay)	
log using `logdir'/masterProbit.log, replace
	*** Undersaver- myopic
	probit undersaverMyopicV male married age log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
	dprobit undersaverMyopicV male married age log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
	*** Undersaver- expost
	probit undersaverExpostV male married age log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
	dprobit undersaverExpostV male married age log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
	*** Money Leaver
	probit moneyLeaver male married age log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
	dprobit moneyLeaver male married age log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
	clear

*** Now, young only.
	use `outdir'/all_young
	gen log_ten = log(tenure)
	gen log_sal = log(yearpay)
	gen ageSq = age*age
	*** Money leaver- same spec.
	probit moneyLeaver male married age log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
	dprobit moneyLeaver male married age log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
	*** Money leaver- Age sq
	probit moneyLeaver male married age ageSq log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
	dprobit moneyLeaver male married age ageSq log_ten log_sal A_dum AV_dum M_dum K_dum CO_dum DU_dum
 	

clear all
capture log close

*** end code