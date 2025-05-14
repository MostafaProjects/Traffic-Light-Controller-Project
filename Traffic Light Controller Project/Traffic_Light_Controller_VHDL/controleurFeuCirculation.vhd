library ieee;
use ieee.std_logic_1164.all;

entity controleurFeuCirculation is
  port( 
    HorlogeG, ResetG, rebondisseur: in std_logic; --il faudra changer rebondisseur a la composatne donne sur BS 
    MSC, SSC: in std_logic_vector(3 downto 0); 
    MSTL, SSTL: out std_logic_vector(2 downto 0));
	
end controleurFeuCirculation;

architecture rtl of controleurFeuCirculation is

SIGNAL int_compteurExpire, int_sc, int_T, int_sel, int_MST, int_SST : std_logic; 

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

BEGIN 

rythmeurTimer: Rythmeur
	PORT MAP(
		i_reset => ResetG, i_enable => int_T, i_clock => HorlogeG,
		MST => int_MST, SST => int_SST);

lumiereVerteCheck: GreenLightCheck
	PORT MAP(
		i_reset => ResetG, i_clock => HorlogeG, SSC => SSC, MSC => MSC, 
		setCompteur => int_sc, Sel => int_sel, compteurExpire => int_compteurExpire);
		
controleurDeFSM: fsmController
	PORT MAP(
		R => rebondisseur, CE => int_compteurExpire, MST => int_MST, SST => int_SST, clk => HorlogeG, reset => ResetG, 
		MSTL => MSTL, SSTL => SSTL, sc => int_sc, T => int_T, sel => int_sel);

end rtl;