library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder is
    Port (
        input_num : in  integer range 0 to 99;
        seg1      : out std_logic_vector(6 downto 0);
        seg2      : out std_logic_vector(6 downto 0)
    );
end decoder;

architecture Behavioral of decoder is
    signal temp_num : integer range 0 to 99 := 0;
    signal digit1, digit2 : integer range 0 to 9 := 0;
    signal seg1_out, seg2_out : std_logic_vector(6 downto 0);
begin
    process(input_num)
    begin
        temp_num <= input_num;
    end process;

    digit1 <= temp_num / 10;
    digit2 <= temp_num mod 10;

    process(digit1, digit2)
    begin
        case digit1 is
            when 0 => seg1_out <= "0000001";  -- Corresponding segments for digit 0
            when 1 => seg1_out <= "1001111";  -- Corresponding segments for digit 1
            when 2 => seg1_out <= "0010010";  -- Corresponding segments for digit 2
            when 3 => seg1_out <= "0000110";  -- Corresponding segments for digit 3
            when 4 => seg1_out <= "1001100";  -- Corresponding segments for digit 4
            when 5 => seg1_out <= "0100100";  -- Corresponding segments for digit 5
            when 6 => seg1_out <= "0100000";  -- Corresponding segments for digit 6
            when 7 => seg1_out <= "0001111";  -- Corresponding segments for digit 7
            when 8 => seg1_out <= "0000000";  -- Corresponding segments for digit 8
            when 9 => seg1_out <= "0000100";  -- Corresponding segments for digit 9
            when others => seg1_out <= "1111111";  -- All segments off for other values
        end case;

        case digit2 is
            when 0 => seg2_out <= "0000001";  -- Corresponding segments for digit 0
            when 1 => seg2_out <= "1001111";  -- Corresponding segments for digit 1
            when 2 => seg2_out <= "0010010";  -- Corresponding segments for digit 2
            when 3 => seg2_out <= "0000110";  -- Corresponding segments for digit 3
            when 4 => seg2_out <= "1001100";  -- Corresponding segments for digit 4
            when 5 => seg2_out <= "0100100";  -- Corresponding segments for digit 5
            when 6 => seg2_out <= "0100000";  -- Corresponding segments for digit 6
            when 7 => seg2_out <= "0001111";  -- Corresponding segments for digit 7
            when 8 => seg2_out <= "0000000";  -- Corresponding segments for digit 8
            when 9 => seg2_out <= "0000100";  -- Corresponding segments for digit 9
            when others => seg2_out <= "1111111";  -- All segments off for other values
        end case;
    end process;

    seg1 <= seg1_out;
    seg2 <= seg2_out;
end Behavioral;