function plot_effects(m, e, i_resp)

n_resp =    length(i_resp);
n_model =   length(m);

% iterate through responses
for j = i_resp

    % create figures
    figCI = figure;
    set(gcf, 'name', ['Effect and CI for ', e.resp(j).name])
    figBar = figure;
    set(gcf, 'name', ['Normalized effects for ',e.resp(j).name])
    

    
    % iterate through models
    for i = 1:n_model
        n_effects = length(m(i).resp(j).effects);
        
        % generate x axis labels from coeffs
        labels = {'','a0'};
        for k = 1:m(i).coeff_count-1
            labels{k+2} = 'a';
            for l = 1:size(m(i).coeffs,2)
                if(m(i).coeffs(k, l) ~= 0)
                    labels{k+2} = [labels{k+2} num2str(m(i).coeffs(k,l))];
                end
            end
        end
        
        x = 1:n_effects;
        %x = m.param_list(x_m) % x axis of the plots
        
        % plot effects with interval of confidence
        figure(figCI);
        subplot(n_model,1,i)
        errorbar(x, m(i).resp(j).effects/m(i).resp(j).effects(1),m(i).resp(j).CI/m(i).resp(j).effects(1),'dr',...
            'MarkerSize',5,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',[.49 1 .63])
        set(gca,'XTick',[0:m(i).coeff_count]);
        %xlim([0 m(3).coeff_count+1.5])
        grid on
        
        set(gca, 'XTickLabel',labels)
        title(strcat(m(i).name,' effects and 90% confidence intervals'),'FontWeight','bold','FontSize',16)
        xlabel('Coefficients')
        ylabel('ai')

        % effects bar plot
        figure(figBar)
        subplot(n_model,1,i)
        bar(x,m(i).resp(j).effects/m(i).resp(j).effects(1),'r')
        set(gca,'XTick',[0:m(i).coeff_count]);
        %xlim([0 m(3).coeff_count+1.5])
        set(gca, 'XTickLabel',labels)
        title(strcat(m(i).name,' effect'),'FontWeight','bold','FontSize',16)
        xlabel('Coefficients')
        ylabel('ai/ao')
    end
end