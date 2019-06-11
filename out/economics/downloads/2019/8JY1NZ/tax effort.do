set memory 1000m
set matsize 800
set more off

cd "E:\EF CCAA\"
use efccaa2.dta, replace

tsset id ano, yearly

*Recaudac Tributaria
gen trib=(impdirect+impindir+tasas)*1000
gen tribr=((impdirect+impindir+tasas)*1000)/(ipc/100)

*PIB
gen pib1=pib*1000000
gen pibr=(pib*1000000)/(ipc/100)
gen lpibr=log(pibr)
gen pibpcr=pibpc/(ipc/100)

gen lpibpcr=log(pibpcr)

rename crisis crisisinicial
rename ca5 can
rename devol tend
rename calidadgest qmanag
rename colorpol dpolitcolour
rename dnca dsint
gen gdpgrowth=100*d.pibr/L.pibr
gen tdpib=100*d.pib/L.pib
gen lgdpgrowth=log(gdpgrowth)
gen ltdpib=log(tdpib)

gen tdpibpcr=100*d.pibpcr/L.pibpcr
gen tdpibpc=100*d.pibpc/L.pibpc
gen dpibpcr=d.pibpcr
gen ldpibpcr=log(dpibpcr)
gen ltdpibpcr=log(tdpibpcr)
gen ltdpibpc=log(tdpibpc)

gen density=densidad
gen pob1=pob*1000


gen ingcor=(impdirect+impindir+tasas+ingtrnc+ingpatr) // en miles euros
gen ingcorr=ingcor*1000/(pib*1000000)

gen tax=log(tribr)




gen gk=(invrea+gttrnk) //en euros
replace   gk=0.00000000001 if gk==0

gen gkr=(gk*1000)/(pib*1000000) //el numerador esta en miles euros y el pib en millones

gen lgk=log(gk)
gen lgkr=log(gkr)
replace lgkr=0 if lgkr==.

gen gkpcr=(gk*1000/(ipc/100))/(pob*1000) //el numerador esta en miles euros y la pob en miles
replace gkpcr=0.0000001 if gkpcr<=0

gen tribk=(impdirect+impindir+tasas)/gk

gen stockkr=stockkpub/(ipc/100) // ojo: no se si el stock est?n miles o en euros

gen dstockkr=(D.stockkpub)/pib
gen ldstockkr=log(dstockkr)
gen ldstockkrf1=F.ldstockkr

gen dstockkpc=D.stockkr/pob
gen ldstockkpc=log(dstockkpc)

gen dstockksup=D.stockkr/superf
gen ldstockksup=ln(dstockksup)



gen gtcor=(gtperson+gtbscor+gtfinanc+gttrncor)
gen gtcorr=gtcor*1000/(pib*1000000)
gen lgtcorr=log(gtcorr)

gen gtcorpc=((gtperson+gtbscor+gtfinanc+gttrncor)*1000/(ipc/100))/(pob*1000)
gen lgtcorpc=ln(gtcorpc)

gen nfexp=((gtperson+gtbscor+gttrncor)*1000/(ipc/100))/(pob*1000)
gen l1nfexp=L1.nfexp

gen scor=(impdirect+impindir+tasas+ingtrnc+ingpatr)-(gtperson+gtbscor+gtfinanc+gttrncor)
gen scorr=scor*1000/(pib*1000000)
//replace   scorr=0.0000000001 if scorr==0
//replace   scorr=0.0000000001 if scorr<0
gen lscorr=ln(scorr)
replace   lscorr=0 if lscorr==.

gen scorp=(impdirect+impindir+tasas+ingtrnc+ingpatr)-(gtperson+gtbscor+gttrncor)
gen scorrp=scorp*1000/(pib*1000000)
replace   scorrp=0.0000000001 if scorrp==0
replace   scorrp=0.0000000001 if scorrp<0
gen lscorrp=log(scorrp)
replace lscorrp=0 if lscorrp==.

gen scorppc=(scorp*1000/(ipc/100))/(pob*1000)
replace scorppc=0.000000001 if scorppc<=0

gen gtfin=(gtfinanc+gtpasfin)/ingcor

gen fexpr=((gtfinanc+gtpasfin)*1000/(ipc/100))/(pob*1000)


gen foral=ca15+ca16

