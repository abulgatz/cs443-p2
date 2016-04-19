function varargout = CS443Project2(varargin)
% CS443PROJECT2 MATLAB code for CS443Project2.fig
%      CS443PROJECT2, by itself, creates a new CS443PROJECT2 or raises the existing
%      singleton*.
%
%      H = CS443PROJECT2 returns the handle to a new CS443PROJECT2 or the handle to
%      the existing singleton*.
%
%      CS443PROJECT2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CS443PROJECT2.M with the given input arguments.
%
%      CS443PROJECT2('Property','Value',...) creates a new CS443PROJECT2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CS443Project2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CS443Project2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CS443Project2

% Last Modified by GUIDE v2.5 14-Apr-2016 10:11:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CS443Project2_OpeningFcn, ...
                   'gui_OutputFcn',  @CS443Project2_OutputFcn, ...
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


% --- Executes just before CS443Project2 is made visible.
function CS443Project2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CS443Project2 (see VARARGIN)

% Choose default command line output for CS443Project2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CS443Project2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CS443Project2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load correct frames according to button selection
switch get(get(handles.uibuttongroup2, 'SelectedObject'),'Tag')
    case 'radiobutton5'
        Ref = imread('sample11.bmp');
        Tar = imread('sample12.bmp');
    case 'radiobutton6'
        Ref = imread('sample21.bmp');
        Tar = imread('sample22.bmp');
end
switch get(get(handles.uibuttongroup3, 'SelectedObject'), 'Tag')
    case 'radiobutton7'
        N=8;
    case 'radiobutton8'
        N=16;
end

p = 7;

% get size of images and convert to grayscale if needed
[x,y,z] = size(Tar);
if z > 1
    Ref = rgb2gray(Ref);
    Tar = rgb2gray(Tar);
end

% pad arrays with 0s so no worrying about indices later
Ref = padarray(Ref,[N,N],0,'both');
Tar = padarray(Tar,[N,N],0,'both');

% init some matrices
MC = uint8(zeros(size(Tar)));
MVx = MC;
MVy = MC;
FD = MC;
DFD = MC;

% first 2 for loops traverse the blocks
for i = N+1:N:x+N
    for j = N+1:N:y+N
        % initialize values
        mad_min = 9999;
        u = 0;
        v = 0;
        
        % these loops search through the blocks
        for k = -p:p 
            for l = -p:p
                %init mad value
                mad = 0;
                
                %find the mad value for the given block
                for xx = i:i+N-1
                    for yy = j:j+N-1
                        x1 =  xx;
                        y1 =  yy;              
                        x2 = k + xx;              
                        y2 = l + yy;
                        mad = mad + abs(Ref(x1,y1) - Tar(x2,y2));       
                    end 
                end
                
                % if mad is new mad_min, save it and save k and l values
                if mad < mad_min
                    mad_min = mad;
                    u = k;
                    v = l;
                end   
            end
        end
        % store the vector values for displaying later
        MVx(i+3,j+3) = u;
        MVy(i+3,j+3) = v;
        
        % copy the correct MB to the predicted frame
        for ii = 1:N+1
            for jj = 1:N+1
                x1 = i+ii-1;
                y1 = j+jj-1;
                x2 = x1 + u;
                y2 = y1 + v;

                MC(x1,y1) = Ref(x2, y2);
                % build the FD and DFD image while here
                FD(x1,y1) = abs(Tar(x1,y1) - Ref(x1,y1));
                DFD(x1,y1)= abs(Tar(x1,y1) - MC(x1,y1));
                
            end
        end
    end
        
end

% remove the padding from the images
Ref = Ref(N+1:x+N+1,N+1:y+N+1);
Tar =Tar(N+1:x+N+1,N+1:y+N+1);
MC = MC(N+1:x+N+1,N+1:y+N+1);
FD = FD(N+1:x+N+1,N+1:y+N+1);
DFD = DFD(N+1:x+N+1,N+1:y+N+1);

% calculate MSE and PSNR
MSE = 0.0;
for iii = 1:x
    for jjj = 1:y
        MSE = MSE + double((Tar(iii,jjj) - MC(iii,jjj))^2);
    end
end

MSE   = MSE / (x * y);
PSNR  = 20 * log10(255/sqrt(MSE));

MSEtext = sprintf('%f', MSE);
PSNRtext = sprintf('%f', PSNR);

set(handles.text7, 'String', MSEtext);
set(handles.text8, 'String', PSNRtext);

axes(handles.axes1);
axis off;
imshow(Ref);

axes(handles.axes2);
axis off;
imshow(Tar);

axes(handles.axes3);
axis off;
switch get(get(handles.uibuttongroup1, 'SelectedObject'),'Tag')
    case 'radiobutton1'
        imshow(MC);
        set(handles.text4, 'String', 'Motion Compensated Frame');
    case 'radiobutton2'
        set(handles.text4, 'String', 'Motion Vector Overlay');
        imshow(Ref);
        hold on;
        quiver(MVx, MVy, N);
        hold off;
    case 'radiobutton3'
        set(handles.text4, 'String', 'FD Frame');
        imshow(FD);
    case 'radiobutton4'
        set(handles.text4, 'String', 'DFD Frame');
        imshow(DFD);
end


% All the radiobuttons call back to the run button on press

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
pushbutton1_Callback(hObject, eventdata, handles);


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
pushbutton1_Callback(hObject, eventdata, handles)


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
pushbutton1_Callback(hObject, eventdata, handles)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
pushbutton1_Callback(hObject, eventdata, handles)


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
pushbutton1_Callback(hObject, eventdata, handles)


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
pushbutton1_Callback(hObject, eventdata, handles)


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
pushbutton1_Callback(hObject, eventdata, handles)


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
pushbutton1_Callback(hObject, eventdata, handles)
