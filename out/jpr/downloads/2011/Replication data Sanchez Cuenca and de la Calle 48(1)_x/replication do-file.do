/* .do File to produce Tables II-IV results from replication data set */

use dtv_1_2009 ,clear

/* Table #II */

tab status ideology if violencetype==2, col

/* Table #III */

tab selectivity ideology if violencetype==2, col

/* Table #IV */

tab strategy ideology if violencetype==2, col


********************************************************************************************************

