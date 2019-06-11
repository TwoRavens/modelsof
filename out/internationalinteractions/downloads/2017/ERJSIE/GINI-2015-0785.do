tsset cow year

*Table 1 Models *
xtgee gtddomestic l.new_sfi lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic l.effectiveness lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic l.corruption lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic l.rpe_gdp lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic l.rpe_agri lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)

*Table 2 Models*
xtgee gtddomestic l.new_sfi mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic l.effectiveness mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic l.corruption mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1) iterate(200)
xtgee gtddomestic l.rpe_gdp mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic l.rpe_agri mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)

*Table 3 Models*
xtgee gtddomestic c.l.new_sfi##c.lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.l.effectiveness##c.lndiscpop_1_10  l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.l.corruption##c.lndiscpop_1_10  l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.l.rpe_gdp##c.lndiscpop_1_10  l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.l.rpe_agri##c.lndiscpop_1_10  l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)

*Table 4 Models*
xtgee gtddomestic c.l.new_sfi##c.mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.l.effectiveness##c.mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.l.corruption##c.mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.l.rpe_gdp##c.mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.l.rpe_agri##c.mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)

*Figure 2: Marginal effects plots of key IVs and significant variables*
xtgee gtddomestic l.new_sfi mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(l.new_sfi) atmeans  post
est store marg1
xtgee gtddomestic l.effectiveness mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(l.effectiveness) atmeans post
est store marg2
xtgee gtddomestic l.corruption mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1) iterate(200)
margins, dydx(l.corruption) atmeans post
est store marg3
xtgee gtddomestic l.rpe_gdp mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(l.rpe_gdp) atmeans post
est store marg4
xtgee gtddomestic l.rpe_agri mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(l.rpe_agri) atmeans post
est store marg5
set scheme s1mono
coefplot (marg1, lab(Model 1)) (marg2, lab(Model 3)) (marg3, lab(Model 3)) (marg4, lab(Model 5)) (marg5, lab(Model 5)),  xline(0, lpattern(_) )  ciopts(recast(rcap)) legend(pos(3)) legend(col(1)) saving(model1-5margins, replace)

xtgee gtddomestic l.new_sfi mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(mar) atmeans  post
est store marg1
xtgee gtddomestic l.effectiveness mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(mar) atmeans post
est store marg2
xtgee gtddomestic l.corruption mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(mar) atmeans post
est store marg3
xtgee gtddomestic l.rpe_gdp mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(mar) atmeans post
est store marg4
xtgee gtddomestic l.rpe_agri mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(mar) atmeans post
est store marg5
set scheme s1mono
coefplot (marg1, lab(Model 1)) (marg2, lab(Model 3)) (marg3, lab(Model 3)) (marg4, lab(Model 5)) (marg5, lab(Model 5)),  xline(0, lpattern(_) )  ciopts(recast(rcap)) legend(pos(3)) legend(col(1)) saving(model1-5margins, replace)


xtgee gtddomestic l.new_sfi lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(l.new_sfi) atmeans  post
est store marg1
xtgee gtddomestic l.effectiveness lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(l.effectiveness) atmeans  post
est store marg2
xtgee gtddomestic l.corruption lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(l.corruption) atmeans  post
est store marg3
xtgee gtddomestic l.rpe_gdp lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(l.rpe_gdp) atmeans  post
est store marg4
xtgee gtddomestic l.rpe_agri lndiscpop_1 l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(l.rpe_agri) atmeans  post
est store marg5
set scheme s1mono
coefplot (marg1, lab(Model 1)) (marg2, lab(Model 3)) (marg3, lab(Model 3)) (marg4, lab(Model 5)) (marg5, lab(Model 5)),  xline(0, lpattern(_) )  ciopts(recast(rcap)) legend(pos(3)) legend(col(1)) saving(model1-5margins, replace)

xtgee gtddomestic l.new_sfi lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(lndiscpop_1) atmeans  post
est store marg1
xtgee gtddomestic l.effectiveness lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(lndiscpop_1) atmeans  post
est store marg2
xtgee gtddomestic l.corruption lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(lndiscpop_1) atmeans  post
est store marg3
xtgee gtddomestic l.rpe_gdp lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(lndiscpop_1) atmeans  post
est store marg4
xtgee gtddomestic l.rpe_agri lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, dydx(lndiscpop_1) atmeans  post
est store marg5
set scheme s1mono
coefplot (marg1, lab(Model 1)) (marg2, lab(Model 3)) (marg3, lab(Model 3)) (marg4, lab(Model 5)) (marg5, lab(Model 5)),  xline(0, lpattern(_) )  ciopts(recast(rcap)) legend(pos(3)) legend(col(1)) saving(model1-52margins, replace)

