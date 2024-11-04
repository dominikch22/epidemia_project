%% 
function network = generateRandomNetwork(numNodes, numConnections)
     for i = 1:numNodes
        nodes(i) = person(i);
    end
    
    connectionsCounter = 0;
    for i = 1:numNodes
        connectionsCounter = 0;
        while connectionsCounter < numConnections
            nodeB = randi(numNodes);
            
            if nodeB ~= i && ~ismember(nodes(nodeB).id, nodes(i).connections)
                nodes(i) = nodes(i).addConnection(nodes(nodeB));
                nodes(nodeB) = nodes(nodeB).addConnection(nodes(i));
                connectionsCounter = connectionsCounter + 1;
            end
        end
    end
    
    network = nodes;
end

function network = generateCyclicRegularNetwork(numNodes)
    for i = 1:numNodes
        nodes(i) = person(i);
    end
    
    for i = 1:numNodes
        nextNode1 = mod(i + 32, numNodes) + 1; 
        nextNode2 = mod(i + 64, numNodes) + 1; 
        
        nodes(i) = nodes(i).addConnection(nodes(nextNode1));
        nodes(i) = nodes(i).addConnection(nodes(nextNode2));
        
        nodes(nextNode1) = nodes(nextNode1).addConnection(nodes(i));
        nodes(nextNode2) = nodes(nextNode2).addConnection(nodes(i));
    end
    
    network = nodes;
end
     
%  Barabási-Albert
function network = generateScaleFreeNetwork(numNodes, numConnections)
    for i = 1:numNodes
        nodes(i) = person(i);
    end
    connectionsCounter = 1;
    
    if numNodes > 1
        nodes(1) = nodes(1).addConnection(nodes(2));
        nodes(2) = nodes(2).addConnection(nodes(1));
    end
    
        for i = 3:numNodes
            connectionsCounter = 0;
            while numConnections > connectionsCounter
                for j = 1:i-1
                    sumDegrees = 0;
                    for k = 1:i-1
                        sumDegrees = sumDegrees + length(nodes(k).connections);
                    end
                    prob =  length(nodes(j).connections) / sumDegrees ;
                    
                    if rand < prob
                       if ~ismember(nodes(j).id, nodes(i).connections) && ~ismember(nodes(i).id, nodes(j).connections)
                            nodes(i) = nodes(i).addConnection(nodes(j));
                            nodes(j) = nodes(j).addConnection(nodes(i));
                            connectionsCounter = connectionsCounter + 1;
                            if numConnections <= connectionsCounter
                                break;
                            end
                        end
                    end
                end
            end
        end
    
    network = nodes;
end

numNodes = 1000; 
%network = generateScaleFreeNetwork(numNodes, 2);
%network = generateRandomNetwork(numNodes, 2);
network = generateCyclicRegularNetwork(numNodes);

simulation = EpidemicSimulation(network, 0.05, 0.05, 365*2);
simulation = simulation.simulate();
%%

R = 10;
theta = linspace(0, 2*pi, numNodes + 1); 
theta(end) = []; 

x = R * cos(theta);
y = R * sin(theta);

numConnections = zeros(numNodes, 1);
for i = 1:numNodes
    numConnections(i) = length(network(i).connections); 
end

sizes = numConnections * 5 +10;
sizes = sizes';

figure;
hold on;
for i = 1:numNodes
    for j = 1:length(network(i).connections)
        otherId = network(i).connections(j);
        plot([x(i), x(otherId)], [y(i), y(otherId)], 'k-', 'LineWidth', 0.3); 
    end
end

scatter(x, y, sizes, 'filled', 'MarkerFaceColor', 'b'); 
hold off;
axis equal;
title('Sieć regularna');

