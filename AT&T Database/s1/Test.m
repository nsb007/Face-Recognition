%% Loading the images from the database and converting training images into column matrix
clear all
clc
No_of_people = 40;
Images_per_person = 10;
Training_images = 5;
A = [];
C = [];

for i = 1:No_of_people
    fn = cd(['C:\Users\Ritika\Desktop\Supervised Learning\Project_1\s' num2str(i)]);
    B = [];
    for j = 1:Training_images
        filename = [num2str(j) '.pgm'];
        img = imread(filename);
        A = imresize(img,0.5);
        A = (A(:));
        B = [B A];
    end
    C = [C B];
end

%% PCA
data=C;
[row,col]=size(data); %r=2576,c=200

% Compute the mean of the data matrix "The mean of each row"
m=mean(data')'; 

% Subtract the mean from each image [Centering the data]
d=data-uint8(repmat(m,1,col));
d=double(d);
% Compute the covariance matrix (co)
co=d'*d;

% Compute the eigen values and eigen vectors of the covariance matrix
[eigvector,eigvl]=eig(co);

% Sort the eigen vectors according to the eigen values
eigvalue = diag(eigvl);
[junk, index] = sort(eigvalue,'descend');
eigvalue = eigvalue(index);
eigvector = eigvector(:, index);

% Compute the number of eigen values that greater than zero (you can select any threshold)
count1=0;
for i=1:size(eigvalue,1)
    if(eigvalue(i)>0)
        count1=count1+1;
    end
end


% And also we can use the eigen vectors that the corresponding eigen values is greater than zero(Threshold) and this method will decrease the
% computation time and complixity

vec=eigvector(:,1);

% Compute the feature matrix (the space that will use it to project the testing image on it)
x=vec'*d';



%% If you have test data do the following
R = [];
T = [];
for i = 1:No_of_people
    fn = cd(['C:\Users\Ritika\Desktop\Supervised Learning\Project_1\s' num2str(i)]);
    S = [];
    for j = 6:10
        filename = [num2str(j) '.pgm'];
        img = imread(filename);
        R = imresize(img,0.5);
        R = (R(:));
        S = [S R];
    end
    T = [T S];
end
m_new = uint8(repmat(m,1,200));
%Subtract the mean from the test data
T=T-m_new;
%Project the testing data on the space of the training data
T_new = double(T);
T=vec'*T_new';

%%To know what is the class of this test data use any classifier 
alldata=T';
alldata(2:size(x,2)+1,:)=x'
dist=pdist(alldata);
[a,b]=min(dist(:,1:size(x,2)))
