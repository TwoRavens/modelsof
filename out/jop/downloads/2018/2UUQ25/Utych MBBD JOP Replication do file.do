/*Data Replication File
Man Bites Blue Dog: Are Moderates Really More Electable than Ideologues?
Stephen M. Utych
Journal of Politics*/


*Main text figures
*Figure 1
logit win c.str_ideo c.time c.str_ideo#c.time gop incumbent open logspend dist_mixed s1-s50, cluster(distyear)
margins, at(time=(0(4)32) str_ideo = (0 3))
marginsplot, l(95) graphregion(color(white)) xtitle(Year) ytitle(Probability of Winning) ti("Figure 1. Ideology and Electability 1980-2012") xlabel(0 "1980" 4 "1984" 8 "1988" 12 "1992" 16 "1996" 20 "2000" 24 "2004" 28 "2008" 32 "2012") scheme(sj)

*Figure 2
reg genelectpct c.str_ideo c.time c.str_ideo#c.time gop incumbent open logspend dist_mixed s1-s50, cluster(distyear)
margins, at(time=(0(4)32) str_ideo = (0 3))
marginsplot, l(95) graphregion(color(white)) xtitle(Year) ytitle(Vote Share) ti("Figure 2. Ideology and Vote Share 1980-2012") xlabel(0 "1980" 4 "1984" 8 "1988" 12 "1992" 16 "1996" 20 "2000" 24 "2004" 28 "2008" 32 "2012") scheme(sj)

*Figure 3
logit win c.str_ideo c.time c.str_ideo#c.time incumbent open logspend dist_mixed s1-s50 if gop==1, cluster(distyear)
margins, at(time=(0(4)32) str_ideo = (0 3))
marginsplot, l(95) graphregion(color(white)) xtitle(Year) ytitle(Probability of Winning) ti("Figure 3. Ideology and Electability 1980-2012 - Republicans")  xlabel(0 "1980" 4 "1984" 8 "1988" 12 "1992" 16 "1996" 20 "2000" 24 "2004" 28 "2008" 32 "2012") scheme(sj)

*Figure 4
logit win c.str_ideo c.time c.str_ideo#c.time incumbent open logspend dist_mixed s1-s50 if gop==0, cluster(distyear)
margins, at(time=(0(4)32) str_ideo = (0 3))
marginsplot, l(95) graphregion(color(white)) xtitle(Year) ytitle(Probability of Winning) ti("Figure 4. Ideology and Electability 1980-2012 - Democrats") xlabel(0 "1980" 4 "1984" 8 "1988" 12 "1992" 16 "1996" 20 "2000" 24 "2004" 28 "2008" 32 "2012") scheme(sj)


*Appendix Tables and Figures

*Table A1
logit win c.str_ideo c.time c.str_ideo#c.time gop incumbent open logspend dist_mixed s1-s50, cluster(distyear)
reg genelectpct c.str_ideo c.time c.str_ideo#c.time gop incumbent open logspend dist_mixed s1-s50, cluster(distyear)

*Table A2
logit win c.str_ideo c.time c.gop c.str_ideo#c.time c.str_ideo#c.gop c.time#c.gop c.str_ideo#c.time#c.gop incumbent open logspend dist_mixed s1-s50, cluster(distyear)
logit win c.str_ideo c.time c.str_ideo#c.time gop incumbent open logspend dist_mixed s1-s50 if gop==1, cluster(distyear)
logit win c.str_ideo c.time c.str_ideo#c.time gop incumbent open logspend dist_mixed s1-s50 if gop==0, cluster(distyear)
reg genelectpct c.str_ideo c.time c.gop c.str_ideo#c.time c.str_ideo#c.gop c.time#c.gop c.str_ideo#c.time#c.gop incumbent open logspend dist_mixed s1-s50, cluster(distyear)
reg genelectpct c.str_ideo c.time c.str_ideo#c.time incumbent open logspend dist_mixed s1-s50 if gop==1, cluster(distyear)
reg genelectpct c.str_ideo c.time c.str_ideo#c.time incumbent open logspend dist_mixed s1-s50 if gop==0, cluster(distyear)

*Figure A1
reg genelectpct c.str_ideo c.time c.str_ideo#c.time incumbent open logspend dist_mixed s1-s50 if gop==1, cluster(distyear)
margins, at(time=(0(4)32) str_ideo = (0 3))
marginsplot, l(95) graphregion(color(white)) xtitle(Year) ytitle(Probability of Winning) ti("Figure A1. Ideology and Vote Share 1980-2012 - Republicans")  xlabel(0 "1980" 4 "1984" 8 "1988" 12 "1992" 16 "1996" 20 "2000" 24 "2004" 28 "2008" 32 "2012") scheme(sj)

*Figure A2
reg genelectpct c.str_ideo c.time c.str_ideo#c.time incumbent open logspend dist_mixed s1-s50 if gop==0, cluster(distyear)
margins, at(time=(0(4)32) str_ideo = (0 3))
marginsplot, l(95) graphregion(color(white)) xtitle(Year) ytitle(Probability of Winning) ti("Figure A2. Ideology and Vote Share 1980-2012 - Democrats") xlabel(0 "1980" 4 "1984" 8 "1988" 12 "1992" 16 "1996" 20 "2000" 24 "2004" 28 "2008" 32 "2012") scheme(sj)
