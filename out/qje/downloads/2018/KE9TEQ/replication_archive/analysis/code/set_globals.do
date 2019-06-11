global demo_controls = "pop_share_minority tot_pop_adult edu_dropout edu_colplus foreign_born_pct income pct_poverty lfp"

global race_controls = "pop_share_minority tot_pop_adult edu_dropout edu_colplus foreign_born_pct"
global race_controls_std = "pop_share_minority_std tot_pop_adult_std edu_dropout_std edu_colplus_std foreign_born_pct_std"

global other_controls = "income pct_poverty lfp" 
global other_controls_std = "income_std pct_poverty_std lfp_std" 

global media_controls = "newspaper_slant document_count" 
global media_controls_std = "newspaper_slant_std document_count_std"

global extra_controls_ptya "cand_visits cmag_oth_ptya_base newspaper_slant document_count"
global extra_controls_ptyd "cand_visits_ptydf cmag_oth_ptyd_base newspaper_slant document_count"
global extra_controls "cand_visits cand_visits_ptydf cmag_oth_ptya_base cmag_oth_ptyd_base newspaper_slant document_count"
