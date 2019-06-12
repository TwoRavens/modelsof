*Open dataset: Flavin_Union_Strength_Political_Equality_state_replication_data_BJPS.dta

*Table 1: Ranking the States by the Equality of Political Representation
order statename political_equality3
gsort -political_equality3

*Table 2: Labor Union Strength and the Equality of Political Representation
reg political_equality3 unionden_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999
predict insample if e(sample)
reg political_equality3 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999
reg political_equality3 unionden_00_06 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999
reg political_equality3 unionden_00_06 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999, beta

*Table 3: Robustness Check Using Alternative Measures of Labor Union Strength
reg political_equality3 union_vote_08 dems_2000_2006 percent_profit median_income_1999 gini1999
reg political_equality3 labor_business_ratio dems_2000_2006 percent_profit median_income_1999 gini1999
reg political_equality3 union_vote_08 labor_business_ratio dems_2000_2006 percent_profit median_income_1999 gini1999
reg political_equality3 union_vote_08 labor_business_ratio dems_2000_2006 percent_profit median_income_1999 gini1999, beta

*Table A-4: Descriptive Statistics for Variables in Regression Models in Tables 2 and 3
sum political_equality3 unionden_00_06 union_vote_08 labor_percent_00_06 labor_business_ratio dems_2000_2006 percent_profit median_income_1999 gini1999 if insample~=.

*Table A-5: Labor Union Lobbying and the Equality of Political Representation
reg political_equality3 labor_lobbying_percent
reg political_equality3 labor_lobbying_percent dems_2000_2006 percent_profit median_income_1999 gini1999

*Table A-6: Robustness Check with % Racial Minority Variable Added to Model
reg political_equality3 unionden_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999 nonwhite
reg political_equality3 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999 nonwhite
reg political_equality3 unionden_00_06 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999 nonwhite

*Table A-7: Running Feasible Generalized Least Squares Regression on the Six Separate Sets of State Income/Proximity Regression Coefficients
xtgls _b_stg unionden_00_06 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999 [aweight=1/(_se_stg)]
xtgls _b_stsmr unionden_00_06 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999 [aweight=1/(_se_stsmr)]
xtgls _b_ssg unionden_00_06 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999 [aweight=1/(_se_ssg)]
xtgls _b_sssmr unionden_00_06 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999 [aweight=1/(_se_sssmr)]
xtgls _b_rsg unionden_00_06 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999 [aweight=1/(_se_rsg)]
xtgls _b_rssmr unionden_00_06 labor_percent_00_06 dems_2000_2006 percent_profit median_income_1999 gini1999 [aweight=1/(_se_rssmr)]

*Table A-8: Equality of Political Representation Does Not Predict State Union Membership
reg unionden_00_06 political_equality3 cb percent_construction percent_manufacturing
