/*******************************************************************************
Program Name: 00_setup.sas
Author:       Haruma Kurita
Date:         11OCT2026
Purpose:      Unpack CDISC Pilot .xpt files into native SAS datasets
Inputs:       ae.xpt, dm.xpt, ds.xpt, ex.xpt
Outputs:      sdtm.ae, sdtm.dm, sdtm.ds, sdtm.ex

Modification History:
Date        Author          Description
----------- --------------- ----------------------------------------------------
07OCT2026   Haruma Kurita   Initial creation.
*******************************************************************************/

/* Establish macro variables for dynamic directory paths */
%let sdtm_path = C:\Users\kuric\Desktop\cdisc-adsl-adae-pipeline\sdtm;
%let adam_path = C:\Users\kuric\Desktop\cdisc-adsl-adae-pipeline\adam;

/* Assign standard libraries for source and target data */
libname sdtm "&sdtm_path.";
libname adam "&adam_path.";

/* Mount XPORT engine libraries to read FDA-standard transport files */
libname x_ae xport "&sdtm_path.\ae.xpt";
libname x_dm xport "&sdtm_path.\dm.xpt";
libname x_ds xport "&sdtm_path.\ds.xpt";
libname x_ex xport "&sdtm_path.\ex.xpt";

/* Unpack transport files into native .sas7bdat format */
proc copy in=x_ae out=sdtm; run;
proc copy in=x_dm out=sdtm; run;
proc copy in=x_ds out=sdtm; run;
proc copy in=x_ex out=sdtm; run;

/* Clear XPORT libraries from memory */
libname x_ae clear;
libname x_dm clear;
libname x_ds clear;
libname x_ex clear;
