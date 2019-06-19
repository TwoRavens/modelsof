clear
capture log close
cd "$root"

log using "JPP/brazspil/logs/%stata/%1setup/rais-data-clean.log", replace

* READ-IN 1-PERCENT RANDOM SAMPLE OF RAIS WORKER DATA
insheet using "rais/draws/natl/wid-draw-workers-natl.csv"
count

* KEEP ONLY WORKERS WITH VALID WORKER ID NUMBERS
drop if wid<2517

* RESETTING SEPARATION MONTH
replace mes_deslig = 13 if mes_deslig==0

* WITHIN-YEAR JOB TURNOVER: KEEP LAST JOB PER YEAR
* IF MORE THAN ONE, KEEP HIGHEST-PAYING JOB
sort wid ano mes_deslig rem_media
by wid ano: keep if _n==_N

order wid ano mes_deslig rem_media
sort wid ano mes_deslig rem_media

* MAPPING OF NESTED VARIABLES (_tc for time consistency)
gen tipo_vinc_tc = tipo_vinc
replace tipo_vinc_tc = 1 if tipo_vinc==10
replace tipo_vinc_tc = 1 if tipo_vinc==15
replace tipo_vinc_tc = 1 if tipo_vinc==20
replace tipo_vinc_tc = 1 if tipo_vinc==25
replace tipo_vinc_tc = 2 if tipo_vinc==30
replace tipo_vinc_tc = 2 if tipo_vinc==35
replace tipo_vinc_tc = 3 if tipo_vinc==40
replace tipo_vinc_tc = 4 if tipo_vinc==50
replace tipo_vinc_tc = 4 if tipo_vinc==55
replace tipo_vinc_tc = 4 if tipo_vinc==60
replace tipo_vinc_tc = 4 if tipo_vinc==65
replace tipo_vinc_tc = 4 if tipo_vinc==70
replace tipo_vinc_tc = 4 if tipo_vinc==75
replace tipo_vinc_tc = 5 if tipo_vinc==80
replace tipo_vinc_tc = 5 if tipo_vinc==90
replace tipo_vinc_tc = 5 if tipo_vinc==95
qui count if tipo_vinc_tc > 5
if `r(N)' > 0  STOP
replace tipo_vinc=. if tipo_vinc==-1

gen caus_desl_tc = caus_desl
replace caus_desl_tc = 1 if caus_desl==10
replace caus_desl_tc = 2 if caus_desl==11
replace caus_desl_tc = 5 if caus_desl==12
replace caus_desl_tc = 3 if caus_desl==20
replace caus_desl_tc = 4 if caus_desl==21
replace caus_desl_tc = 6 if caus_desl==30
replace caus_desl_tc = 6 if caus_desl==31
replace caus_desl_tc = -1 if caus_desl==40
replace caus_desl_tc = 7 if caus_desl==50
replace caus_desl_tc = 8 if caus_desl==60
replace caus_desl_tc = 8 if caus_desl==62
replace caus_desl_tc = 8 if caus_desl==64
replace caus_desl_tc = 7 if caus_desl==70
replace caus_desl_tc = 7 if caus_desl==71
replace caus_desl_tc = 7 if caus_desl==72
replace caus_desl_tc = 7 if caus_desl==73
replace caus_desl_tc = 7 if caus_desl==74
replace caus_desl_tc = 7 if caus_desl==75
replace caus_desl_tc = 7 if caus_desl==76
replace caus_desl_tc = 7 if caus_desl==78
replace caus_desl_tc = 7 if caus_desl==79
replace caus_desl_tc = 9 if caus_desl==80
replace caus_desl_tc = 9 if caus_desl==90
qui count if caus_desl_tc > 9
if `r(N)' > 0  STOP
replace caus_desl=. if caus_desl==-1

replace fx_etaria = -1 if fx_etaria==. & idade== -1
replace fx_etaria = 1 if fx_etaria==. & idade>=10 & idade<=14
replace fx_etaria = 2 if fx_etaria==. & idade>=15 & idade<=17
replace fx_etaria = 3 if fx_etaria==. & idade>=18 & idade<=24
replace fx_etaria = 4 if fx_etaria==. & idade>=25 & idade<=29
replace fx_etaria = 5 if fx_etaria==. & idade>=30 & idade<=39
replace fx_etaria = 6 if fx_etaria==. & idade>=40 & idade<=49
replace fx_etaria = 7 if fx_etaria==. & idade>=50 & idade<=64
replace fx_etaria = 8 if fx_etaria==. & idade>=65
replace idade=. if idade==-1

