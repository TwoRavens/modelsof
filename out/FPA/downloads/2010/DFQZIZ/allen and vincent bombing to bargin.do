
*** To create Table 2 - Bombing Model ***
mlogit statement lagsorties econeffect leadeffect infrastructure fielded, base(-1)

*** To create Table 3 (Relative Rate Ratios) ***
mlogit statement lagsorties econeffect leadeffect infrastructure fielded, base(-1) rrr

*** To create Table 4 - Bargaining Model ***
mlogit statement day lagconcess lagmed2 lagpartial, base(-1) 

*** To create Table 5 ***
mlogit statement day lagconcess lagmed2 lagpartial, base(-1) rrr

*** To create Table 6 - Unified Model ***
mlogit statement lagsorties lagconcess lagmed2 lagpartial econeffect leadeffect fielded infrastructure, base(-1)

mlogit statement day lagconcess lagmed2 lagpartial econeffect leadeffect fielded infrastructure, base(-1)

*** To create Table 7 ***
mlogit statement lagsorties lagconcess lagmed2 lagpartial econeffect leadeffect fielded infrastructure, base(-1) rrr

mlogit statement day lagconcess lagmed2 lagpartial econeffect leadeffect fielded infrastructure, base(-1) rrr