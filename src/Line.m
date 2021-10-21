classdef Line

    properties
        ID (1, 2) % p1.id to p2.id
        Distance (1, 1) double
    end

    properties (SetAccess = private)
        Point1 (1, 2) double % [x1, y1]
        Point2 (1, 2) double % [x2, y2]
    end

    properties
        LineForm (1, 4) double
    end

    % get methods
    methods
        function p1 = get.Point1(this)
            p1 = this.Point1;
        end

        function p2 = get.Point2(this)
            p2 = this.Point2;
        end

        function id = get.ID(this)
            id = this.ID;
        end

        % numeric to string cell method [%num%m]
        function dist = strDistance(this)
            arguments
                this Line
            end

            if isempty(this)
                dist = {' '};
                return,
            end
            dist = cellfun(@(num) [num2str(num), 'm'], ...
                num2cell(round([this.Distance], 2)), ...
                'UniformOutput', false);
        end

        function lineCenter = Center(this)
            lineCenter = double.empty(0, 2);
            if ~isempty(this)
                lineCenter = reshape(mean([this.Point1; this.Point2]), 2, [])';
            end
        end
    end

    % constructor
    methods
        function this = Line(ids, pt1, pt2, dist)
            if nargin > 0
                this.ID = ids;
                this.Point1 = pt1;
                this.Point2 = pt2;
                this.Distance = dist;
            end
        end
        
        % converting from Line type to points that 
        % can be used in line function
        function linefrm = get.LineForm(this)
            linefrm = [this.Point1, this.Point2];
        end
    end

    methods (Static)
        % Matrix to Line class generic array.
        function lineArr = arrayLine(ids, lineList, distance)

            arguments
                ids (:, 2) double
                lineList (:, 4) double
                distance (:, 1) double
            end

            lineArr = repmat(Line, 1, size(lineList, 1));

            for i = 1 : numel(lineArr)
                lineArr(i) = Line(ids(i, :), ...
                                 lineList(i, 1:2), ...
                                 lineList(i, 3:4), ...
                                 distance(i, :));
            end
        end
    end
end