recode wave1q2 (99=3), into(wave1q2_rc)

recode wave2q2 (99=3), into(wave2q2_rc)

*Control Group
mprobit wave2q2_rc i.wave1q2_rc if split==1
margins, at(wave1q2_rc=1) 
margins, at(wave1q2_rc=2) 
margins, at(wave1q2_rc=3) 

*Pro cultural, pro Economic, pro Political
mprobit wave2q2_rc i.wave1q2_rc if split==2
margins, at(wave1q2_rc=1) 
margins, at(wave1q2_rc=2) 
margins, at(wave1q2_rc=3) 

*Anti cultural, pro Economic, pro Political 
mprobit wave2q2_rc i.wave1q2_rc if split==3
margins, at(wave1q2_rc=1) 
margins, at(wave1q2_rc=2) 
margins, at(wave1q2_rc=3) 

*Pro cultural, anti Economic, pro Political 
mprobit wave2q2_rc i.wave1q2_rc if split==4
margins, at(wave1q2_rc=1) 
margins, at(wave1q2_rc=2) 
margins, at(wave1q2_rc=3) 

*Anti cultural, anti Economic, pro Political 
mprobit wave2q2_rc i.wave1q2_rc if split==5
margins, at(wave1q2_rc=1) 
margins, at(wave1q2_rc=2) 
margins, at(wave1q2_rc=3) 

*Pro cultural, pro Economic, anti Political 
mprobit wave2q2_rc i.wave1q2_rc if split==6
margins, at(wave1q2_rc=1) 
margins, at(wave1q2_rc=2) 
margins, at(wave1q2_rc=3) 

*Anti cultural, pro Economic, anti Political
mprobit wave2q2_rc i.wave1q2_rc if split==7
margins, at(wave1q2_rc=1) 
margins, at(wave1q2_rc=2) 
margins, at(wave1q2_rc=3) 

*Pro cultural, anti Economic, anti Political
mprobit wave2q2_rc i.wave1q2_rc if split==8
margins, at(wave1q2_rc=1) 
margins, at(wave1q2_rc=2) 
margins, at(wave1q2_rc=3) 

*Anti cultural, anti Economic, anti Political
mprobit wave2q2_rc i.wave1q2_rc if split==9
margins, at(wave1q2_rc=1) 
margins, at(wave1q2_rc=2) 
margins, at(wave1q2_rc=3) 




*For creating the Transitions Probabilities Figure

graph pie pc_pe_pp if wave1=="Remain", over(wave2) legend(off) name(pc_pe_pp_R, replace) nodraw 
graph pie pc_pe_pp if wave1=="DK", over(wave2) legend(off) name(pc_pe_pp_D, replace) nodraw
graph pie pc_pe_pp if wave1=="Leave", over(wave2) legend(off) name(pc_pe_pp_L, replace) nodraw

graph pie pc_pe_ap if wave1=="Remain", over(wave2) legend(off) name(pc_pe_ap_R, replace) nodraw 
graph pie pc_pe_ap if wave1=="DK", over(wave2) legend(off) name(pc_pe_ap_D, replace) nodraw
graph pie pc_pe_ap if wave1=="Leave", over(wave2) legend(off) name(pc_pe_ap_L, replace) nodraw

graph pie ac_pe_pp if wave1=="Remain", over(wave2) legend(off) name(ac_pe_pp_R, replace) nodraw 
graph pie ac_pe_pp if wave1=="DK", over(wave2) legend(off) name(ac_pe_pp_D, replace) nodraw
graph pie ac_pe_pp if wave1=="Leave", over(wave2) legend(off) name(ac_pe_pp_L, replace) nodraw

graph pie pc_ae_pp if wave1=="Remain", over(wave2) legend(off) name(pc_ae_pp_R, replace) nodraw 
graph pie pc_ae_pp if wave1=="DK", over(wave2) legend(off) name(pc_ae_pp_D, replace) nodraw
graph pie pc_ae_pp if wave1=="Leave", over(wave2) legend(off) name(pc_ae_pp_L, replace) nodraw

graph pie control if wave1=="Remain", over(wave2) legend(off) name(control_R, replace) nodraw 
graph pie control if wave1=="DK", over(wave2) legend(off) name(control_D, replace) nodraw
graph pie control if wave1=="Leave", over(wave2) legend(off) name(control_L, replace) nodraw

graph pie ac_ae_pp if wave1=="Remain", over(wave2) legend(off) name(ac_ae_pp_R, replace) nodraw 
graph pie ac_ae_pp if wave1=="DK", over(wave2) legend(off) name(ac_ae_pp_D, replace) nodraw
graph pie ac_ae_pp if wave1=="Leave", over(wave2) legend(off) name(ac_ae_pp_L, replace) nodraw

graph pie pc_ae_ap if wave1=="Remain", over(wave2) legend(off) name(pc_ae_ap_R, replace) nodraw 
graph pie pc_ae_ap if wave1=="DK", over(wave2) legend(off) name(pc_ae_ap_D, replace) nodraw
graph pie pc_ae_ap if wave1=="Leave", over(wave2) legend(off) name(pc_ae_ap_L, replace) nodraw

graph pie ac_pe_ap if wave1=="Remain", over(wave2) legend(off) name(ac_pe_ap_R, replace) nodraw 
graph pie ac_pe_ap if wave1=="DK", over(wave2) legend(off) name(ac_pe_ap_D, replace) nodraw
graph pie ac_pe_ap if wave1=="Leave", over(wave2) legend(off) name(ac_pe_ap_L, replace) nodraw

