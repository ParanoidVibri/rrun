# rrun


## What is rrun?
rrun is a program for Unix-like computer operating systems that enables users to run programs with the security privileges of another user, by default the superuser.

## Is rrun meant to replace sudo and/or doas?
Not at all! this project was just made for fun and testing and is not meant to replace anything.

## How do I install rrun?
You can either manually install it from source, or use your Linux distrubution's package manager!

### MANUALLY INSTALLING rrun
First, use ``git`` to fetch/clone this repository, which has the main code for rrun.

```
git clone https://github.com/ParanoidVibri/rrun/
```

Then, ``cd`` into the folder the rrun repository has been cloned into.

```
cd rrun
```

After that, you need to make it into an executable,

```
chmod +x rrun.sh
```

Then, before installing rrun, remove the ``.sh`` extention from the name as you dont need it anymore, this is optional, but highly recommended.

If you are in a graphical environment, you can simply open your file manager of choice, right click the ``rrun.sh`` file

In a TTY? No problem!, use ``mv`` to rename the file!

```
mv rrun.sh rrun
```

After allat, you should move your rrun into your $PATH, Before we do that, we should check what's out $PATH, it should be ``/usr/bin``, ``/usr/local/bin`` or ``/usr/sbin``

```
echo $PATH
```
-# checking the $PATH

Then, after you know where your $PATH is, move rrun into the $PATH!

In this example, we will use ``/usr/bin`` as the $PATH.

```
mv rrun /usr/bin
```
Note that you do need root privileges in order to move rrun into your $PATH.

And thats it! rrun is succesfully installed manually!

### PACKAGE MANAGER
This is a more simpler method, note that rrun does not support some distros.

#### ARCH
```
yay -S rrun
```
or
```
paru -S rrun
```

#### GENTOO 
Enable the GURU repository
```
eselect repository enable guru
```
(requires the ``app-eselect/eselect-repository`` package)
(needs root privileges)

Sync the GURU repository
```
emerge --sync
```
(also needs root privileges)
or
```
emaint sync --repo guru
```

Now that the GURU repository has been enabled, we are good to go to install rrun!
```
emerge app-admin/rrun
```
(root privileges required)
