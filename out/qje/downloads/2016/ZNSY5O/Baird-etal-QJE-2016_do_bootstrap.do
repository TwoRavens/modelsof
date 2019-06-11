// *************************************************************************************************
// * ANALYSIS DO FILE FOR "WORMS AT WORK: LONG-RUN IMPACTS OF A CHILD HEALTH INVESTMENT"
// * SARAH BAIRD, JOAN HAMORY HICKS, MICHAEL KREMER, AND EDWARD MIGUEL
// * DATE: JULY 2016 
// *************************************************************************************************

// NOTE: THIS DO FILE PRODUCES THE BOOTSTRAP RESULTS PRESENTED IN SECTION 5 OF BAIRD ET AL. (2016)

// Preamble
	version 10.1
	clear
	set mem 750m
	set matsize 800
	cap log close
	program drop _all

// Folder structure
	global dir   = "" // UPDATE THIS FOLDER FOR YOUR MACHINE
	global da   = "$dir/data"
	global dl    = "$dir/output" 
	global output = "$dir/output"

// Opens data
	use "$da/Baird-etal-QJE-2016_data_primary", clear
	
// Controls for regression	
	global x_controls1 saturation_dm demeaned_popT_6k ///
		zoneidI2-zoneidI8 pup_pop wave2 month_interviewI2-month_interviewI12 cost_sharing  ///
		std98_base_I2 std98_base_I3 std98_base_I4 std98_base_I5 std98_base_I6 female_baseline avgtest96
	
	
****************************************
** TABLE 5: MAIN RESULTS IN THE PAPER **
****************************************

*** Panel B: No health spillovers - Partial subsidy
	program define worms1, rclass
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0  , cl(psdpsch98)
			scalar BETA = _b[treatment]
		reg s5_attendSsch1999 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S1 = (_b[treatment] * 116.85) / (1.0985)
		reg s5_attendSsch2000 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S2 = (_b[treatment] * 116.85) / (1.0985)^2
		reg s5_attendSsch2001 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S3 = (_b[treatment] * 116.85) / (1.0985)^3
		reg s5_attendSsch2002 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S4 = (_b[treatment] * 116.85) / (1.0985)^4
		reg s5_attendSsch2003 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S5 = (_b[treatment] * 116.85) / (1.0985)^5
		reg s5_attendSsch2004 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S6 = (_b[treatment] * 116.85) / (1.0985)^6
		reg s5_attendSsch2005 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S7 = (_b[treatment] * 116.85) / (1.0985)^7
		reg s5_attendSsch2006 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S8 = (_b[treatment] * 116.85) / (1.0985)^8
		reg s5_attendSsch2007 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S9 = (_b[treatment] * 116.85) / (1.0985)^9
			scalar SCHOOL = S1 + S2 + S3 + S4 + S5 + S6 + S7 + S8 + S9
		return scalar a = ( .5 * BETA) * (.19 / .75) * 52 * 0.17012446
		return scalar b = ( .5 * BETA  * (.19 / .75) * 52 * 0.17012446) * 9.22621041
		return scalar c = ((.5 * BETA  * (.19 / .75) * 52 * 0.17012446) * 9.22621041) * 0.16575 - (SCHOOL * .19/.75)
	end
	
	bootstrap a = r(a) b = r(b) c = r(c), reps(1000) cl(psdpsch98) seed(831148) : worms1

	
