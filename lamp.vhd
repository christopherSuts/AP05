LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY AdaptiveTrafficLight IS
    PORT (
        clk : IN STD_LOGIC;

        traffic_sensor_vertical_one, traffic_sensor_vertical_two,
        traffic_sensor_horizontal_one, traffic_sensor_horizontal_two : IN STD_LOGIC;
        elderly_cross_button : IN STD_LOGIC;
        road_vertical : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
        road_horizontal : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
        display_vertical_one, display_vertical_two,
        display_horizontal_one, display_horizontal_two : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        --green_duration : out STD_LOGIC_VECTOR(7 downto 0);    
        --yellow_duration : out STD_LOGIC_VECTOR(7 downto 0);
        --red_duration : out STD_LOGIC_VECTOR(7 downto 0)
    );
END AdaptiveTrafficLight;

ARCHITECTURE Behavioral OF AdaptiveTrafficLight IS
    COMPONENT decoder IS
        PORT (
            input_num : IN INTEGER RANGE 0 TO 59;
            seg1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            seg2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    TYPE State_Type IS (INIT, RED_VERTICAL_NORMAL, RED_HORIZONTAL_NORMAL, RED_VERTICAL_TRAFFIC,
        RED_HORIZONTAL_TRAFFIC, RED_VERTICAL_ELDERLY, RED_HORIZONTAL_ELDERLY, TRANSITION);
    SIGNAL state : State_Type := INIT;
    SIGNAL traffic_density : STD_LOGIC;

    SIGNAL green_timer_vertical, red_timer_horizontal : INTEGER := 10; -- TOLONG KEMBALIKAN JADI 20
    SIGNAL red_timer_vertical, green_timer_horizontal : INTEGER := 10; -- TOLONG KEMBALIKAN JADI 20
    SIGNAL yellow_timer_vertical, yellow_timer_horizontal : INTEGER := 5;
    SIGNAL initial_road_vertical : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    SIGNAL display_timer_vertical, display_timer_horizontal : INTEGER RANGE 0 TO 59;

    SIGNAL elderly_button_status, vertical_traffic_status, horizontal_traffic_status : STD_LOGIC;

    CONSTANT YELLOW_BASE_DURATION : INTEGER := 5; --lampu kuning
    CONSTANT GREEN_RED_BASE_DURATION : INTEGER := 10; -- tolong kembalikan jadi 20 nanti
    CONSTANT GREEN_RED_BASE_DURATION_ELDERLY : INTEGER := 15; -- tolong kembalikan jadi 30 nanti
    CONSTANT GREEN_RED_BASE_DURATION_TRAFFIC : INTEGER := 15; -- tolong kembalikan jadi 30 nanti

BEGIN
    decoder_vertical : decoder PORT MAP(
        input_num => display_timer_vertical,
        seg1 => display_vertical_one,
        seg2 => display_vertical_two
    );

    decoder_horizontal : decoder PORT MAP(
        input_num => display_timer_horizontal,
        seg1 => display_horizontal_one,
        seg2 => display_horizontal_two
    );

    PROCESS (clk, elderly_cross_button)
        VARIABLE reset : STD_LOGIC := '0';
    BEGIN
        IF reset = '1' THEN

            red_timer_vertical <= GREEN_RED_BASE_DURATION;
            green_timer_vertical <= GREEN_RED_BASE_DURATION;
            red_timer_horizontal <= GREEN_RED_BASE_DURATION;
            green_timer_horizontal <= GREEN_RED_BASE_DURATION;
            yellow_timer_vertical <= YELLOW_BASE_DURATION;
            yellow_timer_horizontal <= YELLOW_BASE_DURATION;

            IF (elderly_cross_button = '1') THEN
                red_timer_vertical <= GREEN_RED_BASE_DURATION_ELDERLY;
                green_timer_horizontal <= GREEN_RED_BASE_DURATION_ELDERLY;
                green_timer_vertical <= GREEN_RED_BASE_DURATION_ELDERLY;
                red_timer_horizontal <= GREEN_RED_BASE_DURATION_ELDERLY;
            END IF;

            IF (vertical_traffic_status = '1') THEN
                green_timer_vertical <= GREEN_RED_BASE_DURATION_TRAFFIC;
                red_timer_horizontal <= GREEN_RED_BASE_DURATION_TRAFFIC;
            END IF;

            IF (horizontal_traffic_status = '1') THEN
                green_timer_horizontal <= GREEN_RED_BASE_DURATION_TRAFFIC;
                red_timer_vertical <= GREEN_RED_BASE_DURATION_TRAFFIC;
            END IF;

            reset := '0';

        ELSIF rising_edge(clk) THEN
            CASE state IS
                WHEN INIT =>
                    State <= RED_vertical_normal;

                WHEN RED_VERTICAL_NORMAL =>
                    -- Condition : The vertical traffic light will be red, whether the horizontal traffic light will be green.
                    initial_road_vertical <= "100"; -- merah (sign only)
                    road_vertical <= "100"; -- merah
                    road_horizontal <= "001"; -- hijau

                    IF (traffic_sensor_vertical_one = '1' AND traffic_sensor_vertical_two = '1') THEN
                        vertical_traffic_status <= '1';
                    ELSE
                        vertical_traffic_status <= '0';
                    END IF;

                    IF (elderly_cross_button = '1') THEN
                        elderly_button_status <= '1';
                    ELSE
                        elderly_button_status <= '0';
                    END IF;

                    FOR i IN 1 TO (GREEN_RED_BASE_DURATION) LOOP
                        red_timer_vertical <= red_timer_vertical - 1;
                        green_timer_horizontal <= green_timer_horizontal - 1;
                        display_timer_vertical <= red_timer_vertical - 1;
                        display_timer_horizontal <= green_timer_horizontal - 1;

                        IF (red_timer_vertical = 1 AND green_timer_horizontal = 1) THEN
                            state <= TRANSITION;
                        END IF;
                    END LOOP;

                WHEN RED_VERTICAL_TRAFFIC =>
                    -- Condition : The vertical traffic light will be red, whether the horizontal traffic light will be green.
                    initial_road_vertical <= "100"; -- merah (sign only)
                    road_vertical <= "100"; -- merah
                    road_horizontal <= "001"; -- hijau

                    IF (traffic_sensor_vertical_one = '1' AND traffic_sensor_vertical_two = '1') THEN
                        vertical_traffic_status <= '1';
                    ELSE
                        vertical_traffic_status <= '0';
                    END IF;

                    IF (elderly_cross_button = '1') THEN
                        elderly_button_status <= '1';
                    ELSE
                        elderly_button_status <= '0';
                    END IF;

                    red_timer_vertical <= GREEN_RED_BASE_DURATION_TRAFFIC;
                    green_timer_horizontal <= GREEN_RED_BASE_DURATION_TRAFFIC;

                    FOR i IN 1 TO GREEN_RED_BASE_DURATION_TRAFFIC LOOP
                        red_timer_vertical <= red_timer_vertical - 1;
                        green_timer_horizontal <= green_timer_horizontal - 1;
                        display_timer_vertical <= red_timer_vertical - 1;
                        display_timer_horizontal <= green_timer_horizontal - 1;

                        IF (red_timer_vertical = 1 AND green_timer_horizontal = 1) THEN
                            state <= TRANSITION;
                        END IF;
                    END LOOP;

                WHEN RED_VERTICAL_ELDERLY =>
                    -- Condition : The vertical traffic light will be red, whether the horizontal traffic light will be green.
                    initial_road_vertical <= "100"; -- merah (sign only)
                    road_vertical <= "100"; -- merah
                    road_horizontal <= "001"; -- hijau

                    IF (traffic_sensor_vertical_one = '1' AND traffic_sensor_vertical_two = '1') THEN
                        vertical_traffic_status <= '1';
                    ELSE
                        vertical_traffic_status <= '0';
                    END IF;

                    IF (elderly_cross_button = '1') THEN
                        elderly_button_status <= '1';
                    ELSE
                        elderly_button_status <= '0';
                    END IF;

                    red_timer_vertical <= GREEN_RED_BASE_DURATION_ELDERLY;
                    green_timer_horizontal <= GREEN_RED_BASE_DURATION_ELDERLY;
                    

                    FOR i IN 1 TO GREEN_RED_BASE_DURATION_ELDERLY LOOP
                        red_timer_vertical <= red_timer_vertical - 1;
                        green_timer_horizontal <= green_timer_horizontal - 1;
                        display_timer_vertical <= red_timer_vertical - 1;
                        display_timer_horizontal <= green_timer_horizontal - 1;

                        IF (red_timer_vertical = 1 AND green_timer_horizontal = 1) THEN
                            state <= TRANSITION;
                        END IF;
                    END LOOP;

                    -- TRANSITION = state for yellow
                WHEN TRANSITION =>
                    road_vertical <= "010";
                    road_horizontal <= "010";

                    FOR i IN 1 TO YELLOW_BASE_DURATION LOOP
                        yellow_timer_vertical <= yellow_timer_vertical - 1;
                        yellow_timer_horizontal <= yellow_timer_horizontal - 1;
                        display_timer_vertical <= yellow_timer_vertical - 1;
                        display_timer_horizontal <= yellow_timer_horizontal - 1;

                        IF (yellow_timer_vertical = 1 AND yellow_timer_horizontal = 1) THEN
                            IF (initial_road_vertical = "100") THEN
                                road_vertical <= "001";
                                road_horizontal <= "100";
                                reset := '1';

                                IF (vertical_traffic_status = '1') THEN
                                    state <= RED_HORIZONTAL_TRAFFIC;

                                ELSIF (elderly_button_status = '1') THEN
                                    state <= RED_HORIZONTAL_ELDERLY;
                                ELSE
                                    state <= RED_HORIZONTAL_NORMAL;
                                END IF;
                            ELSE
                                road_vertical <= "100";
                                road_horizontal <= "001";
                                reset := '1';

                                IF (horizontal_traffic_status = '1') THEN
                                    state <= RED_VERTICAL_TRAFFIC;
                                ELSIF (elderly_button_status = '1') THEN
                                    state <= RED_VERTICAL_ELDERLY;
                                ELSE
                                    state <= RED_VERTICAL_NORMAL;
                                END IF;
                            END IF;
                        END IF;
                    END LOOP;

                WHEN RED_HORIZONTAL_NORMAL =>
                    -- Condition : The horizontal traffic light will be red, whether the vertical traffic light will be green.
                    initial_road_vertical <= "001";
                    road_vertical <= "001";
                    road_horizontal <= "100";

                    IF (traffic_sensor_horizontal_one = '1' AND traffic_sensor_horizontal_two = '1') THEN
                        horizontal_traffic_status <= '1';
                    ELSE
                        horizontal_traffic_status <= '0';
                    END IF;

                    IF (elderly_cross_button = '1') THEN
                        elderly_button_status <= '1';
                    ELSE
                        elderly_button_status <= '0';
                    END IF;

                    FOR i IN 1 TO (GREEN_RED_BASE_DURATION) LOOP
                        green_timer_vertical <= green_timer_vertical - 1;
                        red_timer_horizontal <= red_timer_horizontal - 1;
                        display_timer_vertical <= green_timer_vertical - 1;
                        display_timer_horizontal <= red_timer_horizontal - 1;

                        IF (red_timer_horizontal = 1 AND green_timer_vertical = 1) THEN
                            state <= TRANSITION;
                        END IF;
                    END LOOP;

                WHEN RED_HORIZONTAL_TRAFFIC =>
                    -- Condition : The horizontal traffic light will be red, whether the vertical traffic light will be green.
                    initial_road_vertical <= "001";
                    road_vertical <= "001";
                    road_horizontal <= "100";

                    IF (traffic_sensor_horizontal_one = '1' AND traffic_sensor_horizontal_two = '1') THEN
                        horizontal_traffic_status <= '1';
                    ELSE
                        horizontal_traffic_status <= '0';
                    END IF;

                    IF (elderly_cross_button = '1') THEN
                        elderly_button_status <= '1';
                    ELSE
                        elderly_button_status <= '0';
                    END IF;

                    green_timer_vertical <= GREEN_RED_BASE_DURATION_TRAFFIC;
                    red_timer_horizontal <= GREEN_RED_BASE_DURATION_TRAFFIC;

                    FOR i IN 1 TO GREEN_RED_BASE_DURATION_TRAFFIC LOOP
                        green_timer_vertical <= green_timer_vertical - 1;
                        red_timer_horizontal <= red_timer_horizontal - 1;
                        display_timer_vertical <= green_timer_vertical - 1;
                        display_timer_horizontal <= red_timer_horizontal - 1;

                        IF (red_timer_horizontal = 1 AND green_timer_vertical = 1) THEN
                            state <= TRANSITION;
                        END IF;
                    END LOOP;

                WHEN RED_HORIZONTAL_ELDERLY =>
                    -- Condition : The horizontal traffic light will be red, whether the vertical traffic light will be green.
                    initial_road_vertical <= "001";
                    road_vertical <= "001";
                    road_horizontal <= "100";

                    IF (traffic_sensor_horizontal_one = '1' AND traffic_sensor_horizontal_two = '1') THEN
                        horizontal_traffic_status <= '1';
                    ELSE
                        horizontal_traffic_status <= '0';
                    END IF;

                    IF (elderly_cross_button = '1') THEN
                        elderly_button_status <= '1';
                    ELSE
                        elderly_button_status <= '0';
                    END IF;

                    green_timer_vertical <= GREEN_RED_BASE_DURATION_ELDERLY;
                    red_timer_horizontal <= GREEN_RED_BASE_DURATION_ELDERLY;

                    FOR i IN 1 TO GREEN_RED_BASE_DURATION_ELDERLY LOOP
                        green_timer_vertical <= green_timer_vertical - 1;
                        red_timer_horizontal <= red_timer_horizontal - 1;
                        display_timer_vertical <= green_timer_vertical - 1;
                        display_timer_horizontal <= red_timer_horizontal - 1;
                        IF (green_timer_vertical = 1 AND red_timer_horizontal = 1) THEN
                            state <= TRANSITION;
                        END IF;
                    END LOOP;
            END CASE;
        END IF;
    END PROCESS;
END Behavioral;