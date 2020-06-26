function [board, state] = solveSudoku(board)
% solveSudoku 求解输入的数独
% 输入：board为输入的数独（用数字10代表空）
% 输出：board为求解后的结果，state为求解难度
    %% 初始化参数
    state = 1;
    possibilities = [true(81, 9), false(81, 1)];
    zone = [1, 1, 1, 4, 4, 4, 7, 7, 7];
    zone_idx = [0, 0, 0, 1, 1, 1, 2, 2, 2];
    solved = false;
    needCheckFreedoms = false;
    leastFree = [0; 10; zeros(81, 1)];
    %% 开始循环求解
    while ~solved
        solved = true;
        mutated = false;
        for row = 1:9
            for col = 1:9
                lidx = (col - 1) * 9 + row;
                if board(row, col) ~= 10
                    continue
                end
                solved = false;
                %% 减少每个格子的可能性
                currentPos = possibilities(lidx, :);
                currentPos(board(row, 1:9)) = false;
                currentPos(board(1:9, col)) = false;
                currentPos(board(zone(row):zone(row) + 2, zone(col):zone(col) + 2)) = false;
                mutated = mutated || (sum(possibilities(lidx, :) == currentPos) < 10);
                possibilities(lidx, :) = currentPos;
                %% 根据可能性确定格子里的值
                idx = find(currentPos);
                if isempty(idx)
                    board = [];
                    return
                elseif length(idx) == 1
                    board(row, col) = idx(1);
                    continue
                end
                if ~needCheckFreedoms
                    continue
                end
                %% 根据行、列、单元的唯一性确定格子里的值
                possibilities(lidx, :) = false(1, 10);
                uniqueRow = getUnique(board(row, :), currentPos, possibilities(row:9:81, :));
                uniqueCol = getUnique(board(:, col), currentPos, possibilities(9*col-8:9*col, :));
                uniqueCube = getUnique(board(zone(row):zone(row) + 2, zone(col):zone(col) + 2), currentPos, possibilities([1:3; 10:12; 19:21]' + zone_idx(row)*3 + zone_idx(col)*27, :));
                board(row, col) = min([uniqueRow, uniqueCol, uniqueCube]);
                possibilities(lidx, :) = currentPos;
                
                if board(row, col) ~= 10
                    mutated = true;
                    continue
                end
                %% 记录可能性最少的格子，用于后续的随机求解
                if length(idx) == leastFree(2)
                    leastFree(1) = leastFree(1) + 1;
                    leastFree(leastFree(1) + 2) = lidx;
                elseif length(idx) < leastFree(2)
                    leastFree(1:3) = [1, length(idx), lidx];
                end
            end
        end
        %% 若前面的方法失效，尝试随机求解
        if ~mutated && ~solved
            if ~needCheckFreedoms
                needCheckFreedoms = true;
                state = 2;
            else
                [board, state] = solveByGuessing(board, possibilities, leastFree(3:2+leastFree(1)), state);
                return
            end
        end
    end
end
%% 计算是否是唯一值
function [unique] = getUnique(board, currentPos, possibilities)
    unique = 10;
    idx = find(board == 10);
    for i = 1:length(idx)
        currentPos(possibilities(idx(i), :)) = false;
    end
    res = find(currentPos);
    if length(res) == 1
        unique = res;
    end
end
%% 随机求解
function [board, state] = solveByGuessing(board, possibilities, leastFree, state)
    if isempty(leastFree)
        board = [];
        return
    end
    if state <= 3
        state = state + 1;
    end
    idx = leastFree(randi(length(leastFree)));
    guesses = find(possibilities(idx, :));
    guesses = guesses(randperm(length(guesses)));
    for i = 1:length(guesses)
        board(idx) = guesses(i);
        [result, ~] = solveSudoku(board);
        if ~isempty(result)
            board = result;
            return
        end
    end
    board = [];
end