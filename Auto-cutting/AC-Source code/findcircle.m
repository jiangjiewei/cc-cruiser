% findcircle - ʹ��Hough�任��Canny���ӱ�Ե��ⷵ��ͼ����һ��Բ�����ֵ�������߽�ͼ
% ʹ�� ��
% [row, col, r] = findcircle(image,lradius,uradius,scaling, sigma, hithres, lowthres, vert, horz)
%
% ����
%	image		    - ��Ҫ���Բ��ͼ��
%	lradius		    - �����С�뾶
%	uradius		    - ������뾶
%	scaling		    - ����Hough�任�ķ�������
%	sigma		    - ���ڴ����߽�ͼ�ĸ�˹ƽ������
%	hithres		    - ���ڴ����߽�ͼ����ֵ
%	lowthres	    - �������ӱ�Ե����ֵ
%	vert		    - ��ֱ�߽����(0-1)
%	horz		    - ˮƽ�߽����(0-1)
%	
% Output:
%	circleiris	    - ��Ĥ�߽�����������뾶
%	circlepupil	    - ͫ�ױ߽�����������뾶
%	imagewithnoise	- ������������λͼ��


function [row, col, r] = findcircle(image,lradius,uradius,scaling, sigma, hithres, lowthres, vert, horz)

lradsc = round(lradius*scaling);
uradsc = round(uradius*scaling);
rd = round(uradius*scaling - lradius*scaling);

% ��ɱ߽�ͼ

% [I2 or] = canny(image, sigma, scaling, vert, horz);
% I3 = adjgamma(I2, 1.9);
% I4 = nonmaxsup(I3, or, 1.5);
% edgeimage = hysthresh(I4, hithres, lowthres);
% disp('enter edge sobel');
edgeimage = edge(imresize(image,scaling),'sobel');
% disp('exit edge sobel');

% tmpimg = imresize(colordist,scaling).*double(edgeimage);
% 
% edgeimage = edge(edgeimage,'sobel');

% ִ�м��Բ��hough�任
h = houghcircle(edgeimage, lradsc, uradsc);

maxtotal = -1000000;

% Ѱ��Hough�ռ��е����ֵ����Բ�Ĳ���

[YN, XN] = size(edgeimage);
stepX = 2/(XN-1);
stepY = 2/(YN-1);
[XX, YY]=meshgrid(-1:stepX:1,-1:stepY:1);

KK = sqrt(XX.*XX+YY.*YY);

for i=1:rd
    
%     layer = h(:,:,i);
    
    layer = h(:,:,i);% - 30*KK;
%     keral = ones(11);
%     layer = filter2(keral,layer);
    
    [maxlayer] = max(max(layer));
    
    
    if maxlayer > maxtotal
        
        maxtotal = maxlayer;
        
        
        r = int32((lradsc+i) / scaling);
        
        [row,col] = ( find(layer == maxlayer) );
        
        
        row = int32(row(1) / scaling); % ���ؿռ��е�һ��ֵ�����ֵ
        col = int32(col(1) / scaling);    
        
    end 
%     figure,imshow(layer,[])
end






