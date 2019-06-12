use "operational ideology.dta"

*gen noncentrist=0
*replace noncentrist=1 if np_score<=-.462
*replace noncentrist=1 if np_score>=.466


* Table 1, "Operational Ideology"
logit rhousevote  c.r_adv_abs##c.noncentrist pid7 repseat incumbent_party rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight],cl(stdist)

margins,at(r_adv_abs=(-1.34 0.82) noncentrist=(0 1)) post
lincom _b[3._at] - _b[1._at]
lincom _b[4._at] - _b[2._at]

quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 repseat incumbent_party rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight],cl(stdist)
margins,at(pid7 = (1 6)) post
lincom _b[2._at] - _b[1._at]

quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 repseat incumbent_party rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight],cl(stdist)
margins,at(rep_spending_adv=(-1.69 0.64)) post
lincom _b[2._at] - _b[1._at]

** Figure 3B
quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_a attendchurch female black latino age college_grad own_home [pw=weight],cl(stdist)
margins,at(r_adv_abs=(-1.34(.1)0.82) noncentrist=(0 1) own_home=1 black=0 latino=0 female=1 incumbent_party=-1 repseat=0 pid7=4 rep_spending=0 attend=0 college_grad=0) vsquish
marginsplot, xdimension(r_adv_abs) recast(line) recastci(rarea) 


** Figure 4B
quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_a attendchurch female black latino age college_grad own_home [pw=weight],cl(stdist)
margins, at(r_adv_abs=(-3 (.2) 3) noncentrist=(0 1) pid7=(1 6) ) vsquish
marginsplot, xdimension(r_adv_abs) recast(line) recastci(rarea) 


* Table 2, "Operational ideology"
logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight] if correct==1,cl(stdist)

margins,at(r_adv_abs=(-1.34 0.82) noncentrist=(0 1)) post
lincom _b[3._at] - _b[1._at]
lincom _b[4._at] - _b[2._at]

quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight] if correct==1,cl(stdist)
margins,at(pid7 = (1 6)) post
lincom _b[2._at] - _b[1._at]

quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight] if correct==1,cl(stdist)
margins,at(incumbent_ = (-1 1)) post
lincom _b[2._at] - _b[1._at]

quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight] if correct==1,cl(stdist)
margins,at(rep_spending_adv=(-1.69 0.64)) post
lincom _b[2._at] - _b[1._at]


* Table 3, "Operational ideology"
logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight] if middle==1,cl(stdist)
margins,at(r_adv_abs=(-1.34 0.82) noncentrist=(0 1)) post
lincom _b[3._at] - _b[1._at]
lincom _b[4._at] - _b[2._at]

quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight] if middle==1,cl(stdist)
margins,at(pid7 = (1 6)) post
lincom _b[2._at] - _b[1._at]

quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight] if middle==1,cl(stdist)
margins,at(rep_spending_=(-1.69 0.64)) post
lincom _b[2._at] - _b[1._at]

quietly logit rhousevote  c.r_adv_abs##c.noncentrist pid7 incumbent_party repseat rep_spending_advantage attendchurch female black latino age college_grad own_home [pw=weight] if middle==1,cl(stdist)
margins,at(repseat=(0 1)) post
lincom _b[2._at] - _b[1._at]


