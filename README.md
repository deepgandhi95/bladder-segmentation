# bladder-segmentation

Description:
This Matlab code provides a graphical user interface (GUI) for segmenting the bladder in DICOM MR images. The GUI allows the user to load a set of bladder MR image, select the bladder region semi-automatically, and save the segmented image mask to obtain bladder volume.

Requirements:
This code requires Matlab 2016b or later; 
Image Processing Toolbox (thresh_tool.m); 
The volume calculation is done using bladder_volume_code.m 

Usage:

Run the "Bladder_Volume_GUI.m" file in Matlab to open the GUI.
Use the "Load Images" button to select an image file.
Use the "Select Region" button to select the bladder region in the image.
You can use the "add" and "remove" options to change the selected regions.
You can also use the "Reset" button to clear the current selection and start over.

Input:
Series of bladder DICOM images 

Output:
Binary segmentation mask of the bladder
Bladder volume in cm^3 (ml)

Notes:
The code has been tested only .dcm images and will not work with .nii images.

Author:
Deep B. Gandhi
