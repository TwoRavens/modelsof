***Tongfi Kim and Jennifer Sciubba. "The Effect of Age Structure on the Abrogation of Military Alliances"
*Stata version 12.0

**Table 2

*Model 1

logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

*Model 2 

logit violate ythblgap wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

*Model 3. 

logit violate ythblgap capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry treaty milinst time timesquare timecube, robust cluster (atopidphase)

*Model 4
logit violate ythblgap capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry treaty milinst  gdpcapppp1000 mideast_a yr_ind colonial_tie time timesquare timecube, robust cluster (atopidphase)

*Model 5
logit violate ythblgap capcheither20 regchangeeither chTEAltorBmt alformA asymmetry  treaty milinst  time timesquare timecube if removed_any==1, robust cluster (atopidphase)


**Figure 3  
*Probabilities were calculated with CLARIFY (King, Tomz, and Wittenberg 2000). All other variables were set at the median values.

estsimp logit violate ythblgap capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry treaty milinst  gdpcapppp1000 mideast_a yr_ind colonial_tie time timesquare timecube, robust cluster (atopidphase)
setx median

