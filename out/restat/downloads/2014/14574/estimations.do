capture clear
capture log close
clear matrix
set mem 200m
set matsize 3000
set maxvar 10000
set more off


* Indicate the path to the main file 
cd "F:\cle\Regulation des secteurs en amont\Bourlès et al. 2010\Nos publications\Restat\Programs and data"



use base.dta, replace

* Dummies

gen str2 indu=industry
gen indn=real(indu)
drop indu
egen id=group(cou)
gen ctyind=id*100+indn
gen idtime=id*10000+time
gen indtime=indn*10000+time



xtset ctyind time





* The benchmark specification use tfp3

gen ltfp=ln(tfp3)
gen dltfp=d.ltfp
gen dfront=dfronttfp3
gen gap=l.gaptfp3
gen countryfront=countryfronttfp3

* The upstream regulations effects are lagged

gen reg=l.regimpact_us

* We define the common sample

gen ech=1 if dltfp!=. & dfront!=. & gap!=. & reg!=. & countryfront!=1 & time>1984



* The variables are centered arround the sample average

sum gap if ech==1, detail
gen gap_m=0.4721035
replace gap=gap-gap_m
sum reg if ech==1, detail
gen reg_m=0.1454465
replace reg=reg-reg_m

* Crossing of gap and reg

gen gap_reg=gap*reg

* Variable labels

label var  dltfp "Dependant variable : Growth in Total Factor Productivity"
label var dfront "Change in TFP in the technology leader"
label var gap "Gap in TFP levels (lagged 1 year)"
label var reg "Indirect service market regulations (lagged 1 year)"
label var gap_reg "Effect of Gap on the regulation impact (lagged 1 year)"








***** Table 1: Main estimation results ******


xi : reg dltfp dfront gap reg i.indn i.idtime if countryfront!=1 & time>1984, vce(cluster indn)
outreg dfront gap reg using Table_1.xls, bdec(3) coefastr se bracket 3aster noni nocons replace
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1984 , vce(cluster indn)
outreg dfront gap reg gap_reg using Table_1.xls, bdec(3) coefastr se bracket 3aster noni nocons append
n test reg=gap_reg=0
n test gap=reg=gap_reg=0

gen p1=1 if time<1995
replace p1=0 if p1==.
gen i_p1=id*p1
gen i_np1=id*(1-p1)
gen ind_p1=indn*p1
gen dfront_p1=dfront*p1
gen dfront_np1=dfront*(1-p1)
gen gap_p1=gap*p1
gen gap_np1=gap*(1-p1)
gen reg_p1=reg*p1
gen reg_np1=reg*(1-p1)
gen gap_reg_p1=gap_reg*p1
gen gap_reg_np1=gap_reg*(1-p1)
xi : reg dltfp dfront_p1 gap_p1 reg_p1 gap_reg_p1 dfront_np1 gap_np1 reg_np1 gap_reg_np1 i.i_p1 i.indn i.ind_p1 i.idtime if countryfront!=1 & time>1984, vce(cluster indn)
outreg dfront_p1 gap_p1 reg_p1 gap_reg_p1 dfront_np1 gap_np1 reg_np1 gap_reg_np1 using Table_1.xls, bdec(3) coefastr se bracket 3aster noni nocons append
n test reg_p1=gap_reg_p1=0
n test reg_np1=gap_reg_np1=0
n test gap_p1=reg_p1=gap_reg_p1=0
n test gap_np1=reg_np1=gap_reg_np1=0
n test (gap_p1=gap_np1)(reg_p1=reg_np1)(gap_reg_p1=gap_reg_np1), m





****************** Table A2-1: Estimation on a moving 15 year time period window **************


gen num=0
gen num2=0
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1984 
outreg dfront gap reg gap_reg using Table_A2_1.xls, bdec(3) coefastr se bracket 3aster noni nocons replace
forvalues i=0(1) 8 {
replace num=1984+`i'
replace num2=2000+`i'
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>num & time<num2
outreg dfront gap reg gap_reg using Table_A2_1.xls, bdec(3) coefastr se bracket 3aster noni nocons append
}




**************** Table A2-2: One country is alternatively dropped *********************


xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_2.xls, bdec(3) coefastr se bracket 3aster noni nocons replace
foreach x in AUS AUT BEL CAN DEU DNK ESP FIN FRA GRC ITA NLD NOR SWE USA {
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 & cou!="`x'"
outreg dfront gap reg gap_reg using Table_A2_2.xls, bdec(3) coefastr se bracket 3aster noni nocons append
}



**************** Table A2-3: One industry is alternatively dropped *********************


xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_3.xls, bdec(3) coefastr se bracket 3aster noni nocons replace
foreach x in 15-16 17-19 20 21-22 23-25 26 27-28 29 30-33 34-35 36-37 40-41 45 50-52 55 60-63 64 65-67 70 71-74 {
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 & industry!="`x'"
outreg dfront gap reg gap_reg using Table_A2_3.xls, bdec(3) coefastr se bracket 3aster noni nocons append
}



