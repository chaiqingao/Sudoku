function varargout = sudoku(varargin)
% SUDOKU MATLAB code for sudoku.fig
%      SUDOKU, by itself, creates a new SUDOKU or raises the existing
%      singleton*.
%
%      H = SUDOKU returns the handle to a new SUDOKU or the handle to
%      the existing singleton*.
%
%      SUDOKU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUDOKU.M with the given input arguments.
%
%      SUDOKU('Property','Value',...) creates a new SUDOKU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sudoku_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sudoku_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sudoku

% Last Modified by GUIDE v2.5 27-Jun-2020 01:28:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sudoku_OpeningFcn, ...
                   'gui_OutputFcn',  @sudoku_OutputFcn, ...
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


% --- Executes just before sudoku is made visible.
function sudoku_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sudoku (see VARARGIN)

% Choose default command line output for sudoku
handles.output = hObject;
handles.t = now;
handles.clk = timer('Period',1,'ExecutionMode','fixedRate','TimerFcn',{@disptime, handles});
start( handles.clk );
init(hObject, handles, false)
% Update handles structure
% guidata(hObject, handles);
function setEnable(hObject, handles, num, st)
if num == 1
    set(handles.pushbutton5, 'Enable', st);
elseif num == 2
    set(handles.pushbutton6, 'Enable', st);
elseif num == 3
    set(handles.pushbutton7, 'Enable', st);
elseif num == 4
    set(handles.pushbutton8, 'Enable', st);
elseif num == 5
    set(handles.pushbutton9, 'Enable', st);
elseif num == 6
    set(handles.pushbutton10, 'Enable', st);
elseif num == 7
    set(handles.pushbutton11, 'Enable', st);
elseif num == 8
    set(handles.pushbutton12, 'Enable', st);
elseif num == 9
    set(handles.pushbutton13, 'Enable', st);
end
guidata(hObject, handles);

function updateNums(hObject, handles)
row = handles.pos(1);
col = handles.pos(2);
if handles.matrix(row,col) ~= 10
    for i = 1:9
        setEnable(hObject, handles,i,'off');
    end
    return
end
possibilities = true(1,9);
if get(handles.checkbox1,'value')
    board = handles.current;
    zone = [1, 1, 1, 4, 4, 4, 7, 7, 7];
    possibilities(board(row, 1:9)) = false;
    possibilities(board(1:9, col)) = false;
    possibilities(board(zone(row):zone(row) + 2, zone(col):zone(col) + 2)) = false;
end

for i = 1:9
    if possibilities(i)
        setEnable(hObject, handles,i,'on');
    else
        setEnable(hObject, handles,i,'off');
    end
end

function disptime(src, evt, handles)
tm = now - handles.t;
set(handles.edit2,'String',datestr(tm,'HH:MM:SS'));

function init(hObject, handles, restart)
if ~restart
    [handles.matrix, handles.res] = generatePuzzle(get(handles.popupmenu1,'Value'));
end
set(handles.pushbutton2, 'Enable','on');
set(handles.pushbutton14, 'Enable','on');
handles.current = handles.matrix;
[row, col] = find(handles.matrix==10);
idx = randi(length(row));
handles.pos = [row(idx), col(idx)];
handles.check = false;
updateNums(hObject, handles);
draw(handles);
guidata(hObject, handles);




% UIWAIT makes sudoku wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function draw(handles)
cla;
axis off;
axis equal;
hold on
fill([0,9,9,0],[0,0,9,9],'w');
zone = [0,0,0,3,3,3,6,6,6];
x = handles.pos(2)-1;
y = 9-handles.pos(1);
fill([0,9,9,0],[0,0,1,1]+y,[226,231,237]/255);
fill([0,1,1,0]+x,[0,0,9,9],[226,231,237]/255);
fill([0,3,3,0]+zone(x+1),[0,0,3,3]+zone(y+1),[226,231,237]/255);
if handles.current(handles.pos(1),handles.pos(2)) ~= 10
    [rows,cols] = find(handles.current==handles.current(handles.pos(1),handles.pos(2)));
    if ~isempty(rows)
        xs = cols - 1;
        ys = 9 - rows;
        for i = 1:length(xs)
            fill([0,1,1,0]+xs(i),[0,0,1,1]+ys(i),[203,219,237]/255)
        end
    end
