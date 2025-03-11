% Modify this line to assign values without using deal
function S_new = model_exponential(params, lengths, time, sigma_0, sigma_f, theta_0, theta_f)
    % Directly assign parameters from the input vector `params`
    Krw0 = params(1);
    Kro0 = params(2);
    nw = params(3);
    no = params(4);
    Swr = params(5);
    Sor = params(6);
    B = params(7);
    K = params(8);
    a = params(9);
    
    % Convert contact angles from degrees to radians
    theta_0_rad = theta_0 * pi / 180;
    theta_f_rad = theta_f * pi / 180;

    % Initial capillary pressure
    pc0 = 0.3; 
    % Capillary pressure changes with interfacial tension and contact angle
    pc = (sigma_f / sigma_0) * (cos(theta_f_rad) / cos(theta_0_rad)) * pc0;

    % Number of spatial and temporal points
    N = length(lengths);
    T = length(time);
    DT = max(time) / T; % Time step size
    DX = max(lengths) / (N - 1); % Spatial step size
    S_new = zeros(N, T); % Initialize saturation matrix
    
    % Loop over time and space to compute saturation distribution
    for t = 1 : T-1
        for n = 1 : N
            if n == 1
                % Boundary condition at the start of the domain
                S_new(n, t+1) = 0.905; 
            else
                Sw = S_new(n, t); 
                
                % Compute relative permeabilities using exponential functions
                Krw_n = compute_Krw(Krw0, nw, Sw, Swr, a); % Water phase
                Kro_n = compute_Kro(Kro0, no, Sw, Sor, a); % Oil phase
                
                % Compute conductivities for both water and oil phases
                lambda_w = K * Krw_n;
                lambda_o = K * Kro_n;
                
                % Compute saturation change terms
                if n < N
                    term1 = (lambda_w * (S_new(n+1, t) - S_new(n, t)) / DX^2) * DT;
                else
                    term1 = 0;
                end
                
                if n > 1
                    term2 = (lambda_o * (S_new(n, t) - S_new(n-1, t)) / DX^2) * DT;
                else
                    term2 = 0;
                end

                % Update the saturation at the next time step
                S_new(n, t+1) = S_new(n, t) + term1 - term2;
            end
        end
    end
end
