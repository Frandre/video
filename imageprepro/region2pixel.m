function reallabel=region2pixel(label,segs)
% % REALLABEL project the superpixel level result to pixel level.

reallabel=zeros(size(segs));
for iter=1:max(segs(:))
    reallabel(segs==iter)=label(iter);
end
end