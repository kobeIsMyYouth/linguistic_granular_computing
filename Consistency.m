function cd = Consistency(DLPR, cutoff_points, beta)

    % CONSISTENCY calculating the consistency degree of DLPR given the
    % cutoff_points of the corresponding LTS
    % DLPR 
    d = DLPR2num(DLPR, cutoff_points, beta);  
    % d
    cd = 0;
    m = length(d);
    for k = 1:m
        for u = 1:m
            if k ~= u
                term1 = 0;
                term2 = 0;
                for l = 1:m
                    if l ~= k && l ~= u
                        term1 = term1 + (2 * d(k, l) + 2 * d(l, u) - d(l, k) - d(u, l) + 0.5);
                        term2 = term2 + (2 * d(u, l) + 2 * d(l, k) - d(l, u) - d(k, l) + 0.5);
                    end
                end
                % term1 / (3*(m-2)) - d(k, u)
                % term2 / (3*(m-2)) - d(u, k)
                cd = cd + 2 - abs(term1 / (3*(m-2)) - d(k, u))*(2/3) - abs(term2 / (3*(m-2)) - d(u, k))*(2/3);
            end
        end
    end
    cd = cd / (2 * m * (m - 1));
end

