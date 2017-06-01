function generate_sound(A)
    amp = [1 0.5 0.25 0.125 0.125/2] .*0.8;
    freq = [110 220 330 440 550]/2*1.3;
    x = -1:0.001:1;
    Y = 0;
    for ii = 1: 5

        Y = Y + amp(ii)*sin(x.*freq(ii)*2*pi) .* gaussmf(x,[0.7 -0]);
    end
    %%
 
    Y = Y.*A;
  
    for ii = 1:3
    %     amp = 0.5;
    
        player = audioplayer(Y ,8192);
        play(player);
        pause(0.01)
%         pause(0.025 )
    end
end