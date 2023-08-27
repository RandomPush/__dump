#!/system/bin/sh
#
#ifdef VENDOR_EDIT
#huacai.zhou@PSW.BSP.kernel.drv, 2018/03/09, adjust zram size according to total ram size
MemTotalStr=`cat /proc/meminfo | grep MemTotal`
MemTotal=${MemTotalStr:16:8}

if [ $MemTotal -le 2097152 ]; then
  #config 1.25GB zram size with memory less than 2 GB
  echo zstd > /sys/block/zram0/comp_algorithm
  echo 1610612736 > /sys/block/zram0/disksize
  echo 180 > /proc/sys/vm/swappiness
  echo 30 > /proc/sys/vm/direct_swappiness
  echo 3 > /sys/module/lowmemorykiller/parameters/almk_swap_ratio1
  echo 3  >/sys/module/lowmemorykiller/parameters/almk_totalram_ratio
  #echo 10 > /proc/sys/vm/watermark_scale_factor
elif [ $MemTotal -le 3145728 ]; then
  #config 1.6GB zram size with memory less than 3 GB
  echo zstd > /sys/block/zram0/comp_algorithm
  echo 1610612736 > /sys/block/zram0/disksize
  echo 180 > /proc/sys/vm/swappiness
  echo 0 > /proc/sys/vm/direct_swappiness
  echo 3 > /sys/module/lowmemorykiller/parameters/almk_swap_ratio1
  echo 3  >/sys/module/lowmemorykiller/parameters/almk_totalram_ratio
elif [ $MemTotal -le 4194304 ]; then
  #config 2GB zram size with memory less than 4 GB
  echo lz4 > /sys/block/zram0/comp_algorithm
  echo 2684354560 > /sys/block/zram0/disksize
  echo 160 > /proc/sys/vm/swappiness
  echo 60 > /proc/sys/vm/direct_swappiness
  echo 4 > /sys/module/lowmemorykiller/parameters/almk_swap_ratio1
  echo 4  >/sys/module/lowmemorykiller/parameters/almk_totalram_ratio
elif [ $MemTotal -le 6291456 ]; then
  #config 2.25GB zram size with memory 6 GB
  echo lz4 > /sys/block/zram0/comp_algorithm
  echo 3221225472 > /sys/block/zram0/disksize
  echo 160 > /proc/sys/vm/swappiness
  echo 60 > /proc/sys/vm/direct_swappiness
  echo 6 > /sys/module/lowmemorykiller/parameters/almk_swap_ratio1
  echo 6  >/sys/module/lowmemorykiller/parameters/almk_totalram_ratio
else
  #config 2.25GB zram size with memory greater than 6 GB
  echo lz4 > /sys/block/zram0/comp_algorithm
  echo 4294967296 > /sys/block/zram0/disksize
  echo 160 > /proc/sys/vm/swappiness
  echo 60 > /proc/sys/vm/direct_swappiness
  echo 8 > /sys/module/lowmemorykiller/parameters/almk_swap_ratio1
  echo 6  >/sys/module/lowmemorykiller/parameters/almk_totalram_ratio
fi
mkswap /dev/block/zram0
swapon /dev/block/zram0
#endif /* VENDOR_EDIT */
