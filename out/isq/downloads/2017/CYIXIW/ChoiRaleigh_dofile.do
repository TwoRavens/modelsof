

* REPLICATION DO-FILE
*
* Dominant Forms of Conflict in Changing Political Systems
* HYUN JIN CHOI, AND CLIONADH RALEIGH 
* International Studies Quaterly, forthcoming


***Model 1***
xtnbreg rebel LCB LPP election ethnicpol growth logpop Lloggdp Lrebel, i(ccode) nolog 

***Model 2***
xtnbreg pm LCB LPP election ethnicpol growth logpop Lloggdp Lpm, i(ccode) nolog 

***Model 3***
xtnbreg pm LCB LPP Prebel election ethnicpol growth logpop Lloggdp Lpm, i(ccode) nolog 

***Model 4***
xtnbreg riot LCB LPP LCBPP election ethnicpol growth logpop Lloggdp Lriot, i(ccode) nolog 

***Model 5***
gllamm dominance LCB LPP election ethnicpol growth logpop Lloggdp LDrebel LDpm LDriot, i(ccode) link(mlogit) family(binomial) 

***Model 6***
logit shift CB_UP3 LPP CBUP3PP election ethnicpol growth logpop Lloggdp transitionyrs if rebelsum > 0, cluster(ccode)  
