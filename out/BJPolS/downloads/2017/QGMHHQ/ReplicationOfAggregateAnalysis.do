***************************************************************************************************************************************************************************
***** August 25., 2016                                                                                                                                                 **** 
***** The current STATA do-file replicates the main empirical results presented in Rune Jørgen Sørensen: The impact of state television on voter turnout, to be        **** 
***** published inthe British Journal of Political Science. The do-file uses the dataset AggregateReplicationTVData.dta plus map coordinates in muncoord.dta           **** 
***** The file produces the diagrams Figure 1 - 6, and Tables 1 and 2.                                                                                                 **** 
*****                                                                                                                                                                  **** 
***** The file also generates the results presented in the online appendix, Appendix A - F.                                                                            **** 
***** Additional results are based on data from the Norwegian Election Surveys (1965, 1969 and 1973). The results for Tables 3,4 and 5 and Appendix G can be generated **** 
***** by an other do-file.                                                                                                                                             **** 
*****                                                                                                                                                                  **** 
***************************************************************************************************************************************************************************

clear all
set matsize 5000
use "W:\users\fag89001\TVReplication\AggregateData\AggregateReplicationTVData.dta"

****** FIGURE 1 - MAP FOR SOUTH-EAST and WEST-COAST - ******************************************************************************************************************
* FIGURE 1 AS COLOR GRAPH
quietly spmap TVfirstyear using "C:\Users\FAG89001\Dropbox\SASDATA\Kommunekart\Koordinater fra NSD\muncoord.dta" if CountyId<8 & year==1983, id(id)  ///
legend(pos(5)) legend(subtitle("TV access", size(small))) subtitle("", pos(11)) ///
fcolor(green*1 green*0.8 green*0.6 green*0.4 green*0.2 yellow*0.2 yellow*0.4 yellow*0.6 yellow*0.8 yellow yellow yellow yellow yellow) clmethod(unique) title("The South-East", span) ///
note("The map covers the municipalities located in" "the counties Østfold, Akershus, Oslo, Hedmark, Oppland and Vestfold", size(vsmall))  ///
saving(TVAccessA.gph, replace)
quietly spmap TVfirstyear using "C:\Users\FAG89001\Dropbox\SASDATA\Kommunekart\Koordinater fra NSD\muncoord.dta" if CountyId>11 & CountyId<15 & year==1983, id(id)  ///
legend(pos(5)) legend(subtitle("TV access", size(small))) subtitle("", pos(11)) ///
fcolor(green*1 green*0.8 green*0.6 green*0.4 green*0.2 yellow*0.2 yellow*0.4 yellow*0.6 yellow*0.8 yellow yellow yellow yellow yellow) clmethod(unique) title("The West-Coast", span) ///
note("The map covers the municipalities located in" "the counties Hordaland and Sogn- og fjordane, ", size(vsmall))  saving(TVAccessB.gph, replace)
graph combine "TVAccessB" "TVAccessA", title("Figure 1. First year of TV access") saving(Figure1, replace)

* FIGURE 2 - TV DEVELOPMENT ******************************************************************************************************************************************************
egen tvpenetration = mean(TVdummy), by(year)
replace tvpenetration=. if year<1957
replace tvpenetration=0 if year==1959
lab var tvpenetration "Share of municipalities with access to TV signals"
sort year

* FIGURE 2 AS COLOR GRAPH
twoway (scatter newspapers year if year>=1959 & year<=1975, connect(2) lpattern(-) msymbol(triangle) lcolor(green) mcolor(green) sort ) || ///
(scatter TVlic year if year>=1959 & year<=1975, connect(2) lpattern(-) sort msymbol(square_hollow) lcolor(cranberry) mcolor(cranberry)) ||  ///
(scatter tvpenetration year if year>=1959 & year<=1975, connect(1) sort msymbol(square) lcolor(edkblue) mcolor(edkblue) lw(mediumthick)  ///
yline(1) title("Media penetration", size(medium)) graphregion(color(white)) ytitle("Ratios") xtitle("Year") legend(cols(1) ring(0) position(5) bplacement(seast) bmargin(small) region(lwidth(none))) ///
legend(lab(1 "Newspaper circulation")  lab(2 "TV licenses") lab(3 "Municipalities with TV access") size(vsmall))  ///
note("Note. Daily net newspaper circulation and number of TV licenses are" "measured relative to number of radio licenses.", size(vsmall)) saving(tvplott1.gph, replace))
quietly binscatter tvhours tvnewshours year if year>1959 & year<1985, discrete line(connect) graphregion(color(white)) legend(cols(1) ring(0) position(3) bmargin(small) region(lwidth(none))) ///
note("Note. The diagram displays average numbers of TV production,"" using annual numbers of production.", size(vsmall)) ///
title("Television production",size(medium)) msymbol(circle_hollow) ytitle("Hours per day") xtitle("Year") savegraph(tvplott2.gph) legend(lab(1 "Total production") lab(2 "News production") size(small)) replace
graph combine tvplott1.gph tvplott2.gph,  graphregion(color(white)) title("Figure 2. TV and media developments", size(mediumlarge)) saving(Figure2, replace) note("Sources: Editions of Statistical Yearbook, Statistics Norway", size(vsmall))


