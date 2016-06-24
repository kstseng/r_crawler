# -*- coding: utf-8 -*-
"""
Created on Fri Jun 24 10:59:00 2016

@author: David79.Tseng
"""

from bs4 import BeautifulSoup
import requests
import xlsxwriter
import re


id_list = [37722, 37724, 37725, 225117, 98993, 259394]
ID_name = ["Industrial Automation", "Embedded Boards", "Digital Healthcare", "Intelligent Systems", 
             "Digital Logistics", "Industrial Communication"]
path = 'C:\\Users\\David79.Tseng\\Dropbox\\David79.Tseng\\git-respository\\AdvanCrawler\\'
workbook = xlsxwriter.Workbook(path + 'AdvanCrawlerPython.xlsx')    

res = requests.get('http://www.directindustry.com/prod/advantech-4657.html')
soup = BeautifulSoup(res.text)

for i in range(len(ID_name)):
    idx_tmp = 'group-product-list_' + str(id_list[i])
    div_id = soup.findAll('div', {'id':idx_tmp})
    soup_sub = BeautifulSoup(str(div_id))
    div_gpl = soup_sub.findAll("div", {"class": "group-product-list-item"})
    pro_list = []
    for div in div_gpl:
        #print (div.findAll('a')[1].contents[2])
        tmp = div.findAll('a')[1].contents[2].replace('\n', '').replace('\r', '')
        pro_list.append(re.sub(r'\s+', '', tmp))
    pro_list = list(filter(None, pro_list))

    worksheet = workbook.add_worksheet(ID_name[i])

    row, col = 0, 0
    for pro in pro_list:
        #print(pro)
        worksheet.write(row, col, pro)
        row += 1
    
workbook.close()

