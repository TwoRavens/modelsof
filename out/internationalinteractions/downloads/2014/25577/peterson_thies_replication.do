*Replication do file for Peterson & Thies: "The Demand for Protectionism, Demand, Import Elasticity, and Trade Barriers."



****Table 1
xtreg total_prot c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto, fe robust
est store m1
xtreg total_prot c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion, fe robust
est store m2

margins, dydx(polity_adj) at( (means) _all lnelas =(0(.2)2.4))
marginsplot, recast(line) recastci(rarea)
graph save Graph "totprot_p.gph"

xtreg ave_cd c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto if total_prot!=., fe robust
est store m3
xtreg ave_cd c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion if total_prot!=., fe robust
est store m4

margins, dydx(polity_adj) at( (means) _all lnelas =(0(.2)2.4))
marginsplot, recast(line) recastci(rarea)
graph save Graph "ntb_p.gph"

xtreg tariff c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto if total_prot!=., fe robust
est store m5
xtreg tariff c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion if total_prot!=., fe robust
est store m6

margins, dydx(polity_adj) at( (means) _all lnelas =(0(.2)2.4))
marginsplot, recast(line) recastci(rarea)
graph save Graph "tariff_p.gph"

outreg2 [m1 m2 m3 m4 m5 m6] using newtable1, word alpha(0.001, 0.01, 0.05) bdec(3)

*figure 1 ( requires some labeling)
graph combine totprot_p.gph ntb_p.gph tariff_p.gph, ycommon col(3)



*Models with unlogged elasticity measure (divided by 100) (appendix table 1)
xtreg total_prot c.polity_adj##c.elastinv10 imp_pen exp_dep mean_IIT count_riv count_ally ldc wto, fe robust
est store m1e
xtreg total_prot c.polity_adj##c.elastinv10 imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion, fe robust
est store m2e
xtreg ave_cd c.polity_adj##c.elastinv10 imp_pen exp_dep mean_IIT count_riv count_ally ldc wto if total_prot!=., fe robust
est store m3e
xtreg ave_cd c.polity_adj##c.elastinv10 imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion if total_prot!=., fe robust
est store m4e
xtreg tariff c.polity_adj##c.elastinv10 imp_pen exp_dep mean_IIT count_riv count_ally ldc wto if total_prot!=., fe robust
est store m5e
xtreg tariff c.polity_adj##c.elastinv10 imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion if total_prot!=., fe robust
est store m6e



*Models with unrestricted observations (appendix table 2)
xtreg ave_cd c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto, fe robust
est store m3a
xtreg ave_cd c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion, fe robust
est store m4a
xtreg tariff c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto, fe robust
est store m5a
xtreg tariff c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion, fe robust
est store m6a


***For graphs of elasticity marginal effect over polity
xtreg total_prot c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion, fe robust
margins, dydx(lnelas) at( (means) _all polity_adj=(0(2)20))
marginsplot, recast(line) recastci(rarea)
graph save Graph "totprot_e.gph"


xtreg ave_cd c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion if total_prot!=., fe robust
margins, dydx(lnelas) at( (means) _all polity_adj=(0(2)20))
marginsplot, recast(line) recastci(rarea) 
graph save Graph "NTB_e.gph"

xtreg tariff c.polity_adj##c.lnelast imp_pen exp_dep mean_IIT count_riv count_ally ldc wto i.cowregion if total_prot!=., fe robust
margins, dydx(lnelas) at( (means) _all polity_adj=(0(2)20))
marginsplot, recast(line) recastci(rarea)
graph save Graph "tariff_e.gph"

**the final graph requires some labeling
graph combine totprot_e.gph NTB_e.gph tariff_e.gph, ycommon col(3)
