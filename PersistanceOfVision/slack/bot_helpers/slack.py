from slacker import Slacker

slack = Slacker('API_KEY_HERE')

# Send a message to #general channel
slack.chat.post_message('#silverman', 'Running api')

# Get users list
#response = slack.users.list()
#users = response.body['members']

# Upload a file
#slack.files.upload('hello.txt')
