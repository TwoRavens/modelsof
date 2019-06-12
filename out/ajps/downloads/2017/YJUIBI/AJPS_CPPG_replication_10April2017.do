/// Replicaiton file for "The Fulfillment of Parties' Election Pledges"
/// Thomson, Royed, Naurin, Artes, Costello, Ennser-Jedenastik, Ferguson, Kostadinova, Moury, Petry and Praprotnik
/// American Journal of Political Science
/// 10th April 2017

/// file: AJPS_CPPG_pledges_10April2017.dta
use AJPS_CPPG_pledges_10April2017.dta

set more off
/// Table 2 Model 1 - first model gives b; second model with or option gives e^b coefficients
logit fulfil2  gtsinmin gtcomaj gtcomin ///
presidential semipres  bicameral federal EUmember ///
growav xtimeyrs opppreel outalways npledgediv10 precoagree y1980s y1990s y2000s subset /// 
if govparty==1 & sq==0 &  excllink!=1 [pweight=sampwtmod7770], vce (cluster idmanifesto)
logit fulfil2  gtsinmin gtcomaj gtcomin ///
presidential semipres  bicameral federal EUmember ///
growav xtimeyrs opppreel outalways npledgediv10 precoagree y1980s y1990s y2000s subset /// 
if govparty==1 & sq==0 &  excllink!=1 [pweight=sampwtmod7770], vce (cluster idmanifesto) or

/// Table 2 Model 2 - first model gives b; second model with or option gives e^b coefficients
logit fulfil2  gtsinmin gtcomaj gtcomin ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if govparty==1 & sq==0 &  excllink!=1 [pweight=sampwtmod7770], vce (cluster idmanifesto)
logit fulfil2  gtsinmin gtcomaj gtcomin ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if govparty==1 & sq==0 &  excllink!=1 [pweight=sampwtmod7770], vce (cluster idmanifesto) or

/// Table 3 Model 1 Single-party governments - first model gives b; second model with or option gives e^b coefficients
logit fulfil2  gtminless3yrs gtminmore3yrs /// 
presidential semipres  bicameral  federal   /// 
growav opppreel outalways npledgediv10 degomedlogrile y1980s y1990s y2000s subset /// 
if coalition ==0 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod2946], vce (cluster idmanifesto)
logit fulfil2  gtminless3yrs gtminmore3yrs /// 
presidential semipres  bicameral  federal   /// 
growav opppreel outalways npledgediv10 degomedlogrile y1980s y1990s y2000s subset /// 
if coalition ==0 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod2946], vce (cluster idmanifesto) or

/// Table 3 Model 2 Coalitions - first model gives b; second model with or option gives e^b coefficients
logit fulfil2   gtmajless3yrs  gtminmore3yrs ///
ministry chex ///
govlogrilerange HHgovpr pledgecoagree ///
bicameral federal  /// 
growav opppreel outalways npledgediv10 precoagree degomedlogrile y1990s y2000s subset /// 
if coalition==1 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod4021], vce (cluster idmanifesto)
logit fulfil2   gtmajless3yrs  gtminmore3yrs ///
ministry chex ///
govlogrilerange HHgovpr pledgecoagree ///
bicameral federal  /// 
growav opppreel outalways npledgediv10 precoagree degomedlogrile y1990s y2000s subset /// 
if coalition==1 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod4021], vce (cluster idmanifesto) or

/// Figure 1, Fulfillment by country. Descriptives
set more off
/// uk - check 575 359 (14.09 of gov unfulfilled)
tab fulfil3 govparty if country==2, col
/// se check 487 106 (20.74 of gov unfulfilled)
tab fulfil3 govparty if country==5, col
/// pt check 248 615 (21.37 of gov unfulfilled)
tab fulfil3 govparty if country==9, col
/// es check 348 980 (28.45 of gov unfulfilled) only dichotomous measure of fulfillment
tab fulfil2 govparty if country==6, col
/// ca check 828 2712 (31.76 of gov unfulfilled)
tab fulfil3 govparty if country==11, col
/// de check 671 712 (37.56 of gov unfulfilled)
tab fulfil3 govparty if country==7, col
/// us check 674 795 (38.13 of gov unfulfilled)
tab fulfil3 govparty if country==1, col
/// nl check 575 430 (43.30 of gov unfulfilled)
tab fulfil3 govparty if country==3, col
/// ie check 1865 2047 (47.88 gov unfulfilled)
tab fulfil3 govparty if country==4, col
/// bu check 988 1688 (48.48 of gov unfulfilled)
tab fulfil3 govparty if country==10, col
/// at check 1254 446 (50.24 gov unfulfilled)
tab fulfil3 govparty if country==12, col
/// it check 620 gov only (54.35 of gov unfulfilled) only dichotomous measure of fulfillment
tab fulfil2 govparty if country==8, col
/// all - 20023 pledges - 9133 gov (59.55 percent fulfilled) - 10890 opp (34.29 per fulfilled)
tab fulfil2 govparty, col chi
/// sinmaj gov 1575 opp 2909 (74.03 gov fulfilled)
tab fulfil2 govparty if gtsinmaj==1, col
/// sinmin gov 1667 opp 3549 (65.51 gov fulfilled)
tab fulfil2 govparty if gtsinmin==1, col
/// comaj gov 4878 opp 4126 (52.93 gov fulfilled)
tab fulfil2 govparty if gtcomaj==1, col
/// comin gov 1013 opp 306 (59.13 gov fulfilled)
tab fulfil2 govparty if gtcomin==1, col

