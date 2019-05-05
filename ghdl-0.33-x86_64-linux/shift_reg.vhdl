library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is
port(	I:	in std_logic_vector (3 downto 0); -- for loading
		I_SHIFT_IN: in std_logic; -- shifted in bit for both left and right
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; -- positive level triggering in problem 3
		enable:		in std_logic; -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(3 downto 0) -- output the current register content
);
end shift_reg;

architecture behav of shift_reg is
begin
O <= I;	-- WRONG! You must replace it with your implementation.
end behav;

