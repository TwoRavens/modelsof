* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ** Do-file for replication of results presented in the article "Partial Peace: Rebel Groups Inside and ** Outside of Civil war Settlements", Journal of Peace Research, July 2008. Note that this data should ** only be used for replication purposes. The data used in this article is based on previous versions  ** of the data from the Uppsala Conflict Database, and their data has been updated since the empirical * * research for this article was conducted. The most recent version of the data is available at the    ** homepage of the Uppsala Conflict Data Project (www.ucdp.uu.se).                                     *    * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **CREATE LOG**capture log closelog using PartialPeace-PA-2008-JPR, replace

**STSET SIGNATORY PEACE**
sort unique_id_ yearcapture drop first_year_of_peaceby unique_id_: egen first_year_of_peace = min(year)
gen start_of_segment = yeargen end_of_segment = year+.99
*Model 1 - stset with signatory peace*
stset end_of_segment, origin(time first_year_of_peace) enter(time start_of_segment) failure(endsig2event==1) exit(time .) id(unique_id_)*check stset*
list id_ unique_id start_of_segment end_of_segment first_year_of_peace _d _t if id_==24
list id_ unique_id start_of_segment end_of_segment first_year_of_peace _d _t if id_==2
**GENERATE & RECODE VARIABLES**gen politysquared=polity*politygen logungdp=ln(ungdp)
gen signprop =sign/nowpcon
gen sign2 = sign
recode sign2 3/max=0 2=1
generate anypk = 0
recode anypk 0=1 if unpk==1 
recode anypk 0=1 if nonunpk==1
generate WPdummy = nowpcon
recode WPdummy 2=0 3/max=1
generate Twoparty = nowpcon
recode Twoparty 2=1 3/max=0generate exmultiple=WPdummy*exclusive
generate nowpcon2 = nowpcon*nowpcon
generate chad = 0
recode chad 0=1 if id_==8
**DESCRIPTIVE STATS**
correlate exmultiple signprop Twoparty nowpcon anypact duration intensity incompatibility nonunpk unpk polity politysquared logungdpsummarize exmultiple signprop Twoparty nowpcon anypact duration intensity incompatibility nonunpk unpk polity politysquared logungdp**MAIN MODEL- (In article see Model 1, Table I)**stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog 
***MAIN MODEL with weibull***streg exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) dist(weibull) robust nolog**ALT.INCLUSION, weibull**streg inclusive nowpcon anypact duration intensity incompatibility nonunpk unpk, cluster(id_) dist(weibull) robust nologstreg signprop nowpcon anypact duration intensity incompatibility nonunpk unpk, cluster(id_) dist(weibull) robust nolog
**CLUSTER ON COUNTRY**
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(country_) robust nolog
**ADDITIONAL CONTROLS**
*polity*
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk polity politysquared, cluster(id_) robust nolog 
*ungdp*stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk logungdp, cluster(id_) robust nolog 
*signatories*stcox sign2 exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog stcox sign2 nowpcon anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog
*no.party-dummy*
stcox inclusive WPdummy anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog stcox signprop WPdummy anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog
*no.party-curvelinear*
stcox inclusive nowpcon nowpcon2 anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog stcox signprop nowpcon nowpcon2 anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog
**PROP.TEST**
capture drop sch* sca*stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, robust cluster(id) nolog nohr schoenfeld(sch*) scaledsch(sca*)stphtest, detailcapture drop sch* sca*stcox inclusive nowpcon anypact duration intensity incompatibility nonunpk unpk, robust cluster(id) nolog nohr schoenfeld(sch*) scaledsch(sca*)stphtest, detailcapture drop sch* sca*stcox signprop nowpcon anypact duration intensity incompatibility nonunpk unpk, robust cluster(id) nolog nohr schoenfeld(sch*) scaledsch(sca*)stphtest, detail
**BIVARIATE**stcox exmultiple Twoparty, robust cluster(id)
stcox inclusive, robust cluster(id)
stcox signprop, robust cluster(id)
***CHAD***stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog stcox exmultiple chad Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog 
****FIRST OUTLIER TEST****
**OUTLIERS MODEL SIGNATORY PEACE**
capture drop mgcapture drop dev xbcapture drop xb
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust mgale(mg) nohr nolog
*store the data in double format*predict double xb, xbscatter mg xbpredict double dev, deviancescatter dev xb
scatter dev xb if dev>1.5, mlabel(id_)scatter dev xb if dev<-1, mlabel(id_)
**models without: 22, 21, 29, 8, 34, 35, 6, 37, 15
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=22, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=21, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=29, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=8, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=34, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=35, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=6, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=37, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=15, cluster(id_)nolog********************************************************************************************************************STSET OVERALL PEACE***Model 2 - stset with overall peace, signatory and non-signatory peace**before stset with overall peace, it is neccessary to drop observations which have missing on end3event*drop if end3event==.stset end_of_segment, origin(time first_year_of_peace) enter(time start_of_segment) failure(end3event==1) exit(time .) id(unique_id_)**MAIN MODEL- (In article see Model 2, Table I)**stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog ***MAIN MODEL with weibull***streg exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) dist(weibull) robust nolog**ALT.INCLUSION, weibull**streg inclusive nowpcon anypact duration intensity incompatibility nonunpk unpk, cluster(id_) dist(weibull) robust nologstreg signprop nowpcon anypact duration intensity incompatibility nonunpk unpk, cluster(id_) dist(weibull) robust nolog**CLUSTER ON COUNTRY**stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(country_) robust nolog**ADDITIONAL CONTROLS***polity*stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk polity politysquared, cluster(id_) robust nolog *ungdp*stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk logungdp, cluster(id_) robust nolog *signatories*stcox sign2 exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog stcox sign2 nowpcon anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog*no.party-dummy*stcox inclusive WPdummy anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog stcox signprop WPdummy anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog*no.party-curvelinear*stcox inclusive nowpcon nowpcon2 anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog stcox signprop nowpcon nowpcon2 anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog**PROP.TEST**capture drop sch* sca*stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, robust cluster(id) nolog nohr schoenfeld(sch*) scaledsch(sca*)stphtest, detailcapture drop sch* sca*stcox inclusive nowpcon anypact duration intensity incompatibility nonunpk unpk, robust cluster(id) nolog nohr schoenfeld(sch*) scaledsch(sca*)stphtest, detailcapture drop sch* sca*stcox signprop nowpcon anypact duration intensity incompatibility nonunpk unpk, robust cluster(id) nolog nohr schoenfeld(sch*) scaledsch(sca*)stphtest, detail**BIVARIATE**stcox exmultiple Twoparty, robust cluster(id)stcox inclusive, robust cluster(id)stcox signprop, robust cluster(id)***CHAD***stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog stcox exmultiple chad Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog 
**OUTLIERS MODEL OVERALL PEACE**
capture drop mgcapture drop dev xbcapture drop xb
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust mgale(mg) nohr nolog
*store the data in double format*predict double xb, xbscatter mg xbpredict double dev, deviancescatter dev xbscatter dev xb if dev>1, mlabel(id_)scatter dev xb if dev<-1, mlabel(id_)
**models without: 21, 33, 39, 35, 15, 29
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=21, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=33, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=29, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=35, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=39, cluster(id_)nologstcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk if id_!=15, cluster(id_)nolog***OTHER STSETS****Alternative models - stset with signatories and non-signatories, including new parties**before stset with overall peace, it is neccessary to drop observations which have missing on end1event**/drop if end1event==.*/stset end_of_segment, origin(time first_year_of_peace) enter(time start_of_segment) failure(end1event==1) exit(time .) id(unique_id_)
stcox exmultiple Twoparty anypact duration intensity incompatibility nonunpk unpk, cluster(id_) robust nolog 