clear 

//cd ""

//requires downloading of files for the mibeta command


use h_RUS_FIRMS_2010_MI

//PROPERTY DISPUTE SCENARIO REGRESSIONS - TABLE A1
//produces output in Latex

mibeta lawyers2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) replace

mibeta courts2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta lawenf2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta bur2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta courts_inf2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta lawenf_inf2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta bur_inf2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta mafia2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta psa2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta pss2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_ppty.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append


//code for Rows 3 and 4 of Table A1
mibeta lawyers2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta courts2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta lawenf2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta bur2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta courts_inf2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta lawenf_inf2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta bur_inf2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta mafia2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta psa2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta pss2 tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized


//DEBT DISPUTE SCENARIO REGRESSIONS - TABLE A2
//produces output in Latex

mibeta lawyers tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) replace

mibeta courts tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta lawenf tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta bur tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta courts_inf tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta lawenf_inf tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta bur_inf tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta mafia tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta psa tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

mibeta pss tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
outreg2 using demand_debt.tex,   tex(frag) dec(2) alpha(.001,.01,.05,.10) symbol(^{***},^{**},^{*},^{\dagger}) addstat(R-sq., `e(r2_mi)', Adj. R-sq., `e(r2_adj_mi)') adec(2) append

//code for Rows 3 and 4 of Table A2

mibeta lawyers tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta courts tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta lawenf tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta bur tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta courts_inf tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta lawenf_inf tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta bur_inf tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta mafia tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta psa tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized

mibeta pss tax1_dich_r other_firms2_r privatized##consolidated  i.size_dummies firm_age foreign_own gov_own BA rts_viol litigated  leg_ed age gender  i.job_descript i.city2 i.sector3 i.growth  ,robust  miopts(post)
lincom 1.consolidated + 1.consolidated#1.privatized
