
#-----------------------------------------------------------------------------------------------------
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
#EOF
#-----------------------------------------------------------------------------------------------------
url = "https://www.ozon.ru/product/red-bull-energeticheskiy-napitok-473-ml-138221686"

s = Service("chromedriver location")
wd = webdriver.Chrome(service=s)
wd.get(url)
time.sleep(10)
html = wd.page_source

parsed_html = BeautifulSoup(html, "html.parser")
prices = parsed_html.body.find("div", class_="c2h3 c2h9 c2e7").text
print("OZON: ", prices)

#EOF
#-----------------------------------------------------------------------------------------------------
