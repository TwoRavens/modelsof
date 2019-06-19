*this file takes information on grade by subject and cleans the files
*saves all in extract_materias

*as an intermediate step identifies the cedula of individual to be able to merge with fix_repet

clear
set mem 1000m


macro define dir="C:\temp\repeticion"
macro define dir1="C:\temp\repeticion"



capture program drop extract
program define extract



use "$dir\original_data_confidential\concedula\resxal${x}.dta", clear
keep if dep==103
keep dep ced edad
save "$dir\created_data_confidential\tmpold", replace


*takes public files and keeps same school and merges to uncover algorithm
use "$dir\original_data_confidential\sincedula\uso externo resultados por estudiante ${x}.dta", clear
keep if dep==103
merge using "$dir\created_data_confidential\tmpold"
set type float
g a=substr(ced, -9, 7)
g b=substr(ced, -1, 1)
egen newcedula=concat(a b)
destring newcedula , force g(newcedula1)
set type double
g tmp=newcedula1/id
reg newcedula1 id
g tmp1=1

*predict cedula for all those in public file

append using "$dir\original_data_confidential\sincedula\uso externo resultados por estudiante ${x}.dta" 
drop if tmp1==1
drop tmp1
drop edad depend cedula
predict newcedula2
replace newcedula2=round(newcedula2)
format newcedula2 %9.0f
g a1=int(newcedula2/10)
g b1=int(newcedula2-int(newcedula2/10)*10)
g c1="-"
egen newcedula4=concat(a1 c1 b1) 
drop a-c1
drop _m
rename newc cedula
egen group=group(cedula)
egen count=count(group), by(group)
drop if cou>1
drop gr count
sort cedula
saveold "$dir\created_data_confidential\tmp${x}", replace


*takes secret file to check how well merging went
use "$dir\original_data_confidential\concedula\resxal${x}.dta", clear
capture rename curant98 cursoant
keep ced dep edad cursoant sex falt
for any dep edad cursoant sex falt: rename X tmpX
egen group=group(cedula)
egen count=count(group), by(group)
drop if cou>1
drop gr count
g truecedula=cedula
*run "C:\Documents and Settings\Marco\Desktop\uruguay\replacetruecedula.txt"
rename cedula oldcedula
rename truecedula cedula
sort cedula
merge cedula using "$dir\created_data_confidential\tmp${x}"

tab _m 



*replace cedula="" if dep!=tmpdep | dep~=tmpdep

g a=substr(ced, -9, 7)
g b=substr(ced, -1, 1)
g a1=substr(ced, -8, 6)
g a2=substr(ced, -7, 5)
g a3=substr(ced, -6, 4)
g a4=substr(ced, -5, 3)
replace a=a1 if a==""
replace a=a2 if a==""
replace a=a3 if a==""
replace a=a4 if a==""

egen newcedula=concat(a b)
sort newc
egen gr=group(newc) 
egen count=count(gr), by(gr)
drop if cou>1 | cou==0
drop cou gr a1-a4 
drop _m a b tmp*
sort newc


save "$dir\created_data_confidential\tmp${x}", replace
*/


*not takes the file by gustavo where i uncovered the cedula

u "$dir\original_data_confidential\resultados\ResuXAlu19${x}a", replace

rename var2 code
global i=1
while $i<=8 {
g tmp$i=var$i-int(var$i/10)*10
global j=$i+1
g var$j=(var$i-tmp$i)/10
global i=$i+1
}

global i=1
while $i<=8 {
global j=9-$i
rename tmp$i newtmp$j

global i=$i+1
}

order newtmp1 newtmp2 newtmp3 newtmp4 newtmp5 newtmp6 newtmp7 newtmp8

global i=1
while $i<=8 {
g tmp$i=string(newtmp$i)
global i=$i+1
}
g newcedula=tmp1 +tmp2 +tmp3 +tmp4 +tmp5 +tmp6 +tmp7 +tmp8
replace newcedula=tmp2 +tmp3 +tmp4 +tmp5 +tmp6 +tmp7 +tmp8 if tmp1=="0"

