Table 2 - models 5-8
xtlogit newagr lntotdbt lnintgnp rsvsimqt1a lninflt3 govorient burqual regime  gdppct1 prevprogtyt1 y90-y00 nagdur agspline1 agspline2 agspline3  if elig2==1&lnimfquot>0
xtlogit newagr lntotimpt1 rsvsimqt1a lnintgnp  burqual regime govorient lninflt3 gdppct1 prevprogtyt1 y90-y00 nagdur agspline1 agspline2 agspline3  if elig2==1&lnimfquot>0
xtlogit newagr burqual rsvsimqt1a lnintgnp bigdesp lntotdbt regime govorient lninflt3 gdppct1 prevprogtyt1 y90-y00 nagdur agspline1 agspline2 agspline3 if elig2==1&lnimfquot>0
xtlogit newagr lnintgnp bigrsvsa lntotdb burqual rsvsimqt1a regime govorient lninflt3 gdppct1 prevprogtyt1 y90-y00 nagdur agspline1 agspline2 agspline3 if elig2==1&lnimfquot>0


Table 3 - models 3-4
xtlogit newagr lnusimpt1 unvot1 lnintgnp rsvsimqt1a lninflt3  govorient burqual regime gdppct1 prevprogtyt1 y90-y00 nagdur agspline1 agspline2 agspline3  if elig2==1&lnimfquot>0
xtlogit newagr unvot1 unvot12imp unvot12mis lnodaust1 rsvsimqt1a lnintgnp burqual regime govorient lninflt3 gdppct1 prevprogtyt1 y90-y00 nagdur agspline1 agspline2 agspline3  if elig2==1&lnimfquot>0


Table 4 - models 4-6
xtpcse bcpromquot lntotdbt lnintgnp  rsvsimqt1a lninflt1 regime govorient burqual gdppct1 prevprogtyt1 y90-y00 if newagr==1, hetonly
xtpcse bcpromquot lntotdbt bigdesp lnintgnp  rsvsimqt1a lninflt1 regime govorient burqual gdppct1 prevprogtyt1 y90-y00 if newagr==1, hetonly
xtpcse bcpromquot lnusimpt1 lnodaus unvot1 lnintgnp  rsvsimqt1a lninflt1 regime govorient burqual gdppct1 prevprogtyt1 y90-y00 if newagr==1, hetonly


Table 5 - models 4-6
xtlogit active lntotdbt unvot1 lnintgnp rsvsimqt1a lninflt1 lninflchg12 regime govorient burqual gdppct1 mills13u y90-y00 faildur failspline1 failspline2 failspline3 if agr==1
xtlogit active rsvsimqt1a lnintgnp bigdesp lntotdbt   lninflt1 lninflchg12 burqual  regime govorient gdppct1 mills13b y90-y00  faildur failspline1 failspline2 failspline3 if agr==1
xtlogit active lnusimpt1  lnodaus lninflt1 lninflchg12  rsvsimqt1a  lnintgnp regime burqual govorient gdppct1 mills13w y90-y00  faildur failspline1 failspline2 failspline3 if agr==1
