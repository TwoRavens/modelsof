global x "$masterpath/datafiles/"

! gunzip -c  ${x}prices/sic87_3-man7090.dta.gz > ${x}prices/sic87_3-man7090.dta
use ${x}sic87_3-man7090, clear
! rm ${x}prices/sic87_3-man7090.dta
