
* Replication: * Johns, Leslie, and Krzysztof J. Pelc. 2017. 
* "Free-Riding on Enforcement in the WTO." Journal of Politics.

cd "~/replication"

use "replication.dta", clear
stset delayA_wto, failure(complainant)

set more off

* C1: max sample
stcox  bown_global   lnmaster_counter startyear, vce(cluster dispute_combined) nohr
est store m1
* substantives:
di 1-exp(_b[bown_global])

* global, but only on merch, with controls
xi: stcox  bown_global  lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr
est store m2
 	* with topic as shared frailty (not shown):
stcox  bown_global  lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear, shared(topic) nohr

* + hhi
xi: stcox  bown_global hhi_trade_t lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr
est store m3
* substantives:
su hhi_trade_t if e(sample)
	* sd=.2258833
di 1-(exp(-1.082179 * .2258833  ) )

	* with topic as shared frailty (not shown):
stcox  bown_global hhi_trade_t lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear, shared(topic) nohr

* + num 
xi: stcox  bown_global lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr
est store m4
	* with topic as shared frailty (not shown):
stcox  bown_global lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear, shared(topic) nohr

label var lnOWN_trade_t "Own Trade Stake (log)"
label var lnROW_trade_t "ROW Trade Stake (log)"
label var ln_partner_gdp_cap "Country GDP/cap (log)"
label var ln_resp_gdp_cap "Respondent GDP/cap (log)"
label var ln_partner_gdpconst "Country GDP (log)"
label var ln_resp_gdpconst "Respondent GDP (log)"
label var resp_trade_gdp "Respondent Trade Dependence"
label var  partner_trade_gdp "Country Trade Dependence"
label var  startyear "Initiation Year"
label var hhi_trade_t "Disputed Trade Flows HHi"
label var bown_global "Global Policy"
label var lnmaster_counter "Country Legal Capacity" 
label var lnnum_countries500K "Number of Countries Affected (log)"
	
esttab m1 m2 m3 m4 using table.tex, replace cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) title(Diffuseness of Violations and the Rate of Legal Challenge \label{survival}) style(tex) compress legend varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01) label stats(N r2 rmse, fmt(0 2 3) label(N R-squared )) order(bown_global hhi_trade_t lnnum_countries500K lnOWN_trade_t lnROW_trade_t ln_partner_gdp_cap ln_partner_gdpconst partner_trade_gdp ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp lnmaster_counter startyear)

* test all three, using "lnnum_countries_any" to decrease collinearity with hhi:
* hhi + num + fe
quietly xi: stcox  bown_global hhi_trade_t lnnum_countries_any lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr 
 
* PH for 3 key variables
estat phtest, plot(bown_global)
estat phtest, plot(hhi_trade_t)
estat phtest, plot(lnnum_countries_any)
  
* draw diffuse vs. concentrated
su hhi_trade_t lnnum_countries_any if e(sample)
di  .3323394  +  .2258833  
di  .3323394  -  .2258833  
di  3.676932  -  .8092389  
di  3.676932  +  .8092389  
stcurve, cumhaz at(bown_global= 0   lnnum_countries_any =2.8676931  hhi_trade_t=.5582227 )  at(bown_global= 1 lnnum_countries_any =4.4861709 hhi_trade_t= .1064561)
  
  

* Appendix. 

* Restrict sample to only filer countries.  
xi: stcox  bown_global hhi_trade_t lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic if filer==1, vce(cluster dispute) nohr 
est store a1
 
xi: stcox  bown_global lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic if filer==1, vce(cluster dispute) nohr 
est store a2

* With topic as shared frailty

stcox  bown_global  lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear, shared(topic) nohr
est store a3

stcox  bown_global hhi_trade_t lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear, shared(topic) nohr
est store a4

stcox  bown_global lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear, shared(topic) nohr
est store a5

