from plyer import notification
import sys

#runs in a python virtual env

def main():
    args = sys.argv
    notify(args[1])

def notify(text="null"):
    notification.notify(
    title='Alert',
    message=text,
    app_name='Remind me',
    timeout=5
)

main()