function cut()

filelist = dir('../input/*.jpg');
outW = 256;
lfilelist=length(filelist);
for index=1:lfilelist
    inputfname = filelist(index).name;
    eyeimage = (imread(['../input/' inputfname])); 
    [s1 s2]=size(eyeimage);
    if  s1>213*4 && s2>320*4
        eyeimage=imresize(eyeimage,[213*4,320*4]);
        image_scal=1;
        scale_hough=0.05;
    else
        eyeimage=imresize(eyeimage,[213,320]);
    	image_scal=2;
        scale_hough=0.2;
    end
    eyeimage_backup = eyeimage;

    if length(size(eyeimage))==3
        eyeimage = rgb2hsv(eyeimage);
        colordist = eyeimage(:,:,1);
        eyeimage=eyeimage(:,:,2);
    end
    eyeimage = double(eyeimage);

    [row col r] = segmentiris_1(eyeimage,colordist, scale_hough,image_scal);

    rowd = double(row);
    cold = double(col);
    rd = double(r);

    irl = round(rowd-rd);
    iru = round(rowd+rd);
    icl = round(cold-rd);
    icu = round(cold+rd);

    imgsize = size(eyeimage);
    
    tmpedg = [0 0,0 0];
    if irl < 1 
        irl = 1;
        tmpedg(1) = 1;
    end

    if icl < 1
        icl = 1;
        tmpedg(3) = 1;
    end

    if iru > imgsize(1)
        iru = imgsize(1);
        tmpedg(2) = 1;
    end

    if icu > imgsize(2)
        icu = imgsize(2);
        tmpedg(4) = 1;
    end


    circleiris = [row col r];
    [x,y] = circlecoords([circleiris(2),circleiris(1)],circleiris(3),size(eyeimage));
    ind2 = sub2ind(size(eyeimage),double(y),double(x)); 
    ttt = eyeimage_backup;
    ttt(ind2) = 255;
    
    
    imagepupil = eyeimage_backup( irl:iru,icl:icu,:);
    
    if tmpedg(1) == 1 
        [ty,tx,tz]=size(imagepupil);
        tmp1 = [zeros(rd-rowd+1,tx); imagepupil(:,:,1)];
        tmp2 = [zeros(rd-rowd+1,tx); imagepupil(:,:,2)];
        tmp3 = [zeros(rd-rowd+1,tx); imagepupil(:,:,3)];
        tmpc = zeros([size(tmp1) 3]);
        tmpc(:,:,1) = tmp1;
        tmpc(:,:,2) = tmp2;
        tmpc(:,:,3) = tmp3;
        imagepupil = tmpc;
    end
     if tmpedg(2) == 1  
        [ty,tx,tz]=size(imagepupil);
        tmp1 = [imagepupil(:,:,1); zeros(rowd+rd-imgsize(1),tx)];
        tmp2 = [imagepupil(:,:,2); zeros(rowd+rd-imgsize(1),tx)];
        tmp3 = [imagepupil(:,:,3); zeros(rowd+rd-imgsize(1),tx)];
        tmpc = zeros([size(tmp1) 3]);
        tmpc(:,:,1) = tmp1;
        tmpc(:,:,2) = tmp2;
        tmpc(:,:,3) = tmp3;
        imagepupil = tmpc;
     end
    
    if tmpedg(3) == 1 
        [ty,tx,tz]=size(imagepupil);
        tmp1 = [zeros(ty,rd-cold+1),imagepupil(:,:,1)];
        tmp2 = [zeros(ty,rd-cold+1),imagepupil(:,:,2)];
        tmp3 = [zeros(ty,rd-cold+1),imagepupil(:,:,3)];
        tmpc = zeros([size(tmp1) 3]);
        tmpc(:,:,1) = tmp1;
        tmpc(:,:,2) = tmp2;
        tmpc(:,:,3) = tmp3;
        imagepupil = tmpc;
    end
     if tmpedg(4) == 1
        [ty,tx,tz]=size(imagepupil);
        tmp1 = [imagepupil(:,:,1),zeros(ty,cold+rd-imgsize(2)),];
        tmp2 = [imagepupil(:,:,2),zeros(ty,cold+rd-imgsize(2)),];
        tmp3 = [imagepupil(:,:,3),zeros(ty,cold+rd-imgsize(2)),];
        tmpc = zeros([size(tmp1) 3]);
        tmpc(:,:,1) = tmp1;
        tmpc(:,:,2) = tmp2;
        tmpc(:,:,3) = tmp3;
        imagepupil = tmpc;
     end
     imagepupil = imresize(imagepupil,[outW,outW]);
     %delete(['../input/' inputfname]);
     imwrite(uint8(imagepupil),['../output/' inputfname]);
    
    
end







