*sysuse CHMSAIntroFigureData.dta

*****************
****FIGURE 2*****
*****************
*****Create LatinAmerica Matrix***** : "Number of cases of torture in each region"

tab lamerica illtreat if illtreat==1 & lamerica==1, column matcell(lamericaill)
matrix lamericailltotal = lamericaill
matrix colnames lamericailltotal = Illtreatment 
matrix list lamericailltotal

tab lamerica AnyTorture if AnyTorture==1 & lamerica==1, column matcell(lamericaany)
matrix lamericaanytotal = lamericaany
matrix colnames lamericaanytotal = AnyTorture 
matrix list lamericaanytotal

tab lamerica stealth if stealth==1 & lamerica==1, column matcell(lamericastealth)
matrix lamericastealthtotal = lamericastealth
matrix colnames lamericastealthtotal = Stealth 
matrix list lamericastealthtotal

tab lamerica scarring if scarring==1 & lamerica==1, column matcell(lamericascarring)
matrix lamericascarringtotal = lamericascarring
matrix colnames lamericascarringtotal = Scarring 
matrix list lamericascarringtotal

tab lamerica unknown if unknown==1 & lamerica==1, column matcell(lamericaunknown)
matrix lamericaunknowntotal = lamericaunknown
matrix colnames lamericaunknowntotal = Unknown 
matrix list lamericaunknowntotal

matrix LatinAmerica = (lamericailltotal, lamericaanytotal, lamericastealthtotal, lamericascarringtotal, lamericaunknowntotal)
matrix list LatinAmerica
matrix rowname LatinAmerica = "LatinAmerica"

******Create Sub-Saharan Africa Matrix******

tab ssafrica illtreat if illtreat==1 & ssafrica==1, column matcell(ssafricaill)
matrix ssafricailltotal = ssafricaill
matrix colnames ssafricailltotal = Illtreatment 
matrix list ssafricailltotal

tab ssafrica AnyTorture if AnyTorture==1 & ssafrica==1, column matcell(ssafricaany)
matrix ssafricaanytotal = ssafricaany
matrix colnames ssafricaanytotal = AnyTorture 
matrix list ssafricaanytotal

tab ssafrica stealth if stealth==1 & ssafrica==1, column matcell(ssafricastealth)
matrix ssafricastealthtotal = ssafricastealth
matrix colnames ssafricastealthtotal = Stealth 
matrix list ssafricastealthtotal

tab ssafrica scarring if scarring==1 & ssafrica==1, column matcell(ssafricascarring)
matrix ssafricascarringtotal = ssafricascarring
matrix colnames ssafricascarringtotal = Scarring 
matrix list ssafricascarringtotal

tab ssafrica unknown if unknown==1 & ssafrica==1, column matcell(ssafricaunknown)
matrix ssafricaunknowntotal = ssafricaunknown
matrix colnames ssafricaunknowntotal = Unknown 
matrix list ssafricaunknowntotal

matrix SubSaharanAfrica = (ssafricailltotal, ssafricaanytotal, ssafricastealthtotal, ssafricascarringtotal, ssafricaunknowntotal)
matrix rowname SubSaharanAfrica = "SSAfrica"
matrix list SubSaharanAfrica

******Create North Africa and the Middle East matrix******

tab nafrme illtreat if illtreat==1 & nafrme==1, column matcell(nafrmeill)
matrix nafrmeilltotal = nafrmeill
matrix colnames nafrmeilltotal = Illtreatment 
matrix list nafrmeilltotal

tab nafrme AnyTorture if AnyTorture==1 & nafrme==1, column matcell(nafrmeany)
matrix nafrmeanytotal = nafrmeany
matrix colnames nafrmeanytotal = AnyTorture 
matrix list nafrmeanytotal

tab nafrme stealth if stealth==1 & nafrme==1, column matcell(nafrmestealth)
matrix nafrmestealthtotal = nafrmestealth
matrix colnames nafrmestealthtotal = Stealth 
matrix list nafrmestealthtotal

tab nafrme scarring if scarring==1 & nafrme==1, column matcell(nafrmescarring)
matrix nafrmescarringtotal = nafrmescarring
matrix colnames nafrmescarringtotal = Scarring 
matrix list nafrmescarringtotal

tab nafrme unknown if unknown==1 & nafrme==1, column matcell(nafrmeunknown)
matrix nafrmeunknowntotal = nafrmeunknown
matrix colnames nafrmeunknowntotal = Unknown 
matrix list nafrmeunknowntotal

matrix MENA = (nafrmeilltotal, nafrmeanytotal, nafrmestealthtotal, nafrmescarringtotal, nafrmeunknowntotal)
matrix rowname MENA = "MENA"
matrix list MENA

*****Create Asia Matrix*****

tab asia illtreat if illtreat==1 & asia==1, column matcell(asiaill)
matrix asiailltotal = asiaill
matrix colnames asiailltotal = Illtreatment 
matrix list asiailltotal

