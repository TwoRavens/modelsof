******* Stata syntax for analyses in the UK, Political Behavior 2018: "Policy Responsiveness and Electoral Incentives: A (Re)assessment" *******
******* See article for data sources *******


*** Open "POBE_UK" Stata file ***

tsset year


******* Replication of analyses in the article and in the online appendix *******

*** Table 2 and Tables S15-S26. Main analyses with Seemingly Unrelated Regression (SUR) models
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.vmargin govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.vmargin govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.vmargin govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.vmargin govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.vmargin govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lpr govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lpr govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lpr govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lpr govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lpr govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.pop govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.pop govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.pop govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.pop govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.pop govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lpop govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lpop govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lpop govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lpop govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lpop govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.gpv govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.gpv govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.gpv govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.gpv govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.gpv govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lgpv govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lgpv govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lgpv govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lgpv govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lgpv govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.fpv govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.fpv govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.fpv govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.fpv govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.fpv govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lfpv govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lfpv govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lfpv govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lfpv govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lfpv govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.fpv_new govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##i.fpv_new govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##i.fpv_new govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##i.fpv_new govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##i.fpv_new govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.lfpv_new govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##i.lfpv_new govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##i.lfpv_new govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##i.lfpv_new govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##i.lfpv_new govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1)


*** Figure 1b (based on Table S23)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.fpv_new govt1) if year>=1980
margins fpv_new, at(l.iprefs_16=(-48(1)20)) at((mean) l.sp_16)
marginsplot, recast(scatter) recastci(rspike)


*** Table S39. Policy Representation in the UK (with LDV)
sureg (d.sp_16 l.sp_16 l.iprefs_16 govt1) (d.sp_06 l.sp_06 l.iprefs_06 govt1) (d.sp_03 l.sp_03 l.iprefs_03 govt1) (d.sp_13 l.sp_13 l.iprefs_13 govt1) (d.sp_10 l.sp_10 l.iprefs_10 govt1)


*** Table S40. Policy Representation in the UK (without LDV)
sureg (d.sp_16 l.iprefs_16 govt1) (d.sp_06 l.iprefs_06 govt1) (d.sp_03 l.iprefs_03 govt1) (d.sp_13 l.iprefs_13 govt1) (d.sp_10 l.iprefs_10 govt1)


*** Table S45. Public Responsiveness in the UK (with LDV)
sureg (iprefs_16 l.iprefs_16 sp_16) (iprefs_06 l.iprefs_06 sp_06) (iprefs_03 l.iprefs_03 sp_03) (iprefs_13 l.iprefs_13 sp_13) (iprefs_10 l.iprefs_10 sp_10)


*** Table S46. Public Responsiveness in the UK (without LDV)
sureg (iprefs_16 sp_16) (iprefs_06 sp_06) (iprefs_03 sp_03) (iprefs_13 sp_13) (iprefs_10 sp_10)


