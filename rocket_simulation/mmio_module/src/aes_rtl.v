// ================================================================
// AES-128 Encrypt Core (no key expansion; round keys hard-coded)
// - function を使わずに wire と assign で記述
// ================================================================
module aes128_enc_fixedkey (
    input  wire         CLK,
    input  wire         RST,
    input  wire         start,
    input  wire [127:0] plaintext,
    output reg          busy,
    output reg          done,
    output reg  [127:0] ciphertext
);

  // ---- ラウンド鍵（R0..R10）: key=2b7e151628aed2a6abf7158809cf4f3c ----
  wire [127:0] RK [0:10];
  assign RK[0] = 128'h2b7e151628aed2a6abf7158809cf4f3c;
  assign RK[1] = 128'ha0fafe1788542cb123a339392a6c7605;
  assign RK[2] = 128'hf2c295f27a96b9435935807a7359f67f;
  assign RK[3] = 128'h3d80477d4716fe3e1e237e446d7a883b;
  assign RK[4] = 128'hef44a541a8525b7fb671253bdb0bad00;
  assign RK[5] = 128'hd4d1c6f87c839d87caf2b8bc11f915bc;
  assign RK[6] = 128'h6d88a37a110b3efddbf98641ca0093fd;
  assign RK[7] = 128'h4e54f70e5f5fc9f384a64fb24ea6dc4f;
  assign RK[8] = 128'head27321b58dbad2312bf5607f8d292f;
  assign RK[9] = 128'hac7766f319fadc2128d12941575c006e;
  assign RK[10] = 128'hd014f9a8c9ee2589e13f0cc8b6630ca6;

  // ---- 状態 ----
  localparam S_IDLE = 2'd0, S_RUN = 2'd1, S_DONE = 2'd2;
  reg [1:0]  st;
  reg [3:0]  round;         // 0..10
  reg [127:0] state;

  // ---- SubBytes ----
  wire [7:0] sb[0:15];
  aes_sbox u0  (.in(state[127:120]), .out(sb[0]));
  aes_sbox u1  (.in(state[119:112]), .out(sb[1]));
  aes_sbox u2  (.in(state[111:104]), .out(sb[2]));
  aes_sbox u3  (.in(state[103: 96]), .out(sb[3]));
  aes_sbox u4  (.in(state[ 95: 88]), .out(sb[4]));
  aes_sbox u5  (.in(state[ 87: 80]), .out(sb[5]));
  aes_sbox u6  (.in(state[ 79: 72]), .out(sb[6]));
  aes_sbox u7  (.in(state[ 71: 64]), .out(sb[7]));
  aes_sbox u8  (.in(state[ 63: 56]), .out(sb[8]));
  aes_sbox u9  (.in(state[ 55: 48]), .out(sb[9]));
  aes_sbox u10 (.in(state[ 47: 40]), .out(sb[10]));
  aes_sbox u11 (.in(state[ 39: 32]), .out(sb[11]));
  aes_sbox u12 (.in(state[ 31: 24]), .out(sb[12]));
  aes_sbox u13 (.in(state[ 23: 16]), .out(sb[13]));
  aes_sbox u14 (.in(state[ 15:  8]), .out(sb[14]));
  aes_sbox u15 (.in(state[  7:  0]), .out(sb[15]));

  wire [127:0] subbytes_state = {
    sb[0], sb[1], sb[2], sb[3], sb[4], sb[5], sb[6], sb[7],
    sb[8], sb[9], sb[10],sb[11],sb[12],sb[13],sb[14],sb[15]
  };

  // ---- ShiftRows ----
  wire [127:0] shiftrows_state;
  // State: {s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15}
  //
  // s0  s4  s8  s12
  // s1  s5  s9  s13
  // s2  s6  s10 s14
  // s3  s7  s11 s15
  //
  // Shifted State:
  // s0  s4  s8  s12
  // s5  s9  s13 s1
  // s10 s14 s2  s6
  // s15 s3  s7  s11
  assign shiftrows_state = {
    subbytes_state[127:120], subbytes_state[ 95: 88], subbytes_state[ 63: 56], subbytes_state[ 31: 24], // col 0
    subbytes_state[119:112], subbytes_state[ 87: 80], subbytes_state[ 55: 48], subbytes_state[ 23: 16], // col 1
    subbytes_state[111:104], subbytes_state[ 79: 72], subbytes_state[ 47: 40], subbytes_state[ 15:  8], // col 2
    subbytes_state[103: 96], subbytes_state[ 71: 64], subbytes_state[ 39: 32], subbytes_state[  7:  0]  // col 3
  };


  // ---- MixColumns ----
  wire [127:0] mixcolumns_state;
  wire [7:0]   s[0:15]; // Bytes from shiftrows_state
  
  assign s[0]=shiftrows_state[127:120]; assign s[1]=shiftrows_state[119:112]; assign s[2]=shiftrows_state[111:104]; assign s[3]=shiftrows_state[103:96];
  assign s[4]=shiftrows_state[95:88];   assign s[5]=shiftrows_state[87:80];   assign s[6]=shiftrows_state[79:72];   assign s[7]=shiftrows_state[71:64];
  assign s[8]=shiftrows_state[63:56];   assign s[9]=shiftrows_state[55:48];   assign s[10]=shiftrows_state[47:40];  assign s[11]=shiftrows_state[39:32];
  assign s[12]=shiftrows_state[31:24];  assign s[13]=shiftrows_state[23:16];  assign s[14]=shiftrows_state[15:8];   assign s[15]=shiftrows_state[7:0];

  // xtime(x) = {x[6:0],1'b0} ^ (8'h1b & {8{x[7]}})
  wire [7:0] xtime_s[0:15];
  assign xtime_s[0]  = {s[0][6:0],1'b0}  ^ (8'h1b & {8{s[0][7]}});
  assign xtime_s[1]  = {s[1][6:0],1'b0}  ^ (8'h1b & {8{s[1][7]}});
  assign xtime_s[2]  = {s[2][6:0],1'b0}  ^ (8'h1b & {8{s[2][7]}});
  // ... (assign for all 16 bytes)
  // To save space, let's do this calculation inline in the column mixing
  
  wire [7:0] d[0:15]; // Output bytes after MixColumns

  // Column 0
  assign d[0] = ({s[0][6:0],1'b0} ^ (8'h1b & {8{s[0][7]}})) ^ s[1] ^ s[2] ^ ({s[2][6:0],1'b0} ^ (8'h1b & {8{s[2][7]}})) ^ s[3];
  assign d[1] = s[0] ^ ({s[1][6:0],1'b0} ^ (8'h1b & {8{s[1][7]}})) ^ s[2] ^ ({s[2][6:0],1'b0} ^ (8'h1b & {8{s[2][7]}})) ^ s[3];
  assign d[2] = s[0] ^ s[1] ^ ({s[2][6:0],1'b0} ^ (8'h1b & {8{s[2][7]}})) ^ s[3] ^ ({s[3][6:0],1'b0} ^ (8'h1b & {8{s[3][7]}}));
  assign d[3] = s[0] ^ ({s[0][6:0],1'b0} ^ (8'h1b & {8{s[0][7]}})) ^ s[1] ^ s[2] ^ ({s[3][6:0],1'b0} ^ (8'h1b & {8{s[3][7]}}));

  // Column 1
  assign d[4] = ({s[4][6:0],1'b0} ^ (8'h1b & {8{s[4][7]}})) ^ s[5] ^ s[6] ^ ({s[6][6:0],1'b0} ^ (8'h1b & {8{s[6][7]}})) ^ s[7];
  assign d[5] = s[4] ^ ({s[5][6:0],1'b0} ^ (8'h1b & {8{s[5][7]}})) ^ s[6] ^ ({s[6][6:0],1'b0} ^ (8'h1b & {8{s[6][7]}})) ^ s[7];
  assign d[6] = s[4] ^ s[5] ^ ({s[6][6:0],1'b0} ^ (8'h1b & {8{s[6][7]}})) ^ s[7] ^ ({s[7][6:0],1'b0} ^ (8'h1b & {8{s[7][7]}}));
  assign d[7] = s[4] ^ ({s[4][6:0],1'b0} ^ (8'h1b & {8{s[4][7]}})) ^ s[5] ^ s[6] ^ ({s[7][6:0],1'b0} ^ (8'h1b & {8{s[7][7]}}));

  // Column 2
  assign d[8] = ({s[8][6:0],1'b0} ^ (8'h1b & {8{s[8][7]}})) ^ s[9] ^ s[10] ^ ({s[10][6:0],1'b0} ^ (8'h1b & {8{s[10][7]}})) ^ s[11];
  assign d[9] = s[8] ^ ({s[9][6:0],1'b0} ^ (8'h1b & {8{s[9][7]}})) ^ s[10] ^ ({s[10][6:0],1'b0} ^ (8'h1b & {8{s[10][7]}})) ^ s[11];
  assign d[10] = s[8] ^ s[9] ^ ({s[10][6:0],1'b0} ^ (8'h1b & {8{s[10][7]}})) ^ s[11] ^ ({s[11][6:0],1'b0} ^ (8'h1b & {8{s[11][7]}}));
  assign d[11] = s[8] ^ ({s[8][6:0],1'b0} ^ (8'h1b & {8{s[8][7]}})) ^ s[9] ^ s[10] ^ ({s[11][6:0],1'b0} ^ (8'h1b & {8{s[11][7]}}));

  // Column 3
  assign d[12] = ({s[12][6:0],1'b0} ^ (8'h1b & {8{s[12][7]}})) ^ s[13] ^ s[14] ^ ({s[14][6:0],1'b0} ^ (8'h1b & {8{s[14][7]}})) ^ s[15];
  assign d[13] = s[12] ^ ({s[13][6:0],1'b0} ^ (8'h1b & {8{s[13][7]}})) ^ s[14] ^ ({s[14][6:0],1'b0} ^ (8'h1b & {8{s[14][7]}})) ^ s[15];
  assign d[14] = s[12] ^ s[13] ^ ({s[14][6:0],1'b0} ^ (8'h1b & {8{s[14][7]}})) ^ s[15] ^ ({s[15][6:0],1'b0} ^ (8'h1b & {8{s[15][7]}}));
  assign d[15] = s[12] ^ ({s[12][6:0],1'b0} ^ (8'h1b & {8{s[12][7]}})) ^ s[13] ^ s[14] ^ ({s[15][6:0],1'b0} ^ (8'h1b & {8{s[15][7]}}));

  assign mixcolumns_state = {d[0],d[1],d[2],d[3],d[4],d[5],d[6],d[7],d[8],d[9],d[10],d[11],d[12],d[13],d[14],d[15]};


  // ---- FSM ----
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      st <= S_IDLE; busy <= 1'b0; done <= 1'b0;
      round <= 4'd0; state <= 128'd0; ciphertext <= 128'd0;
    end else begin
      case (st)
        S_IDLE: begin
          round <= 4'd0;
          if (start) begin
            state <= plaintext ^ RK[0]; // 初回AddRoundKey
            done  <= 1'b0;
            busy  <= 1'b1;
            st    <= S_RUN;
          end
        end
        S_RUN: begin
          if (round == 4'd0) begin
            state <= state;     // 初回AddRoundKey
            round <= 4'd1;
          end else if (round <= 4'd9) begin
            // state <= mixcolumns( shiftrows( subbytes_state ) ) ^ RK[round];
            state <= mixcolumns_state ^ RK[round];
            round <= round + 4'd1;
          end else begin
            // round==10: 最終ラウンド（MixColumnsなし）
            // ciphertext <= (shiftrows( subbytes_state )) ^ RK[10];
            ciphertext <= shiftrows_state ^ RK[10];
            st    <= S_DONE;
          end
        end
        S_DONE: begin
          busy <= 1'b0; 
          done <= 1'b1; 
          st <= S_IDLE;
          state <= 128'd0;
        end
        default: st <= st;
      endcase
    end
  end

endmodule

// ================================================================
// AES S-Box (Combinational, 8->8)
// ================================================================
module aes_sbox (
    input  wire [7:0] in,
    output reg  [7:0] out
);
  always @* begin
    case (in)
      8'h00: out=8'h63; 8'h01: out=8'h7c; 8'h02: out=8'h77; 8'h03: out=8'h7b;
      8'h04: out=8'hf2; 8'h05: out=8'h6b; 8'h06: out=8'h6f; 8'h07: out=8'hc5;
      8'h08: out=8'h30; 8'h09: out=8'h01; 8'h0a: out=8'h67; 8'h0b: out=8'h2b;
      8'h0c: out=8'hfe; 8'h0d: out=8'hd7; 8'h0e: out=8'hab; 8'h0f: out=8'h76;
      8'h10: out=8'hca; 8'h11: out=8'h82; 8'h12: out=8'hc9; 8'h13: out=8'h7d;
      8'h14: out=8'hfa; 8'h15: out=8'h59; 8'h16: out=8'h47; 8'h17: out=8'hf0;
      8'h18: out=8'had; 8'h19: out=8'hd4; 8'h1a: out=8'ha2; 8'h1b: out=8'haf;
      8'h1c: out=8'h9c; 8'h1d: out=8'ha4; 8'h1e: out=8'h72; 8'h1f: out=8'hc0;
      8'h20: out=8'hb7; 8'h21: out=8'hfd; 8'h22: out=8'h93; 8'h23: out=8'h26;
      8'h24: out=8'h36; 8'h25: out=8'h3f; 8'h26: out=8'hf7; 8'h27: out=8'hcc;
      8'h28: out=8'h34; 8'h29: out=8'ha5; 8'h2a: out=8'he5; 8'h2b: out=8'hf1;
      8'h2c: out=8'h71; 8'h2d: out=8'hd8; 8'h2e: out=8'h31; 8'h2f: out=8'h15;
      8'h30: out=8'h04; 8'h31: out=8'hc7; 8'h32: out=8'h23; 8'h33: out=8'hc3;
      8'h34: out=8'h18; 8'h35: out=8'h96; 8'h36: out=8'h05; 8'h37: out=8'h9a;
      8'h38: out=8'h07; 8'h39: out=8'h12; 8'h3a: out=8'h80; 8'h3b: out=8'he2;
      8'h3c: out=8'heb; 8'h3d: out=8'h27; 8'h3e: out=8'hb2; 8'h3f: out=8'h75;
      8'h40: out=8'h09; 8'h41: out=8'h83; 8'h42: out=8'h2c; 8'h43: out=8'h1a;
      8'h44: out=8'h1b; 8'h45: out=8'h6e; 8'h46: out=8'h5a; 8'h47: out=8'ha0;
      8'h48: out=8'h52; 8'h49: out=8'h3b; 8'h4a: out=8'hd6; 8'h4b: out=8'hb3;
      8'h4c: out=8'h29; 8'h4d: out=8'he3; 8'h4e: out=8'h2f; 8'h4f: out=8'h84;
      8'h50: out=8'h53; 8'h51: out=8'hd1; 8'h52: out=8'h00; 8'h53: out=8'hed;
      8'h54: out=8'h20; 8'h55: out=8'hfc; 8'h56: out=8'hb1; 8'h57: out=8'h5b;
      8'h58: out=8'h6a; 8'h59: out=8'hcb; 8'h5a: out=8'hbe; 8'h5b: out=8'h39;
      8'h5c: out=8'h4a; 8'h5d: out=8'h4c; 8'h5e: out=8'h58; 8'h5f: out=8'hcf;
      8'h60: out=8'hd0; 8'h61: out=8'hef; 8'h62: out=8'haa; 8'h63: out=8'hfb;
      8'h64: out=8'h43; 8'h65: out=8'h4d; 8'h66: out=8'h33; 8'h67: out=8'h85;
      8'h68: out=8'h45; 8'h69: out=8'hf9; 8'h6a: out=8'h02; 8'h6b: out=8'h7f;
      8'h6c: out=8'h50; 8'h6d: out=8'h3c; 8'h6e: out=8'h9f; 8'h6f: out=8'ha8;
      8'h70: out=8'h51; 8'h71: out=8'ha3; 8'h72: out=8'h40; 8'h73: out=8'h8f;
      8'h74: out=8'h92; 8'h75: out=8'h9d; 8'h76: out=8'h38; 8'h77: out=8'hf5;
      8'h78: out=8'hbc; 8'h79: out=8'hb6; 8'h7a: out=8'hda; 8'h7b: out=8'h21;
      8'h7c: out=8'h10; 8'h7d: out=8'hff; 8'h7e: out=8'hf3; 8'h7f: out=8'hd2;
      8'h80: out=8'hcd; 8'h81: out=8'h0c; 8'h82: out=8'h13; 8'h83: out=8'hec;
      8'h84: out=8'h5f; 8'h85: out=8'h97; 8'h86: out=8'h44; 8'h87: out=8'h17;
      8'h88: out=8'hc4; 8'h89: out=8'ha7; 8'h8a: out=8'h7e; 8'h8b: out=8'h3d;
      8'h8c: out=8'h64; 8'h8d: out=8'h5d; 8'h8e: out=8'h19; 8'h8f: out=8'h73;
      8'h90: out=8'h60; 8'h91: out=8'h81; 8'h92: out=8'h4f; 8'h93: out=8'hdc;
      8'h94: out=8'h22; 8'h95: out=8'h2a; 8'h96: out=8'h90; 8'h97: out=8'h88;
      8'h98: out=8'h46; 8'h99: out=8'hee; 8'h9a: out=8'hb8; 8'h9b: out=8'h14;
      8'h9c: out=8'hde; 8'h9d: out=8'h5e; 8'h9e: out=8'h0b; 8'h9f: out=8'hdb;
      8'ha0: out=8'he0; 8'ha1: out=8'h32; 8'ha2: out=8'h3a; 8'ha3: out=8'h0a;
      8'ha4: out=8'h49; 8'ha5: out=8'h06; 8'ha6: out=8'h24; 8'ha7: out=8'h5c;
      8'ha8: out=8'hc2; 8'ha9: out=8'hd3; 8'haa: out=8'hac; 8'hab: out=8'h62;
      8'hac: out=8'h91; 8'had: out=8'h95; 8'hae: out=8'he4; 8'haf: out=8'h79;
      8'hb0: out=8'he7; 8'hb1: out=8'hc8; 8'hb2: out=8'h37; 8'hb3: out=8'h6d;
      8'hb4: out=8'h8d; 8'hb5: out=8'hd5; 8'hb6: out=8'h4e; 8'hb7: out=8'ha9;
      8'hb8: out=8'h6c; 8'hb9: out=8'h56; 8'hba: out=8'hf4; 8'hbb: out=8'hea;
      8'hbc: out=8'h65; 8'hbd: out=8'h7a; 8'hbe: out=8'hae; 8'hbf: out=8'h08;
      8'hc0: out=8'hba; 8'hc1: out=8'h78; 8'hc2: out=8'h25; 8'hc3: out=8'h2e;
      8'hc4: out=8'h1c; 8'hc5: out=8'ha6; 8'hc6: out=8'hb4; 8'hc7: out=8'hc6;
      8'hc8: out=8'he8; 8'hc9: out=8'hdd; 8'hca: out=8'h74; 8'hcb: out=8'h1f;
      8'hcc: out=8'h4b; 8'hcd: out=8'hbd; 8'hce: out=8'h8b; 8'hcf: out=8'h8a;
      8'hd0: out=8'h70; 8'hd1: out=8'h3e; 8'hd2: out=8'hb5; 8'hd3: out=8'h66;
      8'hd4: out=8'h48; 8'hd5: out=8'h03; 8'hd6: out=8'hf6; 8'hd7: out=8'h0e;
      8'hd8: out=8'h61; 8'hd9: out=8'h35; 8'hda: out=8'h57; 8'hdb: out=8'hb9;
      8'hdc: out=8'h86; 8'hdd: out=8'hc1; 8'hde: out=8'h1d; 8'hdf: out=8'h9e;
      8'he0: out=8'he1; 8'he1: out=8'hf8; 8'he2: out=8'h98; 8'he3: out=8'h11;
      8'he4: out=8'h69; 8'he5: out=8'hd9; 8'he6: out=8'h8e; 8'he7: out=8'h94;
      8'he8: out=8'h9b; 8'he9: out=8'h1e; 8'hea: out=8'h87; 8'heb: out=8'he9;
      8'hec: out=8'hce; 8'hed: out=8'h55; 8'hee: out=8'h28; 8'hef: out=8'hdf;
      8'hf0: out=8'h8c; 8'hf1: out=8'ha1; 8'hf2: out=8'h89; 8'hf3: out=8'h0d;
      8'hf4: out=8'hbf; 8'hf5: out=8'he6; 8'hf6: out=8'h42; 8'hf7: out=8'h68;
      8'hf8: out=8'h41; 8'hf9: out=8'h99; 8'hfa: out=8'h2d; 8'hfb: out=8'h0f;
      8'hfc: out=8'hb0; 8'hfd: out=8'h54; 8'hfe: out=8'hbb; 8'hff: out=8'h16;
    endcase
  end
endmodule