

drop if id==.
gen idd=_n

gen distance= govt_position1-0.5
gen absdistance=abs(govt_position1-0.5)
gen distance_vm=govt_position1-voter_mean1
gen absdistance_vm=abs(distance_vm)
gen distance_pm=govt_position1-parl_mean1
gen absdistance_pm=abs(distance_pm)

gen vote_deviation=parl_mean1- mean_proxchoice 
gen abs_val_alpha=abs(val_alpha)
gen absvaldev=abs(val_deviation)

*NEFF
recode  portfolio1- portfolio7 parl_share1-parl_share7 (.=0)
recode  position_first1- position_first7 (.=0)
gen neff=1/ (parl_share1^2+ parl_share2^2+ parl_share3^2+parl_share4^2+ parl_share5^2+ parl_share6^2+parl_share7^2)


*Empty centre
*Emptyc defines empty centre around 0.5 
reshape long party_share parl_share position_first position_second portfolio valence val_mean dist_pv, i(idd) j(party)
gen partydist=position_first- 0.5
gen dist_R=partydist if partydist>0
gen dist_L=partydist if partydist<0
gen absdist=abs(position_first-0.5)
reshape wide absdist partydist dist_R dist_L  party_share parl_share position_first position_second portfolio dist_pv valence val_mean, i(idd) j(party)


egen min_dist_R=rowmin(dist_R1 dist_R2 dist_R3 dist_R4 dist_R5 dist_R6 dist_R7)
egen min_dist_L=rowmax(dist_L1 dist_L2 dist_L3 dist_L4 dist_L5 dist_L6 dist_L7)
egen mindist=rowmin(absdist1 absdist2 absdist3 absdist4 absdist5 absdist6 absdist7)
gen emptyc=min_dist_R-min_dist_L

*Emptyc_vm defines the empty centre around the voter mean.
*recode  portfolio1- portfolio7 parl_share1-parl_share7 (.=0)
*recode  position_first1- position_first7 (.=0)
reshape long party_share parl_share position_first position_second portfolio valence val_mean dist_pv, i(idd) j(party)
gen partydistvm=position_first- voter_mean1
gen dist_Rvm=partydistvm if partydistvm>0
gen dist_Lvm=partydistvm if partydistvm<0
gen absdistvm=abs(position_first-voter_mean1)
reshape wide absdistvm partydistvm dist_Rvm dist_Lvm  party_share parl_share position_first position_second portfolio dist_pv valence val_mean, i(idd) j(party)


egen min_dist_Rvm=rowmin(dist_Rvm1 dist_Rvm2 dist_Rvm3 dist_Rvm4 dist_Rvm5 dist_Rvm6 dist_Rvm7)
egen min_dist_Lvm=rowmax(dist_Lvm1 dist_Lvm2 dist_Lvm3 dist_Lvm4 dist_Lvm5 dist_Lvm6 dist_Lvm7)
egen mindistvm=rowmin(absdistvm1 absdistvm2 absdistvm3 absdistvm4 absdistvm5 absdistvm6 absdistvm7)
gen emptyc_vm=min_dist_Rvm-min_dist_Lvm

*Emptyc_pm defines the empty centre around the parliamentary mean.
*recode  portfolio1- portfolio7 parl_share1-parl_share7 (.=0)
*recode  position_first1- position_first7 (.=0)
reshape long party_share parl_share position_first position_second portfolio valence val_mean dist_pv, i(idd) j(party)
gen partydistpm=position_first- parl_mean1
gen dist_Rpm=partydistpm if partydistpm>0
gen dist_Lpm=partydistpm if partydistpm<0
gen absdistpm=abs(position_first-parl_mean1)
reshape wide absdistpm partydistpm dist_Rpm dist_Lpm  party_share parl_share position_first position_second portfolio dist_pv valence val_mean, i(idd) j(party)


