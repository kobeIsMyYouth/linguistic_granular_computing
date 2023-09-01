function num = interval2num(interval, theta)
    % sampling a number from an interval
    if interval(2) < interval(1)
        temp = interval(2);
        interval(2) = interval(1);
        interval(1) = temp;
    end

    if interval(1) == interval(2)
        num = interval(1);
    end
    if interval(1) ~= interval(2)
        miu_low = 1/(interval(2)-interval(1))-1/(theta+1)*((interval(2)-interval(1))/2)^theta;
        a = rand;
        % a = 0.5;
        % probability distribution function
        cathy = @(q)(((q-interval(1)).^(theta+1))/(theta+1)+(q-interval(1)).*miu_low) ...
                .*(q>=interval(1) & q<((interval(1)+interval(2))/2)) ...
                +(1/2+(((interval(2)-interval(1))/2).^(theta+1)-(interval(2)-q).^ ...
                (theta+1))/(theta+1)+miu_low.*(2.*q-interval(1)-interval(2))/2) ...
                .*(q>=((interval(1)+interval(2))/2) & q<=interval(2)) - a;
        q0 = (interval(1)+interval(2))/2;
        x = fsolve(cathy, q0); % sampling value from the interval
        num = x(1);
        if num < 0 || num > 1
            num = (interval(2)+interval(1))/2;
        end
    end
    % interval
    % num
    % if existfig~=1
    %     num = (interval(2)+interval(1))/2;
    % end

end

