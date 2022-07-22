# cli-tools
Rust, Go, etc. tools that are manually built.

root@2d24c231a2ee:/go# smbclient -U marsh //srv2/documents --directory files -c 'put /etc/hostname hostname'
Enter WORKGROUP\marsh's password:
putting file /etc/hostname as \files\hostname (4.2 kb/s) (average 4.2 kb/s)
root@2d24c231a2ee:/go# smbclient -U marsh //srv2/documents --directory files -c 'get test.txt'
Enter WORKGROUP\marsh's password:
getting file \files\test.txt of size 6 as test.txt (2.0 KiloBytes/sec) (average 2.0 KiloBytes/sec)

