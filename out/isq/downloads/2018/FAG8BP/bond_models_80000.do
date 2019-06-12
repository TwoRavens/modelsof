///////////////////////
// Compare transparencies' affects on sovereign bonds
// 25 May 2015
// MIT License
///////////////////////

// Set working directory, change as needed/
cd "/git_repositories/FRTIndex/paper/"

// Load data
use "analysis/data_and_misc/frt_hrv_obi_bond_80000.dta", clear

// Inverse hyperbolic sine transformation
gen lfrt_log = log(lfrt + sqrt(lfrt^lfrt + 1))
gen dfrt_log = log(dfrt + sqrt(dfrt^dfrt + 1))

//////// Examine Change in long-term rate //////////////////////////////////////
// FRT
xtreg dltrate lltrate lfrt dfrt lpubdebtgdp ///
    dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth doecdgrowth lvix ///
    dvix lcountry_growth dcountry_growth, ///
    cluster(ccode1) i(ccode1) fe vsquish noomit

    regsave using "tables/FRT1.dta", detail(all) replace table(LongRunRate, ///
        order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// HRV
xtreg dltrate lltrate lhrv_mean dhrv_mean ///
    lpubdebtgdp dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth ///
    doecdgrowth lvix dvix lcountry_growth dcountry_growth, ///
    cluster(ccode1) i(ccode1) fe vsquish noomit

    regsave using "tables/HRV1.dta", detail(all) replace table(LongRunRate, ///
        order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// OBI
xtreg dltrate lltrate lobi_filled dobi_filled ///
    lpubdebtgdp dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth ///
    doecdgrowth lvix dvix, cluster(ccode1) i(ccode1) fe vsquish noomit

//////// Examine Change in long-term rate US Spread ////////////////////////////
//FRT
xtreg dltspreadus lltspreadus lfrt dfrt lpubdebtgdp ///
    dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth doecdgrowth lvix ///
    dvix lcountry_growth dcountry_growth ///
    if country != "United States", cluster(ccode1) i(ccode1) fe vsquish noomit

    regsave using "tables/FRT2.dta", detail(all) replace ///
        table(ChangeLongRunRate, order(regvars r2) format(%5.2f) ///
        paren(stderr) asterisk())

// HRV
xtreg dltspreadus lltspreadus lhrv_mean dhrv_mean ///
    lpubdebtgdp dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth ///
    doecdgrowth lvix dvix lcountry_growth dcountry_growth ///
    if country != "United States", cluster(ccode1) i(ccode1) fe vsquish noomit

    regsave using "tables/HRV2.dta", detail(all) replace ///
        table(ChangeLongRunRate, order(regvars r2) format(%5.2f) ///
        paren(stderr) asterisk())

// OBI
xtreg dltspreadus lltspreadus lobi_filled dobi_filled  ///
    lpubdebtgdp dpubdebtgdp linfl dinfl lus3mrate dus3mrate ///
    loecdgrowth doecdgrowth lvix dvix  if country != "United States", ///
    cluster(ccode1) i(ccode1) fe vsquish noomit

//////// Examine Spread volatility /////////////////////////////////////////////
// FRT --- Basic
xtreg dratecov lltratecov lfrt dfrt lpubdebtgdp ///
    dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth doecdgrowth lvix ///
    dvix, cluster(ccode1) i(ccode1) fe vsquish noomit

    regsave using "tables/FRT3.dta", detail(all) replace table(Volatility_basic, ///
        order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// FRT with structural budget balance, country growth, and Eurozone
xtreg dratecov lltratecov lfrt dfrt lpubdebtgdp ///
    dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth doecdgrowth lvix ///
    dvix lstrucbalgdp dstrucbalgdp lcountry_growth dcountry_growth eurozone, ///
    cluster(ccode1) i(ccode1) fe vsquish noomit

    regsave using "tables/FRT5.dta", detail(all) replace ///
        table(Volatility_morevars, order(regvars r2) format(%5.2f) ///
        paren(stderr) asterisk())
        
// FRT on a log scale
/// without domestic growth and eurozone
xtreg dratecov lltratecov lfrt_log dfrt_log lpubdebtgdp ///
    dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth doecdgrowth lvix ///
    dvix, cluster(ccode1) i(ccode1) fe vsquish noomit

    regsave using "tables/log_FRT1.dta", detail(all) replace ///
        table(Volatility_log, order(regvars r2) format(%5.2f) ///
        paren(stderr) asterisk())

// HRV
xtreg dratecov lltratecov lhrv_mean dhrv_mean ///
    lpubdebtgdp dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth ///
    doecdgrowth lvix dvix, ///
    cluster(ccode1) i(ccode1) fe vsquish noomit

    regsave using "tables/HRV3.dta", detail(all) replace table(Volatility, ///
        order(regvars r2) format(%5.2f) paren(stderr) asterisk())

// OBI
xtreg dratecov lltratecov lobi_filled dobi_filled lstrucbalgdp dstrucbalgdp ///
    lpubdebtgdp dpubdebtgdp linfl dinfl lus3mrate dus3mrate loecdgrowth ///
    doecdgrowth lvix dvix, cluster(ccode1) i(ccode1) fe vsquish noomit
