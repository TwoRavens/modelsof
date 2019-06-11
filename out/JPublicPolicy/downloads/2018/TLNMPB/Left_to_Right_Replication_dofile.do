*****************************************
*****Replication File: Left to Right*****
**************Brett Meyer****************
*****************************************

*Use "Left_to_Right_Fig_1_Data" 

***Figure 1 

graph twoway (scatter meanalmp meanepl, mlabel(ISO3dig) mlabv(pos)) if almpcount==1 & eplcount==1, /// 
	title("Active Labor Market Policy and Employment Protection", width(.75)) ytitle("Active Labor Market Policy", height (5)) /// 
	xtitle("Employment Protection") 
	
*Use "Left_to_Right_Replication_Data"	

***Figures 2 & 3

logit union_conf_dum pol_ideol union_member age_group female income educ i.outsider##c.lmri i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate union_density i.year i.iso_num, vce(cluster country_year)
margins, dydx(outsider) at(lmri=(-3.5(.50)2.5)) vsquish
marginsplot, yline(0) level(90) recast(line) recastci(rarea) title("Outsider vs. Insider Support for Unions", /// 
	width(.75)) ytitle("Probability of Outsider Support w.r.t. Insider", height (5)) xtitle("Labor Market Rigidity Index")

logit party_mani pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.lmri i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)
margins, dydx(outsider) at(lmri=(-3.5(.50)2.5)) vsquish
marginsplot, yline(0) level(90) recast(line) recastci(rarea) title("Outsider vs. Insider Support for Populist Radical Right Parties", /// 
	width(.75)) ytitle("Probability of Outsider Support w.r.t. Insider", height (5)) xtitle("Labor Market Rigidity Index")


***Table 1 (Partial Results; Full results in Appendix Table B.1)

ologit union_conf pol_ideol union_member age_group female income educ i.outsider##c.epl gini loggdp gdp_growth u_rate /// 
	union_density i.year i.iso_num, vce(cluster country_year)
ologit union_conf pol_ideol union_member age_group female income educ i.outsider##c.lmri i.outsider##c.plmp gini /// 
	loggdp gdp_growth u_rate union_density i.year i.iso_num, vce(cluster country_year)
ologit union_conf pol_ideol union_member age_group female income educ i.outsider##c.epl i.outsider##c.almp i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate union_density i.year i.iso_num, vce(cluster country_year)

logit party_mani pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.epl gini loggdp gdp_growth /// 
	u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)
logit party_mani pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.lmri i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)
logit party_mani pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.epl i.outsider##c.almp i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)

logit party_list pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.epl gini loggdp gdp_growth /// 
	u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)
logit party_list pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.lmri i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)
logit party_list pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.epl i.outsider##c.almp i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)


***Appendix

*Table A.1

sum union_conf party_mani party_list pol_ideol union_member age_group female income educ imm_attitude outsider part_unemp unemp part /// 
	outsider_epl outsider_almp outsider_plmp outsider_lmri epl almp plmp lmri gini loggdp gdp_growth u_rate union_density imm_rate enpp

*Table B.2

ologit union_conf pol_ideol union_member age_group female income educ i.part_unemp##c.lmri i.part_unemp##c.plmp /// 
	gini loggdp gdp_growth u_rate union_density i.year i.iso_num, vce(cluster country_year)
logit party_mani pol_ideol union_member age_group female income educ imm_attitude i.part_unemp##c.lmri i.part_unemp##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)
logit party_list pol_ideol union_member age_group female income educ imm_attitude i.part_unemp##c.lmri i.part_unemp##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)

ologit union_conf pol_ideol union_member age_group female income educ i.unemp##c.lmri i.unemp##c.plmp gini loggdp /// 
	gdp_growth u_rate union_density i.year i.iso_num, vce(cluster country_year)
logit party_mani pol_ideol union_member age_group female income educ imm_attitude i.unemp##c.lmri i.unemp##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp anglo cont scan asia south i.year, vce(cluster country_year)
logit party_list pol_ideol union_member age_group female income educ imm_attitude i.unemp##c.lmri i.unemp##c.plmp ///
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)

ologit union_conf pol_ideol union_member age_group female income educ i.part##c.lmri i.part##c.plmp gini loggdp /// 
	gdp_growth u_rate union_density i.year i.iso_num, vce(cluster country_year)
logit party_mani pol_ideol union_member age_group female income educ imm_attitude i.part##c.lmri i.part##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)
logit party_list pol_ideol union_member age_group female income educ imm_attitude i.part##c.lmri i.part##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)


*Table A.3

meologit union_conf pol_ideol union_member age_group female income educ outsider lmri plmp outsider_lmri outsider_plmp gini /// 
	loggdp gdp_growth u_rate union_density || country_year:
reg union_conf pol_ideol union_member age_group female income educ i.outsider##c.lmri i.outsider##c.plmp gini loggdp /// 
	gdp_growth u_rate union_density i.year i.iso_num, vce(cluster country_year)
reg union_conf pol_ideol union_member age_group female income educ i.outsider##c.epl i.outsider##c.almp i.outsider##c.plmp gini /// 
	loggdp gdp_growth u_rate union_density i.year i.iso_num, vce(cluster country_year)

logit party_mani pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.lmri i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp i.year, vce(cluster country_year)
reg party_mani pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.lmri i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)
reg party_mani pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.epl i.outsider##c.almp i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)

logit party_list pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.lmri i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp i.year, vce(cluster country_year)
reg party_list pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.lmri i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)
reg party_list pol_ideol union_member age_group female income educ imm_attitude i.outsider##c.epl i.outsider##c.almp i.outsider##c.plmp /// 
	gini loggdp gdp_growth u_rate imm_rate enpp eeur anglo cont scan asia south i.year, vce(cluster country_year)


