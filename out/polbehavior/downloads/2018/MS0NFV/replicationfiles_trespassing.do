**Replication files for The Effects of Partisan Trespassing Strategies across Candidate Sex
**Nichole Bauer 

**Data Files: trepassing_study1.tab, trespassing_study2.tab, trespassing_studuy3.tab

**Study 1
**trespass_conditions 
**1=Trespassing, Issues, 
**2=Partisan, Issues 
**3=Trespass, Traits 
** 4=Partisan, Traits

**Figure  1, Web Appendix 4, Table A2 
ttest inpartisan_issue if trespass_conditions==1|trespass_conditions==2, by(trespass_conditions)
ttest outpartisan_issue if trespass_conditions==1|trespass_conditions==2, by(trespass_conditions)
**net issue effectz
ttesti 236  1.004094   1.780165  236  .6124398    1.661745, unequal
ttest inpartisan_trait if trespass_conditions==3|trespass_conditions==4, by(trespass_conditions)
ttest outpartisan_trait if trespass_conditions==3|trespass_conditions==4, by(trespass_conditions)
**net trait effect
ttesti  229 1.535943 2.312782 229  1.230235  2.242389, unequal
**Web Appendix 4, Table A3
ttest favor if trespass_conditions==1|trespass_conditions==2, by(trespass_conditions)
ttest favor if trespass_conditions==3|trespass_conditions==4, by(trespass_conditions)


**Partisan Comparisons, Web Appendix 4, Tables A4
**full_conditions
**1=Republican, Trespassing, Traits 
**2=Republican, Partisan, Traits
**3=Republican, Trespassing, Issues
**4=Republican, Partisan, Issues
**5=Democrat, Partisan, Traits
**6=Democrat, Trespassing, Traits
**7=Democrat, Partisan, Issues
**8=Democrat, Trespassing Issues

**Democratic Female Candidates
ttest inpartisan_issue if full_conditions==7|full_conditions==8, by(full_conditions)
ttest outpartisan_issue if full_conditions==7|full_conditions==8, by(full_conditions)
ttest inpartisan_trait if full_conditions==5|full_conditions==6, by(full_conditions)
ttest outpartisan_trait if full_conditions==5|full_conditions==6, by(full_conditions)
**Republican female_candidates
ttest inpartisan_issue if full_conditions==3|full_conditions==4, by(full_conditions)
ttest outpartisan_issue if full_conditions==3|full_conditions==4, by(full_conditions)
ttest inpartisan_trait if full_conditions==1|full_conditions==2, by(full_conditions)
ttest outpartisan_trait if full_conditions==1|full_conditions==2, by(full_conditions)

**Web Appendix 4, Tables A5
**Democratic Female Candidates
ttest favor if full_conditions==7|full_conditions==8, by(full_conditions)
ttest favor if full_conditions==5|full_conditions==6, by(full_conditions)
**Republican Female Candidates
ttest favor if full_conditions==3|full_conditions==4, by(full_conditions)
ttest favor if full_conditions==1|full_conditions==2, by(full_conditions)

**Study 2
**trespass_conditions
**1=Female, Trespass, Traits
**2=Female, Partisan, Traits
**3=Female, Trespass, Issues
**4=Female, Partisan, Issues
**5=Male, Trespass, Traits
**6=Male, Partisan, Traits
**7=Male, Trespass, Issues
**8=Male, Partisan, Issues

**Figure 2, Web Appendix 5, Table A6
**Female Candidates
ttest inpartisan_issue if trespass_conditions==3|trespass_conditions==4, by(trespass_conditions)  
ttest outpartisan_issue if trespass_conditions==3|trespass_conditions==4, by(trespass_conditions)  
ttesti 169  2.090616  2.449979  169  1.383193   2.127471 , unequal
ttest inpartisan_trait if trespass_conditions==1|trespass_conditions==2, by(trespass_conditions)
ttest outpartisan_trait if trespass_conditions==1|trespass_conditions==2, by(trespass_conditions)
ttesti 172 2.22093     2.3342    172    1.94186  2.263384 , unequal
**Male Candidates
ttest inpartisan_issue if trespass_conditions==7|trespass_conditions==8, by(trespass_conditions)  
ttest outpartisan_issue if trespass_conditions==7|trespass_conditions==8, by(trespass_conditions)  
ttesti   173 2.356055  2.48075 173    .5866079  1.987307
ttest inpartisan_trait if trespass_conditions==5|trespass_conditions==6, by(trespass_conditions)
ttest outpartisan_trait if trespass_conditions==5|trespass_conditions==6, by(trespass_conditions)
ttesti 169  1.987255  2.062765  169  1.75014   2.140362

