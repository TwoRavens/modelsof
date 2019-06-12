*USER NOTE: This .do file lists syntax for replicating all analysis in the paper that uses data from our original survey of California school board members
*USER NOTE: Information about the survey (including question wording) is included in the replication materials

use "Flavin_Hartney_AJPS_replication_board_member_survey.dta", clear


*List experiment results discussed in text
ttest items, by(treat)


*TABLE 4
tab1 budget_urgent teaching_urgent learning_gains_urgent achievementgaps_urgent commoncore_urgent


*TABLE SI-9
*Individual Level Board Member Characteristics
ttest party7, by(treat)
ttest liberalism, by(treat)
ttest hhinc, by(treat)
ttest boardtenure, by(treat)
ttest college, by(treat)
ttest teacher, by(treat)
ttest kids, by(treat)
ttest white, by(treat)
ttest eyear,by(treat)
ttest achieve,by(treat)
*District level characteristics
ttest offcycle, by(treat)
ttest avghispgap, by(treat)
ttest avgblkgap, by(treat)
ttest meals, by(treat)
ttest phisp, by(treat)
ttest pblk, by(treat)
ttest civra, by(treat)


*TABLE SI-10
reg items pwhiteXtreat treat pwhite, cluster(leaid)
reg items avgblkgapXtreat treat avgblkgap , cluster(leaid)
reg items avghispgapXtreat treat avghispgap , cluster(leaid)
reg items anyblackXtreat anyblack treat, cluster(leaid)
reg items alXtreat treat al, cluster(leaid)


*TABLE SI-11
tab1 budget_urgent teaching_urgent learning_gains_urgent achievementgaps_urgent commoncore_urgent if pwhite<.50
tab1 budget_urgent teaching_urgent learning_gains_urgent achievementgaps_urgent commoncore_urgent if blkgapworse==1
tab1 budget_urgent teaching_urgent learning_gains_urgent achievementgaps_urgent commoncore_urgent if hispgapworse==1