tab asia AnyTorture if AnyTorture==1 & asia==1, column matcell(asiaany)
matrix asiaanytotal = asiaany
matrix colnames asiaanytotal = AnyTorture 
matrix list asiaanytotal

tab asia stealth if stealth==1 & asia==1, column matcell(asiastealth)
matrix asiastealthtotal = asiastealth
matrix colnames asiastealthtotal = Stealth 
matrix list asiastealthtotal

tab asia scarring if scarring==1 & asia==1, column matcell(asiascarring)
matrix asiascarringtotal = asiascarring
matrix colnames asiascarringtotal = Scarring 
matrix list asiascarringtotal

tab asia unknown if unknown==1 & asia==1, column matcell(asiaunknown)
matrix asiaunknowntotal = asiaunknown
matrix colnames asiaunknowntotal = Unknown 
matrix list asiaunknowntotal

matrix Asia = (asiailltotal, asiaanytotal, asiastealthtotal, asiascarringtotal, asiaunknowntotal)
matrix rowname Asia = "Asia"
matrix list Asia

*****Create Eastern Europe Matrix*****

tab eeurop illtreat if illtreat==1 & eeurop==1, column matcell(eeuropill)
matrix eeuropilltotal = eeuropill
matrix colnames eeuropilltotal = Illtreatment 
matrix list eeuropilltotal

tab eeurop AnyTorture if AnyTorture==1 & eeurop==1, column matcell(eeuropany)
matrix eeuropanytotal = eeuropany
matrix colnames eeuropanytotal = AnyTorture 
matrix list eeuropanytotal

tab eeurop stealth if stealth==1 & eeurop==1, column matcell(eeuropstealth)
matrix eeuropstealthtotal = eeuropstealth
matrix colnames eeuropstealthtotal = Stealth 
matrix list eeuropstealthtotal

tab eeurop scarring if scarring==1 & eeurop==1, column matcell(eeuropscarring)
matrix eeuropscarringtotal = eeuropscarring
matrix colnames eeuropscarringtotal = Scarring 
matrix list eeuropscarringtotal

tab eeurop unknown if unknown==1 & eeurop==1, column matcell(eeuropunknown)
matrix eeuropunknowntotal = eeuropunknown
matrix colnames eeuropunknowntotal = Unknown 
matrix list eeuropunknowntotal

matrix EasternEurope = (eeuropilltotal, eeuropanytotal, eeuropstealthtotal, eeuropscarringtotal, eeuropunknowntotal)
matrix rowname EasternEurope = "EasternEurope"
matrix list EasternEurope

*****Create Western Matrix*****

tab western illtreat if illtreat==1 & western==1, column matcell(westernill)
matrix westernilltotal = westernill
matrix colnames westernilltotal = Illtreatment 
matrix list westernilltotal

tab western AnyTorture if AnyTorture==1 & western==1, column matcell(westernany)
matrix westernanytotal = westernany
matrix colnames westernanytotal = AnyTorture 
matrix list westernanytotal

tab western stealth if stealth==1 & western==1, column matcell(westernstealth)
matrix westernstealthtotal = westernstealth
matrix colnames westernstealthtotal = Stealth 
matrix list westernstealthtotal

tab western scarring if scarring==1 & western==1, column matcell(westernscarring)
matrix westernscarringtotal = westernscarring
matrix colnames westernscarringtotal = Scarring 
matrix list westernscarringtotal

tab western unknown if unknown==1 & western==1, column matcell(westernunknown)
matrix westernunknowntotal = westernunknown
matrix colnames westernunknowntotal = Unknown 
matrix list westernunknowntotal

matrix WEur = (westernilltotal, westernanytotal, westernstealthtotal, westernscarringtotal, westernunknowntotal)
matrix rowname WEur = "WesternaEur+"
matrix list WEur

*Combine the 4 matricies for the plot

matrix RegionTortType = (LatinAmerica\SubSaharanAfrica\MENA\Asia\EasternEurope\WEur)

*Plot the final heat map

plotmatrix, m(RegionTortType) s(0(500)3000) c(midblue) ylabel(,angle(0) notick) xlabel(,angle(90) notick) plotregion(margin(zero)) legend(cols(1) color(black) ring(5) position(3) size(small) m(medsmall) rowgap(zero) colgap(zero) keygap(zero) symysize(huge) symxsize(huge))

*plotmatrix, m(PolInstVT) s(0(5)100) c(blue) ylabel(,angle(0) notick) xlabel(,notick) plotregion(margin(zero) style(foreground(outline(none)))) graphregion(style(foreground(outline(none)))) lwidth(none)) bgcolor(white) legend(cols(1) color(black) ring(5) position(3) size(small) m(small) rowgap(zero) colgap(zero) keygap(zero) symysize(huge) symxsize(huge)) title(Victim Type Prevalence by Political Institutions, color(black))



