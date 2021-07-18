% 添加路径
addpath('D:\zpz\画点作图');
% 关掉图片
close all;
% % 这四行画十字
% plot(linspace(0,10000,1000),3300,'b');
% hold on;
% plot(3300,linspace(0,10000,1000),'b');
% axis([0 10000 0 10000]);
% 这一行开始画点
% 先建立一个空的x_data 之后可以在有数据的x_data上继续画
% 这个建立空矩阵只需要运行一次
x_data = [];
% 之后每次只需要改动和运行这一行
x_data = draw_dot_cluster(x_data,40,400,'cross_coord',4200,'cross_coord2',4400);
% 第一个参数是存储数据点的矩阵，可以在每次结束绘画后继续保存新的点
% 第二个参数是每次点击的点个数
% 第三个参数是横向点扩散
% 第四个参数是纵向点扩散
% 第五个参数是点相关性 取值为-1 到1之间 -1为坐上到右下方向 1为左下到右上方向，越大点的倾斜排列越明显
% 画完记得按任意键结束画画
% 画错了可以按u退回前一步 一共可以退10次
% 按p显示百分比，按空格取消显示百分比
% 保存数据
save_name = 'D:\zpz\画点作图\data_sets\x_data-f5-o-4.1c.mat';
if ~exist(save_name)
    save(save_name,'x_data');
    fprintf('File saved\n');
else
    fprintf('File already existed\n');
end
% stats


% 如果需要改点的大小，可以运行下面的代码并尝试不同的MarkerSize值
% plot(x_data(:,1),x_data(:,2),'r.','MarkerSize',4)

%Make the graph into log equivalent coordinates and plot
lg = @(x) 10.^(x./10000*4);
log_x_data = 10.^(x_data./10000*4);
figure;
loglog(log_x_data(:,1),log_x_data(:,2),'r.','MarkerSize',4);
hold on;
cross_coord = 4200;
cross_coord2 = 4400;
cross_coord = lg(cross_coord);
cross_coord2 = lg(cross_coord2);
plot(10.^(linspace(0,10000,100)./10000*4),cross_coord*ones(100,1),'k-');
plot(cross_coord2*ones(100,1),10.^(linspace(0,10000,100)./10000*4),'k-');
axis equal;
set(gca,'tickdir','out');
axis([10^0 10^4 10^0 10^4]);
% text
boundary = log10(cross_coord)/4*10000;
boundary2 = log10(cross_coord2)/4*10000;
fprintf('右上\n');
p1 = sum(x_data(:,1) > boundary2 & x_data(:,2) > boundary)/length(x_data);
text(lg(8500),lg(9500),['' sprintf('%.2f',100*p1) '%']);
fprintf('右下\n');
p2 = sum(x_data(:,1) > boundary2 & x_data(:,2) <= boundary)/length(x_data);
text(lg(8500),lg(500),['' sprintf('%.2f',100*p2) '%']);
fprintf('左上\n');
p3 = sum(x_data(:,1) <= boundary2 & x_data(:,2) > boundary)/length(x_data);
text(lg(200),lg(9500),[' ' sprintf('%.2f',100*p3) '%']);
fprintf('左下\n');
p4 = sum(x_data(:,1) <= boundary2 & x_data(:,2) <= boundary)/length(x_data);
text(lg(200),lg(500),['' sprintf('%.2f',100*p4) '%']);