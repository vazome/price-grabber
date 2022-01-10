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
            pip3 install $i
            printf "$i has been installed \xE2\x9C\x85\n"
        elif pip3 show $i >/dev/null; then
            printf "$i presented \xE2\x9C\x85\n"
        else
            printf "An error occured \xE2\x9A\xA0\nCheck pip3 availability\n"
        fi
    done
    sleep 1
fi

#Executing python from shell with heredoc, that hyphen (-) tells python to read from stdin (EOF).

python3 - <<EOF
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

url = "https://lavka.yandex.ru/213/good/7e447b7e24864298b96f905c0a4c9bf6000300010000"

resp = requests.get(url)

html = resp.content
parsed_html = BeautifulSoup(html, "html.parser")
print("YANDEX LAVKA: ", parsed_html.body.find('div', attrs={'class':'a1i9kwxd'}).text)
#-----------------------------------------------------------------------------------------------------
url = "https://market.yandex.ru/product--energeticheskii-napitok-red-bull/168903198?glfilter=15772198%3A0.473~0.473_100419608853&cpa=1&sku=100419608853"

resp = requests.get(url)

html = resp.content
parsed_html = BeautifulSoup(html, "html.parser")
print("YANDEX MARKET 12-pack: ", parsed_html.body.find('div', attrs={'class':'_3NaXx _3kWlK'}).text)
#-----------------------------------------------------------------------------------------------------
url = "https://www.utkonos.ru/item/3181240/napitok-energeticheskij-red-bull-0-47-l"

resp = requests.get(url)

html = resp.content
parsed_html = BeautifulSoup(html, "html.parser")
print("Utkonos: ", parsed_html.body.find('div', attrs={'class':'d-flex align-items-center ng-star-inserted'}).text)
#-----------------------------------------------------------------------------------------------------
url = "https://www.perekrestok.ru/cat/206/p/energeticeskij-napitok-red-bull-red-bull-473-ml-3173468"

resp = requests.get(url)

html = resp.content
parsed_html = BeautifulSoup(html, "html.parser")
print("PEREKRESTOK: ", parsed_html.body.find('div', attrs={'class':'price-new'}).text)
#-----------------------------------------------------------------------------------------------------
# New, convenient method of lauching file was found on the packages pages
#https://pypi.org/project/webdriver-manager/ and https://www.selenium.dev/documentation/webdriver/getting_started/install_drivers/#1-driver-management-software

url = "https://www.ozon.ru/product/red-bull-energeticheskiy-napitok-473-ml-138221686"

#disabling logging to console
os.environ['WDM_LOG_LEVEL'] = '0'

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
