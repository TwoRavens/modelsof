set memory 50m
/***STATISTICAL RESULTS AND THE GRAPHICAL ILLUSTRATION REPORTED IN THE MANUSCRIPT
HAVE BEEN OBTAINED USING THE FOLLOWING COMMANDS:***/

/*SURVIVAL ANALYSIS OF KEY DETERMINANTS OF TERRITORIAL AUTONOMY FORMATION
(RESTRICTED 'ART' MODEL, TABLE II)*/
streg autprotestdum autrebeldum indprotestdumpurged indrebeldum mixed ///
grp_cap_per grp_pop_per conregmaj, cluster(country_name) distribution(w)

/*SURVIVAL ANALYSIS OF DETERMINANTS OF TERRITORIAL AUTONOMY FORMATION 
(COMPLETE MODEL, TABLE III)*/
streg autprotestdum autrebeldum indprotestdumpurged indrebeldum grp_cap_per grp_pop_per ///
conregmaj statemed orgmed polity gdpfear age numgrps mixed resource2 pastautonomy ///
pastprotstrategy pastrebstrategy, cluster(country_name) distribution(w)

/*SEEMINGLY UNRELATED BIVARIATE PROBIT OF 
DETERMINANTS OF TERRITORIAL AUTONOMY FORMATION (TABLE IV)*/
biprobit (autonomy=autprotestdum indprotestdum autrebeldum indrebeldum grp_cap_per ///
grp_pop_per mixed conregmaj statemed orgmed polity gdpfear age numgrps mixed resource2 ///
pastautonomy pastprotstrategy pastrebstrategy) (tactics1=grp_cap_per grp_pop_per conregmaj ///
statemed orgmed polity gdpfear age numgrps resource2 pastautonomy pastprotstrategy ///
pastrebstrategy), cluster(country_name)

/*CALCULATING PROBABILITIES AND MARGINAL EFFECTS OF PEACEFUL AUTONOMY DEMANDS ///
AND VIOLENT AUTONOMY DEMANDS*/
mfx compute, eqlist(autonomy) at (mean autprotestdum=1	indprotestdum=0	///
autrebeldum=0	indrebeldum=0	mixed=0 conregmaj=0	statemed=0	orgmed=0	///
resource2=0	pastautonomy=0	pastprotstrategy=1	pastrebstrategy=1) ///
predict(pmarg1) nonlinear nose

mfx compute, eqlist(autonomy) at (mean autprotestdum=0	indprotestdum=0	///
autrebeldum=1	indrebeldum=0	mixed=0 conregmaj=0	statemed=0	orgmed=0	///
resource2=0	pastautonomy=0	pastprotstrategy=1	pastrebstrategy=1) ///
predict(pmarg1) nonlinear nose

/*CALCULATING BASELINE PROBABILITIES*/
mfx compute, eqlist(autonomy) at (mean autprotestdum=0	indprotestdum=0	///
autrebeldum=0	indrebeldum=0	mixed=0 conregmaj=0	statemed=0	orgmed=0	///
resource2=0	pastautonomy=0	pastprotstrategy=1	pastrebstrategy=1) ///
predict(pmarg1) nonlinear nose
