**** Necessary Stata Installations:

ssc install outreg2
ssc install mkcorr

** INSTALL RELOGIT
** Install Rare Events Logit (relogitll) by Travis Braidwood
** relogitll is a modified version of Tomz, King, and Zeng's relogit (http://gking.harvard.edu/scholar_software/relogit-rare-events-logistic-regression/1-1-stata)
** Calculates model fit statistics
** relogitll available at http://travisbraidwood.altervista.org/relogitll.ado
** Add (after unzipping if needed) to "ado/base/r" folder in the Stata program folder, typically under "Applications" (in Mac)
** We have also provided the .ado file for relogitll with our replication materials
   


** Specify a working directory before beginning

set more off
*** Table 1
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using Model1Main.doc, dec(2) replace alpha(0.05) symbol(*) 
scalar list

***** Appendix Table 2 (Summary Statistics)
order irredentism irrmargin irrMajoritarianALL hostdispersed hostdiscrim irrhigh irrlow countryGDPRATIO anoano anono noano nono hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet
sum irredentism irrmargin irrMajoritarianALL hostdispersed hostdiscrim irrhigh irrlow countryGDPRATIO anoano anono noano nono hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet 
outreg2 using TableA2-SummaryStats.doc, dec(2) replace sum(log) keep(irredentism irrmargin irrMajoritarianALL hostdispersed hostdiscrim irrhigh irrlow countryGDPRATIO anoano anono noano nono hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet)

***** Appendix Table 3 (Correlation Matrix)
** Open Correlation.doc in Word with MAC OS (Default) Text Encoding; Document Direction Left-to-right; 
** Convert Text to Table in Word; Separate at Tabs; format as necessary in Word
corr irrmargin irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano nono hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet 
mkcorr irrmargin irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano nono hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet, log(TableA3-Correlation.doc) replace casewise


*** Appendix Table 4 (Irredentist Ethnic Margin/Host Ethnic Dispersion Interaction)
relogitll irredentism irrmargin irrMajoritarianALL hostdispersed irrmargin_hostdispersed hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA4.doc, dec(2) replace alpha(0.05) symbol(*)

**** Appendix Table 5: Electoral System Check
relogitll irredentism irrmargin irrMajoritarian2 irrmarginXirrMajoritarian2 hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA5.doc, dec(2) replace alpha(0.05) symbol(*)

*** Appendix Table 6-1: Margin Quadratic
relogitll irredentism irrmargin irrmarginsquared irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA6-1.doc, dec(2) replace alpha(0.05) symbol(*)

**6-2: Proportion Quadratic
relogitll irredentism irrgpro irrgprosquared irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA6-2.doc, dec(2) replace alpha(0.05) symbol(*)


** Appendix Table 7 Ethnicity Robustness Checks, Full
** Table 7A
relogitll irredentism hostef irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7A-hostef.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism hostgpro irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7A-hostgpro.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism hostplural irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7A-hostplural.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism hostcdiv irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7A-hostcdiv.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism hostnumgrps irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7A-hostnumgrps.doc, dec(2) replace alpha(0.05) symbol(*)



** Table 7B
relogitll irredentism irref irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7B-irref.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism irrgpro irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7B-irrgpro.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism irrplural irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7B-irrplural.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism irrcdiv irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7B-irrcdiv.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism irrnumgrps irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7B-irrnumgrps.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism irrmargin irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7B-irrmargin.doc, dec(2) replace alpha(0.05) symbol(*)

** Table 7C
relogitll irredentism irref irrMajoritarianALL irrefXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7C-irrefint.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism irrgpro irrMajoritarianALL irrgproXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7C-irrgproint.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism irrplural irrMajoritarianALL irrpluralXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7C-irrpluralint.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism irrcdiv irrMajoritarianALL irrcdivXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7C-irrcdivint.doc, dec(2) replace alpha(0.05) symbol(*)

relogitll irredentism irrnumgrps irrMajoritarianALL irrnumgrpsXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA7C-irrnumgrpsint.doc, dec(2) replace alpha(0.05) symbol(*)

