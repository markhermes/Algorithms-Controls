
%data is 2-dimensional function, x,y -> z, data and params need to be in
%column vectors
function [params,param_hist] = gradient_descent(data, costFunc, params0, alpha, h, nIter)

%% run the gradient descent algorithm

% Optimize the cost function using gradient descent
params = params0; param_hist = [];
for i = 1:nIter
    % Calculate the gradient of the cost function -- analytical for this 
%     grad = gradient_2d_gaussian(params, data);
    
    %numerical for other functions I dont want to calc
    grad = numerical_gradient_n_dim(@(params) costFunc(params), params, h);
    
    % Update the parameters using gradient descent
    params = params - alpha * grad;
    
    % Save the history to show the convergence
    param_hist = [param_hist ; params];
end

% Extract the optimized parameters
mu_x = params(1);
mu_y = params(2);
sigma_x = params(3);
sigma_y = params(4);
A = params(5);

% % Generate the fitted Gaussian function using the optimized parameters
% x = linspace(-5, 5, 100);
% y = linspace(-5, 5, 100);
% [X, Y] = meshgrid(x, y);
% Z = gaussian2d(params, X(:), Y(:));
% Z = reshape(Z, size(X));
% 
% % Plot the data and the fitted Gaussian function
% figure;
% scatter3(data(:, 1), data(:, 2), data(:, 3), 'b.');
% hold on;
% surf(X, Y, Z, 'FaceAlpha', 0.5);
% xlabel('x');
% ylabel('y');
% zlabel('z');
% legend('Data', 'Fitted Gaussian');

end

%% gaussian beam gen
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

%% -- analytical derivative of the cost function
function grad = gradient_2d_gaussian(params, data)
X = data(:,1);
Y = data(:,2);
Z = data(:,3);
% Compute the gradient of the cost function for fitting a 2D Gaussian
% to the data given by X, Y, and Z, using the parameters in the vector params.

% Evaluate the 2D Gaussian function at the given points.
f = gaussian2d(params, X, Y);

% Compute the residual between the model and the data.
residual = f - Z;

% Compute the gradient of the cost function.
dA = sum(sum(residual .* f));
dmu_x = sum(sum(residual .* f .* (X - params(1)) / params(3)^2));
dmu_y = sum(sum(residual .* f .* (Y - params(2)) / params(4)^2));
dsigma_x = sum(sum(residual .* f .* (X - params(1)).^2 / params(3)^3));
dsigma_y = sum(sum(residual .* f .* (Y - params(2)).^2 / params(4)^3));

grad = [dmu_x, dmu_y, dsigma_x, dsigma_y, dA];
end
%% -- numerical derivative of the cost function
function grad = numerical_gradient_n_dim(cost_function, params, h)
% Compute the numerical gradient of the cost function at the point params using a
% step size of h. The cost_function should take a vector of length N as input,
% where N is the number of dimensions.

% Initialize the gradient vector.
N = length(params);
grad = zeros(N, 1);

% Compute the partial derivative with respect to each dimension.
for i = 1:N
    % Define the perturbed vectors.
    params_p = params;
    params_m = params;
    params_p(i) = params_p(i) + h;
    params_m(i) = params_m(i) - h;
    
    % Compute the partial derivative using the central difference formula.
    grad(i) = (cost_function(params_p) - cost_function(params_m)) / (2 * h);
end
grad = grad';
end