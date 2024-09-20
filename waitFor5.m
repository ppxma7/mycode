function [keyPressed] = waitFor5
keyPressed = 0; % set this to zero until we receive a sensible keypress


myKey = KbName('5%');


while keyPressed == 0 % hang the system until a response is given
    [ keyIsDown, seconds, keyCode ] = KbCheck; % check for keypress
%     if find(keyCode) == '5%' % 89 = 'y', 78 = 'n'
%         keyPressed = find(keyCode);
%         disp('caught a 5')
%     end

    if any(keyCode(myKey))
        disp('Woo')
        % stimulation function here
        
    end
    
    
end