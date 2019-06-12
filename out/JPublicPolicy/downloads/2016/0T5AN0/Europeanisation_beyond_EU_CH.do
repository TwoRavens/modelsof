

*** Graph 1

graph bar (sum) introad, over(year, label(alternate labcolor(black))) bar(1, fcolor(gs11) lcolor(gs11)) ///
ytitle(Number of cantons that passed adv. ban) ymtick(, valuelabel) legend(off) scheme(s1manual)

*** Table 1

logit introad euvote ///
t1 t1_2 t1_3, cluster(canton)

logit introad euvote tab ///
t1 t1_2 t1_3, cluster(canton)

logit introad euvote tab ///
timegdk_98 neighbourban puop leftregperc t1 t1_2 t1_3, cluster(canton)

logit introad euvote tab timegdk_98 ///
neighbourban puop regcul leftregperc gerpop pop2 t1 t1_2 t1_3, cluster(canton)

logit introad euvote tab timegdk_98 ///
spatlag_n puop regcul leftregperc gerpop pop2 t1 t1_2 t1_3, cluster(canton)

logit introad euvote tab timegdk_98 ///
neighbourban puop regcul svpregperc cvpregperc fdpregperc gerpop pop2 t1 t1_2 t1_3, cluster(canton)

logit introad euvote tab timegdk_98 ///
spatlag_n puop regcul svpregperc cvpregperc fdpregperc gerpop pop2 t1 t1_2 t1_3, cluster(canton)

*** Graph 2

set more off
logit introad euvote i.tab spatlag_n timegdk_98 regcul ///
puop svpregperc cvpregperc fdpregperc gerpop pop2 t1 t1_2 t1_3, cluster(canton)

margins, at(euvote=(30(1)80) tab=(1))

marginsplot, recast(line) plotopts(lcolor(gs6) lpattern(dots)) ///
recastci(rarea) ciopts(fcolor(gs14) lcolor(gs14)) ///
ytitle(Probability of introducing advertisement bans) ///
xtitle(Support for EU) yline(0) scheme(s1manual) title(Tobacco industry) ///
name(euvote1, replace) nodraw yscale(r(0 0.6)) ylabel(0 0.1 0.2 0.3 0.4 0.5 0.6)

logit introad euvote i.tab t1 t1_2 t1_3, cluster(canton)

margins, at(euvote=(30(1)80) tab=(0))

marginsplot, recast(line) plotopts(lcolor(gs6) lpattern(dots)) ///
recastci(rarea) ciopts(fcolor(gs14) lcolor(gs14)) ///
ytitle(Probability of introducing advertisement bans) ///
xtitle(Support for EU) yline(0) scheme(s1manual) title(No tobacco industry) ///
name(euvote2, replace) nodraw yscale(r(0 0.6)) ylabel(0 0.1 0.2 0.3 0.4 0.5 0.6)

graph combine euvote1 euvote2, scheme(s1mono) altshrink


*** Graph 3

set more off
logit introad euvote i.tab spatlag_n timegdk_98 regcul ///
puop svpregperc cvpregperc fdpregperc gerpop pop2 t1 t1_2 t1_3, cluster(canton)

margins, at(timegdk_98=(0(1)13) tab=(1) euvote=(25))

marginsplot, recast(line) plotopts(lcolor(gs6) lpattern(dots)) ///
recastci(rarea) ciopts(fcolor(gs14) lcolor(gs14)) ///
ytitle(Probability of introducing advertisement bans) ///
xtitle(Years in CDP Board) yline(0) scheme(s1manual) title(Tobacco industry and low EU support) ///
name(GDK1, replace) nodraw yscale(r(-0.05 0.7)) ylabel(-0.05 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7)

logit introad euvote i.tab spatlag_n timegdk_98 regcul ///
puop svpregperc cvpregperc fdpregperc gerpop pop2 t1 t1_2 t1_3, cluster(canton)

margins, at(timegdk_98=(0(1)13) tab=(1) euvote=(80))

marginsplot, recast(line) plotopts(lcolor(gs6) lpattern(dots)) ///
recastci(rarea) ciopts(fcolor(gs14) lcolor(gs14)) ///
ytitle(Probability of introducing advertisement bans) ///
xtitle(Years in CDP Board) yline(0) scheme(s1manual) title(Tobacco industry and high EU support) ///
name(GDK2, replace)  nodraw yscale(r(-0.05 0.7)) ylabel(-0.05 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7)

graph combine GDK1 GDK2 , scheme(s1manual) altshrink