***************** Table A2-4: Sensibility to the input-output matrix *********************


xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_4.xls, bdec(3) ctitle("US table") addnote("(1) In this estimation the US data are droped") /*
*/coefastr se bracket 3aster noni nocons replace
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 & cou!="USA"
outreg dfront gap reg gap_reg using Table_A2_4.xls, bdec(3) ctitle("US table (1)") coefastr se bracket 3aster noni nocons append
replace reg=dom-reg_m
replace gap_reg=gap*reg
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_4.xls, bdec(3) ctitle("Domestic tables") coefastr se bracket 3aster noni nocons append
replace reg=gbr-reg_m
replace gap_reg=gap*reg
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_4.xls, bdec(3) ctitle("UK table") coefastr se bracket 3aster noni nocons append
replace reg=fra-reg_m
replace gap_reg=gap*reg
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_4.xls, bdec(3) ctitle("France table") coefastr se bracket 3aster noni nocons append



******************* Table A2-5: Direct effects of regulations ******************


* Changes on the direct indicators

gen dir=l.direct
replace dir=0 if dir==.
egen dir_m=mean(dir) if ech==1
gen dir_gap=(dir-dir_m)*gap

gen tarif=l.tarif_dir
replace tarif=0 if tarif==.
egen tarif_m=mean(tarif) if ech==1
gen tarif_gap=(tarif-tarif_m)*gap

gen fdi=l.FDI_dir
replace fdi=0 if fdi==.
egen fdi_m=mean(fdi) if ech==1
gen fdi_gap=(fdi-fdi_m)*gap


* Estimations

xi : areg dltfp dfront gap reg gap_reg i.indn if countryfront!=1 & time>1994, absorb(idtime)
outreg dfront gap reg gap_reg using Table_A2_5.xls, bdec(3) coefastr se bracket 3aster noni nocons replace
xi : areg dltfp dfront gap reg gap_reg dir dir_gap i.indn if countryfront!=1 & time>1994, absorb(idtime)
outreg dfront gap reg gap_reg dir dir_gap using Table_A2_5.xls, bdec(3) coefastr se bracket 3aster noni nocons append
xi : areg dltfp dfront gap reg gap_reg tarif tarif_gap i.indn if countryfront!=1 & time>1994, absorb(idtime)
outreg dfront gap reg gap_reg tarif tarif_gap using Table_A2_5.xls, bdec(3) coefastr se bracket 3aster noni nocons append
xi : areg dltfp dfront gap reg gap_reg fdi fdi_gap i.indn if countryfront!=1 & time>1994, absorb(idtime)
outreg dfront gap reg gap_reg fdi fdi_gap using Table_A2_5.xls, bdec(3) coefastr se bracket 3aster noni nocons append
xi : areg dltfp dfront gap reg gap_reg dir dir_gap tarif tarif_gap fdi fdi_gap i.indn if countryfront!=1 & time>1994, absorb(idtime)
outreg dfront gap reg gap_reg dir dir_gap tarif tarif_gap fdi fdi_gap using Table_A2_5.xls, bdec(3) coefastr se bracket 3aster noni nocons append



******************* Table A2-6: Estimations without the 6 upstream industries ******************


gen up=1 if industry=="40-41" | industry=="50-52" | industry=="60-63" | industry=="64" | industry=="65-67" | industry=="71-74"

xi : areg dltfp dfront gap reg gap_reg i.indn if countryfront!=1 & time>1984, absorb(idtime)
outreg dfront gap reg gap_reg using Table_A2_6.xls, bdec(3) coefastr se bracket 3aster noni nocons replace
xi : areg dltfp dfront gap reg gap_reg i.indn if countryfront!=1 & time>1984 & up!=1, absorb(idtime)
outreg dfront gap reg gap_reg using Table_A2_6.xls, bdec(3) coefastr se bracket 3aster noni nocons append
xi : areg dltfp dfront gap reg gap_reg i.indn if countryfront!=1 & time>1994, absorb(idtime)
outreg dfront gap reg gap_reg using Table_A2_6.xls, bdec(3) coefastr se bracket 3aster noni nocons append
xi : areg dltfp dfront gap reg gap_reg i.indn if countryfront!=1 & time>1994 & up!=1, absorb(idtime)
outreg dfront gap reg gap_reg using Table_A2_6.xls, bdec(3) coefastr se bracket 3aster noni nocons append




******************* Table A2-7: Sensibility to the price measurment of the ouput of 'electrical and optical equipment' (30-33) ******************


xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_7.xls, bdec(3) coefastr se bracket 3aster noni nocons replace
gen x=1 if cou=="USA" & industry=="30-33"
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 & x!=1
outreg dfront gap reg gap_reg using Table_A2_7.xls, bdec(3) coefastr se bracket 3aster noni nocons append

