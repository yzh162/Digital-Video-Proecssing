clc;
clear;

readerobj=VideoReader('/Users/apple/Downloads/video_s.avi'); 
N=readerobj.NumberOfFrames; 
vidFrames=read(readerobj); 

filter='Median';         
ROI=[100,100,250-1,250-1];
FOI=[1 1];      
dldlf=[5 5];
params=struct('filtername',filter,'ROI',ROI,'FOI',FOI,'args',dldlf);
filtersize=params.args;

if(strcmp(params.filtername,'Gaussian'))
for k=params.FOI(1):params.FOI(2)
     mov(k).cdata = vidFrames(:,:,:,k);
     J=mov(k).cdata;
    I=Gauss(J(ROI(1):ROI(3),ROI(2):ROI(4),:,:),params.args(1),params.args(2),params.args(3));
    mov(k).cdata=I;
    mov(k).colormap = [];
end
    
elseif(strcmp(params.filtername,'Laplacian'))
for k=params.FOI(1):params.FOI(2)
     mov(k).cdata = vidFrames(:,:,:,k);
     J=mov(k).cdata;
    I=lap(J(ROI(1):ROI(3),ROI(2):ROI(4),:,:),params.args(1),params.args(2),params.args(3));
    mov(k).cdata=I;
    mov(k).colormap = [];
end
    
elseif (strcmp(params.filtername,'Mean'))
    for k = params.FOI(1) : params.FOI(2)
    mov(k).cdata = vidFrames(:,:,:,k);
    J=mov(k).cdata;
    r = arithmetic_mean(J(:, :, 1), filtersize(1,1),filtersize(1,2),ROI(1),ROI(2),ROI(3),ROI(4));
    g = arithmetic_mean(J(:, :, 2), filtersize(1,1),filtersize(1,2),ROI(1),ROI(2),ROI(3),ROI(4));
    b = arithmetic_mean(J(:, :, 3), filtersize(1,1),filtersize(1,2),ROI(1),ROI(2),ROI(3),ROI(4));
    K = cat(3, r, g, b);
    mov(k).cdata=K;
    mov(k).colormap = [];
end

elseif (strcmp(params.filtername,'Median'))
   for k = params.FOI(1) : params.FOI(2)
    mov(k).cdata = vidFrames(:,:,:,k);
    J=mov(k).cdata;
    r = median(J(:, :, 1), filtersize(1,1),filtersize(1,2),ROI(1,1),ROI(1,2),ROI(1,3),ROI(1,4));
    g = median(J(:, :, 2), filtersize(1,1),filtersize(1,2),ROI(1,1),ROI(1,2),ROI(1,3),ROI(1,4));
    b = median(J(:, :, 3), filtersize(1,1),filtersize(1,2),ROI(1,1),ROI(1,2),ROI(1,3),ROI(1,4));
    K = cat(3, r, g, b);
    mov(k).cdata=K;
    mov(k).colormap = [];
   end
    
end


%     I=Gauss(J(:,:,:),5,5,1,1,1,300-1,300-1);
%     K1=J-I;
%     I1=Gauss(J(:,:,:),30,30,1,100,100,200-1,200-1);
%     K2=J-I1;
%     I2=Gauss(J(:,:,:),5,5,10,100,100,200-1,200-1);
%     K3=J-I2;
%     figure;
%     subplot(131);imshow(J);
%     subplot(132);imshow(I);
%     subplot(133);imshow(K1);
 
    
hf = figure; 
set(hf, 'position', [150 150 readerobj.Width readerobj.Height])
movie(hf, mov, 1, readerobj.FrameRate);
