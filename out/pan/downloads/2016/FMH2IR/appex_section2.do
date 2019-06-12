
/* Replication code for Table A2.1 */


use "C:\Users\ls42\Dropbox\google consumer surveys\Replication Materials\Appendix\gender_report.dta", clear


tab gender_report /* distribution of reported gender, including those that refuse to answer. results shown in coloumn 2 
                     under the subheading GCS Sample 2013 in Table A2.1 */

tab gender_report Gender, col /* distribution of inferred gender that matches the reported gender, including those that refuse to answer.
                                  results shown in coloumns 3 ,4, and 6, under the subheading GCS Sample 2013 in Table A2.1 */


tab gender_report if Gender!="Unknown" /* distribution of reported gender (including those that refuse to answer) whose gender was inferred.
                                           results shown in coloumn 5, under the subheading GCS Sample 2013 in Table A2.1  */


capture drop gender_rescale /* rescaled reported gender variable where we remove those that refuse to answer */
gen gender_rescale=gender_report
recode gender_rescale 3=.

tab gender_rescale /* distribution of reported gender, excluding those that refuse to answer. Results shown in coloumn 2 
                      under the subheading Rescaled GCS Sample 2013 in Table A2.1  */

tab gender_rescale Gender, col /* distribution of inferred gender that matches the reported gender, excluding those that refuse to answer. 
                         results shown in coloumns 3,4,and 6 under the subheading Rescaled GCS Sample 2013 in Table A2.1  */


tab gender_rescale if Gender!="Unknown" /* distribution of reported gender (excluding those that refuse to answer) whose gender was inferred.
                                         results shown in coloumn 5 under the subheading Rescaled GCS Sample 2013 in Table A2.1  */



/* Replication code for Table A2.2 */

use "C:\Users\ls42\Dropbox\google consumer surveys\Replication Materials\Appendix\age_report.dta", clear


tab age_report /* distribution of reported age, including those that refuse to answer. results shown in coloumn 2 
                     under the subheading GCS Sample 2013 in Table A2.2 */ 

encode Age, gen(Age1)
recode Age1 4=3 6=5 /* collapse "35-44" & "44-54" categories into "35-54" and "55-64" & "65+" into "55+" */

tab age_report Age1, col /* distribution of inferred age that matches the reported age, including those that refuse to answer    
                            results shown in coloumns 3,4,5,6,7, and 9 under the subheading GCS Sample 2013 in Table A2.2 */


tab age_report if Age1<7 /* distribution of reported age (including those that refuse to answer) whose age was inferred 
                            results shown in coloumn 8 under the subheading GCS Sample 2013 in Table A2.2 */


/* Replication code for Table A2.3 */

use "C:\Users\ls42\Dropbox\google consumer surveys\Replication Materials\Appendix\income_report.dta", clear


tab income_report /* distribution of reported income. results shown in coloumn 2 in Table A2.3 */                 

encode Income, gen(Income1)
recode Income1 3=2  /* collapse "100K-149.999" & "150K+" categories into "100K+" */

tab income_report Income1, col /* distribution of inferred income that matches the reported income. 
                                 results shown in coloumn 3,4,5,6,7, and 9 in Table A2.3 */

tab income_report if Income1<7 /* distribution of reported income whose age was inferred. 
                                  results shown in coloumn 8 in Table A2.3 */
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 