****** FIGURE 3 - VOTER TURNOUT **********************************************************************************************************************
sort year
egen nturnoutmean = mean(nturnout) , by(year) 
egen nturnoutmedian = median(nturnout), by(year) 
egen nturnout25=pctile(nturnout), p(25) by(year)
egen nturnout75=pctile(nturnout), p(75) by(year)
egen lturnoutmean = mean(lturnout) , by(year) 
egen lturnoutmedian = median(lturnout), by(year) 
egen lturnout25=pctile(lturnout), p(25) by(year)
egen lturnout75=pctile(lturnout), p(75) by(year)

twoway (rarea lturnout25 lturnout75 year, color(grey*0.2))  || (line lturnoutmean year), title("Local elections") xtitle("Election year")  ytitle("Turnout") xlabel(1947(4)1987,labsize(small))  graphregion(color(white)) legend(off) saving(lturnoutgraph.gph, replace)
twoway (rarea nturnout25 nturnout75 year, color(grey*0.2)) || (line nturnoutmean year), title("National elections") xtitle("Election year") ytitle("Turnout") xlabel(1949(4)1989,labsize(small)) graphregion(color(white)) legend(off) saving(nturnoutgraph.gph, replace)
graph combine lturnoutgraph.gph nturnoutgraph.gph, ycommon title("Figure 3. Voter turnout 1947-1987", color(black) size(mediumlarge)) graphregion(color(white)) ///
note("Note. The shaded areas indicate the interquartile range of voter turnout, and the lines show average voter turnout.",size(vsmall))  ///
saving(Figure3, replace)


* FIGURE 4 - TRENDS IN VOTER TURNOUT BY YEAR OF TV access
gen tvp=TVfirstyear
replace tvp=1 if TVfirstyear<=1962
replace tvp=2 if TVfirstyear>=1963 & TVfirstyear<=1965
replace tvp=3 if TVfirstyear>=1966 & TVfirstyear<=1968
replace tvp=4     if TVfirstyear>=1969
lab var tvp "Municipalities classified by first year with TV-access"

* Estimating turnout as deviations from annual means
quietly reg turnout i.year if nationalelection==0
predict rlocalturnout, residual 
quietly reg turnout i.year if nationalelection==1
predict rnationalturnout, residual 

* FIGURE 4 AS COLOR GRAPH
binscatter rlocalturnout year if nationalelection==0, by(tvp) yline(0, lpattern(dash)) xline(1960, lpattern(dash)) line(connect) xlabel(1947(4)1987,labsize(vsmall)) msymbols(square triangle circle diamond)   ///
legend(lab(1 "1960-1962") lab(2 "1963-1965") lab(3 "1966-1968") lab(4 "1969-")) title("Local elections", color(black)) xtitle("Year") ytitle("Share") savegraph(rlocalturnout.gph) replace
binscatter rnationalturnout year if nationalelection==1, by(tvp) yline(0, lpattern(dash)) xline(1960, lpattern(dash)) line(connect) xlabel(1949(4)1987,labsize(vsmall)) msymbols(square_hollow triangle_hollow circle_hollow diamond_hollow)  ///
legend(lab(1 "1960-1962") lab(2 "1963-1965") lab(3 "1966-1968") lab(4 "1969-")) title("National elections", color(black)) xtitle("Year") ytitle("Share") savegraph(rnationalturnout.gph) replace
graph combine rlocalturnout.gph rnationalturnout.gph, graphregion(color(white)) title("Figure 4. Voter turnout by first year of TV access", size(mediumlarge)) ///
note("Note. Voter turnout has been measured as deviations from the annual means." "The first municipalities received access to TV signals in 1960.") saving(Figure4, replace) 
erase rlocalturnout.gph 
erase rnationalturnout.gph

