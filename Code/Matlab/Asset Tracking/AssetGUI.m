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

% Last Modified by GUIDE v2.5 07-Mar-2019 12:27:46

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


% --- Executes on selection change in Asset_type.
function Asset_type_Callback(hObject,eventdata,handles)
% hObject    handle to Asset_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Asset_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Asset_type




% --- Executes during object creation,after setting all properties.
function Asset_type_CreateFcn(hObject,eventdata,handles)
% hObject    handle to Asset_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Road.
function Road_Callback(hObject,eventdata,handles)
% hObject    handle to Road (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Road contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Road



% --- Executes during object creation,after setting all properties.
function Road_CreateFcn(hObject,eventdata,handles)
% hObject    handle to Road (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject,eventdata,handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.Indices) == 0 % There was an error thrown when switching tables
    asset = cell2table(eventdata.Source.Data(eventdata.Indices(1),:),...
                       'VariableNames',eventdata.Source.ColumnName);
   
    if any(strcmp('XCOORD',asset.Properties.VariableNames)) % check for geo data               
        %% This is where I will create the images with bounding boxes. 
        navFileYear1 = handles.Road.UserData.navData.navFileYear1;
        navFileYear2 = handles.Road.UserData.navData.navFileYear2;

        assetType = handles.AssetType.String{handles.AssetType.Value};
        assetTypeInfo = strsplit(assetType,' ');
        assetType = assetTypeInfo(1);
        
        dataDir = handles.setDataDir.UserData;
        road = handles.Road.String{handles.Road.Value};
        cameraParams = handles.Road.UserData.cameraParams;
        % year 1
        [image1,box1,targetPixels1] = ...
            getAssetImage(asset,'Year1',road,navFileYear1,dataDir,cameraParams);
        
        axes(handles.axes1);
        if isempty(image1)
            oldmsgs = cellstr(get(handles.OutputLog,'String'));
            set(handles.OutputLog,'String',[{'No image available for Year 1'};oldmsgs] )
            whiteImage = 255 * ones(2000,2000,'uint8');
            imshow(whiteImage);
            set(handles.Year1File,'String',' ')
        else
            img1 = imread(fullfile(dataDir,road,'Year1','Images',image1.File_Name{1}));
            imgFile1 = image1.File_Name{1};
            hold off;
            h1 = imshow(img1,'Parent',handles.axes1,'InitialMagnification','fit');
            set(h1,'ButtonDownFcn',{@axes1Image_ButtonDownFcn,handles});
            hold on
            rectangle('Position',box1,...
                'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
            plot(targetPixels1(1),targetPixels1(2),'g+')
            text(targetPixels1(1),targetPixels1(2),assetType,'color','m')
            set(handles.Year1File,'String',imgFile1)
            set(handles.Year1File,'UserData',image1);
            hold off
        end

        % year 2
        [image2,box2,targetPixels2] = ...
            getAssetImage(asset,'Year2',road,navFileYear2,dataDir,cameraParams);
        axes(handles.axes2);
        if isempty(image2)
            oldmsgs = cellstr(get(handles.OutputLog,'String'));
            set(handles.OutputLog,'String',[{'No image available for Year 2'};oldmsgs] )
            whiteImage = 255 * ones(2000,2000,'uint8');
            imshow(whiteImage);
            set(handles.Year2File,'String',' ');
        else           
            img2 = imread(fullfile(dataDir,road,'Year2','Images',image2.File_Name{1}));
            imgFile2 = image2.File_Name{1};
            hold off;  % IMPORTANT NOTE: hold needs to be off in order for the "fit" feature to work correctly.
            h2 = imshow(img2,'Parent',handles.axes2,'InitialMagnification','fit');
            set(h2,'ButtonDownFcn',{@axes2Image_ButtonDownFcn,handles});
            hold on
            rectangle('Position',box2,...
                'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
            plot(targetPixels2(1),targetPixels2(2),'g+')
            text(targetPixels2(1),targetPixels2(2),assetType,'color','m')
            set(handles.Year2File,'String',imgFile2);
            set(handles.Year2File,'UserData',image2);
            hold off
        end
    else
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[{'No location data available'};oldmsgs] )
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


% --- Executes on button press in LoadAssetData.
function LoadAssetData_Callback(hObject,eventdata,handles)
% hObject    handle to LoadAssetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AssetSelection = handles.AssetType.String{handles.Asset_type.Value};
AssetTypeInfo = strsplit(AssetSelection,' ');
AssetType = AssetTypeInfo{1};

dataDir = handles.setDataDir.UserData;
road = handles.Road.String{handles.Road.Value};
assetDbfFolder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');
assetDbfFile = dir(fullfile(assetDbfFolder,['*',AssetType,'*.dbf']));

if isempty(assetDbfFile)
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    set(handles.OutputLog,'String',[strcat(['No ',AssetType,' data']);oldmsgs] )
else
    [assetData,fieldNames] = dbfRead(fullfile(assetDbfFolder,assetDbfFile.name));
    assetDataTable = cell2table(assetData,'VariableNames',fieldNames);
    if any(strcmp(fieldNames,'XCOORD'))
        assetDataTable = orderTable(assetDataTable);
    end
    assetData = table2cell(assetDataTable);
    set(handles.uitable1,'Data',assetData,'columnname',fieldNames,'ColumnFormat',{'bank'})
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    set(handles.OutputLog,'String',[strcat([AssetType,' data loaded successfully']);oldmsgs] )       
end

% --- If Enable == 'on',executes on mouse press in 5 pixel border.
% --- Otherwise,executes on mouse press in 5 pixel border or over LoadAssetData.
function LoadAssetData_ButtonDownFcn(hObject,eventdata,handles)
% hObject    handle to LoadAssetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on',executes on mouse press in 5 pixel border.
% --- Otherwise,executes on mouse press in 5 pixel border or over LoadNavData.
function LoadNavData_Callback(hObject,eventdata,handles)
% hObject    handle to LoadNavData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = handles.setDataDir.UserData;
road = handles.Road.String{handles.Road.Value};

try
    navFileYear1 = readtable(fullfile(dataDir,road,'Year1','Nav','Nav.csv'));
    navFileYear2 = readtable(fullfile(dataDir,road,'Year2','Nav','Nav.csv'));

    navData = struct('navFileYear1',navFileYear1,'navFileYear2',navFileYear2);
    cameraParams = setCameraParams(dataDir,road);
    roadData = struct('navData',navData,'cameraParams',cameraParams);
    set(handles.Road,'UserData',roadData);
    
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    message = 'Navigation file and camera parameter data successfully loaded';
    set(handles.OutputLog,'String',[message;oldmsgs])
catch e %e is an MException struct
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    message = e.message;
    set(handles.OutputLog,'String',[message;oldmsgs])
end


% --- Executes on key press with focus on LoadNavData and none of its controls.
function LoadNavData_KeyPressFcn(hObject,eventdata,handles)
% hObject    handle to LoadNavData (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed,in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e.,control,shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitable1_ButtonDownFcn(hObject,eventdata,handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function uitable1_KeyPressFcn(hObject,eventdata,handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in setDataDir.
function setDataDir_Callback(hObject,eventdata,handles)
% hObject    handle to setDataDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = uigetdir;
set(handles.setDataDir,'UserData',dataDir);
oldmsgs = cellstr(get(handles.OutputLog,'String'));
set(handles.OutputLog,'String',[sprintf('Data directory set to %s',dataDir);oldmsgs] )


% --- Executes during object creation,after setting all properties.
function Year1File_CreateFcn(hObject,eventdata,handles)
% hObject    handle to Year1File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation,after setting all properties.
function Year2File_CreateFcn(hObject,eventdata,handles)
% hObject    handle to Year2File (see GCBO)
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
cameraParams = handles.Road.UserData.cameraParams;
pixelClick = eventdata.IntersectionPoint;
u = pixelClick(1); v = pixelClick(2);

try
    assets = handles.assetSearchTypeSelection.UserData;
    image = handles.Year1File.UserData;
    [closestAsset,uAsset,vAsset,box] = ...
        findClosestAsset(assets,image,u,v,cameraParams,'Year1');
    field_names = closestAsset.Properties.VariableNames;

    closestAsset.XCOORD = sprintfc('%9.3f',closestAsset.XCOORD);
    closestAsset.YCOORD = sprintfc('%9.3f',closestAsset.YCOORD);
    closestAssetData = table2cell(closestAsset);

    set(handles.clickOnAssetResult,'Data',closestAssetData','rowname',field_names,'columnname',{})
    asset_type = handles.assetSearchTypeSelection.String{...
        handles.assetSearchTypeSelection.Value};

    if isempty(closestAsset)
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[sprintf('No %s found',asset_type);oldmsgs] )
    else
        axes(handles.axes1);
        hold all
        rectangle('Position',box,...
            'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
        plot(uAsset,vAsset,'g+')
        asset_type_info = strsplit(asset_type,' ');
        text(uAsset,vAsset,asset_type_info(1),'color','m')
    end
catch e %e is an MException struct
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    message = e.message;
    set(handles.OutputLog,'String',[message;oldmsgs])
end


% --- Executes on mouse press over axes background.
function axes2Image_ButtonDownFcn(hObject,eventdata,handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cameraParams = handles.Road.UserData.cameraParams;
pixelClick = eventdata.IntersectionPoint;
u = pixelClick(1); v = pixelClick(2);

try
    assets = handles.assetSearchTypeSelection.UserData;
    image = handles.Year2File.UserData;
    [closestAsset,uAsset,vAsset,box] = ...
        findClosestAsset(assets,image,u,v,cameraParams,'Year2');
    fieldNames = closestAsset.Properties.VariableNames;
    closestAssetData = table2cell(closestAsset);
    set(handles.clickOnAssetResult,'Data',closestAssetData',...
        'rowname',fieldNames,'columnname',{})
    assetType = handles.assetSearchTypeSelection.String{...
        handles.assetSearchTypeSelection.Value};

    if isempty(closestAsset)
        assetType = handles.assetSearchTypeSelection.String{...
            handles.assetSearchTypeSelection.Value};
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[sprintf('No %s found',assetType);oldmsgs] )
    else
        axes(handles.axes2);
        hold all
        rectangle('Position',box,...
            'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
        plot(uAsset,vAsset,'g+')
        asset_type_info = strsplit(assetType,' ');
        text(uAsset,vAsset,asset_type_info(1),'color','m')
    end
catch e %e is an MException struct
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    message = e.message;
    set(handles.OutputLog,'String',[message;oldmsgs])
end

% --- Executes on selection change in assetSearchTypeSelection.
function assetSearchTypeSelection_Callback(hObject,eventdata,handles)
% hObject    handle to assetSearchTypeSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns assetSearchTypeSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from assetSearchTypeSelection
AssetSearchSelection = handles.assetSearchTypeSelection.String{handles.assetSearchTypeSelection.Value};
AssetSearchTypeInfo = strsplit(AssetSearchSelection,' ');
AssetSearchType = AssetSearchTypeInfo{1};

dataDir = handles.setDataDir.UserData;
road = handles.Road.String{handles.Road.Value};
asset_dbf_folder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');
asset_dbf_file = dir(fullfile(asset_dbf_folder,['*',AssetSearchType,'*.dbf']));

if isempty(asset_dbf_file)
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    set(handles.OutputLog,'String',[strcat(['No ',AssetSearchType,' data']);oldmsgs] )
else
    [assetData,fieldNames] = dbfRead(fullfile(asset_dbf_folder,asset_dbf_file.name));
    if any(strcmp('XCOORD',fieldNames))
        asset_data_table = cell2table(assetData,'VariableNames',fieldNames);
        set(handles.assetSearchTypeSelection,'UserData',asset_data_table);
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[strcat([AssetSearchType,' data loaded successfully']);oldmsgs] )
    else
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[{'No location data available'};oldmsgs] )
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


% --- Executes on button press in ShowAllAssets.
function ShowAllAssets_Callback(hObject,eventdata,handles)
% hObject    handle to ShowAllAssets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = handles.Year1File.UserData;
image2 = handles.Year2File.UserData;

dataDir = handles.setDataDir.UserData;
road = handles.Road.String{handles.Road.Value};
asseTypes = handles.AssetType.String;
cameraParams = handles.Road.UserData.cameraParams;

[assetsImage1,assetTypesImage1,assetsImage2,assetTypesImage2] = ...
    findAllAssets(image1,image2,asseTypes,dataDir,road,cameraParams);

axes(handles.axes1);

hold on
nAssets1 = size(assetsImage1,1);
for iAsset = 1:nAssets1
    uAsset = assetsImage1(iAsset,1);
    vAsset = assetsImage1(iAsset,2);
    box = assetsImage1(iAsset,3:6);
%     rectangle('Position',box,'LineWidth',1,'LineStyle','-',...
%               'EdgeColor','r','Curvature',0);
    plot(uAsset,vAsset,'g+')
    text(uAsset,vAsset,assetTypesImage1(iAsset,:),'color','m')
end
hold off 

axes(handles.axes2);
set(handles.axes2,'NextPlot','add')

nAssets2 = size(assetsImage2,1);
hold on
for iAsset = 1:nAssets2
    uAsset = assetsImage2(iAsset,1);
    vAsset = assetsImage2(iAsset,2);
    box = assetsImage2(iAsset,3:6);

%     rectangle('Position',box,'LineWidth',1,'LineStyle','-',...
%               'EdgeColor','r','Curvature',0);
    plot(uAsset,vAsset,'g+')
    text(uAsset,vAsset,assetTypesImage2(iAsset,:),...
        'color','m')
end
hold off

oldmsgs = cellstr(get(handles.OutputLog,'String'));
message = sprintf('Found %d assets in year 1 and %d in year 2',numAssets1,nAssets2);
set(handles.OutputLog,'String',[{message};oldmsgs] )


% --- Executes on button press in showAssets.
function showAssets_Callback(hObject,eventdata,handles)
% hObject    handle to showAssets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = handles.Year1File.UserData;
image2 = handles.Year2File.UserData;

assetType = handles.assetSearchTypeSelection.String{...
    handles.assetSearchTypeSelection.Value};
assetTypeInfo = strsplit(assetType,' ');
assetType = assetTypeInfo(1);
cameraParams = handles.Road.UserData.cameraParams;
assetData = handles.assetSearchTypeSelection.UserData;

[assetsImage1,assetsImage2] = ...
    findAllAssetsOfType(image1,image2,assetData,cameraParams);
axes(handles.axes1);

hold on
nAssets1 = size(assetsImage1,1);
for iAsset = 1:nAssets1
    uAsset = assetsImage1(iAsset,1);
    vAsset = assetsImage1(iAsset,2);
    box = assetsImage1(iAsset,3:6);
    rectangle('Position',box,'LineWidth',1,'LineStyle','-',...
              'EdgeColor','r','Curvature',0);
    plot(uAsset,vAsset,'g+')
    text(uAsset,vAsset,assetType,'color','m')
end
hold off 

axes(handles.axes2);
set(handles.axes2,'NextPlot','add')

numAssets2 = size(assetsImage2,1);
hold on
for iAsset = 1:numAssets2
    uAsset = assetsImage2(iAsset,1);
    vAsset = assetsImage2(iAsset,2);
    box = assetsImage2(iAsset,3:6);

    rectangle('Position',box,'LineWidth',1,'LineStyle','-',...
              'EdgeColor','r','Curvature',0);
    plot(uAsset,vAsset,'g+')
    text(uAsset,vAsset,assetType,'color','m')
end
hold off