* The following modifications to the calculations of the output price in the program 'database' (in the 'Productivity calculation' part) are required before to append the regressions
* No modification of US output price (therefore drop the vap0 step)
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_7.xls, bdec(3) coefastr se bracket 3aster noni nocons append
* US 30-33 relative price is used for all countries
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_7.xls, bdec(3) coefastr se bracket 3aster noni nocons append




******************* Table A2-8: MFP measurment ******************


replace ltfp=ln(tfp1)
replace dltfp=d.ltfp
replace dfront=dfronttfp1
egen gap_mtfp1=mean(gaptfp1) if ech==1 & time>1994 
replace gap=l.gaptfp1-gap_mtfp1
replace gap_reg=gap*reg
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfronttfp1!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_8.xls, bdec(3) coefastr se bracket 3aster noni nocons replace

replace ltfp=ln(tfp2)
replace dltfp=d.ltfp
replace dfront=dfronttfp2
egen gap_mtfp2=mean(gaptfp2) if ech==1 & time>1994 
replace gap=l.gaptfp2-gap_mtfp2
replace gap_reg=gap*reg
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfronttfp2!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_8.xls, bdec(3) coefastr se bracket 3aster noni nocons append

replace ltfp=ln(tfpus)
replace dltfp=d.ltfp
replace dfront=dfronttfpus
egen gap_mtfpus=mean(gaptfpus) if ech==1 & time>1994 
replace gap=l.gaptfpus-gap_mtfpus
replace gap_reg=gap*reg
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfronttfpus!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_8.xls, bdec(3) coefastr se bracket 3aster noni nocons append

replace ltfp=ln(tfpus2)
replace dltfp=d.ltfp
replace dfront=dfronttfpus2
egen gap_mtfpus2=mean(gaptfpus2) if ech==1 & time>1994 
replace gap=l.gaptfpus2-gap_mtfpus2
replace gap_reg=gap*reg
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfronttfpus2!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_8.xls, bdec(3) coefastr se bracket 3aster noni nocons append



******************* Table A2-9: Productivity measurment ******************


gen lLP=ln(LP)
gen dlLP=d.lLP
gen lk=ln(k)
gen dlk=d.lk

* We define the common sample
gen echLP=1 if dlLP!=. & dfrontLP!=. & countryfrontLP!=1 & l.gapLP!=. & l.regimpact_us!=. & time>1994

* The variable gapLP is centered
egen gap_LP_m=mean(gapLP) if echLP==1
replace gap_LP_m=-0.5803055
gen gapLP_reg=(l.gapLP-gap_LP_m)*reg


* Estimations

xi : reg dlLP dfront gap reg gap_reg dlk i.indn i.idtime if  ech==1 & echLP==1
outreg dfront gap reg gap_reg dlk using Table_A2_9.xls, bdec(3) coefastr se bracket 3aster noni nocons replace
replace dfront=dfrontLP
xi : reg dlLP dfront gap reg gap_reg dlk i.indn i.idtime if  ech==1 & echLP==1
outreg dfront gap reg gap_reg dlk using Table_A2_9.xls, bdec(3) coefastr se bracket 3aster noni nocons append
replace gap=l.gapLP
replace gap_reg=gapLP_reg
xi : reg dlLP dfront gap reg gap_reg dlk i.indn i.idtime if  ech==1 & echLP==1
outreg dfront gap reg gap_reg dlk using Table_A2_9.xls, bdec(3) coefastr se bracket 3aster noni nocons append
xi : reg dlLP dfront gap reg gap_reg i.indn i.idtime if  ech==1 & echLP==1
outreg dfront gap reg gap_reg using Table_A2_9.xls, bdec(3) coefastr se bracket 3aster noni nocons append
xi : reg dlLP dfront gap reg gap_reg i.indn i.idtime if echLP==1
outreg dfront gap reg gap_reg using Table_A2_9.xls, bdec(3) coefastr se bracket 3aster noni nocons append




******************* Table A2-10: Sensibility to the PPP ******************


xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1984 
outreg dfront gap reg gap_reg using Table_A2_10.xls, bdec(3) coefastr se bracket 3aster noni nocons replace
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_10.xls, bdec(3) coefastr se bracket 3aster noni nocons append

* The following modifications to the calculations of MFP in the program 'database' (in the 'Productivity calculation' part) are required before to append the regressions
* Replace ppp_gdp by ppa (wich is at the industry level
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1984 
outreg dfront gap reg gap_reg using Table_A2_10.xls, bdec(3) coefastr se bracket 3aster noni nocons append
xi : reg dltfp dfront gap reg gap_reg i.indn i.idtime if countryfront!=1 & time>1994 
outreg dfront gap reg gap_reg using Table_A2_10.xls, bdec(3) coefastr se bracket 3aster noni nocons append

























exit
