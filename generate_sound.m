function generate_sound(A)
    amp = [1 0.5 0.25 0.125 0.125/2] .*0.8;
    freq = [110 220 330 440 550]/3;
    x = -1:0.002:1;
    Y = 0;
    for ii = 1: 5

        Y = Y + amp(ii)*sin(x.*freq(ii)*2*pi) .* gaussmf(x,[0.7 -0]);
    end
    space = zeros(1,501);
    Y = [Y space  Y space   Y  ];
    %%

    Y = Y.*A;
 
    player = audioplayer(Y ,8192);
    play(player);
 pause(0.4)
end