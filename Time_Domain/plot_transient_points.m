idxs_se = TransientDetection(x, 512, 512/4);
plot(x);
hold on
for i = 1 : size(idxs_se, 1)
    if idxs_se(i, 3) == 1
        xline(idxs_se(i, 1), '-r');
%         xline(idxs_se(i, 2), '-y');
    end
end