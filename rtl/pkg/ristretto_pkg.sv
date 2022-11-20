`include "pkg/ristretto_if_stage_pkg.sv"
`include "pkg/ristretto_dec_stage_pkg.sv"
`include "pkg/ristretto_exe_stage_pkg.sv"

/*
	This is the TOP package file. It is imported by the core top module and it is meant
	to provide all basic names, structures, macros, functions and so on.
	It contains the packages referring to each stage (Instruction Fetch, Decode, Execution) and in the future it will
	support the packages for global names, like interrupts, CSRs and so on.

	--if_stage_pkg: all structures, macros and functions needed for the instruction fetch stage hardware
	--dec_stage_pkg: all structures, macros and functions needed for the instruction decode stage hardware
	--exe_stage_pkg: all structures, macros and functions needed for the instruction execution stage hardware

	Each package will contain a Type & Enumeration (T) sub-package, a Param & Macros (P) sub-package and a Functions (F) sub-package
	for each significant piece of hardware. Hence you will find these substructure:

	-TopUnit_pkg
		--TopUnit_t_pkg
		--TopUnit_p_package
		--TopUnit_f_package

		--Unit0_pkg
			---Unit0_t_pkg
			---Unit0_p_pkg
			---Unit0_f_pkg

		--UnitN_pkg
			---UnitN_t_pkg
			---UnitN_p_pkg
			---UnitN_f_pkg

	If an Hardware Unit has no package associated with, it is using the base_core packages or no package at all.
*/

package ristretto_pkg;

import ristretto_if_stage_pkg::*;
import ristretto_dec_stage_pkg::*;
import ristretto_exe_stage_pkg::*;

export *::*;

endpackage;
