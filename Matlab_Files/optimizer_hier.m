function [c] = optimizer_hier(verb)

% distancesMap = {'euclidean'; 'seuclidean'; 'cityblock'; 'minkowski';
%   'chebychev';'cosine';'correlation';'spearman';'hamming';'jaccard'};

distancesMap2 = {'cosine   ','correlation'};
lMethod2 = {'weighted';'ward    ';'single  ';'complete' ;  'average '};

distancesMap = {'cosine','correlation'};
lMethod = {'weighted';'ward';'complete';'average'};

paths_filename = '../2nd-assignment/datasets/paths.txt';
files = file_paths(paths_filename);


M = length(lMethod);
N = length(distancesMap);
F = length(files);
c  = zeros(M*N*(F-2),8);

k =0 ;
for ff = 3:1:F
    T = readtable(files{ff});
    T(:,end) = [];%delete the category from the data
    X=table2array(T);
%     for x =1:1:size(X,1)%Normalize X
%         X(x,:) = X(x,:)./max(X(x,:));
%     end
   
    s_max = 0;
    for j = 1:1:N
        for i = 1:1:M
            k = k+1;
            Y = pdist(X,distancesMap{j});
            YY = squareform(Y);
            Z =linkage(YY,lMethod{i});
            IDX = cluster(Z,'maxclust',8);
            [sil,coh,sep] = sil_coh_sep(X,IDX,distancesMap{j});
            succ1 = eval_clust(IDX,1);
            succ2 = eval_clust(IDX,2);
            c(k,:) = [ff,j,i,succ1,succ2,sil,coh,sep];
            strM = sprintf('Dataset :%d Method %s Dist:%s succ:%3.3f sil:%3.3f ,coh:%3.3f ,sep:%3.3f \n',...
                ff,lMethod2{i},distancesMap2{j} ,succ2,sil,coh,sep);
            if verb ==1
                fprintf(strM)
            end
            if succ1 > s_max
                strMax = strM;
                s_max = succ2;
            end
            
        end
        
    end
    fprintf('The best result was .. \n')
    fprintf(strMax)
end
k ;
M*N*(F-2);



end