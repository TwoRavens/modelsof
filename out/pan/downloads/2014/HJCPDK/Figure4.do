/* Figure 4*/

#delimit;
set mem 5m;
set more off; 

use Figure4a;
merge case using Figure4b;

replace pro = 0 if pro < 0.001;

egen m1 = median(dompar);
egen m2 = median(pro);
egen m2b = median(pro) if pro~=0;

summarize dompar pro m1 m2 m2b;
summarize pro if pro~=0;

/* limit this graph to only cases where pro ~=0 */

graph twoway kdensity dompar, bw(0.03) xlabel(0 0.2 0.4 0.6 0.8) ylabel(0 2 4 6 8) || kdensity pro if pro ~=0, bw(0.03);