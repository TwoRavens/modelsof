/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Stata code for 

    "Careful Commitments: Democratic States and Alliance Design"

    Daina Chiba (dchiba@essex.ac.uk)
    Jesse C. Johnson (j.johnson@uky.edu)
    Brett Ashley Leeds (leeds@rice.edu)

Last modified: 2015-04-22

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//
// NOTE: this do-file requires the following ado file: esttab 
//
// To obtain this ado, type in "net search esttab" from the command window 
// and follow the instructions.
//
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


//+=====+=====+=====+=====+=====+=====+=====+=====+=====+
//  Set the environment
//+=====+=====+=====+=====+=====+=====+=====+=====+=====+

    clear
    version 12
    set more off

    // You may have to set the path to the current folder ("ChibaJohnsonLeedsJOPrep")

    //cd PATH_TO_THE_IORAIC_FOLDER

    // Start a log file in text

    cap log close
    log using "output_logfile_main.log", text replace

//+=====+=====+=====+=====+=====+=====+=====+=====+=====+
//  Load data and define the 2-part model
//+=====+=====+=====+=====+=====+=====+=====+=====+=====+

    // Load the data 

    use "CJL_data_zero10.dta", clear


    // Define the likelihood function for the logit two-part model

    cap program drop tpm
    program define tpm, eclass
        version 12
        args lnf out sel 
        tempvar pg pb
        qui{
        gen double `pg' = 1/(1 + exp(-`sel'))
        gen double `pb' = 1/(1 + exp(-`out'))
        replace `lnf' = ln(1-`pg')            if $ML_y1 == 0
        replace `lnf' = ln(`pg') + ln(1-`pb') if $ML_y1 == 1
        replace `lnf' = ln(`pg') + ln(`pb')   if $ML_y1 == 2
        }
    end    

//+=====+=====+=====+=====+=====+=====+=====+=====+=====+
//  Testing Hypothesis 1 (Table 1)
//+=====+=====+=====+=====+=====+=====+=====+=====+=====+

// Logit 1

    logit onlyconsul dem_prop
    estimates store logit1

// Logit 2: with control variables

    logit onlyconsul dem_prop min_s_2cat mem_num max_threat wartime
    estimates store logit2

// 2PM (using suest)

    // Generate the "selection" variable (any alliance)
    gen anyalliance = h1_cat3 > 0

    // Analyze the "selection" stage
    logit anyalliance dem_prop min_s_2cat mem_num max_threat wartime
    estimates store logit_aa

    // Combine the "selection" and "outcome" stages using suest
    suest logit2 logit_aa
    estimates store tpm1_suest

// 2PM (using the defined LL function)

ml model lf tpm ///
    (out:h1_cat3 = dem_prop min_s_2cat mem_num max_threat wartime) ///
    (sel:          dem_prop min_s_2cat mem_num max_threat wartime), ///
    tech(bfgs) robust
ml maximize, nolog
estimates store tpm1

// Compare 2PM estimates from suest and the defined LL function
esttab tpm1_suest tpm1, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.2f)


    /////////////////////////
    //     Table 1
    /////////////////////////

    esttab logit1 logit2 tpm1, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.2f) label



//+=====+=====+=====+=====+=====+=====+=====+=====+=====+
//  Testing Hypothesis 2 (Table 2)
//+=====+=====+=====+=====+=====+=====+=====+=====+=====+

// Logit 3

    logit defcon dem_prop if defense==1
    estimates store logit3

// Logit 4: with control variables

    logit defcon dem_prop min_s_2cat mem_num offense consul if defense==1
    estimates store logit4

// 2PM (using suest)

    // Generate the "selection" variable (any alliance)
    gen defense_sel = h2_cat3 > 0

    // Analyze the "selection" stage
    logit defense_sel dem_prop min_s_2cat mem_num
    estimates store logit_def

    // Combine the "selection" and "outcome" stages using suest
    suest logit4 logit_def
    estimates store tpm2_suest

// 2PM (using the defined LL function)

ml model lf tpm ///
    (out: h2_cat3 = dem_prop min_s_2cat mem_num offense_tpm consul_tpm) ///
    (sel:           dem_prop min_s_2cat mem_num), ///
    tech(bfgs) robust
ml maximize, nolog
estimates store tpm2


// Compare 2PM estimates from suest and the defined LL function
esttab tpm2_suest tpm2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.2f)


    /////////////////////////
    //     Table 2
    /////////////////////////

    esttab logit3 logit4 tpm2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.2f) label



