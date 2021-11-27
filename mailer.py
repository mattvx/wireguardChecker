#!/bin/python3

import smtplib
import datetime

file = open("log.txt")
current_time = datetime.datetime.now()

from_addr = "sender@gmail.com"
to_addr = "towho@gmail.com"
oggetto = "Wireguard status - " + str(current_time)
testo = file.read()
msg = 'Subject: {}\n\n{}'.format(oggetto,testo)

try:
    email = smtplib.SMTP("smtp.gmail.com", 587)
    email.ehlo()
    email.starttls()
    email.login(from_addr, "your_secret_password")
    email.sendmail(from_addr, to_addr, msg)
    email.close()
except:
    print("something went wrong!")
