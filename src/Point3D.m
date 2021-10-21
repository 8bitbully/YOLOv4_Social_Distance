classdef Point3D
    properties
        x (1, 1) double {mustBeNonNan} = 0.0
        y (1, 1) double {mustBeNonNan} = 0.0
        z (1, 1) double {mustBeNonNan} = 0.0
    end

    properties
        ID
    end

    properties
        EmptyPoint logical
    end

    % constructor
    methods
        function this = Point3D(id, x, y, z)
            if nargin > 0
                this.ID = id;
                this.x = x;
                this.y = y;
                this.z = z;
            end
        end
    end

    % get methods
    methods
        function x = get.x(this)
            x = this.x;
        end

        function y = get.y(this)
            y = this.y;
        end

        function z = get.z(this)
            z = this.z;
        end

        function id = get.ID(this)
            id = this.ID;
        end

        function empty = get.EmptyPoint(this)
            empty = isempty(this.x) | ...
                    isempty(this.y) | ...
                    isempty(this.z);
        end

        function this = Meter(this)
            for i = 1 : numel(this)
                this(i).x = this(i).x / 1e3;
                this(i).y = this(i).y / 1e3;
                this(i).z = this(i).z / 1e3;
            end
        end
    end

    % Overload
    methods
        % operator overload, output point distance
        function dist = minus(obj1, obj2)
            arguments
                obj1 Point3D
                obj2 Point3D
            end

            dx = [obj1.x] - [obj2.x];
            dy = [obj1.y] - [obj2.y];
            dz = [obj1.z] - [obj2.z];

            dist = sqrt(dx.^2 + dy.^2 + dz.^2);
        end
    end

    
    methods (Static)

        % matrix to Point3D generic array
        function point3d = arrayPoint3D(pointArr)
            arguments
                pointArr (:, 3) double
            end

            point3d = repmat(Point3D, size(pointArr, 1), 1);

            for i = 1 : numel(point3d)
                point3d(i) = Point3D(i, ...
                                    pointArr(i, 1), ...
                                    pointArr(i, 2), ...
                                    pointArr(i, 3));
            end
        end

        % input, Point3D class
        function pt = isPoint(point)
            pt = isa(point, 'Point3D');
        end
    end
end