*ING TRANSF CAPITAL
gen itkr=ingtrnk*1000/(pib*1000000) //el numerador esta en euros y el pib en miles
replace   itkr=0.00000000001 if itkr==0
gen litkr=ln(itkr)
replace litkr=0 if litkr==.
gen itkpc=(ingtrnk*1000/(ipc/100))/(pob*1000)
replace   itkpc=0.00000000001 if itkpc==0

*ENDEUDAMIENTO
gen deudanet=(ingpasfin-gtpasfin)
gen deudanetr=deudanet*1000/(pib*1000000)
replace   deudanetr=0.00000000001 if deudanetr<=0

gen ldeudanetr=log(deudanetr)
replace   ldeudanetr=0 if ldeudanetr==.

gen deudar=(ingpasfin)*1000/(pib*1000000) //el numerador esta en euros y el pib en miles
replace   deudar=0.00000000001 if deudar==0


gen ldeudar=log(deudar)
replace   ldeudar=0 if ldeudar==.

gen deudapc=(ingpasfin*1000/(ipc/100))/(pob*1000)
replace deudapc=0.00000001 if deudapc<=0
*POBLACION
gen pob2=pob*pob*1000*1000
gen lpob=log(pob*1000)
gen lpob2=log(pob2)






gen deudak=ingpasfin/gk

gen dempleo=d.nocup
gen ldempleo=ln(dempleo)
gen lempleo=ln(nocup)

gen activ=100*nocup/pob //??
gen lactiv=ln(activ)

gen ltparo=ln(tparo)

gen productiv=pib*1000000/(nocup*1000) // num esta en millones y en denom en miles
gen productivr=productiv/(ipc/100)
gen tdproductiv=100*d.productiv/productiv
gen tdproductivr=100*d.productivr/productivr

gen lproductr=ln(productivr)
gen lproduct=ln(productiv)
gen ltdproductr=ln(tdproductivr)
gen ltdproduct=ln(tdproductiv)



gen litkr1=L.litkr
gen ldeudar1=L.ldeudar
gen lscorrp1=L.lscorrp

gen litkr2=L2.litkr
gen ldeudar2=L2.ldeudar
gen lscorrp2=L2.lscorrp

gen litkr3=L3.litkr
gen ldeudar3=L3.ldeudar
gen lscorrp3=L3.lscorrp

gen litkr4=L4.litkr
gen ldeudar4=L4.ldeudar
gen lscorrp4=L4.lscorrp


gen nofci=ca2+ca4+ca9+ca13+ca17+ca16+ca15

gen density2=density*density
set emptycells drop

gen tnocup=100*(1+((nocup-L5.nocup)/L5.nocup))
gen tpib=100*(1+((pib-L5.pib)/L5.pib))
gen tproductivr=100*(1+((productivr-L5.productivr)/L5.productivr))

gen tfnocup=(F2.nocup)*100/nocup
gen tfpibr=(F2.pibr)*100/pibr
gen tfproductivr=(F2.productivr)*100/productivr
gen tfgk= (F2.gkr)/gkr

gen tcnocup=((F2.nocup)-nocup)*100/nocup
gen tcpibr=((F2.pibr)+pibr)*100/pibr
gen tcpibpcr=((F2.pibpcr)+pibpcr)*100/pibpcr
gen tcproductivr=((F2.productivr)-productivr)*100/productivr
gen tcgk= (F2.gkr)/gkr

gen nocuppc=nocup/pob
gen medproductivr= (productivr+L1.productivr+L2.productivr+L3.productivr+L4.productivr)/5
gen medpibr= (pibpcr+L1.pibpcr+L2.pibpcr+L3.pibpcr+L4.pibpcr)/5
gen mednocuppc= (nocuppc+L1.nocuppc+L2.nocuppc+L3.nocuppc+L4.nocuppc)/5

gen med3productivr= (productivr+L1.productivr+L2.productivr)/3
gen med3pibpcr= (pibr+L1.pibr+L2.pibr)/3
gen med3nocuppc= (nocuppc+L1.nocuppc+L2.nocuppc)/3

gen medFproductivr= (productivr+F1.productivr+F2.productivr)/3
gen medFpibr= (pibr+F1.pibr+F2.pibr)/3
gen medFpibpcr= (pibpcr+F1.pibpcr+F2.pibpcr)/3
gen medFnocuppc= (nocuppc+F1.nocuppc+F2.nocuppc)/3
gen nocuppcf=F2.nocuppc
gen pibpcrf=F2.pibpcr
gen productivrf=F2.productivr

