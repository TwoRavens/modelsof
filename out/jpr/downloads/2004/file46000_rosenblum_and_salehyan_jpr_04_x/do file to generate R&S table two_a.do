**Do file to generate Rosenblum & Salehyan table 2 column one

**The following commands generate necessary variables and executes rolling chow tests reported in table two; reported statistics are the average across 5 datasets.

use jpr1

gen _86 = (year>=1986)
gen hri_2_86 = hri_2*_86
gen polity_86 = polity*_86
gen mildum_86 = mildum*_86
gen  trade2_86 = trade2*_86
gen sanct_86 = sanctions*_86
gen topund_86 = topund*_86

gen _87 = (year>=1987)
gen hri_2_87 = hri_2*_87
gen polity_87 = polity*_87
gen mildum_87 = mildum*_87
gen  trade2_87 = trade2*_87
gen sanct_87 = sanctions*_87
gen topund_87 = topund*_87


gen _88 = (year>=1988)
gen hri_2_88 = hri_2*_88
gen polity_88 = polity*_88
gen mildum_88 = mildum*_88
gen  trade2_88 = trade2*_88
gen sanct_88 = sanctions*_88
gen topund_88 = topund*_88



gen _89 = (year>=1989)
gen hri_2_89 = hri_2*_89
gen polity_89 = polity*_89
gen mildum_89 = mildum*_89
gen  trade2_89 = trade2*_89
gen sanct_89 = sanctions*_89
gen topund_89 = topund*_89

gen _90 = (year>=1990)
gen hri_2_90 = hri_2*_90
gen polity_90 = polity*_90
gen mildum_90 = mildum*_90
gen  trade2_90 = trade2*_90
gen sanct_90 = sanctions*_90
gen topund_90 = topund*_90

gen _91 = (year>=1991)
gen hri_2_91 = hri_2*_91
gen polity_91 = polity*_91
gen mildum_91 = mildum*_91
gen  trade2_91 = trade2*_91
gen sanct_91 = sanctions*_91
gen topund_91 = topund*_91

gen _92 = (year>=1992)
gen hri_2_92 = hri_2*_92
gen polity_92 = polity*_92
gen mildum_92 = mildum*_92
gen  trade2_92 = trade2*_92
gen sanct_92 = sanctions*_92
gen topund_92 = topund*_92

gen _93 = (year>=1993)
gen hri_2_93 = hri_2*_93
gen polity_93 = polity*_93
gen mildum_93 = mildum*_93
gen  trade2_93 = trade2*_93
gen sanct_93 = sanctions*_93
gen topund_93 = topund*_93

gen _94 = (year>=1994)
gen hri_2_94 = hri_2*_94
gen polity_94 = polity*_94
gen mildum_94 = mildum*_94
gen  trade2_94 = trade2*_94
gen sanct_94 = sanctions*_94
gen topund_94 = topund*_94

gen _95 = (year>=1995)
gen hri_2_95 = hri_2*_95
gen polity_95 = polity*_95
gen mildum_95 = mildum*_95
gen  trade2_95 = trade2*_95
gen sanct_95 = sanctions*_95
gen topund_95 = topund*_95

gen _96 = (year>=1996)
gen hri_2_96 = hri_2*_96
gen polity_96 = polity*_96
gen mildum_96 = mildum*_96
gen  trade2_96 = trade2*_96
gen sanct_96 = sanctions*_96
gen topund_96 = topund*_96

gen _97 = (year>=1997)
gen hri_2_97 = hri_2*_97
gen polity_97 = polity*_97
gen mildum_97 = mildum*_97
gen  trade2_97 = trade2*_97
gen sanct_97 = sanctions*_97
gen topund_97 = topund*_97

gen _98 = (year>=1998)
gen hri_2_98 = hri_2*_98
gen polity_98 = polity*_98
gen mildum_98 = mildum*_98
gen  trade2_98 = trade2*_98
gen sanct_98 = sanctions*_98
gen topund_98 = topund*_98



