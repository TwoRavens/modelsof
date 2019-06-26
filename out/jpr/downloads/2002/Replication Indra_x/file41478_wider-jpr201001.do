/*Paradise is a Bazaar? paper for wider-jpr special issue using wider-jpr201001.dta */

use wider-jpr201001, clear


/*Probit tests of civil conflict 1989-1999  (Table 1) */

dprobit allwar lninc89 lnpop lnpopden elf elf2 polity3 polity32 prevwar grw8589 lnnat lnnat2 lnssab lnssab2, r

dprobit allwar lninc89 lnpop lnpopden elf elf2 polity3 polity32 prevwar grw8589 lnnat lnnat2 lnssab lnssab2 lntrade, r

dprobit allwar lninc89 lnpop lnpopden elf elf2 polity3 polity32 prevwar grw8589 lnnat lnnat2 lnssab lnssab2 lntrade expoil, r

dprobit allwar lninc89 lnpop lnpopden elf elf2 polity3 polity32 prevwar grw8589 lnnat lnnat2 lnssab lnssab2 lntrade expoil lnrurpd, r

dprobit allwar lninc89 lnpop lnpopden elf elf2 polity3 polity32 prevwar grw8589 lnnat lnnat2 lnssab lnssab2 lntrade expoil lnrurpd nat2rur, r

corr lnpopden lnrurpd



/*Probit tests of civil conflict 1989-1999  (Table 2) */

dprobit allwar lninc89 lnpop lnpopden elf elf2 polity3 polity32 prevwar lntrade expoil christ mus cat, r

dprobit allwar lninc89 lnpop lnpopden elf elf2 polity3 polity32 prevwar lntrade expoil christ mus cat chrismus, r

dprobit allwar lninc89 lnpop lnpopden elf elf2 prevwar lntrade expoil, r 

dprobit allwar lninc89 lnpop lnpopden elf elf2 prevwar expoil, r

exit
