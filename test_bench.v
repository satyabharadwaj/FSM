module test_bench;
  reg clk;
  reg reset;
  reg speed;
  reg obstacle;
  wire accelerate;
  wire brake;

  // Instantiate the module under test
  Fsm dut(
    .clk(clk),
    .reset(reset),
    .speed(speed),
    .obstacle(obstacle),
    .accelerate(accelerate),
    .brake(brake)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Test scenario
  initial begin
    clk = 0;
    reset = 1;
    speed = 0;
    obstacle = 0;
    #10 reset = 0;

    // Initial state
    #20 speed = 5;
    #20 speed = 0;

    // Start state
    #20 speed = 12;
    #20 speed = 9;
    #20 obstacle = 1;

    // Emergency state
    #20 obstacle = 0;
    #20 obstacle = 1;

    // Drive mode
    #20 speed = 15;
    #20 speed = 25;
    #20 obstacle = 1;

    // Motion mode
    #20 speed = 35;
    #20 speed = 0;

    // Parking state
    #20 speed = 5;
    #20 speed = 0;

    

    // Finish the simulation
    #10 $finish;
  end

  // Monitor outputs
  always @(posedge clk) begin
    $display("Time = %0t | Accelerate = %b | Brake = %b", $time, accelerate, brake);
  end
endmodule
