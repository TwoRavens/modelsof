use export.dta, clear

** SECTIONS DEFINITION

sort product
gen chapter="0"
replace chapter=substr(product,1,2) 
gen section=0

replace section=1   if chapter=="01" | chapter=="02"| chapter=="03"| chapter=="04"| chapter=="05"
replace section=2   if chapter=="06" | chapter=="07"| chapter=="08"| chapter=="09"| chapter=="11"| chapter=="12"| chapter=="13"| chapter=="14"
replace section=3   if chapter=="15"
replace section=4   if chapter=="16" | chapter=="17"| chapter=="18"| chapter=="19"| chapter=="20" |chapter=="21" | chapter=="22"| chapter=="23"| chapter=="24" 
replace section=5   if chapter=="25" |chapter=="26" | chapter=="27"
replace section=6   if chapter=="28" |chapter=="29" | chapter=="30"|chapter=="31" | chapter=="32"| chapter=="33"| chapter=="34"| chapter=="35" |chapter=="36" | chapter=="37"| chapter=="38"
replace section=7   if chapter=="39" |chapter=="40" 
replace section=8   if chapter=="41" |chapter=="42" | chapter=="43"
replace section=9   if chapter=="44" |chapter=="45" | chapter=="46"
replace section=10  if chapter=="47" |chapter=="48" | chapter=="49"
replace section=11  if chapter=="50" |chapter=="51" | chapter=="52"| chapter=="53"| chapter=="54"| chapter=="55" |chapter=="56" | chapter=="57"| chapter=="58" |chapter=="59" |chapter=="60"|chapter=="61" | chapter=="62"| chapter=="63"
replace section=12  if chapter=="64"| chapter=="65" |chapter=="66" | chapter=="67"
replace section=13  if chapter=="68"| chapter=="69" |chapter=="70" 
replace section=14  if  chapter=="71"
replace section=15  if chapter=="72"| chapter=="73"| chapter=="74"| chapter=="75" |chapter=="76" | chapter=="77"| chapter=="78"| chapter=="79" |chapter=="80" |chapter=="81"|chapter=="82" | chapter=="83"
replace section=16  if chapter=="84"| chapter=="85"
replace section=17  if chapter=="86"| chapter=="87" |chapter=="88" | chapter=="89"
replace section=18  if chapter=="90"| chapter=="91" |chapter=="92"
replace section=19  if chapter=="93"
replace section=20  if chapter=="94"| chapter=="95" |chapter=="96" | chapter=="97"| chapter=="98"| chapter=="99"

gen heading="0"
replace heading=substr(product,1,4) 
replace product=heading+"00" if section==11 | section==6 | section==15

collapse (sum)   Exportvalue1988 Exportvalue1989 Exportvalue1990 Exportvalue1991 Exportvalue1992 Exportvalue1993 Exportvalue1994 Exportvalue1995 Exportvalue1996 Exportvalue1997 Exportvalue1998 Exportvalue1999 Exportvalue2000 Exportvalue2001 Exportvalue2002 Exportvalue2003 Exportvalue2004 Exportvalue2005 Exportvalue2006 (mean) section, by(reporter product)




foreach i of numlist 1990/2004 {

rename Exportvalue`i' Exportvalue


** STATUT

local j1 = `i' - 1
local j2 = `i' - 2
gen Pre= (Exportvalue`j1'+ Exportvalue`j2')

local k1 =`i' + 1
local k2 =`i' + 2
gen Post= (Exportvalue`k1'+ Exportvalue`k2')


gen Status=1
replace Status=2 if Pre==0 &  Exportvalue~=0 & Exportvalue`k1'~=0 & Exportvalue`k2'~=0 
replace Status=3 if Pre~=0
replace Status=3 if Pre==0 &  Exportvalue~=0 & Post~=0 & Status ~= 2
label var Status "1=non exported / 2=new exports / 3=trad exports"
drop Pre Post


rename  Exportvalue ExportvalueA
replace ExportvalueA = 0 if Status==1

ren ExportvalueA Exportvalue`i'
ren Status Status`i'


** section shares

gen new=0
replace new=1 if  Status`i'==2
gen old=0
replace old=1 if new==0

egen Nold=sum(old), by(reporter section)
egen Vold=sum(Exportvalue`i'*old), by(reporter section)

egen Noldtot=sum(old), by(reporter)
egen Voldtot=sum(Exportvalue`i'*old), by(reporter)

replace Vold=Vold/Voldtot
replace Nold=Nold/Noldtot

drop Voldtot  Noldtot new old 

ren Vold Vold`i' 
ren Nold Nold`i' 
compress
}

collapse  Vold1990 Vold1991 Vold1992 Vold1993 Vold1994 Vold1995 Vold1996 Vold1997 Vold1998 Vold1999 Vold2000 Vold2001 Vold2002 Vold2003 Vold2004 Nold1990 Nold1991 Nold1992 Nold1993 Nold1994 Nold1995 Nold1996 Nold1997 Nold1998 Nold1999 Nold2000 Nold2001 Nold2002 Nold2003 Nold2004 , by(reporter section)
reshape long Vold Nold, i(reporter section) j(year)
sort reporter year
save SectionRatioModif.dta
