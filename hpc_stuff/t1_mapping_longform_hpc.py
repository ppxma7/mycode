import os
import subprocess
import numpy as np
from numpy import exp
import time
import sys
import nibabel as nib
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
import glob
import argparse
import re

# Input MR parameters
nTIs=8; 
MBfactor=2; 
TR=4500
sliceOffsets=[0,12,24,36,48,60,72,84]
minTI=32 

def size(A):
    sizei = 1
    for dim in np.shape(A): sizei = sizei*dim
    return sizei

## T1 fit functions
# TR is a global variable here...
def myT1fit(t,T1,M0):
    fit =  M0 * (1 - 2*exp(-t/T1) + exp(- TR/T1))
    # e = (data(:) - fit(:))**2;
    return fit

def fitT1(sortTIi,modSlice,maskSlice2):
    datasize=int(modSlice.shape[0])
    t1=np.zeros((datasize,1))
    m0=np.zeros((datasize,1))
    r2=np.zeros((datasize,1))
    e2=np.zeros((datasize,1))
    #modSlice already flattened as input...
    for i in range(0,datasize):#range(int(datasize/2-1000),int(datasize/2+1000)):#
        if maskSlice2[i]:
            modSlicei=modSlice[i,:]
            # params,pcov=curve_fit(myT1fit,sortTIi,modSlicei,p0=[1000,modSlicei[-1]],
            #                       bounds=[[0,0],[10000,1e7]],maxfev=500,ftol=0.01,xtol=0.01)
            params,pcov=curve_fit(myT1fit,sortTIi,modSlicei,p0=[1000,modSlicei[-1]],
                                  bounds=[[0,0],[10000,1e7]],maxfev=500,ftol=0.01,xtol=0.01)
            t1[i]=params[0]
            m0[i]=params[1]
            
            sigfit=myT1fit(sortTIi,params[0],params[1])
            
            #corr_matrix = np.corrcoef(modSlicei,sigfit)
            #corr = corr_matrix[0,1]
            #r2[i] = corr**2
            
            y = modSlicei
            yhat = sigfit                        
            ybar = np.sum(y)/len(y)         
            ssres = np.sum((y - yhat)**2)   
            sstot = np.sum((y - ybar)**2)   
            r2[i] = 1 - ssres / sstot
            
            #r2[i]=sum((myT1fit(sortTIi,params[0],params[1])-modSlicei)**2)
            e2[i]=np.sqrt(np.diag(pcov))[0]
        else:
            t1[i]=0
            m0[i]=0
            r2[i]=0
            e2[i]=0
    return t1,m0,r2,e2

def fitT1_try(sortTIi, modSlice, maskSlice2):
    datasize = int(modSlice.shape[0])
    t1 = np.zeros((datasize, 1))
    m0 = np.zeros((datasize, 1))
    r2 = np.zeros((datasize, 1))
    e2 = np.zeros((datasize, 1))

    for i in range(datasize):
        if maskSlice2[i]:
            modSlicei = modSlice[i, :]
            initial_guess = [800, np.clip(modSlicei[-1], 0, 1e7)]
            
            try:
                params, pcov = curve_fit(myT1fit, sortTIi, modSlicei, p0=initial_guess,
                                         bounds=[[0, 0], [10000, 1e7]], maxfev=500, 
                                         ftol=0.01, xtol=0.01)
                t1[i] = params[0]
                m0[i] = params[1]
                
                sigfit = myT1fit(sortTIi, params[0], params[1])
                y = modSlicei
                yhat = sigfit                        
                ybar = np.sum(y) / len(y)         
                ssres = np.sum((y - yhat)**2)   
                sstot = np.sum((y - ybar)**2)   
                r2[i] = 1 - ssres / sstot
                
                e2[i] = np.sqrt(np.diag(pcov))[0]
            except ValueError as e:
                print(f"Error at index {i}: {e}")
                t1[i], m0[i], r2[i], e2[i] = 0, 0, 0, 0
        else:
            t1[i], m0[i], r2[i], e2[i] = 0, 0, 0, 0

    return t1, m0, r2, e2


