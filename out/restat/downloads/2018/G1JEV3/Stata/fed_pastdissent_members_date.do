// 1.2 - Create Past Dissent behavior by day of vote and by governor
use "$path1\FED_dissent_date_governors.dta", clear
sum date_FOMC
local d1=r(min)
local d2=r(max)  //sum id_member local i1=r(min) local i2=r(max) local adj_v = 1.615
g past_dissent_pc_member = 0
g past_dissent_pcm = 0
quietly { //exp_votes_all exp_votes_dissents
forv d=`d1'/`d2' {
g v_temp_diss = dissent if date_FOMC<`d'
bysort id_member: egen Dvotes_all0 = mean(v_temp_diss)
bysort id_member: egen Nvotes_all0 = count(v_temp_diss)
replace past_dissent_pc_member=Dvotes_all0 if date_FOMC==`d' & Dvotes_all0<.
replace past_dissent_pcm= 0.05*((1)/(1+Nvotes_all0)) + Dvotes_all0*((Nvotes_all0-1)/(1+Nvotes_all0)) if date_FOMC==`d' & Dvotes_all0<.
drop Dvotes_all0 Nvotes_all0 v_temp_diss  // forv i=`i1'/`i2' {    *}
}
g v_temp_diss=past_dissent_pc_member if dissent==1
bysort date_FOMC: egen past_dissent_pc_Dmembers = mean(v_temp_diss)
replace past_dissent_pc_Dmembers = 0 if past_dissent_pc_Dmembers==.
drop v_temp_diss
g v_temp_diss=past_dissent_pcm if dissent==1
bysort date_FOMC: egen past_dissent_pc_Dm = mean(v_temp_diss)
replace past_dissent_pc_Dm= 0 if past_dissent_pc_Dm==.
drop v_temp_diss
}
save "$path1\\FED_dissent_date_governors2.dta", replace
collapse past_dissent_pc_Dmembers past_dissent_pc_Dm past_dissent_pc_member past_dissent_pcm, by(date_FOMC)
save "$path1\\dissent_pastTrack.dta", replace
