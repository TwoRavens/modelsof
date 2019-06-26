cd "/Users/ShomMazumder/Google Drive/Research/PTA Centrality and Conflict/Datasets/" /*change working directory to your own*/

log using monadic, text

use "monadic.dta", clear

eststo clear

/*Check possible causal mechanisms*/

**Causal Mechanism 1: Information Revelation**
quietly eststo inf: reg D.HRV_1 l.HRV_1 D.idealpoint l.idealpoint D.PTACent l.PTACent D.democracy_1 l.democracy_1 D.PTACentDemoc l.PTACentDemoc D.oil_1 l.oil_1 D.Independence_1 l.Independence_1 D.rgdp l.rgdp D.Economic_1 l.Economic_1 D.civilwar_1 l.civilwar_1 D.s_lead_1 l.s_lead_1, cluster(ccode) robust

**Causal Mechanism 2: Liberal International Order**
quietly eststo lib: reg D.idealpoint l.idealpoint D.PTACent l.PTACent D.democracy_1 l.democracy_1 D.PTACentDemoc l.PTACentDemoc D.HRV_1 l.HRV_1 D.oil_1 l.oil_1 D.Independence_1 l.Independence_1 D.rgdp l.rgdp D.Economic_1 l.Economic_1 D.civilwar_1 l.civilwar_1 D.s_lead_1 l.s_lead_1, cluster(ccode) robust

**Causal Mechanism 3: Capitalist Peace**
quietly eststo cap: reg D.kaopen l.kaopen D.idealpoint l.idealpoint D.HRV_1 l.HRV_1 D.PTACent l.PTACent D.democracy_1 l.democracy_1 D.PTACentDemoc l.PTACentDemoc D.oil_1 l.oil_1 D.Independence_1 l.Independence_1 D.rgdp l.rgdp D.Economic_1 l.Economic_1 D.civilwar_1 l.civilwar_1 D.s_lead_1 l.s_lead_1, cluster(ccode) robust

esttab inf lib cap using "causalMech.tex", replace tex se label title(Potential Causal Mechanisms) ///
mtitles("Model 1: DV=HRV Transparency Index" "Model 2: DV=Ideal Point" "Model 3: DV=Chin-Ito Capital Account Index" "Model 4: Full Specification") ///
addnotes("Models estimated using a dynamic error correction model. Standard errors adjust for heteroskedasticity and are clustered by country.")

/*Check for correlation between PTA centrality and democracy*/
eststo clear

**Bivariate correlation**
quietly eststo base: reg PTACent l.Polity_1, cluster(ccode) robust

**Bivariate with country and year fixed effects**
quietly eststo basefe: xtreg PTACent l.Polity_1 _yr*, fe cluster(ccode) robust

**Bivariate correlation**
quietly eststo full: reg PTACent l.Polity_1 l.oil_1 l.Independence_1 l.rgdp l.Economic_1 l.civilwar_1 l.s_lead_1, cluster(ccode) robust

**Bivariate correlation**
quietly eststo fullfe: xtreg PTACent l.Polity_1 l.oil_1 l.Independence_1 l.rgdp l.Economic_1 l.civilwar_1 l.s_lead_1 _yr*, fe cluster(ccode) robust

esttab base basefe full fullfe using "PTACentDemocracyCorr.tex", replace tex se label title(Association between PTA Centrality and Democracy) ///
mtitles("Model 1: Bivariate" "Model 2: Bivariate FE" "Model 3: Full" "Model 4: Full FE") ///
addnotes("Models estimated using OLS. Standard errors adjust for heteroskedasticity and are clustered by country.")

log close

