% ���·��
addpath('D:\zpz\������ͼ');
% �ص�ͼƬ
close all;
% % �����л�ʮ��
% plot(linspace(0,10000,1000),3300,'b');
% hold on;
% plot(3300,linspace(0,10000,1000),'b');
% axis([0 10000 0 10000]);
% ��һ�п�ʼ����
% �Ƚ���һ���յ�x_data ֮������������ݵ�x_data�ϼ�����
% ��������վ���ֻ��Ҫ����һ��
x_data = [];
% ֮��ÿ��ֻ��Ҫ�Ķ���������һ��
x_data = draw_dot_cluster(x_data,40,400,'cross_coord',4200,'cross_coord2',4400);
% ��һ�������Ǵ洢���ݵ�ľ��󣬿�����ÿ�ν����滭����������µĵ�
% �ڶ���������ÿ�ε���ĵ����
% �����������Ǻ������ɢ
% ���ĸ��������������ɢ
% ����������ǵ������ ȡֵΪ-1 ��1֮�� -1Ϊ���ϵ����·��� 1Ϊ���µ����Ϸ���Խ������б����Խ����
% ����ǵð��������������
% �����˿��԰�u�˻�ǰһ�� һ��������10��
% ��p��ʾ�ٷֱȣ����ո�ȡ����ʾ�ٷֱ�
% ��������
save_name = 'D:\zpz\������ͼ\data_sets\x_data-f5-o-4.1c.mat';
if ~exist(save_name)
    save(save_name,'x_data');
    fprintf('File saved\n');
else
    fprintf('File already existed\n');
end
% stats


% �����Ҫ�ĵ�Ĵ�С��������������Ĵ��벢���Բ�ͬ��MarkerSizeֵ
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
fprintf('����\n');
p1 = sum(x_data(:,1) > boundary2 & x_data(:,2) > boundary)/length(x_data);
text(lg(8500),lg(9500),['' sprintf('%.2f',100*p1) '%']);
fprintf('����\n');
p2 = sum(x_data(:,1) > boundary2 & x_data(:,2) <= boundary)/length(x_data);
text(lg(8500),lg(500),['' sprintf('%.2f',100*p2) '%']);
fprintf('����\n');
p3 = sum(x_data(:,1) <= boundary2 & x_data(:,2) > boundary)/length(x_data);
text(lg(200),lg(9500),[' ' sprintf('%.2f',100*p3) '%']);
fprintf('����\n');
p4 = sum(x_data(:,1) <= boundary2 & x_data(:,2) <= boundary)/length(x_data);
text(lg(200),lg(500),['' sprintf('%.2f',100*p4) '%']);