sort newc
for any cursoant1 cursoact1 falt sex edad repite repsale promueve promsale sale: rename  X xX

keep newc x* fallo planant notaf matant* notam* fch* tip* not*  
egen gr=group(newc) 
egen count=count(gr), by(gr)
drop if cou>1

sort newc
merge newc using "$dir\created_data_confidential\tmp${x}"	


capture for any 6: rename curant9X cursan9X
capture for any 8: rename curant9X cursan9X
g tmp=1 if cursan${x}=="1"
replace tmp=2 if cursan${x}=="2"
replace tmp=3 if cursan${x}=="3"

keep if tmp==1 | tmp==2 | tmp==3 





tab dep  if _m<3 

#delimit ;
label define fallos 
1	"PROMOVIDO CON"
2	"Repite p/rendim"
3	"Repite p/inasis"
4	"HABILIT.EXS.LIB"
5	"A RECUPERACION"
6	"ATENCION"
7	"INSCRIP. LIBRE";
#delimit cr
label values fallo fallos
	

#delimit cr
label define matant 1 "ASTRONOMIA"
label define matant 2 "BIOLOGIA", modify
label define matant 3 "CONTABILIDAD", modify
label define matant 4 "DIBUJO", modify
label define matant 5 "ED.FISICA", modify
label define matant 6 "ED.MUSICAL", modify
label define matant 7 "ED.SOCIAL", modify
label define matant 8 "FILOSOFIA", modify
label define matant 9 "FISICA", modify
label define matant 10 "FRANCES", modify
label define matant 100 "ASIST.SOCIAL", modify
label define matant 101 "PSICOLOGO", modify
label define matant 102 "HS.APOYO DIR RC", modify
label define matant 103 "OBSERVATORIO", modify
label define matant 104 "SUPLEN.DIREC.", modify
label define matant 105 "SUPLEN.SUBDIR.", modify
label define matant 107 "APOYO LAB", modify
label define matant 108 "FILOS.C SABERES", modify
label define matant 109 "ARTE C.VISUAL", modify
label define matant 11 "GEOGRAFIA", modify
label define matant 110 "CS.TIERRA Y ESP", modify
label define matant 111 "ACT.MUSICALES", modify
label define matant 112 "ACT FIS.DEP.REC", modify
label define matant 113 "COM.PROD.ESC.OR", modify
label define matant 114 "ACT.INFORMATICA", modify
label define matant 115 "GEOG.HUM.Y ECON", modify
label define matant 12 "HISTORIA", modify
label define matant 125 "HIST.ART CULTUR", modify
label define matant 13 "IDIOMA ESPA¤OL", modify
label define matant 134 "LENGUA MATERNA", modify
label define matant 135 "COM.ORAL Y ESC.", modify
label define matant 136 "T.DE ESCRITURA", modify
label define matant 137 "LENGUA DE SE¥AS", modify
label define matant 14 "INGLES", modify
label define matant 15 "ITALIANO", modify
label define matant 16 "LITERATURA", modify
label define matant 164 "LITERATURA PAyA", modify
label define matant 17 "CS.FISICAS", modify
label define matant 171 "DERE Y CIUDANIA", modify
label define matant 172 "INT.INV.CS SOC.", modify
label define matant 173 "DEREC.HUMANOS", modify
label define matant 174 "ED.CIUDADANA", modify
label define matant 18 "MATEMATICA", modify
label define matant 186 "MATEMATICAIV", modify
label define matant 187 "MATEMATICA OP", modify
label define matant 188 "MATEMATICA III", modify
label define matant 189 "MATEMATICA II", modify
label define matant 19 "QUIMICA", modify
label define matant 20 "I.A LA TECNOLOG", modify
label define matant 201 "R.NAT/PAIS.AGR", modify
label define matant 21 "GEOLOGIA", modify
label define matant 22 "ATLETISMO", modify
label define matant 23 "GIMNASIA ESPECI", modify
label define matant 24 "DIRECTOR CORO", modify
label define matant 25 "PIANISTA ACOMP.", modify
label define matant 26 "DIRECCION BANDA", modify
label define matant 27 "COORD.C.FIS-BIO", modify
label define matant 28 "COORD.FI-QUI-BI", modify
label define matant 29 "COORD.HIS-GEO", modify
label define matant 292 "T,EXP.MUSICAL", modify
label define matant 30 "COORD.HI-GE-ES", modify
label define matant 31 "COORD.PILOTO", modify
label define matant 32 "CS.EXPERIMENT.", modify
label define matant 33 "INFORMATICA", modify
label define matant 330 "ADMINISTRACION", modify
label define matant 331 "AULA INFORM 1§C", modify
label define matant 337 "T.INFORMATICA", modify
label define matant 34 "FRANCES", modify
label define matant 35 "I.A LA TECNOL.", modify
label define matant 36 "ACTIV.DOC.RURAL", modify
label define matant 37 "SUPL. ADSCRIP.", modify
label define matant 38 "T.EXPR.OR.Y ESC", modify
label define matant 39 "EXP.VIRTUAL", modify
label define matant 40 "FISIOTERAPEUTA", modify
label define matant 401 "L.COM.Y 1/2 AUD", modify
label define matant 407 "C.V.LAB IMAGEN", modify
label define matant 41 "MEDICO COORD.", modify
label define matant 421 "EST.ECON.Y SOC.", modify
label define matant 43 "EXP.VIS.Y PLAST", modify
label define matant 46 "DIBUJO Y DISE¤O", modify
label define matant 47 "APOYO ADM.RURAL", modify
label define matant 48 "EXP.PLASTICA", modify
label define matant 49 "INTERPRETE", modify
label define matant 52 "P.AR.ZON.ED.FIS", modify
label define matant 520 "COORD.ED.FISICA", modify
label define matant 521 "COORD.E.FIS.ESP", modify
label define matant 53 "COMPENS.AREA 1", modify
label define matant 54 "COMPENS.AREA 2", modify
label define matant 55 "COMPENS.AREA 3", modify
label define matant 56 "COMPENS.AREA 4", modify
label define matant 57 "MEDICO SEG.ASMA", modify
label define matant 58 "COOR.TIEMPO PED", modify
label define matant 59 "SALUD Y DEPORTE", modify
label define matant 606 "TALLER P.MUSIC.", modify
label define matant 607 "MUS.LAB.SONIDO", modify
label define matant 608 "EXP.MUSICAL", modify
label define matant 611 "TALLER DE TEAT.", modify
label define matant 612 "EXP.CORP.Y TEAT", modify
label define matant 62 "ED.SONORA Y MUS", modify
label define matant 621 "EXP.CORP.Y DANZ", modify
label define matant 63 "ACT.RECREATIVA", modify
label define matant 641 "PORTUGUES", modify
label define matant 65 "MATEMATICA A", modify
label define matant 66 "MATEMATICA B", modify
label define matant 67 "MATEMATICA C", modify
label define matant 68 "MANUALIDADES", modify
label define matant 69 "CS. SOCIALES", modify
label define matant 70 "DERECHO", modify
label define matant 709 "SOCIOLOGIA", modify
label define matant 71 "HIST. UNIVERSAL", modify
label define matant 72 "HIST.NAC.Y AMER", modify
label define matant 74 "COSMOGRAFIA", modify
label define matant 75 "BOTANICA", modify
label define matant 76 "ZOOLOGIA", modify
label define matant 77 "TALLER CS.EXP.", modify
label define matant 78 "TALLER CS.SOC.", modify
label define matant 79 "ACT.ADAP.MEDIO", modify
label define matant 80 "ESTUDIOS SOC.", modify
label define matant 804 "C.D LOS SABERES", modify
label define matant 81 "UR.MUNDO ACTUAL", modify
label define matant 82 "T.EXPRES.ARTIST", modify
label define matant 83 "COMUNIC.VISUAL", modify
label define matant 833 "APOYO BIBLIO.RC", modify
label define matant 84 "ADMIN.Y CONTAB.", modify
label define matant 85 "ECONOMIA", modify
label define matant 86 "DER.Y CS.POLIT.", modify
label define matant 866 "APOYO ADS. RC", modify
label define matant 87 "HIST.DEL ARTE", modify
label define matant 88 "MEDICO CERTIF.", modify
label define matant 89 "ADM.Y CONTABIL.", modify
label define matant 90 "FISICA-ARQ", modify
label define matant 900 "DOC.EFEC.DEF.HS", modify
label define matant 901 "C.DE LA NATURA.", modify
label define matant 91 "FORM.CIUDADANA", modify
label define matant 911 "CS.FIS-QUIMICAS", modify
label define matant 92 "CS.BIOLOGICAS", modify
label define matant 93 "TALLER DE ADMIN", modify
label define matant 931 "CS.TIERRA Y AMB", modify
label define matant 94 "ESP.ADOLESCENTE", modify
label define matant 941 "COM.ORAL ESC.OP", modify
label define matant 942 "TEATRO", modify
label define matant 95 "ARTE CONTEMPOR.", modify
label define matant 96 "C.MUNDO ACTUAL", modify
label define matant 962 "TALLER AR.PLAST", modify
label define matant 963 "TALLER P.AUD.AR", modify
label define matant 964 "T.P.AUD.ART.MUS", modify
label define matant 965 "T.P.AUD.ART.DIB", modify
label define matant 96 "URUGUAY S.XX", modify
label define matant 960 "PROYECTOS P.03", modify
label define matant 961 "INFORME PLAN 03", modify
label define matant 98 "EXPRES.Y COMPR.", modify
label define matant 988 "APOYO LABOR.RC", modify
label define matant 99 "ED.MORAL Y CIV.", modify
label define matant 992 "ES CURR.ABIERTO", modify

