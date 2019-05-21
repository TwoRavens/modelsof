** Do Social Rights Affect Social Outcomes?
** Christian Bjornskov and Jacob Mchangama
** Table 1
** Descriptive statistics
sum healthright healthright_jur educationright educationright_jur safetyright safetyright_jur lifeexpectancyatbirthtotalyears agedependencyratiooldofworkingag polityiv bl_avyearschool  gini_net gini_market lngdp dlngdp lnpop cg  openc  communist  postcommunist

** Table 2, full results, upper panel
** Column 1
xtregar   dlife l.lifeexpectancyatbirthtotalyears dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dhealthright l.healthright p60-p109 , re 
**Column 2
xtregar   dlife l.lifeexpectancyatbirthtotalyears dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dhealthright l.healthright p60-p109 if rgdpch<14000, re 
** Column 3
xtregar   dgininet l.gini_net dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsafetyright l.safetyright p60-p109, re
** Column 4
xtregar   dgininet l.gini_net dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsafetyright l.safetyright p60-p109 if rgdpch <14000, re
** Table 2, bottom panel
* Column 1
xtregar   dlife l.lifeexpectancyatbirthtotalyears dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  djurhealth l.healthright_jur p60-p109 , re 
**Column 2
xtregar   dlife l.lifeexpectancyatbirthtotalyears dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  djurhealth l.healthright_jur p60-p109 if rgdpch<14000, re 
** Column 3
xtregar   dgininet l.gini_net dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc dsafetyright_jur l.safetyright_jur  p60-p109, re
** Column 4
xtregar   dgininet l.gini_net dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc dsafetyright_jur l.safetyright_jur  p60-p109 if rgdpch <14000, re


** Table 3, full results, upper panel
** Column 1
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5health l.l.l.l.l.healthright p60-p109, re
** Column 2
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5health l.l.l.l.l.healthright p60-p109 if rgdpch <14000, re
** Column 3
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 , re
** Column 4
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 if rgdpch<14000, re
** Column 5
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight l.l.l.l.l.safetyright p60-p109, re
** Column 6
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight l.l.l.l.l.safetyright p60-p109 if rgdpch <14000, re
** Table 3, bottom panel
** Column 1
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5healthjur l.l.l.l.l.healthright_jur p60-p109, re
** Column 2
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5healthjur l.l.l.l.l.healthright_jur p60-p109 if rgdpch <14000, re
** Column 3
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 , re
** Column 4
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 if rgdpch<14000, re
** Column 5
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5safeur l.l.l.l.l.safetyright_jur p60-p109, re
** Column 6
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5safeur l.l.l.l.l.safetyright_jur p60-p109 if rgdpch <14000, re

** Table 4
** Column 1
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5health l.l.l.l.l.healthright years15health p60-p109, re
** Column 2
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5health l.l.l.l.l.healthright years15health p60-p109 if rgdpch <14000, re
** Column 3
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright years15edu p60-p109 , re
** Column 4
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright years15edu p60-p109 if rgdpch<14000, re
** Column 5
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight l.l.l.l.l.safetyright years15safety p60-p109, re
** Column 6
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight l.l.l.l.l.safetyright years15safety p60-p109 if rgdpch <14000, re

** Table 5 Side effects, full results, upper panel
** Government expenditures
xtregar  dcg l.cg dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright l.sumrights p60-p109 , re
xtregar   d5cg l.l.l.l.l.cg  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright l.l.l.l.l.sumrights p60-p109 , re
** Inflation
xtregar  dinflation l.inflation_ppp dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright l.sumrights p60-p109 , re
xtregar   d5inflation l.l.l.l.l.inflation_ppp d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright l.l.l.l.l.sumrights p60-p109 , re
** Legal quality
xtreg  d5legal l.l.l.l.l.legalquality d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright l.l.l.l.l.sumrights  p60-p109 if  d5legal!=., re
** Table 5, bottom panel
** Government expenditures
xtregar  dcg l.cg dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright_jur l.sumrights_jur p60-p109 , re
xtregar   d5cg l.l.l.l.l.cg  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright_jur l.l.l.l.l.sumrights_jur p60-p109 , re
** Inflation
xtregar  dinflation l.inflation_ppp dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright_jur l.sumrights_jur p60-p109 , re
xtregar   d5inflation l.l.l.l.l.inflation_ppp d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright_jur l.l.l.l.l.sumrights_jur p60-p109 , re
** Legal quality
xtreg  d5legal l.l.l.l.l.legalquality d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright_jur l.l.l.l.l.sumrights_jur  p60-p109 if  d5legal!=., re


