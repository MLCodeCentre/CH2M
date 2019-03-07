function varargout = AssetGUI(varargin)
% ASSETGUI MATLAB code for AssetGUI.fig
%      ASSETGUI, by itself, creates a new ASSETGUI or raises the existing
%      singleton*.
%
%      H = ASSETGUI returns the handle to a new ASSETGUI or the handle to
%      the existing singleton*.
%
%      ASSETGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSETGUI.M with the given input arguments.
%
%      ASSETGUI('Property','Value',...) creates a new ASSETGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AssetGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AssetGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AssetGUI

% Last Modified by GUIDE v2.5 07-Mar-2019 12:27:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AssetGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AssetGUI_OutputFcn, ...
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


% --- Executes just before AssetGUI is made visible.
function AssetGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AssetGUI (see VARARGIN)

% Choose default command line output for AssetGUI
handles.output = hObject;

% initiate all images as blank
axes(handles.axes1);
whiteImage = 255 * ones(2000, 2000, 'uint8');
imshow(whiteImage);
set(handles.figure1,'toolbar','figure');
% initiate all images as blank
axes(handles.axes2);
whiteImage = 255 * ones(2000, 2000, 'uint8');
imshow(whiteImage);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AssetGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AssetGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Asset_type.
function Asset_type_Callback(hObject, eventdata, handles)
% hObject    handle to Asset_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Asset_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Asset_type