egen min_dist_Rpm=rowmin(dist_Rpm1 dist_Rpm2 dist_Rpm3 dist_Rpm4 dist_Rpm5 dist_Rpm6 dist_Rpm7)
egen min_dist_Lpm=rowmax(dist_Lpm1 dist_Lpm2 dist_Lpm3 dist_Lpm4 dist_Lpm5 dist_Lpm6 dist_Lpm7)
egen mindistpm=rowmin(absdistpm1 absdistpm2 absdistpm3 absdistpm4 absdistpm5 absdistpm6 absdistpm7)
gen emptyc_pm=min_dist_Rpm-min_dist_Lpm

*BALANCE The extent to which one side outweighs the other in the govt
*(abs. value of LW minus RW govt seats).

gen ps1=portfolio1
gen ps2=portfolio2
gen ps3=portfolio3
gen ps4=portfolio4
gen ps5=portfolio5
gen ps6=portfolio6
gen ps7=portfolio7
recode ps1 *=1 if ps1>0
recode ps2 *=1 if ps2>0
recode ps3 *=1 if ps3>0
recode ps4 *=1 if ps4>0
recode ps5 *=1 if ps5>0
recode ps6 *=1 if ps6>0
recode ps7 *=1 if ps7>0

*Balance is defined around 0.5. 
gen lgs1=ps1*parl_share1 if position_first1<0.5
gen lgs2=ps2*parl_share2 if position_first2<0.5
gen lgs3=ps3*parl_share3 if position_first3<0.5
gen lgs4=ps4*parl_share4 if position_first4<0.5
gen lgs5=ps5*parl_share5 if position_first5<0.5
gen lgs6=ps6*parl_share6 if position_first6<0.5
gen lgs7=ps7*parl_share7 if position_first7<0.5

egen lgs=rowtotal(lgs1 lgs2 lgs3 lgs4 lgs5 lgs6 lgs7)
gen leftps=lgs/govt_prop
gen balance=(1- leftps)- leftps
*The following accounts for rounding error.
recode balance *=-1 if balance<-1
gen absbalance=abs(balance)

*Balance_vm is defined around the voter mean.
gen lgsvm1=ps1*parl_share1 if position_first1<voter_mean1
gen lgsvm2=ps2*parl_share2 if position_first2<voter_mean1
gen lgsvm3=ps3*parl_share3 if position_first3<voter_mean1
gen lgsvm4=ps4*parl_share4 if position_first4<voter_mean1
gen lgsvm5=ps5*parl_share5 if position_first5<voter_mean1
gen lgsvm6=ps6*parl_share6 if position_first6<voter_mean1
gen lgsvm7=ps7*parl_share7 if position_first7<voter_mean1

egen lgsvm=rowtotal(lgsvm1 lgsvm2 lgsvm3 lgsvm4 lgsvm5 lgsvm6 lgsvm7)
gen leftpsvm=lgsvm/govt_prop
gen balance_vm=(1- leftpsvm)- leftpsvm
*The following accounts for rounding error.
recode balance_vm *=-1 if balance_vm<-1
gen absbalance_vm=abs(balance_vm)

*Balance_pm is defined around the voter mean.
gen lgspm1=ps1*parl_share1 if position_first1<parl_mean1
gen lgspm2=ps2*parl_share2 if position_first2<parl_mean1
gen lgspm3=ps3*parl_share3 if position_first3<parl_mean1
gen lgspm4=ps4*parl_share4 if position_first4<parl_mean1
gen lgspm5=ps5*parl_share5 if position_first5<parl_mean1
gen lgspm6=ps6*parl_share6 if position_first6<parl_mean1
gen lgspm7=ps7*parl_share7 if position_first7<parl_mean1

egen lgspm=rowtotal(lgspm1 lgspm2 lgspm3 lgspm4 lgspm5 lgspm6 lgspm7)
gen leftpspm=lgspm/govt_prop
gen balance_pm=(1- leftpspm)- leftpspm
*The following accounts for rounding error.
recode balance_pm *=-1 if balance_pm<-1
gen absbalance_pm=abs(balance_pm)