//+=====+=====+=====+=====+=====+=====+=====+=====+=====+
// Export the estimates
//+=====+=====+=====+=====+=====+=====+=====+=====+=====+

// 2PM results for Hypothesis 1

estimates restore tpm1

    mat beta1_2PM = e(b)
    mat vcov1_2PM = e(V)

// Export Beta and V-COV matrix

preserve
	svmat beta1_2PM, names(eqcol)
	outsheet out* sel* in 1 using "output_2PM1beta.txt", replace nolabel
restore

preserve
	svmat vcov1_2PM, names(eqcol)
	outsheet out* sel* in 1/12 using "output_2PM1vcov.txt", replace nolabel
restore


// 2PM results for Hypothesis 2

estimates restore tpm2

    mat beta2_2PM = e(b)
    mat vcov2_2PM = e(V)

// Export Beta and V-COV matrix

preserve
	svmat beta2_2PM, names(eqcol)
	outsheet out* sel* in 1 using "output_2PM2beta.txt", replace nolabel
restore

preserve
	svmat vcov2_2PM, names(eqcol)
	outsheet out* sel* in 1/10 using "output_2PM2vcov.txt", replace nolabel
restore


//+=====+=====+=====+=====+=====+=====+=====+=====+=====+
//  Robustness Checks
//+=====+=====+=====+=====+=====+=====+=====+=====+=====+

//==========================================
// Probabilistic deterrence
//==========================================

    logit prob_det dem_prop if defense==1
    estimates store a2_1

    logit prob_det dem_prop min_s_2cat mem_num max_threat wartime if defense==1
    estimates store a2_2


    /////////////////////////
    //     Table A.2
    /////////////////////////

    esttab a2_1 a2_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label



//==========================================
// Models with a democracy dummy
//==========================================

    // Hypothesis 1

    logit onlyconsul dem_dich
    estimates store a3_1

    logit onlyconsul dem_dich min_s_2cat mem_num max_threat wartime
    estimates store a3_2

    /////////////////////////
    //     Table A.3
    /////////////////////////

    esttab a3_1 a3_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label



    // Hypothesis 2

    logit defcon dem_dich if defense==1
    estimates store a4_1

    logit defcon dem_dich min_s_2cat mem_num offense consul if defense==1
    estimates store a4_2

    /////////////////////////
    //     Table A.4
    /////////////////////////

    esttab a4_1 a4_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// Exclude NATO
//==========================================

    // Hypothesis 1

    logit onlyconsul dem_prop if atopid != 3180
    estimates store a5_1

    logit onlyconsul dem_prop min_s_2cat mem_num max_threat wartime if atopid != 3180
    estimates store a5_2

    /////////////////////////
    //     Table A.5
    /////////////////////////

    esttab a5_1 a5_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


    // Hypothesis 2

    logit defcon dem_prop if defense==1 & atopid != 3180
    estimates store a6_1

    logit defcon dem_prop min_s_2cat mem_num offense consul if defense==1 & atopid != 3180
    estimates store a6_2

    /////////////////////////
    //     Table A.6
    /////////////////////////

    esttab a6_1 a6_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// Cold War
//==========================================

    cap drop coldwar
	gen coldwar = year >= 1946 & year <= 1991

    // Hypothesis 1

    logit onlyconsul dem_prop if coldwar == 0
    estimates store a7_1

    logit onlyconsul dem_prop min_s_2cat mem_num max_threat wartime if coldwar == 0
    estimates store a7_2

    logit onlyconsul dem_prop coldwar
    estimates store a7_3

    logit onlyconsul dem_prop min_s_2cat mem_num max_threat wartime coldwar
    estimates store a7_4

    /////////////////////////
    //     Table A.7
    /////////////////////////

    esttab a7_1 a7_2 a7_3 a7_4, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


    // Hypothesis 2

    logit defcon dem_prop if defense == 1 & coldwar == 0
    estimates store a8_1

    logit defcon dem_prop min_s_2cat mem_num offense consul if defense == 1 & coldwar == 0
    estimates store a8_2

    logit defcon dem_prop coldwar if defense == 1
    estimates store a8_3

    logit defcon dem_prop min_s_2cat mem_num offense consul coldwar if defense == 1
    estimates store a8_4

    /////////////////////////
    //     Table A.8
    /////////////////////////

    esttab a8_1 a8_2 a8_3 a8_4, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// US alliances
