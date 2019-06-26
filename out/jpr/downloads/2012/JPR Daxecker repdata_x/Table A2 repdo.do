set more off
*Table A3, Additional Robustness Tests*
*Removing Control variables one by one*
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln , robust
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln  , robust
nbreg  postnum preelec observed seriousfraud  obs_serfraud   goveffectlag polity2lag stablag_ln gdpcaplag_ln , robust
nbreg  postnum preelec observed seriousfraud  obs_serfraud   goveffectlag polity2lag stablag_ln  , robust
nbreg  postnum preelec observed seriousfraud  obs_serfraud  polity2lag stablag_ln  , robust
nbreg  postnum preelec observed seriousfraud  obs_serfraud  polity2lag  , robust
nbreg  postnum preelec observed seriousfraud  obs_serfraud   , robust
nbreg  postnum  observed seriousfraud  obs_serfraud  , robust

