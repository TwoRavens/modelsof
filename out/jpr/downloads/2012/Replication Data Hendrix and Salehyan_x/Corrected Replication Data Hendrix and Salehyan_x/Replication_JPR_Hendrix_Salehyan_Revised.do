***Replication .do file for Hendrix, Cullen S., and Idean Salehyan (2012) Climate change, rainfall, and social conflict in Africa. Journal of Peace Research 49(1): 35-50.***

*Table 2*

logit conflict_onset incidence_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2_l polity2_sq_l log_pop_pwt_l log_pop_pwt_fd_rescaled_l log_rgdpch_pwt_l grgdpch_pwt_l peaceyears*, cluster(ccode)

*Table 3*
*Model 2 & 3*

nbreg events_no_onset events_no_onset_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, cluster(ccode)
xtnbreg events_no_onset events_no_onset_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, fe

*Model 4 & 5*

nbreg non_violent_events non_violent_events_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, cluster(ccode)
xtnbreg non_violent_events non_violent_events_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, fe

*Model 6 & 7*

nbreg violent_events_no_onset violent_events_no_onset_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, cluster(ccode)
xtnbreg violent_events_no_onset violent_events_no_onset_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, fe

*Model 8 & 9*

nbreg gov_targeted_events_no_onset gov_targeted_events_no_onset_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, cluster(ccode)
xtnbreg gov_targeted_events_no_onset gov_targeted_events_no_onset_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, fe

*Model 10 & 11*

nbreg nongov_targeted_events nongov_targeted_events_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, cluster(ccode)
xtnbreg nongov_targeted_events nongov_targeted_events_l GPCP_precip_mm_deviation_sd GPCP_precip_mm_deviation_sd_sq GPCP_precip_mm_deviation_sd_l GPCP_precip_mm_deviation_sd_l_sq polity2 polity2_sq log_pop_pwt log_pop_pwt_fd log_rgdpch_pwt grgdpch_pwt incidence ttrend year_dummy* if ccode~=520, fe
