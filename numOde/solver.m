% 
% clear t x
% tic
% % for n=1:1000
% %     t(n) = n;
% %     x(n) = sin(n^n);
% % end
% input('Hallo')
% toc
% plot(t,x)
close all
parpool(4)
spmd
  % build magic squares in parallel
  q = magic(labindex+100);
end
for ii=1:length(q)
  % plot each magic square
  figure, imagesc(q{ii});
end
delete(gcp)