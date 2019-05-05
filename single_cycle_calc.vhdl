library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calc is

    port(
        I: in std_logic_vector (7 downto 0) --input value
        clk: in std_logic -- clk; either 1 or 0
    );

end entity calc;

architecture operations of calc is 

    component addSub is 

        port(
            input1, input2 : in std_logic_vector (7 downto 0); --referring to RA and RB out
            sel : in std_logic; --This will determine add(0) or subtract(1) 
            sum : out std_logic_vector (7 downto 0) --combines result of input1 and input2
        );

    end component addSub;

    component clockOutput is
        port(
            clk_out : in std_logic; --clk before it goes through the mux
            clk_in : out std_logic; --clk after it goes through the mux
            Skip2 : in std_logic; -- this indicates bit I<4>
            comp_skip : in std_logic -- result of compare and opcode

        );
    end component clockOutput;
    
    component registers is 

    port(
        RA : in std_logic(1 downto 0); --bits I(3:2)
        RB : in std_logic(1 downto 0); --bits I(1:0) or (4:3)
        RW : in std_logic(7 downto 0); --Either 8 bit adder/sub or LI value
        WD : in std_logic; --determines if load or adder value
        WE : in std_logic; --'1' if data is stored eg, Li, Add/Sub
        regAOUT : out std_logic_vector(7 downto 0); --first register output
        regBOUT : out std_logic_vector(7 downto 0) -- second register output
    );

    end component registers;

  --All necessary signals within the calculator
signal comp_skip, output_clk, WE, display, WDselect, compareout : std_logic;

signal regA, regB, regW : std_logic_vector (1 downto 0);
signal WD, signextend, ALUout, regAOUT, regBOUT (7 downto 0);


begin 
      --Assigning ports 
    regfile : registers port map (regA, regB, regW, WD, output_clk, WE, RAOUT, RBOUT)
    ALU : addSub port map (regAOUT, regBOUT, I(7), ALUout);
    clk_Output : clockOutput port map(clk, clkfilter, I(4), cskip);

    --RegA is the RS register, and regW is the RD; shown on schematic
    regA <= I(3 downto 2);
    regW <= I(5 downto 4);
  
    --This nots the opcode values to determine if the opcode calls for display or another command
    display <= not (I(7) or I(6) or I(5)); --if this value is 1, the command is display
  
    with display select regB <=
      I(1 downto 0) when '0',
      I(4 downto 3) when others;
  
    --Sign extended immediate load value
    signextend(3 downto 0) <= I(3 downto 0);
    with I(3) select signextend(7 downto 4) <=
      "1111" when '1',
      "0000" when others;
  
    --Select whether signed extedend immediate value or ALU results to written to regW.
    WD_sel <= not(I(7) and I(6));
    with WD_sel select WD <=
      signextend when '0',
      ALU_out when others;
  
    --Based on the opcode, says whether info is saved or not
    WE <= I(7) or I(6);
  
    --Used to comp_skip the skip instruction logic.
    comp_skip <= (not I(7)) and (not I(6)) and I(5) and cmp_out;
  
    --Compares the RS and RT registers. Returns 1 if they are EXACTLY the same
    cmp_out <= not ((regA(0)) xor (regB(0))) and
              not ((regA(1)) xor (regB(1))) and  
              not ((regA(2)) xor (regB(2))) and 
              not ((regA(3)) xor (regB(3))) and 
              not ((regA(4)) xor (regB(4))) and  
              not ((regA(5)) xor (regB(5))) and 
              not ((regA(6)) xor (regB(6))) and  
              not ((regA(7)) xor (regB(7))); 
  
    --This determines the display function output
    process(clkfilter,display) is

      variable print_reg : integer;
      begin
        if((clkfilter'event and clkfilter = '1') and (display = '1')) then
          print_reg := to_integer(signed(RAOUT));
  
          --Make the ouput right aligned.
          if(print_reg >= 0) then
            if(print_reg < 10) then
              report "   " & integer'image(print_reg) severity note;

            elsif(print_reg < 100) then
              report "  " & integer'image(print_reg) severity note;

            else
              report " " & integer'image(print_reg) severity note;
            end if;

          else --Display value is negative
            if(print_reg > -10) then
              report "  " & integer'image(print_reg) severity note;

            elsif(print_reg > -100) then
              report " " & integer'image(print_reg) severity note;

            else
              report integer'image(print_reg) severity note;
            end if;
          end if;
        end if;
    end process;
  end architecture operations;