quietly xtpcse asmprn communist hri_2 hri_2_86 polity polity_86  mildum mildum_86 trade2 trade2_86 sanctions sanct_86  topund topund_86 _86 year, c(a)
test hri_2_86 polity_86 mildum_86 trade2_86 sanct_86  topund_86 _86
quietly xtpcse asmprn communist hri_2 hri_2_87 polity polity_87       mildum mildum_87 trade2 trade2_87 sanctions sanct_87  topund topund_87 _87 year, c(a)
test hri_2_87 polity_87    mildum_87 trade2_87 sanct_87  topund_87 _87
quietly xtpcse asmprn communist hri_2 hri_2_88 polity polity_88       mildum mildum_88 trade2 trade2_88 sanctions sanct_88  topund topund_88 _88 year, c(a)
test hri_2_88 polity_88    mildum_88 trade2_88 sanct_88  topund_88 _88
quietly xtpcse asmprn communist hri_2 hri_2_89 polity polity_89       mildum mildum_89 trade2 trade2_89 sanctions sanct_89  topund topund_89 _89 year, c(a)
test hri_2_89 polity_89    mildum_89 trade2_89 sanct_89  topund_89 _89
quietly xtpcse asmprn communist hri_2 hri_2_90 polity polity_90       mildum mildum_90 trade2 trade2_90 sanctions sanct_90  topund topund_90 _90 year, c(a)
test hri_2_90 polity_90    mildum_90 trade2_90 sanct_90  topund_90 _90
quietly xtpcse asmprn communist hri_2 hri_2_91 polity polity_91       mildum mildum_91 trade2 trade2_91 sanctions sanct_91  topund topund_91 _91 year, c(a)
test hri_2_91 polity_91    mildum_91 trade2_91 sanct_91  topund_91 _91
quietly xtpcse asmprn communist hri_2 hri_2_92 polity polity_92       mildum mildum_92 trade2 trade2_92 sanctions sanct_92  topund topund_92 _92 year, c(a)
test hri_2_92 polity_92    mildum_92 trade2_92 sanct_92  topund_92 _92
quietly xtpcse asmprn communist hri_2 hri_2_93 polity polity_93       mildum mildum_93 trade2 trade2_93 sanctions sanct_93  topund topund_93 _93 year, c(a)
test hri_2_93 polity_93    mildum_93 trade2_93 sanct_93  topund_93 _93
quietly xtpcse asmprn communist hri_2 hri_2_94 polity polity_94       mildum mildum_94 trade2 trade2_94 sanctions sanct_94  topund topund_94 _94 year, c(a)
test hri_2_94 polity_94    mildum_94 trade2_94 sanct_94  topund_94 _94
quietly xtpcse asmprn communist hri_2 hri_2_95 polity polity_95       mildum mildum_95 trade2 trade2_95 sanctions sanct_95  topund topund_95 _95 year, c(a)
test hri_2_95 polity_95    mildum_95 trade2_95 sanct_95  topund_95 _95
quietly xtpcse asmprn communist hri_2 hri_2_96 polity polity_96       mildum mildum_96 trade2 trade2_96 sanctions sanct_96  topund topund_96 _96 year, c(a)
test hri_2_96 polity_96    mildum_96 trade2_96 sanct_96  topund_96 _96
quietly xtpcse asmprn communist hri_2 hri_2_97 polity polity_97       mildum mildum_97 trade2 trade2_97 sanctions sanct_97  topund topund_97 _97 year, c(a)
test hri_2_97 polity_97    mildum_97 trade2_97 sanct_97  topund_97 _97
quietly xtpcse asmprn communist hri_2 hri_2_98 polity polity_98       mildum mildum_98 trade2 trade2_98 sanctions sanct_98  topund topund_98 _98 year, c(a)
test hri_2_98 polity_98    mildum_98 trade2_98 sanct_98  topund_98 _98

****
use jpr2

gen _86 = (year>=1986)
gen hri_2_86 = hri_2*_86
gen polity_86 = polity*_86
gen mildum_86 = mildum*_86
gen  trade2_86 = trade2*_86
gen sanct_86 = sanctions*_86
gen topund_86 = topund*_86

gen _87 = (year>=1987)
gen hri_2_87 = hri_2*_87
gen polity_87 = polity*_87
gen mildum_87 = mildum*_87
gen  trade2_87 = trade2*_87
gen sanct_87 = sanctions*_87
gen topund_87 = topund*_87


gen _88 = (year>=1988)
gen hri_2_88 = hri_2*_88
gen polity_88 = polity*_88
gen mildum_88 = mildum*_88
gen  trade2_88 = trade2*_88
gen sanct_88 = sanctions*_88
gen topund_88 = topund*_88



gen _89 = (year>=1989)
gen hri_2_89 = hri_2*_89
gen polity_89 = polity*_89
gen mildum_89 = mildum*_89
gen  trade2_89 = trade2*_89
gen sanct_89 = sanctions*_89
gen topund_89 = topund*_89

gen _90 = (year>=1990)
gen hri_2_90 = hri_2*_90
gen polity_90 = polity*_90
gen mildum_90 = mildum*_90
gen  trade2_90 = trade2*_90
gen sanct_90 = sanctions*_90
gen topund_90 = topund*_90

gen _91 = (year>=1991)
gen hri_2_91 = hri_2*_91
gen polity_91 = polity*_91
gen mildum_91 = mildum*_91
gen  trade2_91 = trade2*_91
gen sanct_91 = sanctions*_91
gen topund_91 = topund*_91

