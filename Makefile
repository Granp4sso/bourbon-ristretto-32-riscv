
#Variables

VERILATOR = /usr/share/verilator/include
FILENAME =  ristretto_top
OLDFILENAME = ristretto_if_stage
TESTBENCH = c_tb/$(FILENAME)_tb
TESTBENCH_DEP = c_tb/mem


WARNINGSBYPASS = -Wno-UNUSED -Wno-PINCONNECTEMPTY -Wno-SYNCASYNCNET -Wno-IMPORTSTAR #-Wno-LATCH 

#Targets

verilate_traced: traced tbchange
	g++ -I $(VERILATOR) -I rtl/obj_dir -I c_tb $(VERILATOR)/verilated.cpp $(VERILATOR)/verilated_vcd_c.cpp $(TESTBENCH).cpp $(TESTBENCH_DEP).cpp rtl/obj_dir/V$(FILENAME)__ALL.a -o exec_$(FILENAME)

tbchange:
	mv $(OLDFILENAME)_tb.cpp $(TESTBENCH).cpp; sed -i 's/$(OLDFILENAME)/$(FILENAME)/g' $(TESTBENCH).cpp

traced:
	cd rtl; verilator -Wall $(WARNINGSBYPASS) --top-module $(FILENAME) --trace -cc $(FILENAME).sv; cd obj_dir; make -f V$(FILENAME).mk

clear:
	rm -r rtl/obj_dir
	rm exec_$(FILENAME)
	rm trace.vcd
