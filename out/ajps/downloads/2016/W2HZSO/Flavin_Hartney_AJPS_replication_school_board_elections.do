*USER NOTE: This .do file lists syntax for replicating all models in the paper that analyze California school board election outcomes
*USER NOTE: Information on how/where to aquire data from the original sources is included in the replication materials

*Open data file that combines all data sources used in the analysis into a single file
use "Flavin_Hartney_AJPS_replication_school_board_elections.dta", clear


*TABLE 1
probit win epp_wh epp_aa epp_hi cands_run seats_up pct_aa pct_hi teach i.year, cluster(cds7)
predict a if e(sample)
test epp_wh=epp_aa
test epp_wh=epp_hi
tab year if a~=.
probit win mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach i.year, cluster(cds7)
predict b if e(sample)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi
tab year if b~=.
reg percent_vote epp_wh epp_aa epp_hi cands_run pct_aa pct_hi teach i.year, cluster(cds7)
vif
predict c if e(sample)
test epp_wh=epp_aa
test epp_wh=epp_hi
tab year if c~=.
reg percent_vote mpp_wh mpp_aa mpp_hi cands_run pct_aa pct_hi teach i.year, cluster(cds7)
vif
predict d if e(sample)
tab year if d~=.
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi


*Correlations of student achievement measures (reported in paper in a footnote)
corr epp_wh epp_aa epp_hi if a~=.
corr mpp_wh mpp_aa mpp_hi if b~=.


