summ dv lag_dv issue_linkage_structure agreement_importance qmv publicity voting_power lngdp foreignpolicy euro new_ms presidency parl_scrut pillarii pillariii lag_dv_alt0 lag_dv_alt1 lag_dv_alt2 lag_dv_alt3



**MODELS 1, 2 -- In EU context, Security and Defense Policy test effect of high/low politics**

**Model 1 - (using lngdp/lag_dv non-independence control)  Check for assumption of proportional odds
ologit dv lag_dv issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut
brant
omodel logit dv lag_dv issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut
**Significant test means assumption violated.  
**So run Generalized ordered logit model.  Cluster standard errors by negotiation because of non-independence of states' bargaining strategies within same negotiation.
gologit2 dv lag_dv issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
**Get Proportional Reduction Error
pre
***Get Odds Ratios for Substantive Interpretation
gologit2 dv lag_dv issue_linkage_structure agreement_importance qmv publicity lngdp foreignpolicy euro new_ms presidency parl_scrut, autofit or cluster(i_bargain)


** Model 2 - (using Shapley-Shubik Index/lag_dv non-independence control) Check for assumption of proportional odds
ologit dv lag_dv issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut
brant
omodel logit dv lag_dv issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut
**Significant test means assumption violated.  
**So run Generalized ordered logit model.  Cluster standard errors by negotiation because of non-independence of states' bargaining strategies within same negotiation.
gologit2 dv lag_dv issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
**Get Proportional Reduction Error
pre
***Get Odds Ratios for Substantive Interpretation
gologit2 dv lag_dv issue_linkage_structure agreement_importance qmv publicity voting_power foreignpolicy euro new_ms presidency parl_scrut, autofit or cluster(i_bargain)

**MODELS 3,4 -- re-runing Models 1 and 2 using EU pillar structure to test effect of high/low politics**
***omitted category is pillar I***

*MODEL 3 - with ln GDP as alternative control for power
ologit dv lag_dv issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut
brant
omodel logit dv lag_dv issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre

*MODEL 4 - with Voting_power alternative control for power
ologit dv lag_dv issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut
brant
omodel logit dv lag_dv issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre




***Effect of different alternative versions of bargaining power across different measures of Temporal Contagion
*lag_dv_alt0 uses 0-category for first phase negotiations
*lag_dv_alt1 uses 1-category for first phase negotiations
*lag_dv_alt2 uses 2-category for first phase negotiations
*lag_dv_alt3 uses 3-category for first phase negotiations


**Rerunning Model 1 with alternative lagged DV measures: (LNGDP measure of power and foreign policy measure)
**MODEL 5 - lngdp and lag_dv_alt0
omodel logit dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, pl(euro foreignpolicy presidency issue_linkage_structure new_ms lngdp) cluster(i_bargain)
pre
*MODEL 6 - lngdp and lag_dv_alt1
omodel logit dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 7 - lngdp and lag_dv_alt2
omodel logit dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 8 - lngdp and lag_dv_alt3
omodel logit dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, pl(issue_linkage_structure euro lngdp presidency foreignpolicy new_ms lag_dv_alt3) cluster(i_bargain)
pre


**Rerunning Model 2 with alternative lagged DV measures: (Voting Power measure of power and foreign policy measure)
**MODEL 9 - voting power and lag_dv_alt0
omodel logit dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 10 - voting power and lag_dv_alt1
omodel logit dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, pl(euro issue_linkage_structure presidency foreignpolicy new_ms voting_power lag_dv_alt1) cluster(i_bargain) 
pre
*MODEL 11 - voting power and lag_dv_alt2
omodel logit dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 12 - voting power and lag_dv_alt3
omodel logit dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, pl(euro issue_linkage_structure foreignpolicy presidency new_ms voting_power lag_dv_alt3) cluster(i_bargain) 
pre


**Rerunning Model 3 with alternative lagged DV measures: (LNGDP measure of power and Pillars measure)
**MODEL 13 - lngdp and lag_dv_alt0
omodel logit dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 14 - lngdp and lag_dv_alt1
omodel logit dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 15 - lngdp and lag_dv_alt2
omodel logit dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 16 - lngdp and lag_dv_alt3
omodel logit dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre


