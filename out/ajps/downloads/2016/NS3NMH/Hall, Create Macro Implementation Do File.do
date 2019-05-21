
***This do file creates the replication dataset MacroImplementation.dta***

***Create Dataset***
*Data Source: Harold J. Spaeth, Lee Epstein, Andrew D. Martin, Jeffrey A. Segal, Theodore J. Ruger, and Sara C. Benesh. 2015 Supreme Court Database, Version 2015 Release 01. URL: http://Supremecourtdatabase.org *
*Cases Organized by Supreme Court Citation, 2014 Version 1*
use "SCDB_2014_01_caseCentered_Citation.dta", clear

drop if decisionDirection==3
recode decisionDirection 1=0 2=1

gen inc=1 if issueArea==1|issueArea==4
replace inc=0 if issue==10180|issue==10250|issue==40010|issue==40020|issue==40030|issue==40070
replace inc=0 if caseOrigin>299

gen coninc=1 if decisionDirection==0 & inc==1
replace coninc=-1 if decisionDirection==1 & inc==1
recode coninc .=0
gen conecon=1 if decisionDirection==0 & (issueArea==7 | issueArea==8)
replace conecon=-1 if decisionDirection==1 & (issueArea==7 | issueArea==8)
recode conecon .=0

collapse (sum) coninc conecon, by (term)

gen year=term+1
tsset year
gen cumconinc=coninc if year==1947
replace cumconinc=l.cumconinc+coninc if year>1947
gen cumconecon=conecon if year==1947
replace cumconecon=l.cumconecon+conecon if year>1947

***Merge with Enns Incarceration Data***
*Data Source: Enns, Peter K., 2014, "Replication data for: The Public's Increasing Punitiveness and Its Influence on Mass Incarceration in the United States", http://dx.doi.org/10.7910/DVN/24827, Harvard Dataverse, V2*
merge 1:1 year using "EnnsIncarcerationData.dta"
drop if _merge==2
drop _merge

***Merge with Total Incarcerations***
*Data Source: Sourcebook of Criminal Justice Statistics, http://www.albany.edu/sourcebook/about.html*
merge 1:1 year using USIncRate.dta
drop if _merge==2
drop _merge

***Merge with Total Population***
*Data Source: Sourcebook of Criminal Justice Statistics, http://www.albany.edu/sourcebook/about.html*
merge 1:1 year using USpop.dta
drop if _merge==2
drop _merge

***Merge with Collapsed State Commitments***
*Data Source: Sourcebook of Criminal Justice Statistics, http://www.albany.edu/sourcebook/about.html*
merge 1:1 year using StateComCol.dta
drop if _merge==2
drop _merge

***Merge with Congress Partisanship and Judicial Ideology Scores***
*Data Source: Martin-Quinn Scores, http://mqscores.berkeley.edu*
*Data Source: Segal-Cover Scores, http://supremecourtdatabase.org/data.php?s=5*
merge 1:1 year using jcs_medians.dta, keepusing(court zcourt seg_med zseg_med courtdems courtreps natpolicy dempres sdpercen hdpercen cdpercen )
drop _merge

***Merge with Criminal Justice Budget Data***
*Data Source: Policy Agendas Project, http://www.policyagendas.org*
merge 1:1 year using FedJusticeBudget.dta
drop if _merge==2
drop _merge
rename dllr just_spend
replace just_spend=just_spend/1000

***Merge with Common Space Scores***
*Vote View, http://voteview.com*
merge m:1 congress using CommonSpaceScores.dta, keepusing(SenMed HouseMed Pres)
drop if _merge==2
drop _merge

merge m:1 congress using PresCommonSpaceScores.dta, keepusing(dwnom2)
drop if _merge==2
drop _merge
rename dwnom2 Pres2

