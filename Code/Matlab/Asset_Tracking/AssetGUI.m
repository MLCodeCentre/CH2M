function varargout = AssetGUI(varargin)
% ASSETGUI MATLAB code for AssetGUI.fig
%      ASSETGUI,by itself,creates a new ASSETGUI or raises the existing
%      singleton*.
%
%      H = ASSETGUI returns the handle to a new ASSETGUI or the handle to
%      the existing singleton*.
%
%      ASSETGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSETGUI.M with the given input arguments.
%
%      ASSETGUI('Property','Value',...) creates a new ASSETGUI or raises the
%      existing singleton*.  Starting from the left,property value pairs are
%      applied to the GUI before AssetGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AssetGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE,GUIDATA,GUIHANDLES

% Edit the above text to modify the response to help AssetGUI

% Last Modified by GUIDE v2.5 20-Mar-2019 10:43:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',      mfilename,...
                   'gui_Singleton', gui_Singleton,...
                   'gui_OpeningFcn',@AssetGUI_OpeningFcn,...
                   'gui_OutputFcn', @AssetGUI_OutputFcn,...
                   'gui_LayoutFcn', [] ,...
                   'gui_Callback',  []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State,varargin{:});
else
    gui_mainfcn(gui_State,varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AssetGUI is made visible.
function AssetGUI_OpeningFcn(hObject,eventdata,handles,varargin)
% This function has no output args,see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AssetGUI (see VARARGIN)

% Choose default command line output for AssetGUI
handles.output = hObject;

% initiate all images as blank
axes(handles.axes1);
whiteImage = 255 * ones(2000,2000,'uint8');
imshow(whiteImage);
set(handles.figure1,'toolbar','figure');
% initiate all images as blank
axes(handles.axes2);
whiteImage = 255 * ones(2000,2000,'uint8');
imshow(whiteImage);

% Update handles structure
guidata(hObject,handles);

% UIWAIT makes AssetGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AssetGUI_OutputFcn(hObject,eventdata,handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in selectAssetType.
function selectAssetType_Callback(hObject,eventdata,handles)
% hObject    handle to selectAssetType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectAssetType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectAssetType


% --- Executes during object creation,after setting all properties.
function selectAssetType_CreateFcn(hObject,eventdata,handles)
% hObject    handle to selectAssetType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in setRoad.
function setRoad_Callback(hObject,eventdata,handles)
% hObject    handle to setRoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns setRoad contents as cell array
%        contents{get(hObject,'Value')} returns selected item from setRoad


% --- Executes during object creation,after setting all properties.
function setRoad_CreateFcn(hObject,eventdata,handles)
% hObject    handle to setRoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected cell(s) is changed in assetDataTable.
function assetDataTable_CellSelectionCallback(hObject,eventdata,handles)
% hObject    handle to assetDataTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

% This if statement stops an error thrown when switching tables
if isempty(eventdata.Indices) == 0
    % selecting asset clicked on in table
    asset = cell2table(eventdata.Source.Data(eventdata.Indices(1),:),...
                       'VariableNames',eventdata.Source.ColumnName);
    % if there is any location data
    if any(strcmp('XCOORD',asset.Properties.VariableNames))
        % load nav files, dataDir, road and cameraParams from handles
        navFileYear1 = handles.setRoad.UserData.navData.navFileYear1;
        navFileYear2 = handles.setRoad.UserData.navData.navFileYear2;
        assetType = getAssetType(handles);
        dataDir = handles.setDataDir.UserData;
        road = handles.setRoad.String{handles.setRoad.Value};
        cameraParams = handles.setRoad.UserData.cameraParams;
        % find assets and plot on axes for year 1
        [image1,box1,targetPixels1] = ...
            getAssetImage(asset,navFileYear1,cameraParams('Year1'));
        axes(handles.axes1);
        plotAssetsOnAxes(image1,box1,targetPixels1,assetType,dataDir,road,'Year1',handles)
        % find assets and plot on axes for year 2
        axes(handles.axes2);
        [image2,box2,targetPixels2] = ...
            getAssetImage(asset,navFileYear2,cameraParams('Year2'));
        plotAssetsOnAxes(image2,box2,targetPixels2,assetType,dataDir,road,'Year2',handles)
    else
        printToLog('No location data available',handles)
    end %is XCOORD and YCOORD a field
end % isempty


function OutputLog_Callback(hObject,eventdata,handles)
% hObject    handle to OutputLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputLog as text
%        str2double(get(hObject,'String')) returns contents of OutputLog as a double

% --- Executes during object creation,after setting all properties.


function OutputLog_CreateFcn(hObject,eventdata,handles)
% hObject    handle to OutputLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadAssetData.
function loadAssetData_Callback(hObject,eventdata,handles)
% hObject    handle to loadAssetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% loading asset data from asset type selection.
assetType = getAssetType(handles);
% loading dataDir and road 
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
% searching for asset dbf file
assetDbfFolder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');
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
    % conver back to cell and set UI table
    assetData = table2cell(assetDataTable);
    set(handles.assetDataTable,'Data',assetData,'columnname',fieldNames,'ColumnFormat',{'bank'})
    printToLog(sprintf('%s data loaded successfully',assetType),handles)       
end


% --- If Enable == 'on',executes on mouse press in 5 pixel border.
% --- Otherwise,executes on mouse press in 5 pixel border or over loadAssetData.
function loadAssetData_ButtonDownFcn(hObject,eventdata,handles)
% hObject    handle to loadAssetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on',executes on mouse press in 5 pixel border.
% --- Otherwise,executes on mouse press in 5 pixel border or over loadNavData.
function loadNavData_Callback(hObject,eventdata,handles)
% hObject    handle to loadNavData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load dataDir and the road
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};

try
    % load navFiles
    navFileYear1 = readtable(fullfile(dataDir,road,'Year1','Nav','Nav.csv'));
    navFileYear2 = readtable(fullfile(dataDir,road,'Year2','Nav','Nav.csv'));
    % order nav files by PCDATE then PCTIME.
    navFileYear1 = sortrows(navFileYear1,{'PCDATE','PCTIME'});
    navFileYear2 = sortrows(navFileYear2,{'PCDATE','PCTIME'});
    
    % create a struct so that the road has a nav file and the
    % camera parameters for each year.
    navData = struct('navFileYear1',navFileYear1,'navFileYear2',navFileYear2);
    cameraParams = setCameraParams(dataDir,road);
    roadData = struct('navData',navData,'cameraParams',cameraParams);
    set(handles.setRoad,'UserData',roadData);
    
    printToLog('Navigation file and camera parameter data successfully loaded', handles)
    
catch e %e is an MException struct
    printToLog(e.message,handles)
end


% --- Executes on key press with focus on loadNavData and none of its controls.
function loadNavData_KeyPressFcn(hObject,eventdata,handles)
% hObject    handle to loadNavData (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed,in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e.,control,shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function assetDataTable_ButtonDownFcn(hObject,eventdata,handles)
% hObject    handle to assetDataTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function assetDataTable_KeyPressFcn(hObject,eventdata,handles)
% hObject    handle to assetDataTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in setDataDir.
function setDataDir_Callback(hObject,eventdata,handles)
% hObject    handle to setDataDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = uigetdir;
set(handles.setDataDir,'UserData',dataDir);
printToLog(sprintf('Data directory set to %s',dataDir),handles)

% --- Executes during object creation,after setting all properties.
function year1File_CreateFcn(hObject,eventdata,handles)
% hObject    handle to year1File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation,after setting all properties.
function year2File_CreateFcn(hObject,eventdata,handles)
% hObject    handle to year2File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation,after setting all properties.
function axes1_CreateFcn(hObject,eventdata,handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject,eventdata,handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes1Image_ButtonDownFcn(hObject,eventdata,handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get click event data
cameraParams = handles.setRoad.UserData.cameraParams;
pixelClick = eventdata.IntersectionPoint;
u = pixelClick(1); v = pixelClick(2);

% try to look for an asset close to that click and catch error
try
    % load selected assets and image from handles and find closest asset
    assets = handles.assetSearchTypeSelection.UserData;
    image = handles.year1File.UserData;
    [closestAsset,assetPixels,assetBox] = ...
        findClosestAsset(assets,image,u,v,cameraParams('Year1'));
    % reformat XCOORD nad YCOORD to a string and convert to table
    closestAsset.XCOORD = sprintfc('%9.3f',closestAsset.XCOORD);
    closestAsset.YCOORD = sprintfc('%9.3f',closestAsset.YCOORD);
    closestAssetData = table2cell(closestAsset);
    % extract field names for table headers.
    fieldNames = closestAsset.Properties.VariableNames;
    % display table
    set(handles.clickedAssetDataTable,'Data',closestAssetData','rowname',fieldNames,'columnname',{})
    assetType = getAssetSearchType(handles);
    
    % plot box and pixels over image
    % plot box and pixels over image
    if isempty(closestAsset)
        printToLog(sprintf('No %s found',assetType),handles)
    else
        axes(handles.axes1);
        plotPixelsAndBox(assetPixels,assetBox,assetType)
    end
    
catch e %e is an MException struct
    printToLog(e.message,handles)
end


% --- Executes on mouse press over axes background.
function axes2Image_ButtonDownFcn(hObject,eventdata,handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get click event data
cameraParams = handles.setRoad.UserData.cameraParams;
pixelClick = eventdata.IntersectionPoint;
u = pixelClick(1); v = pixelClick(2);

% try to look for an asset close to that click and catch error
try
    % load selected assets and image from handles and find closest asset
    assets = handles.assetSearchTypeSelection.UserData;
    image = handles.year2File.UserData;
    [closestAsset,assetPixels,assetBox] = ...
        findClosestAsset(assets,image,u,v,cameraParams('Year2'));
    % reformat XCOORD nad YCOORD to a string and convert to table
    closestAsset.XCOORD = sprintfc('%9.3f',closestAsset.XCOORD);
    closestAsset.YCOORD = sprintfc('%9.3f',closestAsset.YCOORD);
    closestAssetData = table2cell(closestAsset);
    % extract field names for table headers.
    fieldNames = closestAsset.Properties.VariableNames;
    % display table
    set(handles.clickedAssetDataTable,'Data',closestAssetData','rowname',fieldNames,'columnname',{})
    assetType = getAssetSearchType(handles);
        
    % plot box and pixels over image
    if isempty(closestAsset)
        printToLog(sprintf('No %s found',assetType),handles)
    else
        axes(handles.axes2);
        plotPixelsAndBox(assetPixels,assetBox,assetType)
    end
catch e %e is an MException struct
    printToLog(e.message,handles)
end


% --- Executes on selection change in assetSearchTypeSelection.
function assetSearchTypeSelection_Callback(hObject,eventdata,handles)
% hObject    handle to assetSearchTypeSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get ssset search type from the drop down 
AssetSearchSelection = handles.assetSearchTypeSelection.String{...
    handles.assetSearchTypeSelection.Value};
AssetSearchTypeInfo = strsplit(AssetSearchSelection,' ');
AssetSearchType = AssetSearchTypeInfo{1};

% load dataDir, road and search for asset dbf file.
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
assetDbfFolder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');
assetDbfFile = dir(fullfile(assetDbfFolder,['*',AssetSearchType,'*.dbf']));

% check if asset dbf file exists
if isempty(assetDbfFile)
    printToLog(sprintf('No %s data',AssetSearchType),handles)
else
    % load asset dbf file and add to user data to be used later
    [assetData,fieldNames] = dbfRead(fullfile(assetDbfFolder,assetDbfFile.name));
    if any(strcmp('XCOORD',fieldNames))
        assetDataTable = cell2table(assetData,'VariableNames',fieldNames);
        set(handles.assetSearchTypeSelection,'UserData',assetDataTable);
        printToLog(sprintf('%s data loaded successfully',AssetSearchType),handles)
    else
        printToLog('No location data available',handles)
    end
end


% --- Executes during object creation,after setting all properties.
function assetSearchTypeSelection_CreateFcn(hObject,eventdata,handles)
% hObject    handle to assetSearchTypeSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showAllAssets.
function showAllAssets_Callback(hObject,eventdata,handles)
% hObject    handle to showAllAssets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = handles.year1File.UserData;
image2 = handles.year2File.UserData;

dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
assetTypes = handles.selectAssetType.String;
cameraParams = handles.setRoad.UserData.cameraParams;

% find all assets in year 1 image if loaded
if isempty(image1) == 0
    [assetsImage1,assetTypesImage1] = ...
        findAllAssets(image1,assetTypes,dataDir,road,cameraParams('Year1'));
    % plot all of those assets
    axes(handles.axes1);
    set(handles.axes1,'NextPlot','add')
    plotAllAssets(assetsImage1,assetTypesImage1,false)
end

% find all asset in year 2 image if loaded
if isempty(image1) == 0
[assetsImage2,assetTypesImage2] = ...
    findAllAssets(image2,assetTypes,dataDir,road,cameraParams('Year2'));
% plot all of those assets
axes(handles.axes2);
set(handles.axes2,'NextPlot','add')
plotAllAssets(assetsImage2,assetTypesImage2,false)
end


% --- Executes on button press in showAssets.
function showAssets_Callback(hObject,eventdata,handles)
% hObject    handle to showAssets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% shows assets of a selected type
image1 = handles.year1File.UserData;
image2 = handles.year2File.UserData;

% load asset search type
assetSearchType = getAssetSearchType(handles);
% load camera params and asset data (this has already been loaded)
cameraParams = handles.setRoad.UserData.cameraParams;
assetData = handles.assetSearchTypeSelection.UserData;

% find assets in image 1 if an image is loaded
if isempty(image1) == 0
    assetsImage1 = findAssetsInImage(assetData,image1,cameraParams('Year1'));
    % all assets are same type
    assetTypesImage1 = char(ones(size(assetsImage1,1),1) * assetSearchType);
    % plot with boxes
    axes(handles.axes1);
    set(handles.axes1,'NextPlot','add')
    plotAllAssets(assetsImage1,assetTypesImage1,true)
end

% find asset in image 2 if image is loaded
if isempty(image2) == 0
    assetsImage2 = findAssetsInImage(assetData,image2,cameraParams('Year2'));
    % all assets are same type
    assetTypesImage2 = char(ones(size(assetsImage2,1),1) * assetSearchType);
    % plot with boxes
    axes(handles.axes2);
    set(handles.axes2,'NextPlot','add')
    plotAllAssets(assetsImage2,assetTypesImage2,true)
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over loadnavdata.
function loadNavData_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to loadnavdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in prevYear1.
function prevYear1_Callback(hObject, eventdata, handles)
% hObject    handle to prevYear1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
navFile = handles.setRoad.UserData.navData.navFileYear1;
[camera,PCDATE,PCTIME] = parseImageFileName(handles.year1File.String);
rowInd = find((navFile.PCDATE==PCDATE & navFile.PCTIME==PCTIME));
prevImage = navFile(rowInd-1,:);
prevImage.fileName{1} = constructFileName(camera,prevImage.PCDATE,prevImage.PCTIME);

% load dataDir and road for the plot
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
plotAssetsOnAxes(prevImage,[],[],[],dataDir,road,'Year1',handles)


% --- Executes on button press in nextYear1.
function nextYear1_Callback(hObject, eventdata, handles)
% hObject    handle to nextYear1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
navFile = handles.setRoad.UserData.navData.navFileYear1;
[camera,PCDATE,PCTIME] = parseImageFileName(handles.year1File.String);
rowInd = find((navFile.PCDATE==PCDATE & navFile.PCTIME==PCTIME));
nextImage = navFile(rowInd+1,:);
nextImage.fileName{1} = constructFileName(camera,nextImage.PCDATE,nextImage.PCTIME);

% load dataDir and road for the plot
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
plotAssetsOnAxes(nextImage,[],[],[],dataDir,road,'Year1',handles)


% --- Executes on button press in prevYear2.
function prevYear2_Callback(hObject, eventdata, handles)
% hObject    handle to prevYear2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
navFile = handles.setRoad.UserData.navData.navFileYear2;
[camera,PCDATE,PCTIME] = parseImageFileName(handles.year2File.String);
rowInd = find((navFile.PCDATE==PCDATE & navFile.PCTIME==PCTIME));
prevImage = navFile(rowInd-1,:);

prevImage.fileName{1} = constructFileName(camera,prevImage.PCDATE,prevImage.PCTIME);

% load dataDir and road for the plot
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
plotAssetsOnAxes(prevImage,[],[],[],dataDir,road,'Year2',handles)


% --- Executes on button press in nextYear2.
function nextYear2_Callback(hObject, eventdata, handles)
% hObject    handle to nextYear2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
navFile = handles.setRoad.UserData.navData.navFileYear2;
[camera,PCDATE,PCTIME] = parseImageFileName(handles.year2File.String);
rowInd = find((navFile.PCDATE==PCDATE & navFile.PCTIME==PCTIME));
nextImage = navFile(rowInd+1,:);
nextImage.fileName{1} = constructFileName(camera,nextImage.PCDATE,nextImage.PCTIME);

% load dataDir and road for the plot
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
plotAssetsOnAxes(nextImage,[],[],[],dataDir,road,'Year2',handles)


% --- Executes on button press in loadYear1.
function loadYear1_Callback(hObject, eventdata, handles)
% hObject    handle to loadYear1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% loading dataDir and road for folder search
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
imageFile = uigetfile(fullfile(dataDir,road,'Year1','Images','*.jpg'),'Select an image');
% parse image information and find navFile entry
[camera,PCDATE,PCTIME] = parseImageFileName(imageFile);
navFile = handles.setRoad.UserData.navData.navFileYear1;
image = navFile((navFile.PCDATE==PCDATE & navFile.PCTIME==PCTIME),:);
% add the file name and plot on axis. 
image.fileName{1} = imageFile;
plotAssetsOnAxes(image,[],[],[],dataDir,road,'Year1',handles)


% --- Executes on button press in loadYear2.
function loadYear2_Callback(hObject, eventdata, handles)
% hObject    handle to loadYear2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% loading dataDir and road for folder search
dataDir = handles.setDataDir.UserData;
road = handles.setRoad.String{handles.setRoad.Value};
imageFile = uigetfile(fullfile(dataDir,road,'Year2','Images','*.jpg'),'Select an image');
% parse image information and find navFile entry
[camera,PCDATE,PCTIME] = parseImageFileName(imageFile);
navFile = handles.setRoad.UserData.navData.navFileYear2;
image = navFile((navFile.PCDATE==PCDATE & navFile.PCTIME==PCTIME),:);
% add the file name and plot on axis. 
image.fileName{1} = imageFile;
plotAssetsOnAxes(image,[],[],[],dataDir,road,'Year2',handles)


%-----------custom functions-----------%

% plots box and pixels over an image
function plotPixelsAndBox(assetPixels,assetBox,assetType)
hold all
rectangle('Position',assetBox,...
    'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
plot(assetPixels(1),assetPixels(2),'g+')
text(assetPixels(1),assetPixels(2),assetType,'color','m')


% plots all assets found on an image
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


% prints to output log
function printToLog(message,handles)
oldmsgs = cellstr(get(handles.OutputLog,'String'));
set(handles.OutputLog,'String',[{message};oldmsgs] )


% parses assetSearchType info from selectAssetSearchType
function assetSearchType = getAssetSearchType(handles)
assetSearchType = handles.assetSearchTypeSelection.String{...
handles.assetSearchTypeSelection.Value};
assetSearchTypeInfo = strsplit(assetSearchType,' ');
assetSearchType = assetSearchTypeInfo{1};


% parses assetType info from selectAssetType
function assetType = getAssetType(handles)
assetType = handles.selectAssetType.String{handles.selectAssetType.Value};
assetTypeInfo = strsplit(assetType,' ');
assetType = assetTypeInfo{1};


% plots asset, target box and pixels on image
function plotAssetsOnAxes(image,box,targetPixels,assetType,dataDir,road,year,handles)
% check if there is an image to plot and if not leave axes white
if isempty(image)
    printToLog(sprintf('No image available for %s',year),handles)
    whiteImage = 255 * ones(2000,2000,'uint8');
    imshow(whiteImage);
    set(handles.year1File,'String',' ')
else
    % load image and file_name
    img = imread(fullfile(dataDir,road,year,'Images',image.fileName{1}));
    imgFile = image.fileName{1};
    hold off;
    % load correct image handle, button down function and user data for the year
    if strcmpi(year,'Year1')
        h = imshow(img,'Parent',handles.axes1,'InitialMagnification','fit');
        set(h,'ButtonDownFcn',{@axes1Image_ButtonDownFcn,handles});
        set(handles.year1File,'String',imgFile)
        set(handles.year1File,'UserData',image);
    else
        h = imshow(img,'Parent',handles.axes2,'InitialMagnification','fit');
        set(h,'ButtonDownFcn',{@axes2Image_ButtonDownFcn,handles});
        set(handles.year2File,'String',imgFile)
        set(handles.year2File,'UserData',image);
    end
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

