randomNum = zeros(20,1);
for i=1:20
    randomNum(i) = 30*(1+rand(1,1));
end
randomNum = round(randomNum);
assignin('base','randomNum',randomNum);