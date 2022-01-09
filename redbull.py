#!/bin/bash

#Stop the script if there is a sign of: unset variable to be called, non-zero exit status or piping from command with said status.
#Basically it's a kill switch in case of any error.

set -ueo pipefail
exec > >(tee -a $PWD/redbull-result.log) 2>&1


#Making log file more informative by additing timestamp
currentdate=$(date '+%Y-%m-%d %H:%M:%S')
echo "Script lauch: $currentdate"

echo "Checking for Python3 and pip3" 

#We will get recommendation to install necessarities if type returns fail, otherwise it's okay
if ! type python3; then
    echo "Please install python3 https://www.python.org/downloads/"
elif ! type pip3; then
    echo "Please install pip3 https://pip.pypa.io/en/stable/installation/"
else
    echo "Found Python3 and pip3 presence"
fi

#Making sure we have necessary pip packages

#Because macOS uses bash 3 I couldn't use superior "cmd &>> txt.log", let's use "cmd >> txt.log 2>&1"
#Perhaps it's for the better since 2>&1 makes it more universal
pip3 show selenium || pip3 install selenium
pip3 show beautifulsoup4 || pip3 install beautifulsoup4

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
url = "https://www.ozon.ru/product/red-bull-energeticheskiy-napitok-473-ml-138221686"

s = Service("/Users/danielvazome/Downloads/chromedriver")
wd = webdriver.Chrome(service=s)
wd.get(url)
time.sleep(10)
html = wd.page_source

parsed_html = BeautifulSoup(html, "html.parser")
prices = parsed_html.body.find("div", class_="c2h3 c2h9 c2e7").text
print("OZON: ", prices)
EOF

echo "Script finish: $currentdate"
