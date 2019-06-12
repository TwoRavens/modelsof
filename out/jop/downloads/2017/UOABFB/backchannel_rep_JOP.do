************* Replication file for JOP, Backchannel Representation, M. Ritchie, 4.17.17 *************

*************************************************
*Data, Labor Dept. 2005-2012 
*************************************************

use "backchannel_rep_dataverse.dta", replace

************************************************* 
*Main Text Analysis
************************************************* 

**************************** 
*Table 3 // SUR Regressions
****************************

* Columns (1) & (3) Baseline models
sureg (policy_contact = bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    percent_dem_share republican   blue_collar_percent mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population) (bill_intros = policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    percent_dem_share republican   blue_collar_percent mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population), corr

* Columns (2) & (4) Full models
sureg (policy_contact = bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population) (bill_intros = policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population), corr

*** Figures 2-5 ***

* Figure 2.
quietly margins, predict(equation(policy_contact)) dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  blue_collar_percent=(16 (1) 32)  percent_dem_share=(49.34271) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Effects on Predicted Number of Policy Contacts)

* Figure 3.
quietly margins, predict(equation(policy_contact)) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)   blue_collar_percent=(16 (1) 32) republican=(0 1) percent_dem_share=(49.34271) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Predicted Number of Policy Contacts)

* Figure 4.
quietly margins, predict(equation(policy_contact)) dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)   labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Policy Contacts)

* Figure 5.
quietly margins, predict(equation(policy_contact)) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) republican=(0 1) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Policy Contacts)



************************************************* 
*Online Appendix
************************************************* 

*** Figures A1-A4, Bill Introductions ***
quietly sureg (policy_contact = bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population) (bill_intros = policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population), corr

* Figure A1.
quietly margins, predict(equation(bill_intros)) dydx(republican) at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  blue_collar_percent=(16 (1) 32)  percent_dem_share=(49.34271) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Effects on Predicted Number of Bill Introductions)

* Figure A2.
quietly margins, predict(equation(bill_intros)) at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)   blue_collar_percent=(16 (1) 32) republican=(0 1) percent_dem_share=(49.34271) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) 
marginsplot, recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Predicted Number of Bill Introductions)

* Figure A3.
quietly margins, predict(equation(bill_intros)) dydx(republican) at (policy_contact=(8.377129) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)   labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Bill Introductions)

* Figure A4.
quietly margins, predict(equation(bill_intros)) at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) republican=(0 1) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Bill Introductions)


**************************************************** 
*Table A4. // Negative Binomial, Cluster on Senator
**************************************************** 

* Column (1) Baseline Model
nbreg policy_contact bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    percent_dem_share   blue_collar_percent republican population mine_ave  percent_union_members elect_marginal reelection2  percent_manuf partial_termer , cl(icpsr)

* Column (2) Full Model
nbreg policy_contact bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican population mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer , cl(icpsr)

* Column (3) Baseline Model
nbreg  bill_intros policy_contact ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    percent_dem_share   blue_collar_percent republican mine_ave  percent_union_members elect_marginal reelection2  percent_manuf partial_termer population, cl(icpsr)

* Column (4) Full Model
nbreg bill_intros policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population, cl(icpsr)


*** Figures A5-A8 Policy Contacts ***
quietly nbreg policy_contact bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican population mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer , cl(icpsr)

* Figure A5.
quietly margins, dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  blue_collar_percent=(16 (1) 32)  percent_dem_share=(49.34271) population=(6129293) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Effects on Predicted Number of Policy Contacts)

* Figure A6.
quietly margins, at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1)  labor_comm=(0)  seniority=(11.618)   blue_collar_percent=(16 (1) 32) republican=(0 1) percent_dem_share=(49.34271) population=(6129293) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish 
marginsplot, recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Predicted Number of Policy Contacts)

* Figure A7.
quietly margins, dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)  labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) population=(6129293) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Policy Contacts)

* Figure A8.
quietly margins, at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) republican=(0 1) population=(6129293) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Policy Contacts)


**** Figures A9-A12 Bill Introductions ****
quietly nbreg bill_intros policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population, cl(icpsr)

* Figure A9.
quietly margins, dydx(republican) at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  blue_collar_percent=(16 (1) 32)  percent_dem_share=(49.34271) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Effects on Predicted Number of Bill Introductions)

* Figure A10.
quietly margins, at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)   blue_collar_percent=(16 (1) 32) republican=(0 1) percent_dem_share=(49.34271) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Predicted Number of Bill Introductions)

