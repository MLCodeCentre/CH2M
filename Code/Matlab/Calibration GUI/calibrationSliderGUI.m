function varargout = calibrationSliderGUI(varargin)
% CALIBRATIONSLIDERGUI MATLAB code for calibrationSliderGUI.fig
%      CALIBRATIONSLIDERGUI, by itself, creates a new CALIBRATIONSLIDERGUI or raises the existing
%      singleton*.
%
%      H = CALIBRATIONSLIDERGUI returns the handle to a new CALIBRATIONSLIDERGUI or the handle to
%      the existing singleton*.
%
%      CALIBRATIONSLIDERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATIONSLIDERGUI.M with the given input arguments.
%
%      CALIBRATIONSLIDERGUI('Property','Value',...) creates a new CALIBRATIONSLIDERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calibrationSliderGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calibrationSliderGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calibrationSliderGUI

% Last Modified by GUIDE v2.5 31-Jul-2019 09:17:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calibrationSliderGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @calibrationSliderGUI_OutputFcn, ...
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


% --- Executes just before calibrationSliderGUI is made visible.
function calibrationSliderGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calibrationSliderGUI (see VARARGIN)

% Choose default command line output for calibrationSliderGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calibrationSliderGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calibrationSliderGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in showAssets.
function showAssets_Callback(hObject, eventdata, handles)
% hObject    handle to showAssets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.imageFile.UserData;
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};

assetTypes = {'SNSF','MKRF','SNPS','DRGU'};
nAssetTypes = numel(assetTypes);
coords = []; labels = {};
for iAssetType = 1:nAssetTypes
    assetType = assetTypes{iAssetType};
    assets = loadAssetData(dataDir,road,assetType,false,handles);
    [assetsImage,pVehicles] = findCloseAssets(assets,image);
    nAssets = size(assetsImage,1);
    printToLog(sprintf('Found %d %s(s) in image',nAssets,...
        assetType),handles);
    % add x,y,z and type
    for iAsset = 1:nAssets
        coords(end+1,1) = pVehicles(iAsset,1);
        coords(end,2) = pVehicles(iAsset,2);
        coords(end,3) = pVehicles(iAsset,3);
        labels{end+1,1} = assetType;
    end
end
% add to showAssets user data
closeAssets = {coords,labels};
set(handles.showAssets,'UserData',closeAssets)
annotate(handles)

% --- Executes on button press in prev.
function prev_Callback(hObject, eventdata, handles)
% hObject    handle to prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
navFile = handles.setRoad.UserData.navFile;
[camera,PCDATE,PCTIME] = parseImageFileName(handles.imageFile.String);
rowInd = find(navFile.PCDATE==PCDATE & navFile.PCTIME == PCTIME);

skip = get(handles.imageSkipSlider,'UserData');
prevImage = navFile(rowInd-skip,:);
prevImage.fileName{1} = constructFileName(camera,prevImage.PCDATE,prevImage.PCTIME);

% load dataDir and road for the plot
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
plotAssetsOnAxes(prevImage,[],[],[],dataDir,road,handles)
set(handles.imageFile,'UserData',prevImage);

%loadAssetData_Callback(hObject, eventdata, handles)
%annotate(handles);


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
navFile = handles.setRoad.UserData.navFile;
[camera,PCDATE,PCTIME] = parseImageFileName(handles.imageFile.String);
rowInd = find(navFile.PCDATE==PCDATE & navFile.PCTIME == PCTIME);

skip = get(handles.imageSkipSlider,'UserData');
nextImage = navFile(rowInd+skip,:);
nextImage.fileName{1} = constructFileName(camera,nextImage.PCDATE,nextImage.PCTIME);

% load dataDir and road for the plot
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
plotAssetsOnAxes(nextImage,[],[],[],dataDir,road,handles)
set(handles.imageFile,'UserData',nextImage);

