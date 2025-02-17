`timescale 1ns / 1ps

module tb_apb_master;

    // Inputs
    reg clk;
    reg rst;
    reg [6:0] apb_addr;
    reg [7:0] apb_wdata;
    reg apb_write;
    reg apb_read;
    reg apb_enable;
    reg apb_ready;  // Drive this signal in the testbench
    reg apb_pslverr;
    reg [7:0] apb_prdata;
    reg data_send;
    // Outputs
    wire apb_penable;
    wire apb_pwrite;
    wire apb_pread;
    wire [7:0] apb_pwdata;
    wire [7:0] apb_paddr;
    wire apb_master_ready;
    wire i2c_out;
    wire waiting_for_data;

    // Instantiate the APB master module
    apb_master uut (
        .clk(clk),
        .rst(rst),
        .apb_addr(apb_addr),
        .apb_wdata(apb_wdata),
        .apb_write(apb_write),
        .apb_read(apb_read),
        .apb_enable(apb_enable),
        .apb_ready(apb_ready),
        .apb_pslverr(apb_pslverr),
        .apb_prdata(apb_prdata),
        .apb_penable(apb_penable),
        .apb_pwrite(apb_pwrite),
        .apb_pread(apb_pread),
        .apb_pwdata(apb_pwdata),
        .apb_paddr(apb_paddr),
        .data_send(data_send),
        .apb_master_ready(apb_master_ready),
        .i2c_out(i2c_out),
        .waiting_for_data(waiting_for_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        rst = 1;
        apb_addr = 0;
        apb_wdata = 0;
        apb_write = 0;
        apb_read = 0;
        apb_enable = 0;
        apb_ready = 0;  
        data_send = 1;
        apb_pslverr = 0;

        // Apply reset
        #20;
        rst = 0; // De-assert reset
        #10;

        // Test 1: Write to address 8'h10
        $display("Test 1: Write to address 8'h10");
        apb_addr = 8'h10;       // Address 0x10
        apb_wdata = 8'hAA;      // Data to write
        apb_write = 1;          // Write operation
        apb_enable = 1;         // Enable the transaction
       
        apb_ready = 1;          // Simulate slave ready
       
        apb_write = 0;          // Clear write signal
        apb_enable = 0;         // Disable the transaction
        apb_ready = 0;          // Clear ready signal
        #10;

        // Test 2: Write to address 8'h11
        $display("Test 2: Write to address 8'h11");
        apb_addr = 8'h11;       // Address 0x11
        apb_wdata = 8'hBB;      // Data to write
        apb_write = 1;          // Write operation
        apb_enable = 1;         // Enable the transaction
        @(posedge clk);         // Wait for posedge of clock
        apb_ready = 1;          // Simulate slave ready
        @(posedge clk);         // Wait for posedge of clock
        apb_write = 0;          // Clear write signal
        apb_enable = 0;         // Disable the transaction
        apb_ready = 0;          // Clear ready signal
        #10;

        // Test 3: Write to address 8'h12
        $display("Test 3: Write to address 8'h12");
        apb_addr = 8'h12;       // Address 0x12
        apb_wdata = 8'hCC;      // Data to write
        apb_write = 1;          // Write operation
        apb_enable = 1;         // Enable the transaction
                
        apb_ready = 1;          // Simulate slave ready
        
        apb_write = 0;          // Clear write signal
        apb_enable = 0;         // Disable the transaction
        apb_ready = 0;          // Clear ready signal
        #10;

        // Test 4: Read from address 8'h10
        $display("Test 4: Read from address 8'h10");
        apb_addr = 8'h10;       // Address 0x10
        apb_prdata = 8'h11;
        apb_read = 1;           // Read operation
        apb_enable = 1;         // Enable the transaction
       
        apb_ready = 1;          // Simulate slave ready
       
        apb_read = 0;           // Clear read signal
        apb_enable = 0;         // Disable the transaction
        apb_ready = 0;          // Clear ready signal
        #100;

        // Test 5: Read from address 8'h11
        $display("Test 5: Read from address 8'h11");
        apb_addr = 8'h11;       // Address 0x11
        apb_prdata = 8'h12;
        apb_read = 1;           // Read operation
        apb_enable = 1;         // Enable the transaction
       
        apb_ready = 1;          // Simulate slave ready
       
        apb_read = 0;           // Clear read signal
        apb_enable = 0;         // Disable the transaction
        apb_ready = 0;          // Clear ready signal
        #100;

        // Test 6: Read from address 8'h12
        $display("Test 6: Read from address 8'h12");
        apb_addr = 8'h12;       // Address 0x12
        apb_prdata = 8'h13;
        apb_read = 1;           // Read operation
        apb_enable = 1;         // Enable the transaction
       
        apb_ready = 1;          // Simulate slave ready
       
        apb_read = 0;           // Clear read signal
        apb_enable = 0;         // Disable the transaction
        apb_ready = 0;          // Clear ready signal
        #100;

        // End simulation
        $display("Simulation complete");
        $finish;
    end
endmodule