end
fill([0,1,1,0]+x,[0,0,1,1]+y,[187,222,251]/255);
if handles.check
    [rows,cols] = find(handles.current~=handles.res);
    if ~isempty(rows)
        xs = cols - 1;
        ys = 9 - rows;
        for i = 1:length(xs)
            fill([0,1,1,0]+xs(i),[0,0,1,1]+ys(i),[239,173,171]/255)
        end
    end
end
for i = 0 : 9
    if rem(i,3) == 0
        plot(handles.axes1, [0;9],[i,i],'linewidth',3,'color','black');
        plot(handles.axes1, [i;i],[0,9],'linewidth',3,'color','black');
    else
        plot(handles.axes1, [0;9],[i,i],'linewidth',1,'color','black');
        plot(handles.axes1, [i;i],[0,9],'linewidth',1,'color','black');
    end
end

matrix = handles.matrix';
current = handles.current';
for i = 1 : 9
    for j = 1 : 9
        if matrix(i,j) ~= 10
            text(handles.axes1, i-0.63, 9.5-j, num2str(matrix(i,j)),'Color','red','FontSize',14);
        elseif current(i,j) ~= 10
            text(handles.axes1, i-0.63, 9.5-j, num2str(current(i,j)),'Color','black','FontSize',14);
        end
    end
end

% --- Outputs from this function are returned to the command line.
function varargout = sudoku_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.matrix(handles.pos(1),handles.pos(2)) = handles.res(handles.pos(1),handles.pos(2));
handles.current(handles.pos(1),handles.pos(2)) = handles.res(handles.pos(1),handles.pos(2));
[row, col] = find(handles.matrix==10);
if isempty(row)
    return
end
idx = randi(length(row));
handles.pos = [row(idx), col(idx)];
updateNums(hObject, handles);
draw(handles);
guidata(hObject, handles);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.current = handles.res;
draw(handles);
guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable', 'off');
handles.t = now;
stop( handles.clk );
handles.clk = timer('Period',1,'ExecutionMode','fixedRate','TimerFcn',{@disptime, handles});
start( handles.clk );
init(hObject, handles,false);
set(handles.pushbutton1, 'Enable', 'on');


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt = get(gca,'CurrentPoint');
col = ceil(pt(1,1));
row = 10 - ceil(pt(1,2));
if col<1 || col>9 || row<1 || row>9 || handles.matrix(row, col) ~= 10
    set(handles.figure1,'Pointer','arrow');
else
    set(handles.figure1,'Pointer','hand');
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pt = get(gca,'CurrentPoint');
handles.showbg = false;
col = ceil(pt(1,1));
row = 10 - ceil(pt(1,2));
if col<1 || col>9 || row<1 || row>9
    return
end
handles.pos = [row, col];
updateNums(hObject, handles);
if handles.matrix(row, col) ~= 10
    set(handles.pushbutton2, 'Enable','off');
    set(handles.pushbutton14, 'Enable','off');
else
    set(handles.pushbutton2, 'Enable','on');
    set(handles.pushbutton14, 'Enable','on');
end
draw(handles);
guidata(hObject, handles);

function setData(hObject, handles, num)
row = handles.pos(1);
col = handles.pos(2);
handles.current(row, col) = num;
draw(handles);
guidata(hObject, handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 1);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 2);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 3);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 4);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 5);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 6);

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 7);

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 8);

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 9);

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
updateNums(hObject,handles);


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setData(hObject, handles, 10);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
stop(handles.clk);
delete(hObject);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.t = now;
stop( handles.clk );
handles.clk = timer('Period',1,'ExecutionMode','fixedRate','TimerFcn',{@disptime, handles});
start( handles.clk );
init(hObject,handles,true);


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.check = true;
draw(handles);
handles.check = false;
r1 = sum(sum(handles.current == handles.res));
r2 = sum(sum(handles.current == handles.matrix));
if r1 == 81
    msgbox(sprintf('恭喜你！用时%s通过！',get(handles.edit2,'String')));
    stop(handles.clk);
elseif r1 > 70
    msgbox('还差一点就可以了！');
elseif r2 == 81
    msgbox('别逗我啦，一个都还没填呢！');
else
    msgbox('继续努力哦~');
end
guidata(hObject, handles);
