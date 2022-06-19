close all; clc; clear all;
%% Description
% In this section we estimate a time dependent reliability of a multistate
% system but in a comprehensive way
%% Defining the network geometry
source=7; target=10;
directed=true;
nodes_neglected=true;
terminals_excluded=true;

source_nodes=[7 8 8 9 7 9 ];
target_nodes=[8 10 9 8 9 10];
net=reliability_net(source, target, directed, nodes_neglected, ...
    terminals_excluded, source_nodes, target_nodes);
sort_output = true;
net.shortest_paths (sort_output);
net.flow_constraints={'flow=demand', 'maximal capacity constraint'};
%% Defining dynamic demand
% inputs d, t
% outputs R
net.time = linspace(0, 160, 10);
d = 40*sin(2*pi*net.time/400).^2;
net.demand_in_time = round(d);           % to ensure integer-valued demand
w = [4 3 2 3 2];            % maximal component per each arc
k = [10 15 25 15 20];       % maximal capacity per each component
alpha = [300 180 200 350 250];
beta = [1 1 0.8 1.1 1];
%--------------- Reordering according to our paper original order
order_vec = [4 5 3  3 1 2];
w = w(order_vec);
k = k(order_vec);

alpha = alpha(order_vec);
beta = beta(order_vec);
net.k = k;
%---------------- Defining reliability functions ------------------
% building arc reliability matrix
dist = repmat("weibull", 1,6);
parameters = cell(1, 6);
for i=1:6
    parameters{i} = [alpha(i), beta(i)];
end
net.reliability_dependent_time (w, dist, parameters);
net.plot_time_reliablity();