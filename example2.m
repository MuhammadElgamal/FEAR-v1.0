clc; clear all; close all;
%% Example 2 Evaluation
% nodes are ordered begining from source in anticlock wise direction in
% Fig.2
 
source=7; target=9; 
directed=true; 
nodes_neglected=true;
terminals_excluded=true;
 
source_nodes=[7 8 8 10 7 10];
target_nodes=[8 9 10 8 10 9];
net=reliability_net(source, target, directed, nodes_neglected, ...
        terminals_excluded, source_nodes, target_nodes);
plot(net); 
%_______________ Entering Capacity Levels _________________________________
CP=cell(1,6);           
CP{1}=[0.05 0.1 0.25 0.6]; 
CP{2}=[0.1 0.2 0.7];       
CP{3}=[0.1 0.9];           
CP{4}=CP{3};
CP{5}=[0.2 0.8];
CP{6}=CP{2};
net.cost=[2 3 1 1 3 3];
H = 18;                     % can be any of 6, 10, 14, 18 as in paper
net.take_capacity (CP);
sort_output = true;
net.shortest_paths (sort_output);
net.flow_constraints={'flow=demand', 'less than Lj', 'maximal capacity constraint','cost'};
figure;
plot_curve = true;  maximal_cost = H; maximal_error = []; compute_fast = false;
net.evaluate_reliability(plot_curve, maximal_cost, maximal_error, compute_fast);
disp(net);

