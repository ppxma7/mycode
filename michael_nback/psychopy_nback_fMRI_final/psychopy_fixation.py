# -*- coding: utf-8 -*-
"""
Created on Mon Apr 24 16:23:36 2023

@author: Achieva
"""
from psychopy.gui import DlgFromDict
from psychopy import visual, event
from psychopy.visual import Window, TextStim
from psychopy.core import Clock, quit, wait
from psychopy.event import Mouse
from psychopy.hardware.keyboard import Keyboard

### DIALOG BOX ROUTINE ###

# Initialize a fullscreen window with my monitor (HD format) size
# and my monitor specification called "samsung" from the monitor center

win = visual.Window(fullscr=False,monitor="testMonitor", units="norm")
win.color = "gray" 
    
    
# win = Window(size=(1920, 1080), fullscr=False, monitor='samsung')

# Also initialize a mouse, for later
# We'll set it to invisible for now
mouse = Mouse(visible=False)

# Initialize a (global) clock
clock = Clock()

# Initialize Keyboard
kb = Keyboard()

### START BODY OF EXPERIMENT ###
#
# This is where we'll add stuff from the second
# Coder tutorial.

# welcome_txt_stim = TextStim(win, text="Welcome to this experiment!", height=0.1)
# welcome_txt_stim.setHeight(0.2)

event.waitKeys(keyList='5')

fix_target = TextStim(win, '+')
fix_target.draw()
win.flip()
wait(10) # how long to have fixation cross on for
win.flip()
wait(2)

#
### END BODY OF EXPERIMENT ###

# Finish experiment by closing window and quitting
win.close()
quit()