%loadAssetData_Callback(hObject, eventdata, handles)
%annotate(handles)
%fprintf('New: %3.2f, Old: %3.2f\n ',nextImage.HEADING,nextImage.HEADINGOLD)


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
imageFile = uigetfile(fullfile(dataDir,road,'Images','2_*.jpg'),'Select an image');
if imageFile ~= 0
    % parse image information and find navFile entry
    [camera,PCDATE,PCTIME] = parseImageFileName(imageFile);
    navFile = handles.setRoad.UserData.navFile;
    image = navFile(find(navFile.PCDATE==PCDATE & navFile.PCTIME == PCTIME),:);
    % add the file name and plot on axis. 
    image.fileName{1} = imageFile;
    plotAssetsOnAxes(image,[],[],[],dataDir,road,handles)
    set(handles.axes1,'UserData',imageFile)
    set(handles.imageFile,'UserData',image);
end



function console_Callback(hObject, eventdata, handles)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of console as text
%        str2double(get(hObject,'String')) returns contents of console as a double


% --- Executes during object creation, after setting all properties.
function console_CreateFcn(hObject, eventdata, handles)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function imageSkipSlider_Callback(hObject, eventdata, handles)
% hObject    handle to imageSkipSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
skip = round(get(hObject,'Value'));
set(handles.imageSkipSlider,'UserData',skip)
set(handles.imageSkipVal,'String',sprintf('skip: %d',skip))


% --- Executes during object creation, after setting all properties.
function imageSkipSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageSkipSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(handles.imageSkipSlider,'UserData',1)
set(handles.imageSkipVal,'String',sprintf('skip: %d',1))


% --- Executes on button press in showCloseAssets.
function showCloseAssets_Callback(hObject, eventdata, handles)
% hObject    handle to showCloseAssets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% find assets and bounding boxes
cameraParams = collectCameraParams(handles);
image = handles.imageFile.UserData;
assetData = handles.assetTable.Data;
assetVariableNames = handles.assetTable.ColumnName;
assets = cell2table(assetData,'VariableNames',assetVariableNames);
[closeAssets,closePv,closeDims] = findCloseAssets(assets,image);
nAssets = size(closeAssets,1);
fprintf('------------------------------------\n')
for iAsset = 1:nAssets
   fprintf('------------------------------------\n')
   fprintf('x:%0.1f  y:%0.1f  z:%0.1f  w:%0.1f  h:%0.1f\n',...
       closePv(iAsset,1),closePv(iAsset,2),closePv(iAsset,3),...
       closeDims(iAsset,2),closeDims(iAsset,3));
end
%assetsImage = findAssetsInImage(assets,image,cameraParams);
imageAssets.pV = closePv;
imageAssets.Dims = closeDims;
%printToLog(sprintf('Found %d assets',size(imageAssets,2)),handles);
set(handles.showCloseAssets,'UserData',imageAssets);
annotate(handles);



% --- Executes on button press in showClosestImage.
function showClosestImage_Callback(hObject, eventdata, handles)
% hObject    handle to showClosestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function alphaSlider_Callback(hObject, eventdata, handles)
% hObject    handle to alphaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
alpha = get(hObject,'Value');
set(handles.alphaSlider,'UserData',alpha)
set(handles.alphaVal,'String',sprintf('%2.2f [degs]',alpha));
% annote the road surface
annotate(handles);



% --- Executes during object creation, after setting all properties.
function alphaSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function betaSlider_Callback(hObject, eventdata, handles)
% hObject    handle to betaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
beta = get(hObject,'Value');
set(handles.betaSlider,'UserData',beta)
set(handles.betaVal,'String',sprintf('%2.2f [degs]',beta));
% annote the road surface
annotate(handles);


% --- Executes during object creation, after setting all properties.
function betaSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function gammaSlider_Callback(hObject, eventdata, handles)
% hObject    handle to gammaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
gamma = get(hObject,'Value');
set(handles.gammaSlider,'UserData',gamma)
set(handles.gammaVal,'String',sprintf('%2.2f [degs]',gamma))
% annote the road surface
annotate(handles);


% --- Executes during object creation, after setting all properties.
function gammaSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function x0Slider_Callback(hObject, eventdata, handles)
% hObject    handle to x0Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
x0 = get(hObject,'Value');
set(handles.x0Slider,'UserData',x0)
set(handles.x0Val,'String',sprintf('%2.2f [m]',x0))
% annote the road surface
annotate(handles);