**Female and Male, DID
**net issue  loss
ttesti 338  .707423     2.318216 346   1.769447    2.412906 ,  unequal
**net trait loss
ttesti 344  .27907 2.29996 338  .237115  2.102157  

**Favorability Analyses, Web Appendix 5, Table A7
**Female Candidate
ttest favor if trespass_conditions==3|trespass_conditions==4, by(trespass_conditions) 
ttest favor if trespass_conditions==1|trespass_conditions==2, by(trespass_conditions) 
**Male Candidate
ttest favor if trespass_conditions==7|trespass_conditions==8, by(trespass_conditions)  
ttest favor if trespass_conditions==5|trespass_conditions==6, by(trespass_conditions)  
**DID, issue trespassing effect on favorability
ttesti 164 -.2662602  .2839845 167  -.1763243   .2458564 , unequal
**DID, trait trespassfing effect on favorability
ttesti 163  -.0840863  .235671 162  -.0987297   .2602208 , unequal

**Partisan Differences, Web Appendix 5, Table A8 
**full_conditions
**1=Republican, Female, Trespassing, Traits
**2=Republican, Female, _Partisan, Traits
**3=Republican, Female, Trespassing, Issues
**4=Republican, Female, Partisan, Issues
**5=Republican, Male Trespassing, Traits
**6=Republican, Male, _Partisan, Traits
**7=Republican, Male, Trespassing, Issues
**8=Republican, Male, Partisan, Issues
**9=Democrat, Female, Partisan, Traits
**10=Democrat, Female, Trespassing, Traits
**11=Democrat, Female, Partisan, Issues
**12=Democrat, Female, Trespassing, Issues
**13=Democrat, Male, Partisan, Traits
**14=Democrat, Male, Trespassing, Traits
**15=Democrat, Male, Partisan, Issues
**16=Democrat, Male, Trespassing, Issues

**Democratic Female Candidates
ttest inpartisan_issue if full_conditions==11|full_conditions==12, by(full_conditions)  
ttest outpartisan_issue if full_conditions==11|full_conditions==12, by(full_conditions)  
ttest inpartisan_trait if full_conditions==9|full_conditions==10, by(full_conditions)  
ttest outpartisan_trait if full_conditions==9|full_conditions==10, by(full_conditions)  
**Democratic Male Candidates
ttest inpartisan_issue if full_conditions==15|full_conditions==16, by(full_conditions)  
ttest outpartisan_issue if full_conditions==15|full_conditions==16, by(full_conditions)  
ttest inpartisan_trait if full_conditions==13|full_conditions==14, by(full_conditions)  
ttest outpartisan_trait if full_conditions==13|full_conditions==14, by(full_conditions)  
**Republican Female Candidates
ttest inpartisan_issue if full_conditions==3|full_conditions==4, by(full_conditions)  
ttest outpartisan_issue if full_conditions==3|full_conditions==4, by(full_conditions)  
ttest inpartisan_trait if full_conditions==1|full_conditions==2, by(full_conditions)  
ttest outpartisan_trait if full_conditions==1|full_conditions==2, by(full_conditions)  
**Republican Male Candidates
ttest inpartisan_issue if full_conditions==7|full_conditions==8, by(full_conditions)  
ttest outpartisan_issue if full_conditions==7|full_conditions==8, by(full_conditions)  
ttest inpartisan_trait if full_conditions==5|full_conditions==6, by(full_conditions)  
ttest outpartisan_trait if full_conditions==5|full_conditions==6, by(full_conditions)  

