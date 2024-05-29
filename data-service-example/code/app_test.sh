STATUS_CODE=$(curl --silent --head http://172.26.0.2:5000/tripcount | awk '/^HTTP/{print $2}')

if [ "$STATUS_CODE" = "503" ]; then
  echo "ERROR ACCESSING DATA SERVICE - PLEASE VERIFY DATA IS PRESENT"
  echo "Did you use a -v flag with your docker run command?"
elif [ "$STATUS_CODE" = "200" ]; then
  echo "SUCCESSFULLY ACCESSED DATA SERVICE!"
else
  echo "ERROR $STATUS_CODE ACCESSING DATA SERVICE - PLEASE VERIFY SERVICE IS RUNNING"
  echo "Did you start your container with a -p flag?"
fi