gen _92 = (year>=1992)
gen hri_2_92 = hri_2*_92
gen polity_92 = polity*_92
gen mildum_92 = mildum*_92
gen  trade2_92 = trade2*_92
gen sanct_92 = sanctions*_92
gen topund_92 = topund*_92

gen _93 = (year>=1993)
gen hri_2_93 = hri_2*_93
gen polity_93 = polity*_93
gen mildum_93 = mildum*_93
gen  trade2_93 = trade2*_93
gen sanct_93 = sanctions*_93
gen topund_93 = topund*_93

gen _94 = (year>=1994)
gen hri_2_94 = hri_2*_94
gen polity_94 = polity*_94
gen mildum_94 = mildum*_94
gen  trade2_94 = trade2*_94
gen sanct_94 = sanctions*_94
gen topund_94 = topund*_94

gen _95 = (year>=1995)
gen hri_2_95 = hri_2*_95
gen polity_95 = polity*_95
gen mildum_95 = mildum*_95
gen  trade2_95 = trade2*_95
gen sanct_95 = sanctions*_95
gen topund_95 = topund*_95

gen _96 = (year>=1996)
gen hri_2_96 = hri_2*_96
gen polity_96 = polity*_96
gen mildum_96 = mildum*_96
gen  trade2_96 = trade2*_96
gen sanct_96 = sanctions*_96
gen topund_96 = topund*_96

gen _97 = (year>=1997)
gen hri_2_97 = hri_2*_97
gen polity_97 = polity*_97
gen mildum_97 = mildum*_97
gen  trade2_97 = trade2*_97
gen sanct_97 = sanctions*_97
gen topund_97 = topund*_97

gen _98 = (year>=1998)
gen hri_2_98 = hri_2*_98
gen polity_98 = polity*_98
gen mildum_98 = mildum*_98
gen  trade2_98 = trade2*_98
gen sanct_98 = sanctions*_98
gen topund_98 = topund*_98



quietly xtpcse asmprn communist hri_2 hri_2_86 polity polity_86  mildum mildum_86 trade2 trade2_86 sanctions sanct_86  topund topund_86 _86 year, c(a)
test hri_2_86 polity_86 mildum_86 trade2_86 sanct_86  topund_86 _86
quietly xtpcse asmprn communist hri_2 hri_2_87 polity polity_87       mildum mildum_87 trade2 trade2_87 sanctions sanct_87  topund topund_87 _87 year, c(a)
test hri_2_87 polity_87    mildum_87 trade2_87 sanct_87  topund_87 _87
quietly xtpcse asmprn communist hri_2 hri_2_88 polity polity_88       mildum mildum_88 trade2 trade2_88 sanctions sanct_88  topund topund_88 _88 year, c(a)
test hri_2_88 polity_88    mildum_88 trade2_88 sanct_88  topund_88 _88
quietly xtpcse asmprn communist hri_2 hri_2_89 polity polity_89       mildum mildum_89 trade2 trade2_89 sanctions sanct_89  topund topund_89 _89 year, c(a)
test hri_2_89 polity_89    mildum_89 trade2_89 sanct_89  topund_89 _89
quietly xtpcse asmprn communist hri_2 hri_2_90 polity polity_90       mildum mildum_90 trade2 trade2_90 sanctions sanct_90  topund topund_90 _90 year, c(a)
test hri_2_90 polity_90    mildum_90 trade2_90 sanct_90  topund_90 _90
quietly xtpcse asmprn communist hri_2 hri_2_91 polity polity_91       mildum mildum_91 trade2 trade2_91 sanctions sanct_91  topund topund_91 _91 year, c(a)
test hri_2_91 polity_91    mildum_91 trade2_91 sanct_91  topund_91 _91
quietly xtpcse asmprn communist hri_2 hri_2_92 polity polity_92       mildum mildum_92 trade2 trade2_92 sanctions sanct_92  topund topund_92 _92 year, c(a)
test hri_2_92 polity_92    mildum_92 trade2_92 sanct_92  topund_92 _92
quietly xtpcse asmprn communist hri_2 hri_2_93 polity polity_93       mildum mildum_93 trade2 trade2_93 sanctions sanct_93  topund topund_93 _93 year, c(a)
test hri_2_93 polity_93    mildum_93 trade2_93 sanct_93  topund_93 _93
quietly xtpcse asmprn communist hri_2 hri_2_94 polity polity_94       mildum mildum_94 trade2 trade2_94 sanctions sanct_94  topund topund_94 _94 year, c(a)
test hri_2_94 polity_94    mildum_94 trade2_94 sanct_94  topund_94 _94
quietly xtpcse asmprn communist hri_2 hri_2_95 polity polity_95       mildum mildum_95 trade2 trade2_95 sanctions sanct_95  topund topund_95 _95 year, c(a)
test hri_2_95 polity_95    mildum_95 trade2_95 sanct_95  topund_95 _95
quietly xtpcse asmprn communist hri_2 hri_2_96 polity polity_96       mildum mildum_96 trade2 trade2_96 sanctions sanct_96  topund topund_96 _96 year, c(a)
test hri_2_96 polity_96    mildum_96 trade2_96 sanct_96  topund_96 _96
quietly xtpcse asmprn communist hri_2 hri_2_97 polity polity_97       mildum mildum_97 trade2 trade2_97 sanctions sanct_97  topund topund_97 _97 year, c(a)
test hri_2_97 polity_97    mildum_97 trade2_97 sanct_97  topund_97 _97
quietly xtpcse asmprn communist hri_2 hri_2_98 polity polity_98       mildum mildum_98 trade2 trade2_98 sanctions sanct_98  topund topund_98 _98 year, c(a)
test hri_2_98 polity_98    mildum_98 trade2_98 sanct_98  topund_98 _98