**Partisan Differences, Web Appendix 5, Table A9
**Democratic Female Candidates
ttest favor if full_conditions==11|full_conditions==12, by(full_conditions)  
ttest favor if full_conditions==9|full_conditions==10, by(full_conditions)  
**Democratic Male Candidates
ttest favor if full_conditions==15|full_conditions==16, by(full_conditions)  
ttest favor if full_conditions==13|full_conditions==14, by(full_conditions) 
**Republican Female Candidates
ttest favor if full_conditions==3|full_conditions==4, by(full_conditions)  
ttest favor if full_conditions==1|full_conditions==2, by(full_conditions)  
**Republican Male Candidates
ttest favor if full_conditions==7|full_conditions==8, by(full_conditions)  
ttest favor if full_conditions==5|full_conditions==6, by(full_conditions) 

**Study 3 
**trespass_conditions
**1=Female, Same Party, Trespassing
**2=Male, Same Party, Trespassing
**3=Female, Same Party, Partisan
**4=Male, Same Party, Partisan
**5=Female, Different Party, Trespassing
**6=Male, Different Party, Trespassing
**7=Female, Different Party, Partisan
**8=Male, Different Party, Partisan

**Figure 3, Web Appendix 6, Table A10
**Co-Partisans, Female
ttest inpartisan_trait if trespass_conditions==1|trespass_conditions==3, by(trespass_conditions)
ttest outpartisan_trait if trespass_conditions==1|trespass_conditions==3, by(trespass_conditions)
**net trait effect
ttesti   197  1.472371  1.878841 197    2.212784 2.077353   , unequal
**Co-Partisans, Male
ttest inpartisan_trait if trespass_conditions==2|trespass_conditions==4, by(trespass_conditions)
ttest outpartisan_trait if trespass_conditions==2|trespass_conditions==4, by(trespass_conditions)
**net trait effect
ttesti 200   1.66   1.898849  200 1.65 1.92596 , unequal
**Out-Partisans, Female
ttest inpartisan_trait if trespass_conditions==5|trespass_conditions==7, by(trespass_conditions)
ttest outpartisan_trait if trespass_conditions==5|trespass_conditions==7, by(trespass_conditions)
**net trait effect
ttesti 199  1.784011   2.156861  199  1.517283 2.089989  , unequal
**Out-Partisans, Male
ttest inpartisan_trait if trespass_conditions==6|trespass_conditions==8, by(trespass_conditions)
ttest outpartisan_trait if trespass_conditions==6|trespass_conditions==8, by(trespass_conditions)
**net trait effect
ttesti 196   1.5475  1.945355 196  1.29625 1.94672, unequal

**DID, Female vs. Male Co-Partisans 
ttesti  394   .740413 2.012496 400 0.01 1.910061  , unequal

**DID, Female vs. Male Out-Partisans
ttesti 398 .266728   2.125211 392   .25125  1.947614, unequal

**Trait Loss, DID, Female, Co-Partisans vs. Out-Partisans
ttesti 394 -.740413 2.012496  398  .266728  2.125211  , unequal

**Trait Loss, DID, Male, Co-Partisans vs. Out-Partisans
ttesti 400 0.01  1.910061  392  .25125  1.947614 , unequal

**Favorability, Web Appendix 6, Table A11
**Co-Partisans
ttest favor if trespass_conditions==1|trespass_conditions==3, by(trespass_conditions)
ttest favor if trespass_conditions==2|trespass_conditions==4, by(trespass_conditions)
**DID, female vs. male, co-partisans
ttesti 192  .0180697   .2199092 194 -.0474889   .2245548 , unequal
**Out-Partisans
ttest favor if trespass_conditions==5|trespass_conditions==7, by(trespass_conditions)
ttest favor if trespass_conditions==6|trespass_conditions==8, by(trespass_conditions)
**DID, female vs. male, out-partisans
ttesti 185   .031133 .2245548  185 .0647427 .2457078  , unequal

 
