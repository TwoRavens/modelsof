----table 1

forvalues i = 1(1)8 {
display "t=`i'"
tab mass_suc if member2==2 & t==`i' & leadership==0 & group2==0
tab mass_suc if member2==2 & t==`i' & leadership==0 & group2==1
}

keep group2 mass_suc
gen mass_suc2= mass_suc
replace mass_suc=. if group2==1
replace mass_suc2=. if group2==0
prtest mass_suc= mass_suc2



---table 2 and figure 1
 probit mass_suc i.group2   i.prov i.town if member2==2,robust cl(vcode)
 
 probit mass_suc i.group2##c.leaderdec_ratio_leader i.prov i.town if member2==2,robust cl(vcode)
 sum  leaderdec_ratio_leader if e(sample)
 quietly margins r.group2, at( leaderdec_ratio_leader=(0(0.05)0.9))
 marginsplot,yline(0) level(95)
 
 probit mass_suc i.group2   i.lag_masssum i.prov i.town if member2==2,robust cl(vcode)
 
 
 
 
 --table 3
glm   leaderdec_ratio i.group2 i.prov i.town  if leadership==1, link(logit) robust cl(vcode)

glm   leaderdec_ratio i.group2 l.leaderdec_ratio i.lag_masssum  i.prov i.town  if leadership==1, link(logit) robust cl(vcode)

glm   leaderdec_ratio i.group2 l.leaderdec_ratio i.lag_masssum i.gender age edu  i.prov i.town  if leadership==1, link(logit) robust cl(vcode)

glm leaderdec_ratio i.group2 l.leaderdec_ratio i.lag_masssum i.gender age edu  i.prov i.town t if leadership==1, link(logit) robust cl(vcode)


---table 4

forvalues i = 1(1)8 {
display "----t=`i'"
sum  leaderdec_ratio if member2==1 & t==`i' & leadership==1 & group2==0
sum  leaderdec_ratio if member2==1 & t==`i' & leadership==1 & group2==1
}

forvalues i = 1(1)8 {
display "--------t=`i'"
sum  leaderincome_ratio if member2==1 & t==`i' & leadership==1 & group2==0
sum  leaderincome_ratio if member2==1 & t==`i' & leadership==1 & group2==1
}

---Figure 2
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==1 & member2==2 & group2==1,xline(2 3)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==2 & member2==2 & group2==1,xline(4 7)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==3 & member2==2 & group2==1,xline(6 7)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==4 & member2==2 & group2==1,xline(4 8)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==5 & member2==2 & group2==1,xline(2 4 5 8)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==6 & member2==2 & group2==1,xline(7 8)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==7 & member2==2 & group2==1,xline(4 5)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==8 & member2==2 & group2==0,xline(4 8)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==8 & member2==2 & group2==1,xline(4 5 6)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==10 & member2==2 & group2==0,xline(5 8)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==10 & member2==2 & group2==1,xline(2 5)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==11 & member2==2 & group2==0,xline(4)
twoway (connected leaderdec_ratio period,mlabel(masssum)) if vcode==13 & member2==2 & group2==1,xline(2 3 4 7)

---table 5

probit massdec i.group2 i.lag_masssuc##c.leaderdec_ratio_leader age gender i.prov i.town if leadership==0,r cl(vcode)

probit massdec i.group2 i.lag_masssuc##c.leaderdec_ratio_leader age gender i.prov i.town if  leadership==0 & masstype_new2==2 ,r cl(vcode)

probit massdec i.group2 i.lag_masssuc##c.leaderdec_ratio_leader age gender i.prov i.town if   masstype_new2==1|masstype_new2==3|masstype_new2==4,r cl(vcode)

---table 6

ttest leaderdec_ratio_leader if (massdec_cat3==2| massdec_cat3==3)& masstype_new2==2,by(massdec_cat3)
ttest leaderdec_a1p1 if leadership==0 ,by(sk)

---table 7
ttest leaderdec_a1max if  n==1 & (masstype_new2==1 | masstype_new2==3),by(cat_max)
ttest leaderdec_a1max if  n==1,by(cat_max)

----table 8
 oprobit masssum i.group2 leaderdec_ratio_leader i.lag_masssuc    i.prov i.town if leadership==0 & member2==2,  robust cl(vcode)
 oprobit masssum i.group2 leaderdec_ratio_leader i.lag_masssum   i.prov i.town if leadership==0 & member2==2,  robust cl(vcode)
 
 
 ----table 9
  probit mass_suc i.group2 c.leaderdec_ratio_leader##i.lag_masssum i.prov i.town if member2==2,robust cl(vcode)



