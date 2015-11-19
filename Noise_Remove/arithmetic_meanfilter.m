function I4=arithmetic_mean(I,n,m,f,g,h,o)
 [a,b]=size(I);
 I4=I;
 I2=zeros(a+n-1,b+m-1);
for x=1:a  % I2 = 518*518
    for y=1:b
        I2(x+(n-1)/2,y+(m-1)/2)=I(x,y);  %I1 is the broading edges of the image
    end
end;
for i=1:a
    for j=1:b
        Mask2=zeros(m*n,1);
        counter=1;
            for p=1:n
                for q=1:m
                    Mask2(counter)=I2(i+p-1,j+q-1);
                    counter=counter+1;
                end
            end
            I1(i,j)=mean(Mask2);
    end
end

I3=uint8(I1);
I4(f:f+h,g:g+o)=I3(f:f+h,g:g+o);


end