**Rerunning Model 4 with alternative lagged DV measures: (Voting Power measure of power and Pillars measure)
**MODEL 17 - voting power and lag_dv_alt0
omodel logit dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 18 - voting power and lag_dv_alt1
omodel logit dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 19 - voting power and lag_dv_alt2
omodel logit dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre
*MODEL 20 - voting power and lag_dv_alt3
omodel logit dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut
gologit2 dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, autofit cluster(i_bargain)
pre





*****MODELS 1MM THROUGH 20MM -- MULTI-LEVEL MODEL VERSIONS OF MODELS 1 - 20

**Model 1MM
gllamm dv lag_dv issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 2MM
gllamm dv lag_dv issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 3MM
gllamm dv lag_dv issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 4MM
gllamm dv lag_dv issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 5MM
gllamm dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 6MM
gllamm dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 7MM
gllamm dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 8MM
gllamm dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  lngdp foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 9MM
gllamm dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 10MM
gllamm dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 11MM
gllamm dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 12MM
gllamm dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  voting_power foreignpolicy euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 13MM
gllamm dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 14MM
gllamm dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 15MM
gllamm dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 16MM
gllamm dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  lngdp pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 17MM
gllamm dv lag_dv_alt0 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 18MM
gllamm dv lag_dv_alt1 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 19MM
gllamm dv lag_dv_alt2 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)

**Model 20MM
gllamm dv lag_dv_alt3 issue_linkage_structure agreement_importance qmv publicity  voting_power pillarii pillariii euro new_ms presidency parl_scrut, i(i_bargain) link(ologit)




***BASELINE MODELS***

**Baseline Model 1
gologit2 dv lag_dv lngdp foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 2
gologit2 dv lag_dv voting_power foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 3
gologit2 dv lag_dv lngdp pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 4
gologit2 dv lag_dv voting_power pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 5
gologit2 dv lag_dv_alt0 lngdp foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 6
gologit2 dv lag_dv_alt1 lngdp foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 7
gologit2 dv lag_dv_alt2 lngdp foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 8
gologit2 dv lag_dv_alt3 lngdp foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 9
gologit2 dv lag_dv_alt0 voting_power foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 10
gologit2 dv lag_dv_alt1 voting_power foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 11
gologit2 dv lag_dv_alt2 voting_power foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 12
gologit2 dv lag_dv_alt3 voting_power foreignpolicy euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 13
gologit2 dv lag_dv_alt0 lngdp pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 14
gologit2 dv lag_dv_alt1 lngdp pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 15
gologit2 dv lag_dv_alt2 lngdp pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 16
gologit2 dv lag_dv_alt3 lngdp pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 17
gologit2 dv lag_dv_alt0 voting_power pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 18
gologit2 dv lag_dv_alt1 voting_power pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 19
gologit2 dv lag_dv_alt2 voting_power pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)

**Baseline Model 20
gologit2 dv lag_dv_alt3 voting_power pillarii pillariii euro new_ms presidency, autofit cluster(i_bargain)


***MULTILEVEL BASELINE MODELS***

**Baseline Model 1MM
gllamm dv lag_dv lngdp foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)
**Baseline Model 2MM
gllamm dv lag_dv voting_power foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 3MM
gllamm dv lag_dv lngdp pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 4MM
gllamm dv lag_dv voting_power pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 5MM
gllamm dv lag_dv_alt0 lngdp foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 6MM
gllamm dv lag_dv_alt1 lngdp foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 7MM
gllamm dv lag_dv_alt2 lngdp foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 8MM
gllamm dv lag_dv_alt3 lngdp foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 9MM
gllamm dv lag_dv_alt0 voting_power foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 10MM
gllamm dv lag_dv_alt1 voting_power foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 11MM
gllamm dv lag_dv_alt2 voting_power foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 12MM
gllamm dv lag_dv_alt3 voting_power foreignpolicy euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 13MM
gllamm dv lag_dv_alt0 lngdp pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 14MM
gllamm dv lag_dv_alt1 lngdp pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 15MM
gllamm dv lag_dv_alt2 lngdp pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 16MM
gllamm dv lag_dv_alt3 lngdp pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 17MM
gllamm dv lag_dv_alt0 voting_power pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 18MM
gllamm dv lag_dv_alt1 voting_power pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 19MM
gllamm dv lag_dv_alt2 voting_power pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)

**Baseline Model 20MM
gllamm dv lag_dv_alt3 voting_power pillarii pillariii euro new_ms presidency, i(i_bargain) link(ologit)
