% define fun() for generate data on a log scale
% input data must be double (not table!)
function data_interpolated_log = interpolate_velocity_profile(z, cal_data, z_grid)
    % Interpolate velocity profile data onto the log-spaced grid
    data_interpolated_log = interp1(z, cal_data, z_grid, 'linear', 'extrap');
end
