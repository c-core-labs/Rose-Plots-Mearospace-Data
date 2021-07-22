%%% Decripts the Merospace data and the data is put in test.txt file where
%%% it is easier to read 
%%% Inputs: Merospace data in a text file 
%%% Outputs: test.txt file where the organized data is stored, myfile.shp
%%% where the data is plotted so it can be read by ArcMap, numerous
%%% polarhistorgrams for each latitude and longitude showing the course
%%% over ground for that position
%%% Asumptions : the Merospace data is a text file


clear
warning off
fopen('test.txt','w');
fclose('all');

%opens/creates myfile and closes all files that are open 
fopen('myfile.shp','w');
fclose('all');

%opens the Merospace Data with read permissions
fileID = fopen('Maerospace_20210624_085700.txt', 'r');
%Gets the first line of the data 
tline = fgetl(fileID);

 %Adds headers to the test file  
 fid = fopen('test.txt', 'a');
 fprintf(fid, 'cog\t\t sog\t\t mmsi\t\t\t long\t\t\t lat\t\t\t last obs\t\t\t\t\t obs');
 fclose('all');

 %converts to character array
k = char(tline);

%Variable used for shapefile to get multiple points 
 p = 1;
 
 v = 0;
 
%Variables for indexing 
f = 1;
n = 1;
q =1 ;
j = 0;

f2 = 1;
n2 = 1;
q2 = 1 ;
j2 = 0;

f3 = 1;
n3 = 1;
q3 = 1 ;
j3 = 0;

f4 = 1;
n4 = 1;
q4 = 1 ;
j4 = 0;

f5 = 1;
n5 = 1;
q5 = 1 ;
j5 = 0;

f6 = 1;
n6 = 1;
q6 = 1 ;
j6 = 0;

f7 = 1;
n7 = 1;
q7 = 1 ;
j7 = 0;

%find cog in array and marks it's location
m = strfind(k, 'cog');
%gets the lenth of the new array created for a loop
l = length(m);


while j < l
    
%find cog in array and marks it's location
m = strfind(k, 'cog":');  

%indexing- runns through the array m and gets value listed at that point 
i= m(q:n);
 n = n+1;
 q = q+1;
 
 place  = i + 7;
 cog = k(place:(place+2));

 %find and replace 
 quotes =  find(cog == '"');

  if quotes ~isempty(quotes);
      cog(quotes)= ' ' ;
     %cog = cog(1:quotes-1);
     
  else
     cog = cog(1:3) ;
  end
  
   quotes =  find(cog == ',');
   
if quotes ~isempty(quotes);
      cog(quotes)= ' ' ;
end

%find sog in array and marks it's location
m2 = strfind(k, 'sog":');

    
i2= m2(q2:n2);
 n2 = n2+1;
 q2 = q2+1;
 
 place  = i2 + 7;
 sog = k(place:(place+3));

 %find and replace 
 quotes2 =  find(sog == '"');

  if quotes2 ~isempty(quotes2);
      sog(quotes2)= '' ;
     %cog = cog(1:quotes-1)
     
  else
     sog = sog(1:4) ;
  end
  
   quotes2 =  find(sog == ',');
   
if quotes2 ~isempty(quotes2);
      sog(quotes2)= '' ;
end

 %find mmsi in array and marks it's location
 m3 = strfind(k, 'mmsi":');

    
i3= m3(q3:n3);
 n3 = n3+1;
 q3 = q3+1;
 
 place  = i3 + 8;
 mmsi = k(place:(place+8));
 
 
 
 
 %find long in array and marks it's location
 m4 = strfind(k, 'lon":');

    
i4= m4(q4:n4);
 n4 = n4+1;
 q4 = q4+1;
 
 place  = i4 + 7;
 long = k(place:(place+8));
 
 
 
 %find lat in array and marks it's location
  m5 = strfind(k, 'lat":');

    
i5= m5(q5:n5);
 n5 = n5+1;
 q5 = q5+1;
 
 place  = i5 + 7;
 lat = k(place:(place+7));
 
 
 
 %find last obs in array and marks it's location
  m6 = strfind(k, 'last obs": "');

    
i6= m6(q6:n6);
 n6 = n6+1;
 q6 = q6+1;
 
 place  = i6 + 12;
 last = k(place:(place+9));
 
 x = str2double(last);
 last = datetime(x, 'convertfrom','posixtime');
 

 %find obs in array and marks it's location
   m7 = strfind(k, '"obs": "');

    
