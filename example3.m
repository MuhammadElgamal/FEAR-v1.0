clc; clear all; close all;
%% Example 3 Evaluation
% nodes are ordered begining from source in anticlock wise direction in
% Fig.5
source=12; target=13; 
directed=true; 
nodes_neglected=false;
terminals_excluded=true;
 
source_nodes=[12  9   12  9  9  10 10 11];
target_nodes=[9   10  10  13 11 13 11 13] ;
net=reliability_net(source, target, directed, nodes_neglected, ...
        terminals_excluded, source_nodes, target_nodes);
plot(net); 
%_______________   Entering Capacity ______________________________________
CP=cell(1,6);           % a cell array that contains probability distribution for each arc capacity, each cell has maximal_cap(i)+1 length and sums to one 
CP{1}=[5 5 10 10 70]; 
CP{2}=[5 5 10 20 60];       
CP{3}=[10 15 20 20 35];           
CP{4}=[5 10 20 65];
CP{5}=[5 5 5 15 70];
CP{6}=[20 20 30 30];
CP{7}=[5 10 10 10 10 55];
CP{8}=[10 10 10 10 60];
CP{9}=[5 5 5 10 15 60];
CP{10}=[10 25 25 40];
CP{11}=[5 10 10 20 55];
CP=cellfun(@(x) x./100, CP, 'UniformOutput', false);
net.error=[5 3 6 2 8 4 4 5 8 6 7]/1000;
net.take_capacity (CP);
sort_output = true;
net.shortest_paths (sort_output);
net.flow_constraints={'flow=demand', 'maximal capacity constraint','error'};

%% Path Ordering to Appear in same order as Lin 2013
A=net.P;
order=[1 3 6 4 5 2];
A.arcs=cell(size(net.P.arcs));
A.components=cell(size(net.P.arcs));
for i=1:length(order)
    A.arcs{i}=net.P.arcs{order(i)};
    A.components{i}=net.P.components{order(i)};
end
net.P=A;
 
%% Estimating Reliability
% change maximal_error to be 0.02, 0.03 to match with paper
figure;
plot_curve = true;  maximal_cost = []; maximal_error = 0.03; compute_fast = false;
net.evaluate_reliability(plot_curve, maximal_cost, maximal_error, compute_fast);
disp(net);