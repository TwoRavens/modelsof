*sysuse CHMSAIntroData.dta

*****************
****FIGURE 4*****
*****************
***Political Institutions: Judiciary (j), Legislative Checks (l2), Speech (speech), Elections (ACLPreg)
***AoC: Police, Prison, Military, Immigrant, Intelligence, Paramilitary, Unstated
*****Create Judiciary Matrix***** : "Of all cases of torture by _AoC, _% take place in countries with an independent Judiciary

tab j aocpolice if aocpolice==1 & j==1, column matcell(jpolice)
matrix jpolicepercent = [jpolice/6066]*100
matrix colnames jpolicepercent = Police 
matrix list jpolicepercent

tab j aocprison if aocprison==1 & j==1, column matcell(jprison)
matrix jprisonpercent = [jprison/2659]*100
matrix colnames jprisonpercent = Prison 
matrix list jprisonpercent

tab j aocmilitary if aocmilitary==1 & j==1, column matcell(jmilitary)
matrix jmilitarypercent = [jmilitary/3349]*100
matrix colnames jmilitarypercent = Military 
matrix list jmilitarypercent

tab j aocimmigrationdetention if aocimmigrationdetention==1 & j==1, column matcell(jimmigdet)
matrix jimmigdetpercent = [jimmigdet/218]*100
matrix colnames jimmigdetpercent = ImmigDet 
matrix list jimmigdetpercent

tab j aocintelligence if aocintelligence==1 & j==1, column matcell(jintelligence)
matrix jintelligencepercent = [jintelligence/267]*100
matrix colnames jintelligencepercent = Intel 
matrix list jintelligencepercent

tab j aocparamilitary if aocparamilitary==1 & j==1, column matcell(jparamil)
matrix jparamilpercent = [jparamil/316]*100
matrix colnames jparamilpercent = ParaMil
matrix list jparamilpercent

tab j aocunst if aocunst==1 & j==1, column matcell(junst)
matrix junstpercent = [junst/3123]*100
matrix colnames junstpercent = Unstated 
matrix list junstpercent

matrix Judiciary = (jpolicepercent, jprisonpercent, jmilitarypercent, jimmigdetpercent, jintelligencepercent, jparamilpercent, junstpercent)
matrix list Judiciary
matrix rowname Judiciary = Judiciary

****Create Legislature Matrix****

tab l2 aocpolice if aocpolice==1 & l2==1, column matcell(lpolice)
matrix lpolicepercent = [lpolice/6207]*100
matrix colnames lpolicepercent = Police 
matrix list lpolicepercent

tab l2 aocprison if aocprison==1 & l2==1, column matcell(lprison)
matrix lprisonpercent = [lprison/2667]*100
matrix colnames lprisonpercent = Prison 
matrix list lprisonpercent

tab l2 aocmilitary if aocmilitary==1 & l2==1, column matcell(lmilitary)
matrix lmilitarypercent = [lmilitary/3357]*100
matrix colnames lmilitarypercent = Military 
matrix list lmilitarypercent

tab l2 aocimmigrationdetention if aocimmigrationdetention==1 & l2==1, column matcell(limmigdet)
matrix limmigdetpercent = [limmigdet/218]*100
matrix colnames limmigdetpercent = ImmigDet 
matrix list limmigdetpercent

tab l2 aocintelligence if aocintelligence==1 & l2==1, column matcell(lintelligence)
matrix lintelligencepercent = [lintelligence/269]*100
matrix colnames lintelligencepercent = Intel 
matrix list lintelligencepercent

tab l2 aocparamilitary if aocparamilitary==1 & l2==1, column matcell(lparamil)
matrix lparamilpercent = [lparamil/321]*100
matrix colnames lparamilpercent = ParaMil 
matrix list lparamilpercent

tab l2 aocunst if aocunst==1 & l2==1, column matcell(lunst)
matrix lunstpercent = [lunst/3134]*100
matrix colnames lunstpercent = Unstated 
matrix list lunstpercent

matrix Leg = (lpolicepercent, lprisonpercent, lmilitarypercent, limmigdetpercent, lintelligencepercent, lparamilpercent, lunstpercent)
matrix list Leg
matrix rowname Leg = Leg

*****Create Speech Matrix*****

