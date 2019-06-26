****************************************************************************************
**  Replication File Voors and Bulte 2014 Conflict and the Evolution of Institutions **
****************************************************************************************

/*
*Replication File 
*Voors and Bulte 2014 
*JOURNAL OF PEACE RESEARCH
*/

***************************************
		**HOUSEKEEPING**
***************************************
	
	set more off

	*cd "YOUR DIRECTORY\JPR"	
	*In JPR folder, create a folder called "Tables" 
	cd "$DROPLOC\Burundi Conflict and Institutions\Data\JPR"


***************************************
			**ANALYSIS**
***************************************

	use "burundi_conflict_and_institutions_JPR.dta", clear

	*set variables
	global ctrlX "male age age_2 edu exp_ae"
	global ctrlC "landgini_sc dmarket migr_pop ngo"
	global ctrl98 "male98 age98 age98_2 edu98 exp_ae98" 
	

**Table 1. Violent Conflict and Economic Institutions

	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear
	eststo: xi:reg title attack01 $ctrlX $ctrl98 i.reczd, robust
	eststo: xi:reg title attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd)
	eststo: xi:ivreg2 title (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd) first
	
	esttab using "Tables\Tables.rtf", replace star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table I. Conflict and Economic Institutions") label keep (attack01_sclevel attack01 $ctrlX $ctrlC _cons _Iprovince_13) nonotes ///
		addnotes(" † p < 0.10, * p < 0.05, ** p < 0.01. Robust standard errors in parentheses, clustered at village level for columns 2 and 3. Regressions include 1998 controls. Column (4) reports beta coefficients for Column (3).")

	*betas	
	xi:ivreg title (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province, robust beta

**Table 2. Violent Conflict and Social Capital

	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear
	eststo: xi:reg coop attack01 $ctrlX $ctrl98 i.reczd, robust
	eststo: xi:reg coop attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd)
	eststo: xi:ivreg2 coop (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd) first
	eststo: xi:ivreg2 trust_coll (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd) first

	esttab using "Tables\Tables.rtf", append star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table II. Conflict and Social Capital") label keep (attack01_sclevel attack01 $ctrlX $ctrlC _cons _Iprovince_13) nonotes ///
		addnotes(" † p < 0.10, * p < 0.05, ** p < 0.01. Robust standard errors in parentheses clustered at village level for columns 2-4. Regressions include 1998 controls. Column (5) reports beta coefficients for Column (3).")

	*betas	
	xi:ivreg coop  (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province, robust beta
	
**Table 3. Violent Conflict and Political Institutions

	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear
	eststo: xi:reg pi_law attack01 $ctrlX $ctrl98 i.reczd, robust
	eststo: xi:reg pi_law attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd) 
	eststo: xi:ivreg2 pi_law (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd) first
	eststo: xi:ivreg2 pi_loc_pol (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd) first
	
	esttab using "Tables\Tables.rtf", append star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table III. Conflict and Political Institutions") label keep (attack01_sclevel attack01 $ctrlX $ctrlC _cons _Iprovince_13) nonotes ///
		addnotes("† p < 0.10, * p < 0.05, ** p < 0.01. Robust standard errors in parentheses, clustered at village level for columns 3-4. Regressions include 1998 controls. Column (5) reports beta coefficients for Column (3).")
	
	*betas
	xi:ivreg pi_law (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province, robust beta

**Table 4. Conflict, Institutions and Ethnicity

	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear

	eststo: xi:reg coop attack01_sclevel i.province if _merge_subsample==3, robust cluster(reczd) 
	eststo: xi:reg title attack01_sclevel i.province if _merge_subsample==3, robust cluster(reczd) 
	eststo: xi:reg pi_law attack01_sclevel i.province if _merge_subsample==3, robust cluster(reczd) 
	
	eststo: xi:reg coop attack01_sclevel ethnic_homo09  w_ethnic_homo09 i.province if _merge_subsample==3, robust cluster(reczd) 
	eststo: xi:reg title attack01_sclevel ethnic_homo09  w_ethnic_homo09 i.province if _merge_subsample==3, robust cluster(reczd) 
	eststo: xi:reg pi_law attack01_sclevel ethnic_homo09  w_ethnic_homo09 i.province if _merge_subsample==3, robust cluster(reczd) 
	
	esttab using "Tables\Tables.rtf", append star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table IV. Conflict, Institutions and Ethnicity") keep(attack01_sclevel ethnic_homo09 w_ethnic_homo09 _cons) label nonotes ///
		addnotes("† p < 0.10, * p < 0.05, ** p < 0.01. Robust standard errors in parentheses, clustered at village level. Regressions include household, community and 1998 controls")

**Table 5. Post war outcomes
	
	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear
	
	*Panel A: Migration
	collapse migr_pop attack01 $ctrlX landgini_sc dmarket ngo ndadaye $ctrl98 province, by(reczd)

	ren attack01 attack01_sclevel
	
	eststo: xi:reg migr_pop attack01_sclevel $ctrlX landgini_sc dmarket ngo ndadaye $ctrl98 i.province, robust cluster(reczd)
	
	use "burundi_conflict_and_institutions_JPR.dta", clear
	
	*Panel B: Welfare Variables
	eststo: xi:reg exp_ae attack01_sclevel age age_2 edu male $ctrlC $ctrl98 i.province, robust cluster(reczd)
	eststo: xi:reg poverty_status07 attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd)

	*Panel C: Human capital
	eststo: xi:reg edu attack01_sclevel age age_2 male exp_ae $ctrlC $ctrl98 i.province, robust cluster(reczd)
	eststo: xi:reg sickmonths attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd)
	eststo: xi:reg waraffectlife attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd)

	esttab using "Tables\Tables.rtf", append star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table V. Post-war outcome variables") label keep (attack01_sclevel) nonotes ///
		addnotes("Robust standard errors in parentheses clustered at village level, except for Row (1)" "† p < 0.10, * p < 0.05, ** p < 0.01" ///
		"Table reports coefficients from separate regressions, regressing the row variable on community level violence and household, community and 1998 controls and province fixed effects.")

