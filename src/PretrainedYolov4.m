classdef (Abstract) PretrainedYolov4
    properties (Access = protected)
        Network
        Anchors
        ClassNames
    end

    methods (Access = protected)
        function path_init(~)
            addpath assets\libs\pretrained-yolo-v4
            addpath assets\libs\pretrained-yolo-v4\src\
            addpath assets\libs\pretrained-yolo-v4\models
        end

        function init(this)
            if isempty(this.Network)
                error('Network is empty');
            end
            if isempty(this.Anchors)
                error('Anchors is empty');
            end
            if isempty(this.ClassNames)
                error('Class names is empty');
            end
        end
    end

    methods
        function path_delete(~)
            rmpath assets\libs\pretrained-yolo-v4
            rmpath assets\libs\pretrained-yolo-v4\src\
            rmpath assets\libs\pretrained-yolo-v4\models
            rmpath src\
        end
    end

    methods
        % load pretrained network
        function this = loadNetwork(this, netName)
            arguments
                this PretrainedYolov4
                netName (1, :) char ...
                    {mustBeMember(netName, ...
                    {'YOLOv4-tiny-coco', 'YOLOv4-coco'})} ...
                    = 'YOLOv4-tiny-coco'
            end
            if isempty(this.Network)
                % Set the modelName from the above ones to download that pretrained model.
                model = helper.downloadPretrainedYOLOv4(netName);
                this.Network = model.net;
                disp([netName, ' Network Done.']),
            end
        end

        % load anchors
        function this = loadAnchors(this, anchName)
            arguments
                this PretrainedYolov4
                anchName (1, :) char ...
                    {mustBeMember(anchName, ...
                    {'YOLOv4-tiny-coco', 'YOLOv4-coco'})} ...
                    = 'YOLOv4-tiny-coco'
            end

            if isempty(this.Anchors)
                % Get anchors used in training of the pretrained model.
                this.Anchors = helper.getAnchors(anchName);
                disp([anchName, ' Anchors Done.']), 
            end
        end

        % load class names
        function this = loadClassNames(this, name)
            arguments
                this PretrainedYolov4
                name (1, :) char {mustBeMember(name, ...
                    {'coco'})} = 'coco'
            end

            if isempty(this.ClassNames)
                switch name
                    case 'coco'
                        % Get classnames of COCO dataset.
                        this.ClassNames = helper.getCOCOClassNames;
                        disp("COCO class Names Done."),
                end
            end
        end
    end
end