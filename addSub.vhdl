library ieee;
use ieee.std_logic_1164.all;

entity addSub is
    port(
        a: in std_logic_vector(7 downto 0); --this is our RAOUT data
        b: in std_logic_vector(7 downto 0); -- this is our RBOUT data
        sel: in std_logic; --This determines if it is addition(0) or subtraction(1) based off first bit
        sum: out std_logic_vector(7 downto 0) --Sum/difference of RAOUT and RBOUT
    );
end entity addSub;

architecture structural of addSub is --this is the structure of the ALU
    component Adder is
        port(
            a: in std_logic_vector(7 downto 0); --RAOUT
            b: in std_logic_vector(7 downto 0); --RBOUT
            sum: out std_logic_vector(7 downto 0) --result
        );
    end component Adder;

signal rbout_term, rbout_flip, rbout_tcomp: std_logic_vector(7 downto 0); --creates signals for the 2nd term; including inverted and 2's complement
constant one : std_logic_vector(7 downto 0) := "00000001"; --need to add one to change to 2s complement

begin
    adder0: Adder port map(a, rbout_term, sum); --Adds 2 terms together
    adder1: Adder port map(rbout_flip, one, rbout_tcomp); --Uses the adder to convert to 2s complement
    
    rbout_flip <= not(rbout_term); --this sets rbout_flip = to the opposite of the original rbout
    
    with sel select rbout_term <=
        b when '0', --Use regular term when adding
        rbout_tcomp when others; --Uses 2s complement to subtract from a => A - B = A + (-B)
    
end architecture structural;


library ieee;
use ieee.std_logic_1164.all;

entity fullAdder is
    port(
        A: in std_logic;
        B: in std_logic;
        Cin: in std_logic;
        sum: out std_logic;
        Cout: out std_logic
        );
end fullAdder;

architecture structural of fullAdder is
    component halfAdder is
        port(
            A: in std_logic;
            B: in std_logic;
            sum: out std_logic;
            Carry: out std_logic
        );
    end component halfAdder;

signal S1: std_logic;
signal S2: std_logic;
signal S3: std_logic;

begin
    h1: halfAdder port map(a, b, S1, S3);
    h2: halfAdder port map(S1, Cin, sum, S2);
    Cout <= S2 or S3;
end architecture structural;

--- architecture gateLevel of fullAdder is
---    begin
---        S <= A XOR B XOR Cin;
---        Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B);
--- end gateLevel;

library ieee;
use ieee.std_logic_1164.all;

entity halfAdder is
    port(
        A: in std_logic;
        B: in std_logic;
        S: out std_logic;
        Carry: out std_logic
    );
end entity halfAdder;

architecture behavioral of halfAdder is
    begin
        S <= a xor b;
        Carry <= a and b;
end architecture behavioral;