***Merge with Supreme Court Decision Making Rates***
*Data Source: Harold J. Spaeth, Lee Epstein, Andrew D. Martin, Jeffrey A. Segal, Theodore J. Ruger, and Sara C. Benesh. 2015 Supreme Court Database, Version 2015 Release 01. URL: http://Supremecourtdatabase.org *
*Cases Organized by Supreme Court Citation, 2014 Version 1*

merge 1:1 year using SCD_ConInc.dta
drop _merge

merge 1:1 year using SCD_ConRevInc.dta
drop _merge

merge 1:1 year using SCD_ConNonInc.dta
drop _merge

merge 1:1 year using SCD_ConRevNonInc.dta
drop _merge

merge 1:1 year using SCD_ConCrime.dta
drop _merge

merge 1:1 year using SCD_ConRevCrime.dta
drop _merge

merge 1:1 year using SCD_ConEcon.dta
drop _merge

***Merge with Mood***
*Data Source Policy+Mood, http://kelizabethcoggins.com/mood-policy-agendas/*
merge 1:1 year using moodcrime.dta
drop if _merge==2
drop _merge
gen con_crimemood=100-crimemood

***Merge with Federal Cases Filed***
*Data Source: Sourcebook of Criminal Justice Statistics, http://www.albany.edu/sourcebook/about.html*
merge 1:1 year using fed_cases_filed.dta
drop if _merge==2
drop _merge

***Merge with Federal Criminal Justice Statisics***
*Data Source: Sourcebook of Criminal Justice Statistics, http://www.albany.edu/sourcebook/about.html*
merge 1:1 year using fed_crim_justice.dta
drop if _merge==2
drop _merge

***Merge with Federal Punitive Laws***
*Original Data Provided collected by author available in MacroImplementaiton.dta*
merge 1:1 year using punitivelaws.dta
drop if _merge==2
drop _merge
recode pun .=0

***Merge with Retire and Death Data***
*Original data collected by author available in MacroImplementaiton.dta*
merge 1:1 year using /Users/mhall11/Dropbox/Research/ResearchFiles/rawdata/retiredeath.dta
drop _merge

***Merge with Segal Appointment and Retirement Scores***
*Orignal data created based on *Data Source: Segal-Cover Scores, http://supremecourtdatabase.org/data.php?s=5*
merge 1:1 year using /Users/mhall11/Dropbox/Research/ResearchFiles/rawdata/seg_app.dta
drop _merge
recode zappseglib .=0

merge 1:1 year using /Users/mhall11/Dropbox/Research/ResearchFiles/rawdata/seg_ret.dta
drop _merge
recode zretseglib .=0

replace zappseglib=l.zappseglib+zappseglib if year>1937
replace zretseglib=l.zretseglib+zretseglib if year>1937

***Merge with Punitive Sentiment***
*Data Source: Punitive Sentiment Project, http://www.public.asu.edu/~mdramir/punitive-sentiment-project.html*
merge 1:1 year using "/Users/mhall11/Box Sync/Research/ResearchFiles/rawdata/punitive_sentiment.dta"
drop if _merge==2
drop _merge

***Merge with Enns Punitiveness***
*Data Source: Enns, Peter K., 2014, "Replication data for: The Public's Increasing Punitiveness and Its Influence on Mass Incarceration in the United States", http://dx.doi.org/10.7910/DVN/24827, Harvard Dataverse, V2*
merge 1:1 year using "/Users/mhall11/Box Sync/Research/ResearchFiles/rawdata/Enns_AJPS2014rep.dta", keepusing(punitiveness)
drop if _merge==2
drop _merge

***Generate Variables***
tsset year

gen cumpun=pun if year==1947
replace cumpun=l.cumpun+pun if year>1947

gen def_rate=defendants/pop
gen conviction_rate=convicted/((convicted+acquitted)/1000)
gen incarceration_rate=imprisoned/(pop/10)
gen sentence_rate=sentenced/pop
gen file_rate=fed_cases_filed/(pop/10)
gen plea_rate=pleas/(defendants/1000)

gen totcomrate=totcom/pop
replace totcomrate=totcomrate*100000

