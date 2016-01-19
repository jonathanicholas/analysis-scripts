function [sample_R] = sample_corr(dataset, nodes)

    disp(['Calculating sample R for node indices ' num2str(nodes(1)) ' and ' num2str(nodes(2))])

    xx = dataset;
    z = xx(nodes(1),:);
    y = xx(nodes(2),:);
    
    sumC = 0;
    sumB = 0;
    sumA = 0;
    for n = 1:length(xx)
        sumC = sumC + ((z(n) - mean(z)) * (y(n) - mean(y)));

        sumA = sumA + ((z(n)-mean(z)))^2;
        sumB = sumB + ((y(n)-mean(y)))^2;
    end
    sample_cov = sumC/(length(xx) - 1);
    stdevA = sqrt(sumA/(length(xx) - 1));
    stdevB = sqrt(sumB/(length(xx) - 1));
    sample_stdev = stdevA * stdevB;

    sample_R = sample_cov/sample_stdev;

end