****
use jpr3

gen _86 = (year>=1986)
gen hri_2_86 = hri_2*_86
gen polity_86 = polity*_86
gen mildum_86 = mildum*_86
gen  trade2_86 = trade2*_86
gen sanct_86 = sanctions*_86
gen topund_86 = topund*_86

gen _87 = (year>=1987)
gen hri_2_87 = hri_2*_87
gen polity_87 = polity*_87
gen mildum_87 = mildum*_87
gen  trade2_87 = trade2*_87
gen sanct_87 = sanctions*_87
gen topund_87 = topund*_87


gen _88 = (year>=1988)
gen hri_2_88 = hri_2*_88
gen polity_88 = polity*_88
gen mildum_88 = mildum*_88
gen  trade2_88 = trade2*_88
gen sanct_88 = sanctions*_88
gen topund_88 = topund*_88



gen _89 = (year>=1989)
gen hri_2_89 = hri_2*_89
gen polity_89 = polity*_89
gen mildum_89 = mildum*_89
gen  trade2_89 = trade2*_89
gen sanct_89 = sanctions*_89
gen topund_89 = topund*_89

gen _90 = (year>=1990)
gen hri_2_90 = hri_2*_90
gen polity_90 = polity*_90
gen mildum_90 = mildum*_90
gen  trade2_90 = trade2*_90
gen sanct_90 = sanctions*_90
gen topund_90 = topund*_90

gen _91 = (year>=1991)
gen hri_2_91 = hri_2*_91
gen polity_91 = polity*_91
gen mildum_91 = mildum*_91
gen  trade2_91 = trade2*_91
gen sanct_91 = sanctions*_91
gen topund_91 = topund*_91

gen _92 = (year>=1992)
gen hri_2_92 = hri_2*_92
gen polity_92 = polity*_92
gen mildum_92 = mildum*_92
gen  trade2_92 = trade2*_92
gen sanct_92 = sanctions*_92
gen topund_92 = topund*_92

gen _93 = (year>=1993)
gen hri_2_93 = hri_2*_93
gen polity_93 = polity*_93
gen mildum_93 = mildum*_93
gen  trade2_93 = trade2*_93
gen sanct_93 = sanctions*_93
gen topund_93 = topund*_93

gen _94 = (year>=1994)
gen hri_2_94 = hri_2*_94
gen polity_94 = polity*_94
gen mildum_94 = mildum*_94
gen  trade2_94 = trade2*_94
gen sanct_94 = sanctions*_94
gen topund_94 = topund*_94

gen _95 = (year>=1995)
gen hri_2_95 = hri_2*_95
gen polity_95 = polity*_95
gen mildum_95 = mildum*_95
gen  trade2_95 = trade2*_95
gen sanct_95 = sanctions*_95
gen topund_95 = topund*_95

gen _96 = (year>=1996)
gen hri_2_96 = hri_2*_96
gen polity_96 = polity*_96
gen mildum_96 = mildum*_96
gen  trade2_96 = trade2*_96
gen sanct_96 = sanctions*_96
gen topund_96 = topund*_96

gen _97 = (year>=1997)
gen hri_2_97 = hri_2*_97
gen polity_97 = polity*_97
gen mildum_97 = mildum*_97
gen  trade2_97 = trade2*_97
gen sanct_97 = sanctions*_97
gen topund_97 = topund*_97

gen _98 = (year>=1998)
gen hri_2_98 = hri_2*_98
gen polity_98 = polity*_98
gen mildum_98 = mildum*_98
gen  trade2_98 = trade2*_98
gen sanct_98 = sanctions*_98
gen topund_98 = topund*_98



