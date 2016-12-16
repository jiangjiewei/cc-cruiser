% ADDCIRCLE    生成圆曲线的加权器
%
% 使用:  h = addcircle(h, c, radius, weight)
% 
% 参数:
%            h      - 2维累加数组
%            c      - 圆心的坐标[x,y]
%            radius - 圆的半径
%            weight - 加权数组
%
% 返回值:   h - 更新的累加数组

function h = addcircle(h, c, radius, weight)

    [hr, hc] = size(h);
    
    if nargin == 3
	weight = 1;
    end
    
    % c 与半径必须为整数
    if any(c-fix(c))
	error('Circle centre must be in integer coordinates');
    end
    
    if radius-fix(radius)
	error('Radius must be an integer');
    end
    
    x = 0:fix(radius/sqrt(2));
    costheta = sqrt(1 - (x.^2 / radius^2));
    y = round(radius*costheta);
    
    % 填入对称点坐标
    
    px = c(2) + [x  y  y  x -x -y -y -x];
    py = c(1) + [y  x -x -y -y -x  x  y];

    % 防止出现边界外的点
    validx = px>=1 & px<=hr;
    validy = py>=1 & py<=hc;    
    valid = find(validx & validy);

    px = px(valid);
    py = py(valid);
    
    ind = px+(py-1)*hr;
    h(ind) = h(ind) + weight;