## Figure 3 ##
xtgee gtddomestic lag_newsfi lndiscpop_1_10 lfrag_lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter lndiscpop_1_10, inter(lfrag_lndiscpop_1_10) const02(lag_newsfi) saving(grinter1) kdensity yline(0)
xtgee gtddomestic lageffectiveness lndiscpop_1_10 leffect_lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter lndiscpop_1_10, inter(leffect_lndiscpop_1_10) const02(lageffectiveness) saving(grinter2) kdensity yline(0)
xtgee gtddomestic lagcorruption lndiscpop_1_10 lcorrupt_lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter lndiscpop_1_10, inter(lcorrupt_lndiscpop_1_10) const02(lagcorruption) saving(grinter3) kdensity yline(0)
xtgee gtddomestic lag_rpe_gdp lndiscpop_1_10 lag_rpe_gdp_lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter lndiscpop_1_10, inter(lag_rpe_gdp_lndiscpop_1_10) const02(lag_rpe_gdp) saving(grinter4) kdensity yline(0)
xtgee gtddomestic lagrpe_agri lndiscpop_1_10 lagrpe_agri_lndiscpop_1_10 l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter lndiscpop_1_10, inter(lagrpe_agri_lndiscpop_1_10) const02(lagrpe_agri) saving(grinter5) kdensity yline(0)
graph combine grinter1.gph grinter2.gph grinter3.gph grinter4.gph grinter5.gph

## Figure 4 ##
xtgee gtddomestic lag_newsfi mar lagfrag_mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter mar, inter(lagfrag_mar) const02(lag_newsfi) saving(grinter1) kdensity yline(0)
xtgee gtddomestic lageffectiveness mar lageffect_mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter mar, inter(lageffect_mar) const02(lageffectiveness) saving(grinter2) kdensity yline(0)
xtgee gtddomestic lagcorruption mar lagcorr_mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter mar, inter(lagcorr_mar) const02(lagcorruption) saving(grinter3) kdensity yline(0)
xtgee gtddomestic lag_rpe_gdp mar lagrpegdp_mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter mar, inter(lagrpegdp_mar) const02(lag_rpe_gdp) saving(grinter4) kdensity yline(0)
xtgee gtddomestic lagrpe_agri mar lagrpeagri_mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
grinter mar, inter(lagrpeagri_mar) const02(lagrpe_agri) saving(grinter5) kdensity yline(0)
graph combine grinter1.gph grinter2.gph grinter3.gph grinter4.gph grinter5.gph


APPENDIX FIGURE A
##pred prob ##
xtgee gtddomestic c.l.effectiveness##c.mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, atmean at(l.effectiveness=(-2.3(0.4)2.3) mar=(0.1 3.6)) vsquish
marginsplot, recast(line) plot1opts(lpattern(-)) recastci(rline)  ciopts(color(gs13)) scheme(s2mono) title("(a) Predicted Number of Terrorist Attacks") 
## pred prob ##
xtgee gtddomestic c.l.corruption##c.mar l.civilwar2 l.war2 dem anocracy lpop l.lgdp  l.splag_gtd intervention if year>1997, fam(nbinomial) corr(AR1)
margins, atmean at(l.corruption=(-2.3(0.4)2.3) mar=(0.1 3.6)) vsquish
marginsplot, recast(line) plot1opts(lpattern(-)) recastci(rline)  ciopts(color(gs13)) scheme(s2mono) title("(a) Predicted Number of Terrorist Attacks") 

APPENDIX FIGURE B
xtgee gtddomestic l.rpe_gdp i.dmar##i.dem l.civilwar1 l.war2 anocracy lpop l.lgdp l.splag_gtd intervention, fam(nbinomial) corr(AR1)
margins, atmean at(dem=(0 1) dmar=(0 1)) vsquish
marginsplot, xdimension(at(dem), noseparator) plotregion(margin(l+25 r+25))  recast(scatter) scheme(lean1) scale(1) aspectratio(1, placement(center)) graphregion(margin(small))
