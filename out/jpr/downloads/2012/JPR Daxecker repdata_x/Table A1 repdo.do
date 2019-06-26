set more off
*Table A2, Additional Robustness Tests*
*Models 1-5 without matching*
*Alternative measure of violence, using actual number of pre-election violent events*
nbreg  postnum prenum  observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln , robust
*Alternative measure of violence, using violence in previous election*
nbreg  postnum previousviolence observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln , robust
*Without North-African countries*
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln if nonarab==1, robust
*Without Kenyan elections*
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln if postnum!=481 , robust
*Number of observer organizations*
nbreg  postnum preelec observnum seriousfraud   obsnum_serfraud ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln , robust


*Models 6-10, Table A1, Models with matching*
*Match on variables that influence expectations of violence in elections*
cem firstelec polity2lag(#3)  previousviolence previousfraud stablag_ln(#3) gdpcaplag_ln(#5), treatment(observed)
*Run models with matching weights*
*Number of violent events*
nbreg  postnum prenum  observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln [iweight=cem_weights], robust
*Alternative measure of violence, using violence in previous election*
nbreg  postnum previousviolence observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln [iweight=cem_weights], robust
*Without North-African countries*
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln if nonarab==1 [iweight=cem_weights], robust
*Without Kenyan elections*
nbreg  postnum preelec observed seriousfraud  obs_serfraud  ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln if postnum!=481 [iweight=cem_weights], robust
*Number of observer organizations*
nbreg  postnum preelec observnum seriousfraud   obsnum_serfraud ethfrac goveffectlag polity2lag stablag_ln gdpcaplag_ln pop_ln [iweight=cem_weights], robust