**Table 6. Identification 

	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear

	eststo: xi:probit attack01 $ctrl98 i.reczd, robust cluster(reczd)
	eststo: xi:probit attack01 $ctrl98 livestock93 cashcrop93 ethnicity i.reczd , robust cluster(reczd)
	
	collapse attack01 $ctrl98 ndadaye livestock93 cashcrop93 ldensity90 ethnic_homo93  soc_homo98 province, by(reczd) 
		
	eststo: xi:reg attack01 male98 age98 age98_2 edu98 exp_ae98 ndadaye ldensity90 soc_homo98 i.province, robust
	eststo: xi:reg attack01 livestock93 cashcrop93 ethnic_homo93 i.province, robust 
	
	use "burundi_conflict_and_institutions_JPR.dta", clear
	eststo: xi:probit attrition9807 attack01_sclevel $ctrl98 density90 ndadaye i.strate, robust cluster(reczd)

*Column 6 
	use "Attrition_1993_1998_JPR.dta", clear // dataset from Voors et al AER 2012
		ren litcm edu
		ren agecm age
		ren sexcm male
		replace age = age/10
		replace attrition = 1-attrition
			la var attrition "Attrition 1993-1998"
		replace com_attack9398  = com_attack9398/10
	eststo: xi:probit attrition com_attack9398 edu age male livestock93 i.province_r_93 if age>2.8 &  province_r_93<17 &  i7==1

	esttab using "Tables\Tables.rtf", append star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table VI. Identification") label keep (_cons $ctrl98 attack01_sclevel ndadaye livestock93 cashcrop93 ethnicity ldensity90 ethnic_homo93 soc_homo98 com_attack9398 edu age male) nonotes ///
		addnotes("Robust standard errors in parentheses, clustered at village level" "† p < 0.10, * p < 0.05, ** p < 0.01" ///
		"Column (6) uses the ESD-SR 2002 data to assess attrition between 1993 and 1998. Dependent variable is a dummy, 1 if the respondent was present in village in 1993 and 1998, zero else. Literacy, age and gender are measured in 2002; the dummy for livestock farmer in 1993 is based on recall in 2002, the number of attacks between 1993 and 1998 were drawn from the ACLED database and matched at the commune level. Regression uses province fixed effects.")

******************
**Appendix Tables		
******************

**Table I.A  Descriptive Statistics 	
	use "burundi_conflict_and_institutions_JPR.dta", clear

	*Panel A institutions
	sum title coop trust_coll assoc assoc_activ pi_law pi_loc_pol pi_nat_pol
	*Panel B victimization
	sum attack01 prio_conflict
	*Panel C household
	sum $ctrlX $ctrl98 cashcrop93 livestock93 
	sum poverty_status07 waraffectlife sickmonths
	*Panel D community
	collapse $ctrlC ldensity90 ndadaye cashcrop93 livestock93 ethnic_homo93 soc_homo98 lat lon, by(reczd)
	sum $ctrlC ldensity90 ndadaye lat lon cashcrop93 livestock93 soc_homo98 ethnic_homo93 

