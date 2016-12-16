% houghcircle - 使用Hough变换寻找图像中的圆
%
% 使用： 
% h = houghcircle(edgeim, rmin, rmax)
%
% 参数:
%	edgeim      - 待处理的边界图
%   rmin, rmax  - 寻找范围，最大最小半径
% 输出:
%	h           - 变换结果
%

function h = houghcircle(edgeim, rmin, rmax)

[rows,cols] = size(edgeim);
nradii = rmax-rmin+1;
h = zeros(rows,cols,nradii);

[y,x] = find(edgeim~=0);

%对于每个点，画出不同半径的圆
for index=1:size(y)
    
    cx = x(index);
    cy = y(index);
    
    for n=1:nradii
        
        h(:,:,n) = addcircle(h(:,:,n),[cx,cy],n+rmin);
        
    end
    
end
