# -*- coding: utf-8 -*-
"""
Created on Mon Jul 17 12:58:10 2023

@author: luke
"""

import os
import io
import pandas as pd
import unidecode
import string
from urllib.request import urlopen
from bs4 import BeautifulSoup
import csv
import json

target_directory = 'C:/Users/luke/Personal_Projects/Soccer/Similarity/Data/'
categories = {'stats': 'standard', 
              'shooting': 'shooting', 
              'passing': 'passing', 
              'passing_types': 'passing_types', 
              'gca': 'gca', 
              'defense': 'defense', 
              'possession': 'possession', 
              'playingtime': 'playing_time', 
              'misc': 'misc'}
leagues = {"Big5": "Big-5-European-Leagues",
           "MLS": "Major-League-Soccer"}

def make_csv(df, string):
    outname = string+'.csv'
    df.to_csv(target_directory+outname)

def scrape_players_stats(category, league):
    print(categories[category], end=' ')
    try:
        if league=="Big5":
            html=urlopen(f"https://fbref.com/en/comps/{league}/{category}/players/{leagues[league]}-Stats")
        elif league=="MLS":
            html=urlopen(f"https://fbref.com/en/comps/22/2022/{category}/2022-{leagues[league]}-Stats")
    except Exception as e:
        print(e)
        print(category)
        return None
    soup=BeautifulSoup(html, features="lxml")
    table = soup.find('table', {'id': 'stats_'+categories[category]})
        
    stats = pd.read_html(str(table))[0]    
    stats.columns = stats.columns.droplevel(0)
    
    ids = [row.find('td').get('data-append-csv') if row.find('td') is not None else None for row in table.find('tbody').findAll('tr')]
    stats['id'] = ids
    
    stats = stats.loc[stats['Rk']!='Rk']

    stats.to_csv(target_directory+league+"/"+categories[category]+'.csv', index=False)
    print('done', end='... ')
    return stats

def load_all(league="Big5"):
    print("League:", league)
    for key in categories.keys():
        try:
            scrape_players_stats(key, league)
        except Exception as e:
            print(e, end='...')
    print('\nFINISHED')
    
def main():
    inNum = int(input('Enter "1" for Big5 European Leagues\nEnter "2" for MLS (Void)\n'))
    league = "Big5" if inNum==1 else "MLS" if inNum==2 else "return"
    if league=="return":
        main()
        return
    load_all(league)
    return

if __name__ == "__main__":
    #scrape_players_stats("stats", "MLS")
    main()
    
    
    
'''elif league=='MLS':
tableStr = '<table'+str(soup.find('div', {"id": "all_stats_standard"})).split('<table')[1]
table = tableStr.split('</table>')[0]+'</table>'''