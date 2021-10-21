classdef Zone
    properties
        Ids (1, :) uint8
        Safe (1, :) Line
        Risk (1, :) Line
    end

    properties
        Distance (1, 1) double
    end

    % constructor   
    methods
        function this = Zone(ids, safe, risk)
            if nargin > 0
                this.Ids = ids;
                this.Safe = safe;
                this.Risk = risk;
            end
        end

        function bool = isEmpty(this)
            bool = false;
            if isempty(this.Risk) && isempty(this.Safe)
                bool = true;
            end
        end
    end
end