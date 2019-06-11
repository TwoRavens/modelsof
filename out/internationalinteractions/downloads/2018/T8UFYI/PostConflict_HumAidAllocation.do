********************************
*POST-CONFLICT RESULTS: Table 3*
********************************

*Model 1:
tobit totalaidlog gdpcap infst lifee logdead logridp, ll(0)
*Model 2:
tobit totalaidlog oil p5_col p5_contig p5_affinI gurrlag5, ll(0)
*Model 3:
tobit totalaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5, ll(0) 
*Model 4:
tobit totalaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5 if pcw==0, ll(0) 
*Model 5:
tobit totalaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5 if pcw==1, ll(0) 



********************************
*POST-CONFLICT RESULTS: Table 4*
********************************
*Model 1:
tobit dacaidlog gdpcap infst lifee logdead logridp, ll(0)
*Model 2:
tobit multiaidlog gdpcap infst lifee logdead logridp, ll(0)
*Model 3: 
tobit dacaidlog oil p5_col p5_contig p5_affinI gurrlag5, ll(0)
*Model 4:
tobit multiaidlog oil p5_col p5_contig p5_affinI gurrlag5, ll(0)
*Model 5:
tobit dacaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5, ll(0)
*Model 6:
tobit multiaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5, ll(0)



*******************
*APPENDIX TABLE A4*
*******************
tobit totalaidlog scaled_gdpcap scaled_infst scaled_lifee scaled_logdead scaled_logridp scaled_oil scaled_p5_col scaled_p5_contig scaled_p5_affinI scaled_gurrlag5, ll(0)  

test scaled_gdpcap = scaled_infst
test scaled_gdpcap = scaled_lifee
test scaled_gdpcap = scaled_logdead
test scaled_gdpcap = scaled_logridp
test scaled_gdpcap = scaled_oil
test scaled_gdpcap = scaled_p5_col
test scaled_gdpcap = scaled_p5_contig
test scaled_gdpcap = scaled_p5_affinI
test scaled_gdpcap = scaled_gurrlag5

test scaled_infst = scaled_lifee
test scaled_infst = scaled_logdead
test scaled_infst = scaled_logridp
test scaled_infst = scaled_oil
test scaled_infst = scaled_p5_col
test scaled_infst = scaled_p5_contig
test scaled_infst = scaled_p5_affinI
test scaled_infst = scaled_gurrlag5

test scaled_lifee = scaled_logdead
test scaled_lifee = scaled_logridp
test scaled_lifee = scaled_oil
test scaled_lifee = scaled_p5_col
test scaled_lifee = scaled_p5_contig
test scaled_lifee = scaled_p5_affinI
test scaled_lifee = scaled_gurrlag5

test scaled_logdead = scaled_logridp
test scaled_logdead = scaled_oil
test scaled_logdead = scaled_p5_col
test scaled_logdead = scaled_p5_contig
test scaled_logdead = scaled_p5_affinI
test scaled_logdead = scaled_gurrlag5
 
test scaled_logridp = scaled_oil
test scaled_logridp = scaled_p5_col
test scaled_logridp = scaled_p5_contig
test scaled_logridp = scaled_p5_affinI
test scaled_logridp = scaled_gurrlag5
  
test scaled_oil = scaled_p5_col
test scaled_oil = scaled_p5_contig
test scaled_oil = scaled_p5_affinI
test scaled_oil = scaled_gurrlag5

test scaled_p5_col = scaled_p5_contig
test scaled_p5_col = scaled_p5_affinI
test scaled_p5_col = scaled_gurrlag5

test scaled_p5_contig = scaled_p5_affinI
test scaled_p5_contig = scaled_gurrlag5

test scaled_p5_affinI = scaled_gurrlag5



*******************
*APPENDIX TABLE A5*
*******************

*Model 1:
regress totalaidlog gdpcap infst lifee logdead logridp, robust
*Model 2:
regress totalaidlog oil p5_col p5_contig p5_affinI gurrlag5, robust
*Model 3:
regress totalaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5, robust



*******************
*APPENDIX TABLE A6*
*******************

*Model 1: 
tobit totalaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5 time, ll(0) 
*Model 2: 
tobit totalaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5 time if pcw==0, ll(0) 
*Model 3: 
tobit totalaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5 time if pcw==1, ll(0) 
*Model 4: 
tobit dacaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5 time, ll(0)
*Model 5: 
tobit multiaidlog gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5 time, ll(0)



*******************
*APPENDIX TABLE A7*
*******************

*Model 1: 
tobit totalaidlog time_gdpcap time_infst time_lifee time_logdead time_logridp time_oil time_p5_col time_p5_contig time_p5_affinI time_gurrlag5 time gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5, ll(0) 
*Model 2:
tobit totalaidlog time_gdpcap time_infst time_lifee time_logdead time_logridp time_oil time_p5_col time_p5_contig time_p5_affinI time_gurrlag5 time gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5 if pcw==0, ll(0) 
*Model 3: 
tobit totalaidlog time_gdpcap time_infst time_lifee time_logdead time_logridp time_oil time_p5_col time_p5_contig time_p5_affinI time_gurrlag5 time gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5 if pcw==1, ll(0) 
*Model 4: 
tobit dacaidlog time_gdpcap time_infst time_lifee time_logdead time_logridp time_oil time_p5_col time_p5_contig time_p5_affinI time_gurrlag5 time gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5, ll(0)
*Model 5: 
tobit multiaidlog time_gdpcap time_infst time_lifee time_logdead time_logridp time_oil time_p5_col time_p5_contig time_p5_affinI time_gurrlag5 time gdpcap infst lifee logdead logridp oil p5_col p5_contig p5_affinI gurrlag5, ll(0)



******************************************************************
*Figure 2: Humanitarian Aid & Indicators of ÒNeed Ò Post-Conflict*
******************************************************************

tw sc totalaidlog logdead || lfit totalaidlog logdead, name(dead)
tw sc totalaidlog gdpcap || lfit totalaidlog gdpcap, name(gdpcap)
tw sc totalaidlog infst || lfit totalaidlog infst, name(infst)
tw sc totalaidlog logridp || lfit totalaidlog logridp, name(logridp)
graph combine dead gdpcap infst logridp


