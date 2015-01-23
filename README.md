jtfa-pcg-analysis
=================

Heart murmur detection/analysis from phonocardiogram recordings using Matlab/Octave

The sample .wav files are as follows:
normal.wav      - A normal heartbeat
asd.wav         - Heart sounds induced by an atrial septal defect (a hole in the wall separating the atria)
pda.wav         - Heart sounds induced by patent ductus arteriosus (a condition wherein a duct between the aorta and pulmonary artery fails to close after birth)
diastolic.wav   - Heart sounds induced by a diastolic murmur (leaking in the atrioventricular or semilunar valves)

The heart sound files provided are for individual testing purposes only, and are taken from: https://depts.washington.edu/physdx/heart/demo.html

The pcg_analysis_ function currently does the following:
<ul>
 <li>Reads the heart sound recording provided (in .wav format)</li>
 <li>Decimates the original recording into a lower sample rate</li>
  <ul>
   <li>acts as both a low-pass filter for noise</li>
   <li>reduces processing time</li>
  </ul>
 <li>Separates the recording into discrete heart sounds</li>
 <li>Applies an 8th order Daubechies continuous wavelet transform on each sound</li>
 <li>Averages the systolic and diastolic transforms</li>
</ul>
This provides a clean systolic and diastolic heart sound reference for the patient that can be analyzed for abnormalities.

A sample output (normal.wav) is below:
![](https://github.com/casualformality/jtfa-pcg-analysis/blob/master/normal.png)

The red and green symbols indicate where the script has determined the beginning of each sound to be.

Projected additional features include:
<ul>
<li>Listing of heart rate</li>
<li>Cleaner analysis of irregular heart sounds</li>
<li>Vector Support Network or Neural Network to automatically determine the presence of a heart murmur.</li>
</ul>