quietly xtpcse asmprn communist hri_2 hri_2_86 polity polity_86  mildum mildum_86 trade2 trade2_86 sanctions sanct_86  topund topund_86 _86 year, c(a)
test hri_2_86 polity_86 mildum_86 trade2_86 sanct_86  topund_86 _86
quietly xtpcse asmprn communist hri_2 hri_2_87 polity polity_87       mildum mildum_87 trade2 trade2_87 sanctions sanct_87  topund topund_87 _87 year, c(a)
test hri_2_87 polity_87    mildum_87 trade2_87 sanct_87  topund_87 _87
quietly xtpcse asmprn communist hri_2 hri_2_88 polity polity_88       mildum mildum_88 trade2 trade2_88 sanctions sanct_88  topund topund_88 _88 year, c(a)
test hri_2_88 polity_88    mildum_88 trade2_88 sanct_88  topund_88 _88
quietly xtpcse asmprn communist hri_2 hri_2_89 polity polity_89       mildum mildum_89 trade2 trade2_89 sanctions sanct_89  topund topund_89 _89 year, c(a)
test hri_2_89 polity_89    mildum_89 trade2_89 sanct_89  topund_89 _89
quietly xtpcse asmprn communist hri_2 hri_2_90 polity polity_90       mildum mildum_90 trade2 trade2_90 sanctions sanct_90  topund topund_90 _90 year, c(a)
test hri_2_90 polity_90    mildum_90 trade2_90 sanct_90  topund_90 _90
quietly xtpcse asmprn communist hri_2 hri_2_91 polity polity_91       mildum mildum_91 trade2 trade2_91 sanctions sanct_91  topund topund_91 _91 year, c(a)
test hri_2_91 polity_91    mildum_91 trade2_91 sanct_91  topund_91 _91
quietly xtpcse asmprn communist hri_2 hri_2_92 polity polity_92       mildum mildum_92 trade2 trade2_92 sanctions sanct_92  topund topund_92 _92 year, c(a)
test hri_2_92 polity_92    mildum_92 trade2_92 sanct_92  topund_92 _92
quietly xtpcse asmprn communist hri_2 hri_2_93 polity polity_93       mildum mildum_93 trade2 trade2_93 sanctions sanct_93  topund topund_93 _93 year, c(a)
test hri_2_93 polity_93    mildum_93 trade2_93 sanct_93  topund_93 _93
quietly xtpcse asmprn communist hri_2 hri_2_94 polity polity_94       mildum mildum_94 trade2 trade2_94 sanctions sanct_94  topund topund_94 _94 year, c(a)
test hri_2_94 polity_94    mildum_94 trade2_94 sanct_94  topund_94 _94
quietly xtpcse asmprn communist hri_2 hri_2_95 polity polity_95       mildum mildum_95 trade2 trade2_95 sanctions sanct_95  topund topund_95 _95 year, c(a)
test hri_2_95 polity_95    mildum_95 trade2_95 sanct_95  topund_95 _95
quietly xtpcse asmprn communist hri_2 hri_2_96 polity polity_96       mildum mildum_96 trade2 trade2_96 sanctions sanct_96  topund topund_96 _96 year, c(a)
test hri_2_96 polity_96    mildum_96 trade2_96 sanct_96  topund_96 _96
quietly xtpcse asmprn communist hri_2 hri_2_97 polity polity_97       mildum mildum_97 trade2 trade2_97 sanctions sanct_97  topund topund_97 _97 year, c(a)
test hri_2_97 polity_97    mildum_97 trade2_97 sanct_97  topund_97 _97
quietly xtpcse asmprn communist hri_2 hri_2_98 polity polity_98       mildum mildum_98 trade2 trade2_98 sanctions sanct_98  topund topund_98 _98 year, c(a)
test hri_2_98 polity_98    mildum_98 trade2_98 sanct_98  topund_98 _98



****
use jpr4

gen _86 = (year>=1986)
gen hri_2_86 = hri_2*_86
gen polity_86 = polity*_86
gen mildum_86 = mildum*_86
gen  trade2_86 = trade2*_86
gen sanct_86 = sanctions*_86
gen topund_86 = topund*_86

gen _87 = (year>=1987)
gen hri_2_87 = hri_2*_87
gen polity_87 = polity*_87
gen mildum_87 = mildum*_87
gen  trade2_87 = trade2*_87
gen sanct_87 = sanctions*_87
gen topund_87 = topund*_87


gen _88 = (year>=1988)
gen hri_2_88 = hri_2*_88
gen polity_88 = polity*_88
gen mildum_88 = mildum*_88
gen  trade2_88 = trade2*_88
gen sanct_88 = sanctions*_88
gen topund_88 = topund*_88