esttab a1 a2 a3 a4 a5 using table.tex, replace cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) title(Appendix A: Diffuseness of Violations and the Rate of Legal Challenge \label{survival}) style(tex) compress legend varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01) label stats(N r2 rmse, fmt(0 2 3) label(N R-squared )) order(bown_global hhi_trade_t lnnum_countries500K lnOWN_trade_t lnROW_trade_t ln_partner_gdp_cap ln_partner_gdpconst partner_trade_gdp ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp lnmaster_counter startyear)


* Comparing different trade threshold for the number of countries: 
xi: stcox  bown_global lnnum_countries_any lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr 
est store a6

xi: stcox  bown_global lnnum_countries100K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr 
est store a7

xi: stcox  bown_global lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr 
est store a8

xi: stcox  bown_global lnnum_countries1M lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr 
est store a9

label var lnnum_countries_any "Number of Countries ($>USD0$)"
label var lnnum_countries100K "Number of Countries ($>USD100,000$)"
label var lnnum_countries500K "Number of Countries ($>USD500,000$)"
label var lnnum_countries1M "Number of Countries ($>USD1M$)"


esttab a6 a7 a8 a9 using table.tex, replace cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) title(Appendix B: Rate of Legal Challenge \label{survival}) style(tex) compress legend varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01) label stats(N r2 rmse, fmt(0 2 3) label(N R-squared )) order(bown_global hhi_trade_t lnnum_countries500K lnOWN_trade_t lnROW_trade_t ln_partner_gdp_cap ln_partner_gdpconst partner_trade_gdp ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp lnmaster_counter startyear)


* Accounting for multiple complainants, both by adding a count variable, and by excluding them. 

xi: stcox  bown_global  lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic if total_compl_disp==1, vce(cluster dispute) nohr
est store a10

xi: stcox  bown_global  lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic total_compl_disp, vce(cluster dispute) nohr
est store a11

xi: stcox  bown_global hhi_trade_t lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic if total_compl_disp==1, vce(cluster dispute) nohr
est store a12

xi: stcox  bown_global hhi_trade_t lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic  total_compl_disp, vce(cluster dispute) nohr
est store a13

xi: stcox  bown_global lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic if total_compl_disp==1, vce(cluster dispute) nohr
est store a14

xi: stcox  bown_global lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic total_compl_disp, vce(cluster dispute) nohr
est store a15

label var total_compl_disp "Number of Complainants"

esttab a10  a12 a14  using table.tex, replace cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) title(Appendix C: Accounting for Multiple Complainants \label{survival}) style(tex) compress legend varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01) label stats(N r2 rmse, fmt(0 2 3) label(N R-squared )) order(bown_global hhi_trade_t lnnum_countries500K lnOWN_trade_t lnROW_trade_t ln_partner_gdp_cap ln_partner_gdpconst partner_trade_gdp ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp lnmaster_counter startyear)


* change delay to GATT period: 

stset log_delayA, failure(complainant)

xi: stcox  bown_global  hhi_trade_t lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr

xi: stcox  bown_global lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr


*****************
* Dispute-level *
*****************

use "replication.dta", clear

keep if complainant==1

stset delayA_wto

xi: stcox  bown_global lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr
est store a16

xi: stcox  lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr
est store a17

xi: stcox  hhi_trade_t lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr
est store a18

xi: stcox  bown_global lnnum_countries500K lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr
est store a19

xi: stcox bown_global hhi_trade_t lnmaster_counter lnOWN_trade_t lnROW_trade_t  ln_partner_gdp_cap ln_partner_gdpconst ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp partner_trade_gdp startyear i.topic, vce(cluster dispute) nohr
est store a20

esttab a16 a17 a18 a19 a20 using table.tex, replace cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) title(Appendix B: Diffuseness of Violations and the Rate of Legal Challenge \label{survival}) style(tex) compress legend varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01) label stats(N r2 rmse, fmt(0 2 3) label(N R-squared )) order(bown_global hhi_trade_t lnnum_countries500K lnOWN_trade_t lnROW_trade_t ln_partner_gdp_cap ln_partner_gdpconst partner_trade_gdp ln_resp_gdp_cap ln_resp_gdpconst resp_trade_gdp lnmaster_counter startyear)

