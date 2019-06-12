/*Stset*/
stset newend, id(pperid) failure(censor==1) origin(time newstart) scale(365.25)
*Model 2: Base
set seed 123456789
streg conflictmasskilling postconflictmasskilling inversemills,  d(exp) cluster(ccode) vce(boot)
*Model 3: Controls
set seed 123456789
streg conflictmasskilling postconflictmasskilling democracy resourceconflict conflictduration victory peaceagreement lnrgdppc lnpopulation ethnicfractionalization otherconflict unpeacekeeping internationalized lowactivity PW3_5 PW6_20  inversemills,  d(exp) cluster(ccode) vce(boot)
*Model 4: Interaction
set seed 123456789
streg i.conflictmasskilling##i.postconflictmasskilling democracy resourceconflict conflictduration victory peaceagreement lnrgdppc lnpopulation ethnicfractionalization otherconflict unpeacekeeping internationalized lowactivity PW3_5 PW6_20  inversemills,  d(exp) cluster(ccode) vce(boot)