//==========================================

    gen us_alliance = ///
        mem1==2 | mem2==2 | mem3==2 | mem4==2 | mem5==2 | mem6==2 | mem7==2 | mem8==2 | mem9==2 | mem10==2 | ///
        mem11==2 | mem12==2 | mem13==2 | mem14==2 | mem15==2 | mem16==2 | mem17==2 | mem18==2 | mem19==2 | mem20==2 | ///
        mem21==2 | mem22==2 | mem23==2 | mem24==2 | mem25==2 | mem26==2 | mem27==2 | mem28==2 | mem29==2 | mem30==2 | ///
        mem31==2 | mem32==2 | mem33==2 | mem34==2 | mem35==2 | mem36==2 | mem37==2 | mem38==2 | mem39==2 | mem40==2 | ///
        mem41==2 | mem42==2 | mem43==2

    // Hypothesis 1

    logit onlyconsul dem_prop if us_alliance == 0
    estimates store a9_1

    logit onlyconsul dem_prop min_s_2cat mem_num max_threat wartime if us_alliance == 0
    estimates store a9_2

    logit onlyconsul dem_prop us_alliance
    estimates store a9_3

    logit onlyconsul dem_prop min_s_2cat mem_num max_threat wartime us_alliance
    estimates store a9_4

    /////////////////////////
    //     Table A.9
    /////////////////////////

    esttab a9_1 a9_2 a9_3 a9_4, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


    // Hypothesis 2

    logit defcon dem_prop if defense == 1 & us_alliance == 0
    estimates store a10_1

    logit defcon dem_prop min_s_2cat mem_num offense consul if defense == 1 & us_alliance == 0
    estimates store a10_2

    logit defcon dem_prop us_alliance if defense == 1
    estimates store a10_3

    logit defcon dem_prop min_s_2cat mem_num offense consul us_alliance if defense == 1
    estimates store a10_4

    /////////////////////////
    //     Table A.10
    /////////////////////////

    esttab a10_1 a10_2 a10_3 a10_4, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// Exclude 4810 & 4985
//==========================================

// Exclude those that started out as nonaggression pacts (4810 & 4985)

gen start_nonagg = atopid == 4810 | atopid == 4985


    // Hypothesis 1

    logit onlyconsul dem_prop if start_nonagg == 0
    estimates store a11_1

    logit onlyconsul dem_prop min_s_2cat mem_num max_threat wartime if start_nonagg == 0
    estimates store a11_2

    /////////////////////////
    //     Table A.11
    /////////////////////////

    esttab a11_1 a11_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


    // Hypothesis 2

    logit defcon dem_prop if defense == 1 & start_nonagg == 0
    estimates store a12_1

    logit defcon dem_prop min_s_2cat mem_num offense consul if defense == 1 & start_nonagg == 0
    estimates store a12_2

    /////////////////////////
    //     Table A.12
    /////////////////////////

    esttab a12_1 a12_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// Include neutrality
//==========================================

// Recode DV so it includes consultation pacts that have neutrality obligation

    gen onlyconsul_neu = consul==1 &  defense==0 & offense==0
    recode onlyconsul_neu (0=.) if onlyconsul == .
    tab onlyconsul_neu

	
	logit onlyconsul_neu dem_prop 
    estimates store a13_1

	logit onlyconsul_neu dem_prop min_s_2cat mem_num max_threat wartime
    estimates store a13_2


    /////////////////////////
    //     Table A.13
    /////////////////////////

    esttab a13_1 a13_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// Exclude neutrality only pacts
//==========================================

// Identify neutrality only pacts

    gen onlyneu = neutral==1 & defense==0 & offense==0 & consul==0
    tab onlyneu
    recode onlyneu (0=.) if onlyconsul == .

	
	logit onlyconsul dem_prop if onlyneu == 0
    estimates store a14_1

	logit onlyconsul dem_prop min_s_2cat mem_num max_threat wartime if onlyneu==0
    estimates store a14_2


    /////////////////////////
    //     Table A.14
    /////////////////////////

    esttab a14_1 a14_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// Use only polity2 scores
//==========================================

// Not coding missing democracy scores (Raw Polity)

    // Hypothesis 1

	logit onlyconsul dem_prop_RawPolity
    estimates store a15_1

	logit onlyconsul dem_prop_RawPolity min_s_2cat mem_num max_threat wartime
    estimates store a15_2


    /////////////////////////
    //     Table A.15
    /////////////////////////

    esttab a15_1 a15_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


    // Hypothesis 2

    logit defcon dem_prop_RawPolity if defense == 1
    estimates store a16_1

    logit defcon dem_prop_RawPolity min_s_2cat mem_num offense consul if defense == 1
    estimates store a16_2

    /////////////////////////
    //     Table A.16
    /////////////////////////

    esttab a16_1 a16_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// Drop an alliance with occupied members
