function varargout = datasetChooser(varargin)
% DATASETCHOOSER M-file for datasetChooser.fig
%      DATASETCHOOSER, by itself, creates a new DATASETCHOOSER or raises the existing
%      singleton*.
%
%      H = DATASETCHOOSER returns the handle to a new DATASETCHOOSER or the handle to
%      the existing singleton*.
%
%      DATASETCHOOSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATASETCHOOSER.M with the given input arguments.
%
%      DATASETCHOOSER('Property','Value',...) creates a new DATASETCHOOSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before datasetChooser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to datasetChooser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help datasetChooser

% Last Modified by GUIDE v2.5 26-Jul-2010 16:31:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @datasetChooser_OpeningFcn, ...
                   'gui_OutputFcn',  @datasetChooser_OutputFcn, ...
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


% --- Executes just before datasetChooser is made visible.
function datasetChooser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to datasetChooser (see VARARGIN)

% Choose default command line output for datasetChooser
%handles.output = hObject;
addIcon = imread('addButton.png', 'png');
subtractIcon = imread('subtractButton.png', 'png');
deleteIcon = imread('deletePointButton.png', 'png');
set(handles.addButton,'CDATA',addIcon);
set(handles.deleteButton,'CDATA',subtractIcon);
set(handles.deleteAllButton,'CDATA',deleteIcon);

%Use this GUI with datasetChooser(handles, 'parentFigureName');
handles.parentHandles = varargin{1};
handles.parentFigureName = varargin{2};

setappdata(handles.datasetChooser, 'selectedDsNames', {});
setappdata(handles.datasetChooser, 'selectedDsIds', []);

previousDsNames = getappdata(handles.parentHandles.(handles.parentFigureName), 'selectedDsNames');
previousDsIds = getappdata(handles.parentHandles.(handles.parentFigureName), 'selectedDsIds');
setappdata(handles.datasetChooser, 'selectedDsNames', previousDsNames);
setappdata(handles.datasetChooser, 'selectedDsIds', previousDsIds);
set(handles.selectedDatasetsList, 'String', previousDsNames);

populateProjectsSelect(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes datasetChooser wait for user response (see UIRESUME)
uiwait(handles.datasetChooser);


% --- Outputs from this function are returned to the command line.
function varargout = datasetChooser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout = handles.output;
% varargout{1} = getappdata(handles.datasetChooser, 'selectedDsNames');
% varargout{2} = getappdata(handles.datasetChooser, 'selectedDsIds');
%uiresume(handles.datasetChooser);


% --- Executes on selection change in datasetsList.
function datasetsList_Callback(hObject, eventdata, handles)
% hObject    handle to datasetsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns datasetsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from datasetsList


% --- Executes during object creation, after setting all properties.
function datasetsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datasetsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in projectsSelect.
function projectsSelect_Callback(hObject, eventdata, handles)
% hObject    handle to projectsSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns projectsSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from projectsSelect

projIdList = getappdata(handles.datasetChooser, 'projIdList');
projectsSelectIdx = get(hObject, 'Value');
if projectsSelectIdx == 1
    return;
end
projectId = projIdList(projectsSelectIdx-1);
setappdata(handles.datasetChooser, 'projectId', projectId);
populateDatasetsList(handles)


% --- Executes during object creation, after setting all properties.
function projectsSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to projectsSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectedDatasetsList.
function selectedDatasetsList_Callback(hObject, eventdata, handles)
% hObject    handle to selectedDatasetsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns selectedDatasetsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectedDatasetsList


% --- Executes during object creation, after setting all properties.
function selectedDatasetsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectedDatasetsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectedDsNames = getappdata(handles.datasetChooser, 'selectedDsNames');
selectedDsIds = getappdata(handles.datasetChooser, 'selectedDsIds');
dsIdList = getappdata(handles.datasetChooser, 'dsIdList');
dsNameList = getappdata(handles.datasetChooser, 'dsNameList');
if isempty(dsIdList)
    return;
end
datasetListIdx = get(handles.datasetsList, 'Value');
dsName = dsNameList{datasetListIdx};
dsId = dsIdList(datasetListIdx);
if ~isempty(selectedDsIds)
    for thisId = 1:length(selectedDsIds)
        if dsId == selectedDsIds(thisId)
            return;
        end
    end
end
selectedDsNames{end+1} = dsName;
selectedDsIds(end+1) = dsId;
setappdata(handles.datasetChooser, 'selectedDsNames', selectedDsNames);
setappdata(handles.datasetChooser, 'selectedDsIds', selectedDsIds);
set(handles.selectedDatasetsList, 'String', selectedDsNames);
set(handles.selectedDatasetsList, 'Value', 1);



% --- Executes on button press in deleteButton.
function deleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selectedDsIdx = get(handles.selectedDatasetsList, 'Value');
numDsInList = length(get(handles.selectedDatasetsList, 'String'));
if numDsInList < 2
    deleteAllButton_Callback(hObject, eventdata, handles);
    return;
end

selectedDsNames = getappdata(handles.datasetChooser, 'selectedDsNames');
selectedDsIds = getappdata(handles.datasetChooser, 'selectedDsIds');
selectedDsNames = deleteElementFromCells(selectedDsIdx, selectedDsNames);
selectedDsIds = deleteElementFromVector(selectedDsIdx, selectedDsIds);
set(handles.selectedDatasetsList, 'String', selectedDsNames);
if selectedDsIdx > 1
    set(handles.selectedDatasetsList, 'Value', selectedDsIdx-1);
else
    set(handles.selectedDatasetsList, 'Value', 1);
end
setappdata(handles.datasetChooser, 'selectedDsNames', selectedDsNames);
setappdata(handles.datasetChooser, 'selectedDsIds', selectedDsIds);



% --- Executes on button press in deleteAllButton.
function deleteAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteAllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.datasetChooser, 'selectedDsNames', {});
setappdata(handles.datasetChooser, 'selectedDsIds', []);
set(handles.selectedDatasetsList, 'Value', []);
set(handles.selectedDatasetsList, 'String', {});


% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.output{1} = getappdata(handles.datasetChooser, 'selectedDsNames');
% handles.output{2} = getappdata(handles.datasetChooser, 'selectedDsIds');

selectedDsNames = getappdata(handles.datasetChooser, 'selectedDsNames');
selectedDsIds = getappdata(handles.datasetChooser, 'selectedDsIds');
setappdata(handles.parentHandles.(handles.parentFigureName), 'selectedDsNames', selectedDsNames);
setappdata(handles.parentHandles.(handles.parentFigureName), 'selectedDsIds', selectedDsIds);
guidata(handles.datasetChooser, handles);
delete(handles.datasetChooser);


function populateProjectsSelect(handles)

global gateway
% global session
% adminService = session.getAdminService;
% username = handles.parentHandles.credentials{1};
% userId = adminService.lookupExperimenter(username).getId.getValue;
% userIdList = java.util.ArrayList;
% userIdList.add(java.lang.Long(userId));
projects = gateway.getProjects([],0);
projIter = projects.iterator;
numProj = projects.size;
if numProj == 0
    warndlg('No projects found.');
    return;
end
projNameId{numProj,2} = [];
projNameList{numProj} = [];
projIdList = [];
counter = 1;
while projIter.hasNext
    projNameId{counter,1} = char(projects.get(counter-1).getName.getValue.getBytes');
    projNameId{counter,2} = num2str(projects.get(counter-1).getId.getValue);
    projIter.next;
    counter = counter + 1;
end
projNameId = sortrows(projNameId);
for thisProj = 1:numProj
    projNameList{thisProj} = projNameId{thisProj, 1};
    projIdList(thisProj) = str2double(projNameId{thisProj, 2});
end
set(handles.projectsSelect, 'String', [{'Select a project'} projNameList]);
%set(handles.datasetsList, 'String', 'Select a dataset');
setappdata(handles.datasetChooser, 'projNameList', projNameList);
setappdata(handles.datasetChooser, 'projIdList', projIdList);



function populateDatasetsList(handles)

global gateway
projId = getappdata(handles.datasetChooser, 'projectId');
projectId = java.util.ArrayList;
projectId.add(java.lang.Long(projId));
project = gateway.getProjects(projectId, 0).get(0);
numDs = project.sizeOfDatasetLinks;
if numDs == 0
    set(handles.datasetsList, 'Value', 1);
    set(handles.datasetsList, 'String', 'No datasets in this project');
    return;
end
dsLinks{numDs} = [];
datasets{numDs} = [];
dsNameId{numDs,2} = [];
dsNameList{numDs} = [];

dsIter = project.iterateDatasetLinks;
counter = 1;
while dsIter.hasNext
    dsLinks{counter} = dsIter.next;
    datasets{counter} = dsLinks{counter}.getChild();
    dsNameId{counter,1} = char(datasets{counter}.getName.getValue.getBytes');
    dsNameId{counter,2} = num2str(datasets{counter}.getId.getValue);
    counter = counter + 1;
end

dsNameId = sortrows(dsNameId);
for thisDs = 1:numDs
    dsNameList{thisDs} = dsNameId{thisDs, 1};
    dsIdList(thisDs) = str2double(dsNameId{thisDs, 2});
end
set(handles.datasetsList, 'String', dsNameList);

setappdata(handles.datasetChooser, 'dsNameList', dsNameList);
setappdata(handles.datasetChooser, 'dsIdList', dsIdList);


