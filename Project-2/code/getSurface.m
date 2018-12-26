function  heightMap = getSurface(surfaceNormals, method)
% GETSURFACE computes the surface depth from normals
%   HEIGHTMAP = GETSURFACE(SURFACENORMALS, IMAGESIZE, METHOD) computes
%   HEIGHTMAP from the SURFACENORMALS using various METHODs. 
%  
% Input:
%   SURFACENORMALS: height x width x 3 array of unit surface normals
%   METHOD: the intergration method to be used
%
% Output:
%   HEIGHTMAP: height map of object

[h,w,n]=size(surfaceNormals);
G1=surfaceNormals(:,:,1);
G2=surfaceNormals(:,:,2);
G3=surfaceNormals(:,:,3);
fx=-1*bsxfun(@rdivide,G1,G3);
fy=-1*bsxfun(@rdivide,G2,G3);
heightMap=zeros(h,w);
output = zeros(h,w);

X_Sum = cumsum(fx,2);
Y_Sum = cumsum(fy);

switch method
    case 'column'
        
        tic;
        heightMap = cumsum(fy(:,1), 1);
        temp=heightMap(:,1);
        heightMap=heightMap+ cumsum(fx,2);
        heightMap(:,1)=temp;
        heightMap=heightMap*-1;
        toc;

        
    case 'row'
        tic;
        heightMap = cumsum(fx(1,:),2);
        temp=heightMap(1,:);
        heightMap=heightMap + cumsum(fy,1);
        heightMap(1,:)=temp;
        heightMap=heightMap*-1;
        toc;

        
    case 'average'
        tic;
        heightMap1 = cumsum(fy(:,1), 1)
        temp=heightMap1(:,1);
        heightMap1=heightMap1+ cumsum(fx,2);
        heightMap1(:,1)=temp;
        heightMap1=heightMap1*-1;
        
        heightMap2 = cumsum(fx(1,:),2);
        temp=heightMap2(1,:);
        heightMap2=heightMap2 + cumsum(fy,1);
        heightMap2(1,:)=temp;
        heightMap2=heightMap2*-1;
        
        heightMap=heightMap1+heightMap2./2;
        toc;

        
        
    case 'random'

        tic;
        heightMap(2:h,1) = Y_Sum(2:h,1);
        heightMap(1,2:w) = X_Sum(1,2:w);
        for i = 2:h
            for j = 1:w
                val = 0;
                count = 0;
                for p = 1:i-1
                    if( j-p >= 1 )
                        val = val+Y_Sum(1+p)+X_Sum(1+p,j-p)+Y_Sum(i,j-p)-Y_Sum(1+p,j-p)+X_Sum(i,j)-X_Sum(i,j-p);
                        count= count+1;
                    end
                end
                if(i==2 || i== h)
                    val = val+Y_Sum(i,1)+X_Sum(i,j);
                    count = count+1;
                end
                heightMap(i,j) = val/count;
            end
        end
        toc;
        
end