def register_t1_to_mni(sub_dir, subject, data_dir):
    """Register T1 map to MPRAGE, move MPRAGE to MNI space, then apply transformation to T1."""

    # Define paths

    # Define paths
    FSLDIR = "/software/imaging/fsl/6.0.6.3"
    #MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_2mm.nii.gz"
    #BRC_GLOBAL_DIR = "/software/imaging/BRC_pipeline/1.6.6//global"  # Change this to actual path

    #FSLDIR = "/Users/spmic/fsl/"
    #MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_2mm.nii.gz"
    MNI_TEMPLATE = f"{FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz"
    #BRC_GLOBAL_DIR = "/Users/spmic/data/"
    MY_CONFIG_DIR = "/gpfs01/home/ppzma/"

    # Subject's MPRAGE path
    mprage_dir = os.path.join(data_dir, subject, "MPRAGE")
    #mprage_file = os.path.join(mprage_dir, "WIP_MPRAGE_CS3p5_201.nii")
    mprage_files = glob.glob(os.path.join(mprage_dir, "*MPRAGE*.nii"))
    mprage_file = mprage_files[0]  # Use the first match

    if not os.path.exists(mprage_file):
        print(f"Missing MPRAGE file for {subject}, skipping MNI registration.")
        return
    
    print(f"✅ Found MPRAGE file for {subject}: {mprage_file}")

    # Paths for output files
    t1_input = os.path.join(sub_dir, f"{subject}_T1.nii.gz")
    t1_to_mprage = os.path.join(sub_dir, f"{subject}_T1_to_MPRAGE.nii.gz")
    affine_t1_to_mprage = os.path.join(sub_dir, f"{subject}_T1_to_MPRAGE.mat")

    mprage_to_mni = os.path.join(sub_dir, f"{subject}_MPRAGE_to_MNI_linear.nii.gz")
    affine_mprage_to_mni = os.path.join(sub_dir, f"{subject}_MPRAGE_to_MNI.mat")

    mprage_to_mni_nonlin = os.path.join(sub_dir, f"{subject}_MPRAGE_to_MNI_nonlin.nii.gz")
    fnirt_coeff = os.path.join(sub_dir, f"{subject}_MPRAGE_to_MNI_nonlin_coeff.nii.gz")

    t1_mni_output = os.path.join(sub_dir, f"{subject}_T1_MNI.nii.gz")

    # 1. **Align T1 to MPRAGE (subject space)**
    flirt_t1_to_mprage = [
        f"{FSLDIR}/bin/flirt",
        "-in", t1_input,
        "-ref", mprage_file,
        "-omat", affine_t1_to_mprage,
        "-out", t1_to_mprage,
        "-dof", "12"  # Rigid-body transformation
    ]
    subprocess.run(flirt_t1_to_mprage, check=True)

    # 2. **Move MPRAGE to MNI152 space (linear)**
    flirt_mprage_to_mni = [
        f"{FSLDIR}/bin/flirt",
        "-in", mprage_file,
        "-ref", MNI_TEMPLATE,
        "-omat", affine_mprage_to_mni,
        "-out", mprage_to_mni,
        "-dof", "12"
    ]
    subprocess.run(flirt_mprage_to_mni, check=True)

    # 3. **Refine MPRAGE to MNI using FNIRT (nonlinear)**
    fnirt_mprage_to_mni = [
        f"{FSLDIR}/bin/fnirt",
        f"--in={mprage_file}",
        f"--ref={MNI_TEMPLATE}",
        f"--aff={affine_mprage_to_mni}",
        f"--config={MY_CONFIG_DIR}/config/bb_fnirt.cnf",
        f"--cout={fnirt_coeff}",
        f"--iout={mprage_to_mni_nonlin}",
        "--interp=spline"
    ]
    subprocess.run(fnirt_mprage_to_mni, check=True)

    # 4. **Apply the same transformation to the T1 map**
    applywarp_t1_to_mni = [
        f"{FSLDIR}/bin/applywarp",
        f"--in={t1_input}",
        f"--ref={MNI_TEMPLATE}",
        f"--warp={fnirt_coeff}",
        f"--premat={affine_t1_to_mprage}",
        f"--out={t1_mni_output}",
        "--interp=spline"
    ]
    subprocess.run(applywarp_t1_to_mni, check=True)

    print(f"✅ {subject} T1 map successfully registered to MNI space.")




