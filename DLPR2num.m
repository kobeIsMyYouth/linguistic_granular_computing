function num_preference = DLPR2num(DLPR, cutoffpoints, theta)
%   DLPR2NUM Transform a DLPR to a numerical preference relation
%   DLPR = {
%         [0 0 0 1 0 0 0; 0 0 0 1 0 0 0; ...; 0 0 0 1 0 0 0];
%         [0 0 0 1 0 0 0; 0 0 0 1 0 0 0; ...; 0 0 0 1 0 0 0];
%         ...;
%         [0 0 0 1 0 0 0; 0 0 0 1 0 0 0; ...; 0 0 0 1 0 0 0]
%   } 
%   cutoffpoints = [0 0.1 0.2 0.3 0.4 ... 1]

    m = length(DLPR);
    n = length(cutoffpoints);
    
    sampling_value = zeros(1,(n-1));
    for i = 1:n-1
        for j = 1:500
            sampling_value(i) = sampling_value(i) + interval2num([cutoffpoints(i) cutoffpoints(i+1)], theta);
        end
        sampling_value(i) = sampling_value(i) / 500;
    end
    num_preference = zeros(m);
    for k = 1:m
        for l = 1:m
            num_preference(k,l) = dot(DLPR{k}(l,:), sampling_value);
        end
    end
end






