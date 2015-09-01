function m = analyze_experiment(m, e)
    for j = 1:size(e.resp,2)
        
        % half effects
        m.resp(j).effects = m.D * (m.X'*e.resp(j).Y);

        % residue
        m.resp(j).r = e.resp(j).Y - (m.X * m.resp(j).effects);

        % experimental variance
        m.resp(j).sigma = m.resp(j).r'*m.resp(j).r;

        % 90% bilateral Confidence interval estimation
        alpha_ci = .90 + (1-.90)/2;
        m.resp(j).CI = tinv(alpha_ci,e.N-2)*sqrt(diag(m.D)*m.resp(j).sigma);
    end
end