def main(data_dir, output_dir, subject):
    os.makedirs(output_dir, exist_ok=True)

    sub_dir = os.path.join(output_dir, subject)
    os.makedirs(sub_dir, exist_ok=True)

    # # Input MR parameters
    # nTIs=8; 
    # MBfactor=2; 
    # TR=4500
    # sliceOffsets=[0,12,24,36,48,60,72,84]
    # minTI=32 

    subject_path = os.path.join(data_dir, subject, "T1mapping")
    print(f"Processing subject: {subject}")

    # Get all matching .nii files
    #all_nifti_files = glob.glob(os.path.join(subject_path, "*T1mapping*.nii"))
    #all_nifti_files = glob.glob(os.path.join(subject_path, "fixed_wh_1mm*.nii"))
    all_nifti_files = glob.glob(os.path.join(subject_path, "fixed_T1mapping*.nii"))	

    # Enforce correct pattern with regex
    #t1_files = [f for f in all_nifti_files if re.search(r"(?<!_ph)\.nii$", f) and "real" not in f and "imaginary" not in f]
    #ph_files = [f for f in all_nifti_files if re.search(r"_ph\.nii$", f) and "real" not in f and "imaginary" not in f]

    # Enforce correct pattern using regex
    #t1_files = [f for f in all_nifti_files if re.search(r"fixed_wh_1mm.*01\.nii$", f)]
    #ph_files = [f for f in all_nifti_files if re.search(r"fixed_wh_1mm.*01_ph\.nii$", f)]
    t1_files = [f for f in all_nifti_files if re.search(r"fixed_T1mapping.*01\.nii$", f)]
    ph_files = [f for f in all_nifti_files if re.search(r"fixed_T1mapping.*01_ph\.nii$", f)]

    # Locate required files
    #t1_files = [f for f in glob.glob(os.path.join(subject_path, "*T1mapping*.nii")) if "real" not in f and "imaginary" not in f]
    #ph_files = [f for f in glob.glob(os.path.join(subject_path, "*T1mapping*_ph.nii")) if "real" not in f and "imaginary" not in f]

    if not t1_files or not ph_files:
        print(f"  Missing required files for {subject}, skipping...")
        return
    

    t1_file = t1_files[0]  # Use the first match
    ph_file = ph_files[0]

    # Define temporary output filenames
    t1_trimmed = os.path.join(sub_dir, "T1mapping_clv.nii.gz")
    ph_trimmed = os.path.join(sub_dir, "T1mapping_clv_ph.nii.gz")

    # Remove last dynamic (9 -> keep first 8)
    subprocess.run(["fslroi", t1_file, t1_trimmed, "0", "8"], check=True)
    subprocess.run(["fslroi", ph_file, ph_trimmed, "0", "8"], check=True)

    # Load trimmed data
    imgm = nib.load(t1_trimmed)
    imgm_img = imgm.get_fdata()
    imgp = nib.load(ph_trimmed)
    imgp_img = imgp.get_fdata()

    # 🔥 Fix for DICOM phase values (divide by 1000)
    #imgp_img = imgp_img / 1000.0

    # Save the corrected phase image back
    #imgp_corrected = nib.Nifti1Image(imgp_img, affine=imgp.affine, header=imgp.header)
    #nib.save(imgp_corrected, ph_trimmed)  # Overwrite the original file

    # ✅ Print min/max phase values
    #print(f"Min phase value: {np.min(imgp_img)}")
    #print(f"Max phase value: {np.max(imgp_img)}")

    #print(f"Fixed phase NIfTI saved to: {ph_trimmed}")

    imgm_header=imgm.header
    dimensions=imgm_header['dim']
    nX=dimensions[1]
    nY=dimensions[2]
    nS=dimensions[3]
    nTIs=dimensions[4]
    nS_MB1=int(nS/MBfactor); #number of slices per band
    Tseg=TR/nS_MB1; 

    #TIs=(0:1:(nS_MB1-1))*Tseg+ones(1,nS_MB1)*44.5; 
    TIs = minTI + Tseg*np.arange(0,nS_MB1,1,dtype=float)

    #TIs=repmat(TIs,[1 MBfactor]);
    TIs=np.tile(TIs,(1,MBfactor))

    # Default ascend order goes from 1 to nS
    default=np.arange(1,nS_MB1+1,1)

    ascend=np.zeros((len(sliceOffsets),nS))
    ascendMB1=np.zeros((len(sliceOffsets),nS_MB1))


    for sJump in range(0,len(sliceOffsets)):
        ascendMB1[0:nS_MB1-1][sJump]=np.roll(default,-sliceOffsets[sJump])
        #ascendMB1[sJump, 0:nS_MB1-1] = np.roll(default, -sliceOffsets[sJump])


    if MBfactor>1:
        for sJump in range(0,len(sliceOffsets)):
            ascend[sJump]=np.tile(ascendMB1[sJump], (1,MBfactor))
            for iBand in range(2,MBfactor+1,1):
                firstslice=nS_MB1*(iBand-1)
                subslices=np.arange(firstslice,nS_MB1*iBand)
                ascend[sJump][subslices]=ascend[sJump][subslices]+nS_MB1*(iBand-1); # this needs to be fixed-how to acces pat of the array
    else: 
        ascend=ascendMB1



    sortTI=np.zeros((len(sliceOffsets),nS))
    sortTIindex=np.zeros((len(sliceOffsets),nS),dtype=int)
    sortTI2=np.zeros((len(sliceOffsets),nS))

    modData=np.zeros((nX,nY,nS,nTIs))
    phData=np.zeros((nX,nY,nS,nTIs))

    TI_slice=np.zeros((len(sliceOffsets),nS))
    for iSlice in range(0,nS): 
        for sJump in range (0,len(sliceOffsets)):
            #put into TI_slice the actual TI based on TIs array
            a=[int(y-1) for y in ascend[sJump]] 
            if iSlice in a:
                TI_slice[sJump][iSlice]=TIs[0][a.index(iSlice)]

    sortTI=np.sort(TI_slice,axis=0)
    sortTIindex=np.argsort(TI_slice,axis=0)


    for iSlice in range(0,nS): 
        # use this slice as a test
         #range(0,nS): 
        #Need to sort data so that TIs etc are in increasing order
        index=sortTIindex[:,iSlice]
        modData[:,:,iSlice,:]=imgm_img[:,:,iSlice,index]; 
        phData[:,:,iSlice,:]=imgp_img[:,:,iSlice,index]; 


    rearranged_img = nib.Nifti1Image(modData, None, header=imgm.header)
    rearranged_img.to_filename(os.path.join(sub_dir, "modulus_rearranged.nii.gz"))
    rearranged_phs = nib.Nifti1Image(phData, None, header=imgp.header)
    rearranged_phs.to_filename(os.path.join(sub_dir, "phase_rearranged.nii.gz"))

     # Load mask

     # create a mask here
    #subprocess.run(["bet", t1_file, os.path.join(sub_dir, "T1_brain"), "-m", "-Z", "-R", "-f", "0"], check=True)

    subprocess.run(["fslmaths", t1_file, "-Tmean", os.path.join(sub_dir, "T1_tmean.nii.gz")], check=True)
    subprocess.run(["fslmaths", os.path.join(sub_dir, "T1_tmean.nii.gz"), "-bin", os.path.join(sub_dir, "T1_tmean_bin.nii.gz")], check=True)
    subprocess.run(["fslmaths", os.path.join(sub_dir, "T1_tmean_bin.nii.gz"), "-kernel", "sphere", "3", "-dilF", os.path.join(sub_dir, "T1_brain_mask.nii.gz")], check=True)

    maskData = nib.load(os.path.join(sub_dir, "T1_brain_mask.nii.gz")).get_fdata()
    maskDatai = maskData.astype(int)

    # T1 fit routine:
    T1fit=np.zeros((nX,nY,nS))
    M0fit=np.zeros((nX,nY,nS))
    alphafit=np.zeros((nX,nY,nS))
    r2fit=np.zeros((nX,nY,nS))
    e2fit=np.zeros((nX,nY,nS))
    modSlice=np.zeros((nX,nY,nS))

    #print(type(nX))
    sisl=int(nX)*int(nY)*int(nTIs)
    nXY=int(nX)*int(nY)
    phSlice=np.zeros((nX,nY,nTIs))#float64 by default
    phDiff0=np.zeros((sisl,1))
    phDiff=np.zeros((nX,nY,nTIs))
    phDiff2=np.zeros((nXY,nTIs))
    indices=np.zeros((nXY,nTIs),dtype=bool)
    modSlice=np.zeros((nX,nY,nS))
    modSlice2=np.zeros((int(nX)*int(nY),nS))

    #for iSlice in range(115,116):#(0,nS) (82,83)
    for iSlice in range(0,nS):#(0,nS) (82,83)
        start_time = time.time()
    #     if maskDatab[:,:,iSlice]:  
        print('Computing slice '+str(iSlice), flush=True)
        modSlice= modData[:,:,iSlice,:]
        phSlice = phData[:,:,iSlice,:]
        maskSlice = maskDatai[:,:,iSlice]
        
        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        #Perform correction of modulus polarity based on phase 
        #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ## get phase reference
    
            ## get phase reference
        phRef = phSlice[:,:,-1]
    
        phDiff = np.repeat(phRef,nTIs,axis=1).reshape(nX,nY,nTIs) - phSlice;
        ## add 2*pi to locations where PH < 0
        phDiff0=phDiff.ravel()
        aa=phDiff0<0
        phDiff0[aa]=phDiff0[aa]+2*np.pi
    
        phDiff2 = phDiff0.reshape(nXY,nTIs)

            
        modSlice2 = np.reshape(modSlice,(nXY,nTIs))
        maskSlice2 = np.reshape(maskSlice,(nXY,1))

        print("doing phase correction")
        for ipix in range(0,nXY):
            i_jump=nTIs-1
            while i_jump >= 0: #range(nTIs-1,0,-1):
                indices[ipix,i_jump] = np.equal(np.greater(phDiff2[ipix,i_jump],np.pi/2), \
                                            np.less(phDiff2[ipix,i_jump],3*np.pi/2))
                if indices[ipix,i_jump]:
                    for i_jumpi in range(0,i_jump+1):
                        modSlice2[ipix,i_jumpi] = -modSlice2[ipix,i_jumpi]
                        indices[ipix,i_jumpi]=True
                    break
                else:
                    i_jump=i_jump-1
        

            
        #Perform fit and save result for this slice
        t1,m0,r2,e2=fitT1_try(sortTI[:,iSlice],modSlice2,maskSlice2)

        
        #save results in 3D array
        T1fit[:,:,iSlice]=np.reshape(t1,(nX,nY))
        M0fit[:,:,iSlice]=np.reshape(m0,(nX,nY))
        #alphafit[:,:,iSlice]=np.reshape(alpha,(nX,nY))
        r2fit[:,:,iSlice]=np.reshape(r2,(nX,nY))
        e2fit[:,:,iSlice]=np.reshape(e2,(nX,nY))
        print("--- %s seconds ---" % (time.time() - start_time), flush=True)
  
    # save out data
    t1img=nib.nifti1.Nifti1Image(T1fit, imgm.affine)

    
    #t1img.to_filename(sub_dir+'_T1.nii.gz')  
    t1img.to_filename(os.path.join(sub_dir, subject+"_T1.nii.gz"))
    m0img=nib.nifti1.Nifti1Image(M0fit, imgm.affine)
    #m0img.to_filename(sub_dir+'_M0.nii.gz') 
    m0img.to_filename(os.path.join(sub_dir, subject+"_MO.nii.gz"))
    #alphaimg=nib.nifti1.Nifti1Image(alphafit, imgm.affine)
    #alphaimg.to_filename(sub_dir+'_alpha.nii.gz')  
    r2img=nib.nifti1.Nifti1Image(r2fit, imgm.affine)
    #r2img.to_filename(sub_dir+'_R2.nii.gz')
    r2img.to_filename(os.path.join(sub_dir,subject+"_R2.nii.gz"))
    e2img=nib.nifti1.Nifti1Image(e2fit, imgm.affine)
    #e2img.to_filename(sub_dir+'_E2.nii.gz') 
    e2img.to_filename(os.path.join(sub_dir,subject+"_E2.nii.gz"))


    register_t1_to_mni(sub_dir, subject, data_dir)




if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="T1 Mapping Script")
    parser.add_argument("-d", "--data_dir", required=True, help="Base data directory")
    parser.add_argument("-o", "--output_dir", required=True, help="Output directory")
    parser.add_argument("-s", "--subject", required=True, help="Subject ID")

    args = parser.parse_args()
    main(args.data_dir, args.output_dir, args.subject)







    



