** “Beliefs about Corporate America and the Structure of Opinions toward Privatization”
** Mark D. Ramirez and Paul Lewis 
** Verification file for figures and tables 

set more off 

** Load data  
use "RamLew_verify.dta"

** FIGURE 1 (created in R) 
tab trash 
tab highway
tab emt
tab veterans
tab jobs
tab socialservices
tab socialsecurity
tab airport
tab law
tab detention
tab prison_ops
tab military_ops

** Rcode for figure 
trash <- c(4.93, 4.43, 24.97, 30.21, 35.45)
transport <- c(8.45, 7.85, 25.05, 31.29, 27.36)
emt <- c(13.88, 9.05, 22.13, 31.09, 23.84)
vetservices <- c(14.08, 8.85, 23.74, 31.19, 22.13)
jobs <- c(4.61, 5.82, 26.48, 36.41, 26.68)
socialservices <- c(16.62, 10.57, 22.66, 31.72, 18.43)
socialsecurity <- c(28.57, 11.47, 21.73, 18.91, 19.32)
tsa <- c(22.81, 10.05, 22.51, 25.83, 18.79)
privatepolice_support <- c(38.55, 13.86, 15.96, 16.67, 14.96)
detention_support <- c(37.63, 12.98, 21.83, 16, 11.57)
prison_support <- c(28.23, 12.7, 22.18, 22.68, 14.21)
military <- c(42.12, 13.13, 17.47, 17.47, 9.8)

