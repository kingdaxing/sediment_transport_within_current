% velocity profile u(z), z=[0, D]
function [uz, k_star, c] = u_profile(Uf, D, V, cb, ws, b)
  kappa = 0.4;
  % k* is an effective roughness length.
  num_pts = length(Uf);
  num_var_q = length(Uf);
  uz = zeros(num_pts, num_var_q);
  c = zeros(num_pts, num_var_q);
  qS = zeros(1, num_var_q);
  z_min = 1e-10;

  for i = 1:num_pts
      D_val = D(i);
      Uf_val = Uf(i);
      V_val = V(i);
      cb_val = cb(i);
      k_star_val = D_val/exp(kappa*(V_val/Uf_val - 6));
      z = linspace(z_min, D_val, num_pts); % uniform number of data
      for j = 1:num_var_q
         if z(j) <= D_val
            uz(j,i) = Uf_val / kappa * log(30 * z(j) / k_star_val);
            c(j,i) = cb_val*((D_val-z(j))/z(j)*b/(D_val-b))^(ws/kappa/Uf_val);
         end 
      end
      k_star(i,:) = k_star_val; 
  end

end