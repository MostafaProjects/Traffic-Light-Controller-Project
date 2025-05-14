LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fourBitComparator IS
	PORT(
		i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(3 downto 0);  -- 4 bits
		o_GT, o_LT			: OUT	STD_LOGIC;
		o_EQ				: BUFFER	STD_LOGIC;  -- Changement en BUFFER
		o_EQnot				: OUT	STD_LOGIC;  -- Ajout de o_EQnot
		o_GTE			: OUT	STD_LOGIC);
END fourBitComparator;

ARCHITECTURE rtl OF fourBitComparator IS
	SIGNAL int_GT, int_LT : STD_LOGIC_VECTOR(3 downto 0);  -- Signaux internes de 4 bits
	SIGNAL gnd : STD_LOGIC;

	COMPONENT oneBitComparator
	PORT(
		i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC;
		i_Ai, i_Bi			: IN	STD_LOGIC;
		o_GT, o_LT			: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	-- Signal GND pour le premier comparateur
	gnd <= '0';

-- Comparaison du bit de poids fort (bit 3)
comp3: oneBitComparator
	PORT MAP (i_GTPrevious => gnd, 
	          i_LTPrevious => gnd,
			  i_Ai => i_Ai(3),
			  i_Bi => i_Bi(3),
			  o_GT => int_GT(3),
			  o_LT => int_LT(3));

-- Comparaison du bit 2
comp2: oneBitComparator
	PORT MAP (i_GTPrevious => int_GT(3), 
	          i_LTPrevious => int_LT(3),
			  i_Ai => i_Ai(2),
			  i_Bi => i_Bi(2),
			  o_GT => int_GT(2),
			  o_LT => int_LT(2));

-- Comparaison du bit 1
comp1: oneBitComparator
	PORT MAP (i_GTPrevious => int_GT(2), 
	          i_LTPrevious => int_LT(2),
			  i_Ai => i_Ai(1),
			  i_Bi => i_Bi(1),
			  o_GT => int_GT(1),
			  o_LT => int_LT(1));

-- Comparaison du bit de poids faible (bit 0)
comp0: oneBitComparator
	PORT MAP (i_GTPrevious => int_GT(1), 
	          i_LTPrevious => int_LT(1),
			  i_Ai => i_Ai(0),
			  i_Bi => i_Bi(0),
			  o_GT => int_GT(0),
			  o_LT => int_LT(0));

	-- Output Driver
	o_GT <= int_GT(0);
	o_LT <= int_LT(0);
	o_EQ <= int_GT(0) nor int_LT(0);  -- Égalité si ni GT ni LT ne sont vrais
	o_EQnot <= not(o_EQ);  -- Non-égalité (o_EQnot) si o_EQ est faux
	o_GTE <= (int_GT(0)) or (int_GT(0) nor int_LT(0));

END rtl;
