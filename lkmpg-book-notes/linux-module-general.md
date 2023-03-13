# Linux module general knowledge

## 1. Useful tools for manage module

### Installation
    sudo apt install build-essential kmod

### Usage
    查看内核里面有哪些module:
    sudo lsmod

    关于module的更加详细的信息：
    sudo cat /proc/modules

    插入一个module到内核：
    sudo insmod *.ko

    查看module插入过程中内核的活动：
    sudo dmesg

    查看一个module的信息：
    modinfo *.ko

    移除一个module:
    sudo rmmod 'name_of_module'

### 编写module的要点

    一个module最少需要两个函数， 第一个是init_module(),在使用 insmod 插入module 的时候这个函数会被调用，
    第二个是cleanup_module(), 在使用rmmod移除module的时候这个函数会被调用。

    在较新的内核中，可以通过使用 module_init 和 module_exit 宏标记内核插入时调用的函数和内核移除时调用的函数，可以不必使用 init_module 和 cleanup_module 这两个函数名，而是使用任意的函数名。

    module 的源代码中必须包含 <linux/module.h> 头文件。

    源代码中包含 <linux/printk.h> 可以引入内核提供的打印函数，方便调试。
    可以使用 printk() 函数来打印信息，也可以使用 pr_info() 和 pr_warn().

    内核提供的 module 的build 文档： 
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Documentation/kbuild/modules.rst

	内核提供的makefiles文档：
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Documentation/kbuild/makefiles.rst

	内核模块接受从命令行传入的参数，具体步骤如下：
		（1） 首先在内核模块的源代码中申明全局变量（一般需要初始化），可以时基本数据类型，也可以是数组，字符串。
		（2） 在模块源代码中使用 module_parm() 宏来修饰声明的变量，module_parm 使用格式如下
			module_parm(变量名，变量类型，变量在文件系统的中的权限)。
		（3） MODULE_PARM_DESC 宏可以用来对变量做进一步的注释，使用方式如下：
			MODULE_PARM_DESC(变量名，“解释该变量的字符串”)
		（4） 对于数组，可以使用 module_parm_array 来进行修饰。

    查看内核里面的symbol 的方法：
        sudo cat /proc/kallsyms  
    
    在Linux系统上，所有的硬件都在/dev/* 目录下面有一个设备文件（device file）表示. 这个设备文件提供了访问对应的硬件的方法。  
    可以使用 ls -al /dev/ 来查看设备的主设备号（major number） 和 次设备号 （minor number）. 每个驱动都有一个独一无二的  
    设备号，所有具有相同主设备号的设备文件都使用相同的设备驱动。次设备号是设备驱动用来区别自己所控制的不同设备。

    设备可以分为**字符设备**和**块设备**，区别在于（1）块设备有缓冲区，这使得块设备可以以最好的顺序来响应请求。（2）块设备的  
    输入和输出必须以**块**为单位。

    使用 ls -al /dev/* 查看输出，第一个字符是‘c’表示这个设备文件对应于字符设备，‘b’表示这个设备文件对应块设备。

    设备文件可以使用 mknod 命令创建，命令格式如下：
        mknod /dev/foo 'c' or 'b' major-number  minor-number
    
    当一个设备文件被访问时，kernel 通过主设备号来决定使用哪个设备驱动来访问该设备文件， kernel不关心次设备号，设备驱动使用次设备号来  
    区别具体的设备。

    