*commands to replicate models in "Foreign Terrorist Organization Designation, International Cooperation, and Terrorism" for II

*Table 2.
*1 controls only
xtregar d.attacks lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe
*2 FTO only
xtregar d.attacks lagfto lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe
*3 US alliance only
xtregar d.attacks USalliance lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe
*4 interaction
*main model:
xtregar d.attacks i.lagfto##i.USalliance lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe
*5 continuous interaction
xtregar d.attacks  i.lagfto##c.w_sscore lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe

*graphing
*Figure 1, which uses Model 4:
set scheme s1mono
quietly xtregar d.attacks i.lagfto##i.USalliance lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe
quietly margins, dydx(lagfto) at(USalliance=(0(1)1))
marginsplot, recast(scatter) yline(5 0 -5 -10 -15 -20, lcolor(gs15)) xscale(range( -.5 1.5)) yline(0)  note("95% confidence intervals shown.")

*Figure 2, which uses Model 4
quietly xtregar d.attacks  i.lagfto##c.w_sscore lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe
quietly margins, dydx(lagfto) at(w_sscore=(-.25(.25)1))
marginsplot,  yline(0)  note("95% confidence intervals shown.")

**Table 3, robustness checks of Model 4
*6 no group FE, with additional terms
reg d.attacks i.lagfto##i.USalliance lagattacks age age_squared lagdecapscumulative ucdp size religious territory statesponsor vdem_libdem log_pwt_pop gdppc, cluster(groupid)
*7 only 1997-2006
xtregar d.attacks lagfto##USalliance lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc if year >1996, fe
*8 country attacks instead of group attacks
xtregar d.attacks_country i.lagfto##i.USalliance l.attacks_country age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe
*9 ftotime
xtregar d.attacks c.lagftotime##i.USalliance lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe
*10 FBI office instead of USalliance
xtregar d.attacks i.lagfto##i.FBIoffice lagattacks age age_squared lagdecapscumulative vdem_libdem log_pwt_pop gdppc, fe
