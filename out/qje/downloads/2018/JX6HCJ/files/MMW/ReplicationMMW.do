
*Acquiring treatment vector = Strata = edi x ets, they dropped ets == 1 (all three strata) - 
*No problem, as eliminated an entire strata
*They also dropped female verified == . (not clear male or female), I follow this in the regressions
*But in the randomization I keep them as they are part of the stratum within which treatment was randomized

use labeledbaseline, clear
keep sheno edi
sort sheno
save ap, replace

use SLMSMaster.dta, clear
sort sheno
merge sheno using ap
tab _m
*_m = 2 are 42 firms dropped from study because exceed capital stock threshold - did not receive treatment
keep if _m == 3
drop if ets == 1
egen Strata = group(edi ets), label
collapse (mean) treatever100 treatever200 treatmentround Strata, by(sheno) fast
mvencode  treatmentround,mv(5)
recode treatmentround (2=3)
sort sheno treatever100 treatever200 treatmentround
save app, replace
*Will merge this in later


*All of their data manipulation code first, with the regressions removed (except for creating variables)
*Most of this code is irrelevant to the regressions
*Then do regressions at bottom

use SLMSMaster.dta, clear
drop if ets==1 | ets==.
drop if femaleverified==.
sort sheno wave
merge sheno wave using int_pres
drop _merge
tsset sheno wave
gen abschange=prof-L.prof
gen perchange=100*(prof-L.prof)/L.prof
egen xtreme_high=pctile(perchange), p(99)
egen xtreme_low=pctile(perchange), p(1)
egen xtreme_high_abs=pctile(abschange), p(99)
egen xtreme_low_abs=pctile(abschange), p(1)
sum perchange, de
egen minchange=min(perchange), by(sheno)
egen maxchange=max(perchange), by(sheno)
gen sample2=1 if waves>=3 & ets>1 &  (perchange <=xtreme_high | perchange==.) & (abschange<=xtreme_high_abs  | abschange==.)  
drop logprof
gen logprof=log(realprof)
replace amount=.25 if amount==0 & wave>=6
*ERROR IN CODING - PRODUCES POSITIVE VALUES FOR MALES - WILL FOLLOW FURTHER BELOW
replace amount_femaleverified=.25 if amount_femaleverified==0 & wave>=6
gen equip100=equipamount==1
gen equip200=equipamount==2
recode cashamount .25=0
gen cash100=cashamount==1
gen cash200=cashamount==2
gen lK2_nolandnew=log(K2_nolandnew)
for num 2/11: gen femaleverified_waveX=femaleverified*waveX
gen K_noland_femaleverified=K2_noland*femaleverified
replace K2_noland=K2_noland/10000
gen hourlywage=prof/(ownhours*4.2)
gen gend=1+femaleverified if wave==1
egen gender_1=mean(gend), by(sheno)
gen femlow=gender_1==2 & ednyearsFIRM<=7 if gender_1~=. & ednyearsFIRM~=.
gen femmed=gender_1==2 & ednyearsFIRM>=8 & ednyearsFIRM<=10 if gender_1~=. & ednyearsFIRM~=.
gen femhi=gender_1==2 & ednyearsFIRM>=11 if gender_1~=. & ednyearsFIRM~=.
gen malelow=gender_1==1 & ednyearsFIRM<=7 if gender_1~=. & ednyearsFIRM~=.
gen malemed=gender_1==1 & ednyearsFIRM>=8 & ednyearsFIRM<=10 if gender_1~=. & ednyearsFIRM~=.
gen malehi=gender_1==1 & ednyearsFIRM>=11 if gender_1~=. & ednyearsFIRM~=.
for var femlow femmed femhi malelow malemed malehi:gen hours_X=(ownhours*4.2)*X
reg prof age  femlow femmed femhi malelow malemed malehi K2_noland  hours_femlow- hours_malehi if wave==1
gen reg_hourlywage=0 if femlow==1 | femmed==1
replace reg_hourlywage=9.2 if femhi==1
replace reg_hourlywage=2.3 if malelow==1
replace reg_hourlywage=4.3 if malemed==1
replace reg_hourlywage=7.7 if malehi==1
gen adjprof3=realprof-(reg_hourlywage*4.2*ownhours)
mvencode  treatmentround,mv(5)
recode treatmentround (2=3)
gen timetreat1=wave-treatmentround
replace timetreat1=0 if timetreat1<0
for num 1/8 : gen lX_100=timetreat1==X & amount==1
for num 1/8 : gen lX_200=timetreat1==X & amount==2
for num 1/4 : gen lX_25=timetreat1==X & amount==.25
for num 2/11: gen timetreat_waveX=timetreat1*waveX
gen etreat=1 if wave==2 & amount>0 & amount~=.
egen earlytreat=max(etreat), by(sheno)
replace earlytreat=0 if earlytreat==.
gen latetreat=1
replace latetreat=0 if earlytreat==1|treatever==0
gen timesince=wave-1 if earlytreat==1
replace timesince=wave-3 if latetreat==1
replace timesince=0 if timesince==.
replace timesince=0 if timesince<0
gen firstyear=timesince<=4
gen secondyear=timesince>=5 & timesince<=8
gen thirdyear=timesince>=9 & timesince<=11
gen firstyear_amount=amount*firstyear
gen secondyear_amount=amount*secondyear
gen thirdyear_amount=amount*thirdyear
gen amount100=amount==1 if amount~=.
gen amount200=amount==2 if amount~=.
gen female_100=amount100*femaleverified
gen female_200=amount200*femaleverified
gen time100=timetreat1*amount100
gen time200=timetreat1*amount200
gen female_time100=time100*femaleverified
gen female_time200=time200*femaleverified
sum initK if wave==1 & sample2==1, de
local pertile1initK=r(p1)
local pertile99initK=r(p99)
scalar p1K=`pertile1initK'
scalar p99K=`pertile99initK'
display "initK percentiles:  1%= "`pertile1initK' "   99%= " `pertile99initK'
gen sample2K=1 if  sample2==1 & initK>=`pertile1initK' & initK<=`pertile99initK'
gen K2_fem=K2_noland*femaleverified
egen evercash=max(cashamount),by(sheno)
egen everequip=max(equipamount),by(sheno)
replace everequip=0 if everequip==.25
sort sheno
merge sheno using treatment_reported
drop _merge
gen cash_spend=eq_spend+inv_spend if evercash>=1
gen inv_spend_fem=inv_spend*femaleverified
gen perc_inv=inv_spend/trtmnt_reported
gen perc_eq=eq_spend/trtmnt_reported
for var perc_inv perc_eq inv_spend eq_spend: replace X=0 if amount<1
for var inv_spend eq_spend: replace X=X/10000
gen inv_amount=perc_inv*amount
gen eq_amount=perc_eq*amount
sort sheno
merge sheno using treatment1_2
drop _merge
gen refrig=beq1>0 if beq1~=.
gen sewing=beq2>0 if beq2~=.
gen cooker=beq3>0 if beq3~=.
gen blender=beq11>0 if beq11~=.
gen rice=beq12>0 if beq12~=.
gen steamer=beq13>0 if beq13~=.
gen oven=beq14>0 if beq14~=.
gen utensils=beq15>0 if beq15~=.
gen containers=beq16>0 if beq16~=.
gen iron=beq18>0 if beq18~=.
gen camera=beq19>0 if beq19~=.
gen scales=beq20>0 if beq20~=.
gen furn=bfurtot>0 if bfurtot~=.
gen bike=btrav1>0 if btrav1~=.
gen compresor=beq4>0 if beq4~=.
gen grinder=beq5>0 if beq5~=.
gen drill=beq6>0 if beq6~=.
gen amount100_female=amount100*femaleverified
gen amount200_female=amount200*femaleverified
for var rexp_month_appliances-rexp_month_total: gen iX=X if wave==1
for var rexp_month_appliances-rexp_month_total: gen lX=X if wave==11
for var irexp_month_appliances-irexp_month_total: egen init_X=mean(X), by(sheno)
for var lrexp_month_appliances-lrexp_month_total: egen last_X=mean(X), by(sheno)
gen delta_month_groceries=last_lrexp_month_groceries-init_irexp_month_groceries
gen delta_month_housing=last_lrexp_month_housing-init_irexp_month_housing
gen delta_month_nondurable=last_lrexp_month_nondurable-init_irexp_month_nondurable
gen delta_month_health=last_lrexp_month_health-init_irexp_month_health
gen delta_month_education=last_lrexp_month_education-init_irexp_month_education
gen delta_month_fuel=last_lrexp_month_fuel-init_irexp_month_fuel
gen delta_month_clothing=last_lrexp_month_clothing-init_irexp_month_clothing
gen delta_month_footwear=last_lrexp_month_footwear-init_irexp_month_footwear
sort sheno
merge sheno using labeledbaseline, keep(q2_26_1 q2_26_2 q2_26_3 q2_26_4 q2_26_5 )
drop _merge
sort femaleverified
rename  q2_24_1 localinputs
rename  q2_26_1 localsales
gen amount100_localinputs=amount100*localinputs
gen amount200_localinputs=amount200*localinputs
for num 2/11: gen localinputs_waveX=localinputs*waveX
gen amount100_localsales=amount100*localsales
gen amount200_localsales=amount200*localsales
for num 2/11: gen localsales_waveX=localsales*waveX
gen amount100_young=amount100*youngbusiness
gen amount200_young=amount200*youngbusiness
for num 2/11: gen young_waveX=youngbusiness*waveX
pca landphone cellphone q6_1a_1-q6_1a_14 q6_1a_16 if wave==1
predict assetindex1, score
mvdecode c3_2_b_3- c3_2_b_6, mv(9)
for var c3_2_b_3- c3_2_b_6: replace X=0 if X==. 
gen finasset=c3_2_a_3==1 | c3_2_a_4==1 | c3_2_a_5==1 | c3_2_a_6==1  
gen val_finasset= c3_2_b_3 + c3_2_b_4 + c3_2_b_5 + c3_2_b_6 
for var int_nobody int_spouse int_other int_baby: replace X=0 if wave==1
gen fem_nobody=int_nobody*femaleverified
gen fem_spouse=int_spouse*femaleverified
gen fem_other=int_other*femaleverified
gen fem_baby=int_baby*femaleverified
gen fem_spouse_amount100=int_spouse*femaleverified*amount100
gen fem_spouse_amount200=int_spouse*femaleverified*amount200
gen int_spouse_amount100=int_spouse*amount100
gen int_spouse_amount200=int_spouse*amount200
for num 2/11: gen int_spouse_waveX=int_spouse*waveX
gen amount_nobody=amount*int_nobody
gen amount_nobody_fem=amount*int_nobody*femaleverified
sort sheno
merge sheno using tsunami_track11f
drop _merge
for X in num 1/3 5 10 11: egen j37_X=rsum(jq5_37_X_1-jq5_37_X_5)
for X in num 1/3 5 10 11: egen j37_Xm=rmiss(jq5_37_X_1-jq5_37_X_5)
for X in num 1/3 5 10 11: replace j37_X=-100 if j37_Xm==5
for X in num 1/3 5 10 11: egen j37_X_ind=rsum(jq5_37_X_1) 
for X in num 1/3 5 10 11: egen j37_X_sp=rsum(jq5_37_X_2)
egen hh_emp=rsum(j37_1_ind-j37_5_ind) if wave==11 
egen hh_miss=rsum(j37_1-j37_5)
egen hh_empower=mean(hh_emp), by(sheno)
replace hh_empower=. if hh_miss<0
egen bus_emp=rsum(j37_10_sp-j37_11_sp) if wave==11
egen bus_miss=rsum(j37_10-j37_11)
egen bus_empower=mean(bus_emp), by(sheno)
replace bus_empower=4-bus_empower
replace bus_empower=. if bus_miss<0
rename jq5_41_5 sp_prof 
for var jq5_41_2 sp_prof jq5_41_8:  recode X 6=.
gen sp_help=jq5_41_2 +sp_prof +jq5_41_8
pca hh_empower bus_empower sp_prof  if wave==10
predict power, score
for var hh_empower bus_empower  power: egen m_X=mean(X)
for var hh_empower bus_empower  power:   gen dm_X=X-m_X
for var hh_empower bus_empower  power: gen amount100_X=amount100*dm_X
for var hh_empower bus_empower  power: gen amount200_X=amount200*dm_X
for var hh_empower bus_empower  power: gen amount100_X_fem=amount100*dm_X*femaleverified
for var hh_empower bus_empower  power: gen amount200_X_fem=amount200*dm_X*femaleverified
for num 2/11: gen hh_empower_waveX=dm_hh_empower*waveX
for num 2/11: gen bus_empower_waveX=dm_bus_empower*waveX
for num 2/11: gen power_waveX=power*waveX
gen fixed=(K2_noland*10000)-inv
sort sheno
merge sheno using tsunami_track9all, keep(i6_4)
drop _merge
replace i6_4=. if i6_4==99
sort sheno 
merge sheno  using famhours_baseline
drop _merge
drop if ets==.
replace famhours=famhours_b if wave==1
replace nonfamhours=nonfamhours_b if wave==1
gen perc_hhinc=prof/hhincome if wave==1
egen perc_hh=mean(perc_hhinc), by(sheno)
gen amount_perc_hh=amount*perc_hh
gen amount100_perc_hh=amount100*perc_hh
gen amount200_perc_hh=amount200*perc_hh
gen K2_noland_perchh=perc_hh*K2_noland
for num 2/11: gen perc_hh_waveX=perc_hh*waveX
gen otherworkers= nwageworkers+ otherbusworkers
gen amount_other=amount*otherworkers
for num 2/11: gen other_waveX=otherworkers*waveX
pca raven ednyears digitspan crt if wave==10
predict ability1, score
for var loanbank nwageworkers otherbusworkers assetindex ednyearsFIRM p_digitspan p_lotBcrra  raven ability1  coeffvar overallliferisk   : egen m_X=mean(X)
for var loanbank nwageworkers otherbusworkers assetindex ednyearsFIRM p_digitspan  p_lotBcrra  raven ability1  coeffvar overallliferisk     :   gen dm_X=X-m_X
for var  loanbank nwageworkers otherbusworkers assetindex ednyearsFIRM p_digitspan p_lotBcrra  raven ability1  coeffvar overallliferisk   :gen amount_X=amount*dm_X
for var  loanbank nwageworkers otherbusworkers assetindex ednyearsFIRM p_digitspan p_lotBcrra  raven ability1  coeffvar overallliferisk   :gen amount100_X=amount100*dm_X
for var  loanbank nwageworkers otherbusworkers assetindex ednyearsFIRM p_digitspan p_lotBcrra  raven ability1  coeffvar overallliferisk   :gen amount200_X=amount200*dm_X
for var  loanbank nwageworkers otherbusworkers assetindex ednyearsFIRM p_digitspan p_lotBcrra  raven ability1  coeffvar overallliferisk   :gen amount100_female_X=amount100_female*dm_X
for var  loanbank nwageworkers otherbusworkers assetindex ednyearsFIRM p_digitspan p_lotBcrra  raven ability1  coeffvar overallliferisk   :gen amount200_female_X=amount200_female*dm_X
for num 2/11: gen loanbank_waveX=dm_loanbank*waveX
for num 2/11: gen nwageworkers_waveX=dm_nwageworkers*waveX
for num 2/11: gen otherbusworkers_waveX=dm_otherbusworkers*waveX
for num 2/11: gen assetindex_waveX=dm_assetindex*waveX
for num 2/11: gen ednyearsFIRM_waveX=dm_ednyearsFIRM*waveX
for num 2/11: gen p_digitspan_waveX=dm_p_digitspan*waveX
for num 2/11: gen ability1_waveX=dm_ability1*waveX
for num 2/11: gen raven_waveX=dm_raven*waveX
for num 2/11: gen coeffvar_waveX=dm_coeffvar*waveX
for num 2/11: gen p_lotBcrra_waveX=dm_p_lotBcrra*waveX
for num 2/11: gen overallliferisk_waveX=dm_overallliferisk*waveX
gen K2_digit=K2_noland*dm_p_digitspan
sort detailedind
merge detailedind using propfem
drop _merge
egen indcount=count(femaleverified), by(detailedind)
gen indsample=indcount>=44 & indcount~=.
gen amount100_propfem=amount100*(propfem_det)
gen amount200_propfem=amount200*(propfem_det)
gen amount100_propfem_fem=amount100*(propfem_det)*femaleverified
gen amount200_propfem_fem=amount200*(propfem_det)*femaleverified
for num 2/11: gen propfem_waveX=propfem_detailedind*waveX
reg femaleverified athomebus localinputs localsales youngbus  if wave==1 & sample2==1
predict p_female
gen amount100_pfemale=amount100*p_female
gen amount200_pfemale=amount200*p_female
gen amount100_pfemale_fem=amount100*p_female*femaleverified
gen amount200_pfemale_fem=amount200*p_female*femaleverified
for num 2/11: gen pfemale_waveX=p_female*waveX
reg femaleverified athomebus localinputs localsales youngbus  propfem_det  if wave==1 & sample2==1
predict pind_female
gen amount100_pindfemale=amount100*pind_female
gen amount200_pindfemale=amount200*pind_female
gen amount100_pindfemale_fem=amount100*pind_female*femaleverified
gen amount200_pindfemale_fem=amount200*pind_female*femaleverified
for num 2/11: gen pindfemale_waveX=pind_female*waveX
gen gendind=(propfem_detailedind<.25 | propmale_detailedind<.25) if indsample==1 & propfem_det~=.
gen amount_gendind=gendind*amount
for num 2/11: gen gendind_waveX=gendind*waveX
for var timetosolve fatherednFIRM motherednFIRM fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation workcentrality organization polychronicity: egen m_X=mean(X)
for var timetosolve fatherednFIRM motherednFIRM fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation workcentrality organization polychronicity: gen dm_X=X-m_X
for var timetosolve fatherednFIRM motherednFIRM fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation workcentrality organization polychronicity:  gen amount100_X=amount100*dm_X
for var timetosolve fatherednFIRM motherednFIRM fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation workcentrality organization polychronicity:  gen amount200_X=amount200*dm_X
for var timetosolve fatherednFIRM motherednFIRM fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation workcentrality organization polychronicity:  gen amount100_fem_X=amount100*femaleverified*dm_X
for var timetosolve fatherednFIRM motherednFIRM fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation workcentrality organization polychronicity:  gen amount200_fem_X=amount200*femaleverified*dm_X
for num 2/11: gen timetosolve_waveX=dm_timetosolve*waveX
for num 2/11: gen fatherednFIRM_waveX=dm_fatherednFIRM*waveX
for num 2/11: gen motherednFIRM_waveX=dm_motherednFIRM*waveX
for num 2/11: gen fatherbus_waveX=dm_fatherbus*waveX
for num 2/11: gen motherbus_waveX=dm_motherbus*waveX
for num 2/11: gen optimismI_waveX=dm_optimismI*waveX
for num 2/11: gen p_carer_waveX=dm_p_carer*waveX
for num 2/11: gen reasongrow4_waveX=dm_reasongrow4*waveX
for num 2/11: gen athomebus_waveX=dm_athomebus*waveX
for num 2/11: gen selfefficacy_waveX=dm_selfefficacy*waveX
for num 2/11: gen financialliteracy_waveX=dm_financialliteracy*waveX
for num 2/11: gen impulsiveness_waveX=dm_impulsiveness*waveX
for num 2/11: gen passionforwork_waveX=dm_passionforwork*waveX
for num 2/11: gen tenacity_waveX=dm_tenacity*waveX
for num 2/11: gen locusofcontrol_waveX=dm_locusofcontrol*waveX
for num 2/11: gen trust_waveX=dm_trust*waveX
for num 2/11: gen achievement_waveX=dm_achievement*waveX
for num 2/11: gen powermotivation_waveX=dm_powermotivation*waveX
for num 2/11: gen workcentrality_waveX=dm_workcentrality*waveX
for num 2/11: gen organization_waveX=dm_organization*waveX
for num 2/11: gen polychronicity_waveX=dm_polychronicity*waveX
sum *amount* if treatever200 == .
*Unused observations picked up along the way in their code - get rid of them
drop if treatever200 == .

