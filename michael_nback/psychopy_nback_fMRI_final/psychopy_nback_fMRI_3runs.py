# -*- coding: utf-8 -*-
"""
Created on Wed Feb  9 15:47:38 2022

@author: ppysc6
"""

import pandas
import numpy as np
from numpy import matlib
from psychopy import visual, core, event, parallel
from os.path import exists

print('test')
subject = 'test'
run = 1
#trig_path = r'C:\Users\Achieva\Documents\michael_nback\psychopy_nback_fMRI_final\trigger_timings'
#trig_path = "/Volumes/ares/ZESPRI_images/tasks/psychopy_nback_fMRI_final/trigger_timings/"
trig_path = "/Users/ppzma/Documents/MATLAB/mycode/michael_nback/psychopy_nback_fMRI_final/trigger_timings/"
trig_file = trig_path + '/' + subject + '_r5un0' + str(run) + '.txt'

#serial port settings
#port = parallel.ParallelPort(address=int('0x4FF8',16))    #open serial port to start routine
trig_len = 10/600     # s

n_stims = 15
t_stims = 1     # time elapsed per letter (s)
t_pause = 1     # pause between letters (s)
t_rest = 15     # total rest time per block (s)
t_instruction = 2   # instruction screen time (s)
t_wait = 1    # resting baseline at start of task (s)
t_block = (n_stims*(t_stims+t_pause))+t_rest+t_instruction


### create condition sequence array
n_conditions = 3   # total number of conditions
i_conditions = np.arange(n_conditions)   # condition indices
condition_names = ["0-back", "1-back", "2-back"]   # same length as i_conditions
n_blocks = 4     # number of blocks per condition
cond_sequence = np.array([],dtype=int)
for cond in i_conditions:
    cond_sequence = np.append(cond_sequence, np.matlib.repmat(int(cond),n_blocks,1))


### set trigger names
block_start = [1,2,3]   # must be same length as i_conditions
rest_start = [4,5,6]   # must be same length as i_conditions
trig_target = 7
trig_nontarget = 8
resp = 10

### use pandas to load in letter and condition sequences
#filepath = r'C:\Users\Achieva\Documents\michael_nback\psychopy_nback_fMRI_final'
#filepath = "/Volumes/ares/ZESPRI/tasks/psychopy_nback_fMRI_final/"
filepath = "/Users/ppzma/Documents/MATLAB/mycode/michael_nback/psychopy_nback_fMRI_final"

letters_fname_0back = filepath + '/letter_sequences/0back_0' + str(run) + '.txt'
letters_fname_1back = filepath + '/letter_sequences/1back_0' + str(run) + '.txt'
letters_fname_2back = filepath + '/letter_sequences/2back_0' + str(run) + '.txt'
block_seq_fname = filepath + '/block_sequences/run0' + str(run) + '.txt'
df_0back = pandas.read_csv(letters_fname_0back, sep=' ', header=None)
df_1back = pandas.read_csv(letters_fname_1back, sep=' ', header=None)
df_2back = pandas.read_csv(letters_fname_2back, sep=' ', header=None)
df_allconds = pandas.concat([df_0back, df_1back, df_2back], ignore_index=True)
seq_blocks = pandas.read_csv(block_seq_fname, sep=' ', header=None)
block_order = seq_blocks.values.flatten().tolist()
# reorder
df_reordered = df_allconds.reindex(block_order)
df_reordered = df_reordered.set_index(df_allconds.index)
cond_sequence_reordered = [cond_sequence[x] for x in block_order]

### make corresponding dataframe of targets ###
# 0back
df_targets_0back = pandas.DataFrame(index=df_0back.index,columns=df_0back.columns)
df_targets_0back[0] = False
for row in range(0,len(df_0back.index)):
    for col in range(1,len(df_0back.columns)):
        df_targets_0back.iat[row,col] = df_0back.loc[row,col] == df_0back.loc[row,col]
        
# 1back
df_targets_1back = pandas.DataFrame(index=df_1back.index,columns=df_1back.columns)
df_targets_1back[0] = False
for row in range(0,len(df_1back.index)):
    for col in range(1,len(df_1back.columns)):
        df_targets_1back.iat[row,col] = df_1back.loc[row,col] == df_1back.loc[row,col-1]
# 2back
df_targets_2back = pandas.DataFrame(index=df_2back.index,columns=df_2back.columns)
df_targets_2back[0] = False
df_targets_2back[1] = False
for row in range(0,len(df_2back.index)):
    for col in range(2,len(df_2back.columns)):
        df_targets_2back.iat[row,col] = df_2back.loc[row,col] == df_2back.loc[row,col-2]
