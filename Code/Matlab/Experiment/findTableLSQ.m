function findTableLSQ

m = 4032; cx = 2016; % >
n = 3024; cy = 1512; % ^
camera_height = 0.21;

stickyNotesData = readtable(fullfile(dataDir(),'Experiment','StickyNotes.csv'));
num_rows = size(stickyNotesData,1);
%% create data from all sticky notes.
data = zeros(num_rows, 3);
labels = zeros(num_rows,1);
params = []
for row = 1:num_rows
    u = stickyNotesData(row,:).U - cx; v = cy - stickyNotesData(row,:).V;
    x = stickyNotesData(row,:).X; y = stickyNotesData(row,:).Y;
    z = -camera_height;
    data(row,:) = [x,y,z];
    labels(row,1) = sqrt(u^2 + v^2);


    lb = [-pi/2, -pi/2, -pi/2, 0, 0];
    ub = [pi/2, pi/2, pi/2, 10, 10];
    x0 = [0, 0, 0, 1, 1];
    params = [params; lsqcurvefit(@cameraEquationFunction,x0,data(row,:),labels(row,:))]
end

mean(params)