
cd "C:\Users\Will\Dropbox\Will\Papers\Jennings & Wlezien - MIP & Preferences\PSRM\R1\Replication Files\"


** UNITED STATES **

use US_MIPPrefs.dta, clear

tsset year
gen lprefs=.
gen dspend=.
gen dspend1=.
gen lspend=.
gen spend=.
gen dummy=.
gen counterC=.
gen lmip=.
gen mip=.
gen lprefsmip=.

ipolate prefs_03a year, gen(iprefs_03a)
ipolate prefs_03b year, gen(iprefs_03b)
ipolate prefs_06 year, gen(iprefs_06)
ipolate prefs_07 year, gen(iprefs_07)
ipolate prefs_10a year, gen(iprefs_10a)
ipolate prefs_10b year, gen(iprefs_10b)
ipolate prefs_12 year, gen(iprefs_12)
ipolate prefs_13a year, gen(iprefs_13a)
ipolate prefs_13b year, gen(iprefs_13b)
ipolate prefs_14 year, gen(iprefs_14)
ipolate prefs_16 year, gen(iprefs_16)
ipolate prefs_17 year, gen(iprefs_17)
ipolate prefs_19 year, gen(iprefs_19)
ipolate prefs_21 year, gen(iprefs_21)

save US_MIPPrefs_regs.dta, replace

**************************************************************************************************************

*TABLE 3: REGRESSIONS OF SPENDING-MIP/PREFERENCES, WELFARE 
use US_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_13b
replace dspend=D.sp2_13
replace dspend1=D.sp1_13
replace lspend=L.sp2_13
replace lmip=L.mipshare_13
replace mip=mipshare_13
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend1 lprefs govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lmip govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lprefs lmip govt3 govt4 if tin(1974,2006), beta
dwstat

*TABLES 4 & 5: REGRESSIONS OF SPENDING-MIP/PREFERENCES, BY DOMAIN

**DEFENCE 
use US_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_16
replace dspend=D.sp2_16
replace dspend1=D.sp1_16
replace lspend=L.sp2_16
replace lmip=L.mipshare_16
replace mip=mipshare_16
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend1 lprefs govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lmip govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lprefs lmip govt3 govt4 if tin(1974,2006), beta
dwstat

**HEALTH 
use US_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_03a
replace dspend=D.sp2_03
replace dspend1=D.sp1_03
replace lspend=L.sp2_03
replace lmip=L.mipshare_03
replace mip=mipshare_03
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend1 lprefs govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lmip govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lprefs lmip govt3 govt4 if tin(1974,2006), beta
dwstat

**EDUCATION 
use US_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_06
replace dspend=D.sp2_06
replace dspend1=D.sp1_06
replace lspend=L.sp2_06
replace lmip=L.mipshare_06
replace mip=mipshare_06
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend1 lprefs govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lmip govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lprefs lmip govt3 govt4 if tin(1974,2006), beta
dwstat

**ENVIRONMENT 
use US_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_07
replace dspend=D.sp2_07
replace dspend1=D.sp1_07
replace lspend=L.sp2_07
replace lmip=L.mipshare_07
replace mip=mipshare_07
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend1 lprefs govt3 govt4 year77 if tin(1974,2006), beta
dwstat
regress dspend1 lmip govt3 govt4 year77 if tin(1974,2006), beta
dwstat
regress dspend1 lprefs lmip govt3 govt4 year77 if tin(1974,2006), beta
dwstat

**CITIES 
use US_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_14
replace dspend=D.sp2_14
replace dspend1=D.sp1_14
replace lspend=L.sp2_14
replace lmip=L.mipshare_14
replace mip=mipshare_14
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend1 lprefs govt3 govt4 year77 L.year77 if tin(1974,2006), beta
dwstat
regress dspend1 lmip govt3 govt4 year77 L.year77 if tin(1974,2006), beta
dwstat
regress dspend1 lprefs lmip govt3 govt4 year77 L.year77 if tin(1974,2006), beta
dwstat

**CRIME 
use US_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_12
replace dspend=D.sp2_12
replace dspend1=D.sp1_12
replace lspend=L.sp2_12
replace lmip=L.mipshare_12
replace mip=mipshare_12
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend1 lprefs govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lmip govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lprefs lmip govt3 govt4 if tin(1974,2006), beta
dwstat