for any 1 2 3 4 5 6 7 8 9 : rename notamat0X notamatX
for any 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15:destring notamatX, force replace
for any 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15:replace notamatX=. if notamatX>12
for any 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15:order notamatX
for any 1 2 3 4 5 6 7 8 9 : rename notapmat0X notapmatX
for any 1 2 3 4 5 6 7 8 9 : rename tipapmat0X tipapmatX
for any 1 2 3 4 5 6 7 8 9 10 11 12 13 14 :destring notapmatX, force replace
for any 1 2 3 4 5 6 7 8 9 10 11 12 13 14 :replace notapmatX=. if notapmatX>12
for any 1 2 3 4 5 6 7 8 9 10 11 12 13 14 :order notapmatX


for any 1 2 3 4 5 6 7 8 9 : rename matant0X matantX
for any 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15:label values matantX matant

for any 1 2 3 4 5 6 7 8 9 : rename fchapmat0X fchapmatX  
for any 1 2 3 4 5 6 7 8 9 10 11 12  :g dateX=date(fchapmatX , "DMY")
for any  3 4 5  :drop  fchapmatX 
global i =1
while $i<=15 {
g tipomat$i=""
replace tipomat$i="ACT" if matant$i==05
replace tipomat$i="ACT" if matant$i==100
replace tipomat$i="ACT" if matant$i==101
replace tipomat$i="ACT" if matant$i==102
replace tipomat$i="ACT" if matant$i==103
replace tipomat$i="ACT" if matant$i==104
replace tipomat$i="ACT" if matant$i==105
replace tipomat$i="ACT" if matant$i==107
replace tipomat$i="ACT" if matant$i==111
replace tipomat$i="ACT" if matant$i==112
replace tipomat$i="ACT" if matant$i==113
replace tipomat$i="ACT" if matant$i==114
replace tipomat$i="ACT" if matant$i==22
replace tipomat$i="ACT" if matant$i==23
replace tipomat$i="ACT" if matant$i==24
replace tipomat$i="ACT" if matant$i==25
replace tipomat$i="ACT" if matant$i==26
replace tipomat$i="ACT" if matant$i==27
replace tipomat$i="ACT" if matant$i==28
replace tipomat$i="ACT" if matant$i==29
replace tipomat$i="ACT" if matant$i==292
replace tipomat$i="ACT" if matant$i==30
replace tipomat$i="ACT" if matant$i==31
replace tipomat$i="ACT" if matant$i==331
replace tipomat$i="ACT" if matant$i==337
replace tipomat$i="ACT" if matant$i==34
replace tipomat$i="ACT" if matant$i==35
replace tipomat$i="ACT" if matant$i==36
replace tipomat$i="ACT" if matant$i==37
replace tipomat$i="ACT" if matant$i==39
replace tipomat$i="ACT" if matant$i==40
replace tipomat$i="ACT" if matant$i==41
replace tipomat$i="ACT" if matant$i==47
replace tipomat$i="ACT" if matant$i==49
replace tipomat$i="ACT" if matant$i==52
replace tipomat$i="ACT" if matant$i==520
replace tipomat$i="ACT" if matant$i==521
replace tipomat$i="ACT" if matant$i==53
replace tipomat$i="ACT" if matant$i==54
replace tipomat$i="ACT" if matant$i==55
replace tipomat$i="ACT" if matant$i==56
replace tipomat$i="ACT" if matant$i==57
replace tipomat$i="ACT" if matant$i==58
replace tipomat$i="ACT" if matant$i==63
replace tipomat$i="ACT" if matant$i==68
replace tipomat$i="ACT" if matant$i==833
replace tipomat$i="ACT" if matant$i==866
replace tipomat$i="ACT" if matant$i==88
replace tipomat$i="ACT" if matant$i==900
replace tipomat$i="ACT" if matant$i==963
replace tipomat$i="ACT" if matant$i==964
replace tipomat$i="ACT" if matant$i==965
replace tipomat$i="ACT" if matant$i==988
replace tipomat$i="ACT" if matant$i==992
global i=$i+1
}

