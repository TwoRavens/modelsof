*** APPENDIX TABLE 4 MODELS 2 AND 5 ***
*** Note that this uses AppendixTable4M2M5.dta. It can also be run using Table2.dta.  ***

* Note that Appendix Table 4 Model 2 is identical to Appendix Table 4 Model 5
* Note that Model 1 and Model 4 of Appendix Table 4 correspond to Model 4 and Model 6 of Table 1 in the paper

#delimit ;

xi: quietly tobit benefprop_1000 lruralpop nbi abschavezmargin abschavezmargin_chavezstate08 chavezgov2008, ll(0) r;
estimates store apptable4a;
xi: quietly tobit benefprop_1000 lruralpop nbi abschavezmargin abschavezmargin_chavezstate08 chavezgov2008, ll(0) r;
estimates store apptable4b;

estout apptable4*, style(tex) starlevels(* .10 ** .05 *** .01) cells(b(star fmt(3)) se(par fmt(3))) 
	mlabels("1: RE" "2: RE" "3: RE" "4: RE, Lag DV" "5: RE, Lag DV" "6: RE, Lag DV") keep(lruralpop nbi abschavezmargin abschavezmargin_chavezstate08 chavezgov2008) 
	order(abschavezmargin_chavezstate08 abschavezmargin chavezgov2008 lruralpop nbi)
	varlabels(agemunmais "Age" misionfullmunmais "Misiones" patriotmais "\% Loyalists in Opposition State" opositormais "\% Opposition in Chavez State" lvoters "log(Voters)" chavezvote "\% Chavez Vote" abschavezmargin "Chavez Win Margin in Opposition State" abschavezmargin_chavezstate08 "Chavez Win Margin in Chavez State" chavezgov2008 "Chavez Governor Baseline" patchavezstate08 "\% Loyalists in Chavez State" oppchavezstate08 "\% Opposition in Opposition State" lruralvoters "log(Rural Voters)" lruralvoters_muni "log(Rural Voters)" lruralpop "log(Rural Population)" rural_pc_muni "Percent Rural" nbi "Poverty Rate")
	stats(N, labels("Observations") fmt(0 0 3));
