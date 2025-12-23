classdef Country
    % Country class: Represents a nation and its sub-regions (states/provinces)
    % Aggregates data for the country itself and holds a list of State objects.
    
    properties
        Name
        States State       % Array of State objects
        StateNameList      % Cell array of state names
        CumulativeCases 
        CumulativeDeaths
        DailyCases
        DailyDeaths
    end
    
    methods
        function obj = Country(countryName, stateNames, rawData)
            % Constructor: Initializes the country and creates State objects if applicable
            obj.Name = countryName;
            
            % 1. Handle Sub-regions (States/Provinces)
            % If the input list is empty, there are no sub-regions.
            if isempty(stateNames)
                obj.States = State.empty; % Initialize as empty object array
                obj.StateNameList = {};   % Empty cell array
            else
                % The first element is usually the country itself, so we skip it
                % and grab the actual list of states starting from index 2.
                subRegionNames = stateNames(2:end);
                obj.StateNameList = subRegionNames;
                
                % Preallocate the object array for efficiency
                numStates = length(subRegionNames);
                % We need to initialize the first element to define the type
                % or use a loop. Here we loop through to create State objects.
                for k = 1:numStates
                    % data row offset by +1 because row 1 is country total
                    stateData = rawData(k+1, :); 
                    currentStateName = stateNames{k+1};
                    
                    obj.States(k) = State(currentStateName, stateData);
                end
            end
            
            % 2. Handle Country-Level Data
            % Convert the entire raw data cell array to a matrix first
            fullMatrix = cell2mat(rawData);
            
            % The country's total data is always in the first row (index 1)
            countryRow = fullMatrix(1, :);
            
            % Extract Cumulative Stats (Odd cols = Cases, Even cols = Deaths)
            cCases = countryRow(1:2:end);
            cDeaths = countryRow(2:2:end);
            
            obj.CumulativeCases = cCases;
            obj.CumulativeDeaths = cDeaths;
            
            % Calculate Daily Stats
            % Use max(..., 0) to sanitize negative data glitches
            obj.DailyCases = max(diff(cCases, 1, 2), 0);
            obj.DailyDeaths = max(diff(cDeaths, 1, 2), 0);
        end
    end
    
end