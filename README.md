This repository provides MATLAB code for solving the Redundancy Allocation Problem (RAP) in tandem queueing networks with reparable subsystems. The goal is to minimize the total queueing and repair costs over time by optimally allocating redundancy and determining repair rates for system subsystems.

Redundancy allocation plays a key role in enhancing system availability and reducing operational costs in service, manufacturing, and communication systems—many of which can be modeled as queueing networks. In this study, we specifically address RAP for series-parallel configurations, which are commonly used in industry, and incorporate queueing costs into the optimization framework.

🔍 Problem Features
System Type: Tandem queueing network with reparable subsystems

Objective: Minimize total unit time queueing and repair costs

Decision Variables: Redundancy level and repair rate for each subsystem

Constraints: Problem-specific reliability, cost, and resource constraints

Solution Method: A hybrid Simulation-PSO (Particle Swarm Optimization) algorithm

📊 Experimental Validation
Extensive numerical experiments are included to demonstrate:

Practical applicability of the proposed approach

Effectiveness of the hybrid algorithm in optimizing cost and availability