% --- Executes during object creation, after setting all properties.
function Asset_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Asset_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Road.
function Road_Callback(hObject, eventdata, handles)
% hObject    handle to Road (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Road contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Road



% --- Executes during object creation, after setting all properties.
function Road_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Road (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if isempty(eventdata.Indices) == 0 % There was an error thrown when switching tables
    asset = cell2table(eventdata.Source.Data(eventdata.Indices(1),:),...
                       'VariableNames',eventdata.Source.ColumnName);
   
    if any(strcmp('XCOORD',asset.Properties.VariableNames)) % check for geo data               
        %% This is where I will create the images with bounding boxes. 
        nav_file_year1 = handles.Road.UserData.nav_data.nav_file_year1;
        nav_file_year2 = handles.Road.UserData.nav_data.nav_file_year2;

        asset_type = handles.Asset_type.String{handles.Asset_type.Value};
        asset_type_info = strsplit(asset_type,' ');
        asset_type = asset_type_info(1);
        
        dataDir = handles.setDataDir.UserData;
        road = handles.Road.String{handles.Road.Value};
        camera_params = handles.Road.UserData.camera_params;
        % year 1
        [image1, box1, target_pixels1] = getAssetImage(asset,'Year1',road,nav_file_year1,dataDir,camera_params);
        axes(handles.axes1);
        if isempty(image1)
            oldmsgs = cellstr(get(handles.OutputLog,'String'));
            set(handles.OutputLog,'String',[{'No image available for Year 1'};oldmsgs] )
            whiteImage = 255 * ones(2000, 2000, 'uint8');
            imshow(whiteImage);
            set(handles.Year1File,'String',' ')
        else
            img1 = imread(fullfile(dataDir,road,'Year1','Images',image1.File_Name{1}));
            img_file1 = image1.File_Name{1};
            hold off;  % IMPORTANT NOTE: hold needs to be off in order for the "fit" feature to work correctly.
            h1 = imshow(img1, 'Parent', handles.axes1, 'InitialMagnification', 'fit');
            set(h1, 'ButtonDownFcn', {@axes1Image_ButtonDownFcn,handles});
            hold on
            rectangle('Position',box1,'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
            plot(target_pixels1(1), target_pixels1(2), 'g+')
            text(target_pixels1(1), target_pixels1(2), asset_type, 'color', 'm')
            set(handles.Year1File,'String',img_file1)
            set(handles.Year1File,'UserData',image1);
            hold off
        end

        % year 2
        [image2, box2, target_pixels2] = getAssetImage(asset,'Year2',road,nav_file_year2,dataDir,camera_params);
        axes(handles.axes2);
        if isempty(image2)
            oldmsgs = cellstr(get(handles.OutputLog,'String'));
            set(handles.OutputLog,'String',[{'No image available for Year 2'};oldmsgs] )
            whiteImage = 255 * ones(2000, 2000, 'uint8');
            imshow(whiteImage);
            set(handles.Year2File,'String',' ');
        else           
            img2 = imread(fullfile(dataDir,road,'Year2','Images',image2.File_Name{1}));
            img_file2 = image2.File_Name{1};
            hold off;  % IMPORTANT NOTE: hold needs to be off in order for the "fit" feature to work correctly.
            h2 = imshow(img2, 'Parent', handles.axes2, 'InitialMagnification', 'fit');
            set(h2, 'ButtonDownFcn', {@axes2Image_ButtonDownFcn, handles});
            hold on
            rectangle('Position',box2,'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
            plot(target_pixels2(1), target_pixels2(2), 'g+')
            text(target_pixels2(1), target_pixels2(2), asset_type, 'color', 'm')
            set(handles.Year2File,'String',img_file2);
            set(handles.Year2File,'UserData',image2);
            hold off
        end
    else
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[{'No location data available'};oldmsgs] )
    end %is XCOORD and YCOORD a field
end % isempty

function OutputLog_Callback(hObject, eventdata, handles)
% hObject    handle to OutputLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputLog as text
%        str2double(get(hObject,'String')) returns contents of OutputLog as a double

% --- Executes during object creation, after setting all properties.
function OutputLog_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadAssetData.
function LoadAssetData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadAssetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Asset_selection = handles.Asset_type.String{handles.Asset_type.Value};
Asset_type_info = strsplit(Asset_selection,' ');
Asset_type = Asset_type_info{1};

dataDir = handles.setDataDir.UserData;
road = handles.Road.String{handles.Road.Value};
asset_dbf_folder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');
asset_dbf_file = dir(fullfile(asset_dbf_folder,['*',Asset_type,'*.dbf']));

if isempty(asset_dbf_file)
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    set(handles.OutputLog,'String',[strcat(['No ',Asset_type,' data']);oldmsgs] )
else
    [asset_data, field_names] = dbfRead(fullfile(asset_dbf_folder,asset_dbf_file.name));
    asset_data_table = cell2table(asset_data,'VariableNames',field_names);
    if any(strcmp(field_names,'XCOORD'))
        asset_data_table = orderTable(asset_data_table);
    end
    asset_data = table2cell(asset_data_table);
    set(handles.uitable1,'Data',asset_data,'columnname',field_names,'ColumnFormat',{'bank'})
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    set(handles.OutputLog,'String',[strcat([Asset_type,' data loaded successfully']);oldmsgs] )       
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over LoadAssetData.
function LoadAssetData_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to LoadAssetData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over LoadNavData.
function LoadNavData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadNavData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = handles.setDataDir.UserData;
road = handles.Road.String{handles.Road.Value};

try
    nav_file_year1 = readtable(fullfile(dataDir,road,'Year1','Nav','Nav.csv'));
    nav_file_year2 = readtable(fullfile(dataDir,road,'Year2','Nav','Nav.csv'));

    nav_data = struct('nav_file_year1',nav_file_year1,'nav_file_year2',nav_file_year2);
    camera_params = setCameraParams(dataDir,road);
    roadData = struct('nav_data',nav_data,'camera_params',camera_params);
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
function LoadNavData_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to LoadNavData (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uitable1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function uitable1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in setDataDir.
function setDataDir_Callback(hObject, eventdata, handles)
% hObject    handle to setDataDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataDir = uigetdir;
set(handles.setDataDir,'UserData',dataDir);
oldmsgs = cellstr(get(handles.OutputLog,'String'));
set(handles.OutputLog,'String',[sprintf('Data directory set to %s',dataDir);oldmsgs] )


% --- Executes during object creation, after setting all properties.
function Year1File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Year1File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function Year2File_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Year2File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes1Image_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cameraParams = handles.Road.UserData.camera_params;
pixel_click = eventdata.IntersectionPoint;
u = pixel_click(1); v = pixel_click(2);

try
    assets = handles.assetSearchTypeSelection.UserData;
    image = handles.Year1File.UserData;
    [closest_asset, u_asset, v_asset, box] = findClosestAsset(assets,image,u,v,cameraParams,'Year1');
    field_names = closest_asset.Properties.VariableNames;

    closest_asset.XCOORD = sprintfc('%9.3f', closest_asset.XCOORD);
    closest_asset.YCOORD = sprintfc('%9.3f', closest_asset.YCOORD);
    closest_asset_data = table2cell(closest_asset);

    set(handles.clickOnAssetResult,'Data',closest_asset_data','rowname',field_names,'columnname',{})
    asset_type = handles.assetSearchTypeSelection.String{handles.assetSearchTypeSelection.Value};

    if isempty(closest_asset)
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[sprintf('No %s found',asset_type);oldmsgs] )
    else
        axes(handles.axes1);
        hold all
        rectangle('Position',box,'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
        plot(u_asset, v_asset, 'g+')
        asset_type_info = strsplit(asset_type,' ');
        text(u_asset, v_asset, asset_type_info(1), 'color', 'm')
    end
catch e %e is an MException struct
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    message = e.message;
    set(handles.OutputLog,'String',[message;oldmsgs])
end



% --- Executes on mouse press over axes background.
function axes2Image_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cameraParams = handles.Road.UserData.camera_params;
pixel_click = eventdata.IntersectionPoint;
u = pixel_click(1); v = pixel_click(2);

try
    assets = handles.assetSearchTypeSelection.UserData;
    image = handles.Year2File.UserData;
    [closest_asset, u_asset, v_asset, box] = findClosestAsset(assets,image,u,v,cameraParams,'Year2');
    field_names = closest_asset.Properties.VariableNames;
    closest_asset_data = table2cell(closest_asset);
    set(handles.clickOnAssetResult,'Data',closest_asset_data','rowname',field_names,'columnname',{})
    asset_type = handles.assetSearchTypeSelection.String{handles.assetSearchTypeSelection.Value};

    if isempty(closest_asset)
        asset_type = handles.assetSearchTypeSelection.String{handles.assetSearchTypeSelection.Value};
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[sprintf('No %s found',asset_type);oldmsgs] )
    else
        axes(handles.axes2);
        hold all
        rectangle('Position',box,'LineWidth',1,'LineStyle','-','EdgeColor','r','Curvature',0);
        plot(u_asset, v_asset, 'g+')
        asset_type_info = strsplit(asset_type,' ');
        text(u_asset, v_asset, asset_type_info(1), 'color', 'm')
    end
catch e %e is an MException struct
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    message = e.message;
    set(handles.OutputLog,'String',[message;oldmsgs])
end

% --- Executes on selection change in assetSearchTypeSelection.
function assetSearchTypeSelection_Callback(hObject, eventdata, handles)
% hObject    handle to assetSearchTypeSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns assetSearchTypeSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from assetSearchTypeSelection
Asset_search_selection = handles.assetSearchTypeSelection.String{handles.assetSearchTypeSelection.Value};
Asset_search_type_info = strsplit(Asset_search_selection,' ');
Asset_search_type = Asset_search_type_info{1};

dataDir = handles.setDataDir.UserData;
road = handles.Road.String{handles.Road.Value};
asset_dbf_folder = fullfile(dataDir,road,'Assets','Year2_A27_Shapefiles');
asset_dbf_file = dir(fullfile(asset_dbf_folder,['*',Asset_search_type,'*.dbf']));

if isempty(asset_dbf_file)
    oldmsgs = cellstr(get(handles.OutputLog,'String'));
    set(handles.OutputLog,'String',[strcat(['No ',Asset_search_type,' data']);oldmsgs] )
else
    [asset_data, field_names] = dbfRead(fullfile(asset_dbf_folder,asset_dbf_file.name));
    if any(strcmp('XCOORD',field_names))
        asset_data_table = cell2table(asset_data,'VariableNames',field_names);
        set(handles.assetSearchTypeSelection,'UserData',asset_data_table);
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[strcat([Asset_search_type,' data loaded successfully']);oldmsgs] )
    else
        oldmsgs = cellstr(get(handles.OutputLog,'String'));
        set(handles.OutputLog,'String',[{'No location data available'};oldmsgs] )
    end
end

% --- Executes during object creation, after setting all properties.
function assetSearchTypeSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to assetSearchTypeSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ShowAllAssets.
function ShowAllAssets_Callback(hObject, eventdata, handles)
% hObject    handle to ShowAllAssets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = handles.Year1File.UserData;
image2 = handles.Year2File.UserData;

dataDir = handles.setDataDir.UserData;
road = handles.Road.String{handles.Road.Value};
asset_types = handles.Asset_type.String;
cameraParams = handles.Road.UserData.camera_params;

[assets_in_image1, asset_types_in_image1, assets_in_image2, asset_types_in_image2] = ...
    findAllAssets(image1,image2,asset_types,dataDir,road,cameraParams);

axes(handles.axes1);

hold on
num_assets1 = size(assets_in_image1,1);
for asset_num = 1:num_assets1
    u_asset = assets_in_image1(asset_num,1);
    v_asset = assets_in_image1(asset_num,2);
    box = assets_in_image1(asset_num,3:6);
    rectangle('Position',box,'LineWidth',1,'LineStyle','-', ...
              'EdgeColor','r','Curvature',0);
    plot(u_asset, v_asset, 'g+')
    text(u_asset, v_asset, asset_types_in_image1(asset_num,:),'color','m')
end
hold off 

axes(handles.axes2);
set(handles.axes2,'NextPlot','add')

num_assets2 = size(assets_in_image2,1);
hold on
for asset_num = 1:num_assets2
    u_asset = assets_in_image2(asset_num,1);
    v_asset = assets_in_image2(asset_num,2);
    box = assets_in_image2(asset_num,3:6);

    rectangle('Position',box,'LineWidth',1,'LineStyle','-', ...
              'EdgeColor','r','Curvature',0);
    plot(u_asset, v_asset, 'g+')
    text(u_asset, v_asset, asset_types_in_image2(asset_num,:), ...
        'color','m')
end
hold off

oldmsgs = cellstr(get(handles.OutputLog,'String'));
message = sprintf('Found %d assets in year 1 and %d in year 2',num_assets1,num_assets2);
set(handles.OutputLog,'String',[{message};oldmsgs] )


% --- Executes on button press in showAssets.
function showAssets_Callback(hObject, eventdata, handles)
% hObject    handle to showAssets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image1 = handles.Year1File.UserData;
image2 = handles.Year2File.UserData;

dataDir = handles.setDataDir.UserData;
road = handles.Road.String{handles.Road.Value};
asset_type = handles.assetSearchTypeSelection.String{handles.assetSearchTypeSelection.Value};
asset_type_info = strsplit(asset_type, ' ');
asset_type = asset_type_info(1);
camera_params = handles.Road.UserData.camera_params;
asset_data = handles.assetSearchTypeSelection.UserData;

[assets_in_image1, assets_in_image2] = findAllAssetsOfType(image1,image2,asset_data,camera_params);
axes(handles.axes1);

hold on
num_assets1 = size(assets_in_image1,1);
for asset_num = 1:num_assets1
    u_asset = assets_in_image1(asset_num,1);
    v_asset = assets_in_image1(asset_num,2);
    box = assets_in_image1(asset_num,3:6);
    rectangle('Position',box,'LineWidth',1,'LineStyle','-', ...
              'EdgeColor','r','Curvature',0);
    plot(u_asset, v_asset, 'g+')
    text(u_asset, v_asset, asset_type,'color','m')
end
hold off 

axes(handles.axes2);
set(handles.axes2,'NextPlot','add')

num_assets2 = size(assets_in_image2,1);
hold on
for asset_num = 1:num_assets2
    u_asset = assets_in_image2(asset_num,1);
    v_asset = assets_in_image2(asset_num,2);
    box = assets_in_image2(asset_num,3:6);

    rectangle('Position',box,'LineWidth',1,'LineStyle','-', ...
              'EdgeColor','r','Curvature',0);
    plot(u_asset, v_asset, 'g+')
    text(u_asset, v_asset, asset_type,'color','m')
end
hold off
