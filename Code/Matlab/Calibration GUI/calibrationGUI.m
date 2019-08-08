function varargout = calibrationGUI(varargin)
% CALIBRATIONGUI MATLAB code for calibrationGUI.fig
%      CALIBRATIONGUI, by itself, creates a new CALIBRATIONGUI or raises the existing
%      singleton*.
%
%      H = CALIBRATIONGUI returns the handle to a new CALIBRATIONGUI or the handle to
%      the existing singleton*.
%
%      CALIBRATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATIONGUI.M with the given input arguments.
%
%      CALIBRATIONGUI('Property','Value',...) creates a new CALIBRATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calibrationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calibrationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calibrationGUI

% Last Modified by GUIDE v2.5 08-Aug-2019 13:49:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calibrationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @calibrationGUI_OutputFcn, ...
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


% --- Executes just before calibrationGUI is made visible.
function calibrationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calibrationGUI (see VARARGIN)

% Choose default command line output for calibrationGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.figure1,'toolbar','figure');

% UIWAIT makes calibrationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calibrationGUI_OutputFcn(hObject, eventdata, handles) 
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
%road = handles.setRoad.String{handles.setRoad.Value};
image = handles.imageFile.UserData;
assetType = getAssetType(handles);
cameraParams = handles.cameraParamTable.UserData;
assetData = handles.loadAssetData.UserData;
[assetsImage, pVehicles, assetInfo, assetDimensions]...
    = findAssetsInImage(assetData,image,cameraParams);
assetDimensions
assetTypesImage = char(ones(size(assetsImage,1),1) * assetType);

assetTableFields = assetInfo.Properties.VariableNames;
nFields = numel(assetTableFields);
assetTableFields{end+1} = 'x';
assetTableFields{end+1} = 'y';
assetTableFields{end+1} = 'z';
assetInfo.XCOORD = num2str(assetInfo.XCOORD);
assetInfo.YCOORD = num2str(assetInfo.YCOORD);
assetTableData = table2cell(assetInfo);
numAssets = size(assetsImage,1);
for iAsset = 1:numAssets
    assetTableData{iAsset,nFields+1} = pVehicles(iAsset,1);
    assetTableData{iAsset,nFields+2} = pVehicles(iAsset,2);
    if strcmpi(assetType,'MKRF')
        assetTableData{iAsset,nFields+3} = 0.455;
    else
        assetTableData{iAsset,nFields+3} = pVehicles(iAsset,3);
    end
end

set(handles.assetTable,'Data',assetTableData,'columnname',assetTableFields)
axes(handles.axes1);
plotAllAssets(assetsImage,assetTypesImage,true)

