*Table 4. Results of rank ordered estimations: Domestic v. Global Items

rologit rank2 dom domproximity_PSOE if treatment==1 & missingranks==0 & PPorPSOE==1, group(resp_id)
rologit rank2 dom domproximity_PSOE domtreat2 PSOEdomtreat2 domtreat3 PSOEdomtreat3 domtreat4 PSOEdomtreat4 domtreat5 PSOEdomtreat5 domtreat6 PSOEdomtreat6 domtreat7 PSOEdomtreat7 if missingranks==0 & PPorPSOE==1, group(resp_id)
rologit rank2 dom domideology_lvr domtreat2 Ideo_ldomtreat2 domtreat3 Ideo_ldomtreat3 domtreat4 Ideo_ldomtreat4 domtreat5 Ideo_ldomtreat5 domtreat6 Ideo_ldomtreat6 domtreat7 Ideo_ldomtreat7 if missingranks==0, group(resp_id)

*Table 5. Results of rank ordered estimations. Equation 2.

rologit rank2 gov govproximity_PSOE ban banproximity_PSOE eur eurproximity_PSOE for forproximity_PSOE lab labproximity_PSOE  ///
govtreat2 PSOEgovtreat2 bantreat2 PSOEbantreat2 eurtreat2 PSOEeurtreat2 fortreat2 PSOEfortreat2 labtreat2 PSOElabtreat2 ///
govtreat3 PSOEgovtreat3 bantreat3 PSOEbantreat3 eurtreat3 PSOEeurtreat3 fortreat3 PSOEfortreat3 labtreat3 PSOElabtreat3 ///
govtreat4 PSOEgovtreat4 bantreat4 PSOEbantreat4 eurtreat4 PSOEeurtreat4 fortreat4 PSOEfortreat4 labtreat4 PSOElabtreat4 ///
govtreat5 PSOEgovtreat5 bantreat5 PSOEbantreat5 eurtreat5 PSOEeurtreat5 fortreat5 PSOEfortreat5 labtreat5 PSOElabtreat5 ///
govtreat6 PSOEgovtreat6 bantreat6 PSOEbantreat6 eurtreat6 PSOEeurtreat6 fortreat6 PSOEfortreat6 labtreat6 PSOElabtreat6 ///
govtreat7 PSOEgovtreat7 bantreat7 PSOEbantreat7 eurtreat7 PSOEeurtreat7 fortreat7 PSOEfortreat7 labtreat7 PSOElabtreat7 /// 
if missingranks==0 & PPorPSOE==1, group(resp_id)

*Table 6. Effect of treatments on blame of individual items by political ideology

rologit rank2 gov govproximity_lef ban banproximity_lef eur eurproximity_lef for forproximity_lef lab labproximity_lef  ///
govtreat2 lef_govtreat2 bantreat2 lef_bantreat2 eurtreat2 lef_eurtreat2 fortreat2 lef_fortreat2 labtreat2 lef_labtreat2 ///
govtreat3 lef_govtreat3 bantreat3 lef_bantreat3 eurtreat3 lef_eurtreat3 fortreat3 lef_fortreat3 labtreat3 lef_labtreat3 ///
govtreat4 lef_govtreat4 bantreat4 lef_bantreat4 eurtreat4 lef_eurtreat4 fortreat4 lef_fortreat4 labtreat4 lef_labtreat4 ///
govtreat5 lef_govtreat5 bantreat5 lef_bantreat5 eurtreat5 lef_eurtreat5 fortreat5 lef_fortreat5 labtreat5 lef_labtreat5 ///
govtreat6 lef_govtreat6 bantreat6 lef_bantreat6 eurtreat6 lef_eurtreat6 fortreat6 lef_fortreat6 labtreat6 lef_labtreat6 ///
govtreat7 lef_govtreat7 bantreat7 lef_bantreat7 eurtreat7 lef_eurtreat7 fortreat7 lef_fortreat7 labtreat7 lef_labtreat7 /// 
if missingranks==0 , group(resp_id)