global i =15
while $i>=1 {
g newnotamat$i=notamat$i
replace newnotamat$i=. if tipomat$i=="ACT"
global i=$i-1
}
egen mnewnota=rmean(newnotamat15-newnotamat1)

format date* %td

drop fc*

keep id fall  notaf matant*        notamat*  newnotamat* mnewnota fal* xedad xsex cursan notapmat* date* tip*  x*
g year=${x}
sort id year
save $dir\created_data_confidential\tmp${x}, replace

end

global x=96
extract
global x=97
extract

global x=98
extract
 


u $dir\created_data_confidential\tmp96, replace
append using $dir\created_data_confidential\tmp97
append using $dir\created_data_confidential\tmp98

g oldfaltas=faltas96 if year==96
replace oldf=falt97 if year==97
replace oldf=falt98 if year==98

drop falt*
sort id year
save  $dir\created_data_confidential\extract_materias, replace

u $dir\created_data_confidential\extract_materias, replace
for any 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 : replace notamatX=. if notamatX<1 | notamatX>12
for any 1 2 3 4 5 6 7 8 9 10 11 12 13 14 : replace notapmatX=. if notapmatX<1 | notapmatX>12


g cursan=cursan96
for any 97 98: replace cursan=cursanX if year==X
encode cursan, g(newcursoant)
replace newcursoant=newcursoant+6

