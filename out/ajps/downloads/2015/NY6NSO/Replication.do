***** REPLICATION OF RESULTS USING SUPREME COURT LIBERALISM DATA - ALL DECISIONS *****
*Open "SupremeCourtLiberalism1953-2008TermsAllDecisions.dta"

*To replicate Figure 1A
twoway (scatter pctlib term, c(l) lpattern(dash) lcolor(black) mcolor(black)) (lowess pctlib term, bw(.2) lcolor(black)), xlabel(1953(2)2008, angle(vertical)) ylabel(0(10)100) legend(off) xsca(titlegap(1)) ysca(titlegap(1)) ytitle("Percentage of Liberal Decisions") xtitle("Term of the Court") title("A.  All Decisions", size(4)) xline(1969 1986 2005, lcolor(black)) yline(50, lcolor(black))


***** REPLICATION OF RESULTS USING SUPREME COURT LIBERALISM DATA - SALIENT DECISIONS *****
*Open "SupremeCourtLiberalism1953-2008TermsSalientDecisions.dta"

*To replicate Figure 1B
twoway (scatter pctlib_sal term, c(l) lpattern(dash) lcolor(black) mcolor(black)) (lowess pctlib_sal term, bw(.2) lcolor(black)), xlabel(1953(2)2008, angle(vertical)) ylabel(0(10)100) legend(off) xsca(titlegap(1)) ysca(titlegap(1)) ytitle("Percentage of Liberal Decisions") xtitle("Term of the Court") title("B.  Salient Decisions", size(4)) xline(1969 1986 2005, lcolor(black)) yline(50, lcolor(black))


***** REPLICATION OF RESULTS USING 2005 SUPREME COURT ANNENBERG SURVEY - MASS PUBLIC *****
*Open "2005AnnenbergSC-MassPublic.dta"

*Replicate Table 2
tab PerceivedSCIdeology Ideology3pt, col

*To replicate Figure 2A (calculating group means of legitimacy for the three groups)
** Strong Agreement
su  SupremeCourtLegitimacy if IdeoDisagree3pt==0
** Moderate Disagreement
su  SupremeCourtLegitimacy if IdeoDisagree3pt==.5
**Strong Disagreement
su  SupremeCourtLegitimacy if IdeoDisagree3pt==1

*To replicate Figure 2B (calculating group means of legitimacy for the four groups)
** Strong Agreement
su SupremeCourtLegitimacy if IdeoDisagree4pt==1
** Tacit Agreement
su SupremeCourtLegitimacy if IdeoDisagree4pt==2
** Moderate Disagreement
su SupremeCourtLegitimacy if IdeoDisagree4pt==3
** Strong Disagreement
su SupremeCourtLegitimacy if IdeoDisagree4pt==4

*Replicate Table 3
reg SupremeCourtLegitimacy StrongDisagreement ModerateDisagreement TacitAgreement Republican Independent PoliticalTrust AwarenessofCourt DiffMediaExposure Age Hispanic Black Female Education

*Replicate Table E1 from Supporting Information, which Figure 4 is based on
reg SupremeCourtLegitimacy Ideology5pt Ideology5ptSquared PerceptionCourtLiberal PerceptionCourtConservative PercCtLibXIdeology5pt PercCtLibXIdeology5ptSqd PercCtConsXIdeology5pt PercCtConsXIdeology5ptSqd Republican Independent PoliticalTrust AwarenessofCourt DiffMediaExposure Age Hispanic Black Female Education

*Replicate Table C2 in Supporting Information, Section C
oprobit Legit_doaway StrongDisagreement ModerateDisagreement TacitAgreement Republican Independent PoliticalTrust AwarenessofCourt DiffMediaExposure Age Hispanic Black Female Education

*Replicate Table D1 in Supporting Information, Section D
reg SupremeCourtLegitimacy StrongDisagreement ModerateDisagreement TacitAgreement AwarenessofCourt StrongDisXAwareness ModerateDisXAwareness TacitDisXAwareness Republican Independent PoliticalTrust DiffMediaExposure Age Hispanic Black Female Education


***** REPLICATION OF RESULTS USING SURVEY EXPERIMENT *****
*Open "SurveyExperiment.dta"

*Replicate Survey Experiment Results (on which Figure 4 is based); Table C3 in Supporting Information, Section C
reg SupremeCourtLegitimacy PolicyPreference TreatmentDecisionIdeo PolicyPrefXTreatmentDecIdeo Age Female Black Hispanic Education, robust


***** REPLICATION OF RESULTS USING 2005 Annenberg Supreme Court Study - Lawyer Sample (Supporting Information, Section C *****
*Open "2005AnnenbergSC-Lawers.dta"

*Replicate Table C1 in Supporting Information, Section C
reg SupremeCourtLegitimacy StrongDisagreement ModerateDisagreement TacitAgreement PoliticalTrust Age Hispanic Black