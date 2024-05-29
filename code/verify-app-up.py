import requests


# Setting the url
url = 'http://localhost:5000/tripcount'

# Accessing the server
response = requests.get(url)
if response.status_code == 503:
    print("""
    ERROR ACCESSING DATA SERVICE - PLEASE VERIFY DATA IS PRESENT
    Did you use a -v flag with your docker run command?
    """)
elif response.status_code == 200:
    print("""
    SUCCESSFULLY ACCESSED DATA SERVICE!
    """)
else:
    print("""
    ERROR ACCESSING DATA SERVICE - PLEASE VERIFY SERVICE IS RUNNING
    Did you start your container with a -p flag?
    """)
