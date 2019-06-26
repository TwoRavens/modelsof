***Cook & Savun 2016 Replication Do File** 

set more off 
use "C:\Users\sjcook\Dropbox\JPR_MilitaryRegime\MilitaryRegimes_CS_JPR.dta"
tsset ccode year 

//Table 1 

tab onset_clean if gwf_demo_plus ==1 & year >1945 & year<2010 

tab onset_clean if gwf_cons_dem	==1 & year >1945 & year<2010 
tab onset_clean if gwf_new_demo5 ==1 & year >1945 & year<2010 

tab onset_clean if new_demo5_mil ==1 & year >1945 & year<2010 
tab onset_clean if new_demo5_par ==1 & year >1945 & year<2010 
tab onset_clean if new_demo5_permon ==1 & year >1945 & year<2010 


//Tabel 2 

logit onset_clean gwf_new_demo5 l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
margins, dydx (new_demo5_mil l.ln_gdp l.ln_pop peaceyrs )

//Table 3 

logit onset_clean new_demo5_mil new_demo5_permon new_demo5_par l.ln_gdp l.ln_pop l.growth lmtnest1 ef1 relfrac1 peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
logit onset_clean new_demo5_mil new_demo5_permon new_demo5_par l.ln_gdp l.ln_pop l.growth lmtnest1 ef1 relfrac1 western1 eeurop1 lamerica1 ssafrica1  nafrme1 peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
logit onset_clean new_demo5_mil new_demo5_permon new_demo5_par l.ln_gdp l.ln_pop l.xpolity l.growth lmtnest1 ef1 relfrac1 western1 eeurop1 lamerica1 ssafrica1  nafrme1 peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
logit onset_clean new_demo5_mil new_demo5_permon new_demo5_par l.ln_gdp l.ln_pop l.i.pres  l.growth lmtnest1 ef1 relfrac1 western1 eeurop1 lamerica1 ssafrica1  nafrme1 peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
logit onset_clean new_demo5_mil new_demo5_permon new_demo5_par l.ln_gdp l.ln_pop short_spell  l.growth lmtnest1 ef1 relfrac1 western1 eeurop1 lamerica1 ssafrica1  nafrme1 peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
logit onset_clean i.new_demo5_mil##i.coerced_5 i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop  l.growth lmtnest1 ef1 relfrac1 western1 eeurop1 lamerica1 ssafrica1  nafrme1  peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)


//Chi-square results in Findings (paragraph 1) and fn. 18  

tab onset_clean gwf_new_demo5 if gwf_demo_plus==1, chi2 
tab onset_clean new_demo5_mil if gwf_new_demo5==1, chi2 
tab onset_clean new_demo5_mil  if gwf_demo_plus==1 & new_demo5_permon==0 & new_demo5_par ==0, chi2

//Peru counterfactual in Findings (paragraph 4) 

logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
margins, dydx (new_demo5_mil l.ln_pop peaceyrs ) at(l.ln_pop==9.8 l.ln_gdp==8.6 peaceyrs==16 _spline1==-1709.954 _spline2==-3275.815 _spline3==-2394.585)

//fn. 20 

logit onset_clean i.gwf_new_demo5 l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
predict probhat_i

logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
predict probhat_ii

roccomp onset_clean probhat_i probhat_ii if gwf_new_demo5==1, graph summary