*Onesided Is govt built on one side of centre?
gen onesided=.
recode onesided .=1 if absbalance >.995
recode onesided .=0 if absbalance <=.995

gen onesided_vm=.
recode onesided_vm .=1 if absbalance_vm >.995
recode onesided_vm .=0 if absbalance_vm <=.995

gen onesided_pm=.
recode onesided_pm .=1 if absbalance_pm >.995
recode onesided_pm .=0 if absbalance_pm <=.995

*Lopsided. Identifies systems with all parties on one side of centre.
egen minpos=rowmin(position_first1 position_first2 position_first3 position_first4 position_first5 position_first6 position_first7)
egen maxpos=rowmax(position_first1 position_first2 position_first3 position_first4 position_first5 position_first6 position_first7)
gen lopsided=1
recode lopsided 1=0 if minpos<.5&maxpos>.5
gen lopsided_vm=1
recode lopsided_vm 1=0 if minpos<voter_mean1&maxpos>voter_mean1

*Single-party majorities.
egen sharemax=rowmax(parl_share1 parl_share2 parl_share3 parl_share4 parl_share5 parl_share6 parl_share7)
gen spm=0
recode spm 0=1 if sharemax>.5

*Single-party govts.
gen spg=0
recode spg 0=1 if num_gp==1

*Valence deviations from centre.
gen valdistance=(centre_valmean-0.5)
gen absvaldistance=abs(valdistance)
gen valdistance_vm=(centre_valmean-voter_mean1)
gen absvaldistance_vm=abs(valdistance_vm)
gen votechoice= vote_deviation+ mean_proxchoice

*Absvoterskew - the absolute deviation of voter mean positions from the centre.
gen voterskew=voter_mean1-0.5
gen absvoterskew=abs(voter_mean1-0.5)

*abspartyskew - the absolute extent to which the mean party position deviates from centre.
recode position_first1 position_first2 position_first3 position_first4 position_first5 position_first6 position_first7 (0=.)
egen meanpp=rowmean(position_first1 position_first2 position_first3 position_first4 position_first5 position_first6 position_first7)
gen partyskew=meanpp-0.5
gen abspartyskew=abs(meanpp-0.5)

*GGS's measure of ideol. diversity of party system (from Alvarez and Nagler 2004).
gen x1=abs(position_first1-parl_mean1)*parl_share1
gen x2=abs(position_first2-parl_mean1)*parl_share2
gen x3=abs(position_first3-parl_mean1)*parl_share3
gen x4=abs(position_first4-parl_mean1)*parl_share4
gen x5=abs(position_first5-parl_mean1)*parl_share5
gen x6=abs(position_first6-parl_mean1)*parl_share6
gen x7=abs(position_first7-parl_mean1)*parl_share7
egen ptyDISPwtd=rowtotal (x1-x7)
gen GGSptydiversity=ptyDISPwtd/voterSD
drop x1-x7 


gen x1=abs(position_first1-meanpp)
gen x2=abs(position_first2-meanpp)
gen x3=abs(position_first3-meanpp)
gen x4=abs(position_first4-meanpp)
gen x5=abs(position_first5-meanpp)
gen x6=abs(position_first6-meanpp)
gen x7=abs(position_first7-meanpp)
egen ptyDISP=rowmean(x1-x7)
drop x1-x7 

*Weighting by Neff.
*gen neffweight=normalden(neff,3.71,1.21)

aorder
drop absdist1-absdist7 absdistvm1-absdistvm7 absdistpm1- absdistpm7 bil1-bp2 dist_L1-dist_pv7 left_govt_parlshare leftshare-lgsvm7 maxpos min_dist_L-minpos partydist1-partydistvm7 pf_before_el1-pf_before_el7 ps1-ps_before_el7