gen medF2productivr= (F1.productivr+F2.productivr)/2
gen medF2pibr= (F1.pibr+F2.pibr)/2
gen medF2nocuppc= (F1.nocuppc+F2.nocuppc)/2

gen prodocupr = (pib*1000000/(ipc/100))/(nocup*1000)
edit tribr pibr pob1  prodocupr

gen medFprodocupr= (prodocupr+F1.prodocupr+F2.prodocupr)/3
edit id ano tribr pibr pob1  prodocupr
summarize tribr pibr pob1  prodocupr
correlat tribr pibr pob1  prodocupr




gen irpfr=(irpf*1000)/(ipc/100)

gen _1_5w6_5r=(_1_5w6_5)/(ipc/100)
gen lw1565r=log(_1_5w6_5r)
gen mediapib=(_1_5w6_5)/(pib*1000000/100)



gen _1_5w7_5r=(_1_5w7_5)/(ipc/100)
gen lw1575r=log(_1_5w7_5r)
gen medyricpib=(_1_5w7_5)/(pib*1000000/100)


gen w7_5r=(w7_5)/(ipc/100)
gen lw75r=log(w7_5r)
gen lricos=log(w7_5r)
gen ricos2=w7_5r*w7_5r
gen lricos2=log(ricos2)
gen ricospib=(w7_5)/(pib*1000000/100)
gen lricospib=log(ricospib)

gen  elite=_1_5w7_5+w7_5

gen elitepib=elite*100/(pib*1000000000)
gen lelitepib=log(elitepib)





gen isdr=(isd*1000)/(ipc/100)
gen defunpob=defunciones*pob
gen iicceer=(iiccee*1000)/(ipc/100)
gen gtfinalhogr=(gtfinalhog*1000)/(ipc/100)

gen ivar=(iva*1000)/(ipc/100)

gen imppatr=(imppat*1000)/(ipc/100)



gen stockr=(stockk*1000)/(ipc/100)
gen lstockr=log(stockr)
gen skprivr=(stockk-stockkpub)/(ipc/100)
gen lskprivr=log(skprivr)
gen lskprivr1=lskprivr[_n-1]

gen skprir=(stockkpri)/(ipc/100)
gen stockp=log(skprir)
gen stockp1=stockp[_n-1]

gen skprir2=(stockkpri2)/(ipc/100)
gen stockp2=log(skprir2)
gen stockp21=stockp2[_n-1]





gen viviendar=(vivienda*1000)/(ipc/100)



gen ano0811=ano08+ano09+ano10+ano11
gen ano0911=ano09+ano10+ano11
gen crisis0812=ano08+ano09+ano10+ano11+ano12
gen crisis0810=ano08+ano09+ano10
gen crisis=ano10+ano11+ano12
gen crisis0912=ano09+ano10+ano11+ano12




gen ambienter=((ambiente*1000)/(ipc/100))



gen tjuegr=(tjueg*1000)/(ipc/100)
gen juegor=(juego*pob*1000)/(ipc/100)

gen itpajdr=(itpajd*1000)/(ipc/100)
gen actfinancr=(actfinanc*1000)/(ipc/100)

gen normativa=isdr+irpfr+ivar+tjuegr+itpajdr+iicceer+imppatr
gen lnormativa=log(normativa)
gen pop=log(pob1)




gen lviviendar=log(viviendar)
gen gamblingexpr=log(juegor)
gen lhipot=log(hipot)
gen vabpcr=vabcte/pob1
gen lvabr=log(vabcte)
gen ldensity=log(density)
gen lvabpcr=log(vabcte/pob)

gen lpibpcr2=lpibpcr*lpibpcr
gen popgrowth=(D.pob1/L.pob)
gen lpopgrowth=log(popgrowth)
gen income=log(vabcte)

gen patrev=((ingpatr+enajinv)/(ipc/100))/(pob*1000)
gen IngSust=(ingtrnc+ingtrnk+ingpasfin)/(ipc/100)
gen Transfrev=((ingtrnc*1000+ingtrnk*1000)/(ipc/100))/(pob*1000)
gen Transfrevk=((ingtrnk*1000)/(ipc/100))/(pob*1000)
gen Transfrevc=((ingtrnc*1000)/(ipc/100))/(pob*1000)
gen activism2=((ambiente*1000)/(ipc/100))/(pob*1000)
gen activism1=activismo*(ca1+ca13+ca9+ca10)
replace activism1=0 if activism1==.

