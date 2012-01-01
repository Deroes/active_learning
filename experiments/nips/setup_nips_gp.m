gp_responses = @(responses) (2 * responses - 1);

log_input_scale_prior_mean = -10;
log_input_scale_prior_variance = 1;

log_output_scale_prior_mean = 1;
log_output_scale_prior_variance = 1;

latent_prior_mean_prior_mean = -1;
latent_prior_mean_prior_variance = 0.5;

hypersamples.prior_means = ...
    [latent_prior_mean_prior_mean ...
     log_input_scale_prior_mean ...
     log_output_scale_prior_mean];

hypersamples.prior_variances = ...
    [latent_prior_mean_prior_variance ...
     log_input_scale_prior_variance ...
     log_output_scale_prior_variance];

hypersamples.values = find_ccd_points(hypersamples.prior_means, ...
        hypersamples.prior_variances);

hypersamples.mean_ind = 1;
hypersamples.covariance_ind = 2:3;
hypersamples.likelihood_ind = [];
hypersamples.marginal_ind = 1:3;

hyperparameters.lik = hypersamples.values(1, ...
        hypersamples.likelihood_ind);
hyperparameters.mean = hypersamples.values(1, ...
        hypersamples.mean_ind);
hyperparameters.cov = hypersamples.values(1, ...
        hypersamples.covariance_ind);

inference_method = @infLaplace;
mean_function = @meanConst;
covariance_function = @covSEiso;
likelihood = @likErf;

[~, inference_method, mean_function, covariance_function, likelihood] ...
    = check_gp_arguments(hyperparameters, inference_method, ...
                         mean_function, covariance_function, likelihood, ...
                         data, gp_responses(responses));

probability_function = @(data, responses, in_train, test_ind) ...
    gp_probability(data(in_train, :), gp_responses(responses(in_train)), ...
                   data(test_ind, :), inference_method, mean_function, ...
                   covariance_function, likelihood, hypersamples);