** Appendix results
** Table A1, full results, upper panel
** Immunization
xtregar   dimaver l.im_average dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dhealthright l.healthright p60-p109 , re
** Market ginis
xtregar   dginimark l.gini_mark dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsafetyright l.safetyright p60-p109, re
** Table A1, bottom panel
xtregar   dimaver l.im_average dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc djurhealth l.healthright_jur p60-p109 , re
** Market ginis
xtregar   dginimark l.gini_mark dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc dsafetyright_jur l.safetyright_jur p60-p109, re

** Table A2, full results, upper panel
** Immunization
xtregar   d5imaverage l.l.l.l.l.im_average d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5health l.l.l.l.l.healthright p60-p109, re
** Child mortality
xtreg  d5under5 l.l.l.l.l.under5mortality  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight l.l.l.l.l.safetyright p60-p109 if rgdpch <14000, re
xtreg  d5under5 l.l.l.l.l.under5mortality  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight l.l.l.l.l.safetyright p60-p109 if rgdpch <14000, re
** Market ginis
xtregar   d5ginimark l.l.l.l.l.gini_mark  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight l.l.l.l.l.safetyright p60-p109 if rgdpch <14000, re
** Table A2, bottom panel
** Immunization
xtregar   d5imaverage l.l.l.l.l.im_average d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5healthjur l.l.l.l.l.healthright_jur p60-p109, re
** Child mortality
xtreg  d5under5 l.l.l.l.l.under5mortality  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5healthjur l.l.l.l.l.healthright_jur p60-p109 if rgdpch <14000, re
xtreg  d5under5 l.l.l.l.l.under5mortality  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5safeur l.l.l.l.l.safetyright_jur p60-p109 if rgdpch <14000, re
** Market ginis
xtregar   d5ginimark l.l.l.l.l.gini_mark  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5safeur l.l.l.l.l.safetyright_jur p60-p109 if rgdpch <14000, re

** Table A3, full results, upper panel
** Average schooling
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 , re
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 if rgdpch<14000, re
** Primary school
xtreg   dblprimtot l.l.l.l.l.bl_primarytot d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 , re
xtreg   dblprimtot l.l.l.l.l.bl_primarytot d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 if rgdpch<14000, re
** Secondary school
xtreg   dblsectot l.l.l.l.l.bl_secondarytot  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 , re
xtreg   dblsectot l.l.l.l.l.bl_secondarytot  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 if rgdpch<14000, re
** Table A3, bottom panel
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 , re
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 if rgdpch<14000, re
** Primary school
xtreg   dblprimtot l.l.l.l.l.bl_primarytot d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 , re
xtreg   dblprimtot l.l.l.l.l.bl_primarytot d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 if rgdpch<14000, re
** Secondary school
xtreg   dblsectot l.l.l.l.l.bl_secondarytot  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 , re
xtreg   dblsectot l.l.l.l.l.bl_secondarytot  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 if rgdpch<14000, re

