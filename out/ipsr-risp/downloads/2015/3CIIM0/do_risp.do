
use dataset_def_risp.dta, replace

**************************************************************************************************
* Table 3. Non-nested model: representation
reg rep u1 u2 u3 u4, b
predict ru

reg rep i1 i2 i3, b
predict ri

reg rep c1 c2, b
predict rc

reg rep u1 u2 u3 u4 ri rc, b
reg rep i1 i2 i3 ru rc, b
reg rep c1 c2 ru ri, b

**************************************************************************************************
* Table 4. Non-nested model: identity

reg ident u1 u2 u3 u4, b
predict iu

reg ident i1 i2 i3, b
predict ii

reg ident c1 c2, b
predict ic

reg ident u1 u2 u3 u4 ii ic, b
reg ident i1 i2 i3 iu ic, b
reg ident c1 c2 iu ii, b

**************************************************************************************************
* Table 5. Non-nested model: policy scope
reg scope u1 u2 u3 u4, b
predict su

reg scope i1 i2 i3, b
predict si

reg scope c1 c2, b
predict sc

reg scope u1 u2 u3 u4 si sc, b
reg scope i1 i2 i3 su sc, b
reg scope c1 c2 su si, b

****************
* Table 6. Cumulative model of representation, identity, and policy scope

reg rep u1 u2 u3 u4 i3 ru ri rc, b

reg ident u4 i2 c1 iu ii ic, b

reg scope u3 i2 i3 c2 su si sc, b

