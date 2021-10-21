% The situations where the detected people are at risk or safe, 
% the distance between them and the objects to be drawn.
function retZone = detectedObjectProperty(point3d, bboxes, prop)
    
    arguments
        point3d (:, 1) Point3D
        bboxes DetectorBbox % left or right bbox class
        prop.distance (1, 1) double = 1.5 % meter
    end
    
    % returns empty if there are no point.
    if isempty(point3d)
        retZone = Zone(uint8.empty(0, 1), ...
                        Line.empty(0, 1), ...
                        Line.empty(0, 1));
%         retZone.Distance = double.empty(0, 1);
        return,
    end

    % distance between detected people.
    combPoint = nchoosek(point3d, 2); 
    combDist = combPoint(:, 2).Meter - combPoint(:, 1).Meter; % [1, n]

    distIdx = combDist < prop.distance; % [1, n]

    % Determine the values to be used for the drawing,
    ids = unique([combPoint(distIdx, :).ID]);

    % init line matrix
    count = reshape([combPoint.ID], [], 2);

    % necessary points for drawing lines
    leftLine = bboxes.Center(count(:, 1), :);
    rightLine = bboxes.Center(count(:, 2), :);
    linePt = cat(2, leftLine, rightLine);

    % seperate safe and risky points
    safe = linePt(~distIdx, :);
    risk = linePt(distIdx, :);

    retZone = Zone(ids, ...
        Line.arrayLine(count(~distIdx, :), safe, combDist(~distIdx)), ...
        Line.arrayLine(count(distIdx, :), risk,  combDist(distIdx)));
    
    % threshold distance,
    retZone.Distance = prop.distance;
    %
end