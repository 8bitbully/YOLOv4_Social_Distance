classdef DetectorCircle
    properties
        x (1, 1) double
        y (1, 1) double
        radius (1, 1) double
    end

    % constructor
    methods
        function this = DetectorCircle(x, y, r)
            if nargin > 0
                this.x = x;
                this.y = y;
                this.radius = r;
            end
        end
    end

    methods
        function circ = circleForm(this)
            
            arguments
                this DetectorCircle 
            end

            circ = [this.x; this.y; this.radius]'; % [x, y, radius]::(:, 3)
        end
    end

    % static methods
    methods (Static)
        function circ = bboxCenter2Circle(center, prop)
            
            arguments
                center (:, 2) double
                prop.radius (1, 1) double = 2
            end

            circ = DetectorCircle.empty(size(center, 1), 0);

            for i = 1 : size(circ, 1)
                circ(i, 1) = DetectorCircle(center(i, 1), ...
                                            center(i, 2), ...
                                            prop.radius);
            end
        end
    end
end