* FIGURE 5. ILLUSTRATING THE EXOGENEITY ASSUMPTION ****************************************************************************************************************************************************************************************************************************************************************************************************
* FIGURE 5 AS COLOR GRAPH
quietly binscatter TVfirstyear logitt   if year==1957, title("No controls",size(medsmall))                      ylabel(1963(4)1967,labsize(small)) graphregion(color(white)) xtitle("Voter turnout (logit), 1957", size(vsmall)) ytitle("Year with TV access",size(vsmall)) yline(1964.4, lpattern(dash)) saving(turnoutwithoutcontrols, replace)
quietly binscatter TVfirstyear logitt   if year==1957, title("With controls",size(medsmall)) controls(logpop i.CountyId) ylabel(1963(4)1967,labsize(small)) graphregion(color(white)) xtitle("Voter turnout (logit), 1957", size(vsmall)) ytitle("Year with TV access",size(vsmall)) yline(1964.4, lpattern(dash)) saving(turnoutwithcontrols, replace)
quietly binscatter TVfirstyear dlogitnationalturnout19491957 if year==1957, title("No controls",size(medsmall))          ylabel(1963(4)1967,labsize(small)) graphregion(color(white)) xtitle("Turnout difference (logit), 1949-1957", size(vsmall)) ytitle("Year with TV access",size(vsmall)) yline(1964.4, lpattern(dash)) saving(trendwithoutcontrols, replace)
quietly binscatter TVfirstyear dlogitnationalturnout19491957 if year==1957, title("With controls",size(medsmall)) controls(logpop i.CountyId) ylabel(1963(4)1967,labsize(small)) graphregion(color(white)) xtitle("Turnout difference (logit), 1949-1957", size(vsmall)) ytitle("Year with TV access",size(vsmall)) yline(1964.4, lpattern(dash)) saving(trendwithcontrols, replace)
graph combine "turnoutwithoutcontrols" "turnoutwithcontrols" "trendwithoutcontrols" "trendwithcontrols", ycommon  graphregion(color(white)) iscale(1) title("Figure 5. The exogeneity of TV access", size(mediumlarge)) ///
note("Voter turnout (logit) refers to the national elections in 1957 and 1959, and to difference in the period 1949-1957." ///
"The controls include county fixed effects and municipal population size (log). The dashed lines mark the average year of TV access.", size(vsmall)) saving(Figure5, replace)

* FIGURE 6 - RELATIONSHIP BETWEEN LICENSES AND TURNOUT *****************************************************************************************************************************
sort knr year
gen dlt=logitt-logitt[_n-2]
gen ddlt= logitt-logitt[_n-4]
* FIGURE 6 AS COLOR GRAPH
quietly scatter TVlicences1964 TVyears if year==1963 & TVfirstyear<=1965 [aweight=pop], msymbol(smcircle) msymbol(O) mlcolor(blue) mfcolor(ltblue) msize(small) graphregion(color(white)) ///
title("TV-licenses in 1964",size(medium)) ytitle("Percent of households with TV license, 1964", size(small)) xtitle("Number of years with TV access", size(small)) ///
note("Note. The bubble sizes are proportional to the municipality population sizes.", size(vsmall)) saving(tvplott3.gph, replace)
quietly binscatter dlt ddlt TVlicences1964 if year==1965 & TVfirstyear<=1964, nq(50) line(none) msymbol(circle_hollow) graphregion(color(white)) legend(lab(1 "Difference 1965-1961") lab(2 "Difference 1965-1957") size(small)) ///
title("Voter turnout and TV-licenses",size(medium)) ytitle("Increase in voter turnout", size(small)) xtitle("Percent of households with TV license, 1964", size(small)) ///
note("Note. The diagram shows bins using the differences of voter turnout" "measured on a logit scale in 1965 and 1961/1957 respectively.", size(vsmall)) saving(tvplott4.gph, replace)
graph combine tvplott3.gph tvplott4.gph,  title("Figure 6. Television licenses 1960-1964", size(mediumlarge)) graphregion(color(white)) saving(Figure6, replace)
erase tvplott3.gph
erase tvplott4.gph

* TABLE 1. TV-DUMMY EFFECTS ON LEVELS OF VOTER TURNOUT ******************************************************************************************************************************************************************************************************************************************************************************************************
* Local elections
label var TVdummy "TV (=1)"
label var tvnews "TV production"
gen municipalities=knr
xtset municipalities 

