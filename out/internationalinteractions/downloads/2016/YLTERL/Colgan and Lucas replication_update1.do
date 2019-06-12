use "Colgan and Lucas replication - monadic.dta", clear
sort ccode year
xtset ccode year

** Figure 1: cross-tabs
tab sanction1 revolutionary
tab extensivemerge revolutionary

**Table 1
*Model 1.1 
xtlogit sanction1 revolutionary revperiod3 poplog coldwar polity2 interreg transition dem majorpower GDP_PC reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 1.2
xtlogit sanction1 revolutionary revperiod3 GDP_PC poplog coldwar polity2 interreg transition dem, fe

**Table 2
*Model 2.1
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.2
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 d_i_sschool i_gross_fixed  reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.3
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564, fe
*Model 2.4
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564 d_i_sschool i_gross_fixed, fe

***Robustness checks for monadic analysis found in appendix
**Table 5
*Model 1.3
xtlogit sanction1 revolutionary revperiod5 poplog coldwar polity2 interreg transition dem majorpower GDP_PC reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 1.4
xtlogit sanction1 revolutionary revperiod3 poplog coldwar polity2 interreg transition dem majorpower GDP_PC civilwar reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 1.5 - Model usess arab2 variable, which does not include Somalia and Djibouti as Arab states
xtlogit sanction1 revolutionary revperiod3 poplog coldwar polity2 interreg transition dem majorpower GDP_PC muslim arab2 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
/* *Alternative Model 1.5 - uses arab1, which codes Somalia and Djibouti as Arab states
xtlogit sanction1 revolutionary revperiod3 poplog coldwar polity2 interreg transition dem majorpower GDP_PC muslim arab1 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re */
*Model 1.6
xtlogit sanction1 revolutionary revperiod5 poplog coldwar polity2 interreg transition dem GDP_PC, fe
*Model 1.7
xtlogit sanction1 revolutionary revperiod3 poplog coldwar polity2 interreg transition dem GDP_PC civilwar, fe

**Table 6
*Model 1.8
xtlogit F.sanction1 revolutionary revperiod3 poplog coldwar polity2 interreg transition dem majorpower GDP_PC reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 1.9
xtlogit F.sanction1 revolutionary revperiod3 GDP_PC poplog coldwar polity2 interreg transition dem, fe
*Model 1.10 (using the more restrictive "sanction" variable)
xtlogit sanction revolutionary revperiod3 poplog coldwar polity2 interreg transition dem majorpower GDP_PC reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 1.11 (using the more restrictive "sanction" variable)
xtlogit sanction revolutionary revperiod3 GDP_PC poplog coldwar polity2 interreg transition dem, fe

**Table 7
*Model 2.5 (with 5 year period)
xtreg GDP_PC revolutionary revperiod5 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.6
xtreg GDP_PC revolutionary revperiod5 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 d_i_sschool i_gross_fixed  reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.7
xtreg GDP_PC revolutionary revperiod5 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564, fe
*Model 2.8
xtreg GDP_PC revolutionary revperiod5 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564 d_i_sschool i_gross_fixed, fe

**Table 8
*Model 2.9 
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 muslim arab2 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
/* * Alternative Model 2.9 - uses arab1, which codes Somalia and Djbouti as Arab states
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 muslim arab1 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re */
*Model 2.10
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 d_i_sschool i_gross_fixed muslim arab2 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.11 
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 i.year reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.12
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 d_i_sschool i_gross_fixed i.year reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.13
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564 i.year, fe
*Model 2.14
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564 d_i_sschool i_gross_fixed i.year, fe

**Table 9
*Model 2.15
xtreg GDP_PC L.GDP_PC L2.GDP_PC L3.GDP_PC L4.GDP_PC L5.GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.16
xtreg GDP_PC L.GDP_PC L2.GDP_PC L3.GDP_PC L4.GDP_PC L5.GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 d_i_sschool i_gross_fixed  reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.17
xtreg GDP_PC L.GDP_PC L2.GDP_PC L3.GDP_PC L4.GDP_PC L5.GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564, fe
*Model 2.18
xtreg GDP_PC L.GDP_PC L2.GDP_PC L3.GDP_PC L4.GDP_PC L5.GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564 d_i_sschool i_gross_fixed, fe

