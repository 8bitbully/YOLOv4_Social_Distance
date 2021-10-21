classdef PeopleDetector < PretrainedYolov4

    methods
        function this = PeopleDetector()
            % libs path init,
            this.path_init;
        end
    end

    methods
        % People detector.
        function detectorBboxesClass = detectPeople(this, image, options)
            arguments
                this PeopleDetector
                image uint8
                options.threshold (1, 1) double = 0.25
                options.executionEnvironment (1, 1) string ...
                    {mustBeMember(options.executionEnvironment, {'auto', 'gpu'})} ...
                    = "auto"
            end

            % pretrained models init
            this.init();

            % objects detect
            [bboxes, scores, labels] = detectYOLOv4(this.Network, ...
                                                    image, ...
                                                    this.Anchors, ...
                                                    this.ClassNames, ...
                                                    options.executionEnvironment);
            
            % People filter
            if ~isempty(labels)
                scoreIdx = scores > options.threshold;
                labelIdx = labels == 'person';
                bboxsIdx = scoreIdx & labelIdx;
        
                detectorBboxesClass = ...
                            DetectorBbox(bboxes(bboxsIdx, :), ...
                                         scores(bboxsIdx, :));
            else % if labesl is empty, an empty object is returned.
                detectorBboxesClass =  DetectorBbox(double.empty(0, 4), ...
                                                    double.empty(0, 1));
            end
        end
    end
end