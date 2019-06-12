***************************************************************************************************
*** These data can be used to replicate the analysis in "Ideological Fractionalization and the 	***										
*** Conflict Behavior of Parliamentary Democracies." The following variables are used to in the	***
*** models in Table 1.													***
*** --------------------												***
*** init_monad: 		monadic dispute initiation								***
*** initmonad_fatal:	monadic dispute initiation leading to fatalities				***
*** coalition: 		majority coalitional government type						***
*** minority:		minority government type (coalition or single-party)				***
*** dist_directional1:	ideological distance of the farthest outlier party				***
*** gov_ideology1:		government's aggregate ideology score					***
*** cap_1:			CoW CINC score for initiator								***
*** prop_demborder1:	proportion of initiator's bordering countries that are democratic		***
*** prop_allyborder1:	proportion of bordering countries that are allied with the initiator	***
*** dep_trade:		initiator's trade dependence								***
*** veto_players:		number of veto players in the government						***
*** peaceyears (2, 3):	peaceyears, peaceyears-squared, peaceyears-cubed				***
*** --------------------												***
***************************************************************************************************																		


*** COLUMN 1 ***
probit init_monad coalition dist_directional1 gov_ideology1 minority cap_1 prop_demborder1 prop_allyborder1 dep_trade veto_players peaceyears  peaceyears2 peaceyears3, robust

*** COLUMN 2 ***
probit init_monad coalition dist_directional1 gov_ideology1 minority cap_1 prop_demborder1 prop_allyborder1 dep_trade veto_players peaceyears  peaceyears2 peaceyears3 if minority == 0, robust

*** COLUMN 3 ***
probit initmonad_fatal coalition dist_directional1 gov_ideology1 minority cap_1 prop_demborder1 prop_allyborder1 dep_trade veto_players peaceyears  peaceyears2 peaceyears3, robust

*** COLUMN 4 ***
probit initmonad_fatal coalition dist_directional1 gov_ideology1 minority cap_1 prop_demborder1 prop_allyborder1 dep_trade veto_players peaceyears  peaceyears2 peaceyears3 if minority == 0, robust





														