generate Sample = 1
sort sheno treatever100 treatever200 treatmentround
merge sheno treatever100 treatever200 treatmentround using app
tab _m
*These are the 21 sheno with femaleverified == .
drop _m


*All of these xtregs are simple regressions with fixed effects (no re)

*Table 2 - Rounding errors (two other regressions in table are iv - examined below)
xtreg realprof amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe i(sheno) cluster (sheno)
xtreg adjprof3 amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe i(sheno) cluster (sheno)
xtreg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==0, i(sheno) fe cluster(sheno)
xtreg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==1, i(sheno) fe cluster(sheno)

*Table 3 - Rounding errors
xtreg K2_noland amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 & prof~=., fe i(sheno) cluster(sheno)
xtreg K2_noland amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 & prof~=. & timesince<=1 & wave<=4 , fe i(sheno) cluster(sheno)
*Recode to drop non-relevant waves
xtreg K2_noland amount100 amount200 female_100 female_200 wave2-wave4 femaleverified_wave2-femaleverified_wave4 if Sample == 1 & ets>1 & sample2==1 & prof~=. & timesince<=1 & wave<=4 , fe i(sheno) cluster(sheno)
*Had to add cluster option (missing from code) to match paper
xtreg adjprof3 amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe i(sheno) cluster(sheno)

