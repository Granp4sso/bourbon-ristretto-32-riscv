
#Variables

VERILATOR = /usr/share/verilator/include
FILENAME =  beta_top
OLDFILENAME = beta_if_stage
TESTBENCH = $(FILENAME)_tb


WARNINGSBYPASS = -Wno-UNUSED -Wno-PINCONNECTEMPTY -Wno-SYNCASYNCNET #-Wno-LATCH 

#Targets

verilate_traced: traced tbchange
	g++ -I $(VERILATOR) -I rtl/obj_dir $(VERILATOR)/verilated.cpp $(VERILATOR)/verilated_vcd_c.cpp $(TESTBENCH).cpp rtl/obj_dir/V$(FILENAME)__ALL.a -o exec_$(FILENAME)

tbchange:
	mv $(OLDFILENAME)_tb.cpp $(TESTBENCH).cpp; sed -i 's/$(OLDFILENAME)/$(FILENAME)/g' $(TESTBENCH).cpp

traced:
	cd rtl; verilator -Wall $(WARNINGSBYPASS) --top-module $(FILENAME) --trace -cc $(FILENAME).sv; cd obj_dir; make -f V$(FILENAME).mk

clear:
	rm -r rtl/obj_dir
	rm exec_$(FILENAME)
	rm trace.vcd
