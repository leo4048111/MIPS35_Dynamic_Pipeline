module LEDDriver(
    input clk, // 100 Mhz clock source on Basys 3 FPGA
    input rst, // rst
    input [31:0] displayed_number,
    output reg [7:0] anode, // anode signals of the 7-segment LED display
    output reg [6:0] led_out// cathode patterns of the 7-segment LED display
    );

    reg [26:0] one_second_counter; // counter for generating 1 second clock enable
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [2:0] LED_activating_counter; 

    always @(posedge clk)
    begin 
        if(rst==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[19:17];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
        3'b000: begin
            anode = 8'b0111_1111; 
            LED_BCD = displayed_number/32'h10000000;
              end
        3'b001: begin
            anode = 8'b1011_1111; 
            LED_BCD = (displayed_number % 32'h10000000)/32'h1000000;
              end
        3'b010: begin
            anode = 8'b1101_1111; 
            LED_BCD = ((displayed_number % 32'h10000000)%32'h1000000)/32'h100000;
                end
        3'b011: begin
            anode = 8'b1110_1111; 
            LED_BCD = (((displayed_number % 32'h10000000)%32'h1000000)%32'h100000)/32'h10000;
               end
        3'b100: begin
            anode = 8'b1111_0111; 
            LED_BCD = ((((displayed_number % 32'h10000000)%32'h1000000)%32'h100000)%32'h10000)/32'h1000;
               end
        3'b101: begin
            anode = 8'b1111_1011; 
            LED_BCD = (((((displayed_number % 32'h10000000)%32'h1000000)%32'h100000)%32'h10000)%32'h1000)/32'h100;
               end
        3'b110: begin
            anode = 8'b1111_1101; 
            LED_BCD = ((((((displayed_number % 32'h10000000)%32'h1000000)%32'h100000)%32'h10000)%32'h1000)%32'h100)/32'h10;
               end
        3'b111: begin
            anode = 8'b1111_1110; 
            LED_BCD = ((((((displayed_number % 32'h10000000)%32'h1000000)%32'h100000)%32'h10000)%32'h1000)%32'h100)%32'h10;
               end
        endcase
    end
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: led_out = 7'b0000001; // "0"     
        4'b0001: led_out = 7'b1001111; // "1" 
        4'b0010: led_out = 7'b0010010; // "2" 
        4'b0011: led_out = 7'b0000110; // "3" 
        4'b0100: led_out = 7'b1001100; // "4" 
        4'b0101: led_out = 7'b0100100; // "5" 
        4'b0110: led_out = 7'b0100000; // "6" 
        4'b0111: led_out = 7'b0001111; // "7" 
        4'b1000: led_out = 7'b0000000; // "8"     
        4'b1001: led_out = 7'b0000100; // "9" 
        4'b1010: led_out = 7'b0001000; // "A" 
        4'b1011: led_out = 7'b1100000; // "B" 
        4'b1100: led_out = 7'b0110001; // "C"
        4'b1101: led_out = 7'b1000010; // "D" 
        4'b1110: led_out = 7'b0110000; // "E" 
        4'b1111: led_out = 7'b0111000; // "F" 
        default: led_out = 7'b0000001; // "0"
        endcase
    end
 endmodule