*These two regressions seem a bit dubious to me, since they are interacting treatment with a post treatment response and taking as exogenous
*Operating assumption has to be that these investment shares not influenced by treatment
*Since they treat these as exogenous characteristics interacted with treatment, I do as well
xtreg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==0, fe i(sheno) cluster (sheno)
xtreg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==1, fe i(sheno) cluster (sheno)

*Table 5 - Rounding errors, sample size errors in a couple of cases when sample size changes
xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex wave2-wave9 wave10 wave11  nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11 p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex  wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11  p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11   p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan  amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan  amount200_female_p_lotBcrra wave2-wave9 wave10 wave11   nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11      femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)

*Table 6 - numerous rounding errors
foreach X in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
	xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_`X' amount200_`X' amount100_fem_`X' amount200_fem_`X' wave2-wave9 wave10 wave11 `X'_wave2-`X'_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe i(sheno) cluster (sheno)
	}

*Table 7 - numerous rounding errors
xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)
xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe i(sheno) cluster (sheno)

*Table 8 - Many rounding errors, some magnitude errors
for var enroll5to12 enroll12to15 enroll17to18 : xtreg X amount100 amount200 amount100_female amount200_female wave2-wave9 wave10 wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 , fe i(sheno) cluster (sheno)
for var rexp_month_groceries rexp_month_health rexp_month_education : xtreg X amount100 amount200 amount100_female amount200_female wave2-wave9 wave10 wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 , fe i(sheno) cluster (sheno)

