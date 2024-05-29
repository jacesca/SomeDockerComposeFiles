FROM python:3-slim

#
# NOTE: Application reads contents of /data in container
# If not found, application returns errors.
# 

WORKDIR /app
ENV FLASK_RUN_HOST=0.0.0.0

COPY code/app.py .
COPY code/requirements.txt .

RUN pip install -r requirements.txt --root-user-action=ignore

EXPOSE 5000

CMD ["flask", "run"]

# # Build
# # $ docker build -t dataservice .

# # Create the network
# # $ docker network create data_net

# # Run the image with the data volume detail and port exposed
# # $ docker run --name dataservice --network data_net -p 5000:5000 -v <full-path c:/...>/datasets:/data/ -d dataservice

# # Verify the status of the service
# # $ python code/verify-app-up.py

# # Stop the service 
# # $ docker stop dataservice
