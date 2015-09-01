function plot_interpolation(m, e, i_resp)
    if(length(m.param_list) == 3)
        plot_interpolation3d(m, e, i_resp)
    else
        plot_interpolation2d(m, e, i_resp)
    end
end

function plot_interpolation3d(m, e, i_resp)

m_resp = m.resp(i_resp);
e_resp = e.resp(i_resp);

%figure
%title(['Model: ' m.name ':  ' e.resp(i_resp).name])
%set(gcf, 'name', ['Interpolation for ', m.name])
params = [1 2 3;
          1 3 2;
          2 3 1];

colorList = {'r', 'g', 'b', 'm', 'c', 'y', 'k','r', 'g', 'b', 'm', 'c', 'y', 'k'};

for i = 1:3
    p1 = params(i,1);
    p2 = params(i,2);
    p3 = params(i,3);
    figure %subplot(2, 2,i)
    %title([e_resp.name ' vs ' e.param(p1).name ' & ' e.param(p2).name ])
    set(gcf, 'name', ['Interpolation for ', m.name])
    xlabel(['x' num2str(p1) ' (' e.param(p1).name ')'])
    ylabel(['x' num2str(p2) ' (' e.param(p2).name ')'])
    zlabel(e_resp.name)
    hold on
    % plot experimental values
    legend_str = cell(length(e.param(p3).unique),1);
    for j = 1:length(e.param(p3).unique)
        x3 = e.param(p3).unique(j);     % value of the 3rd parameter
        indi = m.X(:,p3 + 1) == x3;     % find all experiments with 3rd parameter == x3
        plot3(m.X(indi,p1+1), m.X(indi,p2 + 1), e_resp.Y(indi), [colorList{j} 'o'],'MarkerSize',5, 'MarkerFaceColor',colorList{j});
        legend_str{j} = [ 'x' num2str(p3) ' = '  num2str(x3)];
        hold on
    end
    legend(legend_str)
    % plot surface of fit
    for j = 1:length(e.param(p3).unique)
        x3 = e.param(p3).unique(j);     % value of the 3rd parameter
        XX = get_mesh3d(m.coeffs, p1, p2, p3, x3);
        Z = zeros(size(XX,1),size(XX,2));
        for k = 1:m.coeff_count
            Z = Z + XX(:,:,k)*m_resp.effects(k);
        end
        surf(XX(:,:,p1+1), XX(:,:,p2+1), Z, 'FaceColor',colorList{j}, 'EdgeAlpha',0.1);
        hold on
    end
    alpha(1)
    
end
end


% does not support interactions at the moment
function plot_interpolation2d(m, e, i_resp)
    m_resp = m.resp(i_resp);
    e_resp = e.resp(i_resp);

    %figure
    %title(['Model: ' m.name ':  ' e.resp(i_resp).name])

    params = [1 2;
              2 1];

    colorList = {'r', 'g', 'b', 'm', 'c', 'y', 'k','r', 'g', 'b', 'm', 'c', 'y', 'k'};
    
    i=1;%for i = 1:2
        figure
        set(gcf, 'name', ['Interpolation for ', m.name])    
        p1 = params(i,1);
        p2 = params(i,2);

        e1 = m.param_list(p1);  % index of the param in the experiment struct
        e2 = m.param_list(p2);  % index of the param in the experiment struct
        
        params2 = e.param(e2).unique;
        
        %subplot(2, 1 ,i)
        %title([e_resp.name ' vs ' e.param(e1).name])
        xlabel(['x_' num2str(e1) ' (Parameter ' e.param(e1).name ')'])
        ylabel(e_resp.name)

        hold on
        % plot experimental values
        legend_str = cell(length(params2),1);
        for j = 1:length(params2)
            x2 = params2(j);     % value of the 3rd parameter
            indi = m.X(:,p2 + 1) == x2;     % find all experiments with 3rd parameter == x3
            X = m.X(indi,p1+1);
            Y = e_resp.Y(indi);
            [X, indi] = sort(X);
            plot(X, Y(indi), [colorList{j} '*-']);
            legend_str{j} = [ 'x_' num2str(e2)  ' = '  num2str(x2)];
            hold on
        end
        legend(legend_str)
        legend('Location', 'northwest')
        
        % plot line of fit
        for j = 1:length(params2)
            x2 = params2(j);     % value of the 3rd parameter
            if(i == 1)
                XX = get_mesh2d(m.coeffs, 1, 2, x2);
                Z = XX*m_resp.effects;
            else
                XX = get_mesh2d(m.coeffs, 2, 1, x2);
                Z = XX*m_resp.effects;
            end
            plot(XX(:,p1+1), Z, [colorList{j} '--']);
            hold on
        end
 

    %end
end

function XX = get_mesh3d(coeffs, p1, p2, p3, value3)
    l = size(coeffs,1);
    XX = ones(11,11,l+1);

    X = ones(11,11,max([p1 p2 p3]));
    [X(:,:,p1), X(:,:,p2)] = meshgrid([-1:0.2:1], [-1:0.2:1]);
    X(:,:,p3) = ones(11,11)*value3;
    
    for ii = 1:l
        for jj = 1:size(coeffs,2)
            if(coeffs(ii,jj) > 0)
                XX(:,:,ii+1) = XX(:,:,ii+1) .* X(:,:,coeffs(ii,jj));
            end
        end
    end
end

function XX = get_mesh2d(coeffs, p1, p2, value2)
    l = size(coeffs,1);
    XX = ones(21,l+1);

    % this is a hack
    coeffs = coeffs - 1;
    
    X = ones(21,2);
    X(:,p1) = (-1:0.1:1)';
    X(:,p2) = value2*ones(21,1);
    
    for ii = 1:l
        for jj = 1:size(coeffs,2)
            if(coeffs(ii,jj) > 0)
                XX(:,ii+1) = XX(:,ii+1) .* X(:,coeffs(ii,jj));
            end
        end
    end
end