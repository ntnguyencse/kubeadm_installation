# Setup NVIDIA Driver and CUDA Driver for NVIDIA Tesla for Ubuntu 18.04

Ref: [NVIDIA Installation Guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)

## Setup NVIDIA 

### 1. NVIDIA Driver Installation
#### Step 1: Ensure your GPU is an NVIDIA GPU
The first thing one needs to do, is ensure that the GPU is an NVIDIA GPU with the following command:
```
 ubuntu-drivers devices
```
#### Step 2: Remove NVIDIA drivers
The first thing one needs to do is run the following commands to ensure any preinstalled driver is purged:
```
sudo apt-get autoremove
sudo apt-get remove nvidia*
sudo apt-get purge cuda*
```
#### Step 3: Disable Nouveau NVIDIA driver
This step is sometimes not necessary after the previous one, but I strongly recommend doing it anyway (doing it doesn’t hurt!).
First, you need to open the blacklist-nouveau.conf file (I use gedit, but feel free to use any other type of editor). The command I use is the following:
```
 sudo vi /etc/modprobe.d/blacklist-nouveau.conf
```
Now, add the following lines to the file.
```
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
```
Save and close the file.
Disable the Kernel nouveau:
```
echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
```
#### Step 4: Add PPA drivers respository
To add the ppa:graphics-drivers/ppa repository into your system type the following command:
```
sudo add-apt-repository ppa:graphics-drivers/ppa
```
#### Step 5: Install NVIDIA Drivers
In the past, I used to download the drivers from the [NVIDIA download Site](https://www.nvidia.co.uk/Download/index.aspx?lang=en-uk).
The simplest and most reliable way to do it (this has been the direct recommendation from NVIDIA on one of my posts on the NVIDIA forum) is to install it directly from the terminal. The command to install the drivers would be (ensure you install the right driver!):
```
sudo apt install nvidia-driver-435
```
The other option is to install it directly from the Software & Updates settings in Ubuntu:

Now, chose the correct driver (this is the tricky bit, you might have to come back and test a new driver if this step hasn’t worked). Click on Apply Changes, and you are good to go!
### Step 6: Reboot your computer
Don’t forget this step!
#### Step 7: Check that the drivers are working
You will know that the installation has been successful by typing the following command:
```
nvidia-smi
```
You should see something similar to

If you get an NVIDIA error here, try all the steps from the beginning, but choosing a new driver this time!


## Setup CUDA

When installing CUDA, I usually follow the CUDA installation guide, which is very complete [NVIDIA Installation Guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html).
#### Step 1: Preinstallation checks
First check that your GPU is can deal with CUDA:
```
lspci | grep -i nvidia
```
Check you have a supported Linux version:
```
uname -m && cat /etc/*release
```
This should return something like
```
x86_64
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION=”Ubuntu 18.04.3 LTS”
NAME=”Ubuntu”
VERSION=”18.04.3 LTS (Bionic Beaver)”
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME=”Ubuntu 18.04.3 LTS”
VERSION_ID=”18.04"
HOME_URL=”https://www.ubuntu.com/"
SUPPORT_URL=”https://help.ubuntu.com/"
BUG_REPORT_URL=”https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL=”https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
```
Check gcc is installed
```
gcc --version
```
Check your kernel headers are compatible with CUDA (you can find the compatibility table on the CUDA installation guide):
```
uname -r
```
Install the kernel headers and packages with the following command:
```
sudo apt-get install linux-headers-$(uname -r)
```
Step 2: Download CUDA
You can download the CUDA toolkit through the following link:
[CUDA Toolkit 10.1 Update 2 Download](https://developer.nvidia.com/cuda-downloads)

For Ubuntu 18.04 you need to download the following

Now, you just need to wait, this download might take a while!
#### Step 3: Install CUDA
The steps to install CUDA are pretty simple. 
Select the target platform, architecture, distribution, Version and Installer type. (Ex: Linux -> x86_64 -> Ubuntu -> 18.04 -> deb(network))
Install CUDA through network is preferrable.

Some commands will show like below:
Just copy and run every command one by one: 
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
sudo apt-get update
sudo apt-get -y install cuda
```
#### Step 5: Post installation setup:
Ref: [Post Installation setup action](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions)
- Enviroment Setup: 
  - To add this path to the PATH variable:
 ``` 
 export PATH=/usr/local/cuda-11.6/bin${PATH:+:${PATH}}
```
- To change the environment variables for 64-bit operating systems:
```
export LD_LIBRARY_PATH=/usr/local/cuda-11.6/lib64\
                         ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```
#### Step 4: Test CUDA drivers

CLone this repo from NVIDIA [NVIDIA Samples Repo](https://github.com/NVIDIA/cuda-samples)

Go to folder cuda-samples:
Build all test program in cuda-samples project
```
make
```
More make options can find in [NVIDIA Samples README file](https://github.com/NVIDIA/cuda-samples)

Run all test when build finished:
- Go to folder: /bin/x86_64/linux/release
- Run this bash commands:
```
search_dir=.
let idx=0
for entry in "$search_dir"/*
do
echo -e "=== TEST $idx === \n"
echo -e "=== File: $entry === \n\n"
  echo -e $($entry)
  echo -e "\n=== END TEST $idx \n\n"
 let  idx++
done
```

Using command "nvidia-smi" to see the workloads on GPU
