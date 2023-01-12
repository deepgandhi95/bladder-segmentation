function varargout = Bladder_Volume_GUI(varargin)
% BLADDER_VOLUME_GUI MATLAB code for Bladder_Volume_GUI.fig
%      BLADDER_VOLUME_GUI, by itself, creates a new BLADDER_VOLUME_GUI or raises the existing
%      singleton*.
%
%      H = BLADDER_VOLUME_GUI returns the handle to a new BLADDER_VOLUME_GUI or the handle to
%      the existing singleton*.
%
%      BLADDER_VOLUME_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BLADDER_VOLUME_GUI.M with the given input arguments.
%
%      BLADDER_VOLUME_GUI('Property','Value',...) creates a new BLADDER_VOLUME_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Bladder_Volume_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Bladder_Volume_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Bladder_Volume_GUI

% Last Modified by GUIDE v2.5 10-Jul-2017 14:36:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Bladder_Volume_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Bladder_Volume_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Bladder_Volume_GUI is made visible.
function Bladder_Volume_GUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Bladder_Volume_GUI (see VARARGIN)

% Choose default command line output for Bladder_Volume_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Bladder_Volume_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Bladder_Volume_GUI_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load Images in Stack.
function pushbutton1_Callback(~, ~, ~)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global masksZ; 
global index;
index = 1;
global data;
global filenames;
set(gcf, 'pointer', 'watch')
drawnow;

[filenames, pathstr] = uigetfile('*.*', 'Select MRE data or loc file','multiselect', 'on');
tmp = dicomread(fullfile(pathstr, filenames{1,1})); 

data = zeros(size(tmp,1),size(tmp,2),size(filenames,2)); 
for i = 1:size(filenames,2)
    
data(:,:,i) = dicomread(fullfile(pathstr, filenames{1,i}));
end
masksZ = zeros(size(tmp,1), size(tmp,2), 2,size(filenames,2));
imagesc(data(:,:,index)); colormap(gray);axis off; hold on;
title(sprintf('Magnitude Z index = %.3g%', index), 'fontsize', 18);
set(gcf, 'pointer', 'arrow')


function keypress_callback(~, eventdata, ~)

global index;
global filenames; 
tmp = filenames; 
global data;
global masksZ;
%%%%For normal order of files%%%%

    
switch eventdata.Character
    case 28 % Left
        if index == 1
            index = size(tmp,3); 
        else 
            index = index - 1; 
        end 
    case 29 % Right
        if index == size(tmp,2)
            index = 1; 
        else 
            index = index + 1; 
        end 
end 


imagesc(data(:,:,index)); colormap(gray);axis off; hold on;
title(sprintf('Magnitude Image = %.3g%', index), 'fontsize', 18);

mask1 = masksZ(:,:,1,index); 
mask2 = masksZ(:,:,2,index); 


    if max(max(mask1))~=0
    contour(mask1,'r','linewidth',0.5);hold on; 
    contour(mask2,'r','linewidth',0.5);hold off; 
    else 
        hold off; 
    end 


