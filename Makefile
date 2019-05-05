GHDL = ghdl-0.33-x86_64-linux/bin/ghdl.exe
COMP = -a --ieee=standard
EXE = -e --ieee=standard
RUN = -r

default: run-calculator

calculator:
#	Compile VHDL files
	$(GHDL) $(COMP) reg_file.vhdl
	$(GHDL) $(COMP) clk_filter.vhdl
	$(GHDL) $(COMP) addsub_8bit.vhdl
	$(GHDL) $(COMP) calculator.vhdl
	$(GHDL) $(COMP) calculator_tb.vhdl
#	Generate the executable for the test bench
$(GHDL) $(EXE) calculator_tb

run-calculator: calculator
#	Run the test bench
$(GHDL) $(RUN) calculator_tb
