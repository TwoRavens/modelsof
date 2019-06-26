***Cook & Savun 2016 Online Appendix Replication Do File** 

set more off 
use "C:\Users\sjcook\Dropbox\JPR_MilitaryRegime\MilitaryRegimes_CS_JPR.dta"
tsset ccode year 

//Figure 1 

logit onset_clean i.gwf_new_demo5 l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
predict probhat_i

logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
predict probhat_ii

roccomp onset_clean probhat_i probhat_ii if gwf_new_demo5==1, graph summary


//Table 2 

tsset ccode year 

logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=862, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=995, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=1012, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=1329, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=1918, cluster (ccode)

logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=2487, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=2735, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=2866, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=3010, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=3014, cluster (ccode)

logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=3018, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=3475, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=3675, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=3676, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=3982, cluster (ccode)

logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=4155, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=4344, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=5109, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=5673, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=7019, cluster (ccode)

logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=7035, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=7107, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=7269, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop peaceyrs _spline* if gwf_demo_plus==1 & _n!=7312, cluster (ccode)

//Table 3 

logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop l.xconst peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)
logit onset_clean i.new_demo5_mil i.new_demo5_permon i.new_demo5_par l.ln_gdp l.ln_pop l.xpolity rolling_conflict rolling_demo peaceyrs _spline* if gwf_demo_plus==1, cluster (ccode)



