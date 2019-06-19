**** Read data
use statfi_data, clear
merge m:1 nuts4_94 using nuts4_data_94classification, nogen keep(match master)
merge m:1 syrtun using tilp94vars, nogen keep(match master)

egen fid=group(syrtun)
sort fid vuosi
tsset fid vuosi
gen tol_vuosi=string(nace_2d) + string(vuosi)
* Rename variables
rename lv_tilp lvti 
rename lv_tilp_la1 lvti_la1 
rename lv_tilp_la2 lvti_la2 
rename lv_tilp_le1 lvti_le1 
rename lv_tilp_le2 lvti_le2 
rename lv_tilp_le3 lvti_le3 
rename kaytom kayto 
rename kaytom_la1 kayto_la1 
rename kaytom_la2 kayto_la2 
rename kaytom_le1 kayto_le1 
rename kaytom_le2 kayto_le2 
rename kaytom_le3 kayto_le3 
* Generate variables
gen lrdcons_la1=log(rdcons_la1)
gen lgdpcap_la1=log(gdpcap_la1)
gen lpopden_92_sk94=log(popden_92_sk94)
gen eprod=lvti/hkb
gen eprod_le3=lvti_le3/hkb_le3
gen eprod_le2=lvti_le2/hkb_le2
gen eprod_le1=lvti_le1/hkb_le1
gen eprod_la1=lvti_la1/hkb_la1
gen eprod_la2=lvti_la2/hkb_la2
gen rdint=ysyht/lvti
gen rdint_le3=ysyht_le3/lvti_le3
gen rdint_le2=ysyht_le2/lvti_le2
gen rdint_le1=ysyht_le1/lvti_le1
gen rdint_la1=ysyht_la1/lvti_la1
gen rdint_la2=ysyht_la2/lvti_la2
foreach ylab in ysyht lvti kayto hkb eprod rdint {
	gen l`ylab'=log(`ylab')
	gen l`ylab'_la1=log(`ylab'_la1)
	gen l`ylab'_la1e2=l`ylab'_la1^2
	gen l`ylab'_la1e3=l`ylab'_la1^3
	gen l`ylab'_la2=log(`ylab'_la2)
	gen l`ylab'_la2e2=l`ylab'_la2^2
	gen l`ylab'_le1=log(`ylab'_le1)
	gen l`ylab'_le2=log(`ylab'_le2)
	gen l`ylab'_le3=log(`ylab'_le3)
	gen d2l`ylab'_le1=l`ylab'_le1-l`ylab'_la1 /* Note: The prefix refers to the length of the difference. The suffix refers to the last year of the difference. */
	gen d3l`ylab'_le1=l`ylab'_le1-l`ylab'_la2
	gen d4l`ylab'_le3=l`ylab'_le3-l`ylab'_la1
	gen d1l`ylab'_la1=l`ylab'_la1-l`ylab'_la2	
}
local y=94
gen lkayto`y'=log(kaytom`y')
gen lhkb`y'=log(hk`y')
gen llvti`y'=log(lvti`y')
gen leprod`y'=log(lvti`y'/hk`y')
gen lkayto`y'e2=log(kaytom`y')^2
gen lhkb`y'e2=log(hk`y')^2
gen llvti`y'e2=log(lvti`y')^2
gen leprod`y'e2=log(lvti`y'/hk`y')^2
gen agee2=age^2
gen agee3=age^3
*Location:
*Impute zeros for R&D by ERDF area when it's missing but company R&D is not missing 
replace ysyht_eu0=0 if !missing(ysyht) & missing(ysyht_eu0)
replace ysyht_eu1=0 if !missing(ysyht) & missing(ysyht_eu1)
replace ysyht_eu2=0 if !missing(ysyht) & missing(ysyht_eu2)
replace ysyht_eu4=0 if !missing(ysyht) & missing(ysyht_eu4)
*Impute zeros for employment by ERDF area when it's missing but available for another area
replace hk_eu0=0 if missing(hk_eu0) & (!missing(hk_eu1) | !missing(hk_eu2) | !missing(hk_eu4))
replace hk_eu1=0 if missing(hk_eu1) & (!missing(hk_eu0) | !missing(hk_eu2) | !missing(hk_eu4))
replace hk_eu2=0 if missing(hk_eu2) & (!missing(hk_eu1) | !missing(hk_eu0) | !missing(hk_eu4))
replace hk_eu4=0 if missing(hk_eu4) & (!missing(hk_eu1) | !missing(hk_eu2) | !missing(hk_eu0))
*ERDF area based on location of R&D and employment
gen ysyht_all=ysyht_eu0 + ysyht_eu1 + ysyht_eu2 + ysyht_eu4
gen ysyht_eu024=ysyht_eu0 + ysyht_eu2 + ysyht_eu4
gen hk_all=hk_eu0 + hk_eu1 + hk_eu2 + hk_eu4
gen hk_eu024=hk_eu0 + hk_eu2 + hk_eu4
gen eutk100=""
gen euhk100=""
replace eutk100="1"     if !missing(ysyht_all) &  ysyht_all>0 & ysyht_eu1==ysyht_all 
replace eutk100="0_2_4" if !missing(ysyht_all) & ysyht_all>0 & ysyht_eu024==ysyht_all
replace euhk100="1"     if !missing(hk_all) & hk_all>0 & hk_eu1==hk_all
replace euhk100="0_2_4" if !missing(hk_all) & hk_all>0 & hk_eu024==hk_all
gen eualue100=eutk100
replace eualue100=euhk100 if eutk100==""  & !(ysyht_eu1>0 & ysyht_eu024>0) & !missing(ysyht_eu1) & !missing(ysyht_eu024)
gen dist00=di00sk94ce
replace dist00=-dist00 if eualue100=="1"
gen eualue100i=1 if eualue100=="1"
replace eualue100i=0 if eualue100=="0_2_4"
* Treatment group
gen enter_program=.
replace enter_program=1 if (fund_la1==0 & myon_avus>0 & tukis_le1>0 & !missing(myon_avus) & !missing(tukis_le1))
* Controls
replace enter_program=0 if vuosi==2000 & fund_la1==0 & fund==0 & fund_le1==0 & F1.enter_program!=1 & F2.enter_program!=1 & F3.enter_program!=1 & F4.enter_program!=1 & F5.enter_program!=1 
replace enter_program=0 if vuosi==2001 &  L1.fund==0 & fund==0 & fund_le1==0 & L1.enter_program!=1 & F1.enter_program!=1 & F2.enter_program!=1 & F3.enter_program!=1 & F4.enter_program!=1
replace enter_program=0 if vuosi==2002 &  L1.fund==0 & fund==0 & fund_le1==0 & L2.enter_program!=1 & L1.enter_program!=1 & F1.enter_program!=1 & F2.enter_program!=1 & F3.enter_program!=1
replace enter_program=0 if vuosi==2003 &  L1.fund==0 & fund==0 & fund_le1==0 & L3.enter_program!=1 & L2.enter_program!=1 & L1.enter_program!=1 & F1.enter_program!=1 & F2.enter_program!=1
replace enter_program=0 if vuosi==2004 &  L1.fund==0 & fund==0 & fund_le1==0 & L4.enter_program!=1 & L3.enter_program!=1 & L2.enter_program!=1 & L1.enter_program!=1 & F1.enter_program!=1
replace enter_program=0 if vuosi==2005 &  L1.fund==0 & fund==0 & fund_le1==0 & L5.enter_program!=1 & L4.enter_program!=1 & L3.enter_program!=1 & L2.enter_program!=1 & L1.enter_program!=1
* Variable labels
lab var enter_program "R&D subsidy grantee"
lab var eualue100i "ERDF Objective 1"
lab var lpopden_92_sk94 "log(Population density 1992)"







