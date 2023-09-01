cutoff_points_optimized = [0 0.2797 0.2920 0.4539 0.5504 0.6681 0.7251 1];
cutoff_points_uniform = [0 1/7 2/7 3/7 4/7 5/7 6/7 1];
cutoff_points_left = [0 1/14 3/14 5/14 7/14 9/14 11/14 1];
cutoff_points_right = [0 3/14 5/14 7/14 9/14 11/14 13/14 1];

num = 500;

consises = zeros(1, num);
for i = 1:num
    consises(i) = Consis(cutoff_points_right);
end

save consis_right.txt -ascii consises