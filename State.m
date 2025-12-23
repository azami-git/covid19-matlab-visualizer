classdef State
    % State class: Represents regional COVID data statistics
    % Stores cumulative and daily figures for cases and deaths.
    
    properties
        Name
        CumulativeCases
        CumulativeDeaths
        DailyCases
        DailyDeaths
    end
    
    methods
        function obj = State(region_name, input_data)
            % Constructor: Sets the name and processes the raw data cell array
            obj.Name = region_name;
            
            % Convert the input cell array into a numeric matrix
            numericData = cell2mat(input_data);
            
            % Extract cumulative data using indexing
            % Cases are in the odd positions (1, 3, 5...), Deaths in even (2, 4, 6...)
            cCases = numericData(1:2:end);
            cDeaths = numericData(2:2:end);
            
            % Assign cumulative properties
            obj.CumulativeCases = cCases;
            obj.CumulativeDeaths = cDeaths;
            
            % Calculate daily statistics
            % We use diff() to get the change per day and max(..., 0) 
            % to ensure negative values (data errors) are treated as 0.
            
            daily_cases_calc = diff(cCases, 1, 2);
            obj.DailyCases = max(daily_cases_calc, 0);
            
            daily_deaths_calc = diff(cDeaths, 1, 2);
            obj.DailyDeaths = max(daily_deaths_calc, 0);
        end
    end
    
end