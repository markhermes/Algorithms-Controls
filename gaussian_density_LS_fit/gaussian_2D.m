%% -- generate gaussian
function Z = gaussian2d(params, X, Y)
% Evaluate a 2D Gaussian distribution at the given points X and Y,
% using the specified parameters.

mu_x = params(1);
mu_y = params(2);
sigma_x = params(3);
sigma_y = params(4);
A = params(5);

Z = A * exp(-(X-mu_x).^2/(2*sigma_x^2) - (Y-mu_y).^2/(2*sigma_y^2));
end