****************
* Legal outcomes*
****************

use "replication.dta", clear

keep if complainant==1

* global only
heckprob netwin_dummy bown_global lnOWN_trade_t   startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic, select(ruling =  BRthirdp1  lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst lnOWN_trade_t) cluster(dispute_combined)
est store m1

* hhi only
xi: heckprob netwin_dummy lnOWN_trade_t hhi_trade_t    startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic , select(ruling =  BRthirdp1  lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst lnOWN_trade_t) cluster(dispute)
est store m2

* num 500K only.
xi: heckprob netwin_dummy lnOWN_trade_t lnnum_countries500K    startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic , select(ruling =  BRthirdp1  lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst lnOWN_trade_t) cluster(dispute)
est store m3


* global and hhi
xi: heckprob netwin_dummy lnOWN_trade_t hhi_trade_t  bown_global  startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic , select(ruling =  BRthirdp1  lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst lnOWN_trade_t) cluster(dispute)
est store m4
margins, atmeans at(bown_global=1 )
margins, atmeans at(bown_global=0 )


* global and num500KÉ
xi: heckprob netwin_dummy lnOWN_trade_t bown_global lnnum_countries500K    startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic , select(ruling =  BRthirdp1  lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst lnOWN_trade_t) cluster(dispute)
est store m5

label var BRthirdp1 "Number of Third Parties"

esttab m1 m2 m3 m4 m5 using table.tex, replace cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) title(Appendix B: Concentration of Benefits and Legal Success \label{success}) style(tex) compress legend varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01) label stats(N r2 rmse, fmt(0 2 3) label(N R-squared )) order(bown_global hhi_trade_t lnnum_countries500K  )



* Robustness: 


* multiple Cs, both as control, and excluded from sample. 
heckprob  netwin_dummy lnOWN_trade_t hhi_trade_t  bown_global  startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic total_compl_dispcom, select(ruling =  BRthirdp1  lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst lnOWN_trade_t) cluster(dispute)
est store h1

heckprob  netwin_dummy lnOWN_trade_t lnnum_countries500K  bown_global  startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic total_compl_dispcom, select(ruling =  BRthirdp1  lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst lnOWN_trade_t) cluster(dispute)
est store h2

heckprob  netwin_dummy lnOWN_trade_t hhi_trade_t  bown_global  startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic if total_compl_dispcom==1, select(ruling =  BRthirdp1  lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst lnOWN_trade_t) cluster(dispute)
est store h3

heckprob  netwin_dummy lnOWN_trade_t lnnum_countries500K  bown_global  startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic if total_compl_dispcom==1, select(ruling =  BRthirdp1  lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst lnOWN_trade_t) cluster(dispute)
est store h4

esttab h1 h2 h3 h4 using table.tex, replace cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) title(Appendix E: Legal Success, Accounting for Multiple Complainants  \label{success}) style(tex) compress legend varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01) label stats(N r2 rmse, fmt(0 2 3) label(N R-squared )) order(bown_global hhi_trade_t lnnum_countries500K  )


* No selection stage: 

probit netwin_dummy bown_global lnOWN_trade_t   startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic
est store m6 

probit netwin_dummy bown_global hhi_trade_t lnOWN_trade_t   startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic, cluster(dispute)
est store m7 

probit netwin_dummy bown_global lnnum_countries500K lnOWN_trade_t   startyear lnmaster_counter ln_partner_gdpconst ln_resp_gdpconst i.topic, cluster(dispute)
est store m8

esttab m6 m7 m8 using table.tex, replace cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) title(Appendix F:  Legal Success, Single-Stage \label{success}) style(tex) compress legend varlabels(_cons Constant) star(* 0.10 ** 0.05 *** 0.01) label stats(N r2 rmse, fmt(0 2 3) label(N R-squared )) order(bown_global hhi_trade_t lnnum_countries500K  )


* end *

clear
