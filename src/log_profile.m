% HINT1: check the results of uz and c
% For each q, evaluate analytical velocity uz and concentration profiles c on a vertically stretched grid, 
% with points that are equidistant on a log scale in the interval b* ≤ z ≤ D (use the logspace command).
uz_table = readtable('matrix_uz.csv');
c_table = readtable('matrix_c.csv'); 
% read the results.csv for D

% Define the number of points
num_pts = length(D);

% Define the range for the log scale
z_min = 0.0001; % Minimum value for z
z_max = D(1);     % Maximum value for z, assuming D is defined
z = linspace(z_min, z_max, num_pts); % uniform number of data

% Generate the vertically stretched grid
z_grid = logspace(log10(z_min), log10(z_max), num_pts);

% Evaluate and generate interpolated data at the grid points on log scale
% func(): data_interpolated_log = interpolate_velocity_profile(z, cal_data, z_grid)
% column correspond to q 
uz_log_inter = interpolate_velocity_profile(z, uz1, z_grid);
c_log_inter = interpolate_velocity_profile(z, c1, z_grid);


uz1 = uz_table.Var1; 
c1 = c_table.Var1; 


% Plot the interpolated data on a logarithmic scale
figure(1)
semilogx(uz_log_inter, z_grid, 'c', 'LineWidth', 2);  % semilogy() plot log at y-axis
ylabel('z');
xlabel('u_z');
yline(b_star(1),'r--', 'LineWidth', 1)
title('Velocity Profile on Log Scale');
grid on;



