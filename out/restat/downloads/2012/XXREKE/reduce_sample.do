set memory 1000m
log using complications_1.log, replace
set more off
use stata_all_1

* we ran into space constraints so we delete some 
* variables that are not used in teh regression analysis
drop paymsold _losm feduc nbiccl prevsts paymsopc cntyresm paymso95m chargesi paymso95i 
drop pay_catm pay_planm pay_cati pay_plani readmission7i readmission14i log_totalcharge
drop drgm adm90to180

* we compress teh data to save some more space
compress

* there are two key variables in the original data that 
* indicate problems during pregnancy (probl_1) and
* problems during childbirth (probl_2).  in the lines
* below we extract all these problems and then construct 
* 48 dummy variables to indicate the presence of any of these
* problems.  we end up not using all of these in the 
* regressions -- please see teh test about which ones were
* selected for use

gen probl_1_01=substr(probl_1,1,2)
gen probl_1_02=substr(probl_1,3,2)
gen probl_1_03=substr(probl_1,5,2)
gen probl_1_04=substr(probl_1,7,2)
gen probl_1_05=substr(probl_1,9,2)
gen probl_1_06=substr(probl_1,11,2)
gen probl_1_07=substr(probl_1,13,2)
gen probl_1_08=substr(probl_1,15,2)
gen probl_1_09=substr(probl_1,17,2)
gen probl_1_10=substr(probl_1,19,2)
gen probl_1_11=substr(probl_1,21,2)
gen probl_1_12=substr(probl_1,23,2)
gen probl_1_13=substr(probl_1,25,2)
gen probl_1_14=substr(probl_1,27,2)
gen probl_1_15=substr(probl_1,29,2)
gen probl_1_16=substr(probl_1,31,2)


gen probl_2_01=substr(probl_2,1,2)
gen probl_2_02=substr(probl_2,3,2)
gen probl_2_03=substr(probl_2,5,2)
gen probl_2_04=substr(probl_2,7,2)
gen probl_2_05=substr(probl_2,9,2)
gen probl_2_06=substr(probl_2,11,2)
gen probl_2_07=substr(probl_2,13,2)
gen probl_2_08=substr(probl_2,15,2)
gen probl_2_09=substr(probl_2,17,2)


