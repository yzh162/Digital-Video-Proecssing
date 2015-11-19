%% SECTION Edge Detection
% DESCRIPTIVE TEXT
clc;
clear;

readerobj=VideoReader(''/Users/apple/Downloads/xid1/Resources/xid1 - Cellular.m4v''); 
vidFrames = read(readerobj);
numFrames = get(readerobj, 'NumberOfFrames');
for k = 1 : numFrames
    mov(k).cdata = vidFrames(:,:,:,k);
    J=rgb2gray((mov(k).cdata));
    level=graythresh(J);
    J1 = im2bw(J,0.44);
    if(k<=20)
    J1(1:225,267:400)=1;
    J1(1:55,134:400)=1;     
    else
    J1(157:186,278:352)=1;           
    end       
   J1 = edge(J1,'canny');
    J1=uint8(J1*255);
   
    K = cat(3, J1, J1, J1);
    mov(k).cdata=K;
    mov(k).colormap =[];  
end
hf = figure; 
set(hf, 'position', [150 150 readerobj.Width readerobj.Height])
movie(hf, mov, 1, readerobj.FrameRate);

%% SECTION Hough Transform 
clc;
clear;

readerobj=VideoReader('/Users/apple/Downloads/xid1 - Cellular.m4v'); 
vidFrames = read(readerobj);
numFrames = get(readerobj, 'NumberOfFrames');
for k = 1 : numFrames    
    mov(k).cdata = vidFrames(:,:,:,k);
    J=rgb2gray((mov(k).cdata));
    [centers, radii] = imfindcircles(J,[10 40],'ObjectPolarity','dark',...
                        'Sensitivity',0.8);
    J1 = insertShape(J, 'circle', [centers(:,1) centers(:,2) radii(:)], 'LineWidth', 1,'Color','blue');

    mov(k).cdata=J1;
    mov(k).colormap =[];  
   
end
hf = figure; 
set(hf, 'position', [150 150 readerobj.Width readerobj.Height])
movie(hf, mov, 1, readerobj.FrameRate);

%% SECTION Determine coin type
clc;
clear;
readerobj=VideoReader('/Users/apple/Downloads/xid1 - Cellular.m4v'); 
vidFrames = read(readerobj);
numFrames = get(readerobj, 'NumberOfFrames');
for k = 1:   numFrames 
     mov(k).cdata = vidFrames(:,:,:,k);
    [centers, radii] = imfindcircles(mov(k).cdata,[15 21],'ObjectPolarity','dark',...
                        'Sensitivity',0.9);
     radii1=round(radii);
     [X]=find(19<=radii1 & radii1<=20);
     nn=max(size(X));
     radii2=zeros(nn,1) ;
     centers1=zeros(nn,2);
  for pp=1:max(size(X))
      qq=X(pp,1);
      centers1(pp,1)=(centers(qq,1));
      centers1(pp,2)=(centers(qq,2));
      radii2(pp,1)=radii1(qq,1);
  end
    J1 = insertShape(mov(k).cdata, 'circle', [centers1(:,1) centers1(:,2) radii2(:,1)],...
                        'LineWidth', 2,'Color','yellow');
                    
                    

    [centers3, radii3] = imfindcircles(mov(k).cdata,[13 20],'ObjectPolarity','dark',...
                        'Sensitivity',0.9);
     radii4=round(radii3);
     [X1]=find(radii4<=18);
 if(find(radii4<=18)~=0)    
     nn1=max(size(X1));
     radii5=zeros(nn1,1) ;
     centers5=zeros(nn1,2);
  for ppp=1:max(size(X1))
      qqq=X1(ppp,1);
      centers5(ppp,1)=(centers3(qqq,1));
      centers5(ppp,2)=(centers3(qqq,2));
      radii5(ppp,1)=radii4(qqq,1);
  end
    J1 = insertShape(J1, 'circle', [centers5(:,1) centers5(:,2) radii5(:,1)],...
                        'LineWidth', 2,'Color','black');
    ctr=max(size(radii5));
 else
     ctr=max(size(radii5));
     ctr=0;
 end


    [centers, radii] = imfindcircles( mov(k).cdata,[21 45],'ObjectPolarity','dark',...
                        'Sensitivity',0.8);
    J1 = insertShape( J1, 'circle', [centers(:,1) centers(:,2) radii(:)], 'LineWidth', 2,'Color','blue');