/// Dataset for Figure 1 contains the descriptive statistics derived from the above commands
/// file: AJPS_CPPG_Figure1_10April2017.dta
use AJPS_CPPG_Figure1_10April2017.dta
graph bar (asis) fful pful fpfulonly, over(govopp) over(order) ylabel(0(10)100) ///
stack ytitle(Percentage fulfilled pledges) scheme(s1mono) blabel(bar)
/// Edited graph in Stata to produce figure in article

/// Predicted probabilities for Figure 2, derived from Model 2 in Table 2
use AJPS_CPPG_pledges_10April2017.dta
/// SPost user package (Long and Freese, 2006, Regression Models for Categorical Dependent Variables Using Stata [Stata Press])
/// http://www.indiana.edu/~jslsoc/stata/
/// Table 2 Model 2
logit fulfil2  gtsinmin gtcomaj gtcomin ///
ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if govparty==1 & sq==0 &  excllink!=1 [pweight=sampwtmod7770], vce (cluster idmanifesto)
/// single party minorities, p=.8211
prvalue, x(gtsinmin=1 gtcomaj=0 gtcomin=0 ministry=1 chex=1 govlogrilerange=0 HHgovpr=1   /// 
presidential=0 semipres=0  bicameral=1 federal=0 EUmember=1 growav=2.45 xtimeyrs=3.71 /// 
opppreel=0 outalways=0 npledgediv10=17.74 precoagree=0 degomedlogrile=0 y1980s=0 y1990s=0 y2000s=1 subset=0)
/// single party majorities, p=.7605
prvalue, x(gtsinmin=0 gtcomaj=0 gtcomin=0 ministry=1 chex=1 govlogrilerange=0 HHgovpr=1   /// 
presidential=0 semipres=0  bicameral=1 federal=0 EUmember=1 growav=2.45 xtimeyrs=3.71 /// 
opppreel=0 outalways=0 npledgediv10=17.74 precoagree=0 degomedlogrile=0 y1980s=0 y1990s=0 y2000s=1 subset=0)
/// coalition majority SNR, p=.6108
prvalue, x(gtsinmin=0 gtcomaj=1 gtcomin=0 ministry=1 chex=1 govlogrilerange=.65 HHgovpr=.60   ///
presidential=0 semipres=0  bicameral=1 federal=0 EUmember=1 growav=2.45 xtimeyrs=3.71 /// 
opppreel=0 outalways=0 npledgediv10=17.74 precoagree=0 degomedlogrile=.25 y1980s=0 y1990s=0 y2000s=1 subset=0)
/// coalition minority SNR, p=.6097
prvalue, x(gtsinmin=0 gtcomaj=0 gtcomin=1 ministry=1 chex=1 govlogrilerange=.65 HHgovpr=.60   /// 
presidential=0 semipres=0  bicameral=1 federal=0 EUmember=1 growav=2.45 xtimeyrs=3.71 /// 
opppreel=0 outalways=0 npledgediv10=17.74 precoagree=0 degomedlogrile=.25 y1980s=0 y1990s=0 y2000s=1 subset=0)
/// coalition majority JNR, p=.5027
prvalue, x(gtsinmin=0 gtcomaj=1 gtcomin=0 ministry=1 chex=0 govlogrilerange=.65 HHgovpr=.60   /// 
presidential=0 semipres=0  bicameral=1 federal=0 EUmember=1 growav=2.45 xtimeyrs=3.71 /// 
opppreel=0 outalways=0 npledgediv10=17.74 precoagree=0 degomedlogrile=.25 y1980s=0 y1990s=0 y2000s=1 subset=0)
/// coalition minority JNR, p=.5015
 prvalue, x(gtsinmin=0 gtcomaj=0 gtcomin=1 ministry=1 chex=0 govlogrilerange=.65 HHgovpr=.60   /// 
presidential=0 semipres=0  bicameral=1 federal=0 EUmember=1 growav=2.45 xtimeyrs=3.71 /// 
opppreel=0 outalways=0 npledgediv10=17.74 precoagree=0 degomedlogrile=.25 y1980s=0 y1990s=0 y2000s=1 subset=0)

