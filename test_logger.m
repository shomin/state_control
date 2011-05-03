%%
log=quad_read_log('test_log.bin');

size(log)

%%

hold on
plot3(log(:,8),log(:,9),log(:,10),'r');
hold off