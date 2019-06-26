***Replication file Costalli and Moro JPR 2012***


***Table 1***

reg log_totalvict nat_fract log_pop contig_hr contig_srb share_cultland incomepc_din91, cluster(municipality)
reg log_totalvict nat_polar log_pop contig_hr contig_srb share_constr incomepc_din91, cluster(municipality)
reg log_totalvict ethn_dom log_pop contig_hr contig_srb share_constr incomepc_din91, cluster(municipality)
drop if municipality == "Srebrenica"
reg log_totalvict mus_dom srb_dom hrv_dom log_pop contig_hr contig_srb share_cultland incomepc_din91, cluster(municipality)


***Table 2***

xtscc log_vict past_vict nat_polar polar92 polar93 polar94 log_pop contig_srb contig_hr internal_bord mil_fact intbord92 intbord93 intbord94 incomepc_din91 share_cultland dum_year92 dum_year93 dum_year94
xtscc log_vict past_vict nat_polar polar92 polar93 polar94 log_pop contig_srb contig_hr cont_hr92 cont_hr93 cont_hr94 internal_bord mil_fact incomepc_din91 share_cultland dum_year92 dum_year93 dum_year94
xtscc log_vict past_vict nat_polar polar92 polar93 polar94 log_pop contig_srb cont_srb92 cont_srb93 cont_srb94 contig_hr internal_bord mil_fact incomepc_din91 share_cultland dum_year92 dum_year93 dum_year94
xtscc log_vict past_vict nat_polar polar92 polar93 polar94 log_pop contig_srb contig_hr internal_bord mil_fact mil_fact92 mil_fact93 mil_fact94 incomepc_din91 share_cultland dum_year92 dum_year93 dum_year94


***Table 5 (Appendix)***

xtscc log_vict past_vict nat_fract nat_fract2 log_pop contig_srb contig_hr internal_bord incomepc_din91 share_cultland dum_year92 dum_year93 dum_year94


***Table 6 (Appendix)***

xtscc log_vict past_vict polareqlast polareqlast92 polareqlast93 polareqlast94 log_pop contig_srb contig_hr internal_bord intbord92 intbord93 intbord94 incomepc_din91 share_cultland dum_year92 dum_year93 dum_year94
xtscc log_vict past_vict polareqlast polareqlast92 polareqlast93 polareqlast94 log_pop contig_srb contig_hr cont_hr92 cont_hr93 cont_hr94 internal_bord incomepc_din91 share_cultland dum_year92 dum_year93 dum_year94
xtscc log_vict past_vict polareqlast polareqlast92 polareqlast93 polareqlast94 log_pop contig_srb cont_srb92 cont_srb93 cont_srb94 contig_hr internal_bord incomepc_din91 share_cultland dum_year92 dum_year93 dum_year94
