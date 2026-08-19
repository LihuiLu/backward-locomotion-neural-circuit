function auc = aucCalculate(x,win,data)
auc = nan(size(data,1),1);
if ~isempty(data)
    dt = x(2) - x(1);
%     win(2);
%     idxMin = find(x == win(1));
%     idxMax = find(x == win(2));
    [~,idxMin] = min(abs(x - win(1)));
    [~,idxMax] = min(abs(x - win(2)));
    for j = 1:size(data,1)
        data1 = data(j,:);
        cdata = data1(:,idxMin:idxMax);
        cauc = sum(cdata,2)*dt;
        auc(j,1) = cauc;
    end
end
