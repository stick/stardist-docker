FROM centos:7

RUN   yum -y update && yum clean all
RUN   yum -y install epel-release

# Install CellProfiler dependencies
RUN   yum -y install      \
        python3           \
        curl              \
        epel-release      \
        jq                \
        which             \
        prelink           \
        unzip


# Fix init and zombie process reaping problems using s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /

# Create and use omero user
RUN useradd -d /opt/omero -m -c "OMERO" -r omero

# Create Virtualenv
WORKDIR /opt/omero

RUN yum -y install python3-pip
# upgrade pip
RUN pip3 install -U pip wheel

# zeroc-ice
RUN pip install -U https://github.com/ome/zeroc-ice-py-centos7/releases/download/0.2.1/zeroc_ice-3.6.5-cp36-cp36m-linux_x86_64.whl

# install omero-py
RUN pip install -U https://github.com/glencoesoftware/omero-user-token/releases/download/v0.1.1/omero_user_token-0.1.1-py2.py3-none-any.whl

# install segmentation utils
COPY segmentation_utils-0.1.1-py2.py3-none-any.whl /tmp/
RUN pip install -U /tmp/segmentation_utils-0.1.1-py2.py3-none-any.whl

User omero
#ADD ometiff-conversion-import.sh /usr/local/bin/
#ENTRYPOINT ["/usr/local/bin/ometiff-conversion-import.sh"]
