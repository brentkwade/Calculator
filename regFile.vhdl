library ieee;
use ieee.std_logic_1164.all;

entity regFile is
    port(
        CLK: in std_logic;
        regA: in std_logic_vector(1 downto 0);
        regB: in std_logic_vector(1 downto 0);
        regW: in std_logic_vector(7 downto 0);
        WD: in std_logic_vector;
        WE: in std_logic;
        regAOUT: out std_logic_vector(7 downto 0);
        regBOUT: out std_logic_vector(7 downto 0)
    );
end regFile;

architecture behavioral of regFile is
    signal R0: std_logic_vector(7 downto 0) := "00000000";
    signal R1: std_logic_vector(7 downto 0) := "00000000";
    signal R2: std_logic_vector(7 downto 0) := "00000000";
    signal R3: std_logic_vector(7 downto 0) := "00000000";
    begin
        with regA select regAOUT <=
            R0 when "00",
            R1 when "01",
            R2 when "10",
            R3 when others;
        with regB select regBOUT <=
            R0 when "00",
            R1 when "01",
            R2 when "10",
            R3 when others;

        process (CLK) is
            begin
                if (CLK'event and CLK='1') then
                    if (WE='1') then
                        if (regW="00") then
                            R0 <= WD;
                        elsif (regW="01") then
                            R1 <= WD;
                        elsif (regW="10") then
                            R2 <= WD;
                        elsif (regW="11") then
                            R3 <= WD;
                        end if;
                    end if;
                end if;
            end process;
        end architecture;