*** Table S50. SUR Models of Electoral Incentives Effects on Policy Representation in the UK: Lagged Dependent Variable Omitted
sureg (d.sp_16 c.l.iprefs_16##c.vmargin govt1) (d.sp_06 c.l.iprefs_06##c.vmargin govt1) (d.sp_03 c.l.iprefs_03##c.vmargin govt1) (d.sp_13 c.l.iprefs_13##c.vmargin govt1) (d.sp_10 c.l.iprefs_10##c.vmargin govt1)
sureg (d.sp_16 c.l.iprefs_16##c.lpr govt1) (d.sp_06 c.l.iprefs_06##c.lpr govt1) (d.sp_03 c.l.iprefs_03##c.lpr govt1) (d.sp_13 c.l.iprefs_13##c.lpr govt1) (d.sp_10 c.l.iprefs_10##c.lpr govt1)
sureg (d.sp_16 c.l.iprefs_16##c.pop govt1) (d.sp_06 c.l.iprefs_06##c.pop govt1) (d.sp_03 c.l.iprefs_03##c.pop govt1) (d.sp_13 c.l.iprefs_13##c.pop govt1) (d.sp_10 c.l.iprefs_10##c.pop govt1)
sureg (d.sp_16 c.l.iprefs_16##c.lpop govt1) (d.sp_06 c.l.iprefs_06##c.lpop govt1) (d.sp_03 c.l.iprefs_03##c.lpop govt1) (d.sp_13 c.l.iprefs_13##c.lpop govt1) (d.sp_10 c.l.iprefs_10##c.lpop govt1)
sureg (d.sp_16 c.l.iprefs_16##c.gpv govt1) (d.sp_06 c.l.iprefs_06##c.gpv govt1) (d.sp_03 c.l.iprefs_03##c.gpv govt1) (d.sp_13 c.l.iprefs_13##c.gpv govt1) (d.sp_10 c.l.iprefs_10##c.gpv govt1)
sureg (d.sp_16 c.l.iprefs_16##c.lgpv govt1) (d.sp_06 c.l.iprefs_06##c.lgpv govt1) (d.sp_03 c.l.iprefs_03##c.lgpv govt1) (d.sp_13 c.l.iprefs_13##c.lgpv govt1) (d.sp_10 c.l.iprefs_10##c.lgpv govt1)
sureg (d.sp_16 c.l.iprefs_16##c.fpv govt1) (d.sp_06 c.l.iprefs_06##c.fpv govt1) (d.sp_03 c.l.iprefs_03##c.fpv govt1) (d.sp_13 c.l.iprefs_13##c.fpv govt1) (d.sp_10 c.l.iprefs_10##c.fpv govt1)
sureg (d.sp_16 c.l.iprefs_16##c.lfpv govt1) (d.sp_06 c.l.iprefs_06##c.lfpv govt1) (d.sp_03 c.l.iprefs_03##c.lfpv govt1) (d.sp_13 c.l.iprefs_13##c.lfpv govt1) (d.sp_10 c.l.iprefs_10##c.lfpv govt1)
sureg (d.sp_16 c.l.iprefs_16##i.fpv_new govt1) (d.sp_06 c.l.iprefs_06##i.fpv_new govt1) (d.sp_03 c.l.iprefs_03##i.fpv_new govt1) (d.sp_13 c.l.iprefs_13##i.fpv_new govt1) (d.sp_10 c.l.iprefs_10##i.fpv_new govt1)
sureg (d.sp_16 c.l.iprefs_16##i.lfpv_new govt1) (d.sp_06 c.l.iprefs_06##i.lfpv_new govt1) (d.sp_03 c.l.iprefs_03##i.lfpv_new govt1) (d.sp_13 c.l.iprefs_13##i.lfpv_new govt1) (d.sp_10 c.l.iprefs_10##i.lfpv_new govt1)
sureg (d.sp_16 c.l.iprefs_16##i.elec1 govt1) (d.sp_06 c.l.iprefs_06##i.elec1 govt1) (d.sp_03 c.l.iprefs_03##i.elec1 govt1) (d.sp_13 c.l.iprefs_13##i.elec1 govt1) (d.sp_10 c.l.iprefs_10##i.elec1 govt1)
sureg (d.sp_16 c.l.iprefs_16##c.elec2 govt1) (d.sp_06 c.l.iprefs_06##c.elec2 govt1) (d.sp_03 c.l.iprefs_03##c.elec2 govt1) (d.sp_13 c.l.iprefs_13##c.elec2 govt1) (d.sp_10 c.l.iprefs_10##c.elec2 govt1)


*** Table S53. Electoral Vulnerability Hypothesis controlling for Election Year variable
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.vmargin govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.vmargin govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.vmargin govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.vmargin govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.vmargin govt1 elec1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lpr govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lpr govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lpr govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lpr govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lpr govt1 elec1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.pop govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.pop govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.pop govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.pop govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.pop govt1 elec1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lpop govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lpop govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lpop govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lpop govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lpop govt1 elec1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.gpv govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.gpv govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.gpv govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.gpv govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.gpv govt1 elec1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lgpv govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lgpv govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lgpv govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lgpv govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lgpv govt1 elec1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.fpv govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.fpv govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.fpv govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.fpv govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.fpv govt1 elec1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lfpv govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lfpv govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lfpv govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lfpv govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lfpv govt1 elec1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.fpv_new govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##i.fpv_new govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##i.fpv_new govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##i.fpv_new govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##i.fpv_new govt1 elec1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.lfpv_new govt1 elec1) (d.sp_06 l.sp_06 c.l.iprefs_06##i.lfpv_new govt1 elec1) (d.sp_03 l.sp_03 c.l.iprefs_03##i.lfpv_new govt1 elec1) (d.sp_13 l.sp_13 c.l.iprefs_13##i.lfpv_new govt1 elec1) (d.sp_10 l.sp_10 c.l.iprefs_10##i.lfpv_new govt1 elec1)


*** Table S56. Electoral Vulnerability Hypothesis controlling for Electoral Proximity variable
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.vmargin govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##c.vmargin govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##c.vmargin govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##c.vmargin govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##c.vmargin govt1 elec2)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lpr govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lpr govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lpr govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lpr govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lpr govt1 elec2)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.pop govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##c.pop govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##c.pop govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##c.pop govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##c.pop govt1 elec2)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lpop govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lpop govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lpop govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lpop govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lpop govt1 elec2)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.gpv govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##c.gpv govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##c.gpv govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##c.gpv govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##c.gpv govt1 elec2)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lgpv govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lgpv govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lgpv govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lgpv govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lgpv govt1 elec2)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.fpv govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##c.fpv govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##c.fpv govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##c.fpv govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##c.fpv govt1 elec2)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lfpv govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lfpv govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lfpv govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lfpv govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lfpv govt1 elec2)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.fpv_new govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##i.fpv_new govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##i.fpv_new govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##i.fpv_new govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##i.fpv_new govt1 elec2)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.lfpv_new govt1 elec2) (d.sp_06 l.sp_06 c.l.iprefs_06##i.lfpv_new govt1 elec2) (d.sp_03 l.sp_03 c.l.iprefs_03##i.lfpv_new govt1 elec2) (d.sp_13 l.sp_13 c.l.iprefs_13##i.lfpv_new govt1 elec2) (d.sp_10 l.sp_10 c.l.iprefs_10##i.lfpv_new govt1 elec2)


*** Table S59. Electoral Proximity Hypothesis controlling for electoral vulnerability measures (I)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 vmargin) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 vmargin) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 vmargin) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 vmargin) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 vmargin)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 lpr) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 lpr) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 lpr) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 lpr) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 lpr)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 pop) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 pop) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 pop) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 pop) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 pop)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 lpop) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 lpop) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 lpop) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 lpop) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 lpop)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 gpv) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 gpv) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 gpv) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 gpv) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 gpv)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 lgpv) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 lgpv) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 lgpv) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 lgpv) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 lgpv)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 fpv) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 fpv) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 fpv) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 fpv) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 fpv)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 lfpv) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 lfpv) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 lfpv) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 lfpv) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 lfpv)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 fpv_new fpv_new) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 fpv_new) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 fpv_new) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 fpv_new) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 fpv_new)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 lfpv_new) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 lfpv_new) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 lfpv_new) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 lfpv_new) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 lfpv_new)


