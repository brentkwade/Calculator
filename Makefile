GHDL = ghdl-0.36-macosx-mcode/bin/ghdl
COMP = -a --ieee=standard
EXE = -e --ieee=standard
RUN = -r

default: run-calculator

calculator:
#	Compile VHDL files
	$(GHDL) $(COMP) regFile.vhdl
	$(GHDL) $(COMP) clockOutput.vhdl
	$(GHDL) $(COMP) addSub.vhdl
	#$(GHDL) $(COMP) single_cycle_calc.vhdl
	$(GHDL) $(COMP) calculatorTestBench.vhdl
#	Generate the executable for the test bench
	$(GHDL) $(EXE) calculatorTestBench

run-calculator: calculator
#	Run the test bench
	$(GHDL) $(RUN) calculatorTestBench

dump-calculator_tb: calculator
	$(GHDL) $(RUN) calculatorTestBench --vcd=calculatorTestBench.vcd

clean:
	rm -f *.o *.cf *.out *.vcd

