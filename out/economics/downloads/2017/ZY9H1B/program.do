

clear all
set mem 400m
set matsize 800

use C:\Users\Rodrigo\Desktop\mayte2\emergencia.dta
generate codccaa=v17
generate year=v2
gen tend=year-1995
sum tend
gen tend2=tend*tend
	
gen cambio = 1/166.386 if year<=2001
replace cambio = 1 if year >2001

gen ajustemonet = cambio*1000 if year<=2001
replace ajustemonet= 1 if year>2001


gen IPC_FMI_2005     = 77.923 if year==1996
replace IPC_FMI_2005 = 79.385 if year==1997
replace IPC_FMI_2005 = 80.785 if year==1998
replace IPC_FMI_2005 = 82.591 if year==1999
replace IPC_FMI_2005 = 85.468 if year==2000
replace IPC_FMI_2005 = 87.884 if year==2001
replace IPC_FMI_2005 = 91.038 if year==2002
replace IPC_FMI_2005 = 93.863 if year==2003
replace IPC_FMI_2005 = 96.728 if year==2004
replace IPC_FMI_2005 = 100    if year==2005
replace IPC_FMI_2005 = 103.563 if year==2006
replace IPC_FMI_2005 = 106.508 if year==2007
replace IPC_FMI_2005 = 110.906 if year==2008
replace IPC_FMI_2005 = 110.642 if year==2009

generate medicos=v49+0.5*v51+v53
generate medicosf=v50+0.5*v52+v54



generate med=  v563+      v579+  v643+           v691+          v699+    v723+v732+v741  
generate cir=v571+v579
generate obs=v587
generate ped=v611
generate uci=v651
replace v826 = 0 if missing(v826)
generate consult1=v826+v828
generate consult2=(v827-v826)+(v829-v828)
generate uni=v859
generate altash=1*med+1.5*cir+1.2*obs+1.3*ped+5.8*uci+0.25*consult1+0.15*consult2+0.3*uni
 ***********************************************************************************************************************************************
 *************************************************************************************************************************************************
generate inversiones=(v1064*ajustemonet*ipc_06_NACI)/v24
twoway (scatter inversiones year)  (lfit inversiones year)
gen capital =  ((1083+1061)/v24)*ajustemonet*(ipc_06_NACI/100)
sum capital

twoway (scatter capital year)  (lfit capital year)
 
 *************************************************************************************************************************
***************************************************************************************************************************
replace consult1 = 0 if missing(consult1)
replace v967 = 0 if missing(v967)
generate lepc=v967*0.25
generate leh=v969
generate leca=971*0.3


gen le=lec+leh+leca
twoway (scatter le year)

**inputs  

generate mir=v545+v546
generate otest= v547+v548 
gen estud=mir

generate farmaceu=v115+0.5*v117+v119
generate farmaceuf=v116+0.5*v118+v120
generate otros1=v121+v123+v125
generate otros1f=v122+v124+v126
generate l=medicos+farmaceu+otros1
generate lf=medicosf+farmaceuf+otros1f
gen licenciados=l+lf  
************************************************

generate enferme=v127+0.5*v129+v131
generate enfermef=v128+0.5*v130+v132
generate otros2=v151+0.5*v153+v155
generate otros2f=v152+0.5*v154+v156
generate t=enferme+otros2
generate tf=enfermef+otros2f
gen tecnicos=t+tf

generate ayudante=v161+0.5*v163
generate ayudantef=v162+0.5*v164
generate otrosnoa=v169+0.5*v171+v173
generate otrosnoaf=v170+0.5*v172+v174

generate aux=ayudante+otrosnoa
generate auxf=ayudantef+otrosnoaf

gen auxiliares=aux+auxf

generate res=v175+0.5*v177+v179+v193+0.5*v195+v197+v199+0.5*v201+v211+0.5*v213+v215+v217+0.5*v219+v221+v223+0.5*v225+v227+v229+0.5*v231+v233
generate resf=v176+0.5*v178+v180+v194+0.5*v196+v198+v200+0.5*v202+v212+0.5*v214+v216+v218+0.5*v220+v222+v224+0.5*v226+v228+v230+0.5*v232+v234

