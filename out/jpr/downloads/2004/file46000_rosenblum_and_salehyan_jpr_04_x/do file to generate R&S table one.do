**The following commands generate the B and beta coefs for models 1, 2a, and 2b in table one:

*M1
miest jpr xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year, c(a)
miest jpr xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year_std, c(a)

*M2a
miest jpr xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <=1992, c(a)
miest jpr xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year_std if year <=1992, c(a)

*M2b
miest jpr xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >1992, c(a)
miest jpr xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year_std if year >1992, c(a)

***************************************
**F-tests for joint interest-based and normative hyps (middle band of table I); reported results are the average chi-square scores across all five data sets

use jpr1

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year , c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )


quietly xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year if year <1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year if year >=1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )

use jpr2

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year , c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )


quietly xtpcse asmprn_std communist_std hri_2_std  polity_std    mildum_std trade2_std sanct_std top_std year if year <1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std    mildum_std trade2_std sanct_std top_std year if year >=1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )


use jpr3

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year , c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )


quietly xtpcse asmprn_std communist_std hri_2_std  polity_std    mildum_std trade2_std sanct_std top_std year if year <1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std    mildum_std trade2_std sanct_std top_std year if year >=1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )


use jpr4

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year , c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )


quietly xtpcse asmprn_std communist_std hri_2_std  polity_std    mildum_std trade2_std sanct_std top_std year if year <1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std    mildum_std trade2_std sanct_std top_std year if year >=1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )


use jpr5

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std  mildum_std trade2_std sanct_std top_std year , c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )


quietly xtpcse asmprn_std communist_std hri_2_std  polity_std    mildum_std trade2_std sanct_std top_std year if year <1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )
test (-mildum_std - trade2_std + sanct_std - top_std + communist_std) = (hri_2_std - polity_std  )

quietly xtpcse asmprn_std communist_std hri_2_std  polity_std    mildum_std trade2_std sanct_std top_std year if year >=1993, c(a)
test hri_2_std polity_std
test mildum_std trade2_std sanct_std  top_std
test (-mildum_std - trade2_std + sanct_std - top_std) = (hri_2_std - polity_std  )

********************************************

**diagnostic statistics reported in bottom six rows of table one; reported results are the avgerage across five imputed datasets.

use jpr1
**M1
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
fitstat

**M2a
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
fitstat

**M2b
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
fitstat

use jpr2
**M1
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
fitstat

**M2a
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
fitstat

**M2b
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
fitstat

use jpr3
**M1
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
fitstat

**M2a
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
fitstat

**M2b
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
fitstat


use jpr4
**M1
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
fitstat

**M2a
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
fitstat

**M2b
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
fitstat

use jpr5
**M1
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year
fitstat

**M2a
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year <1993
fitstat

**M2b
xtpcse asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993, c(a)
prais asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
quietly reg asmprn communist hri_2  polity  mildum trade2 sanctions  topund year if year >=1993
fitstat