/// Dataset for Figure 2 contains the estimated probabilities derived from the above commands
/// file: AJPS_CPPG_Figure2_10April2017.dta
use AJPS_CPPG_Figure2_10April2017.dta
twoway (rcap prfullb4f2 prfulub4f2 gttyp) ///
(scatter prfulpointf2 gttyp), ///
 ylabel(0(.1)1) ytitle("Probability of fulfillment") ///
 ylabel(, ticks labels valuelabel grid gmax gmin) ///
 legend(off) ///
scheme(s1mono)
/// Edited graph in Stata to produce figure in article

/// Online Supporting Information
set more off
/// Table SI.1a Additional analyses regarding minority governments
/// Table SI.1a Model 1 All governments
logit fulfil2  cat2sinminWITHsup cat3sinminNOsup gtcomaj cat4cominWITHsup cat5cominNOsup  /// 
ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset ///
if govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod7770], vce (cluster idmanifesto) 

/// Table SI.1a Model 2 All governments excluding Spain
logit fulfil2  cat2sinminWITHsup cat3sinminNOsup gtcomaj cat4cominWITHsup cat5cominNOsup  /// 
ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if country!=6 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod7422], vce (cluster idmanifesto) 

/// Table SI.1a Model 3 Minority single-party governments only (excluding US)
logit fulfil2  negparl /// 
growav opppreel outalways npledgediv10 partymv y1990s y2000s subset /// 
if country!=1 & gtsinmin==1 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod1089], vce (cluster idmanifesto) 
/// same model no cluster
logit fulfil2  negparl /// 
growav opppreel outalways npledgediv10 partymv y1990s y2000s subset /// 
if country!=1 & gtsinmin==1 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod1089]

/// Table SI.2 Models applied to subsets of cases
/// Table SI.2 Model 1 Excluding US
logit fulfil2  gtsinmin gtcomaj gtcomin ///
ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if country!=1 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod7230], vce (cluster idmanifesto)

/// Table SI.2 Model 2 Chief exec parties only
logit fulfil2  gtsinmin gtcomaj gtcomin /// 
ministry  ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if chex==1 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod5983], vce (cluster idmanifesto)

/// Table SI.2 Model 3 All policy areas included
logit fulfil2  gtsinmin gtcomaj gtcomin /// 
ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if subset==0 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod6946], vce (cluster idmanifesto)

/// Table SI.3a Models with fixed effects for countreis (All governments)
/// Table SI.3a Model 1
logit fulfil2  gtsinmin gtcomaj gtcomin /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree y1980s y1990s y2000s subset /// 
  SEdum PTdum ESdum CAdum DEdum USdum NLdum BUdum ATdum ITdum IEdum /// UK as REF
if govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod7770], vce (cluster idmanifesto)

/// Table SI.3a Model 2
logit fulfil2  gtsinmin gtcomaj gtcomin /// 
ministry chex ///
govlogrilerange HHgovpr growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile  /// 
y1980s y1990s y2000s subset /// 
SEdum PTdum ESdum CAdum DEdum USdum NLdum BUdum ATdum ITdum IEdum /// UK as REF
if govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod7770], vce (cluster idmanifesto)

/// Table SI.3b Models with fixed effects for countries (Single-party governments and coalitions examined separately)
/// Table SI.3b Model 1 Single-party governments
logit fulfil2  gtmajless3yrs gtminless3yrs gtminmore3yrs /// 
growav opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
SEdum PTdum ESdum CAdum DEdum USdum NLdum BUdum ATdum ITdum IEdum /// UK as REF
if coalition==0 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod2946], vce (cluster idmanifesto)

/// Table SI.3b Model 2 Coalitions
logit fulfil2   gtmajless3yrs gtminless3yrs gtminmore3yrs /// 
ministry chex ///
govlogrilerange HHgovpr   /// 
pledgecoagree growav opppreel outalways npledgediv10 precoagree degomedlogrile y1990s y2000s subset /// 
SEdum PTdum ESdum CAdum  USdum NLdum BUdum IEdum ATdum ITdum  ///  DE as REF
if govparty==1 & sq==0 & coalition==1 & excllink!=1 [pweight=sampwtmod4021], vce (cluster idmanifesto)