**Table II.A  Alternative Specifications - Economic Instititions
	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear
		collapse title coop pi_law attack01 $ctrlX $ctrlC $ctrl98 province, by(reczd)
			ren attack01 attack01_sclevel
	eststo: xi:reg title attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust 
	
	use "burundi_conflict_and_institutions_JPR.dta", clear
	eststo: xi:reg title attack01, robust cluster(reczd)
	eststo: xi:reg title attack01 i.reczd, robust
	eststo: xi:reg title prio_conflict $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd)
	eststo: xi:reg title attack01_sclevel attack01_sclevel2 $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd)
	xi:ivreg title (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province, robust beta
	
	esttab using "Tables\AppTables.rtf", replace star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table II.A. Alternative Specifications - Economic Institutions") keep (attack01_sclevel attack01 attack01_sclevel2 prio_conflict $ctrlX $ctrlC _cons _Iprovince_13)  label nonotes ///
		addnotes("Robust standard errors in parentheses, clustered at village level for columns 2, 4, 5. † p < 0.10, * p < 0.05, ** p < 0.01")

**Table III.A Alternative Specifications - Social Capital
	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear
		collapse title coop pi_law attack01 $ctrlX $ctrlC $ctrl98 province, by(reczd)
			ren attack01 attack01_sclevel
	eststo clear
	eststo: xi:reg coop attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust 
	
	use "burundi_conflict_and_institutions_JPR.dta", clear
	eststo: xi:reg coop attack01, robust cluster(reczd)
	eststo: xi:reg coop attack01 i.reczd, robust 
	eststo: xi:reg assoc attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd)
	eststo: xi:reg assoc_activ attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd)
	eststo: xi:reg coop prio_conflict $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd)		
	eststo: xi:reg coop attack01_sclevel attack01_sclevel2 $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd)
	xi:ivreg coop (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province, robust beta
	
	esttab using "Tables\AppTables.rtf", append star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table III.A. Alternative Specifications - Social Capital") keep (attack01_sclevel attack01 attack01_sclevel2 prio_conflict $ctrlX $ctrlC _cons _Iprovince_13)  label nonotes ///
		addnotes("Robust standard errors in parentheses, clustered at village level for columns 2, 4-7. † p < 0.10, * p < 0.05, ** p < 0.01")
	
**Table IV.A Alternative Specifications - Political Institutions
	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear
		collapse title coop pi_law attack01 $ctrlX $ctrlC $ctrl98 province, by(reczd)
			ren attack01 attack01_sclevel
	eststo: xi:reg pi_law attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust 
	
	use "burundi_conflict_and_institutions_JPR.dta", clear
	eststo: xi:reg pi_law attack01, robust cluster(reczd)
	eststo: xi:reg pi_law attack01 i.reczd, robust
	eststo: xi:reg pi_nat_pol attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd)
	eststo: xi:reg pi_law prio_conflict $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd)
	eststo: xi:reg pi_law attack01_sclevel attack01_sclevel2 $ctrlX $ctrlC $ctrl98 i.province , robust cluster(reczd)
	xi:ivreg pi_law (attack01_sclevel = lat lon) $ctrlX $ctrlC $ctrl98 i.province, robust beta

	esttab using "Tables\AppTables.rtf", append star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table IV.A. Alternative Specifications - Political Institutions") keep (attack01_sclevel attack01 attack01_sclevel2 prio_conflict $ctrlX $ctrlC _cons _Iprovince_13)  label nonotes ///
		addnotes("Robust standard errors in parentheses, clustered at village level for columns 2, 4-6. † p < 0.10, * p < 0.05, ** p < 0.01")

**Table V.A Post-war outcome variables – Full Results
	
	eststo clear
	use "burundi_conflict_and_institutions_JPR.dta", clear
	
	*Panel A: Migration
	collapse migr_pop attack01 $ctrlX landgini_sc dmarket ngo  $ctrl98 province, by(reczd)

	ren attack01 attack01_sclevel
	
	eststo: xi:reg migr_pop attack01_sclevel $ctrlX landgini_sc dmarket ngo $ctrl98 i.province, robust 
	
	use "burundi_conflict_and_institutions_JPR.dta", clear
	
	*Panel B: Welfare Variables
	eststo: xi:reg exp_ae attack01_sclevel age age_2 edu male $ctrlC $ctrl98 i.province, robust cluster(reczd)
	eststo: xi:reg poverty_status07 attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd)

	*Panel C: Human capital
	eststo: xi:reg edu attack01_sclevel age age_2 male exp_ae $ctrlC $ctrl98 i.province, robust cluster(reczd)
	eststo: xi:reg sickmonths attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd)
	eststo: xi:reg waraffectlife attack01_sclevel $ctrlX $ctrlC $ctrl98 i.province, robust cluster(reczd)

	esttab using "Tables\AppTables.rtf", append star(† 0.10 * 0.05 ** 0.01) b(3) se ar2 title("Table V.A. Post-war outcome variables - Full") label nonotes ///
		addnotes("Robust standard errors in parentheses clustered at village level, except for Column (1)" "† p < 0.10, * p < 0.05, ** p < 0.01")
		
************************************************
			** END OF FILE **
************************************************
