
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vtop.h"
#define Top Vtop

#define MAX_SIM_TIME (0)
#define TIME_STEP (5)



vluint64_t main_time = 0;

double sc_time_stamp(){
  return main_time;
}

int main(int argc, char** argv)
{
  Verilated::commandArgs(argc, argv);

  Top *top = new Top();

#ifdef TRACE
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace(tfp, 99);
  tfp->open("None");
#endif
  top->io_CLK = 0;
  top->io_RST = 0;

  // input initialization

  while(!Verilated::gotFinish()){
    if(main_time % 5 == 0){
      top->io_CLK = !top->io_CLK;
    }
    if(main_time == 100){
      top->io_RST = 1;
    }
    if(main_time == 100 * 2){
      top->io_RST = 0;
    }

    // update input

    top->eval();

#ifdef TRACE
    tfp->dump(main_time);
#endif

    if(MAX_SIM_TIME > 0 && main_time >= MAX_SIM_TIME){
      //std::cout << "# simulation time: " << main_time << std::endl;
      break;
    }

    main_time += TIME_STEP;
  }

#ifdef TRACE
  tfp->close();
#endif

  top->final();

  return 0;
}
