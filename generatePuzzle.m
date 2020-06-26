function [solvedPuzzle, res] = generatePuzzle(difficulty)
% generatePuzzle 根据输入的难度等级生成一个数独及其解
% 输入：difficulty为难度等级（1-5的一个整数）
% 输出：solvedPuzzle为数独题目，res为其解
    %% 生成一个随机的数独
    if ~ismember(difficulty, 1:5)
        difficulty = 1;
    end
    [solvedPuzzle, ~] = solveSudoku(ones(9,9)*10);
    indexes = randperm(81);
    knownCount = 81;
    %% 开始随机挖空
    for i = 1:81
        % 满足难度要求时就结束
        if knownCount <= 25
            break
        end
        if difficulty == 1 && knownCount <= 35
            break
        end
        currentValue = solvedPuzzle(indexes(i));
        solvedPuzzle(indexes(i)) = 10;
        [~, state] = solveSudoku(solvedPuzzle);
        % 保证难度合理
        if difficulty < state
            solvedPuzzle(indexes(i)) = currentValue;
        else
            knownCount = knownCount - 1;
        end
    end
    [res, ~] = solveSudoku(solvedPuzzle);
end