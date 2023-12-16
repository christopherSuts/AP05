library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AdaptiveTrafficLight is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sensor_data : in STD_LOGIC_VECTOR(7 downto 0);
           green_duration : out STD_LOGIC_VECTOR(7 downto 0);
           yellow_duration : out STD_LOGIC_VECTOR(7 downto 0);
           red_duration : out STD_LOGIC_VECTOR(7 downto 0));
end AdaptiveTrafficLight;

architecture Behavioral of AdaptiveTrafficLight is
    TYPE State IS (INIT, IDLE, CROSS, ELDERLY, TRAFFIC, RST, DONE);
    signal presentState : State := INIT;
    signal traffic_density : integer := 0;
    signal green_timer, yellow_timer, red_timer : integer := 0;

    constant GREEN_BASE_DURATION : integer := 20;
    constant YELLOW_BASE_DURATION : integer := 5;

begin
    process(clk, reset, sensor_data)
    begin
        if reset = '1' then
            traffic_density <= 0;
            green_timer <= 0;
            yellow_timer <= 0;
            red_timer <= 0;
        elsif rising_edge(clk) then
            -- Update traffic density based on sensor data
            traffic_density <= to_integer(unsigned(sensor_data));

            -- Adjust timings based on traffic density
            green_timer <= GREEN_BASE_DURATION + traffic_density;
            yellow_timer <= YELLOW_BASE_DURATION;
            red_timer <= GREEN_BASE_DURATION + YELLOW_BASE_DURATION;

            -- Output timings
            green_duration <= std_logic_vector(to_unsigned(green_timer, 8));
            yellow_duration <= std_logic_vector(to_unsigned(yellow_timer, 8));
            red_duration <= std_logic_vector(to_unsigned(red_timer, 8));
        end if;
    end process;
end Behavioral;