% --- Executes on button press in Crop Image.
function pushbutton2_Callback(~, ~, ~)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Threshold.
function pushbutton3_Callback(~, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index; 
global data; 
global roi1;
global mask1; 
global level; 
global masksZ; 

tmpim = data(:,:,index); 


a = tmpim; 
figure, imshow(a,[]); 
level = thresh_tool(a, []);  

max_val = max(max(a)); 

img = a; 

tmp = zeros(size(img));
e =  (img<level) ;
tmp(e) = max_val; 

% roi1 = imfreehand; 
% roi1= createMask(roi1); 
% close(gcf);
mask1 = tmp.*roi1; 

%%Pick biggest area
s1 = mask1; 
cc = bwconncomp(s1);
stats = regionprops(cc, 'basic');
A = [stats.Area];
[~, biggest] = max(A);
s1(labelmatrix(cc)~=biggest) = 0; 
s1 = imfill(s1,'holes');
mask1 = s1;

% %%Pick biggest area
% s1 = mask1; 
% cc = bwconncomp(s1);
% stats = regionprops(cc, 'basic');
% A = [stats.Area];
% [~, smallest] = min(A);
% s1(labelmatrix(cc)==smallest) = 0; 
% s1 = imfill(s1,'holes');
% mask1 = s1;

%Save masks and update

masksZ(:,:,1,index) = mask1; 

update_mask(handles); 

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(~, ~, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index; global mask1;
   
  global masksZ; 
global data;

tmpim = data(:,:,index); 
mask = masksZ(:,:,1,index);


cIM = tmpim; 
cIM = uint16(cIM);
axes(handles.axes1);  
imagesc(cIM); colormap(gray);axis off; hold on; 
contour(mask1,'r','linewidth',0.5);hold off; 
axes(handles.axes1);  
h = imfreehand;
bw = createMask(h); 
mask = mask | bw; 
delete(h); 
mask1 = mask; 

masksZ(:,:,1,index) = mask1; 
  
update_mask(handles); 


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(~, ~, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index; global mask1;
   
global data;
  global masksZ; 



tmpim = data(:,:,index); 
mask = masksZ(:,:,1,index);


cIM = tmpim; 
cIM = uint16(cIM);
axes(handles.axes1);  
imagesc(cIM); colormap(gray);axis off; hold on; 
contour(mask1,'r','linewidth',0.5);hold off; 
axes(handles.axes1);  
h = imfreehand;
bw = createMask(h); 
mask(bw) = 0; 
delete(h); 
mask1 = mask; 

masksZ(:,:,1,index) = mask1; 

update_mask(handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(~, ~, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Commented on 1/9/2023 to debug error on line 279
% global masksZ;  
% for k = 63:88
%     thisSlice = imread(.....
%     areas(k) = ComputeAreaForOneSlice(thisSlice);  
% end   

    
update_mask(handles);


% --- Executes on button press in Refresh.
function pushbutton7_Callback(~, ~, ~)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global index;  global data; 
   
global beginslice;  


beginslice = 1;%str2double(get(handles.biggest_slice,'String')); 

imagesc(data(:,:,index)); colormap(gray);axis off; hold on;
title(sprintf('Magnitude Z index = %.3g%', index), 'fontsize', 18);
 
set(gcf, 'KeyPressFcn', @keypress_callback, 'Interruptible', 'on', 'BusyAction', 'queue'); 

function update_mask(handles)
%Show masked boundaries on top of image

   global index; 
global mask1; global mask2;
 global masksZ; global data; 


tmpim = data(:,:,index); 
mask1 = masksZ(:,:,1,index);  

axes(handles.axes1);

imagesc(tmpim); colormap(gray);axis off; hold on; 
if max(max(mask1))~=0
    contour(mask1,'r','linewidth',0.5);hold on; 
end
if max(max(mask2))~=0
    contour(mask2,'r','linewidth',0.5);hold off; 
else
    hold off;
end

% --- Executes on button press in Threshold all.
function pushbutton8_Callback(~, ~, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global magX; global magY; global magZ;
global filenames;
global roi1; global roi2; 
global mask1; global mask2; 
global level; 
global masksZ; 
global data; global index;

for i = 63:88%1:size(filenames,2)
 
tmpim = data(:,:,i); 
a = tmpim;

max_val = max(max(a)); 

img = a; 

tmp = zeros(size(img));
e =  (img<level) ;
tmp(e) = max_val; 

mask1 = tmp.*roi1; 


%%Pick biggest area
s1 = mask1; 
cc = bwconncomp(s1);
stats = regionprops(cc, 'basic');
A = [stats.Area];
[~, biggest] = max(A);
s1(labelmatrix(cc)~=biggest) = 0; 
s1 = imfill(s1,'holes');
mask1 = s1;

% mask2 = tmp.*roi2; 

%%Pick biggest area
s1 = mask2; 
cc = bwconncomp(s1);
stats = regionprops(cc, 'basic');
A = [stats.Area];
[~, biggest] = max(A);
s1(labelmatrix(cc)~=biggest) = 0; 
s1 = imfill(s1,'holes');
mask2 = s1;

%save maskes to only only selected direction

masksZ(:,:,1,i)=mask1; 
% masksZ(:,:,2,i)=mask2; 

end
update_mask(handles);
  


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(~, ~, ~)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   global index; 
global data;
global roi1;  


tmpim = data(:,:,index); 
 
figure, imshow(tmpim, []); 
title('Select ROI: Bladder'); 

roi1 = imfreehand; 
roi1= createMask(roi1); 
  
close(gcf); 