*drop newcur*  

sort id year
save  $dir\created_data_confidential\extract_materias, replace

u  $dir\created_data_confidential\extract_materias, replace

global i=1
while $i<=15 {
g missnotamat$i=notamat$i==. if matant$i!=.
global i=$i+1
}
global i=1
while $i<=15 {
replace missnotamat$i=notamat$i==.  
global i=$i+1
}


for any esp mat geo fis hist lit bio csfis dib edf eng fra ita mus eds qui scexp info expvis son scsoc tallexp tallsoc actad expart ciu bio1 ado mor nat csfisqui fil comp1 comp2 comp3 comp4 comp5 artecont: g notaX=. 

global i=1
while $i<=15 {
replace notabio=notamat$i if matant$i==2
replace notadib=notamat$i if matant$i==4
replace notaedf=notamat$i if matant$i==5
replace notamus=notamat$i if matant$i==6
replace notafis=notamat$i if matant$i==9
replace notafra=notamat$i if matant$i==10
replace notaita=notamat$i if matant$i==15
replace notageo=notamat$i if matant$i==11
replace notahis=notamat$i if matant$i==12
replace notaesp=notamat$i if matant$i==13
replace notaeng=notamat$i if matant$i==14
replace notalit=notamat$i if matant$i==16
replace notacsfis=notamat$i if matant$i==17
replace notamat=notamat$i if matant$i==18

replace notaeds=notamat$i if matant$i==7
replace notaqui=notamat$i if matant$i==19
replace notascexp=notamat$i if matant$i==32
replace notainfo =notamat$i if matant$i==33
replace notaexpvis=notamat$i if matant$i==43
replace notason=notamat$i if matant$i==62
replace notascsoc=notamat$i if matant$i==69
replace notatallexp=notamat$i if matant$i==77
replace notatallsoc=notamat$i if matant$i==78
replace notaact=notamat$i if matant$i==79

replace notaexpart=notamat$i if matant$i==82
replace notaciu=notamat$i if matant$i==91

replace notabio1=notamat$i if matant$i==92
replace notaado=notamat$i if matant$i==94
replace notamor=notamat$i if matant$i==99

replace notanat=notamat$i if matant$i==901
replace notacsfisqui=notamat$i if matant$i==911

replace notafil=notamat$i if matant$i==8
replace notacomp1=notamat$i if matant$i==53
replace notacomp2=notamat$i if matant$i==54
replace notacomp3=notamat$i if matant$i==55
replace notacomp4=notamat$i if matant$i==56
replace notaartecont=notamat$i if matant$i==95

global i=$i+1
}


