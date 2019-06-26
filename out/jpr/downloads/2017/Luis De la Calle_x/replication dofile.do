
** Compliance vs constraints: a theory of rebel targeting in civil war
** Luis De la Calle
** Journal of Peace Research, 54 (3): 427-441).
** May 2017, replication file 


**definition of variables


// identification variables

// year == year
// ubigeo == district identification code
// id == same as ubigeo
// district == district's name
// prov == district's province 
// dep == district's department


// dependent variables

// cvrciviliantargets == civilians killed by sendero luminoso [source: CVR]
// sharesecurityforces == share of security forces killed by Shining Path in the district during the year [source: list of military and police deaths killed by Shining Path as collected by the Defence and Home Ministries]
// sharegovernment == share of government officials killed by Shining Path in the district during the year [source: CVR]
// sharecivilians == share of civilians killed by Shining Path in the district during the year [source: CVR]


// main independent variables

// lcontrol == types of (lagged) territorial control: 0, state; 1, contested; 2, rebel [source: electoral reports at the municipal level]
// lcontested == 1 if district is under contested rule
// lfull == 1 if district is under full rebel control
// limaprov == districts belonging to the province of Lima
// st_killings == civilians killed by the state [source: CVR]
// lst_killings == civilians killed by the state, lagged [source: CVR]
// alto_huallaga == districts belonging to the Alto Huallaga region
// increasing_control == 1 if the district moves from state to contested control, from contested to rebel control, or from state to rebel control
// decreasing_control == 1 if the district moves from rebel to state control, from rebel to contested control, or from contested to state control


// controls

// presidency == 1, belaunde; 2, garcia; 3, fujimori [dummies for each president are generated from "presidency"]
// lpop81 == (logged) population in the district as of the 1981 Census
// sum_slkillings == accumulated number of attacks in the district by Shining Path


// robustness variables

// lheight == logged average height of the district
// distancia == distance from the district's capital site to the provincial's capital city
// lsize == logged size of the district (the original values are on km2)
// edad20_29 == share of the district population between 20 and 29 years-old
// spanish == share of the district population that speaks spanish
// lpop81 == logged population of the district as of the 1981 census
// sl_killings == count of Shining Path's killings in the district during the year




** Table 1 
zinb cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr
margins lcontrol#alto_huallaga,  at(lst_killings=(0(1)10)) 
marginsplot, by(alto_huallaga) noci


** Figure 3
zinb cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr
margins lcontrol#alto_huallaga,  at(lst_killings=(0(1)10)) 
marginsplot, by(alto_huallaga) noci

** Tables 2 & 3
tlogit  sharesecurityforces lrcvrsecforces  sharegovernment lrcvrgovernment, base(sharecivilians) // this transformation is necessary to run the SUREG model, although the SUREG dependent variables are already included in the dataset

estsimp sureg (lrcvrsecforces lcontested lfull lst_killings alto_huall increasing_con decreasing_con garcia fujimori lpop81) /*
*/ (lrcvrgovernment lst_killings lfull lcontested alto_hu increasing_con decreasing_con fujimori garcia lpop81) if year>1980

// download clarify at https://gking.harvard.edu/clarify
setx mean
setx lcontested 0 lfull 0 alto_ 0 lst_killing 0 
simqi, pv tfunc(logiti)
setx mean
setx lcontested 1 lfull 0 alto_ 0 lst_killing 0
simqi, pv tfunc(logiti)
setx mean
setx lcontested 0 lfull 1 alto_ 0 lst_killing 0
simqi, pv tfunc(logiti)

setx mean
setx lcontested 0 lfull 0 alto_ 0 lst_killing 10  
simqi, pv tfunc(logiti)
setx mean
setx lcontested 1 lfull 0 alto_ 0 lst_killing 10
simqi, pv tfunc(logiti)
setx mean
setx lcontested 0 lfull 1 alto_ 0 lst_killing 10
simqi, pv tfunc(logiti)
setx mean

setx lcontested 0 lfull 0 alto_ 1 lst_killing 0
simqi, pv tfunc(logiti)
setx mean
setx lcontested 1 lfull 0 alto_ 1 lst_killing 0
simqi, pv tfunc(logiti)
setx mean
setx lcontested 0 lfull 1 alto_ 1 lst_killing 0
simqi, pv tfunc(logiti)

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20 b21 b22 b23 b24 b25


