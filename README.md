# FlexWAN: Software Hardware Co-design for Cost-Effective and Resilient Optical Backbones 

## 1. Overview
FlexWAN is a novel flexible WAN infrastructure designed to provision cost effective WAN capacity while ensuring resilience to optical failures. FlexWAN achieves this by incorporating spacing-variable hardware at the optical layer, enabling the generated wavelength to optimize the utilization of limited spectrum resources for the WAN capacity. FlexWAN solves the algorithmic challenges by formulating the problem of provisioning WAN capacity with the goal of minimizing hardware costs.

For a full technical description on FlexWAN, please read our ACM SIGCOMM 2023 paper:

> C. Miao, Z. Zhong, Y. Zhang, K. He, F. Li, M. Chen, Y. Zhao, X. Li, Z. He, X. Zou, J. Wang, "FlexWAN: Software Hardware Co-design for Flexible and Cost-Effective Optical Backbones," ACM SIGCOMM, 2023. 


## 2. Artifact Structure
In this section, we delve into the organization of the artifacts associated with FlexWAN, which includes input data, source code, and scripts necessary for the TE simulation. This section provides insight into how these components are structured for your convenience. 

The outline of the artifacts's organization and structure are organized as follows.

```
.
├── README.md
├── data/                        # » Input folder for optical planning and TE simulation for FlexWAN
├── plot/                        # » Optical planning results
├── src/                         # » Source code folder for the optical planning and TE simulation for FlexWAN
└── abstract_optical_layer.sh   # » Script for optical layer restoration
```
### 2.1. Input files for optical planning and TE simulation for FlexWAN
Here, we detail the contents of the input files used for optical planning and the TE simulation of FlexWAN, which include the information of Optical fiber topology, IP topology, 
```
.
├── data/                        
    └── topology/
        └── ${topology}/           # » Input topology data for ${topology} (e.g Cernet)
            └── optical_nodes.txt
            └── optical_topo.txt
            └── IP_nodes.txt
            └── IP_topo_${IPTOPO_ID}/
                └── IP_topo_${IPTOPO_ID}.txt
                └── IP_topo_${IPTOPO_ID}_flexgrid.txt
```
#### Optical fiber topology files
`./${topology}/optical_nodes.txt`, each line represents a node on the optical layer.
>[Format] *String_node_names* (the node on the optical layer).

`./${topology}/optical_topo.txt`, each line represents a fiber link.
>[Format] *to_node* (the source node of the fiber link), *from_node* (the destination node of the fiber link), *metric* (the routing calculation metric of the fiber link, e.g., distance), *failure_prob* (the failure probability of the fiber link if specified from this input file).

#### IP topology files
`./${topology}/IP_nodes.txt`, each line represents a node on the IP layer.
>[Format] *String_node_names* (the node on the IP layer).

`./${topology}/IP_topo_${IPTOPO_ID}/IP_topo_${IPTOPO_ID}.txt`, each line represents an IP link. 
>[Format] *src* (the source node of the IP link), *dst* (the destination node of the IP link), *index* (the index of the IP link (if parallel IP link exists), *capacity* (the capacity of the IP links (related to the number of wavelengths of this IP link), *fiberpath_index* (the set of fiber link indices that this IP link is routed through), *wavelength* (the set of wavelengths that supports this IP link), *failure* (the failure probability of the IP link if specified from this input file).

`./${topology}/IP_topo_${IPTOPO_ID}/IP_topo_flexgrid.txt`, each line represents an IP link for flexgrid
>[Format] *src* (the source node of the IP link), *dst* (the destination node of the IP link), *index* (the index of the IP link (if parallel IP link exists), *capacity* (the capacity of the IP links (related to the number of wavelengths of this IP link), *fiberpath_index* (the set of fiber link indices that this IP link is routed through), *wavelength* (the set of wavelengths that supports this IP link), *failure* (the failure probability of the IP link if specified from this input file).

### 2.2. Source code for the TE simulation for FlexWAN.

|  Source Files                 |  Description                                                 |
|  -----                        |  -----                                                       |
|  `src/aggregatetickets.jl`    |  Aggregating parallel generated tickets                      |
|  `src/controller.jl`          |  Traffic engineering controller                              |
|  `src/environment.jl`         |  Fiber cut scenario generator                                |
|  `src/evaluation.jl`          |  Evaluating TE algorithms with fiber cut scenarios           |
|  `src/getscenarionum.jl`      |  Get the number of failure scenarios in each scenario file   |
|  `src/interface.jl`           |  Parse input parameters for the simulator                    |
|  `src/main.jl`                |  Simulation main file                                        |
|  `src/nextpararun.jl`         |  Generating data folder for simulation results               |
|  `src/provision.jl`           |  Execute IP topology provisioning                            |
|  `src/restoration.jl`         |  Optical restoration on the optical layer under failures     |
|  `src/simulator.jl`           |  Traffic engineering simulator                               |
|  `src/topodraw.jl`            |  Visualize network topology and tunnel flows                 |
|  `src/topoprovision.jl`       |  Provision IP topology on top of given optical topology      |




### 2.3. Executable shells for the running TE simulation for FlexWAN.

|  Executable Files             |  Description                                          |
|  -----                        |  -----                                                |
|  `optical_net_planning.jl`    |  Planning                                             |
|  `abstract_optical_layer.sh`  |  Restoration                                          |

## 3. Running simulation

### 3.1. Requirements
#### Major Dependencies
* Julia 1.6.1
* JuMP 0.21.6
* Gurobi 9.1.2
#### Package dependencies and environment setup
To get started, follow these steps:

Initialize the Julia environment by installing the required packages and prepare the results directories by running:
```
julia initialize.jl
```
#### Run the system
For optical planning, run the following command:
```
julia optical_net_planning_channel.jl
```

To perform restoration, execute the provided shell script:
```
bash abstract_optical_layer.sh
```
### Intermediate Result Processing
In addition to optical planning and restoration, FlexWAN involves the processing of three intermediate results. These results are handled by the following scripts:

|  Executable Files                                |  Description                                          |
|  -----                                           |  -----                                                |
|  `src/length_gap_spec_efficiency_analysis.jl`    | Analyzes spectral efficiency in relation to length gaps within the optical network.    |
|  `src/path_length_length_data_rate_analysis.jl`  | Examines the relationship between path lengths and data rate capabilities in the network.    |
|  `src/transponder_spec_analysis.jl`           | Assesses the specifications and capabilities of transponders in the optical network.        |
