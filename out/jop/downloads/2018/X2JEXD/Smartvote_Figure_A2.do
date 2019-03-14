/*******************************************/
/*Figure A.2*/
/*Running this do-file produces Figure A.2.*/
/*******************************************/
qui clear all
qui set more off
use "smartvote_jop.dta",clear
qui reg smartvote diff_top_ptv email $controls   , robust
qui replace sample=cond(e(sample)==1,1,0)
qui keep if sample==1
/*******************************************/
* compare highest ptv before and after elections
** ptv's pre without 99 and 98's
gen ptv1= v1_97_1 if v1_97_1 >=0 & v1_97_1 <=10
gen ptv2= v1_97_2 if v1_97_2 >=0 & v1_97_2 <=10
gen ptv3= v1_97_3 if v1_97_3 >=0 & v1_97_3 <=10
gen ptv4= v1_97_4 if v1_97_4 >=0 & v1_97_4 <=10
gen ptv5= v1_97_5 if v1_97_5 >=0 & v1_97_5 <=10
gen ptv6= v1_97_6 if v1_97_6 >=0 & v1_97_6 <=10
gen ptv7= v1_97_7 if v1_97_7 >=0 & v1_97_7 <=10
gen ptv8= v1_97_8 if v1_97_8 >=0 & v1_97_8 <=10
egen top_ptv_pre = rowmax(ptv1 ptv2 ptv3 ptv4 ptv5 ptv6 ptv7 ptv8)
gen ptv1post= n1_61_6_1 if n1_61_6_1 >=0 & n1_61_6_1 <=10
gen ptv2post= n1_61_6_2 if n1_61_6_2 >=0 & n1_61_6_2 <=10
gen ptv3post= n1_61_6_3 if n1_61_6_3 >=0 & n1_61_6_3 <=10
gen ptv4post= n1_61_6_4 if n1_61_6_4 >=0 & n1_61_6_4 <=10
gen ptv5post= n1_61_6_5 if n1_61_6_5 >=0 & n1_61_6_5 <=10
gen ptv6post= n1_61_6_6 if n1_61_6_6 >=0 & n1_61_6_6 <=10
gen ptv7post= n1_61_6_7 if n1_61_6_7 >=0 & n1_61_6_7 <=10
gen ptv8post= n1_61_6_8 if n1_61_6_8 >=0 & n1_61_6_8 <=10
egen top_ptv_post = rowmax(ptv1post ptv2post ptv3post ptv4post ptv5post ptv6post ptv7post ptv8post)
/*SUM PTVS PRE AND POST*/
gen ptv_sum_before=ptv1+ptv2+ptv3+ptv4+ptv5+ptv6+ptv7+ptv8
gen ptv_sum_after=ptv1post+ptv2post+ptv3post+ptv4post+ptv5post+ptv6post+ptv7post+ptv8post
egen ptv_sd_before=rowsd(ptv1 ptv2 ptv3 ptv4 ptv5 ptv6 ptv7 ptv8)
egen ptv_sd_after=rowsd(ptv1post ptv2post ptv3post ptv4post ptv5post ptv6post ptv7post ptv8post)
egen ptv_mean_before=rowmean(ptv1 ptv2 ptv3 ptv4 ptv5 ptv6 ptv7 ptv8)
egen ptv_mean_after=rowmean(ptv1post ptv2post ptv3post ptv4post ptv5post ptv6post ptv7post ptv8post)
gen change_ptv_sum_before= ptv_sum_after-ptv_sum_before     if  ptv_sum_before!=. & ptv_sum_after!=.
gen change_ptv_sd_before= ptv_sd_after-ptv_sd_before        if  ptv_sd_before!=. & ptv_sd_after!=.
gen change_ptv_mean_before= ptv_mean_after-ptv_mean_before  if  ptv_mean_before!=. & ptv_mean_after!=.
/*******************************************/
local i=1
while `i'<=8{
rename ptv`i'post   post_ptv`i'
rename ptv`i'       pre_ptv`i'
local i=`i'+1
}
egen pre_ptv_nummiss=rowmiss(pre_ptv1 pre_ptv2 pre_ptv3 pre_ptv4 pre_ptv5 pre_ptv6 pre_ptv7 pre_ptv8)
egen post_ptv_nummiss=rowmiss(post_ptv1 post_ptv2 post_ptv3 post_ptv4 post_ptv5 post_ptv6 post_ptv7 post_ptv8)
/*Drop all obs with only missing values on ptvs either pre or post*/
drop if pre_ptv_nummiss==8
drop if post_ptv_nummiss==8
* replace missing ptv with zero
local i=1
while `i'<=8{
replace post_ptv`i'=0 if post_ptv`i'==.
replace pre_ptv`i'=0 if pre_ptv`i'==.
local i=`i'+1
}
/*******************************************/
reshape long pre_ptv post_ptv, i(idlime) j(party)
bysort idlime: egen pre_rank_unique=rank(pre_ptv), unique
bysort idlime: egen post_rank_unique=rank(post_ptv), unique
bysort idlime: egen pre_rank_track=rank(pre_ptv), track
bysort idlime: egen post_rank_track=rank(post_ptv), track
local i=1
while `i'<=8{
gen pre_rank`i'_ptv_party=pre_ptv if pre_rank_unique==`i'
gen post_rank`i'_ptv_party=post_ptv if post_rank_unique==`i'
local i=`i'+1
}
/*******************************************/
#delimit;
reshape wide pre_ptv post_ptv pre_rank_unique post_rank_unique pre_rank_track post_rank_track
pre_rank1_ptv_party post_rank1_ptv_party
pre_rank2_ptv_party post_rank2_ptv_party
pre_rank3_ptv_party post_rank3_ptv_party
pre_rank4_ptv_party post_rank4_ptv_party
pre_rank5_ptv_party post_rank5_ptv_party
pre_rank6_ptv_party post_rank6_ptv_party
pre_rank7_ptv_party post_rank7_ptv_party
pre_rank8_ptv_party post_rank8_ptv_party
, i(idlime) j(party) ;

local i=1;
while `i'<=8{;
egen pre_ptv_rank`i'=rowmin(pre_rank`i'_ptv_party1 pre_rank`i'_ptv_party2 pre_rank`i'_ptv_party3 pre_rank`i'_ptv_party4 pre_rank`i'_ptv_party5 pre_rank`i'_ptv_party6 pre_rank`i'_ptv_party7 pre_rank`i'_ptv_party8);
egen post_ptv_rank`i'=rowmin(post_rank`i'_ptv_party1 post_rank`i'_ptv_party2 post_rank`i'_ptv_party3 post_rank`i'_ptv_party4 post_rank`i'_ptv_party5 post_rank`i'_ptv_party6 post_rank`i'_ptv_party7 post_rank`i'_ptv_party8);
drop pre_rank`i'_ptv_party1 pre_rank`i'_ptv_party2 pre_rank`i'_ptv_party3 pre_rank`i'_ptv_party4 pre_rank`i'_ptv_party5 pre_rank`i'_ptv_party6 pre_rank`i'_ptv_party7 pre_rank`i'_ptv_party8;
drop post_rank`i'_ptv_party1 post_rank`i'_ptv_party2 post_rank`i'_ptv_party3 post_rank`i'_ptv_party4 post_rank`i'_ptv_party5 post_rank`i'_ptv_party6 post_rank`i'_ptv_party7 post_rank`i'_ptv_party8;
local i=`i'+1;
};
/*******************************************/
/*Plot Distribution of Avg PTV scores by rank (pre vs post and treat vs control)*/

keep idlime email
pre_ptv_rank1 pre_ptv_rank2 pre_ptv_rank3 pre_ptv_rank4 pre_ptv_rank5 pre_ptv_rank6 pre_ptv_rank7 pre_ptv_rank8
post_ptv_rank1 post_ptv_rank2 post_ptv_rank3 post_ptv_rank4 post_ptv_rank5 post_ptv_rank6 post_ptv_rank7 post_ptv_rank8
;

reshape long
pre_ptv_rank
post_ptv_rank
, i(idlime) j(rank);

gen diff_ptv_rank=post_ptv_rank-pre_ptv_rank;
gen did=.;
gen pval=.;
gen se=.;

local i=1;
while `i'<=8{;
ttest diff_ptv_rank if rank==`i', by(email);
replace se=r(se)  if rank==`i';
gen mu1=r(mu_1);
gen mu2=r(mu_2);
replace did=mu2 - mu1  if rank==`i';
replace pval=r(p) if rank==`i';
local i=`i'+1;
drop mu1 mu2;
};
/*******************************************/
collapse pre_ptv_rank post_ptv_rank diff_ptv_rank did pval se, by(email rank);

gen diff_ptv_rank_0=diff_ptv_rank if email==0;
gen diff_ptv_rank_1=diff_ptv_rank if email==1;

gen did_upper95=did + 1.96*se;
gen did_lower95=did - 1.96*se;

label var pre_ptv_rank  "pre";
label var post_ptv_rank "post";
label var rank "Party rank";
label var diff_ptv_rank_0  "Control";
label var diff_ptv_rank_1  "Treatment";

label def email 0 "control group" 1 "treatment group";
label val email email;

graph bar pre_ptv_rank post_ptv_rank , over(rank) over(email)
graphr(fcolor(gs16) lcolor(gs16)) nofill
bar(1, color(gs0))  bar(2, color(gs8))
                bargap(-30)
                ytitle("Mean PTV Score")
                legend( label(1 "before") label(2 "after") nobox   )
saving(ControlTreat, replace);

graph bar  diff_ptv_rank_0 diff_ptv_rank_1 , over(rank)
graphr(fcolor(gs16) lcolor(gs16)) nofill
bar(1, color(gs0))  bar(2, color(gs8))
                bargap(-30)
                legend( label(1 "control group") label(2 "treatment group")) legend(nobox)
                title("Before-After Differences")
saving(Diff, replace);

twoway connected did did_upper95 did_lower95 rank,
graphr(fcolor(gs16) lcolor(gs16)) lstyle(none) legend(off)  sort(rank)
xlabel(1(1)8)  title("Differences-in-Differences Estimates")
mc(gs0 gs10 gs10)
msymbol(o p p)  clc(gs0 gs10 gs10) clpattern("l" "..." "...")
nodraw  saving(DinD, replace);

graph combine ControlTreat.gph Diff.gph DinD.gph,
graphr(fcolor(gs16) lcolor(gs16)) ysize(5) xsize(4)  rows(3)  saving(did_all, replace);
graph export did_all.eps, replace;
/*******************************************/