* MAPPING OF LIKE-NESTED VARIABLES
gen nacionalidad_tc = nacionalidad
replace nacionalidad_tc = 21 if nacionalidad>=22 & nacionalidad<=25
replace nacionalidad_tc = 31 if nacionalidad==32 | nacionalidad==37 | nacionalidad==38
replace nacionalidad_tc = 42 if nacionalidad==43
replace nacionalidad_tc = 21 if nacionalidad==48
replace nacionalidad_tc = 42 if nacionalidad==49
replace nacionalidad_tc = 34 if nacionalidad==50
replace nacionalidad=. if nacionalidad==-1

* MAPPING OF STRINGS TO NUMERIC VARIABLES
gen byte _subs_ibge = .
replace _subs_ibge = 26 if subs_ibge=="OUTR/IGN"
replace _subs_ibge =  1 if subs_ibge=="EXTR MINERA"
replace _subs_ibge =  2 if subs_ibge=="MIN NAO MET"
replace _subs_ibge =  3 if subs_ibge=="IND METALUR"
replace _subs_ibge =  4 if subs_ibge=="IND MECANIC"
replace _subs_ibge =  5 if subs_ibge=="ELET E COMU"
replace _subs_ibge =  6 if subs_ibge=="MAT TRANSP"
replace _subs_ibge =  7 if subs_ibge=="MAD E MOBIL"
replace _subs_ibge =  8 if subs_ibge=="PAPEL E GRA"
replace _subs_ibge =  9 if subs_ibge=="BOR FUM COU"
replace _subs_ibge = 10 if subs_ibge=="IND QUIMICA"
replace _subs_ibge = 11 if subs_ibge=="IND TEXTIL"
replace _subs_ibge = 12 if subs_ibge=="IND CALCADO"
replace _subs_ibge = 13 if subs_ibge=="ALIM E BEB"
replace _subs_ibge = 14 if subs_ibge=="SER UTIL PU"
replace _subs_ibge = 15 if subs_ibge=="CONSTR CIVI"
replace _subs_ibge = 16 if subs_ibge=="COM VAREJ"
replace _subs_ibge = 17 if subs_ibge=="COM ATACAD"
replace _subs_ibge = 18 if subs_ibge=="INST FINANC"
replace _subs_ibge = 19 if subs_ibge=="ADM TEC PRO"
replace _subs_ibge = 20 if subs_ibge=="TRAN E COMU"
replace _subs_ibge = 21 if subs_ibge=="ALOJ COMUNI"
replace _subs_ibge = 22 if subs_ibge=="MED ODON VE"
replace _subs_ibge = 23 if subs_ibge=="ENSINO"
replace _subs_ibge = 24 if subs_ibge=="ADM PUBLICA"
replace _subs_ibge = 25 if subs_ibge=="AGRICULTURA"
qui count if _subs_ibge == .
if `r(N)'>0  STOP
drop subs_ibge
rename _subs_ibge subs_ibge

sort grupo_base
merge grupo_base using "rais/cbo/grupo2cbo.dta"
drop if _m==2
drop _m
rename cbogrp cbobasegrp
sort cbobasegrp
merge cbobasegrp using "rais/cbo/cbogrp2occagg.dta"
drop if _m==2
drop _m
rename cbobasegrp cbogrp

* WAGE AND TENURE VARIABLE RESETTING
foreach var in rem_media rem_med__r__ rem_dezembro rem_dez__r__ temp_empr {
  replace `var' = subinstr(`var',".","",.)
  replace `var' = subinstr(`var',",",".",.)
  gen _`var' = real(`var')
  drop `var'
  rename _`var' `var'
  }

* RESET MISSING INFORMATION FOR REMAINING VARIABLES
foreach var in ano municipio identificad mes_adm mes_deslig clas_cnae_95 nat_estb nat_jurid tipo_estbl emp_em_31_12 temp_empr horas_contr tipo_vinc sit_vinculo tipo_adm caus_desl fx_etaria idade grau_instr sexo nacionalidad tipo_vinc_tc caus_desl_tc nacionalidad_tc subs_ibge cbogrp {
  replace `var' = . if `var'==-1
  }
replace clas_cnae_95 = . if clas_cnae_95==0

