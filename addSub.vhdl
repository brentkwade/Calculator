library ieee;
use ieee.std_logic_1164.all;

entity addSub is
    port(
        a: in std_logic_vector(7 downto 0);
        b: in std_logic_vector(7 downto 0);
        sel: in std_logic;
        S: out std_logic_vector(7 downto 0)
    );
end entity addSub;

architecture structural of addSub is
    component Adder is
        port(
            a: in std_logic_vector(7 downto 0);
            b: in std_logic_vector(7 downto 0);
            sum: out std_logic_vector(7 downto 0)
        );
    end component Adder;

--- STILL NEED TO ADD SIGNAL AND SELECT STATEMENTS ---

entity fullAdder is
    port(
        A: in std_logic;
        B: in std_logic;
        Cin: in std_logic;
        S: out std_logic;
        Cout: out std_logic
        );
end fullAdder;

architecture structural of fullAdder is
    component halfAdder is
        port(
            A: in std_logic;
            B: in std_logic;
            S: out std_logic;
            Carry: out std_logic
        );
    end component halfAdder;

signal S1: std_logic;
signal S2: std_logic;
signal S3: std_logic;

begin
    h1: halfAdder port map(a, b, S1, S3);
    h2: halfAdder port map(S1, Cin, Sum, S2);
    Cout <= S2 or S3;
end architecture structural;

--- architecture gateLevel of fullAdder is
---    begin
---        S <= A XOR B XOR Cin;
---        Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B);
--- end gateLevel;

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