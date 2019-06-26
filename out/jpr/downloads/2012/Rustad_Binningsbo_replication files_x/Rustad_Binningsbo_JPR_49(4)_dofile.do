/*Rustad, Siri Aas & Helga Malmin Binningsbø (2012) A price worth fighting for? Natural resources and conflict recurrence*/
/*Journal of Peace Research 49(4): 531-546*/
/*Data file: Rustad_Binningsbo_JPR_49(4).dta*/

/*Original data source: ACD UCDP/PRIO version 4-2007 (Gleditsch et al., 2002)*/
/*2 year rule for conflict episodes*/
/*Method: Exponential peacewise duration analysis*/

/*Stset*/
stset newend, id(pperid) failure(censor==1) origin(time newstart) scale(365.25)
 
/*Table I*/
/*Not made in stata*/

/*Table II*/
/*Not made in stata*/

/*Table III*/
quietly: streg res_confl lnconfldur victory peaceagr lnKSGrgdpch lnpop ethfrac ccodeconfl unoper international PW3_5 PW6_20, tr d(exp)
streg res_confl  PW3_5 PW6_20 if e(sample), tr d(exp)
streg res_confl lnconfldur victory peaceagr lnKSGrgdpch lnpop ethfrac ccodeconfl unoper international PW3_5 PW6_20, tr d(exp)

/*Figure 2a-c*/
sts graph, by(distribution) scheme(s2mono) graphregion(ifcolor(white)) graphregion(margin(zero)) ///
 title(" ", size(zero)) legend(order(1 "No distribution mechanisms" 2 "Distribution mechanisms")) xtitle(Postconflict years)
sts graph, by(finance) scheme(s2mono) graphregion(ifcolor(white)) graphregion(margin(zero)) ///
 title(" ", size(zero)) legend(order(1 "No financing mechanisms" 2 "Financing mechanisms")) xtitle(Postconflict years)
sts graph, by(aggrav) scheme(s2mono) graphregion(ifcolor(white)) graphregion(margin(zero)) ///
 title(" ", size(zero)) legend(order(1 "No aggravation mechanisms" 2 "Aggravation mechanisms")) xtitle(Postconflict years)

/*Table IV*/
streg distribution finance aggrav lnconfldur victory peaceagr lnKSGrgdpch lnpop ethfrac ccodeconfl unoper international PW3_5 PW6_20, tr d(exp)