gen ldefunpob=log(defunpob)
gen lgtfinalhogr=log(gtfinalhogr)
gen pop1=L1.pop
gen income1=L1.income
gen pop2=L2.pop
gen pop3=L3.pop

gen income2=L2.income
gen income3=L3.income

gen lTransfrev=log(Transfrev)
gen lTransfrev1=L1.lTransfrev
gen lTransfrev2=L2.lTransfrev

gen lpatrev=log(patrev)
gen lpatrev1=L1.lpatrev

gen lnfexp=log(nfexp)
gen lnfexp1=L1.lnfexp
gen lnfexp2=L2.lnfexp

gen lfexpr=log(fexpr)
gen lfexpr1=L1.lfexpr


gen lgtfinalhogr1=L1.lgtfinalhogr

gen lgtfinalhogr2=L2.lgtfinalhogr

gen lpibr1=L1.lpibr
gen lpibr2=L2.lpibr
xtscc income    lpibr1  lpibr2  vabagric gdpgrowth
predict lvabctehat
rename lvabctehat incomehat





sfpanel tax income  pop  ano0911 can dprov stockp   gamblingexpr tend if ano>2001 & ano<2013 & ca15==0 & ca16==0, model(tre) dist(tnormal) emean(density  popgrowth qmanag   Transfrev  patrev    activism1 activism2 dpolitcolour dsint  nfexp   gdpgrowth crisis  fexpr) dif iter(500) svfrontier(0.7712 0.2952 -0.1612 -0.4271 -0.045 -0.052 -0.0524 0.0366 8.1645)






sfpanel tax incomehat  pop  ano0911 can dprov stockp   gamblingexpr tend if ano>2001 & ano<2013 & ca15==0 & ca16==0, model(tre) dist(tnormal) emean(density  popgrowth qmanag   Transfrev  patrev    activism1 activism2 dpolitcolour dsint  nfexp   gdpgrowth crisis  fexpr) dif iter(500) svfrontier(0.7712 0.2952 -0.1612 -0.4271 -0.045 -0.052 -0.0524 0.0366 8.1645)
predict gkrfe  if ano>2001 & ano<2013 & ca15==0 & ca16==0, jlms
rename gkrfe taxefforthat
gen l1dpolitcolour=L1.dpolitcolour
gen l1dsint=L1.dsint
gen l2dpolitcolour=L2.dpolitcolour
gen l2dsint=L2.dsint

ivregress 2sls tax   pop stockp gamblingexpr  can dprov   ano0911  tend (income =  lpibr1  lpibr2  vabagric gdpgrowth  ) if ano>2001 & ano<2013 & ca15==0 & ca16==0, vce(robust)
estat endogenous
estat overid



ivregress 2sls tax  income   stockp gamblingexpr  can dprov   ano0911  tend ( lpob=  lpibr1 lpibr2  vabagric gdpgrowth ) if ano>2001 & ano<2013 & ca15==0 & ca16==0
estat endogenous
estat overid

ivregress 2sls taxefforthat     density  popgrowth qmanag   Transfrev  patrev    activism1 activism2  dsint  nfexp   gdpgrowth crisis  fexpr  (dpolitcolour= lgtfinalhogr lpibr1  pop popgrowth gdpgrowth) if ano>2001 & ano<2013 & ca15==0 & ca16==0
estat endogenous
estat overid


ivregress 2sls taxefforthat   density  popgrowth qmanag   Transfrev  patrev    activism1 activism2 dpolitcolour   nfexp   gdpgrowth crisis  fexpr (dsint=  lpibr1  pop popgrowth gdpgrowth) if ano>2001 & ano<2013 & ca15==0 & ca16==0, vce(robust)
estat endogenous
estat overid



gen l1Transfrev=L1.Transfrev

ivregress 2sls taxefforthat   density  popgrowth qmanag     patrev    activism1 activism2 dpolitcolour dsint  nfexp   gdpgrowth crisis  fexpr (lTransfrev= l1Transfrev pop lgtfinalhogr) if ano>2001 & ano<2013 & ca15==0 & ca16==0
estat endogenous
estat overid



ivregress 2sls taxefforthat   density  popgrowth qmanag   Transfrev  patrev    activism1 activism2 dpolitcolour dsint     gdpgrowth crisis  fexpr (nfexp=  lpibr1 lpibr2  vabagric gdpgrowth  ) if ano>2001 & ano<2013 & ca15==0 & ca16==0
estat endogenous
estat overid

