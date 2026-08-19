function heatmapPlot(data,interval,basal,smooth_res,fig,clims,tick)

s = size(data);
cell_number = s(1);
data_length = s(2);

% figure(fig);
if smooth_res
    smoothed_data = linearSmooth1(data,smooth_res);
    data_length=size(smoothed_data,2);
    interval=interval*smooth_res;
else
    smoothed_data = data;
end

if ~isempty(clims)
    imagesc(smoothed_data,clims);
else
    imagesc(smoothed_data,[min(min(smoothed_data)),max(max(smoothed_data))]);
end


xtick = 1:(tick/interval):data_length;
xticklable = -basal:tick:(data_length*interval) - basal;
set(gca,'Xtick',xtick,'XTickLabel',xticklable);
xlim([0 data_length]);
% set(gca,'Ytick',0:5:cell_number,'YTickLabel',0:5:cell_number);

set(gca,'Ytick',[1 cell_number],'YTickLabel',[1 cell_number]);
hold on;
box off;







