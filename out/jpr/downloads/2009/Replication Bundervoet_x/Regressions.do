set memory 30m
use "Dataset1.dta"


regression R1 of Table IV
char Province[omit] 11

xi: logit KIK Niveau_instruction gender numbervaches numbergoshpo numberpoultry AgeIn1993 AgeIn1993SQ i.Province if  Province~=17 [pweight=  Poids_intra_milieu], robust

regressions R2 and R3 of Table IV

use "dataset2.dta"

char Province[omit] 11

xi: logit HHKG Niveau_instruction numbervaches numbergoshpo numberpoultry meanage meanageSQ i.Province if  Province~=17 [pweight=  Poids_intra_milieu], robust

xi: logit HHKG Niveau_instruction TLUbis TLUbisSQ meanage meanageSQ i.Province if  Province~=17 [pweight=  Poids_intra_milieu], robust

Regressions for Table IX

logit HHKG TLUbis TLUbisSQ meanage meanageSQ Popdens FrodVotebis FrodvotebisSQ Niveau_instruction if  Province~=17 [pweight=  Poids_intra_milieu], robust

logit HHKG TLUbis TLUbisSQ meanage meanageSQ Popdens FrodVotebis FrodvotebisSQ Niveau_instruction if  Province==6 | Province==7 | Province==8 | Province==9 | Province==11 | Province==12 | Province==14 [pweight=  Poids_intra_milieu], robust



