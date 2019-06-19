*****************************
*Generate Summary Statistics*
*****************************


clear all

use sumstats

estpost summarize ma ec a f b mr fi h wb, listwise

esttab using sumstats.tex, cells("mean") nomtitle nonumber replace