* Baseline regression
quietly glm turnout i.TVdummy voterpct fvoterpct logpop settlement education i.knr i.year if nationalelection==0, link(logit)  family(binomial) vce(cluster knr)
margins r.TVdummy, post
outreg2 using Table1a.doc,  replace ctitle(Local) bdec(4) alpha(0.001, 0.01, 0.05) title("Marginal effects of TV") addt(Control variables, YES, Municipality FE, YES, County FE, NO, Election year FE, YES, Mun.s.trend, NO, County-year FE, NO)  
* Municipality-specific trend
quietly glm turnout i.TVdummy voterpct fvoterpct logpop settlement education i.knr i.knr#c.trend i.year if nationalelection==0, link(logit)  family(binomial) vce(cluster knr)
margins r.TVdummy, post
outreg2 using Table1a.doc,  append ctitle(Local) bdec(4) alpha(0.001, 0.01, 0.05) title("Marginal effects of TV") addt(Control variables, YES, Municipality FE, YES, County FE, NO, Election year FE, YES, Mun.s.trend, YES, County-year FE, NO)  
* County-year fixed effects
quietly glm turnout i.TVdummy voterpct fvoterpct logpop settlement education i.knr i.year#i.CountyId if nationalelection==0, link(logit)  family(binomial) vce(cluster knr)
margins r.TVdummy, post
outreg2 using Table1a.doc,  append ctitle(Local) bdec(4) alpha(0.001, 0.01, 0.05) title("Marginal effects of TV") addt(Control variables, YES, Municipality FE, YES, County FE, NO, Election year FE, YES, Mun.s.trend, NO, County-year FE, YES)  
* Without covariates
quietly glm turnout i.TVdummy i.CountyId i.year if nationalelection==0, link(logit)  family(binomial) vce(cluster knr)
margins r.TVdummy, post
outreg2 using Table1a.doc,  append ctitle(Local) bdec(4) alpha(0.001, 0.01, 0.05) title("Marginal effects of TV") addt(Control variables, NO, Municipality FE, NO, County FE, YES, Election year FE, YES, Mun.s.trend, NO, County-year FE, NO)  

* National elections
* Baseline regression
quietly glm turnout i.TVdummy voterpct fvoterpct logpop settlement education i.knr i.year if nationalelection==1, link(logit) family(binomial) vce(cluster knr)
margins r.TVdummy, post
outreg2 using Table1b.doc,  replace ctitle(National) bdec(4) label alpha(0.001, 0.01, 0.05) title("Marginal effects of TV") addt(Control variables, YES, Municipality FE, YES, County FE, NO, Election year FE, YES, Mun.s.trend, NO, County-year FE, NO)  
* Municipality-specific trend
quietly glm turnout i.TVdummy voterpct fvoterpct logpop settlement education i.knr i.knr#c.trend i.year if nationalelection==1, link(logit)  family(binomial) vce(cluster knr)
margins r.TVdummy, post
outreg2 using Table1b.doc,  append ctitle(National) bdec(4) alpha(0.001, 0.01, 0.05) title("Marginal effects of TV") addt(Control variables, YES, Municipality FE, YES, County FE, NO, Election year FE, YES, Mun.s.trend, YES, County-year FE, NO)  
* County-year fixed effects
quietly glm turnout i.TVdummy voterpct fvoterpct logpop settlement education i.knr i.year#i.CountyId if nationalelection==1, link(logit)  family(binomial) vce(cluster knr)
margins r.TVdummy, post
outreg2 using Table1b.doc,  append ctitle(National) bdec(4) alpha(0.001, 0.01, 0.05) title("Marginal effects of TV") addt(Control variables, YES, Municipality FE, YES, County FE, NO, Election year FE, YES, Mun.s.trend, NO, County-year FE, YES)  
* Without covariates
quietly glm turnout i.TVdummy i.CountyId i.year if nationalelection==1, link(logit)  family(binomial) vce(cluster knr)
margins r.TVdummy, post
outreg2 using Table1b.doc,  append ctitle(National) bdec(4) alpha(0.001, 0.01, 0.05) title("Marginal effects of TV") addt(Control variables, NO, Municipality FE, NO, County FE, YES, Election year FE, YES, Mun.s.trend, NO, County-year FE, NO)  
* Table 1 FINISHED *******************************************************************************************

* TABLE 2. TV-PRODUCTION EFFECTS ON LEVELS OF VOTER TURNOUT ******************************************************************************************************************************************************************************************************************************************************************************************************
gen tvnewsD=c.tvnews#c.TVdummy
gen tvtotalD=c.tvtotal#c.TVdummy
lab var tvnewsD "TV newsproduction*(TV=1)"
lab var tvtotalD "TV totalproduction*(TV=1)"

