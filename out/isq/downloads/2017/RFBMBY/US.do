** With US Data **
** Table 1 **
tab iraq terror, col row
sort party
by party: tab iraq terror, col row

** Table 2 and Table 4 **
sem (relstrong -> relfeelings) (iraq -> relstrong) (iraq -> relcares) (iraq -> relknow) (iraq -> relmoral) (iraq -> relfeelings) ///
 (iraq -> votebush2) (iraq -> votekerry2) (terror -> relstrong) (terror -> relcares) (terror -> relknow) (terror -> relmoral) ///
 (terror -> relfeelings) (terror -> votebush2) (terror -> votekerry2) (relcares -> relfeelings) (relknow -> relfeelings) ///
 (relmoral -> relfeelings) (relfeelings -> votebush2) (relfeelings -> votekerry2) (democrat -> relstrong) (democrat -> relcares) ///
 (democrat -> relknow) (democrat -> relmoral) (democrat -> relfeelings) (democrat -> votebush2) (democrat -> votekerry2) ///
 (ind -> relstrong) (ind -> relcares) (ind -> relknow) (ind -> relmoral) (ind -> relfeelings) (ind -> votebush2) (ind -> votekerry2) ///
 (economy -> relstrong) (economy -> relcares) (economy -> relknow) (economy -> relmoral) (economy -> relfeelings) (economy -> votebush2) ///
 (economy -> votekerry2) ///
 (relhonest -> relfeelings) (iraq -> relhonest) (terror -> relhonest) (democrat -> relhonest) (ind -> relhonest) (economy -> relhonest), method(adf) ///
 cov( e.relstrong*e.relcares e.relknow*e.relstrong e.relknow*e.relcares e.relknow*e.relmoral e.relmoral*e.relstrong e.relmoral*e.relcares ///
 e.relhonest*e.relcares e.relknow*e.relhonest e.relmoral*e.relhonest e.relstrong*e.relhonest ///
 e.votebush2@0 e.votekerry2@0) nocapslatent
estat gof, stats(all)
estat teffects

** Table 5 **
sem (relstrong -> relfeelings) (iraq -> relstrong) (iraq -> relcares) (iraq -> relknow) (iraq -> relmoral) (iraq -> relfeelings) (iraq -> votebush2) ///
 (iraq -> votekerry2) (terror -> relstrong) (terror -> relcares) (terror -> relknow) (terror -> relmoral) (terror -> relfeelings) (terror -> votebush2) ///
 (terror -> votekerry2) (relcares -> relfeelings) (relknow -> relfeelings) (relmoral -> relfeelings) (relfeelings -> votebush2) (relfeelings -> votekerry2) ///
 (economy -> relstrong) (economy -> relcares) (economy -> relknow) (economy -> relmoral) (economy -> relfeelings) (economy -> votebush2) ///
 (economy -> votekerry2) ///
 (relhonest -> relfeelings) (iraq -> relhonest) (terror -> relhonest) (economy -> relhonest) if party != 0, group(party) method(adf) ///
 cov( e.relstrong*e.relcares e.relknow*e.relstrong e.relknow*e.relcares e.relknow*e.relmoral e.relmoral*e.relstrong e.relmoral*e.relcares ///
 e.relhonest*e.relcares e.relknow*e.relhonest e.relmoral*e.relhonest e.relstrong*e.relhonest ///
 e.votebush2@0 e.votekerry2@0) nocapslatent
 estat gof, stats(all)
estat teffects

** Table 6 **
tab iraq party, col

