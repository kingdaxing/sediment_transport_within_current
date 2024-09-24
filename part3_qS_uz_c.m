% part3: modifications for suspended sediment with bedforms present

% Read the matrix results from part1; 
% theta_prime calculated by upper and lower regime separation method
data= readtable('adddata_regime.csv');
% Extract [q V D D_prime Uf theta theta_prime] 
q_tr = data.Var1;  
V = data.Var2; 
D = data.Var3;
D_prime = data.Var4;
Uf_prime = data.Var5;
theta = data.Var6;
theta_prime = data.Var7;

% prerequire calculation
Uf = sqrt(theta./theta_prime) .* Uf_prime;
d = 1e-3;  % d = 1 mm =1e-3 m 
vi = 1e-6; % viscosity
Re = Uf.*d./vi;
theta_cri = 0.165*(Re+0.6).^(-0.8)+0.045*exp(-40.*Re.^-1.3); % explicit formular of Shield Paramter
kappa = 0.4;

% prepare for concentration
ws = 0.1120; % from 'fsolve_ws.m'
cb = 0.331.*(theta_prime - 0.045).^1.75 ./ (1+0.331/0.46 .*(theta_prime - 0.045).^1.75);
b = 2*d; % typically

% velocity profile u(z), z=[0.0001, D]; function: [uz, k_star, c] = u_profile(Uf, D, V, cb, ws, b)
% uz = zeros(num_pts, num_var_matrix);
% num_pts: calculated points inserted into one section -> correspond to D(i) 
% num_var_matrix: for each q, the number of V, with q increasing [0.5,5]
[uz, k_star,c] = u_profile(Uf, D, V, cb, ws, b);

% results saved in .csv for part3 - uz and c
writematrix(uz, 'matrix_uz.csv');
writematrix(c, 'matrix_c.csv');

% Integral calculation of qS - function
% calculation of qS use the trapz command to perform the integral
% Calculate qS for each column
qS = trapz_qS(uz, k_star, c, D, b);

% plot qS ~ each q
q_range = transpose(q_tr);
plot(q_range, qS, 'r', 'LineWidth', 2)
xlabel('steady discharge per unit width q (m^2/s)')
ylabel('Suspended sediment transport qS (m^2/s)')
title('Variation of the suspended sediment transport qS vs q')
grid on
set(gca, 'FontSize', 14)
