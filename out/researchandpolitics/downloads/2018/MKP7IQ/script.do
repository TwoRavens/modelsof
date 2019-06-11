***************************
*desrciptive statistics****
***************************
summarize agea if e(sample)==1
summarize rtrd if e(sample)==1
summarize above_early if e(sample)==1
summarize above_full if e(sample)==1
summarize eduyrs if e(sample)==1
summarize ever_child if e(sample)==1
summarize lrscale if e(sample)==1
summarize brncntr if e(sample)==1
summarize rural if e(sample)==1
summarize married if e(sample)==1
summarize hinctnta if e(sample)==1
summarize imbgeco if e(sample)==1
summarize imtcjob if e(sample)==1
summarize imbleco if e(sample)==1
tab iscoco10  if e(sample)==1
tab country if e(sample)==1
tab rtrd cntry if e(sample)==1
summarize agea if treatment==1 & rtrd==0
summarize agea if treatment==2 & rtrd==0
summarize agea if treatment==1 & rtrd==1
summarize agea if treatment==2 & rtrd==1
summarize hinctnta if treatment==1 & rtrd==0
summarize hinctnta if treatment==2 & rtrd==0
summarize hinctnta if treatment==1 & rtrd==1
summarize hinctnta if treatment==2 & rtrd==1
summarize ever_child if treatment==1 & rtrd==0
summarize ever_child if treatment==2 & rtrd==0
summarize ever_child if treatment==1 & rtrd==1
summarize ever_child if treatment==2 & rtrd==1
summarize married if treatment==1 & rtrd==0
summarize married if treatment==2 & rtrd==0
summarize married if treatment==1 & rtrd==1
summarize married if treatment==2 & rtrd==1
summarize brncntr if treatment==1 & rtrd==0
summarize brncntr if treatment==2 & rtrd==0
summarize brncntr if treatment==1 & rtrd==1
summarize brncntr if treatment==2 & rtrd==1
summarize rural if treatment==1 & rtrd==0
summarize rural if treatment==2 & rtrd==0
summarize rural if treatment==1 & rtrd==1
summarize rural if treatment==2 & rtrd==1
summarize lrscale if treatment==1 & rtrd==0
summarize lrscale if treatment==2 & rtrd==0
summarize lrscale if treatment==1 & rtrd==1
summarize lrscale if treatment==2 & rtrd==1
tab iscoco10 if treatment==1 & rtrd==0
tab iscoco10 if treatment==2 & rtrd==0
tab iscoco10 if treatment==1 & rtrd==1
tab iscoco10 if treatment==2 & rtrd==1
tab cntry if treatment==1 & rtrd==0
tab cntry if treatment==2 & rtrd==0
tab cntry if treatment==1 & rtrd==1
tab cntry if treatment==2 & rtrd==1
**********************
******descriptive*****
pwcorr full_retire_age imbgeco, sig
corr full_retire_age imtcjob
corr full_retire_age imbleco
corr early_retire_age imbgeco 
corr early_retire_age imtcjob
corr early_retire_age imbleco
***********************
*********OLS***********
***********************
regress imbgeco rtrd eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust 
regress imtcjob rtrd eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust 
regress imbleco rtrd eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust 
***********************
*****IV models*********
***********************
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust first
estat firststage
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust first
estat firststage
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust first
estat firststage
***********************
***survey experiment***
***********************
graph bar if rtrd==1, over(entry_allow) over(treatment) 
ologit entry_allow i.treatment i.country i.iscoco10
ologit entry_allow i.treatment i.country i.iscoco10 if rtrd==0 
listcoef, help
ologit entry_allow i.treatment i.country i.iscoco10 if rtrd==1 
listcoef, help
*retirement as interaction (not sub group)
ologit entry_allow i.treatment##i.rtrd i.country i.iscoco10 
**********************
**robustness checks***
**********************
*survey experiment hetergenous impact by skill
ologit entry_allow i.treatment##i.lowskill i.country if rtrd==1
ologit entry_allow i.treatment##i.highskill i.country if rtrd==1
ologit entry_allow i.treatment##i.lowed i.country if rtrd==1
ologit entry_allow i.treatment##i.lowed i.country if rtrd==0
*also not significant when considering cultural impact of immigration
ivregress 2sls imueclt (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust first
*drop one country
*w/o AT
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="AT", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="AT", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="AT", robust 
*w/o BE
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="BE", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="BE", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="BE", robust 
*w/o DK
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="DK", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="DK", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="DK", robust 
*w/o FI
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="FI", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="FI", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="FI", robust 
*w/o FR
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="FR", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="FR", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="FR", robust 
*w/o DE
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="DE", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="DE", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="DE", robust 
*w/o IE
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="IE", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="IE", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="IE", robust 
*w/o NL
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="NL", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="NL", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="NL", robust 
*w/o NO
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="NO", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="NO", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="NO", robust 
*w/o PT
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="PT", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="PT", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="PT", robust 
*w/o ES
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="ES", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="ES", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="ES", robust 
*w/o SE
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="SE", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="SE", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="SE", robust 
*w/o CH
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="CH", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="CH", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="CH", robust 
*w/o GB
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="GB", robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="GB", robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married if cntry!="GB", robust 
***age effec on opinion
regress imbgeco rtrd eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust 
regress imtcjob rtrd eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust 
regress imbleco rtrd eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust 
*income mostly from pensions
ivregress 2sls imbgeco (pensions_income=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust first
ivregress 2sls imtcjob (pensions_income=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust first
ivregress 2sls imbleco (pensions_income=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr i.country i.iscoco10 i.rural i.married, robust first
*robust to controlling for numeracy noimbro
ivregress 2sls imbgeco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr noimbro i.country i.iscoco10 i.rural i.married, robust 
ivregress 2sls imtcjob (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr noimbro i.country i.iscoco10 i.rural i.married, robust 
ivregress 2sls imbleco (rtrd=above_early above_full) eduyrs agea agesquared hinctnta ever_child lrscale brncntr noimbro i.country i.iscoco10 i.rural i.married, robust 
****dicontinuity plots by country
collapse imbgeco imtcjob imbleco full_retire_age early_retire_age, by (cntry agea)
twoway (line imbgeco imtcjob imbleco agea), by(cntry)
twoway (line imbgeco imtcjob imbleco agea) if cntry=="AT", xline(65)
line imbgeco imtcjob imbleco agea if cntry=="AT", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/AT_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="BE", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/BE_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="DK", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/DK_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="FI", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/FI_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="FR", xline(61.2)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/FR_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="DE", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/DE_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="IE", xline(66)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/IE_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="NL", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/NL_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="PT", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/PT_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="ES", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/ES_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="SE", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/SE_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="GB", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/GB_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="CH", xline(65)
graph save Graph "/Users/amjeannet/dropbox/My Work in Progress I/ATIAS/retirement discontinuity/Research & Politics Submission/RR1/CH_graph.gph"
line imbgeco imtcjob imbleco agea if cntry=="NO", xline(67)
grc1leg AT_graph.gph BE_graph.gph DK_graph.gph FI_graph.gph FR_graph.gph DE_graph.gph IE_graph.gph NL_graph.gph PT_graph.gph ES_graph.gph SE_graph.gph GB_graph.gph CH_graph.gph NO_graph.gph, legendfrom (BE_graph.gph)