for any esp mat geo fis hist lit bio csfis dib edf eng fra ita mus eds qui scexp info expvis son scsoc tallexp tallsoc actad expart ciu bio1 ado mor nat csfisqui fil comp1 comp2 comp3 comp4 comp5 artecont: g notapX=. 
global i=1
while $i<=14 {
replace notapbio=notapmat$i if matant$i==2
replace notapdib=notapmat$i if matant$i==4
replace notapedf=notapmat$i if matant$i==5
replace notapmus=notapmat$i if matant$i==6
replace notapfis=notapmat$i if matant$i==9
replace notapfra=notapmat$i if matant$i==10
replace notapita=notapmat$i if matant$i==15
replace notapgeo=notapmat$i if matant$i==11
replace notaphis=notapmat$i if matant$i==12
replace notapesp=notapmat$i if matant$i==13
replace notapeng=notapmat$i if matant$i==14
replace notaplit=notapmat$i if matant$i==16
replace notapcsfis=notapmat$i if matant$i==17
replace notapmat=notapmat$i if matant$i==18

replace notapeds=notapmat$i if matant$i==7
replace notapqui=notapmat$i if matant$i==19
replace notapscexp=notapmat$i if matant$i==32
replace notapinfo =notapmat$i if matant$i==33
replace notapexpvis=notapmat$i if matant$i==43
replace notapson=notapmat$i if matant$i==62
replace notapscsoc=notapmat$i if matant$i==69
replace notaptallexp=notapmat$i if matant$i==77
replace notaptallsoc=notapmat$i if matant$i==78
replace notapact=notapmat$i if matant$i==79

replace notapexpart=notapmat$i if matant$i==82
replace notapciu=notapmat$i if matant$i==91

replace notapbio1=notapmat$i if matant$i==92
replace notapado=notapmat$i if matant$i==94
replace notapmor=notapmat$i if matant$i==99

replace notapnat=notapmat$i if matant$i==901
replace notapcsfisqui=notapmat$i if matant$i==911

replace notapfil=notapmat$i if matant$i==8
replace notapcomp1=notapmat$i if matant$i==53
replace notapcomp2=notapmat$i if matant$i==54
replace notapcomp3=notapmat$i if matant$i==55
replace notapcomp4=notapmat$i if matant$i==56
replace notapartecont=notapmat$i if matant$i==95

global i=$i+1
}


