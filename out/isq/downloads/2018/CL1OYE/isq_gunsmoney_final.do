**DO FILE FOR COMMANDS FOR TABLE ONE AND ROBUSTNESS CHECKS, includes conflict.

set more off

** BASELINE WITH PANEL SPECIFIC CORRECTION FOR SERIAL CORRELATION
xtpcse Dlnimports_tiv L.lnimports_tiv L.lnrgdp L.lnmilaid L.soviet_aid L.lnrxrat L.dem L.lnavimports_oth L3.crisis L.postcoldwar L.any_conf Dlnrxrat L.Dlnrxrat L2.Dlnrxrat L3.Dlnrxrat L4.Dlnrxrat Dlnrgdp L.Dlnrgdp L2.Dlnrgdp L3.Dlnrgdp L4.Dlnrgdp  c1-c125 if ccode~=2 & ccode~=365 & year>1959, pairwise corr(psar1)

**BASELINE WITH CONTROLS FOR GOVERNMENT SPENDING 
xtpcse Dlnimports_tiv L.lnimports_tiv L.lnrgdp L.lnmilaid L.soviet_aid L.lnrxrat L.lnggc_rp L.dem L.lnavimports_oth L3.crisis L.postcoldwar L.any_conf Dlnrxrat L.Dlnrxrat L2.Dlnrxrat L3.Dlnrxrat L4.Dlnrxrat Dlnrgdp L.Dlnrgdp L2.Dlnrgdp L3.Dlnrgdp L4.Dlnrgdp c1-c125 if ccode~=2 & ccode~=365 & year>1959, pairwise corr(psar1)