* Figure A11.
quietly margins, dydx(republican) at (policy_contact=(8.377129) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)   labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Bill Introductions)

* Figure A12.
quietly margins, at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) republican=(0 1) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Bill Introductions)


**************************************************** 
*Table A5. // Negative Binomial, Cluster on State
**************************************************** 

* Column (1) Baseline Model.
nbreg policy_contact bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    percent_dem_share   blue_collar_percent republican mine_ave  percent_union_members elect_marginal reelection2  percent_manuf partial_termer population, cl(state)

* Column (2) Full Model.
nbreg policy_contact bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population, cl(state)

* Column (3) Baseline Model.
nbreg  bill_intros policy_contact ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    percent_dem_share   blue_collar_percent republican mine_ave  percent_union_members elect_marginal reelection2  percent_manuf partial_termer population, cl(state)

* Column (4) Full Model.
nbreg bill_intros policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population, cl(state)


*** Figures A13-A16 Policy Contacts ***
quietly nbreg policy_contact bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population, cl(state)

* Figure A13.
quietly margins, dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  blue_collar_percent=(16 (1) 32)  percent_dem_share=(49.34271) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Effects on Predicted Number of Policy Contacts)

* Figure A14.
quietly margins, at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)   blue_collar_percent=(16 (1) 32) republican=(0 1) percent_dem_share=(49.34271) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Predicted Number of Policy Contacts)

* Figure A15.
quietly margins, dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)   labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Policy Contacts)

* Figure A16.
quietly margins, at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) republican=(0 1) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Policy Contacts)


*** Figures A17-A20 Bill Introductions ***
quietly nbreg bill_intros policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population, cl(state)

* Figure A17.
quietly margins, dydx(republican) at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  blue_collar_percent=(16 (1) 32)  percent_dem_share=(49.34271) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Effects on Predicted Number of Bill Introductions)

* Figure A18.
quietly margins, at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)   blue_collar_percent=(16 (1) 32) republican=(0 1) percent_dem_share=(49.34271) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Predicted Number of Bill Introductions)

* Figure A19.
quietly margins, dydx(republican) at (policy_contact=(8.377129) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)   labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Bill Introductions)

* Figure A20.
quietly margins, at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) republican=(0 1) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Bill Introductions)


**************************************************** 
*Table A6. // SUR Regression, White Blue-Collar Pop
****************************************************

* Columns (1) and (3) Baseline Models
sureg (policy_contact = bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    percent_dem_share republican   percent_white_blue mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population) (bill_intros = policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    percent_dem_share republican   percent_white_blue mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population), corr

* Columns (2) and (4) Full Model
sureg (policy_contact = bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.percent_white_blue##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population) (bill_intros = policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   c.percent_white_blue##i.republican mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population), corr


*** Figures A21-A24 Policy Contact ***

* Figure A21.
quietly margins, predict(equation(policy_contact)) dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  percent_white_blue=(2 (2) 14)  percent_dem_share=(49.34271) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(2 (2) 14) ytitle(Effects on Predicted Number of Policy Contacts)

* Figure A22. 
quietly margins, predict(equation(policy_contact)) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)   percent_white_blue=(2 (2) 14) republican=(0 1) percent_dem_share=(49.34271) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(2 (2) 14) ytitle(Predicted Number of Policy Contacts)

* Figure A23.
quietly margins, predict(equation(policy_contact)) dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)   labor_comm=(0) seniority=(11.618)  percent_white_blue=(8.544052) percent_dem_share=(25 (4) 73) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Policy Contacts)

* Figure A24.
quietly margins, predict(equation(policy_contact)) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  percent_white_blue=(8.544052) percent_dem_share=(25 (4) 73) republican=(0 1) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Policy Contacts)


***Figures A25-A28 Bill Introductions ***

* Figure A25.
quietly margins, predict(equation(bill_intros)) dydx(republican) at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  percent_white_blue=(2 (2) 14)  percent_dem_share=(49.34271) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(White Blue Collar Population) xlabel(2 (2) 14) ytitle(Effects on Predicted Number of Bill Introductions)

* Figure A26.
quietly margins, predict(equation(bill_intros)) at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)   percent_white_blue=(2 (2) 14) republican=(0 1) percent_dem_share=(49.34271) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) 
marginsplot, recast(line) recastci(rarea) xtitle(White Blue Collar Population) xlabel(2 (2) 14) ytitle(Predicted Number of Bill Introductions)

