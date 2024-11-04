classdef EpidemicSimulation
    properties
        population
        infectionRate
        recoveryRate
        days
    end
    
    methods
        function obj = EpidemicSimulation(population, infectionRate, recoveryRate, days)
            obj.population = population;
            obj.infectionRate = infectionRate;
            obj.recoveryRate = recoveryRate;  
            obj.days = days;

            randomIndex = randi(length(obj.population));
            obj.population(randomIndex) = obj.population(randomIndex).infect();
        end
        
        
        function obj = simulate(obj)
            infectedHistory = zeros(1, obj.days);
            recoveredHistory = zeros(1, obj.days);
            notInfectedHistory = zeros(1, obj.days); 
            
            for day = 1:obj.days
                infectedHistory(day) = sum([obj.population.infected]);
                recoveredHistory(day) = sum([obj.population.recovered]);
                notInfectedHistory(day) = length(obj.population) - infectedHistory(day) - recoveredHistory(day);
                
                for i = 1:length(obj.population)
                    if obj.population(i).infected
                        for j = obj.population(i).connections
                            if ~obj.population(j).infected && ~obj.population(j).recovered
                                if rand() < obj.infectionRate
                                    obj.population(j) = obj.population(j).infect();
                                end
                            end
                        end
                        if rand() < obj.recoveryRate
                            obj.population(i) = obj.population(i).recover();
                        end
                    end
                end
            end
            
            figure;
            plot(1:obj.days, infectedHistory, 'r', 'DisplayName', 'Infected');
            hold on;
            plot(1:obj.days, recoveredHistory, 'b', 'DisplayName', 'Recovered');
            hold on;
            plot(1:obj.days, notInfectedHistory, 'g', 'DisplayName', 'Not Infected'); 
            xlabel('Days');
            ylabel('Population');
            title('Epidemic Simulation');
            legend show;
            grid on;
        end
    end
end