gen preeclempsia=probl_1_01=="01" | probl_1_02=="01" | probl_1_03=="01" | probl_1_04=="01" | probl_1_05=="01" | probl_1_06=="01" | probl_1_07=="01" | probl_1_08=="01" | probl_1_09=="01" | probl_1_10=="01" | probl_1_11=="01" | probl_1_12=="01" | probl_1_13=="01" | probl_1_14 =="01" | probl_1_15=="01" | probl_1_16=="01" | probl_2_01=="01" | probl_2_02=="01" | probl_2_03=="01" | probl_2_04=="01" | probl_2_05=="01" | probl_2_06=="01" | probl_2_07=="01" | probl_2_08=="01" | probl_2_09=="01" 
gen eclampsia=probl_1_01=="02" | probl_1_02=="02" | probl_1_03=="02" | probl_1_04=="02" | probl_1_05=="02" | probl_1_06=="02" | probl_1_07=="02" | probl_1_08=="02" | probl_1_09=="02" | probl_1_10=="02" | probl_1_11=="02" | probl_1_12=="02" | probl_1_13=="02" | probl_1_14 =="02" | probl_1_15=="02" | probl_1_16=="02" | probl_2_01=="02" | probl_2_02=="02" | probl_2_03=="02" | probl_2_04=="02" | probl_2_05=="02" | probl_2_06=="02" | probl_2_07=="02" | probl_2_08=="02" | probl_2_09=="02" 
gen hypertension=probl_1_01=="03" | probl_1_02=="03" | probl_1_03=="03" | probl_1_04=="03" | probl_1_05=="03" | probl_1_06=="03" | probl_1_07=="03" | probl_1_08=="03" | probl_1_09=="03" | probl_1_10=="03" | probl_1_11=="03" | probl_1_12=="03" | probl_1_13=="03" | probl_1_14 =="03" | probl_1_15=="03" | probl_1_16=="03"
gen renal_disease=probl_1_01=="04" | probl_1_02=="04" | probl_1_03=="04" | probl_1_04=="04" | probl_1_05=="04" | probl_1_06=="04" | probl_1_07=="04" | probl_1_08=="04" | probl_1_09=="04" | probl_1_10=="04" | probl_1_11=="04" | probl_1_12=="04" | probl_1_13=="04" | probl_1_14 =="04" | probl_1_15=="04" | probl_1_16=="04"
gen pyelonephritis=probl_1_01=="05" | probl_1_02=="05" | probl_1_03=="05" | probl_1_04=="05" | probl_1_05=="05" | probl_1_06=="05" | probl_1_07=="05" | probl_1_08=="05" | probl_1_09=="05" | probl_1_10=="05" | probl_1_11=="05" | probl_1_12=="05" | probl_1_13=="05" | probl_1_14 =="05" | probl_1_15=="05" | probl_1_16=="05"
gen anemia=probl_1_01=="06" | probl_1_02=="06" | probl_1_03=="06" | probl_1_04=="06" | probl_1_05=="06" | probl_1_06=="06" | probl_1_07=="06" | probl_1_08=="06" | probl_1_09=="06" | probl_1_10=="06" | probl_1_11=="06" | probl_1_12=="06" | probl_1_13=="06" | probl_1_14 =="06" | probl_1_15=="06" | probl_1_16=="06"
gen cardiac_disease=probl_1_01=="07" | probl_1_02=="07" | probl_1_03=="07" | probl_1_04=="07" | probl_1_05=="07" | probl_1_06=="07" | probl_1_07=="07" | probl_1_08=="07" | probl_1_09=="07" | probl_1_10=="07" | probl_1_11=="07" | probl_1_12=="07" | probl_1_13=="07" | probl_1_14 =="07" | probl_1_15=="07" | probl_1_16=="07"
gen lung_disease=probl_1_01=="08" | probl_1_02=="08" | probl_1_03=="08" | probl_1_04=="08" | probl_1_05=="08" | probl_1_06=="08" | probl_1_07=="08" | probl_1_08=="08" | probl_1_09=="08" | probl_1_10=="08" | probl_1_11=="08" | probl_1_12=="08" | probl_1_13=="08" | probl_1_14 =="08" | probl_1_15=="08" | probl_1_16=="08"
gen diabetes=probl_1_01=="09" | probl_1_02=="09" | probl_1_03=="09" | probl_1_04=="09" | probl_1_05=="09" | probl_1_06=="09" | probl_1_07=="09" | probl_1_08=="09" | probl_1_09=="09" | probl_1_10=="09" | probl_1_11=="09" | probl_1_12=="09" | probl_1_13=="09" | probl_1_14 =="09" | probl_1_15=="09" | probl_1_16=="09"
gen rh_sensitive=probl_1_01=="10" | probl_1_02=="10" | probl_1_03=="10" | probl_1_04=="10" | probl_1_05=="10" | probl_1_06=="10" | probl_1_07=="10" | probl_1_08=="10" | probl_1_09=="10" | probl_1_10=="10" | probl_1_11=="10" | probl_1_12=="10" | probl_1_13=="10" | probl_1_14 =="10" | probl_1_15=="10" | probl_1_16=="10"
gen uterine_bleeding=probl_1_01=="12" | probl_1_02=="12" | probl_1_03=="12" | probl_1_04=="12" | probl_1_05=="12" | probl_1_06=="12" | probl_1_07=="12" | probl_1_08=="12" | probl_1_09=="12" | probl_1_10=="12" | probl_1_11=="12" | probl_1_12=="12" | probl_1_13=="12" | probl_1_14 =="12" | probl_1_15=="12" | probl_1_16=="12"
gen Hemoglobinopathy=probl_1_01=="11" | probl_1_02=="11" | probl_1_03=="11" | probl_1_04=="11" | probl_1_05=="11" | probl_1_06=="11" | probl_1_07=="11" | probl_1_08=="11" | probl_1_09=="11" | probl_1_10=="11" | probl_1_11=="11" | probl_1_12=="11" | probl_1_13=="11" | probl_1_14 =="11" | probl_1_15=="11" | probl_1_16=="11"
gen Polyhydramnios=probl_1_01=="13" | probl_1_02=="13" | probl_1_03=="13" | probl_1_04=="13" | probl_1_05=="13" | probl_1_06=="13" | probl_1_07=="13" | probl_1_08=="13" | probl_1_09=="13" | probl_1_10=="13" | probl_1_11=="13" | probl_1_12=="13" | probl_1_13=="13" | probl_1_14 =="13" | probl_1_15=="13" | probl_1_16=="13"
gen incompetent_cervix=probl_1_01=="14" | probl_1_02=="14" | probl_1_03=="14" | probl_1_04=="14" | probl_1_05=="14" | probl_1_06=="14" | probl_1_07=="14" | probl_1_08=="14" | probl_1_09=="14" | probl_1_10=="14" | probl_1_11=="14" | probl_1_12=="14" | probl_1_13=="14" | probl_1_14 =="14" | probl_1_15=="14" | probl_1_16=="14"
gen premature_labor=probl_1_01=="15" | probl_1_02=="15" | probl_1_03=="15" | probl_1_04=="15" | probl_1_05=="15" | probl_1_06=="15" | probl_1_07=="15" | probl_1_08=="15" | probl_1_09=="15" | probl_1_10=="15" | probl_1_11=="15" | probl_1_12=="15" | probl_1_13=="15" | probl_1_14 =="15" | probl_1_15=="15" | probl_1_16=="15"
gen genital_herpes=probl_1_01=="16" | probl_1_02=="16" | probl_1_03=="16" | probl_1_04=="16" | probl_1_05=="16" | probl_1_06=="16" | probl_1_07=="16" | probl_1_08=="16" | probl_1_09=="16" | probl_1_10=="16" | probl_1_11=="16" | probl_1_12=="16" | probl_1_13=="16" | probl_1_14 =="16" | probl_1_15=="16" | probl_1_16=="16"
gen oth_std=probl_1_01=="17" | probl_1_02=="17" | probl_1_03=="17" | probl_1_04=="17" | probl_1_05=="17" | probl_1_06=="17" | probl_1_07=="17" | probl_1_08=="17" | probl_1_09=="17" | probl_1_10=="17" | probl_1_11=="17" | probl_1_12=="17" | probl_1_13=="17" | probl_1_14 =="17" | probl_1_15=="17" | probl_1_16=="17"
gen hepb=probl_1_01=="18" | probl_1_02=="18" | probl_1_03=="18" | probl_1_04=="18" | probl_1_05=="18" | probl_1_06=="18" | probl_1_07=="18" | probl_1_08=="18" | probl_1_09=="18" | probl_1_10=="18" | probl_1_11=="18" | probl_1_12=="18" | probl_1_13=="18" | probl_1_14 =="18" | probl_1_15=="18" | probl_1_16=="18"
gen rubella=probl_1_01=="19" | probl_1_02=="19" | probl_1_03=="19" | probl_1_04=="19" | probl_1_05=="19" | probl_1_06=="19" | probl_1_07=="19" | probl_1_08=="19" | probl_1_09=="19" | probl_1_10=="19" | probl_1_11=="19" | probl_1_12=="19" | probl_1_13=="19" | probl_1_14 =="19" | probl_1_15=="19" | probl_1_16=="19"
gen smoking=probl_1_01=="20" | probl_1_02=="20" | probl_1_03=="20" | probl_1_04=="20" | probl_1_05=="20" | probl_1_06=="20" | probl_1_07=="20" | probl_1_08=="20" | probl_1_09=="20" | probl_1_10=="20" | probl_1_11=="20" | probl_1_12=="20" | probl_1_13=="20" | probl_1_14 =="20" | probl_1_15=="20" | probl_1_16=="20"
gen greater_4000=probl_1_01=="21" | probl_1_02=="21" | probl_1_03=="21" | probl_1_04=="21" | probl_1_05=="21" | probl_1_06=="21" | probl_1_07=="21" | probl_1_08=="21" | probl_1_09=="21" | probl_1_10=="21" | probl_1_11=="21" | probl_1_12=="21" | probl_1_13=="21" | probl_1_14 =="21" | probl_1_15=="21" | probl_1_16=="21"
gen less_2500=probl_1_01=="22" | probl_1_02=="22" | probl_1_03=="22" | probl_1_04=="22" | probl_1_05=="22" | probl_1_06=="22" | probl_1_07=="22" | probl_1_08=="22" | probl_1_09=="22" | probl_1_10=="22" | probl_1_11=="22" | probl_1_12=="22" | probl_1_13=="22" | probl_1_14 =="22" | probl_1_15=="22" | probl_1_16=="22"
gen cervical_cerclage=probl_1_01=="24" | probl_1_02=="24" | probl_1_03=="24" | probl_1_04=="24" | probl_1_05=="24" | probl_1_06=="24" | probl_1_07=="24" | probl_1_08=="24" | probl_1_09=="24" | probl_1_10=="24" | probl_1_11=="24" | probl_1_12=="24" | probl_1_13=="24" | probl_1_14 =="24" | probl_1_15=="24" | probl_1_16=="24"
gen less_37week=probl_1_01=="23" | probl_1_02=="23" | probl_1_03=="23" | probl_1_04=="23" | probl_1_05=="23" | probl_1_06=="23" | probl_1_07=="23" | probl_1_08=="23" | probl_1_09=="23" | probl_1_10=="23" | probl_1_11=="23" | probl_1_12=="23" | probl_1_13=="23" | probl_1_14 =="23" | probl_1_15=="23" | probl_1_16=="23"
gen chronic_villus=probl_1_01=="25" | probl_1_02=="25" | probl_1_03=="25" | probl_1_04=="25" | probl_1_05=="25" | probl_1_06=="25" | probl_1_07=="25" | probl_1_08=="25" | probl_1_09=="25" | probl_1_10=="25" | probl_1_11=="25" | probl_1_12=="25" | probl_1_13=="25" | probl_1_14 =="25" | probl_1_15=="25" | probl_1_16=="25"

