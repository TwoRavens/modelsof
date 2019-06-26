

*table 1, regression 1*

probit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln rev  dt_2     male1424,  robust

*table 1, regression 2*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln ( rev  =   rev9200  )  dt_2     male1424,  robust

*table 1, regression 3*

probit   extreme  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln rev  dt_2     male1424 ,  robust

*table 1, regression 4*

ivprobit   extreme  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev =  rev9200) dt_2     male1424 ,  robust

*table 2, regression 1*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev = rev9200) dt_2     male1424   ukcol, robust 

*table 2, regression 2*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev =  rev9200) dt_2     male1424    frenchcol, robust 

*table 2, regression 3*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev =  rev9200) dt_2     male1424     portugcol, robust 

*table 2, regression 4*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev =  rev9200) dt_2     male1424      polstat, robust 

*table 3, regression 1*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev =  rev9200) dt_2     male1424    latitude     ,  robust 

*table 3, regression 2*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev =  rev9200) dt_2     male1424     landlock     ,  robust 

*table 3, regression 3*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev = rev9200) dt_2     male1424  nbrh  ,  robust 

*table 3, regression 4*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev =  rev9200) dt_2     male1424     kkgoverneffect   ,  robust 

*table 3, regression 5*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev =  rev9200) dt_2     male1424     kkrulelaw ,  robust 

*table 3, regression 6*

ivprobit  frgst2q9907  l_rgdppc    grrgdppc  invest enrollprim governm tottradepwt inflimf lifeexp l_fertrate ethnicfract  civliber diamond confln (rev =  rev9200) dt_2     male1424      kkvoiceaccount ,  robust 



