library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Compteur16Bits is
    Port (
        CK     : in std_logic;
        RST    : in std_logic;
        LOAD   : in std_logic;
        SENS   : in std_logic;
        EN     : in std_logic;
        Din    : in std_logic_vector(15 downto 0);
        Dout   : out std_logic_vector(15 downto 0)
    );
end Compteur16Bits;

architecture Behavioral of Compteur16Bits is
    signal count : std_logic_vector(15 downto 0) := (others => '0');
begin
    Dout <= count;
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
end Behavioral;

-- Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Test_Compteur16Bits is
end Test_Compteur16Bits;

architecture tb of Test_Compteur16Bits is
    signal CK     : std_logic := '0';
    signal RST    : std_logic := '1';
    signal LOAD   : std_logic := '0';
    signal SENS   : std_logic := '1';
    signal EN     : std_logic := '1';
    signal Din    : std_logic_vector(15 downto 0) := (others => '0');
    signal Dout   : std_logic_vector(15 downto 0);

    constant PERIOD : time := 10 ns;

    -- Instanciation du compteur
    component Compteur8Bits
        Port (
            CK     : in std_logic;
            RST    : in std_logic;
            LOAD   : in std_logic;
            SENS   : in std_logic;
            EN     : in std_logic;
            Din    : in std_logic_vector(15 downto 0);
            Dout   : out std_logic_vector(15 downto 0)
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
        wait for 2*PERIOD;
        RST <= '0';  -- Reset
        wait for 2*PERIOD;
        RST <= '1';  -- Fin reset
        wait for 2*PERIOD;
        LOAD <= '1'; Din <= "0000000000001010";  -- Chargement de 10
        wait for 1*PERIOD;
        LOAD <= '0';
        wait for 2*PERIOD;
        EN <= '0';  -- Activation du comptage
        wait for 8*PERIOD;
        SENS <= '0'; -- Changement de sens (décrémentation)
        wait for 8*PERIOD;
        EN <= '1';  -- Désactivation du comptage
        wait for 4*PERIOD;
        report "Simulation terminée";
        wait;
    end process;
end tb;
