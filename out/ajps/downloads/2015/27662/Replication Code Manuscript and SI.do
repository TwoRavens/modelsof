use "/Reduced_Dataset_AJPS.dta"

* Main manuscript: Table 4 & Figure 3
xtset cmpcode timeXT
xtnbreg change ldifseatshare inop durM effpar_leg , nolog irr
xtnbreg change ldifseatshare inop##c.percoff2 durM effpar_leg , nolog irr
margins, dydx(inop) at(percoff2=(0(.1)1)) 
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white))

* Supporting information: table 1

xtnbreg change ldifseatshare seq durM effpar_leg , nolog irr

* Supporting information: table 2

xtnbreg change ldifseatshare inoffminpercoff2 durM effpar_leg , nolog irr

* Supporting information: table 3

xtnbreg changeA1 ldifseatshare inop##c.percoff2 durM effpar_leg , nolog irr
margins, dydx(inop) at(percoff2=(0(.1)1))
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white)) name(gr1)

xtnbreg changeA2 ldifseatshare inop##c.percoff2 durM effpar_leg , nolog irr
margins, dydx(inop) at(percoff2=(0(.1)1))
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white)) name(gr2)

xtreg changeA3 ldifseatshare inop##c.percoff2 durM effpar_leg
margins, dydx(inop) at(percoff2=(0(.1)1))
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white)) name (gr9)

* Supporting information: table 4

xtpcse absrilechange i.inop##c.percoff2 ldifseatshare durM effpar_leg, corr(psar1) p
margins, dydx(inop) at(percoff2=(0(.1)1)) 
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white))

* Supporting information: table 5

graph drop _all

nbreg change ldifseatshare i.inop##c.percoff2 durM effpar_leg , nolog 
local dispersionparameter = e(alpha)
xtgee change ldifseatshare i.inop##c.percoff2 durM effpar_leg, family(nb `dispersionparameter') c(ar1) force vce(robust) eform  nolog
margins, dydx(inop) at(percoff2=(0(.1)1)) 
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white)) name (gr4)

nbreg change ldifseatshare i.inop##c.percoff2 durM effpar_leg , nolog 
local dispersionparameter = e(alpha)
xtgee change ldifseatshare i.inop##c.percoff2 durM effpar_leg, family(nb `dispersionparameter') c(ar3) force vce(robust) eform  nolog
margins, dydx(inop) at(percoff2=(0(.1)1))
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white)) name (gr5)

zinb  change ldifseatshare inop##c.percoff2 durM effpar_leg, inflate(durM) vuong zip irr
margins, dydx(inop) at(percoff2=(0(.1)1))
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white)) name (gr7)

graph combine gr4 gr5 gr7, altshrink imargin(small) graphregion(fcolor(white))

* Supporting information: table 6
graph drop _all

xtgls abslrchange i.inop##c.percoff2 ldifseatshare durM effpar_leg Labslrdif, panels(h) corr(psar1) force
margins, at(inop=(0) percoff2=(0(.1)1)) l(95)
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Predicted change in distance to mean party) title("Government parties") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white))  name(gr7)

margins, at(inop=(1) percoff2=(0(.1)1)) l(95)
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Predicted change in distance to mean party) title("Opposition parties") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white)) name(gr8)

graph combine gr7 gr8, altshrink imargin(small) graphregion(fcolor(white))


* Supporting information: table 7
xtnbreg changeA6 ldifseatshare inop##c.percoff2 durM effpar_leg, nolog irr
margins, dydx(inop) at(percoff2=(0(.1)1)) 
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white))

xtnbreg changeA7 ldifseatshare inop##c.percoff2 durM effpar_leg, nolog irr
margins, dydx(inop) at(percoff2=(0(.1)1))
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white))

* Supporting information: table 8

/// Note: the data for this replication are also used in a follow-up paper, we will publish data + replication material here once this follow-up paper has been published.

* Supporting information: table 9

xtnbreg change ldifseatshare i.inop##c.percoff2 durM effpar_leg , nolog irr vce(jack)

* Supporting information: table 10

xtnbreg change ldifseatshare inop##c.percoff2 durM effpar_leg gdpchange lrvotchange, nolog irr
margins, dydx(inop) at(percoff2=(0(.1)1)) 
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white))

* Supporting information: table 11

xtnbreg change ldifseatshareM inop##c.percoff2 durM effpar_leg , nolog irr
margins, dydx(inop) at(percoff2=(0(.1)1))
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white))

xtnbreg change c.ldifseatshare##inop##c.percoff2 durM effpar_leg , nolog irr

margins, dydx(inop) at(percoff2=(0(.1)1))
marginsplot, xtitle(Proportion of years governed until election t) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white))

margins, dydx(inop) at(ldifseatshare=(-0.4(.1)0.4))
marginsplot, xtitle(Electoral gains and losses at last election) ytitle(Marg. effect of opposition) title("") recast(line) ///
plot1opts(lcolor(gs14)lp(solid)lw(medthick))    ///
recastci(rline) ci1opts(lp(dash)lcolor(gs14))    yline(0, lcolor(black)) graphregion(fcolor(white))




