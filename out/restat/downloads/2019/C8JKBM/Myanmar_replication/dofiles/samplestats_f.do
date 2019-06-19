

// Sample statistics [garment] **********************************************************************
use "$root/myanmarpanel_analysis.dta", clear 

sutex export_sh export export_JP export_JP_sh export_EUUS export_EUUS_sh export_JPandEUUS export_CH_sh emp nsewm vadd dnonknitbf05 rscr_sftu fexit fextg fhose falarm fmap fdrill nurseplant injuryrec hosplist hospcontract no_wleader appoint_w wage hwork_weektt longhw rscr_manag_woitic rscr_prod rscr_quality rscr_machine mandalay oeducu ///
ochinese firmage socialaudit ap_timeo ap_in1hr city_timeo izo  if obs_airport ==1, labels minmax

// Sample statistics [food] **********************************************************************
use "$root/myanmar_food_analysis.dta", clear 

drop if log_emp==. 
drop if firmage <=7 & year == 2013  & industry==2 
drop if firmage <=8 & year == 2014  & industry==2 
drop if firmage <=9 & year == 2015  & industry==2 
keep if ap_timeo!=. 
keep if emp>=5 & log_emp!=. 

sutex export_sh export export_JP export_JP_sh emp sales rscr_sftu fexit fextg fhose falarm fmap fdrill ///
nurseplant injuryrec hosplist hospcontract no_wleader wage hwork_weektt longhw rscr_manag_woitic rscr_prod rscr_quality rscr_machine mandalay_i ///
firmage ap_timeo ap_in1hr city_timeo izo bev, labels minmax