reg cumpun year
predict cumpun_detr, resid

reg cumconinc year
predict cumconinc_detr, resid

gen drug1970=1 if year>1970
recode drug1970 .=0

gen drug1986=1 if year>1986
recode drug1986 .=0

gen drug1988=1 if year>1988
recode drug1988 .=0

gen terr1996=1 if year>1996
recode terr1996 .=0

gen CongId=(HouseMed+SenMed)/2

***Generate Instrumental Variable***
regress cumconinc retire
predict cumconinchat

***Generate Standardized and Time Variables***
tsset year

sum cumpun_detr
gen zcumpun_detr =(cumpun_detr-r(mean))/r(sd)

sum cumconinc
gen zcumconinc =(cumconinc-r(mean))/r(sd)

sum cumconinc_detr
gen zcumconinc_detr =(cumconinc_detr-r(mean))/r(sd)

sum repstrength
gen zrepstrength =(repstrength-r(mean))/r(sd)

sum incarceration_rate
gen zincarceration_rate =(incarceration_rate-r(mean))/r(sd)

replace seg_med=seg_med*-1
replace zseg_med=zseg_med*-1

gen reppres=1 if dempres==0
recode reppres .=0

gen srpercen=100-sdpercen
gen hrpercen=100-hdpercen

sum hrpercen
gen zhrpercen =(hrpercen-r(mean))/r(sd)

sum srpercen
gen zsrpercen =(srpercen-r(mean))/r(sd)

sum crimerate
gen zcrimerate =(crimerate-r(mean))/r(sd)

sum drugmortrate_ad
gen zdrugmortrate_ad =(drugmortrate_ad-r(mean))/r(sd)

sum file_rate
gen zfile_rate =(file_rate-r(mean))/r(sd)

sum conviction_rate
gen zconviction_rate =(conviction_rate-r(mean))/r(sd)

sum plea_rate
gen zplea_rate =(plea_rate-r(mean))/r(sd)

sum con_mood
gen zcon_mood =(con_mood-r(mean))/r(sd)

sum con_crimemood
gen zcon_crimemood =(con_crimemood-r(mean))/r(sd)

sum just_spend
gen zjust_spend =(just_spend-r(mean))/r(sd)

sum Pres
gen zPres =(Pres-r(mean))/r(sd)

egen zPres2=std(Pres2)

sum SenMed
gen zSenMed =(SenMed-r(mean))/r(sd)

sum HouseMed
gen zHouseMed =(HouseMed-r(mean))/r(sd)

sum high_low_inc
gen zhigh_low_inc =(high_low_inc-r(mean))/r(sd)

sum natpolicy
gen znatpolicy =(natpolicy-r(mean))/r(sd)

gen manmin=1 if year<1971|year>1986
recode manmin .=0

gen dconviction_rate=d.conviction_rate
gen lconviction_rate=l.conviction_rate

gen dConInc=d.ConInc
gen lConInc=l.ConInc

gen dConRevInc=d.ConRevInc
gen lConRevInc=l.ConRevInc

gen dincarceration_rate=d.incarceration_rate
gen lincarceration_rate=l.incarceration_rate

gen dinc_rate=d.inc_rate
gen linc_rate=l.inc_rate

gen dfile_rate=d.file_rate
gen lfile_rate=l.file_rate

gen dplea_rate=d.plea_rate
gen lplea_rate=l.plea_rate

gen dsentence_rate=d.sentence_rate
gen lsentence_rate=l.sentence_rate

gen dcumconinc=d.cumconinc
gen lcumconinc=l.cumconinc

gen dcumconinchat=d.cumconinchat
gen lcumconinchat=l.cumconinchat

gen dcumpun_detr=d.cumpun_detr
gen lcumpun_detr=l.cumpun_detr

gen ldreppres=ld.reppres
gen l2reppres=l2.reppres

gen dPres=d.Pres
gen lPres=l.Pres
gen ldPres=ld.Pres