estsimp sureg (lrcvrsecforces lcontested lfull limaprov lst_killings alto_huall increasing_con decreasing_con garcia fujimori lpop81) /*
*/(lrcvrgovernment lst_killings lfull lcontested alto_hu limaprov increasing_con decreasing_con fujimori garcia lpop81) if year>1980
setx mean
setx lcontested 0 lfull 0 alto_ 0 limaprov 1 lst_killing 0
simqi, pv tfunc(logiti)
setx mean
setx lfull 0 lcontested 0 alto_huall 0 lst_killing 10 limaprov 1
simqi, pv tfunc(logiti)


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

** robustness checks (supplementary file)

** Table 5, additional controls
zinb cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol i.limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish   /*
*/ if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr

** Table 6, alternative NBREG models
nbreg cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog vce(cluster ubigeo) irr
nbreg cvrciviliantargets i.lcontrol i.limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog  vce(cluster ubigeo) irr
nbreg cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog vce(cluster ubigeo) irr
nbreg cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog vce(cluster ubigeo) irr
nbreg cvrciviliantargets i.lcontrol i.limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish   /*
*/ if year>1980, nolog  vce(cluster ubigeo) irr
nbreg cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog vce(cluster ubigeo) irr

** Table 7, alternative OLS models
reg cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81  if year>1980,  vce(cluster ubigeo) 
reg cvrciviliantargets i.lcontrol i.limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81  if year>1980,   vce(cluster ubigeo) 
reg cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81  if year>1980,  vce(cluster ubigeo) 
reg cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980,  vce(cluster ubigeo) 
reg cvrciviliantargets i.lcontrol i.limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish   /*
*/ if year>1980,   vce(cluster ubigeo)
reg cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980,  vce(cluster ubigeo) 

** Table 8, ZINB models with alternative measures of inflation, I (population)
zinb cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(lpop81) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol i.limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(lpop81) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(lpop81) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog inflate(lpop81) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol i.limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish   /*
*/ if year>1980, nolog inflate(lpop81) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog inflate(lpop81) vce(cluster ubigeo) irr

** Table 9, ZINB models with alternative measures of inflation, II (share of spanish speakers in the district)
zinb cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(spanish) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol i.limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(spanish) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 if year>1980, nolog inflate(spanish) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog inflate(spanish) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol i.limaprov lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish   /*
*/ if year>1980, nolog inflate(spanish) vce(cluster ubigeo) irr
zinb cvrciviliantargets i.lcontrol##c.lst_killings i.lcontrol##i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog inflate(spanish) vce(cluster ubigeo) irr

** Table 10, SUREG models with additional controls
sureg (lrcvrsecforces lcontested lfull lst_killings alto_huall increasing_con decreasing_con garcia fujimori lpop81 lheight distanc lsize  edad20_29 spanish) /*
*/ (lrcvrgovernment lcontested lfull lst_killings alto_huall increasing_con decreasing_con garcia fujimori lpop81 lheight distanc lsize  edad20_29 spanish) if year>1980
sureg (lrcvrsecforces lcontested lfull limaprov lst_killings alto_huall increasing_con decreasing_con garcia fujimori lpop81 lheight distanc lsize  edad20_29 spanish) /*
*/(lrcvrgovernment lcontested lfull limaprov lst_killings alto_hu increasing_con decreasing_con garcia fujimori  lpop81 lheight distanc lsize  edad20_29 spanish) if year>1980


** Figure 1, analysis of reverse causality between state repression and rebel violence
// download "pvar" here: https://sites.google.com/a/hawaii.edu/inessalove/home/pvar
tsset id year
helm st_killings sl_killings
pvar2 st_killings sl_killings, lag(3) gmm monte 500 "decomp 30"


** Table 12, reduced-form model
// reduced-form model: (1) state repression without civilian targeting; (2) impute values for state repression; (3) structural equation with imputed values

//justify that population size is correlated with state repression but not so much with rebel violence. 
zinb st_killing i.lcontrol limaprov i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr

// impute values for state repression
predict x
rename x ex_staterep
sort ubigeo year
bysort district prov: gen lex_staterep=ex_staterep[_n-1]

// model without imputed values
zinb cvrciviliantargets i.lcontrol lst_killings i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr

// model with imputed values on state repression
zinb cvrciviliantargets i.lcontrol lex_staterep i.alto_  increasing_c decreasing_c  i.presid lpop81 lheight distanc lsize  edad20_29 spanish  /*
*/ if year>1980, nolog inflate(sum_slkillings) vce(cluster ubigeo) irr