* VARIABLE NAME LABELS
label var wid "Worker ID (running number)"
label var ano "Calendar year"
label var identificad "Plant ID (CGC/CNPJ, firm&plant)"
label var mes_adm "Month of accession"
label var mes_deslig "Month of separation"
label var rem_media "Mean monthly wage (minim. wages)"
label var rem_med__r__ "Mean monthly wage (reais)"
label var rem_dezembro "December wage (minim. wages)"
label var rem_dez__r__ "December wage (reais)"
label var municipio "Municipality of plant"
label var subs_ibge "Sector (IBGE, cf. 2-digit SIC)"
label var emp_em_31_12 "Indic.: Employment Dec 31"
label var tipo_vinc "Contractual status (var. def.)"
label var tipo_vinc_tc "Contractual status"
label var caus_desl "Cause of separation (var. def.)"
label var caus_desl_tc "Cause of separation"
label var cbogrp "CBO occupation (3-digit level)"
label var grau_instr "Schooling"
label var sexo "Gender"
label var nacionalidad "Nationality (varying def.)"
label var nacionalidad_tc "Nationality"
label var temp_empr "Tenure at plant (in months)"
label var tipo_estbl "Registration status of plant"
label var tipo_adm "Type of accession"
label var fx_etaria "Employee age range"
label var idade "Employee age"
label var horas_contr "Contracted hours per week"
label var clas_cnae_95 "Sector (CNAE, like 4-digit SIC)"
label var sit_vinculo "Status of employment"
label var nat_estb "UNKNOWN VARIABLE"
label var nat_jurid "Legal form"
label var file "SAS file in /base-wid"
label var grupo_base "CBO occupation (3-digit level)"
* label var radic_cnpj "Firm ID (CGC/CNPJ)"

* VARIABLE FORMATS AND LABELS
format tipo_estbl emp_em_31_12 sit_vinculo tipo_adm fx_etaria grau_instr sexo %1.0f
format mes_adm mes_deslig horas_contr tipo_vinc tipo_vinc_tc caus_desl caus_desl_tc idade nacionalidad nacionalidad_tc subs_ibge nat_estb %2.0f
format cbogrp %3.0f
format temp_empr %3.0g
format ano nat_jurid %4.0f
format clas_cnae_95 %5.0f
format municipio %6.0f
format wid %14.0f 
format identificad %14.0f
foreach pair in "sex sexo" "school grau_instr" "natvinc tipo_vinc" "causaresc caus_desl" "nation nacionalidad" "agerange fx_etaria" "tipoadm tipo_adm" "tipoest tipo_estbl" "nat_jurid nat_jurid" "natvinc tipo_vinc_tc" "causaresc caus_desl_tc" "nation nacionalidad_tc" "subs_ibge subs_ibge" "clas_cnae_95 clas_cnae_95" "cbogrp cbogrp" {
  tokenize `pair'
  local 2 = subinstr("`2'","_tc","",.)
  * rename `2' `1'
  local lblfile = substr(substr("`2'",index("`2'","_")+1,length("`2'")),1,8)
  capture qui do "rais/auxil/`lblfile'.do"
  capture qui do "rais/cnae/`lblfile'.do"
  capture qui do "rais/cbo/`lblfile'.do"
  * label values `1' `lblfile'
  label values `2' `lblfile'
  capture label values `2'_tc `lblfile'
  }

* CHANGE CATEGORICAL VARIABLE TO BINARY INDICATORS
* AGE INDICATORS
 gen byte indchild = (fx_etaria==1)
 label var indchild "Child (10-14y.)"
 gen byte indyouth = (fx_etaria==2)
 label var indyouth "Youth (15-17y.)"
 gen byte indadol = (fx_etaria==3)
 label var indadol "Adolescent (18-24y.)"
 gen byte indnasc = (fx_etaria==4)
 label var indnasc "Nascent Career (25-29y.)"
 gen byte indearly = (fx_etaria==5)
 label var indearly "Early Career (30-39y.)"
 gen byte indpeak = (fx_etaria==6)
 label var indpeak  "Peak Career (40-49y.)"
 gen byte indlate = (fx_etaria==7)
 label var indlate  "Late Career (50-64y.)"
 gen byte indretir = (fx_etaria==8)
 label var indretir "Post Retirement Age (65y.-)"
 drop fx_etaria
 replace indchild=. if indchild==0 & indyouth==0 & indadol==0 & indnasc==0 & indearly==0 & indpeak==0 & indlate==0 & indretir==0
 replace indyouth=. if indchild==.
 replace indadol=. if indchild==.
 replace indnasc=. if indchild==.
 replace indearly=. if indchild==.
 replace indpeak=. if indchild==.
 replace indlate=. if indchild==.
 replace indretir=. if indchild==.

* EDUCATION INDICATORS
 gen byte indprim = (grau_instr==1 | grau_instr==2 | grau_instr==3 | grau_instr==4 | grau_instr==5)
 label var indprim "Primary or Middle School Educ."
 gen byte indhigh = (grau_instr==6 | grau_instr==7)
 label var indhigh "High School Education"
 gen byte indgrad = (grau_instr==8 | grau_instr==9)
 label var indgrad "Complete College Education"
 drop grau_instr
 replace indprim=. if indprim==0 & indhigh==0 & indgrad==0
 replace indhigh=. if indprim==.
 replace indgrad=. if indprim==.

