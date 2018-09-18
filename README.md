# VirtualOA
VirtualOA is a graphical user interface based toolbox for conducting virtual experiments of optoacoustic imaging on a simplified model of a blood vessel embedded in a homogeneous medium [1]. The goal of this work is to provide a user-friendly virtual lab  to enhance the experimental design in optoacoustic imaging.

##  HOW TO START GUI
Run GUI_main.m in MATLAB environment.

## MAIN FUNCTIONS
Three modes are allowed,
### Single Forward 
forward simulation runs using the parameters from the column of
Reference. Result is shown on the button right axes on the Forward result panel.
### ContinuousForward
forwardsimulationrunsusingtheparametersfromthecolumnof
Manual Fitting. Result is shown on the button right axes on the Forward result panel.
### Reconstruction
inverse problem is solved using the parameters from the column of Initial guess and the result of Single Forward. Result is shown on the Reconstruction result panel.

## OTHER FUNCTIONS 
### ADD NOISE
Users can change the noise level n% which is implemented in a simple way noisy result s  = s · 2 · n % · (0.5 − ξ), where s is the resultant ratio data and ξ = r a n d .
### NUMBER OF PROBES AND DISTANCES BETWEEN PROBES AND THE VESSEL
The minimal number of probes is 1. By default, the Probe 1 is located in the center of the surface of the bulk and blood vessel is located at (0, dis1); if number of probes is 2, probe 2 is placed at (dis2, 0); if three or more probes are used, the other probes are placed between probe 1 and Probe 2 with the same distance between two neighbor probes. In the button right part of the parameter panel, users are allowed to change change number of probes, the distance between probe 1 and the vessel (dis1) and the distance between probe 1 and 2 (dis2).
### PLOT SPECTRA OF COEFFICIENTS
In the Single Forward mode, by clicking the radio button plot spectra of coefficients, the result
will be shown in the third display panel Spectra of coefficients.
### PLOT FLUENCE
In the Single Forward mode, by clicking the radio button plot fluence, the result will be dis- played in the button left of the panel Forward result. The signal of ultrasound for probe 1 is shown in the terms of the product of absorption of the blood vessel and the fluence calculated by Green function.
### PLOT ULTRASOUND SIGNAL level
In the Single Forward mode, by clicking the radio button plot ultrasound signal, spectra of intensities of signals gathered from all probes will be shown on the top right axes of the display panel Forward result.

## CROSS-PLATFORM COMPATIBILITY
This program has been so far tested successfully in different Operating Systems including windows 7 and OS X. In order to show the UI properly, the font size should be set ’100%’ or ’Default’ for the OS. The earliest MATLAB version tested so far is MATLAB 2013b.

The GUI is designed to be self-explained, but detailed documentation will come soon ...
 
[1] Jiang J. et al. (2018) A New Method Based on Virtual Fluence Detectors and Software Toolbox for Handheld Spectral Optoacoustic Tomography. In: Thews O., LaManna J., Harrison D. (eds) Oxygen Transport to Tissue XL. Advances in Experimental Medicine and Biology, vol 1072. Springer, Cham
