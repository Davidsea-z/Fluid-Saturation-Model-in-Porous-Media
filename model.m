

function S_new = model(params, S_init, lengths, time, sigma_0, sigma_f, theta_0, theta_f)
    global Krw0 Kro0 nw no B;

    a = params(1);
    K = params(2);
    phi = params(3);
    mu_w = params(4);
    mu_o = params(5);

    theta_0_rad = theta_0 * pi / 180;
    theta_f_rad = theta_f * pi / 180;

    N = length(S_init);
    T = length(time);
    DT = max(time) / T;
    DX = max(lengths) / (N - 1); 
    S_new = zeros(N, T);
    S_new(:, 1) = S_init;
    
    for t = 1 : T-1
        for n = 1 : N
            Sw = S_new(n, t);  
            pc0 = -B * log(max(Sw, 1e-10));  
            pc = (sigma_f / sigma_0) * (cos(theta_f_rad) / cos(theta_0_rad)) * pc0;
            if n == 1
                
                S_new(n, t+1) = 0.905; 
            elseif n == N
                Krw_n = Krw0 * Sw^nw + a;
                Kro_n = Kro0 * (1 - Sw)^no;
                term2 = (K / phi) * (1 / (1 / (Krw_n) / mu_w +(Kro_n / mu_o))) * pc * (S_new(n, t) - S_new(n-1, t)) / DX^2 * DT;
                S_new(n, t+1) = -term2 + S_new(n, t);
            else
                Krw_n = Krw0 * Sw^nw + a;
                Kro_n = Kro0 * (1 - Sw)^no;
                term1 = (K / phi) * (1 / (1 / (Krw_n) / mu_w + (Kro_n / mu_o))) * pc * (S_new(n+1, t) - S_new(n, t)) / DX^2 * DT;
                term2 = (K / phi) * (1 / (1 / (Krw_n) / mu_w + (Kro_n / mu_o))) * pc * (S_new(n, t) - S_new(n-1, t)) / DX^2 * DT;
                S_new(n, t+1) = term1 - term2 + S_new(n, t);
            end
        end
    end
end