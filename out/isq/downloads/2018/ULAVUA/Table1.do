* The commands below allow you to generate the information in Table 1.    *
* One has to sum up manually the dyadclaim numbers when tabbed to get the *
* number of all dyads (86, 67, 23), non-rival claim dyads (68, 62, 18),   *
* and rival claim dyads (27, 13, 8).                                      * 

sort issue
by issue: tab ddyadidclaim2 if year>1900 /*this generates first line of info in table 1: 86 67 23 */
tab midissyr issue if year>1900 /*this generates line 2 info: 115 60 5 */
tab icowfatal issue if year>1900 /*this generates line 3 info: 25 2 0 */
by issue: tab ddyadidclaim2 if year>1900&thomriva==0 /*this generates line 4 info: 68 62 18 */
by issue: tab ddyadidclaim2 if year>1900&thomriva==0&midissyr==1 /*this generates line 5 info: 21 47 4 */
by issue: tab ddyadidclaim2 if year>1900&thomriva==0&icowfatal==1 /*this generates line 6 info: 2 1 0 */
by issue: tab ddyadidclaim2 if year>1900&thomriva==0 /*this generates line 7 info: 27 13 8 */
by issue: tab ddyadidclaim2 if year>1900&thomriva==1&midissyr==1 /*this generates line 8 info: 94 13 1 */
by issue: tab ddyadidclaim2 if year>1900&thomriva==1&icowfatal==1 /*this generates line 9 info: 23 1 0 */
