% circlecoords - 返回一个有圆心坐标和半径定义的圆上的点的坐标
% 使用: 
% [x,y] = circlecoords(c, r, imgsize,nsides)
%
% 参数:
%	c           - 包含圆心坐标的数组
%   r           - 圆的半径
%   imgsize     - 绘制坐标的图像数组的大小
%   nsides      - the circle is actually approximated by a polygon, this
%                 argument gives the number of sides used in this approximation. Default
%                 is 600.
%
% Output:
%	x		    - 包含圆边界点的x坐标的数组
%   y		    - 包含圆边界点的y坐标的数组
%

function [x,y] = circlecoords(c, r, imgsize,nsides)

    
    if nargin == 3
	nsides = 600;
    end
    
    nsides = round(nsides);
    
    a = [0:pi/nsides:2*pi];
    xd = (double(r)*cos(a)+ double(c(1)) );
    yd = (double(r)*sin(a)+ double(c(2)) );
    
    xd = round(xd);
    yd = round(yd);
    
    %除去-VES    
    %出去值大于虹膜图像的点
    xd2 = xd;
    coords = find(xd>imgsize(2));
    xd2(coords) = imgsize(2);
    coords = find(xd<=0);
    xd2(coords) = 1;
    
    yd2 = yd;
    coords = find(yd>imgsize(1));
    yd2(coords) = imgsize(1);
    coords = find(yd<=0);
    yd2(coords) = 1;
    
    x = int32(xd2);
    y = int32(yd2);   