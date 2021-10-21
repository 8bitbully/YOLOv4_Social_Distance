classdef DetectorBbox
    properties
        BoundingBoxes (:, 4) double
        Scores (:, 1) double
    end

    properties
        Center (:, 2) double
        EmptyBoxes logical
    end

    properties
        Threshold (1, 1) double = 0.25
    end

    % constructor
    methods
        function this = DetectorBbox(bboxes, scores)
            if nargin > 0
                this.BoundingBoxes = bboxes;
                this.Scores = scores;
            end
        end
    end

    methods
        % Bounding Boxes center.
        function center = get.Center(this)
            center = this.BoundingBoxes(:, 1:2) + ...
                        this.BoundingBoxes(:, 3:4) .* .5;
        end

        % Bounding boxes isEmpty
        function empty = get.EmptyBoxes(this)
            empty = isempty(this.BoundingBoxes);
        end
    end

    methods
        % bounding box filtering from indexes.
        function bboxIdx = fromIndex(this, ind)
            arguments
                this DetectorBbox
                ind (1, :) uint8
            end

            bboxIdx = zeros(size(this.BoundingBoxes, 1), 1);
            bboxIdx(ind) = 1;
            bboxIdx = logical(bboxIdx);
        end

        function circ = toCircle(this, prop)
            arguments
                this DetectorBbox
                prop.radius (1, 1) double = 2
            end

            circ = DetectorCircle.bboxCenter2Circle(this.Center, ...
                                                    radius= prop.radius);
        end
    end

    methods
        function [obj1, obj2] = matchBoundingBox(obj1, obj2, prop)

            arguments
                obj1 DetectorBbox
                obj2 DetectorBbox
                prop.Unique (1, 1) logical ...
                    {mustBeInRange(prop.Unique, 0, 1)} = true
                prop.MaxRatio (1, 1) double ...
                    {mustBeInRange(prop.MaxRatio, 0, 1)} = 0.8
                prop.Threshold (1, 1) double ...
                    {mustBeInRange(prop.Threshold, 0, 100)} = 40
            end

            matchIdx = matchFeatures(obj1.BoundingBoxes, obj2.BoundingBoxes, ...
                "MaxRatio", prop.MaxRatio, "Unique", prop.Unique, ...
                "MatchThreshold", prop.Threshold);

            if ~obj1.EmptyBoxes || ~obj2.EmptyBoxes
                obj1.BoundingBoxes = obj1.BoundingBoxes(matchIdx(:, 1), :);
                obj1.Scores = obj1.Scores(matchIdx(:, 1), :);
                obj2.BoundingBoxes = obj2.BoundingBoxes(matchIdx(:, 2), :);
                obj2.Scores = obj2.Scores(matchIdx(:, 2), :);
            end
        end

        % [Brute force]
        % Temporary solution for equal bounding boxes of objects detected
        % from right and left camera
        function [obj1, obj2] = minimizeBoundingBox(obj1, obj2)
            
            arguments
                obj1 DetectorBbox
                obj2 DetectorBbox
            end

            if ~obj1.EmptyBoxes || ~obj2.EmptyBoxes
                minDetect = min([size(obj1.BoundingBoxes, 1), ...
                    size(obj2.BoundingBoxes, 1)]);
                obj1.BoundingBoxes = obj1.BoundingBoxes(1:minDetect, :);
                obj1.Scores = obj1.Scores(1:minDetect, :);
                obj2.BoundingBoxes = obj2.BoundingBoxes(1:minDetect, :);
                obj2.Scores = obj2.Scores(1:minDetect, :);
            end
        end
    end
end