gen _89 = (year>=1989)
gen hri_2_89 = hri_2*_89
gen polity_89 = polity*_89
gen mildum_89 = mildum*_89
gen  trade2_89 = trade2*_89
gen sanct_89 = sanctions*_89
gen topund_89 = topund*_89

gen _90 = (year>=1990)
gen hri_2_90 = hri_2*_90
gen polity_90 = polity*_90
gen mildum_90 = mildum*_90
gen  trade2_90 = trade2*_90
gen sanct_90 = sanctions*_90
gen topund_90 = topund*_90

gen _91 = (year>=1991)
gen hri_2_91 = hri_2*_91
gen polity_91 = polity*_91
gen mildum_91 = mildum*_91
gen  trade2_91 = trade2*_91
gen sanct_91 = sanctions*_91
gen topund_91 = topund*_91

gen _92 = (year>=1992)
gen hri_2_92 = hri_2*_92
gen polity_92 = polity*_92
gen mildum_92 = mildum*_92
gen  trade2_92 = trade2*_92
gen sanct_92 = sanctions*_92
gen topund_92 = topund*_92

gen _93 = (year>=1993)
gen hri_2_93 = hri_2*_93
gen polity_93 = polity*_93
gen mildum_93 = mildum*_93
gen  trade2_93 = trade2*_93
gen sanct_93 = sanctions*_93
gen topund_93 = topund*_93

gen _94 = (year>=1994)
gen hri_2_94 = hri_2*_94
gen polity_94 = polity*_94
gen mildum_94 = mildum*_94
gen  trade2_94 = trade2*_94
gen sanct_94 = sanctions*_94
gen topund_94 = topund*_94

gen _95 = (year>=1995)
gen hri_2_95 = hri_2*_95
gen polity_95 = polity*_95
gen mildum_95 = mildum*_95
gen  trade2_95 = trade2*_95
gen sanct_95 = sanctions*_95
gen topund_95 = topund*_95

gen _96 = (year>=1996)
gen hri_2_96 = hri_2*_96
gen polity_96 = polity*_96
gen mildum_96 = mildum*_96
gen  trade2_96 = trade2*_96
gen sanct_96 = sanctions*_96
gen topund_96 = topund*_96

gen _97 = (year>=1997)
gen hri_2_97 = hri_2*_97
gen polity_97 = polity*_97
gen mildum_97 = mildum*_97
gen  trade2_97 = trade2*_97
gen sanct_97 = sanctions*_97
gen topund_97 = topund*_97

gen _98 = (year>=1998)
gen hri_2_98 = hri_2*_98
gen polity_98 = polity*_98
gen mildum_98 = mildum*_98
gen  trade2_98 = trade2*_98
gen sanct_98 = sanctions*_98
gen topund_98 = topund*_98



