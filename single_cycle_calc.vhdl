library ieee;
use ieee.std_logic_1164.all;
use iee.numeric_std_.all;

entity calc is
    port(
        I: in std_logic_vector (7 downto 0)
        clk: in std_logic
    );
end entity calc;

architecture operations of calc is 
    component addSub is 
        port(
            input1, input2 : in std_logic_vector (7 downto 0);
            sel : in std_logic; --This will determine add(0) or subtract(1) 
            sum : out std_logic_vector (7 downto 0)
        );
    end component addSub;
    component clockOutput is
        port(
            clk_in : in std_logic;
            clk_out : out std_logic;
            S : in std_logic;
            trigger : in std_logic

        );
    end component clockOutput;
    
    component registers is 
    port(
        regA : in std_logic(1 downto 0);
        regB : in std_logic(1 downto 0);
        regW : in std_logic(7 downto 0);
        WD : in std_logic;
        WE : in std_logic;
        regAOUT : out std_logic;
        regBOUT : out std_logic
    );
    end component registers;

signal trigger, output_clk, WE, display, WDselect, compareout, regAOUT, regBOUT : std_logic;
signal regA, regB, regW : std_logic_vector (1 downto 0);
signal WD, signextend, ALUout (7 downto 0);


begin 

    regfile : registers port map (regA, regB, regW, WD, output_clk, WE, RAOUT, RBOUT)
    ALU : addSub port map (RAOUT, RBOUT, I(7), ALU_out);
    clk_Output : clockOutput port map(clk, output_clk, I(4), trigger);

    --Assign and/or create control singals route instructions.
    --See datapath schematic.
    regB <= I(1 downto 0);
    regW <= I(5 downto 4);
  
    --Print regesiter control signal.
    display <= not (I(7) or I(6) or I(5));
  
    with display select regA <=
      I(1 downto 0) when '0',
      I(4 downto 3) when others;
  
    --Sign extedend the immediate value.
    sign_ext_imm(3 downto 0) <= I(3 downto 0);
    with I(3) select sign_ext_imm(7 downto 4) <=
      "1111" when '1',
      "0000" when others;
  
    --Select whether signed extedend immediate value or ALU results to written to regW.
    WD_sel <= not(I(7) and I(6));
    with WD_sel select WD <=
      sign_ext_imm when '0',
      ALU_out when others;
  
    --Is WD written to regW?
    WE <= I(7) or I(6);
  
    --Used to trigger the skip instruction logic.
    trigger <= (not I(7)) and (not I(6)) and I(5) and cmp_out;
  
    --Compare the value of the two registers; cmp_out is 1 if they are equal.
    cmp_out <= (RAOUT(7) xnor RBOUT(7)) and
              (RAOUT(6) xnor RBOUT(6)) and
              (RAOUT(5) xnor RBOUT(5)) and
              (RAOUT(4) xnor RBOUT(4)) and
              (RAOUT(3) xnor RBOUT(3)) and
              (RAOUT(2) xnor RBOUT(2)) and
              (RAOUT(1) xnor RBOUT(1)) and
              (RAOUT(0) xnor RBOUT(0));
  
    --The display function
    process(output_clk,display) is
      variable int_val : integer;
      begin
        if((output_clk'event and output_clk = '1') and (display = '1')) then
          int_val := to_integer(signed(RAOUT));
  
          --Make the ouput right aligned.
          if(int_val >= 0) then
            if(int_val < 10) then
              report "   " & integer'image(int_val) severity note;
            elsif(int_val < 100) then
              report "  " & integer'image(int_val) severity note;
            else
              report " " & integer'image(int_val) severity note;
            end if;
          else --Display value is negative
            if(int_val > -10) then
              report "  " & integer'image(int_val) severity note;
            elsif(int_val > -100) then
              report " " & integer'image(int_val) severity note;
            else
              report integer'image(int_val) severity note;
            end if;
          end if;
        end if;
    end process;
  end architecture operations;
