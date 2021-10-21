% triangulate points methods
function point3d = triangulatePoints(left, right, prop)

    arguments
        left DetectorBbox
        right DetectorBbox
        prop.stereoParams stereoParameters
        prop.cameraMatrix1 double = double.empty(4, 0); % (4x3)
        prop.cameraMatrix2 double = double.empty(4, 0); % (4x3)
    end

    assert(isequal(size(left), size(right)), ...
        'Detecting objects in two frames are not equal.');

    % if camera matrices are used.
    if ~isempty(prop.cameraMatrix1) && ~isempty(prop.cameraMatrix2)
        point3d = Point3D.arrayPoint3D( ...
            triangulate(left.Center, right.Center, ...
            prop.cameraMatrix1, prop.cameraMatrix2) ...
            );
        return,
    else % with stereo camera parameters,
        point3d = Point3D.arrayPoint3D( ...
            triangulate(left.Center, right.Center, prop.stereoParams) ...
            );
    end
end