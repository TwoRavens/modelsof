sort dyad year 
xtset dyad year

*estimating model 1*
xtgee domestic_disp l.interdep l.dem_low l.relcap_alt l.alliance_agg l.majpow1 l.majpow2 distance , force family(binomial) link(probit) corr(ar1) vce(robust)

*estimating model 2 and generating figure 1, panel a*
xtgee affect_policies l.interdep l.dem_low l.relcap_alt l.alliance_agg  l.majpow1 l.majpow2 distance , force family(binomial) link(probit) corr(ar1) vce(robust)
margins, atmeans at(l.alliance_agg=0 l.majpow1=0 l.majpow2=0 c.l.interdep=(-29(5)1)) force
marginsplot, recast(line) recastci(rarea)

*estimating model 3*
xtgee social_int l.interdep l.dem_low l.relcap_alt l.alliance_agg  l.majpow1 l.majpow2 distance , force family(binomial) link(probit) corr(ar1) vce(robust)

*estimating model 4 and generating figure1, panel b*
xtgee economic l.interdep l.dem_low l.relcap_alt l.alliance_agg l.majpow1 l.majpow2 distance , force family(binomial) link(probit) corr(ar1) vce(robust)
margins, atmeans at(l.alliance_agg=0 l.majpow1=0 l.majpow2=0 c.l.interdep=(-29(5)1)) force
marginsplot, recast(line) recastci(rarea)

*estimating model 5 and generating figure1, panel c*
xtgee humanitarian l.interdep l.dem_low l.relcap_alt l.alliance_agg l.majpow1 l.majpow2 distance, force family(binomial) link(probit) corr(ar1) vce(robust)
margins, atmeans at(l.alliance_agg=0 l.majpow1=0 l.majpow2=0 c.l.interdep=(-29(5)1)) force
marginsplot, recast(line) recastci(rarea)

*estimating model 6 and generating figure1, panel d*
xtgee territorial l.interdep l.dem_low l.relcap_alt l.alliance_agg l.majpow1 l.majpow2 distance, force family(binomial) link(probit) corr(ar1) vce(robust)
margins, atmeans at(l.alliance_agg=0 l.majpow1=0 l.majpow2=0 c.l.interdep=(-29(5)1)) force
marginsplot, recast(line) recastci(rarea)

*estimating model 7 and generating figure1, panel e*
xtgee military_diplomatic l.interdep l.dem_low l.relcap_alt l.alliance_agg  l.majpow1 l.majpow2 distance , force family(binomial) link(probit) corr(ar1) vce(robust)
margins, atmeans at(l.alliance_agg=0 l.majpow1=0 l.majpow2=0 c.l.interdep=(-29(5)1)) force
marginsplot, recast(line) recastci(rarea)