* Baseline regression of news production - local elections
quietly glm turnout tvnewsD voterpct fvoterpct logpop settlement education i.knr i.year if nationalelection==0, link(logit) family(binomial) vce(cluster knr)
margins, dydx(tvnewsD) post
outreg2 using Table2.doc,  replace keep(tvnewsD) label  ctitle(Local) bdec(4) alpha(0.001, 0.01, 0.05) title("Marginal effects of TV producction in local elections") addt(Control variables, YES, Municipality FE, YES, Election year FE, YES, Mun.s.trend, NO)  
* addnote("The model has been estimated as a fractional response model using a logistic regression specification. The standard errors are clustered at the municipality level." "The table displays marginal effects of television production estimated at mean values of the control variables.") 
* Baseline regression of total production - local elections
quietly glm turnout tvtotalD voterpct fvoterpct logpop settlement education i.knr i.year if nationalelection==0, link(logit) family(binomial) vce(cluster knr)
margins, dydx(tvtotalD) post
outreg2 using Table2.doc,  append keep(tvtotalD) label  ctitle(Local) bdec(4) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Municipality FE, YES, Election year FE, YES, Mun.s.trend, NO)  
* Baseline regression of news production - national elections
quietly glm turnout tvnewsD voterpct fvoterpct logpop settlement education i.knr i.year if nationalelection==1, link(logit) family(binomial) vce(cluster knr)
margins, dydx(tvnewsD) post
outreg2 using Table2.doc,  append keep(tvnewsD) label  ctitle(National) bdec(4) alpha(0.001, 0.01, 0.05) title("Marginal effects of TV producction in national elections") addt(Control variables, YES, Municipality FE, YES, Election year FE, YES, Mun.s.trend, NO)  
* Baseline regression of total production - national elections
quietly glm turnout tvtotalD voterpct fvoterpct logpop settlement education i.knr i.year if nationalelection==1, link(logit) family(binomial) vce(cluster knr)
margins, dydx(tvtotalD) post
outreg2 using Table2.doc,  append keep(tvtotalD) label  ctitle(National) bdec(4) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Municipality FE, YES, Election year FE, YES, Mun.s.trend, NO)  
* Table 2 FINISHED ******************************************************************************************************************************************************************


* TABLES 3-5 PRESENT RESULTS FOR INDIVIDUAL LEVEL SURVEY DATA ********************************************************************************************************************

************* APPENDIX **************************************************************************************************************************************************************
* APPENDIX A. DESCRIPTIVE STATISTICS
quietly outreg2 using AppendixA.doc, replace  sum(log) keep(nturnout lturnout TVdummy tvnews tvtotal TVlicences1964    /// 
voterpct fvoterpct pop settlement education year knr) label title("Appendix A. Descriptive statistics for municipality-level data")  

* FOOTNOTE. Testing whether TV has different effect in national and local elections in the baseline model ***********************************************************************
quietly glm turnout c.TVdummy#i.nationalelection c.voterpct#i.nationalelection c.fvoterpct#i.nationalelection ///
c.logpop#i.nationalelection c.settlement#i.nationalelection c.education#i.nationalelection i.knr#i.nationalelection i.year , link(logit)  family(binomial) vce(cluster knr)
test c.TVdummy#1.nationalelection=c.TVdummy#0.nationalelection
* FOOTNOTE. Estimates with the size of the electorate as weights
quietly glm turnout i.TVdummy voterpct fvoterpct settlement education i.knr i.year if nationalelection==0 [fw=nvoters1965], link(logit)  family(binomial) vce(cluster knr)
margins r.TVdummy
glm turnout c.TVdummy#i.nationalelection c.voterpct#i.nationalelection c.fvoterpct#i.nationalelection ///
c.logpop#i.nationalelection c.settlement#i.nationalelection c.education#i.nationalelection i.knr#i.nationalelection i.year [fw=nvoters1965], link(logit)  family(binomial) vce(cluster knr)
 
 * Appendix B. Linear probability model
