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


// ANY QUALS

use NCDS_Battistin_Sianesi, clear

// Raw estimates of effect - using LFS
meraw Dany, y(wage) x($X_lfs)

// Raw estimates of effect - using FULL
meraw Dany, y(wage) x($X) 

set seed 10000001
bootstrap "mebounds Dany, y(wage) x($X) qui" 	delta1=r(d1)  delta2=r(d2)  delta3=r(d3)  delta4=r(d4)  delta5=r(d5) /*
					*/ 		pD1   =r(p1)  pD2   =r(p2)  pD3   =r(p3)  pD4   =r(p4)  pD5   =r(p5) /*
					*/ 		e1    =r(e1)  e2    =r(e2)  e3    =r(e3)  e4    =r(e4)  e5    =r(e5) /*
					*/ 		lb6   =r(lb6) ub6   =r(ub6) lb7   =r(lb7) ub7   =r(ub7) lb8   =r(lb8) ub8=r(ub8) lb9=r(lb9) ub9=r(ub9) /*
*/ , rep(500) dots saving(bsboundsAcad) replace double


// HE

use NCDS_Battistin_Sianesi, clear

// Raw estimates of effect - using LFS
meraw Dhe, y(wage) x($X_lfs)

// Raw estimates of effect - using FULL
meraw Dhe, y(wage) x($X) 

set seed 10000001
bootstrap "mebounds Dhe, y(wage) x($X) qui" 	delta1=r(d1)  delta2=r(d2)  delta3=r(d3)  delta4=r(d4)  delta5=r(d5) /*
					*/ 		pD1   =r(p1)  pD2   =r(p2)  pD3   =r(p3)  pD4   =r(p4)  pD5   =r(p5) /*
					*/ 		e1    =r(e1)  e2    =r(e2)  e3    =r(e3)  e4    =r(e4)  e5    =r(e5) /*
					*/ 		lb6   =r(lb6) ub6   =r(ub6) lb7   =r(lb7) ub7   =r(ub7) lb8   =r(lb8) ub8=r(ub8) lb9=r(lb9) ub9=r(ub9) /*
*/ , rep(500) dots saving(bsboundsHE) replace double


do CIbounds 


