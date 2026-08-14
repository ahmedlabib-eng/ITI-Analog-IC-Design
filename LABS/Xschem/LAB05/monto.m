% Monte Carlo Analysis for Current Mirrors
clear; clc; close all;

% Define exact Windows file paths
file_simple = 'G:\EECE\ITI Analog Design\LABs\Xschem\LAB05\MC_Simple_CM.csv';
file_ws = 'G:\EECE\ITI Analog Design\LABs\Xschem\LAB05\MC_WS_CM.csv';

% --- Robust Data Parsing ---

% Parse Simple Current Mirror data
Iout_simple = [];
if isfile(file_simple)
    lines_simple = readlines(file_simple);
    for i = 1:length(lines_simple)
        % Extract all numbers (including scientific notation) from the line
        nums = regexp(lines_simple(i), '[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?', 'match');
        if ~isempty(nums)
            % Ngspice prints the run index first. We take the *last* number on the line.
            val = str2double(nums{end});
            
            % Sanity check: Filter out index numbers, keep only microamp-range values
            if val < 1e-3 
                Iout_simple(end+1, 1) = val;
            end
        end
    end
else
    fprintf('Warning: %s not found.\n', file_simple);
end

% Parse Wide Swing Current Mirror data
Iout_ws = [];
if isfile(file_ws)
    lines_ws = readlines(file_ws);
    for i = 1:length(lines_ws)
        nums = regexp(lines_ws(i), '[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?', 'match');
        if ~isempty(nums)
            val = str2double(nums{end});
            if val < 1e-3
                Iout_ws(end+1, 1) = val;
            end
        end
    end
else
    fprintf('Warning: %s not found.\n', file_ws);
end

% --- Statistical Calculations ---

% 1. Simple Current Mirror
if ~isempty(Iout_simple)
    mean_simple = mean(Iout_simple);
    std_simple = std(Iout_simple);
    error_simple = (std_simple / mean_simple) * 100;
    
    fprintf('--- Simple Current Mirror ---\n');
    fprintf('Total Samples: %d\n', length(Iout_simple));
    fprintf('Average Iout: %.4f uA\n', mean_simple * 1e6);
    fprintf('Standard Deviation: %.4f uA\n', std_simple * 1e6);
    fprintf('Percentage Error: %.2f%%\n\n', error_simple);
end

% 2. Wide Swing Current Mirror
if ~isempty(Iout_ws)
    mean_ws = mean(Iout_ws);
    std_ws = std(Iout_ws);
    error_ws = (std_ws / mean_ws) * 100;
    
    fprintf('--- Wide Swing Current Mirror ---\n');
    fprintf('Total Samples: %d\n', length(Iout_ws));
    fprintf('Average Iout: %.4f uA\n', mean_ws * 1e6);
    fprintf('Standard Deviation: %.4f uA\n', std_ws * 1e6);
    fprintf('Percentage Error: %.2f%%\n\n', error_ws);
end

% --- Histogram Plotting ---

figure('Name', 'Monte Carlo Simulation: Iout Histograms', 'Position', [100, 100, 800, 400]);

% Plot Simple Current Mirror (if data exists)
if ~isempty(Iout_simple)
    subplot(1,2,1);
    Iout_simple_uA = Iout_simple * 1e6;
    
    % Using 15 bins as a starting point. Adjust based on your run count.
    histogram(Iout_simple_uA, 15, 'FaceColor', '#0072BD', 'EdgeColor', 'w');
    title('Simple Current Mirror');
    xlabel('I_{out} (\muA)');
    ylabel('Frequency');
    grid on;
    xline(mean_simple*1e6, 'r', 'LineWidth', 2, 'Label', '\mu');
end

% Plot Wide Swing Current Mirror (if data exists)
if ~isempty(Iout_ws)
    subplot(1,2,2);
    Iout_ws_uA = Iout_ws * 1e6;
    
    histogram(Iout_ws_uA, 15, 'FaceColor', '#D95319', 'EdgeColor', 'w');
    title('Wide Swing Current Mirror');
    xlabel('I_{out} (\muA)');
    ylabel('Frequency');
    grid on;
    xline(mean_ws*1e6, 'r', 'LineWidth', 2, 'Label', '\mu');
end

sgtitle('Monte Carlo Analysis of Current Mirror Mismatch');