gen preeclempsia_delivery=probl_2_01=="01" | probl_2_02=="01" | probl_2_03=="01" | probl_2_04=="01" | probl_2_05=="01" | probl_2_06=="01" | probl_2_07=="01" | probl_2_08=="01" | probl_2_09=="01" 
gen eclempsia_delivery=probl_2_01=="02" | probl_2_02=="02" | probl_2_03=="02" | probl_2_04=="02" | probl_2_05=="02" | probl_2_06=="02" | probl_2_07=="02" | probl_2_08=="02" | probl_2_09=="02" 
gen seizure_delivery=probl_2_01=="03" | probl_2_02=="03" | probl_2_03=="03" | probl_2_04=="03" | probl_2_05=="03" | probl_2_06=="03" | probl_2_07=="03" | probl_2_08=="03" | probl_2_09=="03" 
gen fetopelvic_delivery=probl_2_01=="04" | probl_2_02=="04" | probl_2_03=="04" | probl_2_04=="04" | probl_2_05=="04" | probl_2_06=="04" | probl_2_07=="04" | probl_2_08=="04" 
gen shoulder_delivery=probl_2_01=="05" | probl_2_02=="05" | probl_2_03=="05" | probl_2_04=="05" | probl_2_05=="05" | probl_2_06=="05" | probl_2_07=="05" | probl_2_08=="05" | probl_2_09=="05" 
gen breech_delivery=probl_2_01=="06" | probl_2_02=="06" | probl_2_03=="06" | probl_2_04=="06" | probl_2_05=="06" | probl_2_06=="06" | probl_2_07=="06" | probl_2_08=="06" | probl_2_09=="06" 
gen precipitous_delivery=probl_2_01=="07" | probl_2_02=="07" | probl_2_03=="07" | probl_2_04=="07" | probl_2_05=="07" | probl_2_06=="07" | probl_2_07=="07" | probl_2_08=="07" | probl_2_09=="07" 
gen prolonged_delivery=probl_2_01=="08" | probl_2_02=="08" | probl_2_03=="08" | probl_2_04=="08" | probl_2_05=="08" | probl_2_06=="08" | probl_2_07=="08" | probl_2_08=="08" | probl_2_09=="08" 
gen other_dysfunctional_delivery=probl_2_01=="09" | probl_2_02=="09" | probl_2_03=="09" | probl_2_04=="09" | probl_2_05=="09" | probl_2_06=="09" | probl_2_07=="09" | probl_2_08=="09" | probl_2_09=="09" 
gen premature_rupture_delivery=probl_2_01=="10" | probl_2_02=="10" | probl_2_03=="10" | probl_2_04=="10" | probl_2_05=="10" | probl_2_06=="10" | probl_2_07=="10" | probl_2_08=="10" | probl_2_09=="10" 
gen abruptio_placenta_delivery=probl_2_01=="13" | probl_2_02=="13" | probl_2_03=="13" | probl_2_04=="13" | probl_2_05=="13" | probl_2_06=="13" | probl_2_07=="13" | probl_2_08=="13" | probl_2_09=="13" 
gen placenta_previa_delivery=probl_2_01=="14" | probl_2_02=="14" | probl_2_03=="14" | probl_2_04=="14" | probl_2_05=="14" | probl_2_06=="14" | probl_2_07=="14" | probl_2_08=="14" | probl_2_09=="14" 
gen bleeding_delivery=probl_2_01=="15" | probl_2_02=="15" | probl_2_03=="15" | probl_2_04=="15" | probl_2_05=="15" | probl_2_06=="15" | probl_2_07=="15" | probl_2_08=="15" | probl_2_09=="15" 
gen herpes_delivery=probl_2_01=="16" | probl_2_02=="16" | probl_2_03=="16" | probl_2_04=="16" | probl_2_05=="16" | probl_2_06=="16" | probl_2_07=="16" | probl_2_08=="16" | probl_2_09=="16" 
gen sepsis_delivery=probl_2_01=="17" | probl_2_02=="17" | probl_2_03=="17" | probl_2_04=="17" | probl_2_05=="17" | probl_2_06=="17" | probl_2_07=="17" | probl_2_08=="17" | probl_2_09=="17" 
gen febrile_delivery=probl_2_01=="18" | probl_2_02=="18" | probl_2_03=="18" | probl_2_04=="18" | probl_2_05=="18" | probl_2_06=="18" | probl_2_07=="18" | probl_2_08=="18" | probl_2_09=="18" 
gen meconium_delivery=probl_2_01=="19" | probl_2_02=="19" | probl_2_03=="19" | probl_2_04=="19" | probl_2_05=="19" | probl_2_06=="19" | probl_2_07=="19" | probl_2_08=="19" | probl_2_09=="19" 
gen cord_prolapse_delivery=probl_2_01=="20" | probl_2_02=="20" | probl_2_03=="20" | probl_2_04=="20" | probl_2_05=="20" | probl_2_06=="20" | probl_2_07=="20" | probl_2_08=="20" | probl_2_09=="20" 
gen fetal_distress_delivery=probl_2_01=="21" | probl_2_02=="21" | probl_2_03=="21" | probl_2_04=="21" | probl_2_05=="21" | probl_2_06=="21" | probl_2_07=="21" | probl_2_08=="21" | probl_2_09=="21" 
gen anesthetic_comp_delivery=probl_2_01=="22" | probl_2_02=="22" | probl_2_03=="22" | probl_2_04=="22" | probl_2_05=="22" | probl_2_06=="22" | probl_2_07=="22" | probl_2_08=="22" | probl_2_09=="22" 
gen unsucc_vag_delivery=probl_2_01=="23" | probl_2_02=="23" | probl_2_03=="23" | probl_2_04=="23" | probl_2_05=="23" | probl_2_06=="23" | probl_2_07=="23" | probl_2_08=="23" | probl_2_09=="23" 
gen maternal_transfusion_delivery=probl_2_01=="24" | probl_2_02=="24" | probl_2_03=="24" | probl_2_04=="24" | probl_2_05=="24" | probl_2_06=="24" | probl_2_07=="24" | probl_2_08=="24" | probl_2_09=="24" 
gen transport_delivery=probl_2_01=="25" | probl_2_02=="25" | probl_2_03=="25" | probl_2_04=="25" | probl_2_05=="25" | probl_2_06=="25" | probl_2_07=="25" | probl_2_08=="25" | probl_2_09=="25" 