quietly xtpcse asmprn communist hri_2 hri_2_86 polity polity_86  mildum mildum_86 trade2 trade2_86 sanctions sanct_86  topund topund_86 _86 year, c(a)
test hri_2_86 polity_86 mildum_86 trade2_86 sanct_86  topund_86 _86
quietly xtpcse asmprn communist hri_2 hri_2_87 polity polity_87       mildum mildum_87 trade2 trade2_87 sanctions sanct_87  topund topund_87 _87 year, c(a)
test hri_2_87 polity_87    mildum_87 trade2_87 sanct_87  topund_87 _87
quietly xtpcse asmprn communist hri_2 hri_2_88 polity polity_88       mildum mildum_88 trade2 trade2_88 sanctions sanct_88  topund topund_88 _88 year, c(a)
test hri_2_88 polity_88    mildum_88 trade2_88 sanct_88  topund_88 _88
quietly xtpcse asmprn communist hri_2 hri_2_89 polity polity_89       mildum mildum_89 trade2 trade2_89 sanctions sanct_89  topund topund_89 _89 year, c(a)
test hri_2_89 polity_89    mildum_89 trade2_89 sanct_89  topund_89 _89
quietly xtpcse asmprn communist hri_2 hri_2_90 polity polity_90       mildum mildum_90 trade2 trade2_90 sanctions sanct_90  topund topund_90 _90 year, c(a)
test hri_2_90 polity_90    mildum_90 trade2_90 sanct_90  topund_90 _90
quietly xtpcse asmprn communist hri_2 hri_2_91 polity polity_91       mildum mildum_91 trade2 trade2_91 sanctions sanct_91  topund topund_91 _91 year, c(a)
test hri_2_91 polity_91    mildum_91 trade2_91 sanct_91  topund_91 _91
quietly xtpcse asmprn communist hri_2 hri_2_92 polity polity_92       mildum mildum_92 trade2 trade2_92 sanctions sanct_92  topund topund_92 _92 year, c(a)
test hri_2_92 polity_92    mildum_92 trade2_92 sanct_92  topund_92 _92
quietly xtpcse asmprn communist hri_2 hri_2_93 polity polity_93       mildum mildum_93 trade2 trade2_93 sanctions sanct_93  topund topund_93 _93 year, c(a)
test hri_2_93 polity_93    mildum_93 trade2_93 sanct_93  topund_93 _93
quietly xtpcse asmprn communist hri_2 hri_2_94 polity polity_94       mildum mildum_94 trade2 trade2_94 sanctions sanct_94  topund topund_94 _94 year, c(a)
test hri_2_94 polity_94    mildum_94 trade2_94 sanct_94  topund_94 _94
quietly xtpcse asmprn communist hri_2 hri_2_95 polity polity_95       mildum mildum_95 trade2 trade2_95 sanctions sanct_95  topund topund_95 _95 year, c(a)
test hri_2_95 polity_95    mildum_95 trade2_95 sanct_95  topund_95 _95
quietly xtpcse asmprn communist hri_2 hri_2_96 polity polity_96       mildum mildum_96 trade2 trade2_96 sanctions sanct_96  topund topund_96 _96 year, c(a)
test hri_2_96 polity_96    mildum_96 trade2_96 sanct_96  topund_96 _96
quietly xtpcse asmprn communist hri_2 hri_2_97 polity polity_97       mildum mildum_97 trade2 trade2_97 sanctions sanct_97  topund topund_97 _97 year, c(a)
test hri_2_97 polity_97    mildum_97 trade2_97 sanct_97  topund_97 _97
quietly xtpcse asmprn communist hri_2 hri_2_98 polity polity_98       mildum mildum_98 trade2 trade2_98 sanctions sanct_98  topund topund_98 _98 year, c(a)
test hri_2_98 polity_98    mildum_98 trade2_98 sanct_98  topund_98 _98



****
use jpr5

gen _86 = (year>=1986)
gen hri_2_86 = hri_2*_86
gen polity_86 = polity*_86
gen mildum_86 = mildum*_86
gen  trade2_86 = trade2*_86
gen sanct_86 = sanctions*_86
gen topund_86 = topund*_86

gen _87 = (year>=1987)
gen hri_2_87 = hri_2*_87
gen polity_87 = polity*_87
gen mildum_87 = mildum*_87
gen  trade2_87 = trade2*_87
gen sanct_87 = sanctions*_87
gen topund_87 = topund*_87


gen _88 = (year>=1988)
gen hri_2_88 = hri_2*_88
gen polity_88 = polity*_88
gen mildum_88 = mildum*_88
gen  trade2_88 = trade2*_88
gen sanct_88 = sanctions*_88
gen topund_88 = topund*_88



gen _89 = (year>=1989)
gen hri_2_89 = hri_2*_89
gen polity_89 = polity*_89
gen mildum_89 = mildum*_89
gen  trade2_89 = trade2*_89
gen sanct_89 = sanctions*_89
gen topund_89 = topund*_89

gen _90 = (year>=1990)
gen hri_2_90 = hri_2*_90
gen polity_90 = polity*_90
gen mildum_90 = mildum*_90
gen  trade2_90 = trade2*_90
gen sanct_90 = sanctions*_90
gen topund_90 = topund*_90

gen _91 = (year>=1991)
gen hri_2_91 = hri_2*_91
gen polity_91 = polity*_91
gen mildum_91 = mildum*_91
gen  trade2_91 = trade2*_91
gen sanct_91 = sanctions*_91
gen topund_91 = topund*_91

gen _92 = (year>=1992)
gen hri_2_92 = hri_2*_92
gen polity_92 = polity*_92
gen mildum_92 = mildum*_92
gen  trade2_92 = trade2*_92
gen sanct_92 = sanctions*_92
gen topund_92 = topund*_92

gen _93 = (year>=1993)
gen hri_2_93 = hri_2*_93
gen polity_93 = polity*_93
gen mildum_93 = mildum*_93
gen  trade2_93 = trade2*_93
gen sanct_93 = sanctions*_93
gen topund_93 = topund*_93

gen _94 = (year>=1994)
gen hri_2_94 = hri_2*_94
gen polity_94 = polity*_94
gen mildum_94 = mildum*_94
gen  trade2_94 = trade2*_94
gen sanct_94 = sanctions*_94
gen topund_94 = topund*_94

gen _95 = (year>=1995)
gen hri_2_95 = hri_2*_95
gen polity_95 = polity*_95
gen mildum_95 = mildum*_95
gen  trade2_95 = trade2*_95
gen sanct_95 = sanctions*_95
gen topund_95 = topund*_95

