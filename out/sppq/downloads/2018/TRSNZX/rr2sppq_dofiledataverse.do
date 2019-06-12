* Opening file *
pwd
use 2012SPAE_sppqdataverse.dta, clear

**** NOTE: Table 1 is a summary table of the coefficients on cross-level interactions in models used to create Tables A-2 through A-11	
	
* Table A-1 * 	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d1
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i1	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r1	
	
esttab d1 i1 r1 using table1.rtf, b(%3.2f) se(%3.2f) one  scalars(k_res N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)

* Variation Explained by Level-1 in Table A-2*
* Note: Calculated using the random-effects and residual-error parameter estimates as variances.
* % explained by level-1  = var(residual)/(var(_cons) + var(residual) 
* estimates fore d1: 
display .5904871 /(.5904871 + .0066057)
* estimates for i1:  		
display .8938333/(.8938333 + .0372403)
*estimates for r1: 
display .9807522/(.9807522 + .0360415)		
* Table A-2 *
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.preelection  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d8

margins, vsquish at(preelection=(0(10)40) newsint1nodk=(1 4) ///
	(mean) _all gender_b12=0 q12_1b1=1 vlawstrict=2 ideo51catwns=2 battle12=0 race6group=1)
marginsplot, recastci(rarea) ciopts(color(*.3)) legend(on ring(0) col(1) position(11)) ///
	title("Democrats", size(large)) ///
	ytitle("Voter Fraud Is More Common", size(medsmall)) ylabel(1(1)3.5) ///
	xtitle("Voter Fraud Stories (#)" " ", size(medsmall)) ///
	note("", size(vsmall)) ///
	name(rr_vfstorydem, replace)	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.preelection  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i8	
	
margins, vsquish at(preelection=(0(10)40) newsint1nodk=(1 4) ///
	(mean) _all gender_b12=0 q12_1b1=1 vlawstrict=2 ideo51catwns=2 battle12=0 race6group=1)
marginsplot, recastci(rarea) ciopts(color(*.3)) legend(on ring(0) col(1) position(11)) ///
	title("Independents", size(large)) ///
	ytitle(" ", size(medsmall)) ylabel(1(1)3.5) ///
	xtitle("Voter Fraud Stories (#)", size(medsmall)) ///
	note(" ", size(vsmall)) ///
	name(rr_vfstoryind, replace)	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.preelection  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r8		
		
margins, vsquish at(preelection=(0(10)40) newsint1nodk=(1 4) ///
	(mean) _all gender_b12=0 q12_1b1=1 vlawstrict=2 ideo51catwns=2 battle12=0 race6group=1)
marginsplot, recastci(rarea) ciopts(color(*.3)) legend(on ring(0) col(1) position(11)) ///
	title("Republicans", size(large)) ///
	ytitle(" ", size(medsmall)) ylabel(1(1)3.5) ///
	xtitle("Voter Fraud Stories (#)", size(medsmall)) ///
	note(" ", size(vsmall)) ///
	name(rr_vfstoryrepub, replace)	
	
esttab d8 i8 r8 using table8.rtf, b(%3.2f) se(%3.2f) one  scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)
		
* Figure 1 is based on Table A-2 *	
graph combine rr_vfstorydem rr_vfstoryind rr_vfstoryrepub, row(1) col(3) scheme(lean2) ///
		name(rr_vfstorycombine, replace)
* Note: Opacity of confidence intervals and line type are adjusted manually for article *		
		
* Table A-3 *
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#i.battle12  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d7
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#i.battle12  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i7	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#i.battle12  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r7		
		
esttab d7 i7 r7 using table7.rtf, b(%3.2f) se(%3.2f) one scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)
		
* Table A-4 *
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.undoc9010_nih  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d9
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.undoc9010_nih  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i9	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.undoc9010_nih  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r9		
		
esttab d9 i9 r9 using table9.rtf, b(%3.2f) se(%3.2f) one scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)

* Table A-5 *		
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.stgr_black9012  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d6
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.stgr_black9012  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i6	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.stgr_black9012  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r6		
		
esttab d6 i6 r6 using table6.rtf, b(%3.2f) se(%3.2f) one scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)								

* Table A-6 *
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.vlawstrict ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d5
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.vlawstrict ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i5	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.vlawstrict ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r5		
		
esttab d5 i5 r5 using table5.rtf, b(%3.2f) se(%3.2f) one scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)

* Table A-7 *		
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.perc12_repub1 ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d4
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.perc12_repub1 ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i4	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.perc12_repub1 ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r4		

* Figure 2 is based on Table A-7
margins, vsquish at(perc12_repub1=(0(.2)1) newsint1nodk=(1 4) ///
	(mean) _all gender_b12=0 q12_1b1=1 vlawstrict=2 ideo51catwns=2 battle12=0 race6group=1)
