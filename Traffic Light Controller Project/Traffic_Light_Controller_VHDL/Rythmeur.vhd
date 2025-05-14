LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Rythmeur IS
	PORT(
		i_reset, i_enable, i_clock	: IN	STD_LOGIC;
		MST, SST: OUT	STD_LOGIC);
END Rythmeur;

ARCHITECTURE rtl OF Rythmeur IS
SIGNAL int_y3, int_y2, int_y1, int_y0: STD_LOGIC;
SIGNAL int_Y3D, int_Y2D, int_Y1D, int_Y0D: STD_LOGIC;

COMPONENT enARdFF_2 IS
	PORT(
		i_reset	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q			: OUT	STD_LOGIC);
END COMPONENT;

BEGIN

bit0: enARdFF_2
	PORT MAP(
		i_reset => i_reset, i_d => int_Y0D, i_enable => '1', i_clock => i_clock, o_q => int_y0);

bit1: enARdFF_2
	PORT MAP(
		i_reset => i_reset, i_d => int_Y1D, i_enable => '1', i_clock => i_clock, o_q => int_y1);
		
bit2: enARdFF_2
	PORT MAP(
		i_reset => i_reset, i_d => int_Y2D, i_enable => '1', i_clock => i_clock, o_q => int_y2);
		
bit3: enARdFF_2
	PORT MAP(
		i_reset => i_reset, i_d => int_Y3D, i_enable => '1', i_clock => i_clock, o_q => int_y3);
		
int_Y3D <= (int_y3 or (int_y2 and int_y1 and int_y0)) and (i_enable);
int_Y2D <= ((int_y2 and not(int_y1)) or (int_y2 and not(int_y0)) or (int_y3 and int_y2) or (not(int_y2) and int_y1 and int_y0)) and(i_enable);
int_Y1D <= ((int_y1 xor int_y0) or (int_y3 and int_y2 and int_y1)) and (i_enable);
int_Y0D <= (not(int_y0) or (int_y3 and int_y2 and int_y1)) and (i_enable);

--on peut changer ces sorties. MST est mis compteur = 3 et SST est mis a compteur = 2
MST <= not(int_y3) and not(int_y2) and int_y1 and int_y0; 
SST <= not(int_y3) and not(int_y2) and not(int_y0) and int_y1;

END rtl;