*Code removing waves that are automatically zero for these
foreach X in enroll5to12 enroll12to15 enroll17to18 rexp_month_groceries rexp_month_health rexp_month_education {
	xtreg `X' amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 , fe i(sheno) cluster (sheno)
	}

xtreg assetindex1 amount100 amount200 amount100_female amount200_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1   , fe i(sheno) cluster (sheno)
xtreg assetindex1 amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe i(sheno) cluster (sheno)


*Table 9 - Rounding errors
xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_power amount200_power amount100_power_fem amount200_power_fem wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, fe i(sheno) cluster(sheno)
xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_power amount200_power amount100_power_fem amount200_power_fem wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, fe i(sheno) cluster(sheno)
xtreg inv amount100 amount200 amount100_female amount200_female amount100_power amount200_power amount100_power_fem amount200_power_fem wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, fe i(sheno) cluster(sheno)
xtreg fixed amount100 amount200 amount100_female amount200_female amount100_power amount200_power amount100_power_fem amount200_power_fem wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, fe i(sheno) cluster(sheno)

*Dropping variables that are automatically 0 
foreach X in K2_noland adjprof3 inv fixed {
	xtreg `X' amount100 amount200 amount100_power amount200_power wave2-wave9 wave10 wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, fe i(sheno) cluster(sheno)
	}

*IVRegs for Table 2 - All okay
xtivreg2 realprof (K2_noland K2_fem=amount amount_female) wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if sample2==1, i(sheno) fe first cluster(sheno)
lincom K2_noland + K2_fem 
xtivreg2 adjprof3 (K2_noland K2_fem=amount amount_female) wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if sample2==1, i(sheno) fe first cluster(sheno)
lincom K2_noland + K2_fem 

*intent to treat reproduces earlier regressions

save DatMMW, replace

capture erase ap.dta
capture erase app.dta



