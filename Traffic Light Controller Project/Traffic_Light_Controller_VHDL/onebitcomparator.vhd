LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY oneBitComparator IS
	PORT(
		i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC;
		i_Ai, i_Bi			: IN	STD_LOGIC;
		o_GT, o_LT, o_EQ, o_NEQ		: OUT	STD_LOGIC);  -- Ajout de la sortie o_NEQ
END oneBitComparator;

ARCHITECTURE rtl OF oneBitComparator IS
	SIGNAL int_GT1, int_GT2, int_LT1, int_LT2 : STD_LOGIC;
	SIGNAL int_GT, int_LT, int_EQ, int_NEQ : STD_LOGIC;  -- Ajout du signal interne int_NEQ

BEGIN

	-- Concurrent Signal Assignment for GT
	int_GT1 <= not(i_GTPrevious) and not(i_LTPrevious) and i_Ai and not(i_Bi);
	int_GT2 <= i_GTPrevious and not(i_LTPrevious);
	int_GT <= int_GT1 or int_GT2;

	-- Concurrent Signal Assignment for LT
	int_LT1 <= not(i_GTPrevious) and not(i_LTPrevious) and not(i_Ai) and i_Bi;
	int_LT2 <= not(i_GTPrevious) and i_LTPrevious;
	int_LT <= int_LT1 or int_LT2;

	-- Concurrent Signal Assignment for EQ
	int_EQ <= not(int_GT) and not(int_LT);  -- L'égalité est vraie si GT et LT sont tous les deux à 0

	-- Concurrent Signal Assignment for NEQ (Ajout de la logique pour la non-égalité)
	int_NEQ <= not(int_EQ);  -- Non-égalité est vraie si égalité est fausse

	-- Output Driver
	o_GT <= int_GT;
	o_LT <= int_LT;
	o_EQ <= int_EQ;
	o_NEQ <= int_NEQ;  -- Conduire la sortie o_NEQ

END rtl;
