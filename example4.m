clc; clear all; close all;
 
%% Network Structure
source=31; target=56; 
directed=false; 
nodes_neglected=true;
terminals_excluded=true;
% source and sink are named 35,  36
source_nodes=[31:43 31 44:46 39 47:48 33 31 49:54 53 55];
target_nodes=[32:43 56 44:46 39 47:48 56 44 49:54 56 55 56];
net=reliability_net(source, target, directed, nodes_neglected, terminals_excluded, source_nodes, target_nodes);
sort_output = false;
net.shortest_paths (sort_output);
plot(net);
%% Reading Capacity Distributions
c=readmatrix('Aissou_TANET_capacity_distrubution.txt');
selected_components= [47 4 48 3 21 6 15 39 53 61 60 64 80 ...
                      37 20 65 17 79 58 44 7 51 1 77 8 2 33 54 5 14]; % according to the choice of R_(d=4,T=16)
c=c(selected_components, :);  % delete other elements
c(:, [1 end-1:end])=[];
CP=cell(1,size(c,1));
for i=1:size(c,1)
    for j=1:size(c,2)
        if c(i,j)~=0
            CP{i}(j)=c(i,j);
        elseif j+1<=size(c,2)
            if c(i,j+1)~=0
                CP{i}(j)=0;                
            end
        end
    end
end
celldisp(CP, 'cp');
net.error=[4 8 6 5 5 5 5 7 3 2 5 7 5 8 5 6 2 5 5 5 5 5 5 5 4 3 2 1 3 6]/1000; 
net.cost=[4 3 1 2 5 4 5 5 2 2 2 3 2 6 4 5 3 2 1 1 1 2 1 4 2 1 5 4 2 3];

net.take_capacity (CP);
net.flow_constraints={'flow=demand', 'maximal capacity constraint', 'cost', 'error'};
demand=3;   % to find flow vectors at this demand
plot_curve = true;  maximal_cost = 120; maximal_error = 0.04; compute_fast = false;
method_of_generation = 2;    % method 2 uses sparse matrix to accomodate large number of vectors and for speed purposes                 
F=net.generate_flows(demand, maximal_cost, maximal_error, method_of_generation)
[X,F1]=update_state_vectors(net, F)
r=net.rel(X,false);
% maximal_cost can be 120, 80, 60 to match with paper
% maximal_error can be 0.03, 0.035, 0.04, 1 to match with the paper
figure;
net.evaluate_reliability(plot_curve, maximal_cost, maximal_error, compute_fast);
disp(net);