tab speech aocpolice if aocpolice==1 & speech==2, column matcell(sppolice)
matrix sppolicepercent = [sppolice/6255]*100
matrix colnames sppolicepercent = Police 
matrix list sppolicepercent

tab speech aocprison if aocprison==1 & speech==2, column matcell(spprison)
matrix spprisonpercent = [spprison/2706]*100
matrix colnames spprisonpercent = Prison 
matrix list spprisonpercent

tab speech aocmilitary if aocmilitary==1 & speech==2, column matcell(spmilitary)
matrix spmilitarypercent = [spmilitary/3373]*100
matrix colnames spmilitarypercent = Military 
matrix list spmilitarypercent

tab speech aocimmigrationdetention if aocimmigrationdetention==1 & speech==2, column matcell(spimmigdet)
matrix spimmigdetpercent = [spimmigdet/223]*100
matrix colnames spimmigdetpercent = ImmigDet 
matrix list spimmigdetpercent

tab speech aocintelligence if aocintelligence==1 & speech==2, column matcell(spintelligence)
matrix spintelligencepercent = [spintelligence/269]*100
matrix colnames spintelligencepercent = Intel 
matrix list spintelligencepercent

tab speech aocparamilitary if aocparamilitary==1 & speech==2, column matcell(spparamil)
matrix spparamilpercent = [spparamil/321]*100
matrix colnames spparamilpercent = ParaMil 
matrix list spparamilpercent

tab speech aocunst if aocunst==1 & speech==2, column matcell(spunst)
matrix spunstpercent = [spunst/3169]*100
matrix colnames spunstpercent = Unstated 
matrix list spunstpercent

matrix Speech = (sppolicepercent, spprisonpercent, spmilitarypercent, spimmigdetpercent, spintelligencepercent, spparamilpercent, spunstpercent)
matrix list Speech
matrix rowname Speech = Speech

****Create Elections Matrix

tab ACLPreg aocpolice if aocpolice==1 & ACLPreg==1, column matcell(elpolice)
matrix elpolicepercent = [elpolice/5312]*100
matrix colnames elpolicepercent = Police 
matrix list elpolicepercent

tab ACLPreg aocprison if aocprison==1 & ACLPreg==1, column matcell(elprison)
matrix elprisonpercent = [elprison/2262]*100
matrix colnames elprisonpercent = Prison 
matrix list elprisonpercent

tab ACLPreg aocmilitary if aocmilitary==1 & ACLPreg==1, column matcell(elmilitary)
matrix elmilitarypercent = [elmilitary/2626]*100
matrix colnames elmilitarypercent = Military 
matrix list elmilitarypercent

tab ACLPreg aocimmigrationdetention if aocimmigrationdetention==1 & ACLPreg==1, column matcell(elimmigdet)
matrix elimmigdetpercent = [elimmigdet/157]*100
matrix colnames elimmigdetpercent = ImmigDet  
matrix list elimmigdetpercent

tab ACLPreg aocintelligence if aocintelligence==1 & ACLPreg==1, column matcell(elintelligence)
matrix elintelligencepercent = [elintelligence/212]*100
matrix colnames elintelligencepercent = Intel  
matrix list elintelligencepercent

tab ACLPreg aocparamilitary if aocparamilitary==1 & ACLPreg==1, column matcell(elparamil)
matrix elparamilpercent = [elparamil/247]*100
matrix colnames elparamilpercent = ParaMil  
matrix list elparamilpercent

tab ACLPreg aocunst if aocunst==1 & ACLPreg==1, column matcell(elunst)
matrix elunstpercent = [elunst/2485]*100
matrix colnames elunstpercent = Unstated  
matrix list elunstpercent

matrix Elections = (elpolicepercent, elprisonpercent, elmilitarypercent, elimmigdetpercent, elintelligencepercent, elparamilpercent, elunstpercent)
matrix list Elections
matrix rowname Elections = Elections 

*Combine the 4 matricies for the plot

matrix PolInst = (Judiciary\Leg\Speech\Elections)

*Plot the final heat map

plotmatrix, m(PolInst) s(0(5)100) c(midblue) ylabel(,angle(0) notick) xlabel(,angle(90) notick) plotregion(margin(zero)) legend(cols(1) color(black) ring(5) position(3) size(small) m(small) rowgap(zero) colgap(zero) keygap(zero) symysize(huge) symxsize(huge))