** Table A4, upper panel
** Column 1
xtregar   dlife l.lifeexpectancyatbirthtotalyears dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dhealthright l.healthright p60-p109 , re 
**Column 2
xtregar   dlife l.lifeexpectancyatbirthtotalyears dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dhealthright l.healthright p60-p109 if rgdpch<14000, re 
** Column 3
xtregar   dgininet l.gini_net dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsafetyright l.safetyright p60-p109, re
** Column 4
xtregar   dgininet l.gini_net dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsafetyright l.safetyright p60-p109 if rgdpch <14000, re
** Table A4, bottom panel
* Column 1
xtregar   dlife l.lifeexpectancyatbirthtotalyears dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  djurhealth l.healthright_jur p60-p109, fe
**Column 2
xtregar   dlife l.lifeexpectancyatbirthtotalyears dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  djurhealth l.healthright_jur p60-p109 if rgdpch<14000, fe 
** Column 3
xtregar   dgininet l.gini_net dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc dsafetyright_jur l.safetyright_jur  p60-p109, fe
** Column 4
xtregar   dgininet l.gini_net dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp dlngdpsq lngsq dpolity l.polityiv dpolitysq  l.politysqua  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc dsafetyright_jur l.safetyright_jur  p60-p109 if rgdpch <14000, fe

** Table A5, upper panel
** Column 1
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5health l.l.l.l.l.healthright p60-p109, fe
** Column 2
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5health l.l.l.l.l.healthright p60-p109 if rgdpch <14000, fe
** Column 3
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 , fe
** Column 4
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright p60-p109 if rgdpch<14000, fe
** Column 5
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight l.l.l.l.l.safetyright p60-p109, fe
** Column 6
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight l.l.l.l.l.safetyright p60-p109 if rgdpch <14000, fe
** Table A5, bottom panel
** Column 1
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5healthjur l.l.l.l.l.healthright_jur p60-p109, fe
** Column 2
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5healthjur l.l.l.l.l.healthright_jur p60-p109 if rgdpch <14000, fe
** Column 3
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 , fe
** Column 4
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 if rgdpch<14000, fe
** Column 5
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5safeur l.l.l.l.l.safetyright_jur p60-p109, fe
** Column 6
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5safeur l.l.l.l.l.safetyright_jur p60-p109 if rgdpch <14000, fe

** Table A6, upper panel
** Government expenditures
xtregar  dcg l.cg dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright l.sumrights p60-p109 , fe
xtregar   d5cg l.l.l.l.l.cg  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright l.l.l.l.l.sumrights p60-p109 , fe
** Inflation
xtregar  dinflation l.inflation_ppp dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright l.sumrights p60-p109 , fe
xtregar   d5inflation l.l.l.l.l.inflation_ppp d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright l.l.l.l.l.sumrights p60-p109 , fe
** Legal quality
xtreg  d5legal l.l.l.l.l.legalquality d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright l.l.l.l.l.sumrights  p60-p109 if  d5legal!=., fe
** Table A6, bottom panel
** Government expenditures
xtregar  dcg l.cg dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright_jur l.sumrights_jur p60-p109 , fe
xtregar   d5cg l.l.l.l.l.cg  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright_jur l.l.l.l.l.sumrights_jur p60-p109 , fe
** Inflation
xtregar  dinflation l.inflation_ppp dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright_jur l.sumrights_jur p60-p109 , fe
xtregar   d5inflation l.l.l.l.l.inflation_ppp d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright_jur l.l.l.l.l.sumrights_jur p60-p109 , fe
** Legal quality
xtreg  d5legal l.l.l.l.l.legalquality d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright_jur l.l.l.l.l.sumrights_jur  p60-p109 if  d5legal!=., fe

