use "NAVCO-Robustness.dta"

**EXTENSIONS: Repression/Accommodation Trade-Off
ologit F.repress2 camp_size  rad_flank2 regchange regime_support ingo_support if prim_m == 1, r cluster(ccode)
ologit F.repress2 camp_size  rad_flank2 regchange regime_support ingo_support repress2 if prim_m == 1, r cluster(ccode)

*proportional odds
omodel logit frepress2 camp_size  rad_flank2 regchange camp_structure regime_support ingo_support if prim_m == 1 
omodel logit frepress2 camp_size  rad_flank2 regchange camp_structure regime_support ingo_support repress2 if prim_m == 1
ologit frepress2 camp_size  rad_flank2 regchange camp_structure regime_support ingo_support if prim_m == 1, r cluster(ccode)
brant, detail
ologit frepress2 camp_size  rad_flank2 regchange camp_structure regime_support ingo_support repress2 if prim_m == 1, r cluster(ccode)
brant, detail

**ONLINE APPENDIX: Exploring the NAVCO "Repression" Variable
tab repression if prim_m ==1

ologit repression camp_size camp_size2 rad_flank2 regchange regime_support ingo_support if prim_m == 1, r cluster(ccode)
slogit repression camp_size camp_size2 rad_flank2 regchange regime_support ingo_support if prim_m == 1, r cluster(ccode)
ologit repress2 camp_size  rad_flank2 regchange regime_support ingo_support if prim_m == 1, r cluster(ccode)
