
/* Replication codes for table A7.1. The non-response rate is given by Google */

use "C:\Users\ls42\Dropbox\google consumer surveys\Replication Materials\framing_1qn.dta", clear

tab answer group, col /* this is to calculate the proportion of respondents answering Don't Know by treatment groups
                        for framing (welfare) one question experiment results shown in coloumns 2 and 3, row 2 of TableA7.1  */ 
						  				  

use "C:\Users\ls42\Dropbox\google consumer surveys\Replication Materials\framing_10qn.dta", clear
 
tab Question3Answer group, col /* this is to calculate the proportion of respondents answering Don't Know by treatment groups for 
                                 framing (welfare) ten question experiment. results shown in coloumns 4 and 5, row 2 of Table A7.1 */ 


use "C:\Users\ls42\Dropbox\google consumer surveys\Replication Materials\asian_disease.dta", clear

tab answer group, col /* this is to calculate the proportion of respondents answering Don't Know by treatment groups for asian disease experiment.
                           results shown in coloumns 6 and 7, row 2 of Table A7.1 */ 
