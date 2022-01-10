#!/bin/bash

#Stop the script if there is a sign of: unset variable to be called, non-zero exit status or piping from command with said status.
#Basically it's a kill switch in case of any error.

exec > >(tee -a $PWD/redbull-result.log) 2>&1

#Making log file more informative by additing timestamp
currentdate=$(date '+%Y-%m-%d %H:%M:%S')
echo "Script launch: $currentdate"

read -p $"Would you like to check for missing prerequisites (Y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Checking for Python3 and pip3"
    sleep 2

    #We will get recommendation to install necessarities if type returns fail, otherwise it's okay
    if ! type python3 >/dev/null; then
        echo "Please install python3 https://www.python.org/downloads/"
    elif ! type pip3 >/dev/null; then
        echo "Please install pip3 https://pip.pypa.io/en/stable/installation/"
    else
        printf 'Python3 & pip3 are presented \xE2\x9C\x85\n'
    fi

    #Making sure we have necessary pip packages

    #Because macOS uses bash 3 I couldn't use superior "cmd &>> txt.log", let's use "cmd >> txt.log 2>&1"
    #Perhaps it's for the better since 2>&1 makes it more universal
    echo "Searching for pip3 packages, missing ones will be installed"
    packages=(selenium beautifulsoup4 webdriver-manager)
    for i in ${packages[@]}; do
        if ! pip3 show $i >/dev/null; then
            pip3 install $i >/dev/null && printf "$i has been installed \xE2\x9C\x85\n"
        elif pip3 show $i >/dev/null; then
            printf "$i presented \xE2\x9C\x85\n"
        else
            printf "An error occured \xE2\x9A\xA0\nCheck pip3 availability\n"
        fi
    done
    sleep 1
fi

read -p $"Source file: " -r SOURCEFILE
export SOURCEFILE

#Executing python from shell with heredoc, that hyphen (-) tells python to read from stdin (EOF).
python3 - << EOF
print("Getting RedBull Prices")

try: 
    from BeautifulSoup import BeautifulSoup
except ImportError:
    from bs4 import BeautifulSoup
import requests
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
import os
import time
import re

print(os.environ['SOURCEFILE'])

url_class_dict = dict()
file = open(os.getcwd() + "/" + os.environ['SOURCEFILE'], 'r')
for line in file:
    line = line.strip("\n")
    (key, val) = line.split(",")
    url_class_dict[key] = val

for key, value in url_class_dict.items():
    resp = requests.get(key)
    html = resp.content
    parsed_html = BeautifulSoup(html, "html.parser")
    #Colleting domain name to print that out
    domain_name = re.search('https?://([A-Za-z_0-9.-]+).*', key)
    #Printing result with collected domain name
    print(
        domain_name.group(1),
        parsed_html.body.find("div", attrs={"class": value}).text
    )
#-----------------------------------------------------------------------------------------------------
#Chrome zone! For websites with strong protection, launches real chrome with chromedriver using selenium
#New, convenient method of lauching chromedriver was found on the packages pages
#https://pypi.org/project/webdriver-manager/ and https://www.selenium.dev/documentation/webdriver/getting_started/install_drivers/#1-driver-management-software

url = "https://www.ozon.ru/product/red-bull-energeticheskiy-napitok-473-ml-138221686"

#disabling logging to console
os.environ["WDM_LOG_LEVEL"] = "0"

service = Service(executable_path=ChromeDriverManager(cache_valid_range=1).install())
driver = webdriver.Chrome(service=service)
driver.get(url)
driver.find_element(By.CSS_SELECTOR, "input.ui-g.ui-g2").send_keys("19171999")
driver.find_element(By.CSS_SELECTOR, "span.ui-b3.ui-b5").click()
time.sleep(3)
html = driver.page_source

parsed_html = BeautifulSoup(html, "html.parser")
prices = parsed_html.body.find("div", class_="c2h3 c2h9 c2e7").text
print("OZON: ", prices)
EOF

echo "Script finish: $currentdate"