//==========================================

    // Hypothesis 1

	logit onlyconsul dem_prop if atopid != 2550
    estimates store a17_1

	logit onlyconsul dem_prop min_s_2cat mem_num max_threat wartime if atopid != 2550
    estimates store a17_2


    /////////////////////////
    //     Table A.17
    /////////////////////////

    esttab a17_1 a17_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


    // Hypothesis 2

    logit defcon dem_prop if defense == 1 & atopid != 2550
    estimates store a18_1

    logit defcon dem_prop min_s_2cat mem_num offense consul if defense == 1 & atopid != 2550
    estimates store a18_2

    /////////////////////////
    //     Table A.18
    /////////////////////////

    esttab a18_1 a18_2, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// Mean similarity instead of minimum
//==========================================

    // Hypothesis 1

	logit onlyconsul dem_prop mean_s_2cat mem_num max_threat wartime
    estimates store a19


    /////////////////////////
    //     Table A.19
    /////////////////////////

    esttab a19, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


    // Hypothesis 2

    logit defcon dem_prop mean_s_2cat mem_num offense consul if defense == 1
    estimates store a20

    /////////////////////////
    //     Table A.20
    /////////////////////////

    esttab a20, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// Mean threat instead of maximum
//==========================================

	logit onlyconsul dem_prop min_s_2cat mem_num mean_threat wartime
    estimates store a21


    /////////////////////////
    //     Table A.21
    /////////////////////////

    esttab a21, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label


//==========================================
// 5 times more zeros
//==========================================

    use "CJL_data_zero5.dta", clear

    // Hypothesis 1

    ml model lf tpm ///
        (out:h1_cat3 = dem_prop min_s_2cat mem_num max_threat wartime) ///
        (sel:          dem_prop min_s_2cat mem_num max_threat wartime), ///
        tech(bfgs) robust
    ml maximize, nolog
    estimates store tpm1_5zero


    /////////////////////////
    //     Table A.22
    /////////////////////////

    esttab tpm1 tpm1_5zero, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.2f) label


    // Hypothesis 2

    ml model lf tpm ///
    (out: h2_cat3 = dem_prop min_s_2cat mem_num offense_tpm consul_tpm) ///
    (sel:           dem_prop min_s_2cat mem_num), ///
    tech(bfgs) robust
    ml maximize, nolog
    estimates store tpm2_5zero


    /////////////////////////
    //     Table A.23
    /////////////////////////

    esttab tpm2 tpm2_5zero, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.2f) label



//==========================================
// Multinomial logit
//==========================================

// Hypothesis 1 (5 times more zeros)

	// 0 as the baseline
	mlogit h1_cat3 dem_prop min_s_2cat mem_num max_threat wartime, base(0)
	estimates store ml5z_0

	// 1 as the baseline
	mlogit h1_cat3 dem_prop min_s_2cat mem_num max_threat wartime, base(1)
	estimates store ml5z_1

// Hypothesis 2 (5 times more zeros)

	mlogit h2_cat4 dem_prop min_s_2cat mem_num, base(2)
	estimates store ml5z_4cat2



    use "CJL_data_zero10.dta", clear

// Hypothesis 1 (10 times more zeros)

	// 0 as the baseline
	mlogit h1_cat3 dem_prop min_s_2cat mem_num max_threat wartime, base(0)
	estimates store ml10z_0

	// 1 as the baseline
	mlogit h1_cat3 dem_prop min_s_2cat mem_num max_threat wartime, base(1)
	estimates store ml10z_1

	// Hausman test
	mlogit h1_cat3 dem_prop min_s_2cat mem_num max_threat wartime, base(1), if h1_cat3 != 0

	hausman ml10z_1, alleqs constant

// Hypothesis 2 (10 times more zeros)

	mlogit h2_cat4 dem_prop min_s_2cat mem_num, base(2)
	estimates store ml10z_4cat2

	// Hausman test 1
	mlogit h2_cat4 dem_prop min_s_2cat mem_num, base(2), if h2_cat4 != 0
	hausman ml10z_4cat2, alleqs constant



    /////////////////////////
    //     Table A.24
    /////////////////////////

    esttab ml10z_1 ml10z_0 ml5z_0 ml5z_1,  star(* 0.10 ** 0.05 *** 0.01) b(%9.2f) se


    /////////////////////////
    //     Table A.25
    /////////////////////////

    esttab ml10z_4cat2 ml5z_4cat2,  star(* 0.10 ** 0.05 *** 0.01) b(%9.2f) se




cap log close
exit

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ END OF FILE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
