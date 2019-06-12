
generate unanimity=1-dissent

generate dissent_p= dissent*fomc_public_vote

generate unanimity_p= unanimity *fomc_public_vote

generate F_np=1- fomc_public_vote

///

reg r1_sp dissent_p unanimity_p F_np ffs_factor1 ffs_factor2 fomc_unscheduled, noconstant vce(robust)

test dissent = unanimity

reg r2_sp dissent_p unanimity_p F_np ffs_factor1 ffs_factor2 fomc_unscheduled, noconstant vce(robust)

test dissent = unanimity

//regressions above are for the monetary factors (results placed in Table 4 of the paper)

reg r1_sp dissent_p unanimity_p F_np fomc_unscheduled recessiondummy tighteningcycledummy easingcycledummy, noconstant vce(robust)

test dissent = unanimity 

reg r2_sp dissent_p unanimity_p F_np fomc_unscheduled recessiondummy tighteningcycledummy easingcycledummy, noconstant vce(robust)

test dissent = unanimity

//regressions above are for cyclical and monetary policy dummies (results placed in Table 4 of the paper)

qreg r1_sp dissent in 1/70 , vce(robust)

qreg r2_sp dissent in 1/70, vce(robust)

qreg r1_sp dissent in 71/202 , vce(robust)

qreg r2_sp dissent in 71/202, vce(robust)

//MQ regressions above (results shown in Table A6 of the appendix)