* GENDER INDICATORS
 gen byte indfem = (sexo==2) 
 label var indfem "Female"
 drop sexo
* BRAZILIAN INDICATOR
 gen byte indbraz = (nacionalidad_tc==10)
 label var indbraz "Brazilian"
 drop nacionalidad nacionalidad_tc
* CONTRACT INDICATOR
 gen byte indprjob = (tipo_vinc_tc~=2)
 label var indprjob "Private-sector contract"
*drop tipo_vinc_tc
* OCCUPATION INDICATORS (BASED ON 3-DIGIT CBO; see rais/cbo/cbogrp2occagg.csv)
 gen byte indprof = (occagg==1 | occagg==2)
 label var indprof "Professional or Managerial Occ."
 gen byte indwhit = (occagg==3)
 label var indwhit "Other White Collar Occupation"
 gen byte indsklb = (occagg==4)
 label var indsklb "Skilled Blue Collar Occupation"
 gen byte indunsklb = (occagg==5)
 label var indunsklb "Unskilled Blue Collar Occupation"
 drop cbogrp occagg
 replace indprof=. if indprof==0 & indwhit==0 & indsklb==0 & indunsklb==0
 replace indwhit=. if indprof==.
 replace indsklb=. if indprof==.
 replace indunsklb=. if indprof==.
* PRIVATE OWNERSHIP INDICATOR
 gen byte indprown = (nat_jurid==2000 | nat_jurid>=2046)
 label var indprown "Privately owned firm"
* FDI INDICATOR
 gen byte indfdi = (nat_jurid==2178)
 label var indfdi "Foreign-owned plant"
 drop nat_jurid
* TRANSFER INDICATOR
 gen byte indtrsf = (tipo_adm==3 | tipo_adm==4)
 label var indtrsf "Transfer by employer"
 drop tipo_adm

* KEEP ONLY PRIME AGE WORKERS
drop if indchild==1
drop if indretir==1
drop indchild indretir

* KEEP ONLY WORKERS WITH POSITIVE WAGES
keep if rem_media>0

* KEEP ONLY WORKERS IN PRIVATE SECTOR JOBS
keep if indprjob==1
drop indprjob

* KEEP ONLY FULL-TIME CONTRACT WORKERS
keep if tipo_vinc_tc==1

* GENERATE FIRM-ID
gen double firmid=int(identificad/1000000)
format firmid %10.0g

sort wid ano municipio
order wid ano municipio identificad subs_ibge
save "JPP/brazspil/data/rais-draw-natl.dta", replace
count

* GENERATE AVERAGE ANNUAL WAGE VARIABLE
* Deflated Average Minimum Wage in Brazilian Reais
use "rais/auxil/minwage.dta"
keep day saldfl
gen ano = year(day)
gen month = month(day)
keep if month==12  
keep if ano>=1986 & ano<=2001
rename saldfl minwage
drop day month
sort ano
compress
save "JPP/brazspil/auxil/minwage.dta", replace 

use "JPP/brazspil/data/rais-draw-natl.dta"
sort ano
merge ano using "JPP/brazspil/auxil/minwage.dta"
tab _merge
drop _merge

* Generate wage variable
gen mthwk = 12 if mes_adm==0 & mes_deslig==13
replace mthwk = mes_deslig if mes_adm==0 & mes_deslig~=13
replace mthwk = (mes_deslig-mes_adm) if mes_adm~=0 & mes_deslig==13
replace mthwk = (mes_deslig-mes_adm+1) if mes_adm~=0 & mes_deslig~=13

* Average Monthly Minimum Wage in Reais*Average Monthly Wage in Minimum Wages*Months Worked in Year
gen wage = minwage*rem_media*mthwk
label var wage "Average Annual Wages"
gen lnwage = ln(wage)
label var lnwage "Log Average Annual Wages"
drop minwage
sort wid ano municipio
order wid ano municipio identificad subs_ibge
save "JPP/brazspil/data/rais-draw-natl.dta", replace
count

* Basic Summary Statistics
sum

* Year Statistics
tab ano

* Worker Statistics
* Number of Workers
preserve
keep wid
duplicates drop
count
* Retention of Workers
restore, preserve
keep wid ano
duplicates drop
duplicates tag wid, gen(tag)
tab tag
drop tag

* Firm Statistics
* Number of Firms
restore, preserve
keep firmid
duplicates drop
count
* Retention of Firms
restore, preserve
keep firmid ano
duplicates drop
duplicates tag firmid, gen(tag)
tab tag
drop tag

* Plant Statistics
* Number of Plants
restore, preserve
keep identificad
duplicates drop
count
* Retention of Plants
restore, preserve
keep identificad ano
duplicates drop
duplicates tag identificad, gen(tag)
tab tag
drop tag

log close