% --- Executes during object creation, after setting all properties.
function x0Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x0Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function y0Slider_Callback(hObject, eventdata, handles)
% hObject    handle to y0Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
y0 = get(hObject,'Value');
set(handles.y0Slider,'UserData',y0)
set(handles.y0Val,'String',sprintf('%2.2f [m]',y0))
% annote the road surface
annotate(handles);


% --- Executes during object creation, after setting all properties.
function y0Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y0Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function hSlider_Callback(hObject, eventdata, handles)
% hObject    handle to hSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
h = get(hObject,'Value');
set(handles.hSlider,'UserData',h)
set(handles.hVal,'String',sprintf('%2.2f [m]',h))
% annote the road surface
annotate(handles);


% --- Executes during object creation, after setting all properties.
function hSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function fSlider_Callback(hObject, eventdata, handles)
% hObject    handle to fSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
f = get(hObject,'Value');
set(handles.fSlider,'UserData',f)
set(handles.fVal,'String',sprintf('%2.0f [pixels]',f))
% annote the road surface
annotate(handles);


% --- Executes during object creation, after setting all properties.
function fSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in setRoad.
function setRoad_Callback(hObject, ~, handles)
% hObject    handle to setRoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns setRoad contents as cell array
%        contents{get(hObject,'Value')} returns selected item from setRoad


% --- Executes during object creation, after setting all properties.
function setRoad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setRoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in setAssetType.
function setAssetType_Callback(hObject, eventdata, handles)
% hObject    handle to setAssetType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns setAssetType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from setAssetType


% --- Executes during object creation, after setting all properties.
function setAssetType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setAssetType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in loadAssetData.
function loadAssetData_Callback(hObject, eventdata, handles)
% hObject    handle to loadAssetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% dataDir and Road
% dataDir = handles.setDataDir.UserData;
% road = handles.setRoad.String{handles.setRoad.Value};
% % current image
assetType = getAssetType(handles);
% loading dataDir and road 
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
loadAssetData(dataDir,road,assetType,true,handles);


%--- loads asset data and adds to table.
function assetData = loadAssetData(dataDir,road,assetType,showTable,handles)

assetDbfFolder = fullfile(dataDir,road,'Inventory');
assetDbfFile = dir(fullfile(assetDbfFolder,['*',assetType,'*.dbf']));

% if there is a dbf file
if isempty(assetDbfFile)
    printToLog(sprintf('No %s data',assetType),handles);
else
    [assetData,fieldNames] = dbfRead(fullfile(assetDbfFolder,assetDbfFile.name));
    assetDataTable = cell2table(assetData,'VariableNames',fieldNames);
    % check if there is location data, and then order by it
    if any(strcmp(fieldNames,'XCOORD'))
        assetDataTable = orderTable(assetDataTable);
    end
    % convert back to cell and set UI table
    assetData = table2cell(assetDataTable);
    if showTable
        set(handles.assetTable,'Data',assetData,'columnname',fieldNames,'ColumnFormat',{'bank'})
        printToLog(sprintf('%s data loaded successfully',assetType),handles)   
    else
        assetData = cell2table(assetData);
        assetData.Properties.VariableNames = fieldNames;
    end
end


% --- Executes on button press in loadNavData.
function loadNavData_Callback(hObject, eventdata, handles)
% hObject    handle to loadNavData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    dataDir = handles.setDataDir.UserData;
    road = handles.setRoad.String{handles.setRoad.Value};
    % load navFile
    navDBF = sprintf('%s.dbf',road);
    [navData,fieldNames] = dbfRead(fullfile(dataDir(),road,'Nav',navDBF));
    navFile = cell2table(navData,'VariableNames',fieldNames);
    %navFile = sortrows(navFile,{'PCDATE','PCTIME'});
    navFile.PCDATE = str2double(navFile.PCDATE);
    navFile.PCTIME = str2double(navFile.PCTIME);
    %navFile = fixHeadingsCentralDiff(navFile);
    navFile = kalmanFilter(navFile);
    % create a struct so that the road has a nav file and the
    % camera parameters for each year.
    navData = struct('navFile',navFile);
    set(handles.setRoad,'UserData',navData);
    
    printToLog(sprintf('%s navigation file successfully loaded',road),handles)
    
