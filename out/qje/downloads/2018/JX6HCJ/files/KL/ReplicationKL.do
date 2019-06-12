
*Using merged file provided by DK because original public use data files did not contain perbush variable used in regressions 
use "AER merged.dta", clear

*TABLE 3 - All okay
dprobit amount treatment
probit amount treatment

dprobit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3

dprobit amount treatment if dormant==1
probit amount treatment if dormant==1

dprobit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1

dprobit amount treatment if dormant==0
probit amount treatment if dormant==0

dprobit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0
probit amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0


*TABLE 4 - Errors on coefficients (one regression, some of the variables) & s.e., some rounding errors, 
*This true in original public use data file as well, which is identical on these variables

reg amount treatment
reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
reg amount treatment if dormant==1
reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1
reg amount treatment if dormant==0
reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0
reg amountchange treatment
reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3
reg amount treatment if gave==1
reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1
reg amount treatment if dormant==1 & gave==1
reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==1 & gave==1
reg amount treatment if dormant==0 & gave==1
reg amount treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if dormant==0 & gave==1
reg amountchange treatment if gave==1
reg amountchange treatment ratio2 ratio3 size25 size50 size100 askd2 askd3 if gave==1

*Table 5 - All okay
*Top panel - table suggests is probit, actually is reg.

*Slight modification of their code to allow me to extract information
matrix X = (0, 0.4, 0.45, 0.475, 0.5, 0.525, 0.55, 0.6, 1)
forvalues i = 1/8 {
	reg gave treatment if perbush >=X[1,`i'] & perbush<X[1,`i'+1]
	}

dprobit gave treatment if redcty==1 & red0==1
probit gave treatment if redcty==1 & red0==1

dprobit gave treatment if bluecty==1 & red0==1
probit gave treatment if bluecty==1 & red0==1

dprobit gave treatment if redcty==1 & blue0==1
probit gave treatment if redcty==1 & blue0==1

dprobit gave treatment if bluecty==1 & blue0==1
probit gave treatment if bluecty==1 & blue0==1

gen T_nonlit = treatment*nonlit
gen T_cases = treatment*cases
gen T_red0 = treatment*red0

dprobit gave treatment T_red0 T_nonlit red0 nonlit 
probit gave treatment T_red0 T_nonlit red0 nonlit 

dprobit gave treatment T_red0 T_cases red0 cases 
probit gave treatment T_red0 T_cases red0 cases 

dprobit gave treatment T_red0 T_nonlit T_cases red0 nonlit cases 
probit gave treatment T_red0 T_nonlit T_cases red0 nonlit cases 


gen t_year5 = treatment * year5
gen t_hpa = treatment * hpa 
gen t_pwhite=treatment*pwhite
gen t_pblack=treatment*pblack
gen t_page18_39=treatment*page18_39
gen t_ave_hh_sz = treatment*ave_hh_sz
gen t_psch_atlstba = treatment*psch_atlstba
gen t_powner = treatment*powner
gen t_red0=treatment*red0
gen t_poppropurban = treatment*pop_propurban

rename median_hhincome medinc
gen medinc_adj = medinc/100000
gen t_medinc_adj = treatment*medinc_adj 

*TABLE 6 - Most columns have somewhat different coefficients and sample size 
*This true for original census data file as well (different than merged data file on these variables, producing different regressions)
*Work with merged data file since either way can't exactly match original regressions

dprobit gave treatment t_red0 t_year5 t_hpa red0 year5 hpa 
probit gave treatment t_red0 t_year5 t_hpa red0 year5 hpa 

dprobit gave treatment t_red0 t_pwhite red0 pwhite 
probit gave treatment t_red0 t_pwhite red0 pwhite 

dprobit gave treatment t_red0 t_pblack red0 pblack 
probit gave treatment t_red0 t_pblack red0 pblack 

dprobit gave treatment t_red0 t_page18_39 red0 page18_39 
probit gave treatment t_red0 t_page18_39 red0 page18_39 

dprobit gave treatment t_red0 t_ave_hh_sz red0 ave_hh_sz 
probit gave treatment t_red0 t_ave_hh_sz red0 ave_hh_sz 

dprobit gave treatment t_red0 t_medinc_adj red0 medinc_adj 
probit gave treatment t_red0 t_medinc_adj red0 medinc_adj 

dprobit gave treatment t_red0 t_powner red0 powner 
probit gave treatment t_red0 t_powner red0 powner 

dprobit gave treatment t_red0 t_psch_atlstba red0 psch_atlstba 
probit gave treatment t_red0 t_psch_atlstba red0 psch_atlstba 

dprobit gave treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban red0 pwhite pblack page18_39 ave_hh_sz medinc_adj powner psch_atlstba pop_propurban 
probit gave treatment t_red0 t_pwhite t_pblack t_page18_39 t_ave_hh_sz t_medinc_adj t_powner t_psch_atlstba t_poppropurban red0 pwhite pblack page18_39 ave_hh_sz medinc_adj powner psch_atlstba pop_propurban 

save DatKL, replace


