Implementaion of a RV321 instruction set with a 5-stage pipelined CPU. The Project is designed with the following design parameters:
- Forwarding unit from MEM/WB to ID/EX.
- Hazard Detection Unit for stalls and handling branches and jumps.
- Branch computed in MEM stage and thus branch misprediciton causes 2 stages of stall.
- Static branch not taken assumed for branch.

THINGS TO DO:
- add support for OUT-OF-ORDER instruction execution by adding a reservation station and augmenting control and datapaths.
- Integrate Cache DRAM with memory interface.
