% smaller intervals; adddata_regime res [V D D_prime Uf theta theta_prime] 
% Inputs
Slope = 0.001; % channel slope
d = 1e-3;  % d = 1 mm =1e-3 m 
k_N = 2.5*d;  % k_N=2.5d
g = 9.81; 
s = 2.65; % s = 2.65

% steady discharge per unit width q range: 0.5 m2/s < q < 5 m2/s,
% add more data for part3!
q_range = 0.5: 0.001: 5;   

% initial matrix for results (V D D_prime Uf theta theta_prime)
num_q = length(q_range);
error = zeros(6,num_q);
V_matrix = zeros(num_q, 1);
D_matrix = zeros(num_q, 1);
D_prime_matrix = zeros(num_q, 1);
Uf_prime_matrix = zeros(num_q, 1);
theta_matrix = zeros(num_q, 1);
theta_prime_matrix = zeros(num_q, 1);

% Initial guess for the first iteration
guess = [0.5 0.5 0.1 0.03 0.3 0.3]; % [V D D_prime Uf theta theta_prime] 

% loop for fsolve_ThreeEqns
for i = 1:num_q
    q = q_range(i);
    
   % Make a vector containint the constants
   cvec = [q Slope d k_N g s];

   % Use fsolve to solve the system of equations (6 equations)
   % firstly use lower regime eqn for theta_prime
   [sol, ~, exitflag] = fsolve(@(solvec)  q_SixEqn_lower(solvec, cvec), guess);
   error(1:6,i) = q_SixEqn_lower(sol, cvec);
   theta_prime_matrix(i) = sol(6);

   if theta_prime_matrix(i) > 0.55 % upper regime
        [sol] = fsolve(@(solvec)  q_SixEqn_upper(solvec,cvec), guess);
        error(1:6,i) = q_SixEqn_upper(sol, cvec);
   end

    % save the solution in the matrix
    V_matrix(i) = sol(1);
    D_matrix(i) = sol(2);
    D_prime_matrix(i) = sol(3);
    Uf_prime_matrix(i) = sol(4);
    theta_matrix(i) = sol(5);
    theta_prime_matrix(i) = sol(6);
    
    % Update guess for the next iteration
    % guess = sol; % Use the solution from the current iteration as the initial guess for the next iteration
end


%%% Plot results
% Plot 1) D ~ q 
subplot(2,2,1);
plot(q_range, D_matrix, 'r', 'LineWidth', 2)
xlabel('steady discharge per unit width q (m^2/s)')
ylabel('Flow depth D (m)')
title('D ~ q')
grid on
% verify there is not the imaginary part
set(gca, 'FontSize', 12)

% Plot 2) V ~ q 
subplot(2,2,2);
plot(q_range, V_matrix, 'b', 'LineWidth', 2)
xlabel('steady discharge per unit width q (m^2/s)')
ylabel('mean velocity V (m/s) ')
title('V ~ q')
grid on
set(gca, 'FontSize', 12)

% Plot 3) theta_prime ~ q  
subplot(2,2,3);
plot(q_range, theta_prime_matrix, 'g', 'LineWidth', 2)
xlabel('steady discharge per unit width q (m^2/s)')
ylabel('θ’: the skin friction component ')
title('θ’ ~ q')
grid on
set(gca, 'FontSize', 12)
% layer line at theta_prime=0.55
yline(0.55, 'r--', 'LineWidth', 1.5);  
% add text to identify area
text(3, 0.55, 'Upper region for θ’', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 12, 'Color', 'black');
text(1, 0.55, 'Lower region for θ’', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left', 'FontSize', 12, 'Color', 'black');

ratio=theta_matrix./theta_prime_matrix;
% Plot 4) theta/theta_prime = D/D_prime ~ q  
subplot(2,2,4);
plot(q_range, ratio, 'black', 'LineWidth', 2)
xlabel('steady discharge per unit width q (m^2/s)')
ylabel(' θ/θ’ ')
title('the ratio of θ/θ’ ~ q')
grid on
set(gca, 'FontSize', 12)
hold off

% results saved in .csv 
 q_tr = transpose(q_range)
% [V D D_prime Uf theta theta_prime] 
 matrix = [q_tr, V_matrix, D_matrix, D_prime_matrix,Uf_prime_matrix,theta_matrix,theta_prime_matrix];
% writematrix(matrix, 'adddata_regime.csv');