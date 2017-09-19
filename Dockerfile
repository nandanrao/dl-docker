FROM nvidia/cuda:latest

# Install some dependencies
RUN apt-get update && apt-get install -y \
		bc \
		build-essential \
		cmake \
		curl \
		g++ \
		gfortran \
		git \
		libffi-dev \
		libfreetype6-dev \
		libhdf5-dev \
		libjpeg-dev \
		liblcms2-dev \
		libopenblas-dev \
		liblapack-dev \
		libpng12-dev \
		libssl-dev \
		libtiff5-dev \
		libwebp-dev \
		libzmq3-dev \
		nano \
		pkg-config \
		python-dev \
		software-properties-common \
		unzip \
		wget \
		zlib1g-dev \
		qt5-default \
		libvtk6-dev \
		zlib1g-dev \
		libjpeg-dev \
		libwebp-dev \
		libpng-dev \
		libtiff5-dev \
		libjasper-dev \
		libopenexr-dev \
		libgdal-dev \
		libdc1394-22-dev \
		libavcodec-dev \
		libavformat-dev \
		libswscale-dev \
		libtheora-dev \
		libvorbis-dev \
		libxvidcore-dev \
		libx264-dev \
		yasm \
		libopencore-amrnb-dev \
		libopencore-amrwb-dev \
		libv4l-dev \
		libxine2-dev \
		libtbb-dev \
		libeigen3-dev \
		python-dev \
		python-tk \
		python-numpy \
                python-pip \
		python3-dev \
		python3-tk \
		python3-numpy \
		ant \
		default-jdk \
		doxygen \
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* && \

# Link BLAS library to use OpenBLAS using the alternatives mechanism (https://www.scipy.org/scipylib/building/linux.html#debian-ubuntu)
	update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3

# Install pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py && \
	python get-pip.py && \
	rm get-pip.py

# Add SNI support to Python
RUN pip3 install \
         pyopenssl \
	 ndg-httpsclient \
      	 pyasn1

RUN pip install \
         pyopenssl \
	 ndg-httpsclient \
      	 pyasn1

# Install other useful Python packages using pip
RUN pip3 install --upgrade ipython && \
    pip3 install \
        scipy \
        sklearn \
        pandas \
        matplotlib \
        mxnet-cu80 \
	Cython \
	ipykernel \
	jupyter \
	path.py \
	Pillow \
	pygments \
	six \
	sphinx \
	wheel \
	zmq \
	&& \
	python3 -m ipykernel.kernelspec

# Install other useful Python packages using pip
RUN pip install --no-cache-dir --upgrade ipython && \
    pip install --no-cache-dir \
        scipy \
        sklearn \
        pandas \
        matplotlib \
        mxnet-cu80 \
	Cython \
	ipykernel \
	jupyter \
	path.py \
	Pillow \
	pygments \
	six \
	sphinx \
	wheel \
	zmq \
	&& \
	python -m ipykernel.kernelspec

# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /root/

# Expose Ports for TensorBoard (6006), Ipython (8888)
EXPOSE 6006 8888

WORKDIR "/root"
CMD ["run_jupyter.sh --allow-root"]
