classdef person
    properties
        id
        connections
        infected = false
        recovered = false
    end
    
    methods
        function obj = person(id)
            if nargin > 0  
                obj.id = id;
                obj.connections = [];
            end
        end
        
        function obj = addConnection(obj, other)
            obj.connections = [obj.connections, other.id];
        end

        function obj =  infect(obj)
            if ~obj.infected && ~obj.recovered
                obj.infected = true;
            end
        end
        
        function obj = recover(obj)
            if obj.infected
                obj.infected = false;
                obj.recovered = true;
            end
        end
    end
end