// Battistin and Sianesi 
// 	Misclassified Treatment Status and Treatment Effects:
// 	An Application to Returns to Education in the UK


clear 
set mem 900m
set more 1
set matsize 400

// globals 
run globalX 
global X      "white $schvar $tests7 $tests11 $parvars $regvar3"  
global X_lfs  "white $regvar3"  						


use NCDS_Battistin_Sianesi, clear

// Raw estimates of effect - using LFS 
mtraw Dmult, y(wage) x($X_lfs)

// Raw estimates of effect - using FULL
mtraw Dmult, y(wage) x($X) 


#delimit ;
set seed 10000001	;
bootstrap "mtbounds Dmult, y(wage) x($X) l21(5) l22(90) qui"
	 ub10_9   =    r(ub109)  
	 lb10_9   =    r(lb109)  
	 ub10_8   =    r(ub108)  
	 lb10_8   =    r(lb108)  
	 ub10_7   =    r(ub107)  
	 lb10_7   =    r(lb107)  
	 ub10_6   =    r(ub106)  
	 lb10_6   =    r(lb106)  
	                         
	 ub21_9   =    r(ub219)  
	 lb21_9   =    r(lb219)  
	 ub21_8   =    r(ub218)  
	 lb21_8   =    r(lb218)  
	 ub21_7   =    r(ub217)  
	 lb21_7   =    r(lb217)  
	 ub21_6   =    r(ub216)  
	 lb21_6   =    r(lb216)  
	                         
	 ub20_9   =    r(ub209)  
	 lb20_9   =    r(lb209)  
	 ub20_8   =    r(ub208)  
	 lb20_8   =    r(lb208)  
	 ub20_7   =    r(ub207)  
	 lb20_7   =    r(lb207)  
	 ub20_6   =    r(ub206)  
	 lb20_6   =    r(lb206)  
	                         
, rep(500) dots saving(bsboundsMT5_90) replace double ;
#delimit cr


use NCDS_Battistin_Sianesi, clear

#delimit ;
set seed 10000001	;
bootstrap "mtbounds Dmult, y(wage) x($X) l21(1) l22(95) qui"
	 ub10_9   =    r(ub109)  
	 lb10_9   =    r(lb109)  
	 ub10_8   =    r(ub108)  
	 lb10_8   =    r(lb108)  
	 ub10_7   =    r(ub107)  
	 lb10_7   =    r(lb107)  
	 ub10_6   =    r(ub106)  
	 lb10_6   =    r(lb106)  
	                         
	 ub21_9   =    r(ub219)  
	 lb21_9   =    r(lb219)  
	 ub21_8   =    r(ub218)  
	 lb21_8   =    r(lb218)  
	 ub21_7   =    r(ub217)  
	 lb21_7   =    r(lb217)  
	 ub21_6   =    r(ub216)  
	 lb21_6   =    r(lb216)  
	                         
	 ub20_9   =    r(ub209)  
	 lb20_9   =    r(lb209)  
	 ub20_8   =    r(ub208)  
	 lb20_8   =    r(lb208)  
	 ub20_7   =    r(ub207)  
	 lb20_7   =    r(lb207)  
	 ub20_6   =    r(ub206)  
	 lb20_6   =    r(lb206)  
	                         
, rep(500) dots saving(bsboundsMT1_95) replace double ;
#delimit cr

do CIboundsMT