% Blue: Quarter: $0.25 这个是准确的
% Black: Penny: $0.1
% Yellow: Cent: $0.01
%     J1 = insertText(J1,[centers(:,1) centers(:,1)],[0.25],'AnchorPoint','LeftBottom');     
%     J1 = insertText(J1,[centers5(:,1) centers5(:,1)],[0.1],'AnchorPoint','LeftBottom');     
%     J1 = insertText(J1,[centers1(:,1) centers1(:,1)],[0.01],'AnchorPoint','LeftBottom');     
    totle=0.25*max(size(radii))+0.1*ctr+0.01*max(size(radii2));
    J1 = insertText(J1,[30 30],[totle],'AnchorPoint','LeftBottom');     


    %imshow(J1)
    
    
    
    

   mov(k).cdata=J1;
   mov(k).colormap =[];  
   end

hf = figure; 
set(hf, 'position', [150 150 readerobj.Width readerobj.Height])
movie(hf, mov, 1, readerobj.FrameRate);


% %%
% clc;
% clear;
% I=(imread('/Users/apple/Desktop/2.png'));
% HSV = rgb2hsv(I);
% D=[HSV(:,:,1)<0.03];
% D(1:52,143:429)=0;  
% 
% [L Ne]=bwlabel(double(D),4);
% prop=regionprops(L,'Area','Centroid');
% L(181:237,276:429)=1;     
% L(1:52,143:429)=1;           
% total=0;
% imshow(I);
% for n=2:size(prop,1) 
% doll=prop(n).Centroid;
% X=doll(1);
% Y=doll(2);
% if prop(n).Area>100
% total=total+1;
% end
% end 
% 
% dollar = total*0.1;

%% Tracking 

clc;
clear;
readerobj=VideoReader('/Users/apple/Downloads/xid1 - Cellular.m4v'); 
vidFrames = read(readerobj);
numFrames = get(readerobj, 'NumberOfFrames');
tt=zeros(2,2);

tt(1,1)=47;
tt(1,2)=150;
for jk=1:2
     k=tt(1,jk);
     mov(k).cdata = vidFrames(:,:,:,k);
    [centers, radii] = imfindcircles(mov(k).cdata,[15 21],'ObjectPolarity','dark',...
                        'Sensitivity',0.9);
     radii1=round(radii);
     [X]=find(19<=radii1 & radii1<=20);
     nn=max(size(X));
     radii2=zeros(nn,1) ;
     centers1=zeros(nn,2);
  for pp=1:max(size(X))
      qq=X(pp,1);
      centers1(pp,1)=(centers(qq,1));
      centers1(pp,2)=(centers(qq,2));
      radii2(pp,1)=radii1(qq,1);
  end
    J1 = insertShape(mov(k).cdata, 'circle', [centers1(:,1) centers1(:,2) radii2(:,1)],...
                        'LineWidth', 2,'Color','yellow');                    

    [centers3, radii3] = imfindcircles(mov(k).cdata,[13 20],'ObjectPolarity','dark',...
                        'Sensitivity',0.9);
     radii4=round(radii3);
     [X1]=find(radii4<=18);
 if(find(radii4<=18)~=0)    
     nn1=max(size(X1));
     radii5=zeros(nn1,1) ;
     centers5=zeros(nn1,2);
  for ppp=1:max(size(X1))
      qqq=X1(ppp,1);
      centers5(ppp,1)=(centers3(qqq,1));
      centers5(ppp,2)=(centers3(qqq,2));
      radii5(ppp,1)=radii4(qqq,1);
  end
    J1 = insertShape(J1, 'circle', [centers5(:,1) centers5(:,2) radii5(:,1)],...
                        'LineWidth', 2,'Color','black');
    ctr=max(size(radii5));
 else
     ctr=max(size(radii5));
     ctr=0;
 end


    [centers, radii] = imfindcircles( mov(k).cdata,[21 45],'ObjectPolarity','dark',...
                        'Sensitivity',0.8);
    J1 = insertShape( J1, 'circle', [centers(:,1) centers(:,2) radii(:)], 'LineWidth', 2,'Color','blue');
   
   totle=max(size(radii))+ctr+max(size(radii2));

    J1 = insertText(J1,[30 30],[totle],'AnchorPoint','LeftBottom');
    tt(2,jk)=totle;  
end   
   totle_num=sum(tt(2,:))






