% Integral calculation of qS 
function qS = trapz_qS(uz, k_star, c, D, b)
    num_var_q = length(D);
    qS = zeros(1, num_var_q);
    num_rows = length(D);  % as q_range = 0.5: 0.01: 5; num_rows = 451

    % Define the lower bound limit 
    b_star = max(k_star ./ 30, b); 

    % Calculate qS for each column
    for i = 1:num_var_q
        % Find the index corresponding to the lower limit
        [~, start_index] = min(abs(linspace(0.0001, D(i), num_rows) - b_star(i))); % z[0.0001, D]
       
        % Perform the trapezoidal integration with specified lower and upper bounds
        qS(i) = trapz(uz(start_index:end, i) .* c(start_index:end, i));
    end
end