gen resto=res+resf

gen perso=resto+auxiliares+tecnicos+licenciados+estud
generate suministros=v1048
generate camas=v24

collapse (mean) altash le licenciados tecnicos auxiliares resto estud suministros capital camas inversiones consult1 consult2 uni tend tend2, by (codccaa year)
list
sum

sort codccaa
save emergencia.dta, replace 

use  "C:\Users\Rodrigo\Desktop\mayte2\dempob.dta"


sort codccaa


merge 1:1 codccaa year using emergencia.dta


sum le
replace le = 0.0000001 if le==0
generate ly1=log(le)
generate y=le+altash
generate ly2=log(y)

generate lx1=log(camas)
generate lx2=log(licenciados)
generate lx3=log(tecnicos)
generate lx7=log(capital)
generate lx9=log(inversiones)

generate lx4=log(auxiliares)
generate lx5=log(resto)
generate lx6=log(suministros)
generate lx8=log(estud)

generate ld1=log(paro)
generate ld2=log(pib)
generate ld3=log(morbilidad)


replace ipc = 5 if missing(ipc)  
replace ipc=5 if ipc<0

generate ld4=log(ipc)
sum esperanza
generate ld5=log(esperanza)
generate ld6=log(poblacion)


gen consult=(consult1+consult2)
generate ld7=log(consult) 




egen mly1=mean(ly1)
egen mly2=mean(ly2)
egen mlx1=mean(lx1)
egen mlx2=mean(lx2)
egen mlx3=mean(lx3)
egen mlx4=mean(lx4)
egen mlx5=mean(lx5)
egen mlx6=mean(lx6)
egen mlx7=mean(lx7)
egen mlx8=mean(lx8)
egen mlx9=mean(lx9)
egen mtend=mean(tend)
egen mtend2=mean(tend2)

egen mld1=mean(ld1)
egen mld2=mean(ld2)
egen mld3=mean(ld3)
egen mld4=mean(ld4)
egen mld5=mean(ld5)
egen mld6=mean(ld6)
egen mld7=mean(ld7)


generate y1=ly1-mly1
list y1 ly1 mly1


generate y2=ly2-mly2

generate x1=lx1-mlx1
generate x2=lx2-mlx2
generate x3=lx3-mlx3
generate x4=lx4-mlx4
generate x5=lx5-mlx5
generate x6=lx6-mlx6
generate x7=lx7-mlx7
generate x8=lx8-mlx8
generate x9=lx9-mlx9
generate t=tend-mtend
generate t2=tend2-mtend2


generate d1=ld1-mld1
generate d2=ld2-mld2
generate d3=ld3-mld3
generate d4=ld4-mld4
generate d5=ld5-mld5
generate d6=ld6-mld6
generate d7=ld7-mld7




*descriptive statistics (table 1)
sum le inversiones capital paro pib consult poblacion esperanza 

**regression results  (table 2)
xtset codccaa year
xi: xtpcse y1  i.codccaa i.year x9 x7 d1 d2 d7  d6 d5, c(psar1) rhotype(freg)  het  

*d5 coefficient without logs
egen d5mean=mean(esperanza)

gen d5withoutlog= -4.410519/d5mean
sum d5withoutlog

* several Test

testparm _Iyear_1997- _Iyear_2009
testparm _Icodccaa_2 - _Icodccaa_17

*******************************
*autocorrelation:
findit xtserial
 net sj 3-2 st0039         
 net install st0039        
xtserial y1    x9 x7 d1 d2 d7  d6 d5 

*******************************************
*heterocedasticity
 xi: xtreg y1  i.codccaa i.year x9 x7 d1 d2 d7  d6 d5, fe
 xttest3
 
 *************************
 *correlation contemporanea
 tsset codccaa year,yearly
  xi: xtreg y1  i.codccaa i.year x9 x7 d1 d2 d7  d6 d5, fe
  xtcsd , pesaran 
 
  
****************************