* Figure A27.
quietly margins, predict(equation(bill_intros)) dydx(republican) at (policy_contact=(8.377129) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)   labor_comm=(0) seniority=(11.618)  percent_white_blue=(8.544052) percent_dem_share=(25 (4) 73) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Bill Introductions)

* Figure A28.
quietly margins, predict(equation(bill_intros)) at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  percent_white_blue=(8.544052) percent_dem_share=(25 (4) 73) republican=(0 1) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Bill Introductions)


****************************************************** 
*Table A7. // SUR Regression, Omitting Blue-Collar Pop
******************************************************

* Columns (1) and (3) Baseline models 
sureg (policy_contact = bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    percent_dem_share republican  mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population) (bill_intros = policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    percent_dem_share republican  mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population), corr

* Columns (2) and (4) Full models 
sureg (policy_contact = bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican  mine_ave percent_union_members elect_marginal reelection2 percent_manuf partial_termer population) (bill_intros = policy_contact  ideological_extremity  leader laborcommleaders unified repub_control_senate labor_comm  seniority    c.percent_dem_share##i.republican   mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer population), corr


*** Figures A29-A30 Policy Contact ***

* Figure A29.
quietly margins, predict(equation(policy_contact)) dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)   labor_comm=(0) seniority=(11.618) percent_dem_share=(25 (4) 73) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Policy Contacts)

* Figures A30.
quietly margins, predict(equation(policy_contact)) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  percent_dem_share=(25 (4) 73) republican=(0 1) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Policy Contacts)


*** Figures A31-A32 Bill Intros *** 

* Figure A31.
quietly margins, predict(equation(bill_intros)) dydx(republican) at (policy_contact=(8.377129) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)   labor_comm=(0) seniority=(11.618) percent_dem_share=(25 (4) 73) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on Predicted Number of Bill Introductions)

* Figure A32.
quietly margins, predict(equation(bill_intros)) at (policy_contact=(8.377129) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  percent_dem_share=(25 (4) 73) republican=(0 1) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0) population=(6129293)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted Number of Bill Introductions)



****************************************************** 
*Table A8. // Sparse Model
******************************************************

nbreg policy_contact ideological_extremity, cl(icpsr)
nbreg policy_contact c.blue_collar_percent##i.republican, cl(icpsr)
nbreg policy_contact c.percent_white_blue##i.republican, cl(icpsr)
nbreg policy_contact c.percent_dem_share##i.republican, cl(icpsr)


****************************************************** 
*Table A9. // Sparse Model
******************************************************

nbreg policy_contact ideological_extremity labor_comm  seniority mine_ave, cl(icpsr)
nbreg policy_contact c.blue_collar_percent##i.republican labor_comm  seniority mine_ave, cl(icpsr)
nbreg policy_contact c.percent_white_blue##i.republican labor_comm  seniority mine_ave, cl(icpsr)
nbreg policy_contact c.percent_dem_share##i.republican labor_comm seniority mine_ave, cl(icpsr)


****************************************************** 
*Figures A33-A36. // Scatter Plots
******************************************************

* Ideological Extremity.
twoway (scatter policy_contact ideological_extremity) (lfit policy_contact ideological_extremity), ytitle(Number of Policy Contacts)

* Blue-Collar.
separate policy_contact, by(republican)
twoway (scatter policy_contact0 blue_collar_percent) (scatter policy_contact1 blue_collar_percent) (lfit policy_contact0 blue_collar_percent) (lfit policy_contact1 blue_collar_percent), legend(order(1 "Democrat" 2 "Republican" 3 "Lfit Democrat" 4 "Lfit Republican")) ytitle(Number of Policy Contacts)

* White Blue-Collar.
twoway (scatter policy_contact0 percent_white_blue) (scatter policy_contact1 percent_white_blue) (lfit policy_contact0 percent_white_blue) (lfit policy_contact1 percent_white_blue), legend(order(1 "Democrat" 2 "Republican" 3 "Lfit Democrat" 4 "Lfit Republican")) ytitle(Number of Policy Contacts)

* Democratic Vote Share.
twoway (scatter policy_contact0 percent_dem_share) (scatter policy_contact1 percent_dem_share) (lfit policy_contact0 percent_dem_share) (lfit policy_contact1 percent_dem_share), legend(order(1 "Democrat" 2 "Republican" 3 "Lfit Democrat" 4 "Lfit Republican")) ytitle(Number of Policy Contacts)