quietly glm turnout TVdummy voterpct fvoterpct logpop settlement education i.knr i.year if nationalelection==0, link(identity)  family(binomial) vce(cluster knr)
outreg2 using AppendixB.doc,  replace keep(TVdummy) nocon ctitle(Local) bdec(3) alpha(0.001, 0.01, 0.05) title("Appendix B. TV-estimates with a linear probability model.") addt(Control variables, YES, Municipality FE, YES, County FE, NO, Election year FE, YES)  
quietly glm turnout TVdummy i.CountyId i.year if nationalelection==0, link(identity)  family(binomial) vce(cluster knr)
outreg2 using AppendixB.doc,  append  keep(TVdummy) nocon ctitle(Local) bdec(3) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Municipality FE, NO, County FE, YES, Election year FE, YES)  
quietly glm turnout TVdummy voterpct fvoterpct logpop settlement education i.knr i.year if nationalelection==1, link(identity)  family(binomial) vce(cluster knr)
outreg2 using AppendixB.doc,  append  keep(TVdummy) nocon ctitle(National) bdec(3) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Municipality FE, YES, County FE, NO, Election year FE, YES)  
quietly glm turnout TVdummy i.CountyId i.year if nationalelection==1, link(identity)  family(binomial) vce(cluster knr)
outreg2 using AppendixB.doc,  append  keep(TVdummy) nocon ctitle(National) bdec(3) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Municipality FE, NO, County FE, YES, Election year FE, YES)  

* APPENDIX C. The IMPACT OF TV-licenses ON VOTER TURNOUT *************************************************************************************************
sort knr year
replace TVlicences1964=TVlicences1964/100
* Define TVlicences as shares rather than as percentages to match response variable
quietly glm turnout TVlicences1964 voterpct fvoterpct logpop settlement education i.CountyId if year==1965, link(identity) family(binomial) vce(robust)
margins, dydx(TVlicences1964) post
outreg2 using AppendixC.doc,  replace label ctitle(National) bdec(4) alpha(0.001, 0.01, 0.05) title("Appendix C. TV-licenses and voter turnout in the 1965 election") keep(TVlicences1964) addt(Control variables, YES, Turnout 1957, NO, Turnout 1961, NO, County FE, YES, Election year FE, YES) 
quietly glm turnout TVlicences1964 nationalturnout1957 voterpct fvoterpct logpop settlement education i.CountyId if year==1965, link(identity) family(binomial) vce(robust)
margins, dydx(TVlicences1964) post
outreg2 using AppendixC.doc,  append label ctitle(National) bdec(4) alpha(0.001, 0.01, 0.05) keep(TVlicences1964) addt(Control variables, YES, Turnout 1957, YES, Turnout 1961, NO, County FE, YES, Election year FE, YES) 
quietly glm turnout TVlicences1964 nationalturnout1957 nationalturnout1961 voterpct fvoterpct logpop settlement education i.CountyId if year==1965, link(identity) family(binomial) vce(robust)
margins, dydx(TVlicences1964) post
outreg2 using AppendixC.doc,  append label ctitle(National) bdec(4) alpha(0.001, 0.01, 0.05) keep(TVlicences1964) addt(Control variables, YES, Turnout 1957, YES, Turnout 1961, YES, County FE, YES, Election year FE, YES) 

