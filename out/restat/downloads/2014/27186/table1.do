
/*-----------------------------------------------------------------------------*
				GENERATE THE DATASET FOR THE EMPIRICAL ANALYSIS
*------------------------------------------------------------------------------*/

/* This do-file defines four broad categories of firms: manufacturers, wholesalers, retailers, and a residual group including the remaining sectors. It then computes the total value of exports and the relative share of the four broad categories of firms (Table 1).
*/

cd  "~/work/bergrato_export/data"

foreach j in 2000 2001 2002 2003 2004 2005 2006 2007 {
	use coe`j'sh6_original.dta, clear
	rename codice_i codiceasia
	rename prog_i idcode
	rename paese country
	gen sector= ateco
	destring sector, replace
	replace export=. if export==0
	replace import=. if import==0

	rename sector sector5
	tostring sector5, replace
	replace sector5= sector5+string(0)+string(0)+string(0) if strlen(sector5) ==2
	replace sector5= sector5+string(0)+string(0) if strlen(sector5) ==3
	replace sector5= sector5+string(0) if strlen(sector5) ==4
	gen sector2= substr(sector5,1,2)
	gen sector3= substr(sector5,1,3)
	destring sector2, replace
	destring sector3, replace
	gen str6 hs6 = string(sh6,"%06.0f")
	
**Sector Group
	gen energy=1 if sector2==10 | sector2==11  | sector2==12  | sector2==13  | sector2==14   | sector2==40  | sector2==41
	replace energy= 0 if energy==.
	gen manuf=1 if sector2>=15 & sector2<=37
	replace manuf=0 if manuf==.
	gen constr=1 if  sector2==45
	replace constr=0 if constr==.
	gen whol=1 if sector3==501 | sector3==503 | sector3==504 | sector3==505 | sector2==51 
	replace whol=0 if whol==.
	gen reta=1 if  sector3==521 | sector3==522 | sector3==523 | sector3==524 |sector3==525 | sector3==526   
	replace reta=0 if reta==.
	gen tcu=1 if sector2>=60  & sector2<=64
	replace tcu=0 if tcu==.
	gen fire=1 if sector2==65 | sector2==66 | sector2==67  | sector2==70  | sector2==71  | sector2==72 | sector2==73 | sector2==74
	replace fire=0  if fire==.
	gen otserv=1 if sector3==502 | sector3==527 | sector2==55 | sector2==80 | sector2==85  | sector2==90  | sector2==91  | sector2==92 | sector2==93 | sector2==95 | sector2==96 | sector2==97 | sector2==02
	replace otserv=0  if otserv==.
	gen nosector=1 if sector3==.
	replace nosector=0 if nosector==.
	sort codiceasia
	keep if export!=.
	egen export_i=sum(export), by(codiceasia)
	gen VMUE=export/export_qua
	save coe`j'fcp_exp.dta, replace
	}


foreach j in 2003 {
	display "processing year `j' "
	use coe`j'fcp_exp.dta, replace
	gen sector_group=1 if manuf==1
	replace sector_group=2 if whol==1
	replace sector_group=3 if reta==1
	replace sector_group=4 if (energy==1 | fire==1 | tcu==1 | otserv==1 | constr==1 | nosector==1)
	collapse export_i sector_group, by(codiceasia)
	gen export_status=1 if export_i!=.

*** Table number of firms ***
	display "Number of exporting firms, All obs, year  `j'"
	tab sector_group 
	egen sumexp= sum(export_i), by (sector_group)
	gen sumexp_div=sumexp / 1000000
	collapse sumexp_div,  by(sector_group)
	egen grand_tot = sum(sumexp_div)
	gen share_class=(sumexp_div/grand_tot)*100

*** Table Volume of Export  ***
	display "Share of Export by Whol, All obs, year  `j'"
	list
	}