*** Table S62. Electoral Proximity Hypothesis controlling for electoral vulnerability measures (II)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 vmargin) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 vmargin) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 vmargin) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 vmargin) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 vmargin)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 lpr) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 lpr) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 lpr) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 lpr) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 lpr)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 pop) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 pop) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 pop) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 pop) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 pop)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 lpop) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 lpop) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 lpop) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 lpop) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 lpop)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 gpv) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 gpv) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 gpv) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 gpv) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 gpv)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 lgpv) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 lgpv) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 lgpv) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 lgpv) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 lgpv)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 fpv) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 fpv) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 fpv) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 fpv) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 fpv)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 lfpv) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 lfpv) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 lfpv) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 lfpv) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 lfpv)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 fpv_new fpv_new) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 fpv_new) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 fpv_new) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 fpv_new) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 fpv_new)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 lfpv_new) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 lfpv_new) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 lfpv_new) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 lfpv_new) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 lfpv_new)


*** Table S65. Controlling for GDP
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.vmargin govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##c.vmargin govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##c.vmargin govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##c.vmargin govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##c.vmargin govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lpr govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lpr govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lpr govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lpr govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lpr govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.pop govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##c.pop govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##c.pop govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##c.pop govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##c.pop govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lpop govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lpop govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lpop govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lpop govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lpop govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.gpv govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##c.gpv govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##c.gpv govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##c.gpv govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##c.gpv govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lgpv govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lgpv govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lgpv govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lgpv govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lgpv govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.fpv govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##c.fpv govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##c.fpv govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##c.fpv govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##c.fpv govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lfpv govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lfpv govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lfpv govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lfpv govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lfpv govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.fpv_new govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##i.fpv_new govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##i.fpv_new govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##i.fpv_new govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##i.fpv_new govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.lfpv_new govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##i.lfpv_new govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##i.lfpv_new govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##i.lfpv_new govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##i.lfpv_new govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.elec1 govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##i.elec1 govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##i.elec1 govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##i.elec1 govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##i.elec1 govt1 gdp)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.elec2 govt1 gdp) (d.sp_06 l.sp_06 c.l.iprefs_06##c.elec2 govt1 gdp) (d.sp_03 l.sp_03 c.l.iprefs_03##c.elec2 govt1 gdp) (d.sp_13 l.sp_13 c.l.iprefs_13##c.elec2 govt1 gdp) (d.sp_10 l.sp_10 c.l.iprefs_10##c.elec2 govt1 gdp)