*** Appendix Table 8B
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 2, cluster(triadcode)outreg2 using ModelA8B-No2.doc,  dec(2) replace alpha(0.05) symbol(*)
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 5, cluster(triadcode)outreg2 using ModelA8B-No5.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 15, cluster(triadcode)outreg2 using ModelA8B-No15.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 21, cluster(triadcode)outreg2 using ModelA8B-No21.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 26, cluster(triadcode)outreg2 using ModelA8B-No26.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 31, cluster(triadcode)outreg2 using ModelA8B-No31.doc,  dec(2) replace alpha(0.05) symbol(*)
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 43, cluster(triadcode)outreg2 using ModelA8B-No43.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 53, cluster(triadcode)outreg2 using ModelA8B-No53.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 64, cluster(triadcode)outreg2 using ModelA8B-No64.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 69, cluster(triadcode)outreg2 using ModelA8B-No69.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 75, cluster(triadcode)outreg2 using ModelA8B-No75.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 90, cluster(triadcode)outreg2 using ModelA8B-No90.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 91, cluster(triadcode)outreg2 using ModelA8B-No91.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 92, cluster(triadcode)outreg2 using ModelA8B-No92.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 93, cluster(triadcode)outreg2 using ModelA8B-No93.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 97, cluster(triadcode)outreg2 using ModelA8B-No97.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 98, cluster(triadcode)outreg2 using ModelA8B-No98.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 102, cluster(triadcode)outreg2 using ModelA8B-No102.doc,  dec(2) replace alpha(0.05) symbol(*)relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if triadcode != 103, cluster(triadcode)outreg2 using ModelA8B-No103.doc,  dec(2) replace alpha(0.05) symbol(*)

** Appendix Table 9: Regional Controls
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet EEurope CenAsiaNAfrica SubSahAfrica peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA9.doc,  dec(2) replace alpha(0.05) symbol(*)

*** Appendix Table 10: Checks of Expected Utility Model
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop eqSacqa eqSacqb eqSnego eqSwara IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA10.doc, dec(2) replace alpha(0.05) symbol(*)

**** Appendix Table 11: Model 1 (Group Proportion)
relogitll irredentism irrgpro irrMajoritarianALL irrgproXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA11-1.doc,  dec(2) replace alpha(0.05) symbol(*)

**** Appendix Table 11: Model 2 (Group GDP Ratio)
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL irrhigh irrlow hostdiscrim groupGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA11-2.doc,  dec(2) replace alpha(0.05) symbol(*)

**** Appendix Table 11: Model 3 (Monadic Regime Indicators)
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO irrdemocl irrautocl hostdemocl hostautocl hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA11-3.doc,  dec(2) replace alpha(0.05) symbol(*)

**** Appendix Table 11: Model 4 (No Islands)
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if host != "Indonesia" & host != "Taiwan" & host != "Trinidad & Tobago" & host != "United Kingdom", cluster(triadcode) 
outreg2 using ModelA11-4.doc,  dec(2) replace alpha(0.05) symbol(*)

*** Appendix Table 11: Model 5 (exclude Soviet dummies) 
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA11-5.doc,  dec(2) replace alpha(0.05) symbol(*)

*** Appendix Table 11: Model 6 (exclude asymmetric inequality) 
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
outreg2 using ModelA11-6.doc, dec(2) replace alpha(0.05) symbol(*)

*** Appendix Table 11: Model 7 (exclude if group < 0.5)
relogitll irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed if irrgpro >= .5, cluster(triadcode) 
outreg2 using ModelA11-7.doc, dec(2) replace alpha(0.05) symbol(*)

*** The final versions of the graphs presented in the paper/appendix were further formatted with the STATA graph editor
*** Figure 1
quietly logit irredentism c.irrmargin##irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
quietly margins irrMajoritarianALL, at(irrmargin=(0(.1)1))
marginsplot, recast(line) recastci(rarea) yline(0)
graph save Graph "Figure 1.gph", replace

**** Figure 2a
quietly logit irredentism c.irrmargin##irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
quietly margins, at(irrhigh=(1(.1)1.748821))
marginsplot, recast(line) recastci(rarea)
graph save Graph "Figure 2a.gph", replace

*** Figure 2b
quietly logit irredentism c.irrmargin##irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
quietly margins, at(irrlow=(1(.1)1.8))
marginsplot, recast(line) recastci(rarea)
graph save Graph "Figure 2b.gph", replace


**** Figure 3 (From Model 1):
quietly logit irredentism c.irrmargin##irrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed, cluster(triadcode) 
quietly margins, at(anoano=1 anono = 0 noano = 0) at(anoano=0 anono=1 noano=0) at (anoano=0 anono=0 noano=1) at (anoano=0 anono=0 noano=0)  post
margins, coeflegend
test _b[1bn._at] = _b[2._at]
test _b[1bn._at] = _b[3._at]
test _b[1bn._at] = _b[4._at]
marginsplot, recast(scatter)
graph save Graph "Figure 3.gph", replace
