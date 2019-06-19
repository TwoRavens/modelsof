
set mem 1200m

use Cr_Peer


drop if year==2007

drop if grade==3

iis schyr


xi: xtreg read read_1 gread black hisp lunch gblack ghisp glunch i.grade if gread_2~=. & gread_1~=., fe 
outreg using `direc'/tab2.txt, ctitle(OLS/contemp) title("Exogenous peer effects") bdec(4) coefastr se bracket 3aster rdec(4) addnote("", "Run at $S_TIME, $S_DATE", Using data from $S_FN, "anexog.do") replace

xi: xtreg read read_1 gread_2 black hisp lunch gblack ghisp glunch i.grade if gread_1~=., fe 
outreg using `direc'/tab2.txt, ctitle(OLS/2-lag/va) bdec(4) coefastr se bracket 3aster rdec(4) append

xi: xtreg read read_1 black hisp lunch gblack ghisp glunch i.grade if gread_2~=. & gread_1~=., fe 
outreg using `direc'/tab2.txt, ctitle(OLS/RF) bdec(4) coefastr se bracket 3aster rdec(4) append


