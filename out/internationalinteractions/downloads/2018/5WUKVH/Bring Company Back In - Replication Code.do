				*********************************************
				  ******Bringing the Company Back In*******
				*********************************************

NOTE: The following code reproduces the results from "Bringing the Company Back
In: A Firm-Level Analysis of Foreign Direct Investment." It should be noted
that there are two .dta files: "Replication Data" is the dataset used for the
actual analyses; "Estimated Effects" includes the point estimates, along with
lower- and upper-bound estimates, and should be used to recreate the figures.


						
						//Getting the Data Ready//
						
NOTE: Use the "Replication Data" file. 

**Sorting the data, and generating lags**
tsset pccow year
sort pccow year
foreach x of varlist subpres polity subpresXpolity durable growth gdp_percap lnpercap ihs_inflate ihs_inflate_pos ihs_inflate_neg lnpop urbanpercent impgdp expgdp extractperc manufperc servperc proprights econfree {
gen L_`x'=L.`x'
}
NOTE: Save the file.


						
						//Primary Analyses//

NOTE: Use the "Replication Data" file.

**Table 2: Democracy and New MNC Ventures (1994-2008)
logit subnew L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust

**Table 4: Democracy and New MNC Ventures, by Sector (1994-2008)
logit extnew L_polity L_durable L_extractperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres extnew_scope extnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres mannew_scope mannew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres sernew_scope sernew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust


					
					//Generating Predicted Values//
					
NOTE: Use the "Replication Data" file. The estimated effects reported in Table 3
were entered directly into the table. The estimated effects that correspond with
the figures were copied into a separate file ("Estimated Effects"). The commands
for generating the actual graphs can be found further down.

**Table 3: Effects of Significant Variables, Model 1
logit subnew L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
prvalue, x(L_polity 2 L_subpres 0 subnew_scope 1 subnew_comp 0) rest(mean)
prvalue, x(L_polity 8 L_subpres 0 subnew_scope 1 subnew_comp 0) rest(mean)
prvalue, x(L_polity 2 L_subpres 1 subnew_scope 1 subnew_comp 0) rest(mean)
prvalue, x(L_durable 32.51 L_polity 2 L_subpres 0 subnew_scope 1 subnew_comp 0) rest(mean)
prvalue, x(L_lnpercap 8.33 L_polity 2 L_subpres 0 subnew_scope 1 subnew_comp 0) rest(mean)
prvalue, x(L_lnpop 17.52 L_polity 2 L_subpres 0 subnew_scope 1 subnew_comp 0) rest(mean)
prvalue, x(L_urbanpercent 70.74 L_polity 2 L_subpres 0 subnew_scope 1 subnew_comp 0) rest(mean)
prvalue, x(L_ihs_inflate 4.38 L_polity 2 L_subpres 0 subnew_scope 1 subnew_comp 0) rest(mean)
prvalue, x(L_expgdp 63.98 L_polity 2 L_subpres 0 subnew_scope 1 subnew_comp 0) rest(mean)
prvalue, x(L_polity 2 L_subpres 0 subnew_scope 5 subnew_comp 0) rest(mean)
prvalue, x(L_polity 2 L_subpres 0 subnew_scope 1 subnew_comp 2) rest(mean)

**Figure 3: Joint Effects of Democracy and Presence on Choice of Host, Model 2
estsimp logit subnew L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
	*Panel A: Marginal Effect of Presence
setx mean
setx subnew_scope 1
setx subnew_comp 0
setx L_polity -10
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -10)
setx L_polity -9
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -9)
setx L_polity -8
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -8)
setx L_polity -7
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -7)
setx L_polity -6
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -6)
setx L_polity -5
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -5)
setx L_polity -4
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -4)
setx L_polity -3
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -3)
setx L_polity -2
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -2)
setx L_polity -1
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 -1)
setx L_polity 0
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 0)
setx L_polity 1
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 1)
setx L_polity 2
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 2)
setx L_polity 3
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 3)
setx L_polity 4
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 4)
setx L_polity 5
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 5)
setx L_polity 6
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 6)
setx L_polity 7
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 7)
setx L_polity 8
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 8)
setx L_polity 9
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 9)
setx L_polity 10
simqi, fd(prval(1)) changex(L_subpres 0 1 L_subpresXpolity 0 10)
	*Panel B1: Predicted Probability of New Venture (Absence)
