********************************************************************************
// This file: Define routines for the project
********************************************************************************

set linesize 255 // for version control purposes

// control regression weighting
cap program drop regs_weighted
program regs_weighted
    global regWeight "[aw=L.pop]"
end

cap program drop regs_unweighted
program regs_unweighted
    global regWeight ""
end

// define data use shortcuts
cap program drop use_data_nation_year
program use_data_nation_year
    // use nation-year dataset
    use "cleaned_data/nation_year_cleaned.dta", clear
    xtset fips year
end

cap program drop use_data_state_year
program use_data_state_year
    // use state-year dataset
    use "cleaned_data/state_year_cleaned.dta", clear
    xtset fips year
end

cap program drop use_data_cnty_year
program use_data_cnty_year
    // use county-year dataset
    use "cleaned_data/county_year_cleaned.dta", clear
    xtset fips year
end

cap program drop use_ipums
program use_ipums
    use "raw_data/ipums.dta", clear
end

********************************************************************************

// globals of control variables
global controls "msa1990 log_pop D.log_pop manufact_earn_share_1969"

// globals of instrumental variables
#delimit ;

global coal_price_res "L(0/2).d_coalprice_by_coalres";
global og_oilprice_cont_74 "L(0/2).d_oilprice_by_emp1974";
global og_oilprice_cont_67 "L(0/2).d_oilprice_by_emp1967";
global og_emp_cont_74 "L(0/2).d_ogemp_by_emp1974";
global og_emp_cont_67 "L(0/2).d_ogemp_by_emp1967";

global coal_price_res_nolags "d_coalprice_by_coalres";
global og_oilprice_cont_74_nolags "d_oilprice_by_emp1974";
global og_oilprice_cont_67_nolags "d_oilprice_by_emp1967";
global og_emp_cont_74_nolags "d_ogemp_by_emp1974";
global og_emp_cont_67_nolags "d_ogemp_by_emp1967";

#delimit cr

// globals for constraints and options
global ssdi_bal "bal_obs_ssdi==1"
global ssdi_unbal "bal_obs_ssdi<."
global ssi_bal "bal_obs_ssi==1"
global ssi_unbal "bal_obs_ssi<."
