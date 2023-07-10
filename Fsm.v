module Fsm(
  input wire clk,
  input wire reset,
  input wire speed,
  input wire obstacle,
  output reg accelerate,
  output reg brake
);

  // State enumeration
  localparam [2:0] INITIAL_STATE = 3'b000;
  localparam [2:0] START = 3'b001;
  localparam [2:0] DRIVE_MODE = 3'b010;
  localparam [2:0] REVERSE_MODE = 3'b011;
  localparam [2:0] MOTION_MODE = 3'b100;
  localparam [2:0] PARKING_STATE = 3'b101;
  localparam [2:0] EMERGENCY_STATE = 3'b110;

  // Define state registers
  reg [2:0] current_state;
  reg [2:0] next_state;

  // Initialize state registers
  always @(posedge clk or posedge reset) begin
    if (reset)
      current_state <= INITIAL_STATE;
    else
      current_state <= next_state;
  end

  // Define output assignments
  always @* begin
    case (current_state)
      INITIAL_STATE:
        begin
          accelerate = 1'b0;
          brake = 1'b0;
        end
      START:
        begin
          accelerate = 1'b0;
          brake = 1'b0;
        end
      DRIVE_MODE:
        begin
          accelerate = 1'b1;
          brake = 1'b0;
        end
      REVERSE_MODE:
        begin
          accelerate = 1'b0;
          brake = 1'b1;
        end
      MOTION_MODE:
        begin
          accelerate = 1'b1;
          brake = 1'b0;
        end
      PARKING_STATE:
        begin
          accelerate = 1'b0;
          brake = 1'b0;
        end
      EMERGENCY_STATE:
        begin
          accelerate = 1'b0;
          brake = 1'b1;
        end
      default:
        begin
          accelerate = 1'b0;
          brake = 1'b0;
        end
    endcase
  end

  // Define next state logic
  always @* begin
    case (current_state)
      INITIAL_STATE:
        begin
          if (speed > 0)
            next_state = START;
          else
            next_state = INITIAL_STATE;
        end
      START:
        begin
          if (speed >= 10)
            next_state = DRIVE_MODE;
          else if (obstacle)
            next_state = EMERGENCY_STATE;
          else
            next_state = START;
        end
      DRIVE_MODE:
        begin
          if (obstacle)
            next_state = EMERGENCY_STATE;
          else if (speed < 10)
            next_state = DRIVE_MODE;
          else if (speed >= 30)
            next_state = MOTION_MODE;
          else if (!obstacle && speed < 30)
            next_state = DRIVE_MODE;
          else
            next_state = DRIVE_MODE;
        end
      REVERSE_MODE:
        begin
          if (obstacle)
            next_state = EMERGENCY_STATE;
          else if (!obstacle && speed == 0)
            next_state = PARKING_STATE;
          else if (speed > 0)
            next_state = REVERSE_MODE;
          else
            next_state = REVERSE_MODE;
        end
      MOTION_MODE:
        begin
          if (obstacle)
            next_state = EMERGENCY_STATE;
          else if (speed == 0)
            next_state = PARKING_STATE;
          else if (speed < 30)
            next_state = MOTION_MODE;
          else
            next_state = MOTION_MODE;
        end
      PARKING_STATE:
        begin
          if (obstacle)
            next_state = EMERGENCY_STATE;
          else if (!obstacle && speed > 0)
            next_state = PARKING_STATE;
          else
            next_state = PARKING_STATE;
        end
      EMERGENCY_STATE:
        begin
          if (!obstacle)
            next_state = INITIAL_STATE;
          else
            next_state = EMERGENCY_STATE;
        end
      default:
        next_state = INITIAL_STATE;
    endcase
  end

endmodule
