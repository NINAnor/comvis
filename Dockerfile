# Use the base image for python 3.8
FROM python:3.8

# Install the dependancies for cv2
RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6  -y

# Install poetry (alternative to conda for package management)
RUN pip3 install poetry 
RUN pip3 install azure-storage-blob

# Install all the poetry dependancies
WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false
RUN poetry install --no-root

# Add model.pt in a megadetector folder
RUN mkdir megadetector
ADD https://github.com/agentmorris/MegaDetector/releases/download/v5.0/md_v5a.0.0.pt ./megadetector

# Clone the repo megadetector depends on
RUN git clone https://github.com/ecologize/yolov5/ && \
    cd /app/yolov5 && \ 
    git checkout ad033704d1a826e70cd365749e1bb01f1ea8282a

RUN git clone https://github.com/agentmorris/MegaDetector.git && \
    cd /app/MegaDetector &&  \
    git checkout ce1f225098875850366d3091e8f659143522ecd1

# Make a folder for my scripts
COPY ./ /app/

# Change PYTHONPATH
ENV PYTHONPATH "$PYTHONPATH:/app/MegaDetector:/app/ai4eutils:/app/yolov5"