******************************************************** 
*Table A10. // AFL-CIO Scores & AFL-CIO Score Extremity
********************************************************

gen aflcio_50 = aflcio_percent - 50
gen aflcio_extremity =abs(aflcio_50)

* Column (1) Baseline Model.
reg aflcio_percent bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    percent_dem_share   blue_collar_percent republican population mine_ave  percent_union_members elect_marginal reelection2  percent_manuf partial_termer , cl(icpsr)

* Column (2) Full Model.
reg aflcio_percent bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican population mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer , cl(icpsr)

* Column (3) Baseline Model.
reg aflcio_extremity bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    percent_dem_share   blue_collar_percent republican population mine_ave  percent_union_members elect_marginal reelection2  percent_manuf partial_termer , cl(icpsr)

* Column (4) Full Model.
reg aflcio_extremity bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican population mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer , cl(icpsr)

*** Interaction Figures, AFL-CIO Score ***
quietly reg aflcio_percent bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican population mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer , cl(icpsr)

* Figure A37.
quietly margins, dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  blue_collar_percent=(16 (1) 32)  percent_dem_share=(49.34271) population=(6129293) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Effects on AFL-CIO Score)

* Figure A38.
quietly margins, at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1)  labor_comm=(0)  seniority=(11.618)   blue_collar_percent=(16 (1) 32) republican=(0 1) percent_dem_share=(49.34271) population=(6129293) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish 
marginsplot, recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Predicted AFL-CIO Score)

* Figure A39.
quietly margins, dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)  labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) population=(6129293) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on AFL-CIO Score)

* Figure A40.
quietly margins, at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) republican=(0 1) population=(6129293) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Predicted AFL-CIO Score)


*** Interaction Figures, AFL-CIO Score Extremity *** 

quietly reg aflcio_extremity bill_intros  ideological_extremity  leader laborcommleaders unified repub_control_senate  labor_comm  seniority    c.percent_dem_share##i.republican   c.blue_collar_percent##i.republican population mine_ave  percent_union_members elect_marginal reelection2 percent_manuf partial_termer , cl(icpsr)

* Figure A41.
quietly margins, dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0)  seniority=(11.618)  blue_collar_percent=(16 (1) 32)  percent_dem_share=(49.34271) population=(6129293) mine_ave=(514.6929)  percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) ytitle(Effects on AFL-CIO Extremity)

* Figure A42.
quietly margins, at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0) unified=(1) repub_control_senate=(1)  labor_comm=(0)  seniority=(11.618)   blue_collar_percent=(16 (1) 32) republican=(0 1) percent_dem_share=(49.34271) population=(6129293) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish 
marginsplot, recast(line) recastci(rarea) xtitle(Blue Collar Population) xlabel(16 (1) 32) yscale(range(20(5)50)) ylabel(20(5)50) ytitle(Predicted AFL-CIO Extremity)

* Figure A43.
quietly margins, dydx(republican) at (bill_intros=(1.569343) ideological_extremity=(.3977299)  leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1)  labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) population=(6129293) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, yline(0) recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73) ytitle(Effects on AFL-CIO Extremity)

* Figure A44.
quietly margins, at (bill_intros=(1.569343) ideological_extremity=(.3977299)   leader=(0) laborcommleaders=(0)  unified=(1) repub_control_senate=(1) labor_comm=(0) seniority=(11.618)  blue_collar_percent=(22.98151) percent_dem_share=(25 (4) 73) republican=(0 1) population=(6129293) mine_ave=(514.6929) percent_union_members=(6.70292) elect_marginal=(0) reelection2=(0) percent_manuf=(11.11479) partial_termer=(0)) vsquish
marginsplot, recast(line) recastci(rarea) xtitle(Democratic Presidential Vote Share) xlabel(25 (4) 73)  yscale(range(10(10)50)) ylabel(10(10)50) ytitle(Predicted AFL-CIO Extremity)


*******************************************
*Table A11. // Test of alternative account
*******************************************

* Ideological Extremity.
nbreg policy_contact c.ideological_extremity##i.repub_control_senate if republican==1, cl(icpsr)

* Blue-Collar.
nbreg policy_contact c.blue_collar_percent##i.repub_control_senate if republican==1, cl(icpsr)

* White Blue-Collar.
nbreg policy_contact c.percent_white_blue##i.repub_control_senate if republican==1, cl(icpsr)

* Democratic Vote Share.
nbreg policy_contact c.percent_dem_share##i.repub_control_senate if republican==1, cl(icpsr)