gen dincrate=d.incrate
gen lincrate=l.incrate

gen dcrimerate=d.crimerate
gen lcrimerate=l.crimerate

gen ddrug= d.drugmortrate_ad
gen ldrug= l.drugmortrate_ad

gen dmanmin= d.manmin
gen lmanmin= l.manmin

gen drepstrength= d.repstrength
gen lrepstrength= l.repstrength

gen djust_spend=d.just_spend 
gen ljust_spend=l.just_spend

gen ddrug1970=d.drug1970 
gen ldrug1970= l.drug1970

gen ddrug1986=d.drug1986
gen ldrug1986=l.drug1986

gen dcon_mood=d.con_mood
gen lcon_mood=l.con_mood

gen dcon_crimemood=d.con_crimemood
gen lcon_crimemood=l.con_crimemood

gen dhigh_low_inc=d.high_low_inc
gen lhigh_low_inc=l.high_low_inc

gen dnatpolicy=d.natpolicy
gen lnatpolicy=l.natpolicy

gen dreppres= d.reppres
gen lreppres= l.reppres

gen dsrpercen= d.srpercen
gen lsrpercen= l.srpercen

gen dhrpercen= d.hrpercen
gen lhrpercen= l.hrpercen

gen dzPres= d.zPres
gen lzPres= l.zPres

gen ldzPres2= ld.zPres2

gen dzSenMed= d.zSenMed
gen lzSenMed= l.zSenMed

gen dzHouseMed= d.zHouseMed
gen lzHouseMed= l.zHouseMed

gen ld17zapp=ld17.zapp
gen l18zapp=l18.zapp

gen dcourt=d.court
gen lcourt=l.court

gen dcourtreps=d.courtreps
gen lcourtreps=l.courtreps

gen dCongId=d.CongId
gen lCongId=l.CongId

gen dzretseglib=d.zretseglib
gen lzretseglib=l.zretseglib

gen dzappseglib=d.zappseglib
gen lzappseglib=l.zappseglib

gen dcumconinc_detr=d.cumconinc_detr
gen lcumconinc_detr=l.cumconinc_detr

gen dPres2=d.Pres2
gen lPres2=l.Pres2
gen ldPres2=ld.Pres2

gen libinc=100-coninc
gen dlibinc=d.libinc
gen llibinc=l.libinc

gen libcourt=court*-1
gen dlibcourt=d.libcourt
gen llibcourt=l.libcourt

gen dpun_sent=d.pun_sent
gen lpun_sent=l.pun_sent

gen dpunitiveness=d.punitiveness
gen lpunitiveness=l.punitiveness

gen _dcumconinc=dcumconinc
gen _lcumconinc=lcumconinc
gen _dcumpun_detr=dcumpun_detr
gen _lcumpun_detr=lcumpun_detr
gen _ldPres2=ldPres2

