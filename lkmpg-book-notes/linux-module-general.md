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
