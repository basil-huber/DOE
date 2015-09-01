function m = setup_model(m, coeffs, e, name)
       
    % set coeffs and number of coeffs
    m.coeffs = coeffs;
    m.coeff_count = size(coeffs,1)+1;
    
    % get matrix of the model
    m.X = my_matmod(e.E_norm, coeffs,1);
    %m.X = model_matrix(e.E_norm, coeffs);

    % dispersion matrix
    m.D = inv(m.X'*m.X);
    
    % set name
    m.name = name;
    
    % add parameters
    i = 1;
    m.param_list = [];
    for j = 1:length(e.param)
        if(ismember(j,coeffs)) % check if index i is contained in coeffs
            m.param_list(i) = j;
            i = i+1;
        end
    end