*** APPENDIX TABLE 2 MODELS ***

#delimit ;

xi: clogit benefdummy patriotflag opositor patchavezmaygov oppchavezmaygov patoppmaygov oppoppmaygov patoppmaychavezgov oppoppmaychavezgov misionfull, group(centro) cl(centro);
estimates store clogitmay1;
xi: clogit benefdummy patriotflag opositor patchavezmaygov oppchavezmaygov patoppmaygov oppoppmaygov patoppmaychavezgov oppoppmaychavezgov timeapp misionfull, group(centro) cl(centro);
estimates store clogitmay2;
xi: clogit benefdummy patriotflag opositor patchavezmaygov oppchavezmaygov patoppmaygov oppoppmaygov patoppmaychavezgov oppoppmaychavezgov timeapp misionfull i.tipo_doc, group(centro) cl(centro);
estimates store clogitmay3;

estout clogitmay*, style(tex) starlevels(* .10 ** .05 *** .01) cells(b(star fmt(3)) se(par fmt(3))) 
mlabels("1" "2" "3" "4" "5")  keep(opositor patriotflag opositor patchavezmaygov oppchavezmaygov patoppmaygov oppoppmaygov patoppmaychavezgov oppoppmaychavezgov misionfull timeapp _Itipo_doc_2 _Itipo_doc_3 _Itipo_doc_4)
order(patchavezmaygov oppchavezmaygov patriotflag opositor patoppmaychavezgov oppoppmaychavezgov patoppmaygov oppoppmaygov misionfull timeapp _Itipo_doc_2 _Itipo_doc_3 _Itipo_doc_4)
varlabels(opositor "Opposition in Chavez Muni and Opposition State" patriotflag "Loyalist in Chavez Muni and Opposition State" swing "Swing in Opposition" age "Age" lvotantes "log(Voters)" nno "Pct. No" misionfull "Misiones" abstencion "Abstention"
patchavezhold08 "Patriot in Chavez" chavezmayor2008 "Chavez Governor Baseline" oppchavezhold08 "Opposition in Chavez" swingchavezstate08 "Swing in Chavez" _Itipo_doc_2 "Carta Agraria" _Itipo_doc_3 "Permanency Rights" _Itipo_doc_4 "Title Registration"
_Itipo_doca2 "Carta Agraria" _Itipo_doca3 "Permanency Rights" _Itipo_doca4 "Title Registration" timeapp "Time in Application" nbi "Poverty Rate" rural_pc_muni "Percent Rural" lruralpop "log(Rural Population)" lruralvoters "log(Rural Voters)"
patchavezmaygov "Loyalist in Chavez Muni and Chavez State" oppchavezmaygov "Opposition in Chavez Muni and Chavez State" patoppmaygov "Loyalist in Opposition Muni and Opposition State" oppoppmaygov "Opposition in Opposition Muni and Opposition State" 
patoppmaychavezgov "Loyalist in Opposition Muni and Chavez State" oppoppmaychavezgov "Opposition in Opposition Muni and Chavez State")
stats(N, labels("Observations") fmt(0 0 3));