graph pie ac_ae_ap if wave1=="Remain", over(wave2) legend(off) name(ac_ae_ap_R, replace) nodraw 
graph pie ac_ae_ap if wave1=="DK", over(wave2) legend(off) name(ac_ae_ap_D, replace) nodraw
graph pie ac_ae_ap if wave1=="Leave", over(wave2) legend(off) name(ac_ae_ap_L, replace) nodraw

graph combine pc_pe_pp_R pc_pe_pp_D pc_pe_pp_L ///
pc_pe_ap_R pc_pe_ap_D pc_pe_ap_L ///
ac_pe_pp_R ac_pe_pp_D ac_pe_pp_L ///
pc_ae_pp_R pc_ae_pp_D pc_ae_pp_L ///
control_R control_D control_L ///
ac_ae_pp_R ac_ae_pp_D ac_ae_pp_L ///
pc_ae_ap_R pc_ae_ap_D pc_ae_ap_L ///
ac_pe_ap_R ac_pe_ap_D ac_pe_ap_L ///
ac_ae_ap_R ac_ae_ap_D ac_ae_ap_L, rows(9) graphregion(fcolor(white))


graph pie pc_pe_pp if wave1=="Remain", over(wave2)





graph bar (asis) pc_pe_pp if wave1=="Remain", over(wave2) legend(off) name(pc_pe_pp_R, replace) 



graph bar pc_pe_pp if wave1=="Remain", over(wave2) legend(off) name(pc_pe_pp_R, replace) nodraw 
graph bar pc_pe_pp if wave1=="DK", over(wave2) legend(off) name(pc_pe_pp_D, replace) nodraw
graph bar pc_pe_pp if wave1=="Leave", over(wave2) legend(off) name(pc_pe_pp_L, replace) nodraw

graph bar pc_pe_ap if wave1=="Remain", over(wave2) legend(off) name(pc_pe_ap_R, replace) nodraw 
graph bar pc_pe_ap if wave1=="DK", over(wave2) legend(off) name(pc_pe_ap_D, replace) nodraw
graph bar pc_pe_ap if wave1=="Leave", over(wave2) legend(off) name(pc_pe_ap_L, replace) nodraw

graph bar ac_pe_pp if wave1=="Remain", over(wave2) legend(off) name(ac_pe_pp_R, replace) nodraw 
graph bar ac_pe_pp if wave1=="DK", over(wave2) legend(off) name(ac_pe_pp_D, replace) nodraw
graph bar ac_pe_pp if wave1=="Leave", over(wave2) legend(off) name(ac_pe_pp_L, replace) nodraw

graph bar pc_ae_pp if wave1=="Remain", over(wave2) legend(off) name(pc_ae_pp_R, replace) nodraw 
graph bar pc_ae_pp if wave1=="DK", over(wave2) legend(off) name(pc_ae_pp_D, replace) nodraw
graph bar pc_ae_pp if wave1=="Leave", over(wave2) legend(off) name(pc_ae_pp_L, replace) nodraw

graph bar control if wave1=="Remain", over(wave2) legend(off) name(control_R, replace) nodraw 
graph bar control if wave1=="DK", over(wave2) legend(off) name(control_D, replace) nodraw
graph bar control if wave1=="Leave", over(wave2) legend(off) name(control_L, replace) nodraw

graph bar ac_ae_pp if wave1=="Remain", over(wave2) legend(off) name(ac_ae_pp_R, replace) nodraw 
graph bar ac_ae_pp if wave1=="DK", over(wave2) legend(off) name(ac_ae_pp_D, replace) nodraw
graph bar ac_ae_pp if wave1=="Leave", over(wave2) legend(off) name(ac_ae_pp_L, replace) nodraw

graph bar pc_ae_ap if wave1=="Remain", over(wave2) legend(off) name(pc_ae_ap_R, replace) nodraw 
graph bar pc_ae_ap if wave1=="DK", over(wave2) legend(off) name(pc_ae_ap_D, replace) nodraw
graph bar pc_ae_ap if wave1=="Leave", over(wave2) legend(off) name(pc_ae_ap_L, replace) nodraw

graph bar ac_pe_ap if wave1=="Remain", over(wave2) legend(off) name(ac_pe_ap_R, replace) nodraw 
graph bar ac_pe_ap if wave1=="DK", over(wave2) legend(off) name(ac_pe_ap_D, replace) nodraw
graph bar ac_pe_ap if wave1=="Leave", over(wave2) legend(off) name(ac_pe_ap_L, replace) nodraw

graph bar ac_ae_ap if wave1=="Remain", over(wave2) legend(off) name(ac_ae_ap_R, replace) nodraw 
graph bar ac_ae_ap if wave1=="DK", over(wave2) legend(off) name(ac_ae_ap_D, replace) nodraw
graph bar ac_ae_ap if wave1=="Leave", over(wave2) legend(off) name(ac_ae_ap_L, replace) nodraw

graph combine pc_pe_pp_R pc_pe_pp_D pc_pe_pp_L ///
pc_pe_ap_R pc_pe_ap_D pc_pe_ap_L ///
ac_pe_pp_R ac_pe_pp_D ac_pe_pp_L ///
pc_ae_pp_R pc_ae_pp_D pc_ae_pp_L ///
control_R control_D control_L ///
ac_ae_pp_R ac_ae_pp_D ac_ae_pp_L ///
pc_ae_ap_R pc_ae_ap_D pc_ae_ap_L ///
ac_pe_ap_R ac_pe_ap_D ac_pe_ap_L ///
ac_ae_ap_R ac_ae_ap_D ac_ae_ap_L, rows(9) graphregion(fcolor(white))