*** Table S68. Electoral vulnerability measures created without govt ideology specification
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lpop2 govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lpop2 govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lpop2 govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lpop2 govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lpop2 govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lgpv2 govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lgpv2 govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lgpv2 govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lgpv2 govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lgpv2 govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##c.lfpv2 govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##c.lfpv2 govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##c.lfpv2 govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##c.lfpv2 govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##c.lfpv2 govt1)
sureg (d.sp_16 l.sp_16 c.l.iprefs_16##i.lfpv_new2 govt1) (d.sp_06 l.sp_06 c.l.iprefs_06##i.lfpv_new2 govt1) (d.sp_03 l.sp_03 c.l.iprefs_03##i.lfpv_new2 govt1) (d.sp_13 l.sp_13 c.l.iprefs_13##i.lfpv_new2 govt1) (d.sp_10 l.sp_10 c.l.iprefs_10##i.lfpv_new2 govt1)


*** Table S71. SUR Models of Electoral Incentives Effects on Policy Representation in the UK: Two Lags Public Opinion and Dynamic Measures of Electoral Vulnerability
sureg (d.sp_16 l.sp_16 c.l.l.iprefs_16##c.llpop govt1) (d.sp_06 l.sp_06 c.l.l.iprefs_06##c.llpop govt1) (d.sp_03 l.sp_03 c.l.l.iprefs_03##c.llpop govt1) (d.sp_13 l.sp_13 c.l.l.iprefs_13##c.llpop govt1) (d.sp_10 l.sp_10 c.l.l.iprefs_10##c.llpop govt1)
sureg (d.sp_16 l.sp_16 c.l.l.iprefs_16##c.llgpv govt1) (d.sp_06 l.sp_06 c.l.l.iprefs_06##c.llgpv govt1) (d.sp_03 l.sp_03 c.l.l.iprefs_03##c.llgpv govt1) (d.sp_13 l.sp_13 c.l.l.iprefs_13##c.llgpv govt1) (d.sp_10 l.sp_10 c.l.l.iprefs_10##c.llgpv govt1)
sureg (d.sp_16 l.sp_16 c.l.l.iprefs_16##c.llfpv govt1) (d.sp_06 l.sp_06 c.l.l.iprefs_06##c.llfpv govt1) (d.sp_03 l.sp_03 c.l.l.iprefs_03##c.llfpv govt1) (d.sp_13 l.sp_13 c.l.l.iprefs_13##c.llfpv govt1) (d.sp_10 l.sp_10 c.l.l.iprefs_10##c.llfpv govt1)
sureg (d.sp_16 l.sp_16 c.l.l.iprefs_16##i.llfpv_new govt1) (d.sp_06 l.sp_06 c.l.l.iprefs_06##i.llfpv_new govt1) (d.sp_03 l.sp_03 c.l.l.iprefs_03##i.llfpv_new govt1) (d.sp_13 l.sp_13 c.l.l.iprefs_13##i.llfpv_new govt1) (d.sp_10 l.sp_10 c.l.l.iprefs_10##i.llfpv_new govt1)


*** Table S74. OLS Models of Electoral Incentives Effects on Collective Representation in the UK
reg d.sp_social l.sp_social c.l.int_social##c.vmargin govt1
reg d.sp_social l.sp_social c.l.int_social##c.lpr govt1
reg d.sp_social l.sp_social c.l.int_social##c.pop govt1
reg d.sp_social l.sp_social c.l.int_social##c.lpop govt1
reg d.sp_social l.sp_social c.l.int_social##c.gpv govt1
reg d.sp_social l.sp_social c.l.int_social##c.lgpv govt1
reg d.sp_social l.sp_social c.l.int_social##c.fpv govt1
reg d.sp_social l.sp_social c.l.int_social##c.lfpv govt1
reg d.sp_social l.sp_social c.l.int_social##i.fpv_new govt1
reg d.sp_social l.sp_social c.l.int_social##i.lfpv_new govt1
reg d.sp_social l.sp_social c.l.int_social##i.elec1 govt1
reg d.sp_social l.sp_social c.l.int_social##c.elec2 govt1