catch e %e is an MException struct
    printToLog(e.message,handles)
end


% --- Executes on button press in setDataDir.
function setDataDir_Callback(hObject, eventdata, handles)
% hObject    handle to setDataDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = uigetdir('/');
set(handles.setDataDir,'UserData',dataDir);
printToLog(sprintf('dataDir set to %s',dataDir),handles);


% --- Parses assetType info from selectAssetType
function assetType = getAssetType(handles)
assetType = handles.setAssetType.String{handles.setAssetType.Value};
assetTypeInfo = strsplit(assetType,' ');
assetType = assetTypeInfo{1};


% --- Prints to console
function printToLog(message,handles)
oldmsgs = cellstr(get(handles.console,'String'));
set(handles.console,'String',[{message};oldmsgs])


% --- Plots asset, target box and pixels on image
function plotAssetsOnAxes(image,box,targetPixels,assetType,dataDir,road,handles)
% check if there is an image to plot and if not leave axes white
if isempty(image)
    %printToLog(sprintf('No image available for %s',year),handles)
    whiteImage = 255 * ones(2000,2000,'uint8');
    imshow(whiteImage);
    set(handles.imageFile,'String',' ')
else
    % load image and file_name
    img = imread(fullfile(dataDir,road,'Images',image.fileName{1}));
    imgFile = image.fileName{1};
    % load correct image handle, button down function and user data
    h = imshow(img,'Parent',handles.axes1,'InitialMagnification','fit');
    set(h,'ButtonDownFcn',{@axes1Image_ButtonDownFcn,handles});
    set(handles.imageFile,'String',imgFile);
    set(handles.imageFile,'UserData',image);        
    % plot box and pixels if not empty
    if ~isempty(box)
        rectangle('Position',box,...
            'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
        plot(targetPixels(1),targetPixels(2),'g+')
        hold on
        text(targetPixels(1),targetPixels(2),assetType,'color','m')
    end
end


% --- creates image file name from camera, PCDATE and PCTIME 
function fileName = constructFileName(camera,PCDATE,PCTIME)
fileName = sprintf('%d_%d_%d.jpg',camera,PCDATE,PCTIME);


% --- create camera parameter struct from sliders
function cameraParams = collectCameraParams(handles)
cameraParams.alpha = deg2rad(get(handles.alphaSlider,'UserData'));
cameraParams.beta = deg2rad(get(handles.betaSlider,'UserData'));
cameraParams.gamma = deg2rad(get(handles.gammaSlider,'UserData'));
cameraParams.x0 = get(handles.x0Slider,'UserData');
cameraParams.y0 = get(handles.y0Slider,'UserData');
cameraParams.h = get(handles.hSlider,'UserData');
cameraParams.fu = get(handles.fSlider,'UserData');
cameraParams.fv = get(handles.fSlider,'UserData');
cameraParams.m = 2464;
cameraParams.n = 2056;


% --- clears figure and draws new annotation
function annotate(handles)
% load camera params road and dataDir
cameraParams = collectCameraParams(handles);
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
% get current annotation and delete
annotations = findobj(handles.axes1,'Type','line');
delete(annotations);
labels = findobj(handles.axes1,'Type','text');
delete(labels);
rectangles = findobj(handles.axes1,'Type','rectangle');
delete(rectangles);

% assets = handles.showCloseAssets.UserData;
% coords = assets.pV; Dims = assets.Dims;
% % draw new annotations on road surface
% % find assets and bounding boxes
% % % plot those assets on the image.
% assetType = getAssetType(handles);
% nAssets = size(coords,1);
hold on
% for iAsset = 1:nAssets
%     [u,v] = getPixelsFromCoords(coords(iAsset,:)',cameraParams);
%     box = getBoundingBox(coords(iAsset,:),Dims(iAsset,:),cameraParams);
%     try
%         rectangle('Position',box,...
%                 'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
%     catch
%         disp('No rectangle')
%     end
%     plot(u,v,'g+')
%     text(u,v,assetType,'color','m')
% end

% add all assets too.

allAssets = handles.showAssets.UserData;
coords = allAssets{1}; labels = allAssets{2};
nAssets = size(coords,1);
for iAsset = 1:nAssets
    [u,v] = getPixelsFromCoords(coords(iAsset,:)',cameraParams);
    %box = getBoundingBox(coords(iAsset,:),Dims(iAsset,:),cameraParams);
    box = [];
    try
        rectangle('Position',box,...
                'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
    catch
        disp('No rectangle')
    end
    plot(u,v,'g+')
    text(u,v,labels{iAsset},'color','m')
end
%annotateRoad(cameraParams)
hold off

% --- Executes on button press in saveCameraParams.
function saveCameraParams_Callback(hObject, eventdata, handles)
% hObject    handle to saveCameraParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set of folder to save parameters to
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
outFolder = fullfile(dataDir,road,'Calibration');
mkdir(outFolder);
% collect parameters from sliders and save
cameraParams = collectCameraParams(handles);
cameraParamTable = struct2table(cameraParams);
writetable(cameraParamTable,fullfile(outFolder,'camera_parameters.csv'))
printToLog('Camera parameters saved',handles)

% --- Executes on button press in loadCameraParams.
function loadCameraParams_Callback(hObject, eventdata, handles)
% hObject    handle to loadCameraParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
folder = fullfile(dataDir,road,'Calibration');
cameraParamTable = readtable(fullfile(folder,'camera_parameters.csv'));
cameraParams = table2struct(cameraParamTable);
% reset sliders and values
% alpha
set(handles.alphaSlider,'Value',rad2deg(cameraParams.alpha))
set(handles.alphaSlider,'UserData',rad2deg(cameraParams.alpha))
set(handles.alphaVal,'String',sprintf('%2.2f [degs]',rad2deg(cameraParams.alpha)))
% beta
set(handles.betaSlider,'Value',rad2deg(cameraParams.beta))
set(handles.betaSlider,'UserData',rad2deg(cameraParams.beta))
set(handles.betaVal,'String',sprintf('%2.2f [degs]',rad2deg(cameraParams.beta)))
% gamma
set(handles.gammaSlider,'Value',rad2deg(cameraParams.gamma))
set(handles.gammaSlider,'UserData',rad2deg(cameraParams.gamma))
set(handles.gammaVal,'String',sprintf('%2.2f [degs]',rad2deg(cameraParams.gamma)))
% x0
set(handles.x0Slider,'Value',cameraParams.x0)
set(handles.x0Slider,'UserData',cameraParams.x0)
set(handles.x0Val,'String',sprintf('%2.2f [m]',cameraParams.x0))
% y0
set(handles.x0Slider,'Value',cameraParams.y0)
set(handles.y0Slider,'UserData',cameraParams.y0)
set(handles.y0Val,'String',sprintf('%2.2f [m]',cameraParams.y0))
% h
set(handles.hSlider,'Value',cameraParams.h)
set(handles.hSlider,'UserData',cameraParams.h)
set(handles.hVal,'String',sprintf('%2.2f [m]',cameraParams.h))
% f
set(handles.fSlider,'Value',cameraParams.fu)
set(handles.fSlider,'UserData',cameraParams.fu)
set(handles.fVal,'String',sprintf('%2.2f [pix]',cameraParams.fu))

annotate(handles)


% --- Executes when selected cell(s) is changed in assetTable.
function assetTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to assetTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.Indices) == 0
    % selecting asset clicked on in table
    asset = cell2table(eventdata.Source.Data(eventdata.Indices(1),:),...
                       'VariableNames',eventdata.Source.ColumnName);
    % if there is any location data
    if any(strcmp('XCOORD',asset.Properties.VariableNames))
        % load nav files, dataDir, road and cameraParams from handles
        navFile = handles.setRoad.UserData.navFile;
        assetType = getAssetType(handles);
        dataDir = handles.setDataDir.UserData;
        road = handles.setRoad.String{handles.setRoad.Value};
        cameraParams = collectCameraParams(handles);
        % find assets and plot on axes
        [image,box,targetPixels] = ...
            getAssetImage(asset,navFile,cameraParams);
        %axes(handles.surveyImage);
        plotAssetsOnAxes(image,box,targetPixels,assetType,dataDir,road,handles)
    else
        printToLog('No location data available',handles)
    end %is XCOORD and YCOORD a field
end % isempty