*SUBSTANTIVE EFFECTS (have to create year dummy variables b/c CLARIFY can't compute with i.year syntax)
tabulate year, gen(yeardum)
drop yeardum1
estsimp probit win epp_wh epp_aa epp_hi cands_run seats_up pct_aa pct_hi teach yeardum*, cluster(cds7)
setx mean if a~=.
simqi, fd(prval(1)) changex(epp_wh p75 p25)
simqi, fd(prval(1)) changex(epp_aa p75 p25)
simqi, fd(prval(1)) changex(epp_hi p75 p25)
estsimp probit win mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach yeardum*, cluster(cds7) dropsims
setx mean if b~=.
simqi, fd(prval(1)) changex(mpp_wh p75 p25)
simqi, fd(prval(1)) changex(mpp_aa p75 p25)
simqi, fd(prval(1)) changex(mpp_hi p75 p25)
estsimp reg percent_vote epp_wh epp_aa epp_hi cands_run pct_aa pct_hi teach yeardum*, cluster(cds7) dropsims
setx mean if c~=.
simqi, fd(ev) changex(epp_wh p75 p25)
simqi, fd(ev) changex(epp_aa p75 p25)
simqi, fd(ev) changex(epp_hi p75 p25)
estsimp reg percent_vote mpp_wh mpp_aa mpp_hi cands_run pct_aa pct_hi teach yeardum*, cluster(cds7) dropsims
setx mean if d~=.
simqi, fd(ev) changex(mpp_wh p75 p25)
simqi, fd(ev) changex(mpp_aa p75 p25)
simqi, fd(ev) changex(mpp_hi p75 p25)


*TABLE 2
probit win aa_e hi_e epp_wh epp_aa epp_hi cands_run seats_up pct_aa pct_hi teach i.year, cluster(cds7)
probit win aa_m hi_m mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach i.year, cluster(cds7)
reg percent_vote aa_e hi_e epp_wh epp_aa epp_hi cands_run pct_aa pct_hi teach i.year, cluster(cds7)
reg percent_vote aa_m hi_m mpp_wh mpp_aa mpp_hi cands_run pct_aa pct_hi teach i.year, cluster(cds7)


*TABLE 3
probit win epp_wh epp_hi cands_run seats_up pct_aa pct_hi teach i.year, cluster(cds7)
test epp_wh=epp_hi
probit win mpp_wh mpp_hi cands_run seats_up pct_aa pct_hi teach i.year, cluster(cds7)
test mpp_wh=mpp_hi
reg percent_vote epp_wh epp_hi cands_run pct_aa pct_hi teach i.year, cluster(cds7)
test epp_wh=epp_hi
reg percent_vote mpp_wh mpp_hi cands_run pct_aa pct_hi teach i.year, cluster(cds7)
test mpp_wh=mpp_hi
probit win epp_wh epp_hi cands_run seats_up pct_aa pct_hi teach i.year if hisp_greater_white==1, cluster(cds7)
test epp_wh=epp_hi
probit win mpp_wh mpp_hi cands_run seats_up pct_aa pct_hi teach i.year if hisp_greater_white==1, cluster(cds7)
test mpp_wh=mpp_hi
reg percent_vote epp_wh epp_hi cands_run pct_aa pct_hi teach i.year if hisp_greater_white==1, cluster(cds7)
test epp_wh=epp_hi
reg percent_vote mpp_wh mpp_hi cands_run pct_aa pct_hi teach i.year if hisp_greater_white==1, cluster(cds7)
test mpp_wh=mpp_hi


***************************************
*Supporting Information (SI) section*
***************************************


*TABLE SI-1
probit win epp_wh epp_aa epp_hi cands_run seats_up pct_aa pct_hi teach offcycle i.year, cluster(cds7)
test epp_wh=epp_aa
test epp_wh=epp_hi
probit win mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach offcycle i.year, cluster(cds7)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi
reg percent_vote epp_wh epp_aa epp_hi cands_run pct_aa pct_hi teach offcycle i.year, cluster(cds7)
test epp_wh=epp_aa
test epp_wh=epp_hi
reg percent_vote mpp_wh mpp_aa mpp_hi cands_run pct_aa pct_hi teach offcycle i.year, cluster(cds7)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi


*TABLE SI-2
probit win wh_api aa_api hi_api cands_run seats_up pct_aa pct_hi teach i.year, cluster(cds7)
test wh_api=aa_api
test wh_api=hi_api
reg percent_vote wh_api aa_api hi_api cands_run pct_aa pct_hi teach i.year, cluster(cds7)
predict e if e(sample)
test wh_api=aa_api
test wh_api=hi_api
tab year if e~=.


*TABLE SI-4
sum win percent_vote epp_wh epp_aa epp_hi cands_run seats_up pct_aa pct_hi teach if a~=.
sum mpp_wh mpp_aa mpp_hi if b~=.


/*
*TABLE SI-5
*USER NOTE: Models are collapsed by election-year, so this syntax is bracketed off to allow subsequent analyses to be run (remove brackets to run collapsed analysis)

collapse win percent_vote epp_wh epp_aa epp_hi mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach, by(cds7 year)
*collapse win epp_wh epp_aa epp_hi mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach cds7 year (sum) percent_vote, by(Multi_RaceID)
*collapse win epp_wh epp_aa epp_hi mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach cds7 year (sum) percent_vote, by(Multi_RaceID)

*win = % of incumbents in the district-year who won reelection
*percent_vote = average % of total vote share for incumbent candidates running in the district-year 

gen win100=win*100
drop win
rename win100 win
bysort year: sum win percent_vote epp_wh epp_aa epp_hi mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach
eststo clear
eststo: reg win epp_wh epp_aa epp_hi cands_run seats_up pct_aa pct_hi teach i.year, cluster(cds7)
predict a if e(sample)
test epp_wh=epp_aa
test epp_wh=epp_hi
tab year if a~=.
eststo: reg win mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach i.year, cluster(cds7)
predict b if e(sample)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi
tab year if b~=.
eststo: reg percent_vote epp_wh epp_aa epp_hi cands_run pct_aa pct_hi teach i.year, cluster(cds7)
predict c if e(sample)
test epp_wh=epp_aa
test epp_wh=epp_hi
tab year if c~=.
eststo: reg percent_vote mpp_wh mpp_aa mpp_hi cands_run pct_aa pct_hi teach i.year, cluster(cds7)
predict d if e(sample)
tab year if d~=.
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi
sum win percent_vote epp_wh epp_aa epp_hi mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach if a~=.
esttab using C:\Users\patrick_j_flavin\Desktop\Baylor\Tables\RIRV-SI.rtf, replace se star(* 0.05) b(3) obslast brackets r2
*/


*TABLE SI-6
probit win epp_wh epp_aa epp_hi cands_run seats_up pct_aa pct_hi teach meals current_expense_per_ada studentteacher_ratio i.year, cluster(cds7)
predict f if e(sample)
test epp_wh=epp_aa
test epp_wh=epp_hi
probit win mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach meals current_expense_per_ada studentteacher_ratio i.year, cluster(cds7)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi
reg percent_vote epp_wh epp_aa epp_hi cands_run pct_aa pct_hi teach meals current_expense_per_ada studentteacher_ratio i.year, cluster(cds7)
test epp_wh=epp_aa
test epp_wh=epp_hi
reg percent_vote mpp_wh mpp_aa mpp_hi cands_run pct_aa pct_hi teach meals current_expense_per_ada studentteacher_ratio i.year, cluster(cds7)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi


*TABLE SI-7
probit win epp_wh epp_aa epp_hi, cluster(cds7)
test epp_wh=epp_aa
test epp_wh=epp_hi
probit win mpp_wh mpp_aa mpp_hi, cluster(cds7)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi
reg percent_vote epp_wh epp_aa epp_hi, cluster(cds7)
test epp_wh=epp_aa
test epp_wh=epp_hi
reg percent_vote mpp_wh mpp_aa mpp_hi, cluster(cds7)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi


*TABLE SI-8
probit win epp_wh epp_aa epp_hi cands_run seats_up pct_aa pct_hi teach ward i.year, cluster(cds7)
test epp_wh=epp_aa
test epp_wh=epp_hi
probit win mpp_wh mpp_aa mpp_hi cands_run seats_up pct_aa pct_hi teach ward i.year, cluster(cds7)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi
reg percent_vote epp_wh epp_aa epp_hi cands_run pct_aa pct_hi teach ward i.year, cluster(cds7)
test epp_wh=epp_aa
test epp_wh=epp_hi
reg percent_vote mpp_wh mpp_aa mpp_hi cands_run pct_aa pct_hi teach ward i.year, cluster(cds7)
test mpp_wh=mpp_aa
test mpp_wh=mpp_hi
