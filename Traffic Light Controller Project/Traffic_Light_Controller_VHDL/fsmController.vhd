library ieee;
use ieee.std_logic_1164.all;

entity fsmController is
  port(
    R, CE, MST, SST: in std_logic;   
    clk, reset: in std_logic;
    MSTL, SSTL: out std_logic_vector(2 downto 0); 
    sc, T, sel: out std_logic);
end fsmController;

architecture rtl of fsmController is
  signal i_y1, i_y4, i_y2, i_y3: std_logic;
  signal o_y1, o_y4, o_y2, o_y3: std_logic;

  signal o_y1_prime, o_y4_prime, o_y2_prime, o_y3_prime: std_logic;

  component enARdFF_2 is
    port(
      i_reset, i_d, i_enable, i_clock: in std_logic;
      o_q, o_qBar: out std_logic
    );
  end component;
  
  component enARdFF_2_inverted is
    port(
      i_reset, i_d, i_enable, i_clock: in std_logic;
      o_q, o_qBar: out std_logic
    );
  end component;

begin

  dFFy1: enARdFF_2_inverted
    port map(i_d => i_y1,
             i_enable => '1',
             i_clock => clk,
             o_q => o_y1,
             o_qBar => o_y1_prime,
             i_reset => reset);
               
  dFFy2: enARdFF_2
    port map(i_d => i_y2,
             i_enable => '1',
             i_clock => clk,
             o_q => o_y2,
             o_qBar => o_y2_prime,
             i_reset => reset);

  dFFy3: enARdFF_2
    port map(i_d => i_y3,
             i_enable => '1',
             i_clock => clk,
             o_q => o_y3,
             o_qBar => o_y3_prime,
             i_reset => reset);

  dFFy4: enARdFF_2
    port map(i_d => i_y4,
             i_enable => '1',
             i_clock => clk,
             o_q => o_y4,
             o_qBar => o_y4_prime,
             i_reset => reset);
				 
  i_y1 <= (o_y4 and o_y1_prime and o_y2_prime and o_y3_prime and SST) or 
          (o_y1 and o_y4_prime and o_y2_prime and o_y3_prime and (not(CE) or (not(R) and CE)));

  i_y2 <= (o_y1 and o_y4_prime and o_y2_prime and o_y3_prime and R and CE) or 
          (o_y2 and o_y4_prime and o_y1_prime and o_y3_prime and not(MST));

  i_y3 <= (o_y2 and o_y1_prime and o_y4_prime and o_y3_prime and MST) or 
          (o_y3 and o_y1_prime and o_y4_prime and o_y2_prime and not(CE)); 

  i_y4 <= (o_y3 and o_y1_prime and o_y4_prime and o_y2_prime and CE) or 
          (o_y4 and o_y1_prime and o_y3_prime and o_y2_prime and not(SST));


  sel <= o_y1_prime and o_y2_prime and o_y3 and o_y4_prime;

  T <= (o_y1_prime and o_y2 and o_y3_prime and o_y4_prime) or (o_y1_prime and o_y2_prime and o_y3_prime and o_y4);

  sc <= (o_y1 and o_y2_prime and o_y3_prime and o_y4_prime) or 
        (o_y1_prime and o_y2_prime and o_y3 and o_y4_prime);

	MSTL(2) <= o_y1 and o_y2_prime and o_y3_prime and o_y4_prime;
	MSTL(1) <= o_y1_prime and o_y2 and o_y3_prime and o_y4_prime;
	MSTL(0) <= (o_y1_prime and o_y2_prime and o_y3 and o_y4_prime) or (o_y1_prime and o_y2_prime and o_y3_prime and o_y4);
	
	SSTL(2) <= o_y1_prime and o_y2_prime and o_y3 and o_y4_prime;
	SSTL(1) <= o_y1_prime and o_y2_prime and o_y3_prime and o_y4;
	SSTL(0) <= (o_y1 and o_y2_prime and o_y3_prime and o_y4_prime) or (o_y1_prime and o_y2 and o_y3_prime and o_y4_prime);

end rtl;

 

