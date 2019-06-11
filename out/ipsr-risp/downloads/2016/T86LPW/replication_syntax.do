***Replication syntax*******
***Russo-Verzichelli ITPSR**
***January 2016************* 

***DATASET PREPARATION

	*Declare Stata version
	version 12

	*Open file
	use replication_data.dta

	*generate growth rates for several spending categories
	
	*DEFENCE
	gen f2GDP = f2/gdp 
	gen lnf2GDP = ln(f2GDP)
	gen Dlnf2GDP = d.lnf2GDP
	drop lnf2GDP

	*ORDER
	gen f3GDP = f3/gdp
	gen lnf3GDP = ln(f3GDP)
	gen Dlnf3GDP = d.lnf3GDP
	drop lnf3GDP

	*EDUCATION
	gen f4GDP = f4/gdp
	gen lnf4GDP = ln(f4GDP)
	gen Dlnf4GDP = d.lnf4GDP
	drop lnf4GDP

	*WELFARE
	gen f5_6 = f5+f6
	gen f5_6GDP = f5_6/gdp
	gen lnf5_6GDP = ln(f5_6GDP)
	gen Dlnf5_6GDP = d.lnf5_6GDP
	drop lnf5_6GDP

	*generate variables measuring the relative attention to each category on the total attention given to spending items in electoral manifestos
	
	*generate total attention on spending items
	gen attention_spending =  per104+ per105+ per605+ per502+ per506+ per507+ per501+ per504+ per505+ per403+ per404+ per406+ per409+ per412+ per413+ per401+ per402+ per407+ per414+ per503
	
	*generate growth rates for attention (sometimes attention is 0, to compute the logarithm it is necessary to add a very small quantity)
	gen RelAtt_Welfare =  welfare_cmp/attention_spending
	gen ln_RelWel = ln(RelAtt_Welfare+0.000001)
	gen LDln_RelWel = l.d.ln_RelWel
	drop ln_RelWel

	gen RelAtt_Defence = per104/attention_spending
	gen ln_RelDef = ln(RelAtt_Defence+0.000001)
	gen LDln_RelDef = l.d.ln_RelDef
	drop ln_RelDef

	gen educul_cmp = per502 + per503 + per506
	gen RelAtt_Education = educul_cmp/attention_spending
	gen ln_RelEdu = ln(RelAtt_Education+0.000001)
	gen LDln_RelEdu = l.d.ln_RelEdu
	drop ln_RelEdu

	gen RelAtt_Order = per605/attention_spending
	gen ln_RelOrd = ln(RelAtt_Order+0.000001)
	gen LDln_RelOrd = l.d.ln_RelOrd
	drop ln_RelOrd

	*generate lagged difference for govenrment left-right position
	gen LDLeftRight = l.d.left_right


	*CONTROL VARIABLES

	*growth rate for GDP
	gen ln_gdp = ln(gdp)
	gen Dln_gdp = d.ln_gdp
	drop ln_gdp 

	*generate growth rate for population with more than 65 years
	gen ln_pop65 = ln(pop65)
	gen Dln_pop65 = d.ln_pop65
	drop ln_pop65

	*generate growth rate for cost of military missions
	gen lnCost_Miss = ln(cost_miss+0.000001)

	*generate Government ideological range
	gen Lwinset = l.right_veto - l.left_veto 

***TABLE 1
summarize Dlnf2GDP Dlnf3GDP Dlnf4GDP Dlnf5_6GDP LDln_RelDef LDln_RelOrd LDln_RelEdu LDln_RelWel LDLeftRight electyrs Dln_gdp overall_budget_regime Lwinset 
	

***TABLE 2
 
regress   Dlnf2GDP LDln_RelDef LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime, robust
estimates store m1, title(Defence)
regress   Dlnf2GDP LDln_RelDef c.Lwinset##c.LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime, robust
	margins, dydx(LDLeftRight) at (Lwinset=(0(0.5)6.5))
	marginsplot, recast(line) recastci(rarea) yline(0)
	graph save lrDef, replace
	graph export lrDef.eps, replace
estimates store m1b, title(Defence)
	
regress   Dlnf3GDP LDln_RelOrd LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime, robust
estimates store m2, title(Public Order)
regress   Dlnf3GDP LDln_RelOrd c.Lwinset##c.LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime, robust
estimates store m2b, title(Public Order)


regress   Dlnf4GDP LDln_RelEdu LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime, robust
estimates store m3, title(Education)
regress   Dlnf4GDP LDln_RelEdu c.Lwinset##c.LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime, robust
estimates store m3b, title(Education)

regress  Dlnf5_6GDP LDln_RelWel LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime, robust
estimates store m4, title(Welfare)
regress  Dlnf5_6GDP LDln_RelWel c.Lwinset##c.LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime, robust
	margins, dydx(LDLeftRight) at (Lwinset=(0(0.5)6.5))
	marginsplot, recast(line) recastci(rarea) yline(0)
	graph save lrWel, replace
	graph export lrWel.eps, replace
estimates store m4b, title(Welfare)

esttab m1 m1b m2 m2b m3 m3b m4 m4b using models.rtf, replace se ar2 nonumbers mtitles star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


***TABLE 4
regress f2 l.f2 l.RelAtt_Defence l.gdp  l.overall_budget_regime l.left_right f.electyrs, robust

regress f3 l.f3 l.RelAtt_Order l.gdp  l.overall_budget_regime l.left_right f.electyrs, robust

regress f4 l.f4 l.RelAtt_Education l.gdp  l.overall_budget_regime l.left_right f.electyrs, robust

regress f5_6 l.f5_6 l.RelAtt_Welfare l.gdp  l.overall_budget_regime l.left_right f.electyrs, robust

esttab m1b m2b m3b m4b using models_PAM.rtf, replace se ar2 nonumbers mtitles star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

***Additional robusteness check for the models on Defence and Welfare Spending
regress   Dlnf2GDP LDln_RelDef LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime d.cost_miss, robust
regress   Dlnf2GDP LDln_RelDef c.Lwinset##c.LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime d.cost_miss, robust
regress   Dlnf5_6GDP LDln_RelWel LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime Dln_pop65, robust
regress   Dlnf5_6GDP LDln_RelWel c.Lwinset##c.LDLeftRight f.electyrs l.Dln_gdp l.overall_budget_regime Dln_pop65, robust


***FIGURE 2

gr combine lrDef.gph lrWel.gph, ycommon saving(interaction, replace)