**Table 10
*Model 2.19 (lag all RHS variables)
xtreg F.GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.20
xtreg F.GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 d_i_sschool i_gross_fixed  reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.21
xtreg F.GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564, fe
*Model 2.22
xtreg F.GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar civilwar postwar oil per1564 d_i_sschool i_gross_fixed, fe

**Table 11
*Model 2.23 (feasible generalized least squares with panel-specific AR1 autocorrelation structure)
xtgls GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 reg1 reg2 reg3 reg4 reg5 reg6 reg7, corr(psar1) force
*Model 2.24
xtgls GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog coldwar majorpower civilwar postwar oil per1564 d_i_sschool i_gross_fixed  reg1 reg2 reg3 reg4 reg5 reg6 reg7, corr(psar1) force  
*Model 2.25 (data from 1962-1999)
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog1 coldwar majorpower civilwar postwar oil per1564 reg1 reg2 reg3 reg4 reg5 reg6 reg7, re
*Model 2.26 (data from 1962-1999)
xtreg GDP_PC revolutionary revperiod3 polity2 interreg transition dem poplog1 coldwar civilwar postwar oil per1564, fe

**Table 16
sum revolutionary
sum revperiod3
sum sanction
sum GDP_PC
sum poplog
sum dem
sum polity2
sum civilwar
sum postwar
sum per1564
sum year

** Figure 3: Event History
use "Colgan and Lucas replication - event history.dta", clear
sort ccode year

*Pre5
sum GDP_PC if eh_code == 1
*Pre4
sum GDP_PC if eh_code == 2
*Pre3
sum GDP_PC if eh_code == 3
*Pre2
sum GDP_PC if eh_code == 4
*Pre1
sum GDP_PC if eh_code == 5
*Rev
sum GDP_PC if eh_code == 6
*Post1 
sum GDP_PC if eh_code == 7
*Post2
sum GDP_PC if eh_code == 8
*Post3
sum GDP_PC if eh_code == 9
*Post4
sum GDP_PC if eh_code == 10
*Post5
sum GDP_PC if eh_code == 11

use "Colgan and Lucas replication - dyadic.dta", clear
sort ccode1 ccode2 year
tsset ddyad2 year

**Table 3 
*Model 3.1 
logit atopally0 rev1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 3.2 
logit atopally0 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 3.3 
logit atopally0 rev1 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)

**Table 4 
*Model 4.1 
logit chg_ally rev1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 4.2
logit chg_ally revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 4.3
logit chg_ally rev1 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)

***Robustness checks for dyadic analysis found in appendix
**Table 12
*Model 3.4
logit atopally0 revperiod5_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 3.5 
logit atopally0 rev1 revperiod5_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 3.6 
logit atopally0 rev1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol7_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 3.7
logit atopally0 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol7_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 3.8
logit atopally0 rev1 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol7_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)

**Table 13
*Model 3.9
logit F.atopally0 rev1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 3.10
logit F.atopally0 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 3.11
logit F.atopally0 rev1 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)

**Table 14
*Model 4.4 
logit chg_ally revperiod5_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 4.5
logit chg_ally rev1 revperiod5_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 4.6
logit chg_ally rev1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol7_using  reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 4.7
logit chg_ally revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol7_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 4.8
logit chg_ally rev1 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol7_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 4.9
logit F.chg_ally rev1 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)

**Table 15 
*Model 4.10
logit stronger_ally rev1 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)
*Model 4.11
logit weaker_ally rev1 revperiod3_1 adj_polity21 interreg1 transition1 arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using reg1_1 reg2_1 reg3_1 reg4_1 reg5_1 reg6_1 reg7_1, cl(dirdyadID)

**Table 17
sum rev1
sum revperiod3_1
sum atopally0
sum chg_ally
sum arep_MBallSW
sum aiis_bl
sum S
sum I
sum jointenemy_dum
sum sqrtdist
sum mpctdum
sum poldif_using
sum pol5_using
sum year