marginsplot, scheme(lean1) recast(line) recastci(rarea) legend(pos(6) size(small)) ///
	title("Republicans", size(large)) ///
	ytitle(" ", size(medsmall)) ///
	xtitle("Voter Fraud Stories (#)", size(medsmall)) ///
	note(" ", size(vsmall)) ///
	name(rr_vflegisrepub, replace)	
		
esttab d4 i4 r4 using table4.rtf, b(%3.2f) se(%3.2f) one scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)

* Table A-8 *
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.iEPI12 ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d3
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.iEPI12 ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i3	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.iEPI12 ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r3		
		
esttab d3 i3 r3 using table3.rtf, b(%3.2f) se(%3.2f) one scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)
		
* Table A-9 *		
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.cases ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d2
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.cases ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i2	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.cases ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.undoc9010_nih c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r2		
		
esttab d2 i2 r2 using table2.rtf, b(%3.2f) se(%3.2f) one scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)

* Table A-10 *
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.stgr_fbnc9012  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.stgr_fbnc9012 c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d10
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.stgr_fbnc9012  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.stgr_fbnc9012 c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i10	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.stgr_fbnc9012  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.stgr_fbnc9012 c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r10		
		
esttab d10 i10 r10 using table10.rtf, b(%3.2f) se(%3.2f) one scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)

* Table A-11 *		
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.stgr_lat9012  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.stgr_lat9012 c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==1 || statefips:
estimates store d11
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.stgr_lat9012  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.stgr_lat9012 c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==2 || statefips:	
estimates store i11	
	
mixed vfscale_spae12notamperndk c.ideo51catwns c.newsint1nodk c.newsint1nodk#c.stgr_lat9012  ///
	i.q12_1b1  ///
	c.educ c.age i.gender_b12 b1.race6group ///
	i.battle12 c.preelection c.stgr_lat9012 c.stgr_black9012 c.vlawstrict c.perc12_repub1 ///
	c.iEPI12 c.cases ///
	[pweight = weight] if pid71catwns==3 || statefips:		
estimates store r11		
		
esttab d11 i11 r11 using table11.rtf, b(%3.2f) se(%3.2f) one scalars(N_clust chi2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) staraux noomitted nogaps nobase compress replace ///
		coeflabels(ideo51catwns Ideology  c.newsint1nodk#c.cases "Pol. Interest X Alleged Voter Fraud Cases" c.newsint1nodk#i.battle12 "Pol. Interest X Battleground State" c.newsint1nodk#c.preelection "Pol. Interest X Media Coverage of Voter Fraud" ///
		c.newsint1nodk#c.undoc9010_nih "Undoc. Pop. Growth X Pol. Interest" c.newsint1nodk#c.stgr_black9012 "Pol. Interest X Black Pop. Growth" c.newsint1nodk#c.vlawstrict "Pol. Interest X Voter ID Laws" ///
		c.newsint1nodk#c.perc12_repub1 "Pol. Interest X % R Legislature" c.newsint1nodk#c.iEPI12 "Pol. Interest X EPI Index" cases "Alleged Voter Fraud Cases" iEPI12 "EPI Index" ///
		undoc9010_nih "Undoc. Pop. Growth" newsint1nodk "Political Interest" ///
		1.q12_1b1 "Show ID" educ "Education" age "Age" 1.gender_b12 "Female" ///
		1.battle12 "Battleground" stgr_black9012 "Black pop." vlawstrict "Voter ID" perc12_repub1 "% R Legislature" ///
		1.demgov12 "D Gov" preelection "Voter Fraud Stories" 2.race6group Black 3.race6group Hispanic 4.race6group Asian 5.race6group "NA/ME/Other" 6.race6group Mixed)	
		
* Figure 3 
* Figure 3 is based on vfimmacrossstates.dta, in which the unit of analysis is a U.S. state

* Open file *
pwd 
use vfimmacrossstates.dta, clear

* First transform perc12_repub1 into whole percentage points; this new variable (perc12_repub1p) is used in the scatter plot below *
gen perc12_repub1p = perc12_repub1*100
	
twoway (scatter preelection perc12_repub1p, sort scheme(lean2) mcolor(black) msize(small) msymbol(circle) mlabel(stateinit) ///
	mlabsize(small) mlabcolor(black) mlabposition(3)), ytitle(Stories (#)) yline(8, lcolor(black)) xtitle ///
	(Republicans in State Legislature (%)) xline(50) xlabel(0(20)100) ///
	title("Figure 3. Local Media Coverage of Voter Fraud" "Across Partisan Control of State Legislature", size(medlarge)) ///
	name(fig3, replace)