*** Panel B: No health spillovers - Full subsidy
	program define worms2, rclass
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
			scalar BETA = _b[treatment]
		reg s5_attendSsch1999 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S1 = (_b[treatment] * 116.85) / (1.0985)
		reg s5_attendSsch2000 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S2 = (_b[treatment] * 116.85) / (1.0985)^2
		reg s5_attendSsch2001 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S3 = (_b[treatment] * 116.85) / (1.0985)^3
		reg s5_attendSsch2002 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S4 = (_b[treatment] * 116.85) / (1.0985)^4
		reg s5_attendSsch2003 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S5 = (_b[treatment] * 116.85) / (1.0985)^5
		reg s5_attendSsch2004 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S6 = (_b[treatment] * 116.85) / (1.0985)^6
		reg s5_attendSsch2005 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S7 = (_b[treatment] * 116.85) / (1.0985)^7
		reg s5_attendSsch2006 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S8 = (_b[treatment] * 116.85) / (1.0985)^8
		reg s5_attendSsch2007 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S9 = (_b[treatment] * 116.85) / (1.0985)^9
			scalar SCHOOL = S1 + S2 + S3 + S4 + S5 + S6 + S7 + S8 + S9
		return scalar a = ( .5 * BETA) * 52 * 0.17012446
		return scalar b = ( .5 * BETA  * 52 * 0.17012446) * 9.22621041
		return scalar c = ((.5 * BETA  * 52 * 0.17012446) * 9.22621041) * 0.16575 - SCHOOL
	end
		bootstrap a = r(a) b = r(b) c = r(c), reps(1000) seed(831148) cl(psdpsch98) sa("$output/t5_no_full", replace): worms2
	

	// Sentence: "29% percent of the time the value of net revenue gains are negative"
		preserve
		use "$output/t5_no_full", clear
		g x = (c < 0)
		sum x
		restore
	
	
*** Panel C: With health spillovers - Partial subsidy
	program define worms3, rclass
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, cl(psdpsch98)
			scalar BETA  = _b[treatment]
			scalar GAMMA = _b[saturation_dm]
		reg s5_attendSsch1999 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S1 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)
		reg s5_attendSsch2000 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S2 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^2
		reg s5_attendSsch2001 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S3 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^3
		reg s5_attendSsch2002 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S4 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^4
		reg s5_attendSsch2003 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S5 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^5
		reg s5_attendSsch2004 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S6 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^6
		reg s5_attendSsch2005 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S7 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^7
		reg s5_attendSsch2006 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S8 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^8
		reg s5_attendSsch2007 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , cl(psdpsch98)
			scalar S9 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^9
			scalar SCHOOL = S1 + S2 + S3 + S4 + S5 + S6 + S7 + S8 + S9	
		return scalar a = ((  .5 * BETA * .19/.75) + ((GAMMA * .681 * .19/.75)/.681)) * 52 * 0.17012446
		return scalar b = ((( .5 * BETA * .19/.75) + ((GAMMA * .681 * .19/.75)/.681)) * 52 * 0.17012446) * 9.22621041
		return scalar c = ((((.5 * BETA * .19/.75) + ((GAMMA * .681 * .19/.75)/.681)) * 52 * 0.17012446) * 9.22621041) * 0.16575 - (SCHOOL * .19/.75)
	end
	
	bootstrap a = r(a) b = r(b) c = r(c), reps(1000) seed(831148) cl(psdpsch98) : worms3
	

*** Panel C: With health spillovers - Full subsidy
	program define worms4, rclass
		reg total_hours treatment $x_controls1 [pw=weight] if insample==1 & female_baseline==0, r cl(psdpsch98)
			scalar BETA  = _b[treatment]
			scalar GAMMA = _b[saturation_dm]
		reg s5_attendSsch1999 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S1 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)
		reg s5_attendSsch2000 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S2 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^2
		reg s5_attendSsch2001 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S3 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^3
		reg s5_attendSsch2002 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S4 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^4
		reg s5_attendSsch2003 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S5 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^5
		reg s5_attendSsch2004 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S6 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^6
		reg s5_attendSsch2005 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S7 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^7
		reg s5_attendSsch2006 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S8 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^8
		reg s5_attendSsch2007 treatment $x_controls1 [pweight=weight] if insample_edu_matrix==1 , r cl(psdpsch98)
			scalar S9 = ((_b[treatment] + _b[saturation_dm])     * 116.85) / (1.0985)^9
			scalar SCHOOL = S1 + S2 + S3 + S4 + S5 + S6 + S7 + S8 + S9
		return scalar a = ((  .5 * BETA) + ((.75 * .681 * GAMMA)/.681)) * 52 * 0.17012446
		return scalar b = ((( .5 * BETA) + ((.75 * .681 * GAMMA)/.681)) * 52 * 0.17012446) * 9.22621041
		return scalar c = ((((.5 * BETA) + ((.75 * .681 * GAMMA)/.681)) * 52 * 0.17012446) * 9.22621041) * 0.16575 - SCHOOL
	end
	
	bootstrap a = r(a) b = r(b) c = r(c), reps(1000) seed(831148) cl(psdpsch98) : worms4
