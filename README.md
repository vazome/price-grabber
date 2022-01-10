# price-grabber
This is a fun project originating from a bet I made with a friend. With this tool you can check price of goods on variety of online grocers.

Technically it can be used for general webscrapping and data collection, but the general purpose for me is monitoring of Red Bull prices.

## Prerequisites
- Linux/WSL
- Python 3
  - Script prompts user to check and install the following pip3 packages:
  - BeautifulSoup4 package `pip3 install BeautifulSoup4`
  - Selenium packge `pip3 install selenium`
  - webdriver-manager packge `pip3 install webdriver-manager`
## Usage
[Download script and example csv](https://github.com/vazome/price-grabber/tree/main/script), set your links and div classes in csv file and for a protected website edit url variable in script.

macOS - `bash ./price-grabber.sh`

Other - `./price-grabber.sh`

https://user-images.githubusercontent.com/46573198/148727983-e3745679-0aee-443c-aea2-be780673de95.mp4
