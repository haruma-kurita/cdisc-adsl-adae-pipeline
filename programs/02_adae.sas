/*******************************************************************************
Program Name: 02_adae.sas
Author:       Haruma Kurita
Date:         12 OCT2026
Purpose:      Derive Adverse Events Analysis Dataset (ADAE) using DATA steps
Inputs:       sdtm.ae, adam.adsl
Outputs:      adam.adae

Modification History:
Date        Author          Description
----------- --------------- ----------------------------------------------------
12OCT2026   Haruma Kurita   Initial creation.
*******************************************************************************/

/* Establish macro variables for dynamic directory paths */
%let sdtm_path = C:\Users\kuric\Desktop\cdisc-adsl-adae-pipeline\sdtm;
%let adam_path = C:\Users\kuric\Desktop\cdisc-adsl-adae-pipeline\adam;

/* Assign standard libraries for source and target data */
libname sdtm "&sdtm_path.";
libname adam "&adam_path.";

/*******************************************************************************
  SECTION 1: Merging the SDTM.AE to ADAM.ADSL and creating adam.ADAE
*******************************************************************************/
proc sort data=sdtm.ae out=sorted_ae;
	by USUBJID;
run;

proc sort data=adam.adsl out=sorted_adsl;
	by USUBJID;
run;

data adam.ADAE;
	retain USUBJID TRTA TRTSDT AETERM AEDECOD AESEV ASTDT ASTDY TRTEMFL;
	merge sorted_ae (in=a) sorted_adsl (in=b);
	by USUBJID;
	if a;

/* Actual Treatment */
	TRTA = TRT01A;

/*Analysis Start Date*/
	ASTDT = input(AESTDTC, yymmdd10.);
	format ASTDT yymmdd10.;

/* Analysis Start Relative Day & Treatment Emergent Flag */
	if nmiss(ASTDT, TRTSDT) = 0 then do;
		if ASTDT >= TRTSDT then do;
			ASTDY = (ASTDT - TRTSDT + 1);
			TRTEMFL = 'Y';
		end;
		else if ASTDT < TRTSDT then do;
			ASTDY = (ASTDT - TRTSDT);
		end;
	end;

	KEEP USUBJID TRTA TRTSDT AETERM AEDECOD AESEV ASTDT ASTDY TRTEMFL;
run;

proc print data=adam.ADAE(obs=10);
run;

