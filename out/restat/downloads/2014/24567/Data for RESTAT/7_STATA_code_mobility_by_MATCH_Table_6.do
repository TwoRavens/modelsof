

use "C:\Users\Bo\Documents\Match FX\mobility_reg_file.dta" ,clear

gen exit_in_1=   school_id!=F.school_id & F.school_id==.
gen switch_in_1=   school_id!=F.school_id & F.school_id!=.
replace exit_in_1=. if year>=2006

bysort teachid: egen ever_switch=max(switch_in_1)
bysort teachid: egen ever_exit=max(exit_in_1)

reg teach_fx_math ever_exit , cluster(teachid)
reg teach_fx_math ever_switch , cluster(teachid)



xi: logit  switch_in_1  match_fx_math  teach_fx_math ln_salary pfreelunch  pblack  ln_enrol  mean_read   exp_3 exp_4 exp_10 exp_25 exp_missing lic_score adv_deg reg_lic  i.year  , r cluster(teachid) or
xi: logit  exit_in_1  match_fx_math  teach_fx_math ln_salary pfreelunch  pblack  ln_enrol  mean_read   exp_3 exp_4 exp_10 exp_25 exp_missing lic_score adv_deg reg_lic  i.year  , r cluster(teachid) or

*with teacher fixed effects

xi: clogit  switch_in_1  match_fx_math  teach_fx_math ln_salary pfreelunch  pblack  ln_enrol  mean_read   exp_3 exp_4 exp_10 exp_25 exp_missing lic_score adv_deg reg_lic  i.year  , r gr(teachid) or
xi: clogit  exit_in_1  match_fx_math  teach_fx_math ln_salary pfreelunch  pblack  ln_enrol  mean_read   exp_3 exp_4 exp_10 exp_25 exp_missing lic_score adv_deg reg_lic  i.year  , r gr(teachid) or


egen schlid=group(schlcode lea)

xi: clogit  switch_in_1  match_fx_math  teach_fx_math ln_salary pfreelunch  pblack  ln_enrol  mean_read   exp_3 exp_4 exp_10 exp_25 exp_missing lic_score adv_deg reg_lic  i.year  , r gr(schlid) or
xi: clogit  exit_in_1  match_fx_math  teach_fx_math ln_salary pfreelunch  pblack  ln_enrol  mean_read   exp_3 exp_4 exp_10 exp_25 exp_missing lic_score adv_deg reg_lic  i.year  , r gr(schlid) or


* I can inlcude both in a linear probability model

xi: felsdvreg   switch_in_1  match_fx_math ln_salary pfreelunch  pblack  ln_enrol  mean_read   exp_3 exp_4 exp_10 exp_25 exp_missing lic_score adv_deg reg_lic  i.year ,  i(teach_id) j(sch_id) p(teacher_fx3) f(school_fx3) xb(XB)  res(res3) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr)  robust cluster(teachid)
xi: felsdvreg   exit_in_1  match_fx_read ln_salary pfreelunch  pblack  ln_enrol  mean_read   exp_3 exp_4 exp_10 exp_25 exp_missing lic_score adv_deg reg_lic  i.year ,  i(teach_id) j(sch_id) p(teacher_fx3) f(school_fx3) xb(XB)  res(res3) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr)  robust cluster(teachid)








