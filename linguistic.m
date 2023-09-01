classdef linguistic < PROBLEM
    %LINGUISTIC Summary of this class goes here
    %   Detailed explanation goes here
    

    methods
        %% Default settings of the problem
        function Setting(obj)
            obj.M = 1;
            obj.D = 6;
            obj.lower    = zeros(1,obj.D);
            obj.upper    = zeros(1,obj.D) + 1;
            obj.encoding = ones(1,obj.D);
        end

        %% Initialization
        function Population = Initialization(obj, N)
            if nargin < 2
            	N = obj.N;
            end
            PopDec = rand(N,obj.D);
            % PopDec
            Type   = arrayfun(@(i)find(obj.encoding==i),1:5,'UniformOutput',false);
            if ~isempty(Type{1})        % Real variables
                PopDec(:,Type{1}) = unifrnd(repmat(obj.lower(Type{1}),N,1),repmat(obj.upper(Type{1}),N,1));
            end
            if ~isempty(Type{2})        % Integer variables
                PopDec(:,Type{2}) = round(unifrnd(repmat(obj.lower(Type{2}),N,1),repmat(obj.upper(Type{2}),N,1)));
            end
            if ~isempty(Type{3})        % Label variables
                PopDec(:,Type{3}) = round(unifrnd(repmat(obj.lower(Type{3}),N,1),repmat(obj.upper(Type{3}),N,1)));
            end
            if ~isempty(Type{4})        % Binary variables
                PopDec(:,Type{4}) = logical(randi([0,1],N,length(Type{4})));
            end
            if ~isempty(Type{5})        % Permutation variables
                [~,PopDec(:,Type{5})] = sort(rand(N,length(Type{5})),2);
            end
            Population = obj.Evaluation(PopDec);
        end
        

        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)

            for i = 1:size(PopDec, 1)
                for j = 1:size(PopDec, 2)
                    PopDec(i,j)
                    if PopDec(i,j) < 0 || PopDec(i,j) > 1
                        PopDec(i,j) = rand;
                    end
                end
            end

            % PopDec
            for i = 1:size(PopDec,1)
                cutoff_points = [0 PopDec(i,:) 1];
                PopObj(i,1) = -Consis(cutoff_points);
            end
        end
        %% Calculate constraint violations
        function PopCon = CalCon(obj,PopDec)
            % for i = 1:size(PopDec, 1)
            %     for j = 1:size(PopDec, 2)
            %         PopDec(i,j)
            %         if PopDec(i,j) < 0 || PopDec(i,j) > 1
            %             PopDec(i,j) = rand;
            %         end
            %     end
            % end

            for i = 1:size(PopDec,1)
                for j = 1:(size(PopDec,2)+1)
                    if j == 1
                        if PopDec(i,j) == 0
                            PopCon(i,j) = -1;
                        else
                            PopCon(i,j) = -PopDec(i,j);
                        end
                    elseif j == (size(PopDec, 2) + 1)
                        if PopDec(i,j-1) == 1
                            PopCon(i,j) = -1;
                        else
                            PopCon(i,j) = PopDec(i,j-1) - 1;
                        end
                    else
                        if PopDec(i,j-1) == PopDec(i,j)
                            PopCon(i,j) = -1;
                        else
                            PopCon(i,j) = PopDec(i,j-1) - PopDec(i,j);
                        end
                    end
                end
            end

            % PopCon(:,1) = -PopDec(:,1);
            % for i = 2:obj.D
            %     PopCon(:,i) = PopDec(:,i-1) - PopDec(:,i);
            % end
            % PopCon(:,obj.D+1) = PopDec(:,obj.D)-1;

            for i = 1:obj.D
                PopCon(:, i+obj.D+1) = (i - 1) / (obj.D+1) - PopDec(:, i);
                PopCon(:, i+2*obj.D+1) = PopDec(:, i) - (i + 1) / (obj.D+1);
            end
            
            for i = 1:size(PopDec,1)
                for j = 1:(size(PopDec,2)+1)
                    if j == 1
                        if PopDec(i,j) == 0
                            delta = 0.0000000001;
                        else
                            delta = PopDec(i,j);
                        end
                        PopCon(i,3*obj.D+1+j) = -1.0 / log(delta/2) - 2; %beta
                    elseif j == size(PopDec,2)+1
                        if PopDec(i, j-1) == 1
                            delta = 0.0000000001;
                        else
                            delta = 1.0-PopDec(i, j-1);
                        end
                        PopCon(i,4*obj.D+2) = -1.0 / log(delta/2) - 2; %beta
                    else
                        if PopDec(i, j) == PopDec(i, j-1)
                            delta = 0.0000000001;
                        else
                            delta = PopDec(i, j) - PopDec(i, j-1);
                        end
                        PopCon(i, j+3*obj.D+1) = -1.0 / log((abs(delta))/2) - 2; %beta
                    end
                end
            end

            % if PopDec(:, 1) == 0
            %     delta = 0.0000000001;
            % else
            %     delta = PopDec(:, 1);
            % end
            % PopCon(:, 3*obj.D+2) = -1 / log(delta/2) - 2; %beta
            % for i = 2:obj.D
            %     if PopDec(:, i) == PopDec(:, i-1)
            %         delta = 0.0000000001;
            %     else
            %         delta = PopDec(:, i) - PopDec(:, i-1);
            %     end
            %     PopCon(:, i+3*obj.D+1) = -1 / log((abs(delta))/2) - 2; %beta
            % end
            % if PopDec(:, obj.D) == 1
            %     delta = 0.0000000001;
            % else
            %     delta = abs(1-PopDec(:, obj.D));
            % end
            % PopCon(:, 4*obj.D+2) = -1 / log(delta/2) - 2; %beta
            % PopCon
        end
    end
end