**FOREIGN AID 
use US_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_19
replace dspend=D.sp2_19
replace dspend1=D.sp1_19
replace lspend=L.sp2_19
replace lmip=L.mipshare_19
replace mip=mipshare_19
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend1 lprefs govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lmip govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lprefs lmip govt3 govt4 if tin(1974,2006), beta
dwstat

**SPACE 
use US_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_17
replace dspend=D.sp2_17
replace dspend1=D.sp1_17
replace lspend=L.sp2_17
replace lmip=L.mipshare_17
replace mip=mipshare_17
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend1 lprefs govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lmip govt3 govt4 if tin(1974,2006), beta
dwstat
regress dspend1 lprefs lmip govt3 govt4 if tin(1974,2006), beta
dwstat

**************************************************************************************************************

** UNITED KINGDOM **

use UK_MIPPrefs.dta, clear

tsset year
gen lprefs=.
gen dspend=.
gen dspend1=.
gen lspend=.
gen spend=.
gen dummy=.
gen counterC=.
gen lmip=.
gen mip=.
gen lprefsmip=.
gen unempC=.

ipolate prefs_03 year, gen(iprefs_03)
ipolate prefs_06 year, gen(iprefs_06)
ipolate prefs_10 year, gen(iprefs_10)
ipolate prefs_13 year, gen(iprefs_13)
ipolate prefs_16 year, gen(iprefs_16)

save UK_MIPPrefs_regs.dta, replace

**************************************************************************************************************


*TABLES 6: REGRESSIONS OF SPENDING-MIP/PREFERENCES, BY DOMAIN

estimates clear

**DEFENSE
use UK_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_16
replace dspend=D.sp_16
replace lspend=L.sp_16
replace lmip=L.mipshare_16
replace mip=mipshare_16
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
regress dspend lprefs lspend govt3 if tin(1977,1996), beta
estat durbinalt, small
regress dspend lmip lspend govt3 if tin(1977,1996), beta
estat durbinalt, small
regress dspend lprefs lmip lspend govt3 if tin(1977,1996), beta
estat durbinalt, small
regress dspend lprefs lmip lprefsmip lspend govt3 if tin(1977,1996), beta
estat durbinalt, small

**HEALTH
use UK_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_03
replace dspend=D.sp_03
replace lspend=L.sp_03
replace lmip=L.mipshare_03
replace mip=mipshare_03
replace lprefsmip=lprefs*lmip
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
su unemp if dummy==1
replace unempC=unemp-r(min)
regress dspend lprefs lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small
regress dspend lmip lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small
regress dspend lprefs lmip lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small
regress dspend lprefs lmip lprefsmip lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small

**EDUCATION
use UK_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_06
replace dspend=D.sp_06
replace lspend=L.sp_06
replace lmip=L.mipshare_06
replace lprefsmip=lprefs*lmip
replace mip=mipshare_06
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
su unemp if dummy==1
replace unempC=unemp-r(min)
regress dspend lprefs lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small
regress dspend lmip lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small
regress dspend lprefs lmip lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small
regress dspend lprefs lmip lprefsmip lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small

**PENSIONS
use UK_MIPPrefs_regs.dta, clear
replace lprefs=L.iprefs_13
replace dspend=D.sp_13
replace lspend=L.sp_13
replace lmip=L.mipshare_13
replace lprefsmip=lprefs*lmip
replace mip=mipshare_13
replace dummy=.
replace dummy=1 if lprefs~=. & dspend~=.
su lprefs if dummy==1
scalar pr_ave=r(mean)
scalar pr_sd=r(sd)
scalar pr_min=r(min)
scalar pr_max=r(max)
replace lprefs=lprefs-r(mean)
su dspend if dummy==1
scalar sp_ave=r(mean)
scalar sp_sd=r(sd)
scalar sp_min=r(min)
scalar sp_max=r(max)
replace dspend=dspend-r(mean)
replace spend=F.lspend
su spend if dummy==1
scalar splev_ave=r(mean)
su counter if dummy==1
replace counterC=counter-r(min)
su unemp if dummy==1
replace unempC=unemp-r(min)
regress dspend lprefs lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small
regress dspend lmip lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small
regress dspend lprefs lmip lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small
regress dspend lprefs lmip lprefsmip lspend govt3 unempC if tin(1977,1996), beta
estat durbinalt, small

