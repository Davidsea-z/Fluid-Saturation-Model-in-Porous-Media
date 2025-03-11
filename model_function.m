function S_model = model_function(a, S_init, lengths, time, sigma_0, sigma_f, theta_0, theta_f)
    global K phi mu_w mu_o;
    
    params = [a, K, phi, mu_w, mu_o];
    S_model = model(params, S_init, lengths, time, sigma_0, sigma_f, theta_0, theta_f);
    
    
    [N, T] = size(S_model);
    S_model = interp1(linspace(1, T, size(S_model, 2)), S_model', linspace(1, T, T))';
end