* APPENDIX D. TESTING OF EXOGENIETY ASSUMPTION AS IN FIGURE 5. **********************************************************************************************************************
quietly reg tvyears19601987 logitlocalturnout1959 logitnationalturnout1957 dlogitlocalturnout19471959 dlogitnationalturnout19491957 if year==1957, vce(robust)
test logitlocalturnout1959=logitnationalturnout1957=dlogitlocalturnout19471959=dlogitnationalturnout19491957=0
local F1 = r(F)
local P1=r(p)
outreg2 using AppendixD.doc,  replace nocon  title("Appendix D. Balancing tests") /// 
keep(logitlocalturnout1959 logitnationalturnout1957 dlogitlocalturnout19471959 dlogitnationalturnout19491957) label  ctitle(All) bdec(3) alpha(0.001, 0.01, 0.05) /// 
addstat(F(Trends)>Test, `F1', P(Trends) > F, `P1') addt(Population FE, NO, County FE, NO, Covariates, NO)  

quietly reg tvyears19601987 logitlocalturnout1959 logitnationalturnout1957 dlogitlocalturnout19471959 dlogitnationalturnout19491957 c.logpop##i.CountyId if year==1957, vce(robust)
test logitlocalturnout1959=logitnationalturnout1957=dlogitlocalturnout19471959=dlogitnationalturnout19491957=0
local F1 = r(F)
local P1=r(p)
outreg2 using AppendixD.doc,  append nocon keep(logitlocalturnout1959 logitnationalturnout1957 dlogitlocalturnout19471959 dlogitnationalturnout19491957) label  ctitle(All) bdec(3) alpha(0.001, 0.01, 0.05) /// 
addstat(F(Trends)>Test, `F1', P(Trends) > F, `P1') addt(Population FE, YES, County FE, YES, Covariates, NO) 
quietly reg tvyears19601987 logitlocalturnout1959 logitnationalturnout1957 dlogitlocalturnout19471959 dlogitnationalturnout19491957 voterpct fvoterpct education settlement c.logpop##i.CountyId if year==1957, vce(robust)
test logitlocalturnout1959=logitnationalturnout1957=dlogitlocalturnout19471959=dlogitnationalturnout19491957=0
local F1 = r(F)
local P1=r(p)
test voterpct=fvoterpct=education=settlement=0
outreg2 using AppendixD.doc,  append nocon keep(logitlocalturnout1959 logitnationalturnout1957 dlogitlocalturnout19471959 dlogitnationalturnout19491957) label  ctitle(All) bdec(3) alpha(0.001, 0.01, 0.05) /// 
addstat(F(Trends)>Test, `F1', P(Trends) > F, `P1', F(Covariates) > Test, r(F), P(Covariates) > F, r(p)) addt(Population FE, YES, County FE, YES, Covariates, YES) 

* A supplementary test to show that the randomness of TV was first available in a local election, a national election or a non-election year. Not presented as table. **************** 
tabstat firstelection sameyear if year==1961, stats(mean n) 

* APPENDIX E ****LEAD-LAG PLOT **********************************************************************************************
sort knr year
by knr: gen l3dTVdummy=TVdummy[_n-3]
by knr: gen l2dTVdummy=TVdummy[_n-2]-TVdummy[_n-3]
by knr: gen l1dTVdummy=TVdummy[_n-1]-TVdummy[_n-2]
by knr: gen dTVdummy = TVdummy[_n-0]-TVdummy[_n-1]
by knr: gen f1dTVdummy=TVdummy[_n+1]-TVdummy[_n+0]
by knr: gen f2dTVdummy=TVdummy[_n+2]-TVdummy[_n+1]
by knr: gen f3dTVdummy=TVdummy[_n+3]-TVdummy[_n+2]

label var f3dTVdummy "-6 years" 
label var f2dTVdummy "-4 years" 
label var f1dTVdummy "-2 years" 
label var dTVdummy   "0 years" 
label var l1dTVdummy "+2 years"
label var l2dTVdummy "+4 years"
label var l3dTVdummy "+6 years and more"

quietly xtreg logitt f3dTVdummy f2dTVdummy f1dTVdummy dTVdummy l1dTVdummy l2dTVdummy l3dTVdummy voterpct fvoterpct logpop settlement education i.year c.nationalelection#i.knr c.trend#i.knr, fe vce(cluster knr)
coefplot, keep(f3dTVdummy f2dTVdummy f1dTVdummy dTVdummy l1dTVdummy l2dTVdummy l3dTVdummy) vertical yline(0) ytitle("Logit estimates") graphregion(color(white)) xtitle("Years before and after TV was available", size(small)) label("Fixed effects for municipality and years") ///
rename(f3dTVdummy="-6" f2dTVdummy="-4" f1dTVdummy="-2" dTVdummy="0" l1dTVdummy="2" l2dTVdummy="4"  l3dTVdummy="6 +") title("Logistic model specification") saving(Leadlag1, replace)
quietly xtreg turnout f3dTVdummy f2dTVdummy f1dTVdummy dTVdummy l1dTVdummy l2dTVdummy l3dTVdummy voterpct fvoterpct logpop settlement education i.year i.knr#c.nationalelection c.trend#i.knr, fe vce(cluster knr)
coefplot, keep(f3dTVdummy f2dTVdummy f1dTVdummy dTVdummy l1dTVdummy l2dTVdummy l3dTVdummy ) vertical yline(0)  graphregion(color(white)) xtitle("Years before and after TV was available", size(small)) ytitle("%") ///
rename(f3dTVdummy="-6" f2dTVdummy="-4" f1dTVdummy="-2" dTVdummy="0" l1dTVdummy="2" l2dTVdummy="4" l3dTVdummy="6 +") title("Linear model specification") saving(Leadlag2, replace)

graph combine "leadlag1" "leadlag2", xcommon graphregion(color(white)) title("Appendix E. The impact of TV-leads and -lags on voter turnout")  ///
note("Notes. Leads and lags have been coded as dummy variables indicating election years when TV was first available as well as"  ///
"election years before and after the arrival of television. 6+ indiates a dummy variable for all elections starting in the 6th year and after."  ///
"Both diagrams are estimated with the baseline model with fixed effects for municipalities and years."   ///
"The graphs show parameter estimates and corresponding 95% confidence intervals indicating the effects on voter turnout in" ///
"local and national elections.", size(vsmall)) saving(AppendixE.gph, replace)

* APPENDIX F. SUPPLEMENTARY ANALYSES WITH MOBILIZATION INDICATOR ***********************************************************************************************************************
xtset knr year
gen dturnout=turnout-l4.turnout
gen dlogitt=logitt-l4.logitt
gen mobshare=dturnout/(1-l4.turnout)
gen dtvnews=tvnews-l4.tvnews
* dTVdummy defined above
* gen dTVdummy=TVdummy-l4.TVdummy
gen dvoterpct=voterpct-l4.voterpct
gen dfvoterpct=fvoterpct-l4.fvoterpct
gen dsettlement=settlement-l4.settlement
gen deducation=education-l4.education
gen dlogpop=logpop-l4.logpop
gen mob=1-l4.turnout
lab var mobshare "Increase in voter turnout, relative to mobilization potential, %"
lab var dTVdummy "dTV=1"

quietly reg dlogitt dTVdummy dvoterpct dfvoterpct dsettlement dlogpop i.year if nationalelection==0, vce(cluster knr)
outreg2 using AppendixF.doc,  replace keep(dTVdummy) nocons label  ctitle(Local, FD) bdec(4) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Election year FE, YES) ///
title("Appendix G. First difference estimates")
quietly reg dturnout dTVdummy dvoterpct dfvoterpct dsettlement dlogpop i.year if nationalelection==0, vce(cluster knr)
outreg2 using AppendixF.doc,  append keep(dTVdummy) nocons label  ctitle(Local, FD-lin) bdec(4) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Election year FE, YES) 
quietly reg mobshare dTVdummy dvoterpct dfvoterpct dsettlement dlogpop i.year if nationalelection==0, vce(cluster knr)
outreg2 using AppendixF.doc,  append  keep(dTVdummy) nocons label  ctitle(Local, M) bdec(4) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Election year FE, YES)  

