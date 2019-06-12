

**Figure 1
xtline agc coefvar if year >1979 ,  scheme(s2mono)

**Table 2
xi: xtpcse socexp_t  unemp  realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc  ,pair       corr(psar1) 
xi: xtpcse socexp_t  unemp   realgdp openc kaopen  interest gov_left1 vturn efelth coefvar efelth_coefvar  ,pair       corr(psar1)  
xi: xtpcse socexp_t  unemp   realgdp openc kaopen  interest gov_left1 vturn efelth per90 efelth_per9010  ,pair       corr(psar1)  
xtpcse socexp_t  unemp realgdp openc kaopen  interest gov_left1 vturn i.majoritarian##c.agc  ,pair       corr(psar1)
xi: xtpcse socexp_t  unemp   realgdp openc kaopen  interest gov_left1 vturn  i.majoritarian*coefvar  ,pair       corr(psar1)  
xi: xtpcse socexp_t  unemp   realgdp openc kaopen  interest gov_left1 vturn  i.majoritarian*per90  ,pair       corr(psar1)  
   
 *Figure 2
label var agc "AGC"
 xi: xtpcse socexp_t  unemp  realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc  ,pair       corr(psar1) 
grinter agc, const(efelth) inter(efelth_agc) nomean xlabel(0 10 20 30 37.5)   yline(0) scheme(s2mono) 

 *Figure 3  
xtpcse socexp_t  unemp realgdp openc kaopen  interest gov_left1 vturn i.majoritarian##c.agc  ,pair       corr(psar1)
margins majoritarian, at (agc=(0(0.05)0.35))   atmeans noatlegend
marginsplot, level(95) ytitle(Predicted Social Expenditure %GDP) xtitle ("Adjusted Geographic Concentration")  title("") plot(, label("Majoritarian" "Non Majoritarian")) scheme(lean1) legend(position(6))


 *** TABLE 3
xi: xtpcse sstran unemp    realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc  ,pair       corr(psar1)  
xi: xtpcse sstran  unemp    realgdp openc kaopen  interest gov_left1 vturn efelth coefvar efelth_coefvar  ,pair       corr(psar1)  
xi: xtpcse sstran  unemp    realgdp openc kaopen  interest gov_left1 vturn efelth per90 efelth_per9010  ,pair       corr(psar1)  
xi: xtpcse sstran unemp    realgdp openc kaopen  interest gov_left1 vturn i.majoritarian*agc  ,pair       corr(psar1)  
xi: xtpcse sstran  unemp    realgdp openc kaopen  interest gov_left1 vturn  i.majoritarian*coefvar  ,pair       corr(psar1)  
xi: xtpcse sstran unemp    realgdp openc kaopen  interest gov_left1 vturn  i.majoritarian*per90  ,pair       corr(psar1)  

	   
	   
*** TABLE 4
 ******** ROBUSTNESS DEP VARIABLE

xi: xtpcse socexp_c unemp    realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc  ,pair       corr(psar1)  
xi: xtpcse socexp_c unemp    realgdp openc kaopen  interest gov_left1 vturn i.majoritarian*agc   ,pair       corr(psar1)  

xi: xtpcse socexp_k unemp    realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc  ,pair       corr(psar1)   
xi: xtpcse socexp_k unemp    realgdp openc kaopen  interest gov_left1 vturn  i.majoritarian*agc   ,pair       corr(psar1)   

xi: xtpcse unempl_policies unemp    realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc  ,pair       corr(psar1)  
xi: xtpcse  unempl_policies unemp    realgdp openc kaopen  interest gov_left1 vturn   i.majoritarian*agc   ,pair       corr(psar1)  

xi: xtpcse other_s unemp    realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc  ,pair       corr(psar1)  
xi: xtpcse  other_s unemp    realgdp openc kaopen  interest gov_left1 vturn   i.majoritarian*agc   ,pair       corr(psar1)  


*** TABLE 5

gen efeligc=igc*efelth
gen igcmajoritarian=igc*majoritarian
xi: xtpcse socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn efelth igc efeligc ,pair       corr(psar1)  
xi: xtpcse socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn majoritarian igc igcmajoritarian  ,pair       corr(psar1) 
   
xi: xtpcse sstran  unemp    realgdp openc kaopen  interest gov_left1 vturn efelth igc efeligc  ,pair       corr(psar1)  
xi: xtpcse  sstran  unemp    realgdp openc kaopen  interest gov_left1 vturn majoritarian igc  igcmajoritarian  ,pair       corr(psar1)

****TABLE 6

gen agcmajoritarian=agc*majoritarian      
xi: jackknife: xtpcse socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc  ,pair       corr(psar1)
xi: jackknife: xtpcse socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn i.majoritarian*agc   ,pair       corr(psar1)  

 xi:  xtpcse socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc if country!="Italy"   ,pair       corr(psar1)  
xi:  xtpcse socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn i.majoritarian*agc    if country!="Italy"  ,pair       corr(psar1)  

xi: ivreg2  socexp_t   unemp    realgdp openc kaopen  interest gov_left1 vturn  agc efelth efelth_agc (efelth efelth_agc= yearele  )
xi:  ivreg2  socexp_t   unemp    realgdp openc kaopen  interest gov_left1 vturn  majoritarian agc agcmajorita (majoritarian agcmajoritarian= yearele)

xi: xtdpdsys socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn     agc efelth efelth_agc 
xi: xtdpdsys socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn  i.majoritarian*agc 

xi: xtdpdsys d.socexp_t l.socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn     agc efelth efelth_agc
xi: xtdpdsys d.socexp_t l.socexp_t unemp    realgdp openc kaopen  interest gov_left1 vturn   i.majoritarian*agc 
   
xi: xtfevd socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn efelth agc efelth_agc, invariant ( efelth efelth_agc )  ar1
xi: xtfevd socexp_t  unemp    realgdp openc kaopen  interest gov_left1 vturn majoritarian agc agcmajo , invariant (majo agcmajo  )  ar1