i7= m7(q7:n7);
 n7 = n7+1;
 q7 = q7+1;
 
 place  = i7 + 8;
 obs = k(place:(place+9));
 
 x = str2double(obs);
 obs = datetime(x, 'convertfrom','posixtime');
 
 %appends values to test file 
 fid = fopen('test.txt', 'a');
 fprintf(fid, '\n %s\t %s\t    %s\t    %s\t    %s\t    %s\t    %s\t    ' , cog, sog, mmsi, long, lat, last, obs );
 fclose('all');
 

%Converting to right data form to be used in shapewrite command later
lat = str2double(lat);
long = str2double(long);
cog = str2double(cog);

sog = num2str(sog);

obs = datestr(obs);
obs = convertStringsToChars(obs);

last = datestr(last);
last = convertStringsToChars(last);


%Gets the information needed to create a point in a shapefile (attributes
%of point)
Data(p).Geometry = deal('Point') ;
Data(p).Lat = lat  ;  % latitude
Data(p).Lon = long ;  % longitude
Data(p).cog = cog ;   % some random attribute
Data(p).sog = sog ;
Data(p).mmsi = mmsi ;
Data(p).last_obs = last ;
Data(p).obs = obs ;


%using the data for point p the information is put in myfile.shp

%shapewrite(Data, 'myfile.shp')


%Variable so we can create multiple points in the shapefile
  p = p +1;  
  
 %variable for loop 
 j = j +1;

end

%creating lists of zeros 
latVal = zeros(length(Data),1);
cog = zeros(length(Data),1);
longVal = zeros(length(Data),1);

%creating lists for longitude, latitude and cog
for I = 1 :length(latVal)
    latVal(I) = Data(I).Lat;
    longVal(I) = Data(I).Lon;
    cogVal(I) = Data(I).cog;
end

%infinite loop variable
j = 1;

%intial latitude (a) and longitude(b) values
a= 35;
b = -17;

%infinite loop 
while j == 1
   
%emptying lists from prior runs 
list_cog_lat = [];
list_found_lat = [];

%increments latitude and longitude
    a = a +1;
    b = -17;
    
%to stop at max value of latitude
    if a == 69
         break
     else
    end

%gets rid of decimals and makes it an integer
lattrunc = floor(latVal);

%finding specified latitude
list_found_lat = find (lattrunc == a);

%for all values in list_found_lat the cog value is found and added to
%list_cog_lat
for i=1:length(list_found_lat)
    x = list_found_lat(i);
    cog = cogVal(x);
    list_cog_lat(end +1) = cog;
    i = i +1 ;
end



%infinite loop for finding longitude
    while j == 1
     
    %emptying lists from prior runs and incrementing b(longitude)
     list_cog_long = [];
    list_found_long = [];
    
    list_both = [];
    
    b = b -1 ;
    

    %gets rid of decimals and makes it an integer     
    longtrunc = floor(longVal);
    
    %finding specified longitude
    list_found_long = find (longtrunc ==b);
    
    
    %to stop at min value of longitude and return to intial loop where a is
    %incremented
            if b == -66
               break
            else
            end
    
   %continues on if longitude values in that range exist
   if ~isempty(list_found_long)
       
            %for all values in list_found_long the cog value is found and added to
            %list_cog_long
            for i=1:length(list_found_long)
                x = list_found_long(i);
                cog = cogVal(x);
                list_cog_long(end +1) = cog;
                i = i +1 ;
            end

            %both lists with cog values are compared to see if any of the
            %values are the same. If they are the same ismember returns a 1
            %then common searches both for any ones creating a new list
        both = ismember (list_cog_lat, list_cog_long);
        common = find (both == 1);
    
        %Checks to see that both list have a value in common before
        %continuing 
        if ~isempty(common)

            %a list is created of the cog values both lists have in common 
                for i = 1:length(common)
                    y = common(i);
                    t = list_cog_lat(y);
                    list_both(end+1) = t ;
                end 

            %list of common values of cog is used to create a rose plot
            %and save it based on it's a (latitude) and b (longitude)
            %values
                
            polarhistogram(list_both);
            title('Vessel Course over Ground','fontweight','bold','fontsize',10)
             saveas(gcf, strcat('Rose_plot_lat_', num2str(a) , '_long_', num2str(b) ))
        else
        end
   else
   end

    end

end

display('DONE!')
