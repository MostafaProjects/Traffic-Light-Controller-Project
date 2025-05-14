library ieee;
use ieee.std_logic_1164.all;

entity controleurFeuCirculationFinale is
  port( 
    HorlogeG, ResetG, SSCS: in std_logic;
    MSC, SSC: in std_logic_vector(3 downto 0); 
    MSTL, SSTL: out std_logic_vector(2 downto 0));
	
end controleurFeuCirculationFinale;

architecture rtl of controleurFeuCirculationFinale is

SIGNAL int_compteurExpire, int_rebondisseur, int_sc, int_T, int_sel, int_MST, int_SST, clock : std_logic; 

COMPONENT Rythmeur IS
	PORT(
		i_reset, i_enable, i_clock	: IN	STD_LOGIC;
		MST, SST: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT GreenLightCheck IS
	PORT(
		i_reset, i_clock	: IN	STD_LOGIC;
		SSC, MSC 			: IN	STD_LOGIC_VECTOR(3 downto 0);
		setCompteur, Sel  : IN	STD_LOGIC;
		compteurExpire: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT fsmController is
  port(
    R, CE, MST, SST: in std_logic;   
    clk, reset: in std_logic;
    MSTL, SSTL: out std_logic_vector(2 downto 0); 
    sc, T, sel: out std_logic);
end COMPONENT;

COMPONENT clk_div IS
	PORT(
		clock_25Mhz				: IN	STD_LOGIC;
		clock_1MHz				: OUT	STD_LOGIC;
		clock_100KHz				: OUT	STD_LOGIC;
		clock_10KHz				: OUT	STD_LOGIC;
		clock_1KHz				: OUT	STD_LOGIC;
		clock_100Hz				: OUT	STD_LOGIC;
		clock_10Hz				: OUT	STD_LOGIC;
		clock_1Hz				: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT debouncer IS
	PORT(
		i_raw			: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_clean			: OUT	STD_LOGIC);
END COMPONENT;

BEGIN 

rythmeurTimer: Rythmeur
	PORT MAP(
		i_reset => ResetG, i_enable => int_T, i_clock => clock,
		MST => int_MST, SST => int_SST);

lumiereVerteCheck: GreenLightCheck
	PORT MAP(
		i_reset => ResetG, i_clock => clock, SSC => SSC, MSC => MSC, 
		setCompteur => int_sc, Sel => int_sel, compteurExpire => int_compteurExpire);
		
controleurDeFSM: fsmController
	PORT MAP(
		R => int_rebondisseur, CE => int_compteurExpire, MST => int_MST, SST => int_SST, clk => clock, reset => ResetG, 
		MSTL => MSTL, SSTL => SSTL, sc => int_sc, T => int_T, sel => int_sel);
		
diviseurDorloge: clk_div
	PORT MAP(
		clock_25Mhz => HorlogeG, clock_1MHz => clock);

rebondisseurSS: debouncer
	PORT MAP(
		i_raw => SSCS, i_clock => clock, o_clean => int_rebondisseur);

end rtl;