/// Table SI.4 Models with detailed coding of pledge type
/// Table SI.4 Model 1
logit fulfil2  gtsinmin gtcomaj gtcomin ///
presidential  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree y1980s y1990s y2000s subset /// 
typtaxcut typexpand typcut typtaxincr typoutcome  ///
if govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod4305] , vce (cluster idmanifesto)

/// Table SI.4 Model 2
logit fulfil2  gtsinmin gtcomaj gtcomin /// 
ministry chex ///
govlogrilerange HHgovpr ///
presidential bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
typtaxcut typexpand typcut typtaxincr typoutcome  /// 
if govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod4305], vce (cluster idmanifesto)

/// Table SI.5 The effects of different operationalisations of GDP growth and the size fo the public sector on pledge fulfillment
/// Table SI.5 Model 1
logit fulfil2  gtsinmin gtcomaj gtcomin /// 
ministry chex ///
govlogrilerange HHgovpr   ///
presidential semipres  bicameral federal EUmember /// 
growey xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod7770], vce (cluster idmanifesto)

/// Table SI.5 Model 2
logit fulfil2  gtsinmin gtcomaj gtcomin /// 
ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y2000s subset /// 
pubexpgdpwb /// 
if govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod4279] , vce (cluster idmanifesto)

/// Table SI.6a Multinomial model of all governments
mlogit fulfil3  gtsinmin gtcomaj gtcomin /// 
ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod6813] , vce (cluster idmanifesto) baseoutcome(0) 
/// same model without cluster
mlogit fulfil3  gtsinmin gtcomaj gtcomin /// 
ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod6813] ,  baseoutcome(0) 

/// Table SI.6b Multinomial models of single-party governments and coalitions examined separately
/// Table SI.6b Model 1 Single-party governments
mlogit fulfil3  gtmajless3yrs gtminless3yrs gtminmore3yrs ///
presidential semipres  bicameral  federal   /// 
growav opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if coalition ==0 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod2598], vce (cluster idmanifesto)  baseoutcome(0) 
/// same model without cluster
mlogit fulfil3  gtmajless3yrs gtminless3yrs gtminmore3yrs ///
presidential semipres  bicameral  federal   /// 
growav opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset /// 
if coalition ==0 & govparty==1 & sq==0 & excllink!=1 [pweight=sampwtmod2598], baseoutcome(0) 

/// Table SI.6b Coalitions
mlogit fulfil3  gtmajless3yrs gtminless3yrs gtminmore3yrs /// 
ministry chex ///
govlogrilerange HHgovpr pledgecoagree /// 
presidential semipres  bicameral federal  /// 
growav opppreel outalways npledgediv10 precoagree degomedlogrile y1990s y2000s subset /// 
if govparty==1 & sq==0 & coalition==1 & excllink!=1 [pweight=sampwtmod4021], vce (cluster idmanifesto) baseoutcome(0) 
/// same model without cluster
mlogit fulfil3   gtmajless3yrs gtminless3yrs gtminmore3yrs /// 
ministry chex ///
govlogrilerange HHgovpr pledgecoagree /// 
presidential semipres  bicameral federal  /// 
growav opppreel outalways npledgediv10 precoagree degomedlogrile y1990s y2000s subset /// 
if govparty==1 & sq==0 & coalition==1 & excllink!=1 [pweight=sampwtmod4021], baseoutcome(0) 

/// Table SI.7 Models with platforms as cases
/// file AJPS_CPPG_platforms_2March2017.dta"
clear all
/// file: AJPS_CPPG_pledges_2March2017.dta
use AJPS_CPPG_platforms_2March2017.dta

/// Table SI.7 Model 1
glm fulfil2 gtsinmin coalition chex  ///
, link(logit) family(binomial) robust nolog cluster(country)
test
/// Table SI.7 Model 2
glm fulfil2 gtsinmin coalition chex ///
govlogrilerange HHgovpr presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile  /// 
y1980s y1990s y2000s subset ///
, link(logit) family(binomial) robust nolog cluster(country)
test

/// Table SI.8 Descriptive statistics
/// file: AJPS_CPPG_pledges_10April2017.dta
use AJPS_CPPG_pledges_10April2017.dta
summarize fulfil2  gtsinmin gtsinmaj gtcomaj gtcomin ministry chex ///
govlogrilerange HHgovpr   /// 
presidential semipres  bicameral federal EUmember /// 
growav xtimeyrs opppreel outalways npledgediv10 precoagree degomedlogrile y1980s y1990s y2000s subset if sampwtmod7770!=.
summarize  gtminless3yrs gtminmore3yrs if sampwtmod2946!=.
summarize gtmajless3yrs  gtminmore3yrs pledgecoagree if sampwtmod4021!=.

/// END
  
