*sysuse CHMSAIntroData.dta

*****************
****FIGURE 3*****
*****************
*****Create Judiciary Matrix***** : "Of all cases of _torture, _% take place in countries with an independent Judiciary

tab j illtreat if illtreat==1 & j==1, column matcell(jill)
matrix jillpercent = [jill/6507]*100
matrix colnames jillpercent = Illtreatment 
matrix list jillpercent

tab j AnyTorture if AnyTorture==1 & j==1, column matcell(jany)
matrix janypercent = [jany/13288]*100
matrix colnames janypercent = AnyTorture 
matrix list janypercent

tab j stealth if stealth==1 & j==1, column matcell(jstealth)
matrix jstealthpercent = [jstealth/3122]*100
matrix colnames jstealthpercent = Stealth 
matrix list jstealthpercent

tab j scarring if scarring==1 & j==1, column matcell(jscarring)
matrix jscarringpercent = [jscarring/7757]*100
matrix colnames jscarringpercent = Scarring 
matrix list jscarringpercent

tab j unknown if unknown==1 & j==1, column matcell(junknown)
matrix junknownpercent = [junknown/5394]*100
matrix colnames junknownpercent = Unknown 
matrix list junknownpercent

matrix Judiciary = (jillpercent, janypercent, jstealthpercent, jscarringpercent, junknownpercent)
matrix list Judiciary
matrix rowname Judiciary = Judiciary

******Create Legislature Matrix******

tab l2 illtreat if illtreat==1 & l2==1, column matcell(lill)
matrix lillpercent = [lill/6594]*100
matrix colnames lillpercent = Illtreatment 
matrix list lillpercent

tab l2 AnyTorture if AnyTorture==1 & l2==1, column matcell(lany)
matrix lanypercent = [jany/13433]*100
matrix colnames lanypercent = AnyTorture 
matrix list lanypercent

tab l2 stealth if stealth==1 & l2==1, column matcell(lstealth)
matrix lstealthpercent = [lstealth/3143]*100
matrix colnames lstealthpercent = Stealth 
matrix list lstealthpercent

tab l2 scarring if scarring==1 & l2==1, column matcell(lscarring)
matrix lscarringpercent = [lscarring/7865]*100
matrix colnames lscarringpercent = Scarring 
matrix list lscarringpercent

tab l2 unknown if unknown==1 & l2==1, column matcell(lunknown)
matrix lunknownpercent = [lunknown/5433]*100
matrix colnames lunknownpercent = Unknown 
matrix list lunknownpercent

matrix Leg = (lillpercent, lanypercent, lstealthpercent, lscarringpercent, lunknownpercent)
matrix rowname Leg = Leg
matrix list Leg

******Create Speech matrix******

tab speech illtreat if illtreat==1 & speech==2, column matcell(spill)
matrix spillpercent = [spill/6672]*100
matrix colnames spillpercent = Illtreatment 
matrix list spillpercent

tab speech AnyTorture if AnyTorture==1 & speech==2, column matcell(spany)
matrix spanypercent = [spany/13542]*100
matrix colnames spanypercent = AnyTorture 
matrix list spanypercent

tab speech stealth if stealth==1 & speech==2, column matcell(spstealth)
matrix spstealthpercent = [spstealth/3160]*100
matrix colnames spstealthpercent = Stealth 
matrix list spstealthpercent

tab speech scarring if scarring==1 & speech==2, column matcell(spscarring)
matrix spscarringpercent = [spscarring/7912]*100
matrix colnames spscarringpercent = Scarring 
matrix list spscarringpercent

tab speech unknown if unknown==1 & speech==2, column matcell(spunknown)
matrix spunknownpercent = [spunknown/5494]*100
matrix colnames spunknownpercent = Unknown 
matrix list spunknownpercent

matrix Speech = (spillpercent, spanypercent, spstealthpercent, spscarringpercent, spunknownpercent)
matrix rowname Speech = Speech 
matrix list Speech

*****Create Elections Matrix*****

tab ACLPreg illtreat if illtreat==1 & ACLPreg==1, column matcell(elill)
matrix elillpercent = [elill/5367]*100
matrix colnames elillpercent = Illtreatment 
matrix list elillpercent

tab ACLPreg AnyTorture if AnyTorture==1 & ACLPreg==1, column matcell(elany)
matrix elanypercent = [elany/11025]*100
matrix colnames elanypercent = AnyTorture 
matrix list elanypercent

tab ACLPreg stealth if stealth==1 & ACLPreg==1, column matcell(elstealth)
matrix elstealthpercent = [elstealth/2651]*100
matrix colnames elstealthpercent = Stealth 
matrix list elstealthpercent

tab ACLPreg scarring if scarring==1 & ACLPreg==1, column matcell(elscarring)
matrix elscarringpercent = [elscarring/6500]*100
matrix colnames elscarringpercent = Scarring 
matrix list elscarringpercent

tab ACLPreg unknown if unknown==1 & ACLPreg==1, column matcell(elunknown)
matrix elunknownpercent = [elunknown/4393]*100
matrix colnames elunknownpercent = Unknown 
matrix list elunknownpercent

matrix Elections = (elillpercent, elanypercent, elstealthpercent, elscarringpercent, elunknownpercent)
matrix rowname Elections = Elections 
matrix list Elections

*Combine the 4 matricies for the plot

matrix PolInst = (Judiciary\Leg\Speech\Elections)

*Plot the final heat map

plotmatrix, m(PolInst) s(0(5)100) c(midblue) ylabel(,angle(0) notick) xlabel(,angle(90) notick) plotregion(margin(zero)) legend(cols(1) color(black) ring(5) position(3) size(small) m(medsmall) rowgap(zero) colgap(zero) keygap(zero) symysize(huge) symxsize(huge))

*plotmatrix, m(PolInstVT) s(0(5)100) c(blue) ylabel(,angle(0) notick) xlabel(,notick) plotregion(margin(zero) style(foreground(outline(none)))) graphregion(style(foreground(outline(none)))) lwidth(none)) bgcolor(white) legend(cols(1) color(black) ring(5) position(3) size(small) m(small) rowgap(zero) colgap(zero) keygap(zero) symysize(huge) symxsize(huge)) title(Victim Type Prevalence by Political Institutions, color(black))