par(mfrow=c(3,4))
barplot(trash, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize trash services", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(transport, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize highway repairs", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(emt, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize emergency care", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(vetservices, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize veterans' healthcare", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(jobs, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize job training", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(socialservices, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize child & family services", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(socialsecurity, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize Social Security", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(tsa, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize airport screening", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(privatepolice_support, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize law enforcement", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(detention_support, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize detention centers", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(prison_support, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize prison operations", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)
barplot(military, main="", col="white", ylim=c(0,50), ylab="percent", xlab="privatize military operations", names=c("never", "", "", "", "always"), cex.lab=1.3, cex.axis=1.3, cex.main=1.3)


** TABLE 1 (STATA)
polychoric trash highway emt veterans jobs socialservices socialsecurity airport law detention prison_ops military_ops
display r(sum_w)
global N=r(sum_w)
matrix r=r(R)
factormat r, n($N) factors(2) 

** TABLE 1 (STATA)
mean trash 
mean highway 
mean emt
mean veterans
mean jobs
mean socialservices
mean socialsecurity
mean airport
mean law
mean detention
mean prison_ops
mean military_ops

** Support for privatization index  
alpha trash highway emt veterans jobs socialsecurity socialservices airport law detention prison_ops military_ops, detail

** TABLE 2 (STATA)
reg privatization zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc public_employee unionhh

** save data as Rdata2017.dta

****************
** RCODE FOR SEM
****************
library(foreign)
library(car)
library(lattice)
library(latticeExtra)
library(RCurl)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(sem) 
library(lavaan)

# LOAD IN THE DATA 
data <- read.dta("Rdata2017.dta")
attach(data)
summary(data)

data[,c("gender","zpid7","zpersonal_income", "znatl_econ", "zideo", "zeduc" )] <-
lapply(data[,c("gender","zpid7","zpersonal_income", "znatl_econ", "zideo", "zeduc")], ordered) 

detach(data)
attach(data)

data$gender = c(0,1)[as.numeric(gender)]
data$zpid7 = c(0,0.1666667, 0.3333333, 0.5000000, 0.6666667, 0.8333333, 1.0000000)[as.numeric(zpid7)]
data$zideo = c(0, .16, .33, .5, .66, .83, 1)[as.numeric(zideo)]
data$zpersonal_income = c(0, .25, .5, .75, 1)[as.numeric(zpersonal_income)]
data$znatl_econ = c(0, .2, .4, .6, .8, 1)[as.numeric(znatl_econ)]
data$zeduc = c(0, .2, .4, .6, .8, 1)[as.numeric(zeduc)]

detach(data)
attach(data)

# outcome model 
model <- '

privatization ~ b1*zcorporate_motivation + b2*zaccountability5 + b3*zcorp_infl5 + c1*zapproval + c2*znatl_econ + c3*zpersonal_income + c4*unemployed + c5*zpid7 + c6*zideo + c7*fiscal_liberalism + c8*gender + c9* zeduc + c11* public_employee + c12* unionhh


# mediator models
zcorporate_motivation ~ d20*zapproval + d1* gender + d3*zeduc + d4*zpersonal_income + d5*public_employee + d6*unionhh + d7*white_collar + d8*investor + d9*ownhome + d10*zpid7 + d11*zideo + d12*fiscal_liberalism + d13*tv_use + d14*newspaper_use + d15 *znatl_econ + d16*unemployed
zcorp_infl5 ~ e20*zapproval+ e1*gender  + e3*zeduc + e4*zpersonal_income + e5*public_employee + e6*unionhh + e7*white_collar + e8*investor + e9*ownhome + e10*zpid7 + e11*zideo + e12*fiscal_liberalism + e13*tv_use + e14*newspaper_use + e15 * znatl_econ + e16*unemployed
zaccountability5 ~ f20*zapproval + f1* gender  + f3*zeduc + f4*zpersonal_income + f5*public_employee + f6*unionhh + f7*white_collar + f8*investor + f9*ownhome + f10*zpid7 + f11*zideo + f12*fiscal_liberalism + f13*tv_use + f14*newspaper_use + f15 * znatl_econ + f16*unemployed


# indirect effects (IDE) Approval
medVar1IDE := d20*b1
medVar2IDE  := e20*b2
medVar3IDE := f20*b3
sumIDE := (d20*b1) + (e20*b2) + (f20*b3)

# indirect effects (IDE)
medVar1IDEPID  := b1*d10
medVar2IDEPID  := b2*e10
medVar3IDEPID := b3*f10
sumIDE := (b1*d10) + (b2*e10) + (b3*f10)

# indirect effects (IDE)
medVar1IDEideo  := b1*d11
medVar2IDEideo  := b2*e11
medVar3IDEideo := b3*f11
sumIDE := (b1*d11) + (b2*e11) + (b3*f11)

# indirect effects (IDE)
medVar1IDEflib  := b1*d12
medVar2IDEflib  := b2*e12
medVar3IDEflib := b3*f12
sumIDE := (b1*d12) + (b2*e12) + (b3*f12)

# indirect effects (IDE)
medVar1IDEpublic  := b1*d5
medVar2IDEpublic  := b2*e5
medVar3IDEpublic := b3*f5
sumIDE := (b1*d5) + (b2*e5) + (b3*f5)

# indirect effects (IDE)
medVar1IDEunion  := b1*d6
medVar2IDEunion  := b2*e6
medVar3IDEunion := b3*f6
sumIDE := (b1*d6) + (b2*e6) + (b3*f6)

# indirect effects (IDE)
medVar1IDEeduc  := b1*d3
medVar2IDEeduc  := b2*e3
medVar3IDEeduc := b3*f3
sumIDE := (b1*d3) + (b2*e3) + (b3*f3)

# indirect effects (IDE)
medVar1IDEpi := b1*d4
medVar2IDEpi  := b2*e4
medVar3IDEpi := b3*f4
sumIDE := (b1*d4) + (b2*e4) + (b3*f4)

# indirect effects (IDE)
medVar1IDEnatlecon := b1*d15
medVar2IDEnatlecon  := b2*e15
medVar3IDEnatlecon := b3*f15
sumIDE := (b1*d15) + (b2*e15) + (b3*f15)

# indirect effects (IDE)
medVar1IDEgender := b1*d1
medVar2IDEgender  := b2*e1
medVar3IDEgender := b3*f1
sumIDE := (b1*d1) + (b2*e1) + (b3*f1)


# indirect effects (IDE)
medVar1IDEunemp := b1*d16
medVar2IDEunemp  := b2*e16
medVar3IDEunemp := b3*f16
sumIDE := (b1*d16) + (b2*e16) + (b3*f16)

# total effect
##total := c1 + c2 + c3 + c4 +c5 +c6 +c7 +c8 +c9 + c11 + c12 + (d1*b1) + 
zcorporate_motivation ~~ zcorp_infl5 # model correlation between mediators
'

fit <- sem(model, data=data)

summary(fit, fit.measures=TRUE, standardize=TRUE, rsquare=TRUE)

boot.fit <- parameterEstimates(fit, boot.ci.type="bca.simple")
boot.fit

# indirect effects (IDE)
#medVar1IDErace := b1*d2
#medVar2IDErace  := b2*e2
#medVar3IDErace := b3*f2
#sumIDE := (b1*d2) + (b2*e2) + (b3*f2)

** CFA
CFA.model <- ' latent =~ corp_infl + corp_motivation  + corp_account + ideo + fiscal_liberalism'
fit <- cfa(CFA.model, data=data)
summary(fit, fit.measures=TRUE)

data[,c("trash","highway","emt", "veterans", "jobs", "socialsecurity", "socialservices", "airport", "law", "detention", "prison_ops", "military_ops" )] <-
lapply(data[,c("trash","highway","emt", "veterans", "jobs", "socialsecurity", "socialservices", "airport", "law", "detention", "prison_ops", "military_ops" )], ordered) 

CFA.model <- ' latent =~ trash + highway + emt + veterans + jobs + socialsecurity + socialservices + airport + law + detention + prison_ops + military_ops'
fit <- cfa(CFA.model, data=data)
summary(fit, fit.measures=TRUE)

CFA.model2 <- 'nc =~ trash + highway + emt + veterans + jobs + socialsecurity + socialservices  
coercive =~ airport + law + detention + prison_ops + military_ops'
fit2 <- cfa(CFA.model2, data=data)
summary(fit2, fit.measures=TRUE)

CFA.model3 <- 'is =~ trash + highway + detention + prison_ops + military_ops + airport  
not =~  emt + law + veterans + jobs + socialsecurity + socialservices'
fit3 <- cfa(CFA.model3, data=data)
summary(fit3, fit.measures=TRUE)
 
** Tables SM17 SM18 SM19
tempfile tf1 tf2 tf3 tf4 tf5 tf6 tf7 tf8 tf9 tf10 tf11 tf12 
parmby "ologit trash zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh", lab saving(`"tf1"', replace) idn(1) ids(Unadjusted)
parmby "ologit highway zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh", lab saving(`"tf2"', replace) idn(1) ids(Unadjusted)
parmby "ologit emt zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh", lab saving(`"tf3"', replace) idn(1) ids(Unadjusted)
parmby "ologit jobs zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh", lab saving(`"tf4"', replace) idn(1) ids(Unadjusted)
parmby "ologit socialservices zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh", lab saving(`"tf5"', replace) idn(1) ids(Unadjusted)
parmby "ologit socialsecurity zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh", lab saving(`"tf6"', replace) idn(1) ids(Unadjusted)
parmby "ologit veterans zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh military", lab saving(`"tf7"', replace) idn(1) ids(Unadjusted)
parmby "ologit law zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh zresentment ", lab saving(`"tf8"', replace) idn(1) ids(Unadjusted)
parmby "ologit airport zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh", lab saving(`"tf9"', replace) idn(1) ids(Unadjusted)
parmby "ologit detention zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh zresentment", lab saving(`"tf10"', replace) idn(1) ids(Unadjusted)
parmby "ologit prison_ops zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh zresentment", lab saving(`"tf11"', replace) idn(1) ids(Unadjusted)
parmby "ologit military_ops zcorporate_motivation zaccountability5 zcorp_infl5 zapproval znatl_econ zpersonal_income unemployed zpid7 zideo fiscal_liberalism gender zeduc white public_employee unionhh military ", lab saving(`"tf12"', replace) idn(1) ids(Unadjusted)
drop _all
append using `"tf1"' `"tf2"' `"tf3"' `"tf4"' `"tf5"' `"tf6"' `"tf7"' `"tf8"' `"tf9"' `"tf10"' `"tf11"' `"tf12"'
list idnum idstr parm estimate min95 max95 p, noobs nodis

multproc, pvalue(p) critical(corrected) nhcred(credibility) method(simes) gpcor(newvarname) gpuncor(newvar2) rank(rank) reject(reject)
smileplot,pv(p) esti(estimate) ptl() me(simes) nline(1)

qqvalue p, method(simes) qvalue(qvalues) npvalue(npvalue) rank(ranknewvar)
  
