function ten_outer = outer_pro(v1, v2, v3)
    %outer_pro - Outer product of v1, v2, v3
    %
    % Syntax: ten_outer = outer_pro(v1,v2,v2)
    %
    % Long description

    % v1 = [2, 3, 4];
    % v2 = [3, 4, 5];
    % v3 = [1, 1, 2];

    len1 = length(v1);
    len2 = length(v2);
    len3 = length(v3);

    mat = zeros(len1, len2);

    for i = 1:len1

        for j = 1:len2
            mat(i, j) = v1(i) * v2(j);
        end

    end

    ten_arr = zeros(len1, len2, len3);

    for k = 1:len3

        for i = 1:len1

            for j = 1:len2
                ten_arr(i, j, k) = mat(i, j) * v3(k);
            end

        end

    end

    ten_outer = tensor(ten_arr);

end
