function [dot_data] = draw_dot_cluster(x_data,dot_number,std1,varargin)
    % x_data = draw_dot_cluster(300,400)
    % 每次点击画面会绘制一串2维正态分布散点
    % 第一个参数是存储数据点的矩阵，可以在每次结束绘画后继续保存新的点
    % 第二个参数是每次点击的点个数
    % 第三个参数是横向点扩散
    % 第四个参数是纵向点扩散
    % 第五个参数是点相关性 取值为-1 到1之间 -1为坐上到右下方向 1为左下到右上方向，越大点的倾斜排列越明显
    if nargin < 1
        x_data = [];
    end
    if nargin < 2
        dot_number = 20;
    end
    if nargin < 3
        std1 = 30;
    end
%     if nargin < 4
%         std2 = std1;
%     end
%     if nargin < 5
%         rho = 0;
%     end
    p = inputParser;
    cross_coord_default = 4600;
    addOptional(p,'std2',std1,@isnumeric);
    addOptional(p,'rho',0,@isnumeric);
    addParameter(p,'cross_coord',cross_coord_default,@isnumeric);
    addParameter(p,'cross_coord2',cross_coord_default,@isnumeric);
    parse(p,varargin{:});
    rho = p.Results.rho;
    std2 = p.Results.std2;
    hist_capacity = 10;
    history = {[x_data]};
    % 修改画布坐标
    if ~any(strcmpi(varargin,'cross_coord2'))
        refresh(x_data,1,p.Results.cross_coord);
    else
        refresh(x_data,1,p.Results.cross_coord,p.Results.cross_coord2);
    end
    hold on;
    dot_data = [];
    set(gcf,'currentchar',' '); 
    percent_flag = 0;
    while get(gcf,'currentchar')==' ' || get(gcf,'currentchar')=='u' || ...
          get(gcf,'currentchar')=='p'
        if get(gcf,'currentchar')=='u'
            if length(history) > 1
                x_data = history{end};
                history = history(1:end-1);
                if ~any(strcmpi(varargin,'cross_coord2'))
                    refresh(x_data,1,p.Results.cross_coord);
                else
                    refresh(x_data,1,p.Results.cross_coord,p.Results.cross_coord2);
                end
                history
            else
                x_data = history{end};
                if ~any(strcmpi(varargin,'cross_coord2'))
                    refresh(x_data,1,p.Results.cross_coord);
                else
                    refresh(x_data,1,p.Results.cross_coord,p.Results.cross_coord2);
                end
            end
            get(gcf,'currentchar');
            set(gcf,'currentchar',' '); 
            continue;
        end
        if get(gcf,'currentchar')=='p'
            if ~isempty(x_data)
                if ~percent_flag
                    percent_flag = ~percent_flag;
                end
                if ~any(strcmpi(varargin,'cross_coord2'))
                    show_percentage(x_data,p.Results.cross_coord,p.Results.cross_coord,percent_flag);
                else
                    show_percentage(x_data,p.Results.cross_coord,p.Results.cross_coord2,percent_flag);    
                end
                % set(gcf,'currentchar',' '); 
            end
        else
            if ~any(strcmpi(varargin,'cross_coord2'))
                show_percentage(x_data,p.Results.cross_coord,p.Results.cross_coord,0);
            else
                show_percentage(x_data,p.Results.cross_coord,p.Results.cross_coord2,0);
            end
        end
        [x y button] = ginput(1);
        if button == 1
            [x1 x2] = mvnrnd([x y],[std1^2 rho*std1*std2;rho*std1*std2 std2^2],dot_number);
            plot(x1(:,1),x1(:,2),'r.','MarkerSize',4);
            x_data = [x_data;x1];
            if length(history) < 10
                history{end+1} = x_data;
            else
                history(1:9) = history(2:10);
                history{10} = x_data;
            end
        end
    end
    dot_data = x_data;
end

function refresh(x_data,cross_show,cross_coord,cross_coord2)
    if nargin < 2
        cross_show = 1;
    end
    if nargin < 3
        cross_coord = 4600;
    end
    if nargin < 4
        cross_coord2 = cross_coord;
    end
    hold off;
    if ~isempty(x_data)
        plot(x_data(:,1),x_data(:,2),'r.','MarkerSize',4);
    end
    hold on;
    if cross_show
        plot(linspace(0,10000,100),cross_coord*ones(100,1),'k-');
        plot(cross_coord2*ones(100,1),linspace(0,10000,100),'k-');
    end
    axis equal;
    axis([0 10000 0 10000]);
    set(gca,'tickdir','out');
end

function show_percentage(x_data,cross_coord,cross_coord2,flag)
    refresh(x_data,1,cross_coord,cross_coord2);
    boundary = cross_coord;
    boundary2 = cross_coord2;
    if flag
        fprintf('右上\n');
        p1 = sum(x_data(:,1) > boundary2 & x_data(:,2) > boundary)/length(x_data);
        text(8500,9500,['' sprintf('%.2f',100*p1) '%']);
        fprintf('右下\n');
        p2 = sum(x_data(:,1) > boundary2 & x_data(:,2) <= boundary)/length(x_data);
        text(8500,500,['' sprintf('%.2f',100*p2) '%']);
        fprintf('左上\n');
        p3 = sum(x_data(:,1) <= boundary2 & x_data(:,2) > boundary)/length(x_data);
        text(200,9500,[' ' sprintf('%.2f',100*p3) '%']);
        fprintf('左下\n');
        p4 = sum(x_data(:,1) <= boundary2 & x_data(:,2) <= boundary)/length(x_data);
        text(200,500,['' sprintf('%.2f',100*p4) '%']);
    else
        refresh(x_data,1,cross_coord,cross_coord2);
    end
end