compress

*drop aggregate problem variables
drop probl_*

*rename variables
rename preeclempsia prob01
rename eclampsia prob02
rename hypertension prob03 
rename renal_disease  prob04
rename pyelonephritis  prob05
rename anemia  prob06
rename cardiac_disease prob07 
rename lung_disease  prob08
rename diabetes  prob09
rename rh_sensitive  prob10
rename uterine_bleeding prob11
rename Hemoglobinopathy  prob12
rename transport_delivery prob13
rename Polyhydramnios  prob14
rename incompetent_cervix  prob15
rename premature_labor  prob16
rename genital_herpes  prob17
rename oth_std  prob18
rename hepb  prob19
rename rubella  prob20
rename smoking  prob21
rename greater_4000  prob22
rename less_2500  prob23
rename cervical_cerclage  prob24
rename less_37week  prob25
rename chronic_villus  prob26
rename preeclempsia_delivery  prob27
rename eclempsia_delivery  prob28
rename seizure_delivery  prob29
rename maternal_transfusion_delivery  prob30
rename fetopelvic_delivery  prob31
rename shoulder_delivery  prob32
rename breech_delivery  prob33
rename precipitous_delivery  prob34
rename prolonged_delivery  prob35
rename vbac_delivery  prob36
rename other_dysfunctional_delivery  prob37
rename premature_rupture_delivery  prob38
rename abruptio_placenta_delivery  prob39
rename placenta_previa_delivery prob40
rename bleeding_delivery  prob41
rename herpes_delivery  prob42
rename sepsis_delivery  prob43
rename febrile_delivery  prob44
rename meconium_delivery  prob45
rename cord_prolapse_delivery  prob46
rename fetal_distress_delivery  prob47
rename anesthetic_comp_delivery  prob48


replace prob01=1 if prob01==0 & prob27==1
replace prob02=1 if prob02==0 & prob28==1
replace prob17=1 if prob17==0 & prob42==1

drop prob27
drop prob28
drop prob42

compress
save stata_all_2, replace
