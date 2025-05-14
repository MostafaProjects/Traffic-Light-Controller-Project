LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY GreenLightCheck IS
	PORT(
		i_reset, i_clock	: IN	STD_LOGIC;
		SSC, MSC 			: IN	STD_LOGIC_VECTOR(3 downto 0);
		setCompteur, Sel  : IN	STD_LOGIC;
		compteurExpire: OUT	STD_LOGIC);
END GreenLightCheck;

ARCHITECTURE rtl OF GreenLightCheck IS

SIGNAL int_compteurMS, int_compteurSS : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL int_MUXcompteurSortie, int_MUXTimeGreenLightSortie : STD_LOGIC_VECTOR(3 downto 0);

COMPONENT MUX2to1_4bit 
    PORT(
        IN1, IN2: in std_logic_vector(3 downto 0);
        Sel: in std_logic;
        OUT1: out std_logic_vector(3 downto 0)
    );
END COMPONENT;

COMPONENT CompteurMSetSS IS
	PORT(
		i_reset, i_enable, i_clock	: IN	STD_LOGIC;
		o_conteurValeur: OUT	STD_LOGIC_VECTOR(3 downto 0));
END COMPONENT;

COMPONENT fourBitComparator 
	PORT(
		i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(3 downto 0);  -- 4 bits
		o_GTE			: OUT	STD_LOGIC);
END COMPONENT;


BEGIN

CompteurMS : CompteurMSetSS
	PORT MAP(
		i_reset => i_reset, i_enable => setCompteur, i_clock => i_clock, o_conteurValeur => int_compteurMS);
		
CompteurSS : CompteurMSetSS
	PORT MAP(
		i_reset => i_reset, i_enable => setCompteur, i_clock => i_clock, o_conteurValeur => int_compteurSS);

MUXCompteur: MUX2to1_4bit
	PORT MAP(
		IN1 => int_compteurMS, IN2 => int_compteurSS, Sel => Sel, OUT1 => int_MUXcompteurSortie);
		
MUXTimeGreenLight: MUX2to1_4bit
	PORT MAP(
		IN1 => MSC, IN2 => SSC, Sel => Sel, OUT1 => int_MUXTimeGreenLightSortie);
		
ComparateurCompteur: fourBitComparator
	PORT MAP(
		i_Ai => int_MUXcompteurSortie, i_Bi => int_MUXTimeGreenLightSortie, o_GTE => compteurExpire);
		
END rtl;