setx mean
setx subnew_scope 1
setx subnew_comp 0
setx L_subpres 0
setx L_polity -10 L_subpresXpolity 0
simqi, pr
setx L_polity -9 L_subpresXpolity 0
simqi, pr
setx L_polity -8 L_subpresXpolity 0
simqi, pr
setx L_polity -7 L_subpresXpolity 0
simqi, pr
setx L_polity -6 L_subpresXpolity 0
simqi, pr
setx L_polity -5 L_subpresXpolity 0
simqi, pr
setx L_polity -4 L_subpresXpolity 0
simqi, pr
setx L_polity -3 L_subpresXpolity 0
simqi, pr
setx L_polity -2 L_subpresXpolity 0
simqi, pr
setx L_polity -1 L_subpresXpolity 0
simqi, pr
setx L_polity 0 L_subpresXpolity 0
simqi, pr
setx L_polity 1 L_subpresXpolity 0
simqi, pr
setx L_polity 2 L_subpresXpolity 0
simqi, pr
setx L_polity 3 L_subpresXpolity 0
simqi, pr
setx L_polity 4 L_subpresXpolity 0
simqi, pr
setx L_polity 5 L_subpresXpolity 0
simqi, pr
setx L_polity 6 L_subpresXpolity 0
simqi, pr
setx L_polity 7 L_subpresXpolity 0
simqi, pr
setx L_polity 8 L_subpresXpolity 0
simqi, pr
setx L_polity 9 L_subpresXpolity 0
simqi, pr
setx L_polity 10 L_subpresXpolity 0
simqi, pr
	*Panel B2: Predicted Probability of New Venture (Presence)
setx mean
setx subnew_scope 1
setx subnew_comp 0
setx L_subpres 1
setx L_polity -10 L_subpresXpolity -10
simqi, pr
setx L_polity -9 L_subpresXpolity -9
simqi, pr
setx L_polity -8 L_subpresXpolity -8
simqi, pr
setx L_polity -7 L_subpresXpolity -7
simqi, pr
setx L_polity -6 L_subpresXpolity -6
simqi, pr
setx L_polity -5 L_subpresXpolity -5
simqi, pr
setx L_polity -4 L_subpresXpolity -4
simqi, pr
setx L_polity -3 L_subpresXpolity -3
simqi, pr
setx L_polity -2 L_subpresXpolity -2
simqi, pr
setx L_polity -1 L_subpresXpolity -1
simqi, pr
setx L_polity 0 L_subpresXpolity 0
simqi, pr
setx L_polity 1 L_subpresXpolity 1
simqi, pr
setx L_polity 2 L_subpresXpolity 2
simqi, pr
setx L_polity 3 L_subpresXpolity 3
simqi, pr
setx L_polity 4 L_subpresXpolity 4
simqi, pr
setx L_polity 5 L_subpresXpolity 5
simqi, pr
setx L_polity 6 L_subpresXpolity 6
simqi, pr
setx L_polity 7 L_subpresXpolity 7
simqi, pr
setx L_polity 8 L_subpresXpolity 8
simqi, pr
setx L_polity 9 L_subpresXpolity 9
simqi, pr
setx L_polity 10 L_subpresXpolity 10
simqi, pr

clear

**Figure 4.1: Effect of Democracy on Choice of Host, Extraction
logit extnew L_polity L_subpres L_durable L_growth L_extractperc L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp extnew_scope extnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
prgen L_polity, gen(ext) f(-10) to(10) gap(1) ci x(L_subpres 0 extnew_scope 1 extnew_comp 0) rest(mean)
browse extx extp1 extp1lb extp1ub

clear

**Figure 4.2: Effect of Democracy on Choice of Host, Manufacturing
logit mannew L_polity L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres mannew_scope mannew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
prgen L_polity, gen(man) f(-10) to(10) gap(1) ci x(L_subpres 0 mannew_scope 1 mannew_comp 0) rest(mean)
browse manx manp1 manp1lb manp1ub

clear

**Figure 4.3: Effect of Democracy on Choice of Host, Services
logit sernew L_polity L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres sernew_scope sernew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
prgen L_polity, gen(ser) f(-10) to(10) gap(1) ci x(L_subpres 0 sernew_scope 1 sernew_comp 0) rest(mean)
browse polity serv_pol_pr serv_pol_lb serv_pol_ub

clear



						//Graphing the Findings//
						
NOTE: Use the "Estimated Effects" file.

**Figure 3
	*Panel A:
twoway (rcap fig3a_lb fig3a_ub polity) (scatter fig3a_me polity), legend(order(1 "95% Confidence Interval"))
	*Panel B:
twoway (line fig3b_abs_pr polity) (line fig3b_pres_pr polity), legend(order(1 "Absence (t-1)" 2 "Presence (t-1)"))

**Figure 4
	*Extraction:
twoway (rarea fig4_ext_lb fig4_ext_ub polity) (line fig4_ext_pr polity), legend(order(1 "95% Confidence Interval"))
	*Manufacturing:
twoway (rarea fig4_man_lb fig4_man_ub polity) (line fig4_man_pr polity), legend(order(1 "95% Confidence Interval"))
	*Services:
twoway (rarea fig4_ser_lb fig4_ser_ub polity) (line fig4_ser_pr polity), legend(order(1 "95% Confidence Interval"))







					//Robustness Checks (Web Appendix)//
					
NOTE: Use the "Replication Data" file.

**Table A4: Democracy*Presence, by Sector
logit extnew L_polity L_subpres L_subpresXpolity L_durable L_extractperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp extnew_scope extnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_subpres L_subpresXpolity L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp mannew_scope mannew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_subpres L_subpresXpolity L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp sernew_scope sernew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust

**Table A5: Table 2 Models w/ 'Relevance' Equation
gen subnew_rel=subnew
biprobit (subnew=L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp) (subnew_rel=L_lnpercap L_lnpop subnew_scope subnew_comp) if highdev==0&homecow!=cowcode, partial cl(cyear) robust
biprobit (subnew=L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp) (subnew_rel=L_lnpercap L_lnpop subnew_scope subnew_comp) if highdev==0&homecow!=cowcode, partial cl(cyear) robust

**Table A6: Property Rights and New MNC Ventures
logit subnew L_proprights L_polity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew proprights_drop L_polity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust

**Table A7: Main Models w/ Temporal Term
logit subnew L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp subnew_yrs if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp subnew_yrs if highdev==0&homecow!=cowcode, cl(cyear) robust
logit extnew L_polity L_subpres L_durable L_extractperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp extnew_scope extnew_comp extnew_yrs if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_subpres L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp mannew_scope mannew_comp mannew_yrs if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_subpres L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp sernew_scope sernew_comp sernew_yrs if highdev==0&homecow!=cowcode, cl(cyear) robust

**Table A8: Main Models Including Deflation
logit subnew L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate_pos L_ihs_inflate_neg L_expgdp L_impgdp subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate_pos L_ihs_inflate_neg L_expgdp L_impgdp subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit extnew L_polity L_subpres L_durable L_extractperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate_pos L_ihs_inflate_neg L_expgdp L_impgdp extnew_scope extnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_subpres L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate_pos L_ihs_inflate_neg L_expgdp L_impgdp mannew_scope mannew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_subpres L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate_pos L_ihs_inflate_neg L_expgdp L_impgdp sernew_scope sernew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust

**Table A9: Main Models w/ Econ. Controls Replaced by 'Economic Freedom Index'
logit subnew L_polity L_subpres L_durable L_econfree L_lnpop L_urbanpercent subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity L_durable L_econfree L_lnpop L_urbanpercent subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit extnew L_polity L_subpres L_durable L_econfree L_extractperc L_lnpop L_urbanpercent extnew_scope extnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_subpres L_durable L_econfree L_manufperc L_lnpop L_urbanpercent mannew_scope mannew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_subpres L_durable L_econfree L_servperc L_lnpop L_urbanpercent sernew_scope sernew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust

**Table A10: Main Models Excluding Firm-Specific Controls
logit subnew L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit extnew L_polity L_subpres L_durable L_extractperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_subpres L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_subpres L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp if highdev==0&homecow!=cowcode, cl(cyear) robust

**Tables A11, A12 & A13: Firm, Year and Country Fixed Effects
logit subnew L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp if highdev==0&homecow!=cowcode, cl(cyear) robust
quietly tab pcid if e(sample), gen(pc)
quietly tab year if e(sample), gen(yr)
quietly tab cowcode if e(sample), gen (c)
	*Table All: Table 2 Models w/ Firm and Year Fixed Effects
logit subnew L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
	*Table A12: Table 4 Models w/ Firm and Year Fixed Effects
logit extnew L_polity L_durable L_extractperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres extnew_scope extnew_comp pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit extnew L_polity pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres mannew_scope mannew_comp pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp L_subpres sernew_scope sernew_comp pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity pc1-yr15 if highdev==0&homecow!=cowcode, cl(cyear) robust
	*Table A13: Main Models w/ Country, Firm and Year Fixed Effects
logit subnew L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp pc1-c133 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity pc1-c133 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit extnew L_polity L_subpres L_durable L_extractperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp extnew_scope extnew_comp pc1-c133 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit extnew L_polity pc1-c133 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_subpres L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp mannew_scope mannew_comp pc1-c133 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity pc1-c133 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_subpres L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp sernew_scope sernew_comp pc1-c133 if highdev==0&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity pc1-c133 if highdev==0&homecow!=cowcode, cl(cyear) robust

**Table A14: Main Models, All Countries w/ per capita GDP < $10,000
logit subnew L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp if L_gdp_percap<10000&homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp if L_gdp_percap<10000&homecow!=cowcode, cl(cyear) robust
logit extnew L_polity L_subpres L_durable L_extractperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp extnew_scope extnew_comp if L_gdp_percap<10000&homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_subpres L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp mannew_scope mannew_comp if L_gdp_percap<10000&homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_subpres L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp sernew_scope sernew_comp if L_gdp_percap<10000&homecow!=cowcode, cl(cyear) robust

**Table A15: Main Models, All Countries (except US)
logit subnew L_polity L_subpres L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp if homecow!=cowcode, cl(cyear) robust
logit subnew L_polity L_subpres L_subpresXpolity L_durable L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp subnew_scope subnew_comp if homecow!=cowcode, cl(cyear) robust
logit extnew L_polity L_subpres L_durable L_extractperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp extnew_scope extnew_comp if homecow!=cowcode, cl(cyear) robust
logit mannew L_polity L_subpres L_durable L_manufperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp mannew_scope mannew_comp if homecow!=cowcode, cl(cyear) robust
logit sernew L_polity L_subpres L_durable L_servperc L_growth L_lnpercap L_lnpop L_urbanpercent L_ihs_inflate L_expgdp L_impgdp sernew_scope sernew_comp if homecow!=cowcode, cl(cyear) robust

