*******************************
*IN-CONFLICT RESULTS: Table 1*
*******************************

*Model 1:
tobit aidlog gdpcap infst lifee logdead logref2, ll(0)
*Model 2:
tobit aidlog oil p5_col p5_contig p5_affinI gurrlag5, ll(0)
*Model 3:
tobit aidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5, ll(0) 
*Model 4:
tobit aidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5 if pcw==0, ll(0) 
*Model 5:
tobit aidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5 if pcw==1, ll(0) 



*******************************
*IN-CONFLICT RESULTS: Table 2*
*******************************

*Model 1:
tobit dacaidlog gdpcap infst lifee logdead logref2, ll(0)
*Model 2:
tobit multiaidlog gdpcap infst lifee logdead logref2, ll(0)
*Model 3:
tobit dacaidlog oil p5_col p5_contig p5_affinI gurrlag5, ll(0)
*Model 4:
tobit multiaidlog oil p5_col p5_contig p5_affinI gurrlag5, ll(0)
*Model 5:
tobit dacaidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5, ll(0)
*Model 6:
tobit multiaidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5, ll(0)



*******************
*APPENDIX TABLE A2*
*******************
tobit aidlog scaled_gdpcap scaled_infst scaled_lifee scaled_logdead scaled_logref2 scaled_oil scaled_p5_col scaled_p5_contig scaled_p5_affinI scaled_gurrlag5, ll(0) 

test scaled_gdpcap = scaled_infst
test scaled_gdpcap = scaled_lifee
test scaled_gdpcap = scaled_logdead
test scaled_gdpcap = scaled_logref2
test scaled_gdpcap = scaled_oil
test scaled_gdpcap = scaled_p5_col
test scaled_gdpcap = scaled_p5_contig
test scaled_gdpcap = scaled_p5_affinI
test scaled_gdpcap = scaled_gurrlag5

test scaled_infst = scaled_lifee
test scaled_infst = scaled_logdead
test scaled_infst = scaled_logref2
test scaled_infst = scaled_oil
test scaled_infst = scaled_p5_col
test scaled_infst = scaled_p5_contig
test scaled_infst = scaled_p5_affinI
test scaled_infst = scaled_gurrlag5

test scaled_lifee = scaled_logdead
test scaled_lifee = scaled_logref2
test scaled_lifee = scaled_oil
test scaled_lifee = scaled_p5_col
test scaled_lifee = scaled_p5_contig
test scaled_lifee = scaled_p5_affinI
test scaled_lifee = scaled_gurrlag5

test scaled_logdead = scaled_logref2
test scaled_logdead = scaled_oil
test scaled_logdead = scaled_p5_col
test scaled_logdead = scaled_p5_contig
test scaled_logdead = scaled_p5_affinI
test scaled_logdead = scaled_gurrlag5
 
test scaled_logref2 = scaled_oil
test scaled_logref2 = scaled_p5_col
test scaled_logref2 = scaled_p5_contig
test scaled_logref2 = scaled_p5_affinI
test scaled_logref2 = scaled_gurrlag5
  
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
*APPENDIX TABLE A3*
*******************

*Model 1:
tobit aidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5 confyears, ll(0) 
*Model 2:
tobit aidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5 confyears if pcw==0, ll(0) 
*Model 3:
tobit aidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5 confyears if pcw==1, ll(0) 
*Model 4:
tobit dacaidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5 confyears, ll(0)
*Model 5:
tobit multiaidlog gdpcap infst lifee logdead logref2 oil p5_col p5_contig p5_affinI gurrlag5 confyears, ll(0)
