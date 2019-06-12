use "../../ATUS/ATUS_bls.dta"

svyset [pweight=wt06]

generate homework=(bls_hhact+bls_purch+bls_carehh+bls_carenhh)*7/60

generate work=bls_work*7/60

generate leisure=(bls_leis+bls_comm+bls_food)*7/60

generate personalcare=bls_pcare*7/60

generate totaltime=(bls_pcare+bls_food+bls_hhact+bls_purch+bls_carehh+bls_carenhh+bls_work+bls_educ+bls_social+bls_leis+bls_comm+bls_other)*7/60

generate residual=totaltime-homework-work-leisure-personalcare

drop if work>100
drop if homework>100
drop if leisure==0

drop if missing(work)
drop if missing(homework)
drop if missing(leisure)
drop if missing(personalcare)
drop if missing(residual)

generate ratiohl=homework/(homework+leisure)

*age restriction
keep if age>=55 & age<=70

*aggregate categories
svy: mean ratiohl, over(age)
estat sd

svy: mean ratiohl if sex==1, over(age)
estat sd

svy: mean ratiohl if sex==2, over(age)
estat sd

svy: mean work, over(age)
estat sd

svy: mean work if sex==1, over(age)
estat sd

svy: mean work if sex==2, over(age)
estat sd

svy: mean homework, over(age)
estat sd

svy: mean homework if sex==1, over(age)
estat sd

svy: mean homework if sex==2, over(age)
estat sd

svy: mean leisure, over(age)
estat sd

svy: mean leisure if sex==1, over(age)
estat sd

svy: mean leisure if sex==2, over(age)
estat sd

svy: mean personalcare, over(age)
estat sd

svy: mean personalcare if sex==1, over(age)
estat sd

svy: mean personalcare if sex==2, over(age)
estat sd

svy: mean residual, over(age)
estat sd

svy: mean residual if sex==1, over(age)
estat sd

svy: mean residual if sex==2, over(age)
estat sd

*homework sub-categories
*housework
generate housework=bls_hhact_hwork*7/60

svy: mean housework, over(age)
estat sd

svy: mean housework if sex==1, over(age)
estat sd

svy: mean housework if sex==2, over(age)
estat sd

*purchasing goods and services
generate shopping=bls_purch*7/60

svy: mean shopping, over(age)
estat sd

svy: mean shopping if sex==1, over(age)
estat sd

mean shopping if sex==2, over(age)
estat sd

*food prep and clean up
generate cooking=bls_hhact_food*7/60

svy: mean cooking, over(age)
estat sd

svy: mean cooking if sex==1, over(age)
estat sd

mean cooking if sex==2, over(age)
estat sd

*lawn and garden care
generate gardening=bls_hhact_lawn*7/60

svy: mean gardening, over(age)
estat sd

svy: mean gardening if sex==1, over(age)
estat sd

svy: mean gardening if sex==2, over(age)
estat sd

*maintenance
generate maintenance=(bls_hhact_inter+bls_hhact_exter+bls_hhact_vehic+bls_hhact_tool)*7/60

svy: mean maintenance, over(age)
estat sd

svy: mean maintenance if sex==1, over(age)
estat sd

svy: mean maintenance if sex==2, over(age)
estat sd


*leisure sub-categories
*watching TV
generate tv=bls_leis_tv*7/60

svy: mean tv, over(age)
estat sd

svy: mean tv if sex==1, over(age)
estat sd

svy: mean tv if sex==2, over(age)
estat sd

*sports and exercise
generate sports=bls_leis_partsport*7/60

svy: mean sports, over(age)
estat sd

svy: mean sports if sex==1, over(age)
estat sd

svy: mean sports if sex==2, over(age)
estat sd

*socializing, hosting/attending social events
generate social=bls_leis_soccom*7/60

svy: mean social, over(age)
estat sd

svy: mean social if sex==1, over(age)
estat sd

svy: mean social if sex==2, over(age)
estat sd

*relaxing -- residual leisure
generate relaxing=leisure-tv-sports-social

svy: mean relaxing, over(age)
estat sd

svy: mean relaxing if sex==1, over(age)
estat sd

svy: mean relaxing if sex==2, over(age)
estat sd




