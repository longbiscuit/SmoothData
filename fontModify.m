
% scAlf=sprintfc('%g',sc);%把数字数组转化成字符串数组
% legend(scAlf,'Location','northoutside','Orientation','horizontal');%加图例
% legend(scAlf,'Location','bestoutside');%加图例
FontSize=12;
set(gca,'Fontsize',FontSize,'FontName','Times new Roman');
set(get(gca,'XLabel'),'FontSize',FontSize,'FontName','Times new Roman');
set(get(gca,'YLabel'),'FontSize',FontSize,'FontName','Times new Roman');
set(get(gca,'ZLabel'),'FontSize',FontSize,'FontName','Times new Roman');