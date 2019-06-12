capture use "C:\Users\KKOSEC\Desktop\apsr_aspirations_construction_041617.dta", clear

***Construct index of aspirations where we record aspirations in terms of S.D.'s above your district's mean (MEASURE 1)

*Generate weights for each of four dimensions

forvalues x=1/4 {
replace A_5_`x'=. if A_5_`x'>20|A_5_`x'==-88
}
gen weight_income=A_5_1/20
gen weight_assets=A_5_2/20
gen weight_socstatus=A_5_3/20
gen weight_educ=A_5_4/20

foreach x in inc asset socstat educ {
label var weight_`x' "Weight placed on `x' (share of beans)"
}

*Turn education level data into years of education

replace A_4_1=. if A_4_1<0
gen yrseduc=A_4_1
replace yrseduc=14 if A_4_1==13
replace yrseduc=16 if A_4_1==14
replace yrseduc=17 if A_4_1==15
replace yrseduc=16 if A_4_1==16
replace yrseduc=17 if A_4_1==17
replace yrseduc=12 if A_4_1==18
replace yrseduc=5 if A_4_1==19
replace yrseduc=5 if A_4_1==20
replace yrseduc=5 if A_4_1==21
replace yrseduc=0 if A_4_1==22
replace yrseduc=0 if A_4_1==23
label var yrseduc "What is the number of years of education that you have now?"

replace A_4_2=. if A_4_2<0
gen aspyrseduc=A_4_2
replace aspyrseduc=14 if A_4_2==13
replace aspyrseduc=16 if A_4_2==14
replace aspyrseduc=17 if A_4_2==15
replace aspyrseduc=16 if A_4_2==16
replace aspyrseduc=17 if A_4_2==17
replace aspyrseduc=12 if A_4_2==18
replace aspyrseduc=5 if A_4_2==19
replace aspyrseduc=5 if A_4_2==20
replace aspyrseduc=5 if A_4_2==21
replace aspyrseduc=0 if A_4_2==22
label var aspyrseduc "What is the number of years of education that you would like to achieve?"

*Income dimension

replace A_1_2=. if A_1_2<0
bysort district: egen locavgaspinc=mean(A_1_2)
bysort district: egen locsdaspinc=sd(A_1_2)
label var locavgaspinc "Mean of income people in sample would like to achieve"
label var locsdaspinc "S.D. of income people in sample would like to achieve"

gen asplevellocinc=(A_1_2-locavgaspinc)/locsdaspinc
label var asplevellocinc "Aspirations Index - income dimension only"

*Assets dimension

replace A_2_2=. if A_2_2<0
bysort district: egen locavgaspassets=mean(A_2_2)
bysort district: egen locsdaspassets=sd(A_2_2)
label var locavgaspassets "Mean of assets people in sample would like to achieve"
label var locsdaspassets "S.D. of assets people in sample would like to achieve"

gen asplevellocassets=(A_2_2-locavgaspassets)/locsdaspassets
label var asplevellocassets "Aspirations Index - assets dimension only"

*Social status dimension

replace A_3_2=. if A_3_2<0
bysort district: egen locavgaspsocstatus=mean(A_3_2)
bysort district: egen locsdaspsocstatus=sd(A_3_2)
label var locavgaspsocstatus "Mean of social status people in sample would like to achieve"
label var locsdaspsocstatus "S.D. of social status people in sample would like to achieve"

gen asplevellocsocstatus=(A_3_2-locavgaspsocstatus)/locsdaspsocstatus
label var asplevellocsocstatus "Aspirations Index - social status dimension only"

*Education dimension

bysort district: egen locavgaspyrseduc=mean(aspyrseduc)
bysort district: egen locsdaspyrseduc=sd(aspyrseduc)
label var locavgaspyrseduc "Mean of years of education people in sample would like to achieve"
label var locsdaspyrseduc "S.D. of years of education people in sample would like to achieve"

gen asplevellocyrseduc=(aspyrseduc-locavgaspyrseduc)/locsdaspyrseduc
label var asplevellocyrseduc "Aspirations Index - years of education dimension only"

*Aggregate aspirations index

foreach x in asplevellocinc asplevellocassets asplevellocsocstatus asplevellocyrseduc {
gen temp_`x'=`x'
}

*Create a temporary variable that ensures that the variable aspirationsindex is not missing just becuase there is missing data for a dimension of aspirations level on which a person has missing data but ALSO places no weight on that dimenion. Essentially, if I fail to answer questions on income and therefore have a missing value for asplevellocinc, and yet I place 0 value on income, then you can still compute an aspirations index for me (i.e. it should not be missing)
replace temp_asplevellocinc=0 if temp_asplevellocinc==. & weight_income==0
replace temp_asplevellocassets=0 if temp_asplevellocassets==. & weight_assets==0
replace temp_asplevellocsocstatus=0 if temp_asplevellocsocstatus==. & weight_socstatus==0
replace temp_asplevellocyrseduc=0 if temp_asplevellocyrseduc==. & weight_educ==0

gen aspirationlevel= temp_asplevellocinc*weight_income + temp_asplevellocassets*weight_assets + temp_asplevellocsocstatus*weight_socstatus + temp_asplevellocyrseduc*weight_educ
label var aspirationlevel "Aspirations Level (relative to district) (4 dimensions weighted by personal importance)"
drop temp* locavgasp* locsdasp*