# reorder targets dataframes
df_targets_allconds = pandas.concat([df_targets_0back, df_targets_1back, df_targets_2back], ignore_index=True)
df_targets_reordered = df_targets_allconds.reindex(block_order)
df_targets_reordered = df_targets_reordered.set_index(df_allconds.index)

 
#%%
def nback(condition_names, condition_sequence, letter_sequence, target_sequence,
          t_stims, t_pause, t_rest, t_instruction, t_wait, start_trigs, end_trigs,
          target_trig, nontarget_trig, resp_trig, trig_length, trig_filepath):
    
    # Allow user to terminate the experiment early with the "q" key
    global check
    check = 0
    def quit_exp():
          global check
          check = 1
         
    def send_trigger(data):
        filehandle.write(str(data) + ' ' + str(master_clock.getTime()) + '\n')
        #port.setData(data)
        core.wait(trig_length)
        #port.setData(0)
          
    def btn_press():
        filehandle.write('btn ' + str(master_clock.getTime()) + '\n')
        #port.setData(resp)
        core.wait(trig_length)
        #port.setData(0)
          
    def block(condition):
        # instruction screen
        clock = core.Clock()
        send_trigger(block_start[condition])
        while clock.getTime() < t_instruction:  # Clock times are in seconds
            if check == 1:
                break
            iscreens[condition].draw()
            window.flip()
        # task period
        t=t_instruction
        for stim in np.arange(n_stims):
            if check == 1:
                break
            if target_sequence.loc[blocknum,stim]:
                send_trigger(target_trig) 
            else:
                send_trigger(nontarget_trig)
               
            while clock.getTime() < t+t_stims:
                if check == 1:
                    break
                letters[(blocknum*n_stims)+stim].draw()
                window.flip()
            while clock.getTime() < t+t_stims+t_pause:
                if check == 1:
                    break
                window.flip()
            t+=(t_stims+t_pause)
        # rest period        
        send_trigger(rest_start[condition])
        while clock.getTime() < t_block:
            if check == 1:
                break
            fixation.draw()
            window.flip()
        
         
    event.globalKeys.clear()     
    event.globalKeys.add(key='q', func=quit_exp)
    event.globalKeys.add(key='9', func=btn_press)
    
    # find key variables from letter sequence
    n_blocks = len(letter_sequence.index)
    n_stims = len(letter_sequence.columns)
    
    #create a window
    window = visual.Window(fullscr=False,monitor="testMonitor", units="norm")
    window.color = "gray" 
    
    #create instruction screens
    iscreens = []
    for cond in condition_names:
        iscreen = visual.TextStim(win=window,text=cond,color='red', pos=(-0.4,0)
                              ,height=0.6,alignText='center',anchorHoriz='center',
                              anchorVert='center')
        iscreens.append(iscreen)
        
    # create intro screen
    intro_screen = visual.TextStim(win=window,text="keep still!",color='red'
                          ,height=0.4,alignText='center',anchorHoriz='center',
                          anchorVert='center')
        
    #create letter objects
    letters = []
    for blocknum in np.arange(n_blocks):
        for stimnum in np.arange(n_stims):
            letter = visual.TextStim(win=window,text=letter_sequence.loc[blocknum,stimnum],
                                 color='black',height=1,alignText='center',
                                 anchorHoriz='center',anchorVert='center')
            letters.append(letter)
            
    # create fixation
    fixation = visual.GratingStim(win=window, units="norm", size=[0.05,0.06], 
                              pos=[0,0], sf=0, color="red")
        
    # run task
    file_exists = exists(trig_filepath)
    while file_exists:
        trig_filepath = trig_filepath[:-4] + '_new.txt'
        file_exists = exists(trig_filepath)
    filehandle = open(trig_filepath, 'w')
    master_clock = core.Clock()
    window.flip()
    intro_screen.draw()
    window.flip()
    event.Mouse(visible=False)
    event.waitKeys(keyList='5')
    filehandle.write('StartData ' + str(master_clock.getTime()) + '\n')
    fixation.draw()
    window.flip()
    clock = core.Clock()
    while clock.getTime() < t_wait:
        if check == 1:
            break
        fixation.draw()
        window.flip()
    blocknum=0
    for cond in condition_sequence:
        if check == 1:
            break
        block(cond)
        blocknum += 1
    intro_screen.draw()
    window.flip()
    filehandle.write('EndData ' + str(master_clock.getTime()) + '\n')
    event.waitKeys(keyList="<space>")
    filehandle.close()
    window.close()
    core.quit()

### run n-back task
nback(condition_names=condition_names, condition_sequence=cond_sequence_reordered, 
        letter_sequence=df_reordered, target_sequence=df_targets_reordered,
        t_stims=t_stims, t_pause=t_pause, t_rest=t_rest, t_instruction=t_instruction,
        t_wait=t_wait, start_trigs=block_start, end_trigs=rest_start, target_trig=trig_target,
        nontarget_trig=trig_nontarget, resp_trig=resp, trig_length=trig_len, 
        trig_filepath=trig_file)


