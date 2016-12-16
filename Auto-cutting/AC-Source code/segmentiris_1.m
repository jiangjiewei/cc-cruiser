% segmentiris - �ָ��Ĥ�����ͬʱ�������������򣬲�������ͽ�ë�����ڸ�
%
% ʹ�÷�����
% [circleiris, circlepupil, imagewithnoise] = segmentiris(image)
%
% ����
%	eyeimage		- ����ͼ��
%	
% �����
%	circleiris	    - ��Ĥ��Ե�����������뾶
%	circlepupil	    - ͫ�ױ�Ե�����������뾶 
%	imagewithnoise	- ������������λͼ��
%

function [row, col, r] = segmentiris_1(eyeimage,colordist,scale_hough,image_scal)

% ����ͫ�����Ĥ�뾶��Χ

%CASIA
% lpupilradius = 20;
% upupilradius = 60;
% lirisradius = 80;
% uirisradius = 150;scal
% lirisradius = 10;
% uirisradius = 100;
if image_scal==1
	lirisradius =40;
	uirisradius =400;
else
	lirisradius =10;
	uirisradius = 100;
end
colordist_backup = colordist;
% �������ڼ���hough�任�ķ�������
% scaling = 0.4;
scaling = scale_hough;


reflecthres = 240;

% tmpcdist = abs((colordist - 0.55).^2);
% colordist(tmpcdist > (0.1).^2) = 0;






% Ѱ�Һ�Ĥ�빮Ĥ��߽磬����Ĥ��߽�
[row, col, r] = findcircle(eyeimage, lirisradius, uirisradius, scaling, 2, 0.20, 0.15, 1.00, 0.00);



%�� colordist ��Բ��Ĳ��ָ�ֵΪ0��ֱ��������dr������
dr = 3;
[ny, nx] = size(colordist);
[xx, yy] = meshgrid(1:nx, 1:ny);
tmp =  (xx - double(col)).^2 + (yy - double(row)).^2 - (double(r)-2).^2;
tmp(tmp>=0) = 0;
tmp(tmp<0) = 1;

colordist = colordist.*tmp;

% tmpcdist = (colordist - 0.55).^2;
% colordist(tmpcdist > (0.1).^2) = 0;

colordist((colordist > 0.9)|(colordist <0.2)) = 0;

se = strel('disk',2); 
colordist = imerode(colordist,se);
colordist = imdilate(colordist,se);

xxxxx = 0;

[row, col, r] = findcircle(colordist, lirisradius, uirisradius, scaling, 2, 0.20, 0.15, 1.00, 0.00);



