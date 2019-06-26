*Models 1-3, Table 1*
set more off
*No interaction*
nbreg  postnum preelec observed seriousfraud   ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln , robust
*Interaction*
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln , robust
*Without first elections*
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln if firstelec==0 , robust

*Models 4-6, Table 2, Models with matching*
*Match on variables that influence expectations of violence in elections*
cem firstelec polity2lag(#3)  previousviolence previousfraud stablag_ln(#3) gdpcaplag_ln(#5)  , treatment(observed)
*Run models with matching weights*
nbreg  postnum preelec observed seriousfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln [iweight=cem_weights] , robust
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln [iweight=cem_weights] , robust
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln if firstelec==0 [iweight=cem_weights] , robust