for any esp mat geo fis hist lit bio csfis dib edf eng fra ita mus eds qui scexp info expvis son scsoc tallexp tallsoc actad expart ciu bio1 ado mor nat csfisqui fil comp1 comp2 comp3 comp4 comp5 artecont: g dateX=. 
global i=1
while $i<=11 {
replace datebio=date$i if matant$i==2
replace datedib=date$i if matant$i==4
replace dateedf=date$i if matant$i==5
replace datemus=date$i if matant$i==6
replace datefis=date$i if matant$i==9
replace datefra=date$i if matant$i==10
replace dateita=date$i if matant$i==15
replace dategeo=date$i if matant$i==11
replace datehis=date$i if matant$i==12
replace dateesp=date$i if matant$i==13
replace dateeng=date$i if matant$i==14
replace datelit=date$i if matant$i==16
replace datecsfis=date$i if matant$i==17
replace datemat=date$i if matant$i==18

replace dateeds=date$i if matant$i==7
replace datequi=date$i if matant$i==19
replace datescexp=date$i if matant$i==32
replace dateinfo =date$i if matant$i==33
replace dateexpvis=date$i if matant$i==43
replace dateson=date$i if matant$i==62
replace datescsoc=date$i if matant$i==69
replace datetallexp=date$i if matant$i==77
replace datetallsoc=date$i if matant$i==78
replace dateact=date$i if matant$i==79

replace dateexpart=date$i if matant$i==82
replace dateciu=date$i if matant$i==91

replace datebio1=date$i if matant$i==92
replace dateado=date$i if matant$i==94
replace datemor=date$i if matant$i==99

replace datenat=date$i if matant$i==901
replace datecsfisqui=date$i if matant$i==911

replace datefil=date$i if matant$i==8
replace datecomp1=date$i if matant$i==53
replace datecomp2=date$i if matant$i==54
replace datecomp3=date$i if matant$i==55
replace datecomp4=date$i if matant$i==56
replace dateartecont=date$i if matant$i==95


global i=$i+1
}



for any esp mat geo fis hist lit bio csfis dib edf eng fra ita mus eds qui scexp info expvis son scsoc tallexp tallsoc actad expart ciu bio1 ado mor nat csfisqui: g yearX=year(dateX)
for any esp mat geo fis hist lit bio csfis dib edf eng fra ita mus eds qui scexp info expvis son scsoc tallexp tallsoc actad expart ciu bio1 ado mor nat csfisqui:  g monthX=month(dateX)
for any esp mat geo fis hist lit bio csfis dib edf eng fra ita mus eds qui scexp info expvis son scsoc tallexp tallsoc actad expart ciu bio1 ado mor nat csfisqui: g newnotapX=notapX if year==yearX-1900-1 & monthX<4

for any 1 2 3 4 5 6 7 8 9 10 11: g yearX=year(dateX)
for any 1 2 3 4 5 6 7 8 9 10 11: g monthX=month(dateX)
for any 1 2 3 4 5 6 7 8 9 10 11: g newnotapX=notapmatX if year==yearX-1900-1 & monthX<4



*typical curricula

*7 grade curriculum
*esp mat eng/fra hist geo dib bio csfis edfis (tall cs exp) 

*8 grade curriculum
*esp mat eng/fra hist geo dib bio csfis edfis (tall expr art)
	
*9th grade
*lit mat eng/fra hist geo edsoc edmus bio fis qui edfis (eds tallsoc)

g notaidi=notaeng
replace notaidi=notafra if notaeng==.


egen mnota=rmean(notamat9-notamat1) if newcursoant<=8
egen mnota1=rmean(notamat11-notamat1) if newcursoant==9
replace mnota=mnota1  if newcursoant==9 
drop mnota1



for any 1 2 3 4 5 6 7 8 9 10 11 12: capture drop dummyX
for any 1 2 3 4 5 6 7 8 9 10 11 12: g dummyX=notamatX<6 if notamatX<.

*for any 1 2 3 4 5 6 7 8 9 10 11 12: capture drop dummyX
*for any 1 2 3 4 5 6 7 8 9 10 11 12: g dummyX=notamatX>=6 if notamatX<.



save  $dir\created_data_confidential\extract_materias, replace