gen _96 = (year>=1996)
gen hri_2_96 = hri_2*_96
gen polity_96 = polity*_96
gen mildum_96 = mildum*_96
gen  trade2_96 = trade2*_96
gen sanct_96 = sanctions*_96
gen topund_96 = topund*_96

gen _97 = (year>=1997)
gen hri_2_97 = hri_2*_97
gen polity_97 = polity*_97
gen mildum_97 = mildum*_97
gen  trade2_97 = trade2*_97
gen sanct_97 = sanctions*_97
gen topund_97 = topund*_97

gen _98 = (year>=1998)
gen hri_2_98 = hri_2*_98
gen polity_98 = polity*_98
gen mildum_98 = mildum*_98
gen  trade2_98 = trade2*_98
gen sanct_98 = sanctions*_98
gen topund_98 = topund*_98



quietly xtpcse asmprn communist hri_2 hri_2_86 polity polity_86  mildum mildum_86 trade2 trade2_86 sanctions sanct_86  topund topund_86 _86 year, c(a)
test hri_2_86 polity_86 mildum_86 trade2_86 sanct_86  topund_86 _86
quietly xtpcse asmprn communist hri_2 hri_2_87 polity polity_87       mildum mildum_87 trade2 trade2_87 sanctions sanct_87  topund topund_87 _87 year, c(a)
test hri_2_87 polity_87    mildum_87 trade2_87 sanct_87  topund_87 _87
quietly xtpcse asmprn communist hri_2 hri_2_88 polity polity_88       mildum mildum_88 trade2 trade2_88 sanctions sanct_88  topund topund_88 _88 year, c(a)
test hri_2_88 polity_88    mildum_88 trade2_88 sanct_88  topund_88 _88
quietly xtpcse asmprn communist hri_2 hri_2_89 polity polity_89       mildum mildum_89 trade2 trade2_89 sanctions sanct_89  topund topund_89 _89 year, c(a)
test hri_2_89 polity_89    mildum_89 trade2_89 sanct_89  topund_89 _89
quietly xtpcse asmprn communist hri_2 hri_2_90 polity polity_90       mildum mildum_90 trade2 trade2_90 sanctions sanct_90  topund topund_90 _90 year, c(a)
test hri_2_90 polity_90    mildum_90 trade2_90 sanct_90  topund_90 _90
quietly xtpcse asmprn communist hri_2 hri_2_91 polity polity_91       mildum mildum_91 trade2 trade2_91 sanctions sanct_91  topund topund_91 _91 year, c(a)
test hri_2_91 polity_91    mildum_91 trade2_91 sanct_91  topund_91 _91
quietly xtpcse asmprn communist hri_2 hri_2_92 polity polity_92       mildum mildum_92 trade2 trade2_92 sanctions sanct_92  topund topund_92 _92 year, c(a)
test hri_2_92 polity_92    mildum_92 trade2_92 sanct_92  topund_92 _92
quietly xtpcse asmprn communist hri_2 hri_2_93 polity polity_93       mildum mildum_93 trade2 trade2_93 sanctions sanct_93  topund topund_93 _93 year, c(a)
test hri_2_93 polity_93    mildum_93 trade2_93 sanct_93  topund_93 _93
quietly xtpcse asmprn communist hri_2 hri_2_94 polity polity_94       mildum mildum_94 trade2 trade2_94 sanctions sanct_94  topund topund_94 _94 year, c(a)
test hri_2_94 polity_94    mildum_94 trade2_94 sanct_94  topund_94 _94
quietly xtpcse asmprn communist hri_2 hri_2_95 polity polity_95       mildum mildum_95 trade2 trade2_95 sanctions sanct_95  topund topund_95 _95 year, c(a)
test hri_2_95 polity_95    mildum_95 trade2_95 sanct_95  topund_95 _95
quietly xtpcse asmprn communist hri_2 hri_2_96 polity polity_96       mildum mildum_96 trade2 trade2_96 sanctions sanct_96  topund topund_96 _96 year, c(a)
test hri_2_96 polity_96    mildum_96 trade2_96 sanct_96  topund_96 _96
quietly xtpcse asmprn communist hri_2 hri_2_97 polity polity_97       mildum mildum_97 trade2 trade2_97 sanctions sanct_97  topund topund_97 _97 year, c(a)
test hri_2_97 polity_97    mildum_97 trade2_97 sanct_97  topund_97 _97
quietly xtpcse asmprn communist hri_2 hri_2_98 polity polity_98       mildum mildum_98 trade2 trade2_98 sanctions sanct_98  topund topund_98 _98 year, c(a)
test hri_2_98 polity_98    mildum_98 trade2_98 sanct_98  topund_98 _98



