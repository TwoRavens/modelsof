*Replication For: Was Mattarella Worth the Trouble? Explaining the Failure of the 2016 Italian Constitutional Referendum
*Fedra Negri and Elisa Rebessi, University of Milano
*Paper accepted for publication in the IPSR on December 04, 2017.

*Table 1
use "Was Mattarella Worth the Trouble_Dataset_Nested_Structure.dta", clear
nlogit choice wev_constYES wev_constNO rev_economyYES rev_economyNO revgovRenzi_YES revgovRenzi_NO rPTVPDYES rPTVPDNO rPTVFIYES rPTVFINO rPTVM5SYES rPTVM5SNO rPTVLNYES rPTVLNNO || type: pol_inv female age educ empl1 empl2 empl4 empl5 empl6 empl7 empl8 empl9, base (participate)|| voting:, noconstant case(IDbis)

*Table A3
use "Was Mattarella Worth the Trouble_Dataset_Conditioning_Effects.dta", clear

*M0
logit YESvoting wev_const ev_economy3 ev_Renzi2 rD35_01_W9bis rD35_02_W9bis rD35_04_W9bis rD35_05_W9bis female age educ ib(freq).employment pol_inv, vce(robust)

*M1
logit YESvoting c.wev_const##c.ev_economy3 ev_Renzi2 rD35_01_W9bis rD35_02_W9bis rD35_04_W9bis rD35_05_W9bis female age educ ib(freq).employment pol_inv, vce(robust)

*M2
logit YESvoting wev_const ev_economy3 c.wev_const##c.ev_Renzi2 rD35_01_W9bis rD35_02_W9bis rD35_04_W9bis rD35_05_W9bis female age educ ib(freq).employment pol_inv, vce(robust)

*Table A3bis
*M3
logit YESvoting wev_const ev_economy3 ev_Renzi2 c.wev_const##c.rD35_01_W9bis rD35_02_W9bis rD35_04_W9bis rD35_05_W9bis female age educ ib(freq).employment pol_inv, vce(robust) 

*M4
logit YESvoting wev_const ev_economy3 ev_Renzi2 rD35_01_W9bis c.wev_const##c.rD35_02_W9bis rD35_04_W9bis rD35_05_W9bis female age educ ib(freq).employment pol_inv, vce(robust) 

*M5
logit YESvoting wev_const ev_economy3 ev_Renzi2 rD35_01_W9bis rD35_02_W9bis c.wev_const##c.rD35_04_W9bis rD35_05_W9bis female age educ ib(freq).employment pol_inv, vce(robust) 

*M6
logit YESvoting wev_const ev_economy3 ev_Renzi2 rD35_01_W9bis rD35_02_W9bis rD35_04_W9bis c.wev_const##c.rD35_05_W9bis female age educ ib(freq).employment pol_inv, vce(robust) 


*Figure 2 (Forza Italia)
*Derived from M4, Table A3bis
logit YESvoting wev_const ev_economy3 ev_Renzi2 rD35_01_W9bis c.wev_const##c.rD35_02_W9bis rD35_04_W9bis rD35_05_W9bis female age educ ib(freq).employment pol_inv, vce(robust) 
margins, dydx(wev_const) at(rD35_02_W9bis=(0(1) 10))
marginsplot, yline(0) level(90) addplot(normal rD35_02_W9bis if e(sample), yaxis(2))

*Figure 2 (Five Star Movement)
*Derived from M5, Table A3bis
logit YESvoting wev_const ev_economy3 ev_Renzi2 rD35_01_W9bis rD35_02_W9bis c.wev_const##c.rD35_04_W9bis rD35_05_W9bis female age educ ib(freq).employment pol_inv, vce(robust) 
margins, dydx(wev_const) at(rD35_04_W9bis=(0(1) 10))
marginsplot, yline(0) level(90) addplot(normal rD35_04_W9bis if e(sample), yaxis(2))

