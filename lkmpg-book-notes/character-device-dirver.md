# Character Device Driver
## 文件操作函数结构体 struct file_operations 

这个结构体定义在 include/linux/fs.h 文件中，这个结构体中放置着指向函数的指针，这些函数就是设备驱动提供的在设备上进行的特定操作。有的设备可能没有  
某个操作，那么这个结构体中对应的函数指针应该被设置为NULL.

这个结构体的初始化可以使用两种GCC语法,比较新的GCC提供的语法是：
    
    struct file_operations fops = {
        read: device_read,
        write： device_write,
        open: device_open,
        release: device_release
    };

在C99中提供的结构体初始化语法：

    struct file_operations fops = {
        .read = device_read,
        .write = device_write,
        .open = device_open,
        .release = device_release
    };

使用第二种语法可以更好的和之前的内核驱动兼容。


## 向内核登记一个设备

添加一个驱动（driver）到系统意味着向kernel登记它。这个过程中需要向内核申请一个主设备号。可以使用以下函数来向内核登记设备：
    
    int register_chrdev(unsigned int major, const char *name, struct file_operations *fops);

major 参数是驱动开发者想向内核申请的主设备号，name 参数用来在 /proc/devices 文件中表示驱动。fops 参数是驱动提供的函数指针集合。  
如果这个函数返回负值，说明登记请求失败。使用这个函数有个缺点，需要驱动开发者自己决定使用哪个主设备号，这有可能和别的设备的主设备号  
冲突。

解决这个问题的思路是让内核动态地为设备分配主设备号，如果在调用 register_chrdev 函数的时候让 major 参数为0， 则该函数返回内核动态  
分别的主设备号。


向内核登记一个字符设备的推荐方法是使用 cdev 接口，这个新的推荐方法分2步来完成字符驱动登记。  
第一步，先向内核登记设备号，这个任务可以  
由两个函数完成：

    int register_chrdev_region(dev_t from, unsigned count, const char *name);
    int alloc_chrdev_region(dev_t *dev, unsigned baseminor, unsigned count, const char *name);

这个两个函数的区别在于开发者是否知道设备的主设备号，如果已经知道设备的主设备号则使用 register_chrdev_region, 否则使用alloc_chrdev_region.

第二步是初始化一个 struct cdev 数据结构并且将这个数据结构和申请的主设备号联系起来。

    struct cdev *my_dev = cdev_alloc();
    my_cdev->ops = &my_fops;

在实践中，对struct cdev常用的使用方法是将其嵌入一个设备开发者自己定义的一个和具体设备相关的结构体中，然后使用 cdev_init 来初始它：

    void cdev_init(struct cdev *cdev, const struct file_operations *fops);





