******************************************************************************************************************************************
normalden(xb2) *normal((xb1_1-e(rho)*xb2)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[ln_pre_market_size2] ///
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[ln_pre_market_size2] ///
normalden(-xb2) *normal((xb1_0-e(rho)*xb2)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[ln_pre_market_size2]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb2m)*normal((xb1_1m-e(rho)*xb2m)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[ln_pre_market_size2] ///
normalden(xb1_0m)*normal((-1)*(xb2m -e(rho)*xb1_0m)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[ln_pre_market_size2] ///
normalden(-xb2m)*normal((xb1_0m-e(rho)*xb2m)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[ln_pre_market_size2]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb2) *normal((xb1_1-e(rho)*xb2)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[monopoly_effdur] ///
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[monopoly_effdur] ///
normalden(-xb2) *normal((xb1_0-e(rho)*xb2)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[monopoly_effdur]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb2m)*normal((xb1_1m-e(rho)*xb2m)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[monopoly_effdur] ///
normalden(xb1_0m)*normal((-1)*(xb2m -e(rho)*xb1_0m)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[monopoly_effdur] ///
normalden(-xb2m)*normal((xb1_0m-e(rho)*xb2m)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[monopoly_effdur]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb2) *normal((xb1_1-e(rho)*xb2)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[atc3_rxsubstitutes_g] ///
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[atc3_rxsubstitutes_g] ///
normalden(-xb2) *normal((xb1_0-e(rho)*xb2)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[atc3_rxsubstitutes_g]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb2m)*normal((xb1_1m-e(rho)*xb2m)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[atc3_rxsubstitutes_g] ///
normalden(xb1_0m)*normal((-1)*(xb2m -e(rho)*xb1_0m)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[atc3_rxsubstitutes_g] ///
normalden(-xb2m)*normal((xb1_0m-e(rho)*xb2m)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[atc3_rxsubstitutes_g]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb2) *normal((xb1_1-e(rho)*xb2)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[atc3_rxsubstitutes_b] ///
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[atc3_rxsubstitutes_b] ///
normalden(-xb2) *normal((xb1_0-e(rho)*xb2)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[atc3_rxsubstitutes_b]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb2m)*normal((xb1_1m-e(rho)*xb2m)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[atc3_rxsubstitutes_b] ///
normalden(xb1_0m)*normal((-1)*(xb2m -e(rho)*xb1_0m)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[atc3_rxsubstitutes_b] ///
normalden(-xb2m)*normal((xb1_0m-e(rho)*xb2m)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[atc3_rxsubstitutes_b]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[atc3_exp2]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb1_0m) *normal((-1)*(xb2m -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[atc3_exp2]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[nfc3_exp2]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb1_0m) *normal((-1)*(xb2m -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[nfc3_exp2]) if ag_entry_dum==1, se(phat_diff_se) force
normalden(xb2) *normal((xb1_1-e(rho)*xb2)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[ln_pre_market_size2] ///
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[ln_pre_market_size2] ///
normalden(-xb2) *normal((xb1_0-e(rho)*xb2)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[ln_pre_market_size2]), se(phat_diff_se) force
normalden(xb2) *normal((xb1_1-e(rho)*xb2)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[monopoly_effdur] ///
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[monopoly_effdur] ///
normalden(-xb2) *normal((xb1_0-e(rho)*xb2)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[monopoly_effdur]), se(phat_diff_se) force
normalden(xb2) *normal((xb1_1-e(rho)*xb2)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[atc3_rxsubstitutes_g] ///
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[atc3_rxsubstitutes_g] ///
normalden(-xb2) *normal((xb1_0-e(rho)*xb2)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[atc3_rxsubstitutes_g]), se(phat_diff_se) force
normalden(xb2) *normal((xb1_1-e(rho)*xb2)/sqrt(1-(e(rho))^2))*[ag_entry_dum]_b[atc3_rxsubstitutes_b] ///
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[atc3_rxsubstitutes_b] ///
normalden(-xb2) *normal((xb1_0-e(rho)*xb2)/sqrt(1-(e(rho))^2))*(-1)*[ag_entry_dum]_b[atc3_rxsubstitutes_b]), se(phat_diff_se) force
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[atc3_exp2]), se(phat_diff_se) force
normalden(xb1_0) *normal((-1)*(xb2 -e(rho)*xb1_0)/sqrt(1-(e(rho))^2))*[ind_generic_entry_exp]_b[nfc3_exp2]), se(phat_diff_se) force