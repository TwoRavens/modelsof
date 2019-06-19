/* ColumnNameAdjustments.do */
/* Allcott and Wozny (2011) */

if `import' == 1 {
if `year'==1984 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v13 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS= "NA"
rename v14 MPGCity
gen MPGHwy = .
rename v15 MSRP
}

if `year'==1985 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v13 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS= "NA"
rename v14 MPGCity
rename v15 MPGHwy
rename v16 MSRP
}

if `year'==1986|`year'==1987|`year'==1988|`year'==1989|`year'==1990 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v14 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS= "NA"
rename v15 MPGCity
rename v16 MPGHwy
rename v17 MSRP
}

if `year'>=1991&`year'<=1992 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v14 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS= "NA"
rename v16 MPGCity
rename v17 MPGHwy
rename v18 MSRP
}

if `year'>=1993&`year'<=1995 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v14 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
rename v16 ABS
rename v17 MPGWards
rename v18 MSRP
}
}
*


if `car' == 1 {
* Year-specific adjustments
if `year'==1984 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v13 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS= "NA"
rename v14 MPGCity
gen MPGHwy = .
gen MSRP = ""
}

if `year'>=1985&`year'<=1987 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v13 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS= "NA"
rename v14 MPGCity
rename v15 MPGHwy
gen MSRP = ""
}


if `year'>=1988&`year'<=1989 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v14 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS= "NA"
rename v15 MPGCity
rename v16 MPGHwy
gen MSRP = ""
}

if `year'==1990 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v14 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS= "NA"
rename v15 MPGCity
rename v16 MPGHwy
rename v17 MSRP
}

if `year'>=1991&`year'<=1996 {
rename v2 Wheelbase
rename v6 Weight
rename v7 Cylinders
rename v9 Liters
rename v14 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
rename v16 ABS
rename v17 MPGWards
rename v18 MSRP
}

if `year' == 1997 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v11 Liters
rename v17 HP
rename v18 Torque
rename v21 Traction
gen Stability = "NA"
rename v22 ABS
rename v23 MPGWards
rename v24 MSRP
}
if `year' == 1998 {
gen Submodel=v3
rename v4 Drive
rename v5 Wheelbase
rename v9 Weight
rename v10 Cylinders
rename v12 Liters
rename v18 HP
rename v19 Torque
rename v22 Traction
gen Stability = "NA"
rename v23 ABS
rename v24 MPGWards
rename v25 MSRP
}
if `year' == 1999 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v11 Liters
rename v17 HP
rename v18 Torque
rename v21 Traction
gen Stability = "NA"
rename v22 ABS
rename v23 MPGWards
rename v24 MSRP
}
if `year' == 2000 {

gen Submodel=v3
rename v5 Drive
rename v6 Wheelbase
rename v11 Cylinders
rename v10 Weight
rename v13 Liters
rename v19 HP
rename v20 Torque
rename v23 Traction
gen Stability = "NA"
rename v24 ABS
rename v25 MPGWards
rename v26 MSRP
}
if `year' == 2001 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v11 Liters
rename v17 HP
rename v18 Torque
rename v21 Traction
gen Stability = "NA"
rename v22 ABS
rename v23 MPGWards
rename v24 MSRP
}
if `year' == 2002 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v12 Liters
rename v19 HP
rename v20 Torque
rename v24 Traction
gen Stability = "NA"
rename v25 ABS
rename v26 MPGWards
rename v27 MSRP
}
if `year' == 2003 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v12 Liters
rename v19 HP
rename v20 Torque
rename v24 Traction
gen Stability = "NA"
rename v25 ABS
rename v26 MPGWards
rename v27 MSRP
}

if `year' == 2004 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v12 Liters
rename v19 HP
rename v20 Torque
rename v24 Traction
rename v25 Stability
rename v26 ABS
rename v27 MPGWards
rename v28 MSRP
}
if `year' == 2005 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v12 Liters
rename v19 HP
rename v20 Torque
rename v24 Traction
rename v25 Stability
rename v26 ABS
rename v27 MPGWards
rename v28 MSRP
}
if `year' == 2006 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v12 Liters
rename v19 HP
rename v22 Torque
rename v28 Traction
rename v29 Stability
rename v30 ABS
rename v31 MPGWards
rename v32 MSRP
}
if `year' == 2007 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v12 Liters
rename v20 HP
rename v23 Torque
rename v29 Traction
rename v30 Stability
rename v31 ABS
rename v32 MPGWards
rename v34 MSRP
}
if `year' == 2008 {
gen Submodel=v2
rename v3 Drive
rename v4 Wheelbase
rename v8 Weight
rename v9 Cylinders
rename v12 Liters
rename v21 HP
rename v24 Torque
rename v30 Traction
rename v31 Stability
rename v32 ABS
rename v33 MPGWards
rename v34 MSRP
}

}
*

