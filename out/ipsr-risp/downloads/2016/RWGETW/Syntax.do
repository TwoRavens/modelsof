
 ***RISP Syntax for "REPRESENTATION THROUGH THE EYES OF THE VOTER: A COST-BENEFIT ANALYSIS OF EUROPEAN INTEGRATION"
 
 ***use EES 2009 (www.piredeu.eu), KEEP IF Q24==1
 ***use EU profiler 2009 (www.gesis.org); match the position  (as reported by Q80 EES) of voters (q25) with the position of the party they voted for (156 parties, as coded by EU Profiler 2009 and documented in Borz and Rose (2010))
 **generate Q25Q80 '2=represented; 0=indiferent; 1=misrepresented' 
 
 use: "RISPData"
 
 ***Variables in the analysis
 
  label variable Q25Q80R "Quality of representation"
  label define Q25Q80R 2 "represented" 0 "indiferent" 1 "misrepresented"
  label variable Q25Q80RR "Representation by pro-integration parties only"
  label define Q25Q80RR 2 "represented" 0 "indiferent" 1 "misrepresented"
  label variable Q25Q80_1 "Representation by anti-integration parties only"
  label define Q25Q80_1 2 "represented" 0 "indiferent" 1 "misrepresented"
  label variable T102 "country"
 
 label variable EVALUATION "positive evaluation Q41 + Q79"
 label variable euposinf  "EU policy influence Q73+Q74+Q75+Q76+Q77"

 label variable Q56R "immigrants should adapt"
 label variable Q67R "immigration should decrease"
 label variable Q91RR "EU decisions not in interest of own country"
 label variable Q40R "EP does not consider citizen's concerns"
 
 
 label variable NEWEU12 "New EU12"
 label variable euintcpt "competition on EU integration (0/1)"
 label variable euslg "EU spending(log of net contribution)"
 label variable pcomp "N dimensions party competition"
 
 label variable Q6R "EU deals with imp issues"
 label variable Q42R "cares which party wins EP elections"
 label variable Q82R "feels European"
 
 label variable V200FF "education"
 label variable Q120RR "standard of living"
 label variable Q93R "knowledge about EU"
 label variable Q46NEITH "neither left nor right" 
 label variable Q48R "evaluation of gov't econ performance"
 label variable Q16R "watch election news on TV" 
 label variable Q7R "how many days follows news"


**Figure1.  Power point figure with data from Appendix Table 1 as by described below

**Table 1. ALL VOTERS 
mlogit Q25Q80R EVALUATION euposinf   Q56R Q67R  Q91RR Q40R    NEWEU12 euintcpt euslg pcomp   Q6R Q42R Q82R   V200FF Q120RR  Q93R Q46NEITH  Q48R Q16R Q7R, base(2)
estout, eform drop(_cons) cells(b(star fmt(%8.3f)) se(par)) stats(r2_p chi2 p, labels ("Pseudo R-Square")) unstack varwidth(33) modelwidth(10) collabels(var) legend mlabels ("Multinomial Model")label

** Table 3. MODEL 1 VOTERS FOR PRO-INTEGRATION PARTIES
keep if T102==1196 | T102==1203 | T102==1208 | T102==1246 | T102==1250 | T102==1300 | T102==1348 | T102==1372 | T102==1528 | T102==1620 | T102==1642 | T102==1703 | T102==1752 | T102==1826
mlogit Q25Q80RR  EVALUATION euposinf   Q56R Q67R  Q91RR Q40R    NEWEU12 euintcpt euslg pcomp   Q6R Q42R Q82R   V200FF Q120RR  Q93R Q46NEITH  Q48R Q16R Q7R, base(2)
estout, eform drop(_cons) cells(b(star fmt(%8.3f)) se(par)) stats(r2_p chi2 p, labels ("Pseudo R-Square")) unstack varwidth(33) modelwidth(10) collabels(var) legend mlabels ("Multinomial Model")label

**Table 3. Model 2 VOTERS FOR ANTI-INTEGRATION PARTIES 
keep if T102==1196 | T102==1203 | T102==1208 | T102==1246 | T102==1250 | T102==1300 | T102==1348 | T102==1372 | T102==1528 | T102==1620 | T102==1642 | T102==1703 | T102==1752 | T102==1826
mlogit Q25Q80_1  EVALUATION euposinf   Q56R Q67R  Q91RR Q40R    NEWEU12 euintcpt euslg pcomp   Q6R Q42R Q82R   V200FF Q120RR  Q93R Q46NEITH  Q48R Q16R Q7R, base(2)
estout, eform drop(_cons) cells(b(star fmt(%8.3f)) se(par)) stats(r2_p chi2 p, labels ("Pseudo R-Square")) unstack varwidth(33) modelwidth(10) collabels(var) legend mlabels ("Multinomial Model")label
clear

**Appendix Table 1
use: "RISPData"
tabulate Q25Q80R T102, column

**Appendix Table 2
summarize Q25Q80R EVALUATION euposinf   Q56R Q67R  Q91RR Q40R    NEWEU12 euintcpt euslg pcomp   Q6R Q42R Q82R   V200FF Q120RR  Q93R Q46NEITH  Q48R Q16R Q7R


