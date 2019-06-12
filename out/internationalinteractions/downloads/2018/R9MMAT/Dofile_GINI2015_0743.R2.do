
# TABLE 2 #
xtgee gtddomestic lrexclpop l.ecoglob weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic mar l.ecoglob weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic lrexclpop mar l.ecoglob weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic lrexclpop c.mar##c.l.ecoglob weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic mar c.lrexclpop##i.weakdem l.ecoglob fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.mar##c.l.ecoglob c.lrexclpop##i.weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)

# TABLE 3 marginal changes ##
xtgee gtddomestic lrexclpop mar l.ecoglob weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
sum lrexclpop mar l.ecoglob weakdem fulldem anocracy lpop l.durable if e(sample)
# political exclusion 1 std below mean to 1 std above mean #
margins, at (lrexclpop=0.336 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
margins, at (lrexclpop=3.426 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
# eco dis 1 std below mean to 1 std above mean #
margins, at (lrexclpop=1.881 mar=0.319 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
margins, at (lrexclpop=1.881 mar=3.455 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
# eco glob 1 std below mean to 1 std above mean #
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=28.28 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=65.45 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
# weakdem 0 - 1 #
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=1 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
# fulldem 0 - 1 #
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=1 anocracy=0 lpop=9.087 l.durable=23.28)
# anocracy 0 - 1 #
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=23.28)
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=1 lpop=9.087 l.durable=23.28)
# pop 1 std below mean to 1 std above mean #
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=7.121 l.durable=23.28)
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=11.053 l.durable=23.28)
# durable 
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=0)
margins, at (lrexclpop=1.881 mar=1.887 l.ecoglob=46.87 weakdem=0 fulldem=0 anocracy=0 lpop=9.087 l.durable=53.18)

# TABLE APPENDIX A #
xtgee gtddomestic lrexclpop l.ecoglob weakdem fulldem anocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic mar l.ecoglob weakdem fulldem anocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic lrexclpop mar l.ecoglob weakdem fulldem anocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic lrexclpop c.mar##c.l.ecoglob weakdem fulldem anocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic mar c.lrexclpop##i.weakdem l.ecoglob fulldem anocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic c.mar##c.l.ecoglob c.lrexclpop##i.weakdem fulldem anocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)

# TABLE APPENDIX B #
xtgee gtddomestic weakdem fulldem anocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic weakdem fulldem autocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic autocracy fulldem anocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)
xtgee gtddomestic weakdem autocracy anocracy l.lgdp lpop l.durable, fam(nbinomial) corr(AR1)

# FIGURE 2 #
xtgee gtddomestic lrexclpop mar l.ecoglob weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
margins,  atmeans at(lrexclpop=(0(0.57)4.59) ) vsquish
marginsplot, recast(line) plot1opts(lpattern(-)) recastci(rline)  ciopts(color(gs13)) scheme(s2mono) title("(a) Predicted Number of Terrorist Attacks")  
margins,  atmeans at(mar=(0(0.5)4) ) vsquish
marginsplot, recast(line) plot1opts(lpattern(-)) recastci(rline)  ciopts(color(gs13)) scheme(s2mono) title("(b) Predicted Number of Terrorist Attacks")  

# FIGURE 3 #
xtgee gtddomestic lrexclpop mar l.ecoglob weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
margins, dydx(lrexclpop mar l.ecoglob weakdem fulldem anocracy lpop) atmeans post
coefplot,  xline(0, lcolor(red) ) scheme(s2mono) ciopts(recast(rcap))

# FIGURE 4 #
xtgee gtddomestic c.mar##c.l.ecoglob c.lrexclpop##i.weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
margins, atmean at(mar=(0(0.5)4) l.ecoglob=(9.43 98.88)) vsquish
marginsplot, recast(line) plot1opts(lpattern(-)) recastci(rline)  ciopts(color(gs13)) scheme(s2mono) title("(a) Predicted Number of Terrorist Attacks") 
xtgee gtddomestic lrexclpop mar lag_ecoglob lagecoglob_mar weakdem_exclusion weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
grinter mar, inter(lagecoglob_mar) const02(lag_ecoglob) kdensity yline(0)

# FIGURE 5 #
xtgee gtddomestic c.mar##c.l.ecoglob c.lrexclpop##i.weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
margins, atmean at(lrexclpop=(0(0.5)4.59) weakdem=(0 1)) vsquish
marginsplot, recast(line) plot1opts(lpattern(-)) recastci(rline)  ciopts(color(gs13)) scheme(s2mono) title("(a) Predicted Number of Terrorist Attacks")  
xtgee gtddomestic lrexclpop mar lag_ecoglob lagecoglob_mar weakdem_exclusion weakdem fulldem anocracy lpop l.durable, fam(nbinomial) corr(AR1)
grinter lrexclpop, inter(weakdem_exclusion) const02(weakdem)  


 

