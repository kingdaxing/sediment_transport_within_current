% failure in insert if statement
function F = q_SixEqn_upper(unknowns, constants)
    % unknown variables
    V = unknowns(1);
    D = unknowns(2);
    D_prime = unknowns(3);
    Uf = unknowns(4);
    theta = unknowns(5);
    theta_prime = unknowns(6); % Shieid Parameter prime, use the 
  
    % given parameters as constants
    q = constants(1); % steady discharge per unit width
    Slope = constants(2); % channel slope
    d = constants(3);  % d = 1 mm =1e-3 m 
    k_N = constants(4);  % k_N=2.5d
    g = constants(5); 
    s = constants(6); % s = 2.65

    % initial equation 
    % q = V*D;
    % V/Uf = 6+2.5*log(D_prime/k_N);
    % Uf = sqrt(g*D_prime*Slope);
    % D/D_prime = theta/theta_prime;
    % theta = D * Slope/(s-1)/d;
    % need to check the theta_prime range for correct equation !
    % theta_prime = 0.06+0.3*theta^1.5  %%  theta_prime =<0.55
    % theta_prime = (0.702*theta^(-1.8)+0.298)^(-1/1.8)   %%  theta_prime > 0.55

    % Define the initial equations
    F = [q - V*D;
         V - Uf *(6+2.5*log(D_prime/k_N)) ;
         Uf - sqrt(g*D_prime*Slope);
         D - D_prime*(theta/theta_prime);
         theta - D * Slope/(s-1)/d;
         theta_prime - (0.702*theta^(-1.8)+0.298)^(-1/1.8) % for theta_prime > 0.55, upper regime
                ]; 
end
