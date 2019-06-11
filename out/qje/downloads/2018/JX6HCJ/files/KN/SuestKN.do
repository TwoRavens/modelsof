
****************************************
****************************************


use DatKN, clear

*Table 2

global i = 1

foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		reg `Y' award `specification' if treatment !=2, 
		estimates store M$i
		global i = $i + 1
		}
	}

suest M1 M2 M3 M4, cluster(session1)
test award
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

drop _all
svmat double F
save results/SuestKN, replace


