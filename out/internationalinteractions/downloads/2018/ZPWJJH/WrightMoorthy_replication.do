******************************
*Wright, Thorin M. and Shweta Moorthy. 2017. "Refugees, Economic Capacity, and Host State Repression." International Interactions
*Replication Script
******************************





*Table 1: Summary Statistics


summarize latent_r if  lnrgdp!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost!=.  , detail

summarize lntotalhost if latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & l.lntotalhost!=. & lnrgdp!=. , detail

summarize lncivhost if latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost!=. & lnrgdp!=. , detail

summarize lnrgdp if latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost!=. & lnrgdp!=. , detail

summarize cie if latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost!=. & lnrgdp!=. , detail

summarize l.lnpop1 if latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost!=. & lnrgdp!=. , detail

summarize civconflict if latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & l.lntotalhost!=. & l.lnrgdp!=. , detail

summarize l.polity2 if latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost!=. & lnrgdp!=. , detail



**Table 2

*refugees above and below +/- 1 SD on GDP 
summarize lntotalhost if lnrgdp>=9.467 & latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost>0 & lntotalhost!=.  , detail
summarize lntotalhost if lnrgdp<=7.047 & latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost>0  & lntotalhost!=. , detail
summarize lntotalhost if lnrgdp>=7.047 & lnrgdp<=9.467 & latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost>0 & lntotalhost!=. , detail

summarize latent_r if lnrgdp<=7.047 & latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost>0 & lntotalhost!=. , detail
summarize latent_r if lnrgdp>=9.467 & latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost>0  & lntotalhost!=. , detail
summarize latent_r if lnrgdp>=7.047 & lnrgdp<=9.467 & latent_r!=. & civconflict!=. & l.lnpop1!=. & l.polity2!=. & lntotalhost>0 & lntotalhost!=. , detail


**Table 3

xtreg latent_r  c.lntotalhost lnrgdp l.lnpop1 civconflict l.polity2 , fe vce (cl ccode)

xtreg latent_r  c.lntotalhost lnrgdp l.lnpop1 civconflict l.polity2 i.year  , fe vce (cl ccode)

xtreg latent_r  c.lntotalhost lnrgdp l.lnpop1 civconflict l.polity2   c.lntotalhost#c.lnrgdp, fe vce (cl ccode)

xtreg latent_r  c.lntotalhost lnrgdp l.lnpop1 civconflict l.polity2   c.lntotalhost#c.lnrgdp i.year, fe vce (cl ccode)

xtreg latent_r  c.lntotalhost  lnrgdp l.lnpop1 civconflict l.polity2   c.cie c.lntotalhost#c.cie , fe vce (cl ccode)

xtreg latent_r  c.lntotalhost  lnrgdp l.lnpop1 civconflict l.polity2   c.cie c.lntotalhost#c.cie i.year , fe vce(cl ccode)

xtreg latent_r  c.lncivhost  lnrgdp l.lnpop1 civconflict l.polity2    c.lncivhost#c.lnrgdp  , fe vce(cl ccode)

xtreg latent_r  c.lncivhost  lnrgdp l.lnpop1 civconflict l.polity2    c.lncivhost#c.lnrgdp i.year, fe vce(cl ccode)

**Figure 1

xtreg latent_r  c.lntotalhost  lnrgdp l.lnpop1 civconflict l.polity2  c.lntotalhost#c.lnrgdp , fe vce(cl ccode)

quietly margins, dydx(c.lntotalhost) at ( c.lnrgdp=(5(0.5)13) civcon=0 ) atmeans noatlegen 

marginsplot

**Figure 2

quietly margins, at (c.lntotalhost =(0.00(1)15) c.lnrgdp=(7.047(2.42)9.467) civcon=0 ) atmeans noatlegen 
marginsplot
