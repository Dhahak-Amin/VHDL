library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Compteur8Bits is
    Port (
        CK     : in std_logic;
        RST    : in std_logic;
        LOAD   : in std_logic;
        SENS   : in std_logic;
        EN     : in std_logic;
        Din    : in std_logic_vector(7 downto 0);
        Dout   : out std_logic_vector(7 downto 0)
    );
end Compteur8Bits;

architecture Behavioral of Compteur8Bits is
    signal count : std_logic_vector(7 downto 0) := (others => '0');
begin
    process (CK)
    begin
        if rising_edge(CK) then
            if RST = '0' then -- Reset synchrone actif bas
                count <= (others => '0');
            elsif LOAD = '1' then -- Chargement de la valeur Din
                count <= Din;
            elsif EN = '0' then -- Enable actif bas
                if SENS = '1' then
                    count <= count + 1; -- Incrémentation
                else
                    count <= count - 1; -- Décrémentation
                end if;
            end if;
        end if;
    end process;
    
    Dout <= count;
end Behavioral;

-- Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Test_Compteur8Bits is
end Test_Compteur8Bits;

architecture tb of Test_Compteur8Bits is
    signal CK     : std_logic := '0';
    signal RST    : std_logic := '1';
    signal LOAD   : std_logic := '0';
    signal SENS   : std_logic := '1';
    signal EN     : std_logic := '1';
    signal Din    : std_logic_vector(7 downto 0) := "00000000";
    signal Dout   : std_logic_vector(7 downto 0);

    constant PERIOD : time := 10 ns;

    -- Instanciation du compteur
    component Compteur8Bits
        Port (
            CK     : in std_logic;
            RST    : in std_logic;
            LOAD   : in std_logic;
            SENS   : in std_logic;
            EN     : in std_logic;
            Din    : in std_logic_vector(7 downto 0);
            Dout   : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    UUT: Compteur8Bits port map (
        CK => CK, RST => RST, LOAD => LOAD, SENS => SENS, EN => EN, Din => Din, Dout => Dout
    );
    
    -- Génération de l'horloge
    process
    begin
        while true loop
            CK <= '0'; wait for PERIOD/2;
            CK <= '1'; wait for PERIOD/2;
        end loop;
    end process;
    
    -- Stimulus
    process
    begin
        wait for 20 ns;
        RST <= '0';  -- Reset
        wait for 20 ns;
        RST <= '1';  -- Fin reset
        wait for 20 ns;
        LOAD <= '1'; Din <= "00001010";  -- Chargement de 10
        wait for 10 ns;
        LOAD <= '0';
        wait for 20 ns;
        EN <= '0';  -- Activation du comptage
        wait for 80 ns;
        SENS <= '0'; -- Changement de sens (décrémentation)
        wait for 80 ns;
        EN <= '1';  -- Désactivation du comptage
        wait for 40 ns;
        report "Simulation terminée";
        wait;
    end process;
end tb;
