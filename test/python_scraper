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
time.sleep(5)
html = driver.page_source
score = ""
parsed_html = BeautifulSoup(html, "html.parser")
prices = parsed_html.body.find_all("div",  {"class": ["c2h3 c2h9 c2e7", "jm9 j0n n1j"]})
for price in prices:
        score = score + price.text
print("OZON:", score)
