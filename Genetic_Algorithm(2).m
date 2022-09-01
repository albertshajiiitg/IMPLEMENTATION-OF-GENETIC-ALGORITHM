%% Binary coded GA implementation
clc,clear all;
%% Range of variables
x1_min=0;
x2_min=0;
x1_max=0.5;
x2_max=0.5;
pc=1;                                             %% crossover probability
N=100;                                            %% Total solution population
itrs=1;
max_itrs=1000;
bit_size=10;                                      %% bits per variable
string_length=2*bit_size;
soln_population=randi([0,1],N,string_length);
mating_pool=zeros(N,string_length);
fitness_array=zeros(N,1);          
cummulative_probability_array=zeros(N,1);  

while itrs<max_itrs

for i=1:N
    x1=scale(soln_population(i,[1:bit_size]),x1_min,x1_max);
    x2=scale(soln_population(i,[bit_size+1:end]),x2_min,x2_max);
    fitness_array(i,1)=multi_quad(x1,x2);
end
s=0;
fitness_sum=sum(fitness_array);

for i=1:N                                           %% loop for creating cummulative probability array
    cummulative_probability_array(i,1)=s+fitness_array(i,1)/fitness_sum;
    s=cummulative_probability_array(i,1);
end

for i=1:N                                            %% loop for creating mating pool
    random_num=rand;
    mating_pool(i,:)=soln_population(min(find(random_num<=cummulative_probability_array)),:);  
end
indexes=[1:1:N];
crossover_site=randsample(string_length-1,1);
parent_1=zeros(1,string_length);
parent_2=zeros(1,string_length);
child_1=zeros(1,string_length);
child_2=zeros(1,string_length);

while ~isempty(indexes)                               %% crossover

      index_pair= randsample(indexes, 2);
      parent_1=mating_pool(index_pair(1),:);
      parent_2=mating_pool(index_pair(2),:);
      
  if rand <pc
      child_1(1,1:crossover_site)=parent_1(1,1:crossover_site);
      child_1(1,crossover_site+1:end)=parent_2(crossover_site+1:end);
      child_2(1,1:crossover_site)=parent_2(1,1:crossover_site);
      child_2(1,crossover_site+1:end)=parent_1(crossover_site+1:end);
      mating_pool(index_pair(1),:)=child_1(1,:);
      mating_pool(index_pair(2),:)=child_2(1,:);
      indexes=setdiff(indexes,index_pair);
   end
end
soln_population=mating_pool;
itrs=itrs+1;
end

fi = fopen('output_file.txt','w');                     %% output is printed in out_data txt file
fprintf(fi,'Solution set obtained are :\n');               %% printing final solution set
fprintf(fi,'x1           x2\n');
for i=1:N
    fprintf(fi,'%f   %f\n',scale(soln_population(i,1:bit_size),x1_min,x1_max),scale(soln_population(i,bit_size+1:end),x2_min,x2_max));
end
%% Actual surface plot 
%{
[X1,X2]= meshgrid(0:0.01:0.5);
Z =  X1 + X2 -2*X1.*X1 -X2.*X2 +X1.*X2;
surf(X1,X2,Z)
%}



