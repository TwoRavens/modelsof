*** APPENDIX TABLE 3 MODELS ***

#delimit ;

xi: logit patriotflag misionfull chavezgov2008 nbi lruralpop lvotantes, cl(centro);
predict patriotflag_hat;
gen patchavezstate08_iv = patriotflag_hat*chavezgov2008;
xi: logit opositor misionfull chavezgov2008 nbi lruralpop lextrange, cl(centro);
predict opositor_hat;
gen oppchavezstate08_iv = opositor_hat*chavezgov2008;
xi: logit benefdummy patriotflag_hat patchavezstate08_iv chavezgov2008 opositor_hat oppchavezstate08_iv misionfull nbi lruralpop, cl(centro);
est store ivlogit1;

estout ivlogit*, style(tex) starlevels(* .10 ** .05 *** .01) cells(b(star fmt(3)) se(par fmt(3))) 
mlabels("1" "2" "3" "4" "5")  keep(nbi lruralpop opositor_hat patriotflag_hat misionfull patchavezstate08_iv oppchavezstate08_iv chavezgov2008)
order(patchavezstate08_iv patriotflag_hat oppchavezstate08_iv opositor_hat chavezgov2008 misionfull lruralpop nbi)
varlabels(opositor_hat "Opposition in Opposition State" patriotflag_hat "Patriot in Opposition State" swing "Swing in Opposition" age "Age" lvotantes "log(Voters)" nno "Pct. No" misionfull "Misiones" abstencion "Abstention"
patchavezstate08_iv "Patriot in Chavez State" chavezgov2008 "Chavez Governor Baseline" oppchavezstate08_iv "Opposition in Chavez State" swingchavezstate08 "Swing in Chavez"
nbi "Poverty Rate" rural_pc_muni "Percent Rural" lruralpop "log(Rural Population)" lruralvoters "log(Rural Voters)")
stats(N, labels("Observations") fmt(0 0 3));