** Table A7, upper panel
** Government expenditures
xtregar  dcg l.cg dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright l.sumrights p60-p109 , re
xtregar   d5cg l.l.l.l.l.cg  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright l.l.l.l.l.sumrights p60-p109 , re
** Inflation
xtregar  dinflation l.inflation_ppp dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright l.sumrights p60-p109 , re
xtregar   d5inflation l.l.l.l.l.inflation_ppp d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright l.l.l.l.l.sumrights p60-p109 , re
** Legal quality
xtreg  d5legal l.l.l.l.l.legalquality d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright l.l.l.l.l.sumrights  p60-p109 if  d5legal!=., re
** Table A7, middle panel
** Government expenditures
xtregar  dcg l.cg dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright_jur l.sumrights_jur p60-p109 , re
xtregar   d5cg l.l.l.l.l.cg  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright_jur l.l.l.l.l.sumrights_jur p60-p109 , re
** Inflation
xtregar  dinflation l.inflation_ppp dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsumright_jur l.sumrights_jur p60-p109 , re
xtregar   d5inflation l.l.l.l.l.inflation_ppp d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright_jur l.l.l.l.l.sumrights_jur p60-p109 , re
** Legal quality
xtreg  d5legal l.l.l.l.l.legalquality d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5sumright_jur l.l.l.l.l.sumrights_jur  p60-p109 if  d5legal!=., re
** Table A7, bottom panel
** Government expenditures
xtregar  dcg l.cg dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc djurhealth l.healthright_jur p60-p109 , re
xtregar   d5cg l.l.l.l.l.cg  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5healthjur l.l.l.l.l.healthright_jur p60-p109 , re
xtregar  dcg l.cg dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  djuredu l.educationright_jur p60-p109 , re
xtregar   d5cg l.l.l.l.l.cg  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur p60-p109 , re
xtregar  dcg l.cg dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsafetyright_jur l.safetyright_jur , re
xtregar   d5cg l.l.l.l.l.cg  d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5safeur l.l.l.l.l.safetyright_jur p60-p109 , re
** Inflation
xtregar  dinflation l.inflation_ppp dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  djurhealth l.healthright_jur p60-p109 , re
xtregar   d5inflation l.l.l.l.l.inflation_ppp d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5healthjur l.l.l.l.l.healthright_jur p60-p109 , re
xtregar  dinflation l.inflation_ppp dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  djuredu l.educationright_jur p60-p109 , re
xtregar   d5inflation l.l.l.l.l.inflation_ppp d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur  p60-p109 , re
xtregar  dinflation l.inflation_ppp dagedepend l.agedependencyratiooldofworkingag dlngdp l.lngdp  dpolity l.polityiv  dcommunist l.communist  dlnpop  l.lnpop  dopen l.openc  dsafetyright_jur l.safetyright_jur p60-p109 , re
xtregar   d5inflation l.l.l.l.l.inflation_ppp d5agedep  d5lngdp  d5polityiv   d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5safeur l.l.l.l.l.safetyright_jur p60-p109 , re
** Legal quality
xtreg  d5legal l.l.l.l.l.legalquality d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5healthjur l.l.l.l.l.healthright_jur  p60-p109 if  d5legal!=., re
xtreg  d5legal l.l.l.l.l.legalquality d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5edujur l.l.l.l.l.educationright_jur  p60-p109 if  d5legal!=., re
xtreg  d5legal l.l.l.l.l.legalquality d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5safeur l.l.l.l.l.safetyright_jur  p60-p109 if  d5legal!=., re

** Table A8
** Health
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5health l.l.l.l.l.healthright yearsonly10health years15health p60-p109 if rgdpch <14000, re
xtregar   d5life l.l.l.l.l.lifeexpectancyatbirthtotalyears  d5agedep  d5lngdp  d5polityiv  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5health l.l.l.l.l.healthright yearsonly10health years15health p60-p109, re
** Education
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright yearsonly10edu years15edu p60-p109 if rgdpch<14000, re
xtreg   davschool l.l.l.l.l.bl_avyearschool  d5agedep  d5lngdp  d5polityiv d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv  l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5eduright l.l.l.l.l.educationright yearsonly10edu years15edu p60-p109, re
** Inequality
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight yearsonly10safety years15safety l.l.l.l.l.safetyright p60-p109 if rgdpch <14000, re
xtregar   d5gininet l.l.l.l.l.gini_net  d5agedep  d5lngdp d5lnsq d5polityiv d5politysq  d5commu  d5lnpop  d5open l.l.l.l.l.agedependencyratiooldofworkingag l.l.l.l.l.lngdp l.l.l.l.l.polityiv l.l.l.l.l.dlngdpsq l.l.l.l.l.dpolitysq l.l.l.l.l.communist l.l.l.l.l.lnpop l.l.l.l.l.openc d5saferight yearsonly10safety years15safety l.l.l.l.l.safetyright p60-p109, re