hold on
U = [];
V = [];
z = 0;
for x = linspace(10,40,10)
    for y = linspace(-1.8,1.8,10)        
        [u,v] = getPixelsFromCoords([x,y,z]',cameraParams);
        U = [U,u];
        V = [V,v];
    end
    plot(U(:),V(:),'bo')
    hold on
    U = [];
    V = [];
end


% --- Executes on selection change in setRoad.
function setRoad_Callback(hObject, eventdata, handles)
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
try
    dataDir = handles.setDataDir.UserData;
    road = handles.setRoad.String{handles.setRoad.Value};
    assetType = getAssetType(handles);
    assetDBF = sprintf('%s.dbf',assetType);
    [assetData,fieldNames] = dbfRead(fullfile(dataDir(),road,'Inventory',assetDBF));
    assets = cell2table(assetData,'VariableNames',fieldNames);
    set(handles.loadAssetData,'UserData',assets)
    printToLog(sprintf('%s data succesfully loaded',assetType),handles);
    set(handles.assetTable,'Data',assetData,'columnname',fieldNames)
catch e
    printToLog(e.message,handles)
end


% --- Executes on button press in loadNavData.
function loadNavData_Callback(hObject, eventdata, handles)
% hObject    handle to loadNavData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% load dataDir and the road
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
    % update position data
    navFile = kalmanFilter(navFile);
    % update headings
    navFile = preProcessNavFile(navFile);
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


% --- Executes on button press in Prev.
function Prev_Callback(hObject, eventdata, handles)
% hObject    handle to Prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
navFile = handles.setRoad.UserData.navFile;
[camera,PCDATE,PCTIME] = parseImageFileName(handles.imageFile.String);
rowInd = find(navFile.PCDATE==PCDATE & navFile.PCTIME == PCTIME);

skip = get(handles.skipslide,'UserData');
prevImage = navFile(rowInd-skip,:);
prevImage.fileName{1} = constructFileName(camera,prevImage.PCDATE,prevImage.PCTIME);

% load dataDir and road for the plot
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
plotAssetsOnAxes(prevImage,[],[],[],dataDir,road,handles)


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
navFile = handles.setRoad.UserData.navFile;
[camera,PCDATE,PCTIME] = parseImageFileName(handles.imageFile.String);
rowInd = find(navFile.PCDATE==PCDATE & navFile.PCTIME == PCTIME);

skip = get(handles.skipslide,'UserData');
nextImage = navFile(rowInd+skip,:);
nextImage.fileName{1} = constructFileName(camera,nextImage.PCDATE,nextImage.PCTIME);

% load dataDir and road for the plot
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
plotAssetsOnAxes(nextImage,[],[],[],dataDir,road,handles)

%plotting heading and location on axes.
axes(handles.locationAndHeading)
cla(handles.locationAndHeading)
plotCorrectedVehicle(navFile,nextImage.PCDATE,nextImage.PCTIME - 2:nextImage.PCTIME + 2,nextImage.PCTIME)


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
end


% plots asset, target box and pixels on image
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
    hold off;
    % load correct image handle, button down function and user data
    h = imshow(img,'Parent',handles.axes1,'InitialMagnification','fit');
    set(h,'ButtonDownFcn',{@axes1Image_ButtonDownFcn,handles});
    set(handles.imageFile,'String',imgFile);
    set(handles.imageFile,'UserData',image);        
    % plot box and pixels if not empty
    if isempty(box) == 0
        hold on
        rectangle('Position',box,...
            'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
        plot(targetPixels(1),targetPixels(2),'g+')
        text(targetPixels(1),targetPixels(2),assetType,'color','m')
        hold off
    end
end


% parses assetType info from selectAssetType
function assetType = getAssetType(handles)
assetType = handles.setAssetType.String{handles.setAssetType.Value};
assetTypeInfo = strsplit(assetType,' ');
assetType = assetTypeInfo{1};


% parses image file name
function [camera,PCDATE,PCTIME] = parseImageFileName(fileName)
fileNameAndExt = strsplit(fileName,'.');
fileName = fileNameAndExt{1};
fileInfo = strsplit(fileName,'_');
camera = str2num(fileInfo{1});
PCDATE = str2num(fileInfo{2});
PCTIME = str2num(fileInfo{3});


% creates image file name from camera, PCDATE and PCTIME 
function fileName = constructFileName(camera,PCDATE,PCTIME)
fileName = sprintf('%d_%d_%d.jpg',camera,PCDATE,PCTIME);


% --- Executes when entered data in editable cell(s) in cameraParamTable.
function cameraParamTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to cameraParamTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
cameraParamFields = {'alpha','beta','gamma','x0','y0','h','fu','fv','cu','cv','m','n'};
cameraParamVals = handles.cameraParamTable.Data;
cameraParams = table2struct(cell2table(num2cell(cameraParamVals)','VariableNames',cameraParamFields));
set(handles.cameraParamTable,'UserData',cameraParams)
printToLog('Camera parameters set',handles)


% --- Executes during object creation, after setting all properties.
function cameraParamTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cameraParamTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
cameraParamFields = {'alpha','beta','gamma','x0','y0','h','fu','fv','cu','cv','m','n'};
cameraParamVals = {0,0,0,2,0,3,2500,2500,0,0,2464,2056};
set(hObject,'Data',cameraParamVals','rowname',cameraParamFields,'columnname',{});

cameraParams = table2struct(cell2table(cameraParamVals,'VariableNames',cameraParamFields));
set(hObject,'UserData',cameraParams)


% parses assetSearchType info from selectAssetSearchType
function assetType = getAssetSearchType(handles)
assetType = handles.setAssetType.String{...
handles.setAssetType.Value};
assetSearchTypeInfo = strsplit(assetType,' ');
assetType = assetSearchTypeInfo{1};


function plotAllAssets(assetsImage,AssetTypesImage,plotBox)
% plots all assets, to hide the bounding box set plotBox to False, otherwise True.  
nAssets = size(assetsImage,1);
hold on
for iAsset = 1:nAssets
    % parse the columns of assetsImage
    uAsset = assetsImage(iAsset,1);
    vAsset = assetsImage(iAsset,2);
    box = assetsImage(iAsset,3:6);
    % plot bounding box if requested
    if plotBox
         rectangle('Position',box,'LineWidth',1,'LineStyle','-',...
               'EdgeColor','r','Curvature',0);
    end
    % plot pixels
    plot(uAsset,vAsset,'g+')
    text(uAsset,vAsset,AssetTypesImage(iAsset,:),'color','m')
end
hold off


% --- Executes on button press in showClosestImage.
function showClosestImage_Callback(hObject, eventdata, handles)
% hObject    handle to showClosestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
asset = handles.assetTable.UserData; 
if any(strcmp('XCOORD',asset.Properties.VariableNames))
    % load nav files, dataDir, road and cameraParams from handles
    navFile = handles.setRoad.UserData.navFile;
    assetType = getAssetType(handles);
    dataDir = handles.setDataDir.UserData;
    road = handles.setRoad.String{handles.setRoad.Value};
    cameraParams = handles.cameraParamTable.UserData;
    % find assets and plot on axes for year 1
    [image,box,targetPixels,pVehicle] = ...
        getAssetImage(asset,navFile,cameraParams);
    axes(handles.axes1);
    plotAssetsOnAxes(image,box,targetPixels,assetType,dataDir,road,handles)
    set(handles.axes1,'UserData',pVehicle)
else
    printToLog('No location data available',handles)
end  


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over showClosestImage.
function showClosestImage_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to showClosestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function assetTable_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to assetTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in assetTable.
function assetTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to assetTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    row = eventdata.Indices(1);   
    asset = cell2table(eventdata.Source.Data(row,:),...
                       'VariableNames',eventdata.Source.ColumnName);
    handles.assetTable.UserData = asset;  
end


% --- Executes on button press in addObservation.
function addObservation_Callback(hObject, eventdata, handles)
% hObject    handle to addObservation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over addObservation.
function addObservation_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to addObservation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%observation = handles.assetTable.UserData;
[u,v] = ginput(1);
pVehicle = handles.axes1.UserData;
% different if the data is taken from nearest image of asset, or from an
% ordinary image. 
if isempty(pVehicle)
    tableData = handles.assetTable.UserData;
    x = tableData.x; y = tableData.y; z = tableData.z;
else
    x = pVehicle(1); y = pVehicle(2); z = pVehicle(3);  
end
observation = {x,y,z,u,v};

fileName = handles.imageFile.UserData.fileName;
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
% add file to observation data and add to calibration table.
observation{end+1} = fullfile(dataDir,road,'Images',fileName{1});
oldData = get(handles.observationTable,'Data');
newData = [oldData; observation];
set(handles.observationTable,'Data',newData);


% prints to output log
function printToLog(message,handles)
oldmsgs = cellstr(get(handles.outputLog,'String'));
set(handles.outputLog,'String',[{message};oldmsgs] )



function outputLog_Callback(hObject, eventdata, handles)
% hObject    handle to outputLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputLog as text
%        str2double(get(hObject,'String')) returns contents of outputLog as a double


% --- Executes during object creation, after setting all properties.
function outputLog_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calibrationButton.
function calibrationButton_Callback(hObject, eventdata, handles)
% hObject    handle to calibrationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
observationData = handles.observationTable.Data;
observationFields = handles.observationTable.ColumnName;
observations = cell2table(observationData,'VariableNames',observationFields);
cameraParams = handles.cameraParamTable.UserData;
cameraParamsSolve = calibrate(observations,cameraParams);
%cameraParamsSolve = ransacCalibrationGUI(observations,cameraParams);

cameraParamFields = {'alpha','beta','gamma','x0','y0','h','fu','fv','cu','cv','m','n'};
set(handles.cameraParamTable,'Data',cameraParamsSolve','rowname',cameraParamFields,'columnname',{});

cameraParams = table2struct(cell2table(num2cell(cameraParamsSolve),'VariableNames',cameraParamFields));
set(handles.cameraParamTable,'UserData',cameraParams)

% plotting some assets on assetLocalisation axes
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
assetType = 'MKRF';
assetDBF = sprintf('%s.dbf',assetType);
[assetData,fieldNames] = dbfRead(fullfile(dataDir(),road,'Inventory',assetDBF));
assetTable = cell2table(assetData,'VariableNames',fieldNames);

nAssetsTotal = size(assetTable,1);
nAssets = 4;
assetInds = randi(nAssetsTotal,1,nAssets);
assetsToFind = assetTable(assetInds,:);
% find each nearest image, and box and plot on subplot.

navFile = handles.setRoad.UserData.navFile;
figure;
for iAsset = 1:nAssets
    asset = assetsToFind(iAsset,:);
   [assetDimensions,assetZ] = getAssetDimensions(asset);
   [image,box,targetPixels] = findClosestImage(navFile,asset,2,assetDimensions,assetZ,cameraParams);
   if ~isempty(image)
       img = imread(fullfile(dataDir,road,'Images',image.fileName{1}));
       subplot(2,2,iAsset)
       imshow(img); hold on;
       rectangle('Position',box,...
                'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
       plot(targetPixels(1),targetPixels(2),'g+')
       text(targetPixels(1),targetPixels(2),assetType,'color','m') 
   end
end
hold off

% --- Executes during object creation, after setting all properties.
function setDataDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setDataDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function observationTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to observationTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
calibrationDataFields = {'x','y','z','u','v','file'};
calibrationDataVals = {};
set(hObject,'Data',calibrationDataVals,'columnname',calibrationDataFields);



% --- Executes during object creation, after setting all properties.
function skipSlide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to skipSlide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when selected cell(s) is changed in observationTable.
function observationTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to observationTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    rowInd = eventdata.Indices(1);
    set(handles.observationTable,'UserData',rowInd);
end


% --- Executes on button press in deleteRow.
function deleteRow_Callback(hObject, eventdata, handles)
% hObject    handle to deleteRow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rowInd = handles.observationTable.UserData;
observationData = handles.observationTable.Data;
observationData(rowInd,:) = [];
set(handles.observationTable,'Data',observationData);


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.observationTable,'Data',[]);


% --- Executes on button press in saveCalibrationData.
function saveCalibrationData_Callback(hObject, eventdata, handles)
% hObject    handle to saveCalibrationData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
outFolder = fullfile(dataDir,'Calibration Data',road);
mkdir(outFolder);

observationDataTable = cell2table(handles.observationTable.Data,'VariableNames',{'x','y','z','u','v','file'});
writetable(observationDataTable,fullfile(outFolder,'calibration_data.csv'));
printToLog('Calibration data saved',handles)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over saveCameraParameters.
function saveCameraParameters_Callback(hObject, eventdata, handles)
% hObject    handle to saveCameraParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
outFolder = fullfile(dataDir,road,'Calibration');
mkdir(outFolder);

cameraParamTable = struct2table(handles.cameraParamTable.UserData);
writetable(cameraParamTable,fullfile(outFolder,'camera_parameters.csv'))
printToLog('Camera parameters saved',handles)


% --- Executes on slider movement.
function skipslide_Callback(hObject, eventdata, handles)
% hObject    handle to skipslide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
skip = round(get(hObject,'Value'));
printToLog(sprintf('skip set to %d',skip),handles);
set(handles.skipslide,'UserData',skip);


% --- Executes during object creation, after setting all properties.
function skipslide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to skipslide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in showCloseAssets.
function showCloseAssets_Callback(hObject, eventdata, handles)
% hObject    handle to showCloseAssets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.imageFile.UserData;
%assetType = getAssetType(handles);
assetData = handles.loadAssetData.UserData;
[assetInfo,pVehicles] = findCloseAssets(assetData,image);
numAssets = size(assetInfo,1);
if numAssets > 0
    assetTableFields = assetInfo.Properties.VariableNames;
    nFields = numel(assetTableFields);
    assetTableFields{end+1} = 'x';
    assetTableFields{end+1} = 'y';
    assetTableFields{end+1} = 'z';
    assetInfo.XCOORD = num2str(assetInfo.XCOORD);
    assetInfo.YCOORD = num2str(assetInfo.YCOORD);
    assetTableData = table2cell(assetInfo);

    for iAsset = 1:numAssets
        assetTableData{iAsset,nFields+1} = pVehicles(iAsset,1);
        assetTableData{iAsset,nFields+2} = pVehicles(iAsset,2);
        assetTableData{iAsset,nFields+3} = pVehicles(iAsset,3);
    end
    set(handles.assetTable,'Data',assetTableData,'columnname',assetTableFields)

else
    printToLog('No close assets',handles);
end


% --- Executes on button press in LoadCameraParameters.
function LoadCameraParameters_Callback(hObject, eventdata, handles)
% hObject    handle to LoadCameraParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
folder = fullfile(dataDir,road,'Calibration');
cameraParamTable = readtable(fullfile(folder,'camera_parameters.csv'));
cameraParams = table2struct(cameraParamTable);

cameraParamFields = {'alpha','beta','gamma','x0','y0','h','fu','fv','cu','cv','m','n'};
set(handles.cameraParamTable,'Data',table2cell(cameraParamTable)');
set(handles.cameraParamTable,'UserData',cameraParams)


% --- Executes on button press in loadCalibrationData.
function loadCalibrationData_Callback(hObject, eventdata, handles)
% hObject    handle to loadCalibrationData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
calibrationCSV = fullfile(dataDir,'Calibration Data',road,'calibration_data.csv');
calibrationData = readtable(calibrationCSV);
set(handles.observationTable,'Data',table2cell(calibrationData));


% --- Executes during object creation, after setting all properties.
function locationAndHeading_CreateFcn(hObject, eventdata, handles)
% hObject    handle to locationAndHeading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate locationAndHeading


% --- Executes on button press in Ransac.
function Ransac_Callback(hObject, eventdata, handles)
% hObject    handle to Ransac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
observationData = handles.observationTable.Data;
observationFields = handles.observationTable.ColumnName;
observations = cell2table(observationData,'VariableNames',observationFields);
cameraParams = handles.cameraParamTable.UserData;
cameraParamsSolve = ransacCalibrate(observations,cameraParams);
% setting calibration table to found parameters
cameraParamFields = {'alpha','beta','gamma','x0','y0','h','fu','fv','cu','cv','m','n'};
set(handles.cameraParamTable,'Data',cameraParamsSolve','rowname',cameraParamFields,'columnname',{});

cameraParams = table2struct(cell2table(num2cell(cameraParamsSolve),'VariableNames',cameraParamFields));
set(handles.cameraParamTable,'UserData',cameraParams)
