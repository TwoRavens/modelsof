* Wayman & Tago (2009) Journal of Peace Research replication do file.
* Please run this after you download the STATA data files on your C: drive.

* For Table II (Left-side)
use "C:\Democide_All_Cases_WaymanTagoJPR081009.dta", clear
stcox interstatewar intrastatewar extrastatewar coups democracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups autocracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups communist military pcenergy, nolog nohr

* For Table II (Right-side)
use "C:\Politicide_All_Cases_WaymanTagoJPR081009.dta", clear
stcox interstatewar intrastatewar extrastatewar coups democracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups autocracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups communist military pcenergy, nolog nohr

* For Table III (Left-side)
use "C:\Democide_Valentino_Cases_WaymanTagoJPR081009.dta", clear
stcox interstatewar intrastatewar extrastatewar coups democracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups autocracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups communist military pcenergy, nolog nohr

* For Table III (Right-side)
use "C:\Politicide_Valentino_Cases_WaymanTagoJPR081009.dta", clear
stcox interstatewar intrastatewar extrastatewar coups democracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups autocracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups communist military pcenergy, nolog nohr

* For Table IV
use "C:\Democide_Over1000_Cases_WaymanTagoJPR081009.dta", clear
stcox interstatewar intrastatewar extrastatewar coups democracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups autocracy pcenergy, nolog nohr
stcox interstatewar intrastatewar extrastatewar coups communist military pcenergy, nolog nohr
