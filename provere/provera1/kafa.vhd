----------------------------------------------------------------------------------
-- Prva provera, 13.3.2019.
-- Aleksa Rodic RA218-2015
-- Druga grupa
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity kafa is
    Port ( clk                 : in  STD_LOGIC;
           reset_n             : in  STD_LOGIC;
           coin_avail          : in  STD_LOGIC;
           water_avail         : in  STD_LOGIC;
           coffee_powder_avail : in  STD_LOGIC;
           plastic_glass_avail : in  STD_LOGIC;
           plastic_glass       : out STD_LOGIC;
           coffee_powder       : out STD_LOGIC;
           hot_water           : out STD_LOGIC;
           unlock              : out STD_LOGIC;
           coin_return         : out STD_LOGIC
         );
end kafa;

architecture Behavioral of kafa is

  type STANJA_KAFEMATA_t is (IDLE, UZMI_CASU, SIPAJ_KAFU, SIPAJ_VODU, OTKLJUCAJ);

  -- Automat
  signal trenutno_stanje : STANJA_KAFEMATA_t;
  signal trenutno_stanje_next : STANJA_KAFEMATA_t;

  -- Brojac
  signal brojac_s : std_logic_vector (7 downto 0);
  signal brojac_next_s : std_logic_vector (7 downto 0);
  signal timer1 : STD_LOGIC;
  signal startuj_tajmer_s : STD_LOGIC;

  -- Izlazne vrednosti
  signal plastic_glass_s : STD_LOGIC;
  signal coffee_powder_s : STD_LOGIC;
  signal hot_water_s : STD_LOGIC;
  signal unlock_s : STD_LOGIC;
  signal coin_return_s : STD_LOGIC;

begin

  -- Brojac
  process (clk, reset_n) begin
    if (reset_n = '0') then
      brojac_s <= (others => '0');
    elsif (clk'event and clk = '1') then
      brojac_s <= brojac_next_s;
    end if;
  end process;

  -- Logika brojaca
  process (brojac_s, startuj_tajmer_s) begin
    if (startuj_tajmer_s = '1') then
      if (brojac_s = x"05") then
        brojac_next_s <= (others => '0');
        timer1 <= '1';
      else
        brojac_next_s <= brojac_s + 1;
        timer1 <= '0';
      end if;
    else
      timer1 <= '0';
      brojac_next_s <= (others => '0');
    end if;
  end process;

  -- Flip flop, registar
  process (clk, reset_n) begin
    if (reset_n = '0') then
      trenutno_stanje <= IDLE;
    elsif (clk'event and clk = '1') then
      trenutno_stanje <= trenutno_stanje_next;
    end if;
  end process;

  -- Logika automata
  process (trenutno_stanje, coin_avail, water_avail, coffee_powder_avail, plastic_glass_avail) begin
    case trenutno_stanje is 
      when IDLE => 
        if (coin_avail = '1' and water_avail = '1' and coffee_powder_avail = '1' and plastic_glass_avail = '1') then

          -- Stanja izlaznih indikatora, svi indikatori na 0
          startuj_tajmer_s <= '0';
          plastic_glass_s <= '0';
          coffee_powder_s <= '0';
          hot_water_s <= '0';
          unlock_s <= '0';
          coin_return_s <= '0';

          trenutno_stanje_next <= UZMI_CASU;
        elsif (coin_avail = '1' and (water_avail = '0' or coffee_powder_avail = '0' or plastic_glass_avail = '0')) then

          -- Stanja izlaznih indikatora
          startuj_tajmer_s <= '0';
          plastic_glass_s <= '0';
          coffee_powder_s <= '0';
          hot_water_s <= '0';
          unlock_s <= '0';
          coin_return_s <= '1';  -- Ako nemamo "materijala" vracamo dinar

          trenutno_stanje_next <= IDLE;
        else

          -- Stanja izlaznih indikatora, svi indikatori na 0
          startuj_tajmer_s <= '0';
          plastic_glass_s <= '0';
          coffee_powder_s <= '0';
          hot_water_s <= '0';
          unlock_s <= '0';
          coin_return_s <= '0';

          trenutno_stanje_next <= IDLE;
        end if;

      when UZMI_CASU =>
        -- Stanja izlaznih indikatora
        startuj_tajmer_s <= '1';
        plastic_glass_s <= '1';  -- Uzimamo i stavljamo casu na predvidjeno mesto
        coffee_powder_s <= '0';
        hot_water_s <= '0';
        unlock_s <= '0';
        coin_return_s <= '0';

        -- Cekamo na tajmer
        if (timer1 = '1') then
          trenutno_stanje_next <= SIPAJ_KAFU;
          startuj_tajmer_s <= '0';
        else
          trenutno_stanje_next <= UZMI_CASU;
        end if;
        
      when SIPAJ_KAFU =>
        -- Stanja izlaznih indikatora
        startuj_tajmer_s <= '1';
        plastic_glass_s <= '0';
        coffee_powder_s <= '1';  -- Sipamo kafu u solju
        hot_water_s <= '0';
        unlock_s <= '0';
        coin_return_s <= '0';

        -- Cekamo na tajmer
        if (timer1 = '1') then
          trenutno_stanje_next <= SIPAJ_VODU;
          startuj_tajmer_s <= '0';
        else
          trenutno_stanje_next <= SIPAJ_KAFU;
        end if;

      when SIPAJ_VODU =>
        -- Stanja izlaznih indikatora
        startuj_tajmer_s <= '1';
        plastic_glass_s <= '0';
        coffee_powder_s <= '0';
        hot_water_s <= '1';  -- Sipamo vodu u solju
        unlock_s <= '0';
        coin_return_s <= '0'; 

        -- Cekamo na tajmer
        if (timer1 = '1') then
          trenutno_stanje_next <= OTKLJUCAJ;
          startuj_tajmer_s <= '0';
        else
          trenutno_stanje_next <= SIPAJ_VODU;
        end if;

      when OTKLJUCAJ =>
        -- Stanja izlaznih indikatora
        startuj_tajmer_s <= '1';
        plastic_glass_s <= '0';
        coffee_powder_s <= '0';
        hot_water_s <= '0';
        unlock_s <= '1';  -- Otkljucaj prostor za kasu i drzi ga otkljucanog
        coin_return_s <= '0';

        -- Cekamo na tajmer
        if (timer1 = '1') then
          trenutno_stanje_next <= IDLE;
          startuj_tajmer_s <= '0';
        else
          trenutno_stanje_next <= OTKLJUCAJ;
        end if;
    end case;
  end process;

  -- Povezujemo signale sa izlazima
  plastic_glass <= plastic_glass_s;
  coffee_powder <= coffee_powder_s;
  hot_water <= hot_water_s;
  unlock <= unlock_s;
  coin_return <= coin_return_s;


end Behavioral;
