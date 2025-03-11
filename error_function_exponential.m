function err = error_function_exponential(params, S_exp, lengths, time, sigma_0, sigma_f, theta_0, theta_f)
    % Compute the modeled saturation distribution
    S_model = model_exponential(params, lengths, time, sigma_0, sigma_f, theta_0, theta_f);
    
    % Check the dimensions of the experimental data
    [N, T] = size(S_exp);
    
    % Calculate the sum of squared differences between experimental and modeled saturation
    err = sum((S_exp(:) - S_model(:)).^2);
end