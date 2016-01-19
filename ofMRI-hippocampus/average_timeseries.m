function [subject_data] = average_timeseries(data_dir, subjects, nodes)

    for s = 1:length(subjects)
    
        for n = 1:length(nodes)

            disp(['Averaging timeseries for node ' nodes{n} ' in ' subjects{s}])

            data = dir([data_dir, subjects{s}, '/40Hz/', nodes{n}]);

            for d = 1:length(data)
                load([data_dir, subjects{s}, '/40Hz/', data(d).name]);
                timeseries{d} = ts;
            end

            t_length = size(timeseries{1});
            if t_length(1) == 0 %this is to account for empty matrices..
                t_length = 0;
            else
                t_length = t_length(2);
            end

            for t = 1:t_length
                for d = 1:length(data)
                    timeseries_holder(d,:) = timeseries{d}(:,t);
                end
                timeseries_mu(:,t) = nanmean(timeseries_holder)';
                timeseries_holder = [];
            end

            node_data(n, :) = nanmean(timeseries_mu);
            timeseries_mu = [];

        end
        subject_data{s} = node_data;
        node_data = [];
        
    end
            
end