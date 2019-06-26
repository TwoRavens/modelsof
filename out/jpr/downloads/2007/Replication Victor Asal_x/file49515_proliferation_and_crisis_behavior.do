use "C:\Documents and Settings\Yeah Kyle\My Documents\Projects\Nuke crises\proliferation and crisis behavior.dta", clear

ologit viol sumnukepowers_2 cincdif_mean jointdem cractr threatgrave pc if period>=3
ologit viol nukedyad cincdif_mean jointdem cractr threatgrave pc if period>=3
logit war sumnukepowers_2 cincdif_mean jointdem cractr threatgrave pc if period>=3
ologit viol sumnukepowers_2 cincdif_mean jointdem cractr threatgrave pc newnuke_2 if period>=3
ologit viol sumnukepowers_2 cincdif_mean jointdem cractr threatgrave pc spact if period>=3

estsimp ologit viol sumnukepowers_2 cincdif_mean jointdem cractr threatgrave pc if period>=3
setx jointdem 0 cractr 5 threatgrave 0 pc 1 cincdif_mean mean sumnukepowers_2 0
simqi, pr
setx jointdem 0 cractr 5 threatgrave 0 pc 1 cincdif_mean mean sumnukepowers_2 1
simqi, pr
setx jointdem 0 cractr 5 threatgrave 0 pc 1 cincdif_mean mean sumnukepowers_2 2
simqi, pr
setx jointdem 0 cractr 5 threatgrave 0 pc 1 cincdif_mean mean sumnukepowers_2 3
simqi, pr
setx jointdem 0 cractr 5 threatgrave 0 pc 1 cincdif_mean mean sumnukepowers_2 4
simqi, pr
setx jointdem 0 cractr 5 threatgrave 0 pc 1 cincdif_mean mean sumnukepowers_2 5
simqi, pr