quietly reg dlogitt dTVdummy dvoterpct dfvoterpct dsettlement dlogpop i.year if nationalelection==1, vce(cluster knr)
outreg2 using AppendixF.doc,  append  keep(dTVdummy) nocons label  ctitle(National, FD) bdec(4) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Election year FE, YES)  
quietly reg dturnout dTVdummy dvoterpct dfvoterpct dsettlement dlogpop i.year if nationalelection==1, vce(cluster knr)
outreg2 using AppendixF.doc,  append  keep(dTVdummy) nocons label  ctitle(National, FD-lin) bdec(4) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Election year FE, YES)  
quietly reg mobshare dTVdummy dvoterpct dfvoterpct dsettlement dlogpop i.year if nationalelection==1, vce(cluster knr)
outreg2 using AppendixF.doc,  append  keep(dTVdummy) nocons label  ctitle(National, M) bdec(4) alpha(0.001, 0.01, 0.05) addt(Control variables, YES, Election year FE, YES)

* APPDENDIX G. DESCRIPTIVE STATISTICS FOR SURVEY DATA
 
* APPENDIX H. TELEVISION ACCESS
quietly spmap TVfirstyear using "C:\Users\FAG89001\Dropbox\SASDATA\Kommunekart\Koordinater fra NSD\muncoord.dta" if year==1983, id(id)  ///
legend(pos(5)) legend(subtitle("TV access", size(small))) subtitle("", pos(11)) ///
fcolor(green*1 green*0.8 green*0.6 green*0.4 green*0.2 yellow*0.2 yellow*0.4 yellow*0.6 yellow*0.8 yellow yellow yellow yellow yellow) clmethod(unique) ///
title("Appendix H. The timing of TV access in Norway", span) ///
note("The map displays the first year of TV access, measured at the muncipality level.", size(vsmall))  ///
saving(AppendixH.gph, replace)

* Removing unceccesary files *******************************************************************************************************************************************
erase tvplott1.gph 
erase tvplott2.gph 
erase lturnoutgraph.gph 
erase nturnoutgraph.gph 
erase trendwithcontrols.gph 
erase trendwithoutcontrols.gph 
erase turnoutwithcontrols.gph 
erase turnoutwithoutcontrols.gph 
erase TVAccessA.gph 
erase TVAccessB.gph 
erase Leadlag1.gph
erase Leadlag2.gph
erase Table1a.txt
erase Table1b.txt
erase Table2.txt
erase AppendixA.txt
erase AppendixB.txt
erase AppendixC.txt
erase AppendixD.txt
erase AppendixF.txt
****    FINISHED    ****    FINISHED    ****    FINISHED    ****    FINISHED    ****    FINISHED ****    FINISHED ****    FINISHED    ****    FINISHED    ******************    
