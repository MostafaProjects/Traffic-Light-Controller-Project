library IEEE;

use IEEE.STD_LOGIC_1164.ALL;


entity MUX2to1_4bit is

    port(
        IN1, IN2: in std_logic_vector(3 downto 0);
        Sel: in std_logic;
        OUT1: out std_logic_vector(3 downto 0)
    );

end MUX2to1_4bit;
 

architecture rtl OF MUX2to1_4bit is

begin

    OUT1(3) <= ((IN1(3) and not(Sel)) or (IN2(3) and Sel));
    OUT1(2) <= ((IN1(2) and not(Sel)) or (IN2(2) and Sel));
    OUT1(1) <= ((IN1(1) and not(Sel)) or (IN2(1) and Sel));
    OUT1(0) <= ((IN1(0) and not(Sel)) or (IN2(0) and Sel));

end rtl;