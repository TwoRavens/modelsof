svyset [pweight=v1001]

*svyset, clear

*Deviators 

svy: mlogit knowdevcap interest educ age woman income pidstrength ptyagdcap white ///
statedum40 statedum36 statedum30 statedum22 statedum3 ///
if knownondevcap!=. &  v5032 != 3 & v5033 != 3, base(0)
est store mod1
*esttab mod1 using "coeff1.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knowdeviraq interest educ age woman income pidstrength ptyagdiraq white ///
statedum3 statedum7 statedum19 statedum24 statedum30 statedum40  ///
if knownondeviraq!=. & v5027 != 3, base(0)
est store mod2
*esttab mod2 using "coeff2.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knowdevcafta interest educ age woman income pidstrength ptyagdcafta white ///
statedum2 statedum9 statedum10 statedum19 statedum27 statedum30 statedum33 ///
statedum38 statedum39 statedum41 statedum42 statedum47 ///
if knownondevcafta!=. & v5034 !=3 & v5035!=3, base(0)
est store mod3
*esttab mod3 using "coeff3.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knowdevimm interest educ age woman income pidstrength ptyid2agdimm white ///
statedum4 statedum14 statedum16-statedum18 statedum23 statedum24 statedum29 statedum31 ///
statedum33 statedum38-statedum41 statedum43 statedum45 statedum46  ///
if knownondevimm!=. & v5029 !=3, base(0)
est store mod4
*esttab mod4 using "coeff4.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knowdevminwage interest educ age woman income pidstrength ptyagdwage white /// 
statedum40 ///
if knownondevminwage!=. & v5030 !=3 & v5030 !=4, base(0)
est store mod5 
*esttab mod5 using "coeff5.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knowdevstem interest educ age woman income pidstrength ptyagdstem white ///
statedum4 statedum16 statedum28 statedum30 statedum31 statedum38-statedum40 statedum46 ///
if knownondevstem!=., base(0)
est store mod6
*esttab mod6 using "coeff6.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knowdevabort interest educ age woman income pidstrength ptyagdabort white ///
statedum30 statedum34 statedum40 statedum47 statedum50 ///
if knownondevabort!=. & v5022 !=3 & v5022 !=4 & v5023 !=3 & v5023 !=4, base(0)
est store mod7
*esttab mod7 using "coeff7.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

*Non deviators 

svy: mlogit knownondevcap interest educ age woman income pidstrength ptyagndcap white ///
statedum40 statedum36 statedum30 statedum22 statedum3 ///
if knowdevcap!=. & v5032 != 3 & v5033 != 3, base(0)
est store mod8
*esttab mod8 using "coeff8.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knownondeviraq interest educ age woman income pidstrength ptyagndiraq white ///
statedum3 statedum7 statedum10 statedum19 statedum24 statedum30  ///
if knowdeviraq!=. & v5027 != 3, base(0)
est store mod9
*esttab mod9 using "coeff9.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knownondevcafta interest educ age woman income pidstrength ptyagndcafta white ///
statedum2 statedum9 statedum10 statedum19 statedum27 statedum30 statedum33 ///
statedum38 statedum39 statedum41 statedum42 statedum47 ///
if knowdevcafta!=. & v5034 !=3 & v5035!=3, base(0)
est store mod10
*esttab mod10 using "coeff10.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knownondevimm interest educ age woman income pidstrength ptyid2atndimm white ///
statedum4 statedum14 statedum16-statedum18 statedum23 statedum24 statedum29 statedum31 ///
statedum33 statedum38-statedum41 statedum43 statedum45 statedum46 ///
if knowdevimm!=. & v5029 !=3, base(0)  
est store mod11
*esttab mod11 using "coeff11.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knownondevminwage interest educ age woman income pidstrength ptyagndwage white ///
statedum40 ///
if knowdevminwage!=. & v5030 !=3 & v5030 !=4, base(0)
est store mod12 
*esttab mod12 using "coeff12.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knownondevstem interest educ  age woman income pidstrength ptyagndstem white ///
statedum4 statedum16 statedum28 statedum30 statedum31 statedum38-statedum40 statedum46 ///
if knowdevstem!=., base(0)
est store mod13
*esttab mod13 using "coeff13.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

svy: mlogit knownondevabort interest educ age woman income pidstrength ptyagndabort white ///
statedum30 statedum34 statedum40 statedum47 statedum50 ///
if knowdevabort!=. & v5022 !=3 & v5022 !=4 & v5023 !=3 & v5023 !=4, base(0)
est store mod14
*esttab mod14 using "coeff14.csv", b(%9.2f) ci label nopar nonotes  nostar ///
*keep(educ interest age woman income pidstrength pty* white) replace 

quietly suest mod1 mod8
lincom [mod8_1]interest-[mod1_1]interest

quietly suest mod2 mod9
lincom [mod9_1]interest-[mod2_1]interest

quietly suest mod3 mod10
lincom [mod10_1]interest-[mod3_1]interest

quietly suest mod4 mod11
lincom [mod11_1]interest-[mod4_1]interest

quietly suest mod5 mod12
lincom [mod12_1]interest-[mod5_1]interest

quietly suest mod6 mod13
lincom [mod13_1]interest-[mod6_1]interest

quietly suest mod7 mod14
lincom [mod14_1]interest-[mod7_1]interest

