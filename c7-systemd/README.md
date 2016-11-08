# 安装带systemd的CentOs7

## CentOS image documentation
The `centos:latest` tag is always the most recent version currently available.

### Rolling builds

The CentOS Project offers regularly updated images for all active releases. These images will be updated monthly or as needed for emergency fixes. These rolling updates are tagged with the major version number only. For example: `docker pull centos:6` or `docker pull centos:7`

### Minor tags

Additionally, images with minor version tags that correspond to install media are also offered. These images DO NOT recieve updates as they are intended to match installation iso contents. If you choose to use these images it is highly recommended that you include RUN yum -y update && yum clean all in your Dockerfile, or otherwise address any potential security concerns. To use these images, please specify the minor version tag:

For example: `docker pull centos:5.11` or `docker pull centos:6.6`

Package documentation
By default, the CentOS containers are built using yum's nodocs option, which helps reduce the size of the image. If you install a package and discover files missing, please comment out the line tsflags=nodocs in /etc/yum.conf and reinstall your package.

### Systemd integration
Systemd is now included in both the centos:7 and centos:latest base containers, but it is not active by default. In order to use systemd, you will need to include text similar to the example Dockerfile below:

Dockerfile for systemd base image
```
FROM centos:7
MAINTAINER "you" <your@email.here>
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
```
This Dockerfile deletes a number of unit files which might cause issues. From here, you are ready to build your base image.
```
$ docker build --rm -t local/c7-systemd .
```
Example systemd enabled app container

In order to use the systemd enabled base container created above, you will need to create your Dockerfile similar to the one below.
```
FROM local/c7-systemd
RUN yum -y install httpd; yum clean all; systemctl enable httpd.service
EXPOSE 80
CMD ["/usr/sbin/init"]
```

Build this image:
```
$ docker build --rm -t local/c7-systemd-httpd
```
Running a systemd enabled app container

In order to run a container with systemd, you will need to mount the cgroups volumes from the host. Below is an example command that will run the systemd enabled httpd container created earlier.
```
$ docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 local/c7-systemd-httpd
```
This container is running with systemd in a limited context, with the cgroups filesystem mounted. There have been reports that if you're using an Ubuntu host, you will need to add -v /tmp/$(mktemp -d):/run in addition to the cgroups mount.

### Supported Docker versions
This image is officially supported on Docker version 1.12.3.

Support for older versions (down to 1.6) is provided on a best-effort basis.

Please see the Docker installation documentation for details on how to upgrade your Docker daemon.

## User Feedback
### Issues

If you have any problems with or questions about this image, please contact us by submitting a ticket at https://bugs.centos.org or through a GitHub issue. If the issue is related to a CVE, please check for a cve-tracker issue on the official-images repository first.

You can also reach many of the official image maintainers via the #docker-library IRC channel on Freenode.

### Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans by submitting a ticket at https://bugs.centos.org or through a GitHub issue, especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

### Documentation

Documentation for this image is stored in the centos/ directory of the docker-library/docs GitHub repo. Be sure to familiarize yourself with the repository's README.md file before attempting a pull request.