***Create Variable Labels***
label variable dcrimerate "\hspace{5pt}$\Delta$ Crime Rate"
label variable lcrimerate "\hspace{5pt}Crime Rate$_{t-1}$"
label variable ddrug "\hspace{5pt}$\Delta$ Drug Use"
label variable ldrug "\hspace{5pt}Drug Use$_{t-1}$"
label variable dmanmin "\hspace{5pt}$\Delta$ Mandatory Minimums"
label variable lmanmin "\hspace{5pt}Mandatory Minimums\$_{t-1}$"
label variable drepstrength "\hspace{5pt}$\Delta$ Republican Party Strength"
label variable lrepstrength "\hspace{5pt}Republican Party Strength$_{t-1}$"
label variable djust_spend "\hspace{5pt}$\Delta$ Criminal Justice \hspace{15pt}Spending"
label variable ljust_spend "\hspace{5pt}Criminal Justice \hspace{15pt}Spending$ _{t-1}$"
label variable dConInc "\hspace{5pt}$\Delta$ \% Conservative Decisions"
label variable lConInc "\hspace{5pt}\% Conservative Decisions\$_{t-1}$"
label variable dConRevInc "\hspace{5pt}$\Delta$ \% Conservative Reversals"
label variable lConRevInc "\hspace{5pt}\% Conservative Reversals\$_{t-1}$"
label variable lincarceration_rate "\hspace{5pt}Incarceration$_{t-1}$" 
label variable ddrug1970 "\hspace{5pt}$\Delta$ 1970 Controlled Substances Act"
label variable ldrug1970 "\hspace{5pt}1970 Controlled Substances Act\$_{t-1}$"
label variable ddrug1986 "\hspace{5pt}$\Delta$ 1986 Anti-Drug Abuse Act"
label variable ldrug1986 "\hspace{5pt}1986 Anti-Drug Abuse Act\$_{t-1}$"
label variable dcon_mood "\hspace{5pt}$\Delta$ Policy Mood"
label variable lcon_mood "\hspace{5pt}Policy Mood\$_{t-1}$"
label variable dcon_crimemood "\hspace{5pt}$\Delta$ Criminal Justice \hspace{15pt}Mood"
label variable lcon_crimemood "\hspace{5pt}Criminal Justice \hspace{15pt}Mood$ _{t-1}$"
label variable dhigh_low_inc "\hspace{5pt}$\Delta$ Economic \hspace{15pt}Inequality"
label variable lhigh_low_inc "\hspace{5pt}Economic \hspace{15pt}Inequality$ _{t-1}$"
label variable dnatpolicy "\hspace{5pt}$\Delta$ National Policy"
label variable lnatpolicy "\hspace{5pt}National Policy\$_{t-1}$"
label variable dreppres "\hspace{5pt}$\Delta$ Republican \hspace{15pt}President"
label variable lreppres "\hspace{5pt}Republican \hspace{15pt}President$ _{t-1}$"
label variable dsrpercen "\hspace{5pt}$\Delta$ \% Senate Republican"
label variable lsrpercen "\hspace{5pt}\% Senate Republican\$_{t-1}$"
label variable dhrpercen "\hspace{5pt}$\Delta$ \% House Republican"
label variable lhrpercen "\hspace{5pt}\% House Republican\$_{t-1}$" 
label variable dzPres "\hspace{5pt}$\Delta$ President Ideology"
label variable lzPres "\hspace{5pt}President Ideology\$_{t-1}$"
label variable dzSenMed "\hspace{5pt}$\Delta$ Senate Ideology"
label variable lzSenMed "\hspace{5pt}Senate Ideology\$_{t-1}$"
label variable dzHouseMed "\hspace{5pt}$\Delta$ House Ideology"
label variable lzHouseMed "\hspace{5pt}House Ideology\$_{t-1}$"
label variable dcumpun_detr "\hspace{5pt}$\Delta$ Congressional \hspace{15pt}Policy"
label variable lcumpun_detr "\hspace{5pt}Congressional \hspace{15pt}Policy$ _{t-1}$"
label variable _dcumpun_detr "\hspace{5pt}$\Delta$ Congressional Policy"
label variable _lcumpun_detr "\hspace{5pt}Congressional Policy$ _{t-1}$"
label variable dcumconinc "\hspace{5pt}$\Delta$ Supreme Court \hspace{15pt}Policy"
label variable lcumconinc "\hspace{5pt}Supreme Court \hspace{15pt}Policy$ _{t-1}$"
label variable _dcumconinc "\hspace{5pt}$\Delta$ Supreme Court Policy"
label variable _lcumconinc "\hspace{5pt}Supreme Court Policy$ _{t-1}$"
label variable ldreppres "\hspace{5pt}$\Delta$ Republican \hspace{15pt}President$ _{t-1}$"
label variable dfile_rate "\hspace{5pt}$\Delta$ Case Filings"
label variable lfile_rate "\hspace{5pt}Case Filings\$_{t-1}$"
label variable dconviction_rate "\hspace{5pt}$\Delta$ Conviction Rate"
label variable lconviction_rate "\hspace{5pt}Conviction Rate$ _{t-1}$"
label variable dplea_rate "\hspace{5pt}$\Delta$ Plea Bargaining"
label variable lplea_rate "\hspace{5pt}Plea Bargaining\$_{t-1}$"
label variable dPres2 "\hspace{5pt}$\Delta$ Presidential \hspace{15pt}Preferences"
label variable lPres2 "\hspace{5pt}Presidential \hspace{15pt}Preferences$ _{t-1}$"
label variable ldPres "\hspace{5pt}$\Delta$ 1st Dimension \hspace{15pt}CS Scores$ _{t-1}$"
label variable dcourt "\hspace{5pt}$\Delta$ Supreme Court Conservatism"
label variable lcourt "\hspace{5pt}Supreme Court Conservatism$ _{t-1}$"
label variable dcourtreps "\hspace{5pt}$\Delta$ Supreme Court Republicans"
label variable lcourtreps "\hspace{5pt}Supreme Court Republicans$ _{t-1}$"
label variable dCongId "\hspace{5pt}$\Delta$ Congressional Consevatism"
label variable lCongId "\hspace{5pt}Congressional Consevatism$ _{t-1}$"
label variable dzretseglib "\hspace{5pt}$\Delta$ Departure \hspace{15pt}Liberalism"
label variable lzretseglib "\hspace{5pt}Departure \hspace{15pt}Liberalism$ _{t-1}$"
label variable dzappseglib "\hspace{5pt}$\Delta$ Appointment \hspace{15pt}Liberalism"
label variable lzappseglib "\hspace{5pt}Appointment \hspace{15pt}Liberalism$ _{t-1}$"
label variable l18zapp "\hspace{5pt}Appointment \hspace{15pt}Liberalism$ _{t-18}$"
label variable dcumconinc_detr "\hspace{5pt}$\Delta$ Detrended Supreme \hspace{15pt}Court Policy"
label variable lcumconinc_detr "\hspace{5pt}Detrended Supreme \hspace{15pt}Court Policy$ _{t-1}$"
label variable ldPres2 "\hspace{5pt}$\Delta$ Presidential \hspace{15pt}Preferences$ _{t-1}$"
label variable _ldPres2 "\hspace{5pt}$\Delta$ Presidential Preferences$ _{t-1}$"
label variable dlibinc "\hspace{10pt}$\Delta$ Liberal Incarceration Decisions"
label variable llibinc "\hspace{10pt}\% Liberal Incarceration Decisions$ _{t-1}$"
label variable dlibcourt "\hspace{10pt}$\Delta$ U.S. Supreme Court"
label variable llibcourt "\hspace{10pt}U.S. Supreme Court$ _{t-1}$"
label variable dpun_sent "\hspace{5pt}$\Delta$ Punitive \hspace{15pt}Sentiment"
label variable lpun_sent "\hspace{5pt}Punitive \hspace{15pt}Sentiment$ _{t-1}$"
label variable dpunitiveness "\hspace{5pt}$\Delta$ Tough on Crime \hspace{15pt}Opinion"
label variable lpunitiveness "\hspace{5pt}Tough on Crime \hspace{15pt}Opinion$ _{t-1}$"


reg dcumconinc lcumconinc d.zret l.zret dcumpun_detr lcumpun_detr ldPres2 lPres2 dcrimerate lcrimerate ddrug ldrug l18zapp
predict dhat

gen hat=dhat if year==1955
replace hat=l.hat+dhat if year>1955
gen lhat=l.hat
label variable dhat "\hspace{5pt}$\Delta$ Supreme Court \hspace{15pt}Policy Instrument"
label variable lhat "\hspace{5pt}Supreme Court \hspace{15pt}Policy Instrument$ _{t-1}$"



tsset year

save "/Users/mhall11/Dropbox/Research/IncarcerationProject/Data/Incarceration.dta", replace