****************

if `truck' == 1 {

if `year'>=1984 & `year' <= 1988 {
rename v2 Wheelbase
rename v8 Weight
rename v11 Cylinders
rename v13 Liters
rename v17 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS = "NA"
rename v18 MPGCity
gen MPGHwy = .
rename v19 MSRP
}

if `year'>=1989 & `year' <= 1990 {
rename v2 Wheelbase
rename v6 Weight
rename v9 Cylinders
rename v11 Liters
rename v15 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS = "NA"
rename v16 MPGCity
rename v17 MPGHwy
rename v18 MSRP
}


if `year'>=1991 & `year' <= 1992 {
rename v2 Wheelbase
rename v6 Weight
rename v9 Cylinders
rename v11 Liters
rename v15 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
gen ABS = "NA"
rename v17 MPGWards
rename v18 MSRP
}

if `year'>=1993 & `year' <= 1995 {
rename v2 Wheelbase
rename v6 Weight
rename v9 Cylinders
rename v11 Liters
rename v16 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
rename v18 ABS
rename v19 MPGWards
rename v20 MSRP
}

if `year' == 1996 {
rename v3 Wheelbase
rename v7 Weight
rename v9 Cylinders
rename v11 Liters
rename v16 HP
gen Torque = "NA"
gen Traction = "NA"
gen Stability = "NA"
rename v19 ABS
rename v20 MPGWards
rename v21 MSRP
}

if `year' == 1997|`year'==1998|`year'==1999|`year'==2000 {
egen Submodel= concat(v2 v3)
replace Submodel= subinstr(Submodel,"."," ",.)
rename v4 Drive
rename v6 Wheelbase
rename v10 Weight
rename v12 Cylinders
rename v14 Liters
rename v20 HP
rename v21 Torque
rename v24 Traction
gen Stability = "NA"
rename v26 ABS
rename v27 MPGWards
rename v28 MSRP
}


if `year' == 2001 {
gen Submodel=v2
rename v3 Drive
rename v5 Wheelbase
rename v9 Weight
rename v11 Cylinders
rename v13 Liters
rename v19 HP
rename v20 Torque
rename v23 Traction
gen Stability = "NA"
rename v24 ABS
rename v25 MPGWards
rename v26 MSRP
}

if `year' == 2002|`year'==2003 {
gen Submodel=v2
rename v3 Drive
rename v5 Wheelbase
rename v9 Weight
rename v11 Cylinders
rename v14 Liters
rename v21 HP
rename v22 Torque
rename v26 Traction
gen Stability = "NA"
rename v28 ABS
rename v29 MPGWards
rename v30 MSRP
}

if `year' == 2004|`year'==2005 {
gen Submodel=v2
rename v3 Drive
rename v5 Wheelbase
rename v9 Weight
rename v11 Cylinders
rename v14 Liters
rename v21 HP
rename v22 Torque
rename v26 Traction
rename v27 Stability
rename v29 ABS
rename v30 MPGWards
rename v31 MSRP
}


if `year'==2006 {
gen Submodel=v2
rename v3 Drive
rename v5 Wheelbase
rename v9 Weight
rename v11 Cylinders
rename v14 Liters
rename v21 HP
rename v24 Torque
rename v30 Traction
rename v31 Stability
rename v33 ABS
rename v34 MPGWards
rename v35 MSRP
}

if `year' == 2007 {
gen Submodel=v2
rename v3 Drive
rename v5 Wheelbase
rename v9 Weight
rename v11 Cylinders
rename v14 Liters
rename v22 HP
rename v25 Torque
rename v31 Traction
rename v32 Stability
rename v34 ABS
rename v35 MPGWards
rename v37 MSRP
}

if `year' == 2008 {
gen Submodel=v2
rename v3 Drive
rename v5 Wheelbase
rename v9 Weight
rename v11 Cylinders
rename v14 Liters
rename v23 HP
rename v26 Torque
rename v32 Traction
rename v33 Stability
rename v35 ABS
rename v36 MPGWards
rename v37 MSRP
}
}
*
