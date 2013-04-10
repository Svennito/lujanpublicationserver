#!/usr/bin/env python
# -*- coding: utf-8 -*-
# encoding: utf-8 

# based on:
#
# gscholar - Get bibtex entries from Goolge Scholar
# Copyright (C) 2010  Bastian Venthur <venthur at debian org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# modifications for LANSCE publication list by S. Vogel
#
# To do:
# 
# - queries are run for "instrument-name neutron", if others exist with same name (SCD), maybe different terms
# - queries are run for "scientist-name lansce/lanl"
# - each beam line scientist gets list of publications referring to his/her beam line for three years (i.e. three .bib files)
# - using JabRef or other BibTeX client, false hits are flagged (not deleted, so they don't come again next year)
#   - add optional field "include" to all reference types, enter anything if entry is to be included
# - use bibtosql script or similar to convert to SQL database for more queries - or use script to select subsets?



"""Library to query Google Scholar.

Call the method query with a string which contains the full search string.
Query will return a list of bibtex items.
"""


import urllib2
import re
import hashlib
import random
import sys
import os
import time
import subprocess
import optparse
import logging
from htmlentitydefs import name2codepoint



# fake google id (looks like it is a 16 elements hex)
google_id = hashlib.md5(str(random.random())).hexdigest()[:16] 

GOOGLE_SCHOLAR_URL = "http://scholar.google.com"
#HEADERS = {'User-Agent' : 'Mozilla/5.0','Cookie' : 'GSP=ID=%s:CF=4' % google_id }
HEADERS = {'User-Agent' : 'Opera/9.80 (X11; Linux i686; U; en) Presto/2.6.30 Version/10.63','Cookie' : 'GSP=ID=%s:CF=4' % google_id }

# valid scholar search string (generated using advanced search):
# http://scholar.google.com/scholar?as_q=hippo+neutron&num=100&btnG=Search+Scholar&as_epq=&as_oq=&as_eq=&as_occt=any&as_sauthors=&as_publication=&as_ylo=&as_yhi=&as_sdt=1.&as_sdtp=on&as_sdts=32&hl=en
# http://scholar.google.com/scholar?hl=en&num=100&q=hippo+neutron&as_allsubj=some&as_subj=bio&as_subj=chm&as_subj=eng&as_subj=phy&as_sdt=10000000001&as_ylo=2010&as_yhi=2010&as_vis=1
def query(searchstr, year_from=False, year_to=False, exact_phrase=False, allresults=True,written_by=False,instrument=False,facility=False):
    """Return a list of bibtex items."""
    logging.debug("Query: %s" % searchstr)
    logging.debug("From year: %s" % year_from)
    logging.debug("To year: %s" % year_to)
    logging.debug("Exact phrase: %s" % exact_phrase)
    logging.debug("Written by: %s" % written_by)
    logging.debug("Instrument: %s" % instrument)
    logging.debug("Facility: %s" % facility)
    # remember the original query
    shortstr_short = searchstr
    
    # initialize the query to the searchstring and 100 results
    if written_by != "False" :
      # we have an author, let's skip the searchstring
      searchstr = "/scholar?as_q=&num=100" #&btnG=Search+Scholar&as_epq=&as_oq=&as_eq=&as_occt=any&as_sauthors=&as_publication="
    else:
      searchstr = '/scholar?as_q='+urllib2.quote(searchstr)+"&num=100" #&btnG=Search+Scholar&as_epq=&as_oq=&as_eq=&as_occt=any&as_sauthors=&as_publication="
    
    searchstr = searchstr+"&btnG=Search+Scholar"
    
    # limit subject areas to Biology, Life Sciences, and Environmental Science, Chemistry and Materials Science, Engineering, Computer Science, and Mathematics, Physics, Astronomy, and Planetary Science
    searchstr = searchstr+"&as_allsubj=some&as_subj=bio&as_subj=chm&as_subj=eng&as_subj=phy"
    # do NOT include citations (at least summaries)
    searchstr = searchstr+"&as_vis=1"

    # require exact phrase (helps to filter SMARTS against smart etc.)
    # SV 120725 requiring exact phrase fails to find a lot of publications, skip it...
    #if exact_phrase != "False" :
      #searchstr = searchstr+"&as_epq="+exact_phrase
    #else:
      #searchstr = searchstr+"&as_epq="
    searchstr = searchstr+"&as_epq="
    
    # require at least one of these terms: lanl "los alamos" lansce
    searchstr = searchstr+"&as_oq=lanl+%22los+alamos%22+lansce&as_eq=&as_occt=any"
    
    if written_by != "False" :
      searchstr = searchstr+"&as_sauthors=%22"+written_by+"%22" #       as_sauthors=%22S*+Vogel%22
    else:
      searchstr = searchstr+"&as_sauthors="
      
    searchstr = searchstr+"&as_publication="
  
    
    # did we get a year to look for?
    if year_from != "False" :
      searchstr = searchstr+"&as_ylo="+year_from
    else:
      searchstr = searchstr+"&as_ylo="
    if year_to != "False" :
      searchstr = searchstr+"&as_yhi="+year_to
    else:
      searchstr = searchstr+"&as_yhi="
      
    logging.debug("String sent to google: %s" % searchstr)
    url = GOOGLE_SCHOLAR_URL + searchstr

    # Try to connect a few times, waiting longer after each consecutive failure
    MAX_ATTEMPTS = 10
    for attempt in range(MAX_ATTEMPTS):
        try:
	    # fake google id (looks like it is a 16 elements hex)
	    google_id = hashlib.md5(str(random.random())).hexdigest()[:16] 
	  
	    # try to confuse google with random user agents, e.g. from http://www.stevestechresource.com/str/instructional/web_browser_useragent_values.html
	    # confusing doesn't seem to work. What seems to work is to use wireshark and get the full cookie sent by google, the one in the cookie manager is insufficient...
	    # looks like one needs to enter the cookies from scholar.google.com and google.com as listed in Opera cookie manager after one has identified the little picture
	    agent = random.randrange(1) 
	    if agent == 0:
		HEADERS = {'User-Agent' : 'Opera/9.80 (X11; Linux i686; U; en) Presto/2.10.289 Version/12.02','Cookie' : 'BIGipServerbluecoat_pool=2248478892.36895.0000; GSP=ID=d7531c222b61af10:IN=7e6cc990821af63+3047c38f1bda9f39:CF=4:DT=1:NT=1365540270:S=RNz8OZOjnTe-LFtA; MPRF=H4sIAAAAAAAAAKt4175i3Q3VLiaGSUwKhmam5kmGBuZppsnmicYG5iZmxsnGxuaplmlGqQYWBkkTmBkAbNVZqjAAAAA; SS=DQAAAL4AAAD-XDruwu4pI0AwKA6kNxTwqaePBrComcsrEv2YwGfq3RZqbpswnDyBIus7jchEcKVsvHyZWkNPhA_ukTHsGHscEF4-jxsj153OhcwnJ_Do_4FRQKuou7ih6z2a9uPcbUoo7PE-vRVt-XKBPQezIbkIZSunCxBmcKBifR8fbAxknWbe9cTwB05wGJpb1dwb8_en-GyDrMOJDdR-shZDelymhhsmxIamClOmv7GRgWx1MU3ZxYcsjGnGoODDXCItK3g; PREF=ID=d7531c222b61af10:U=53b32425fdf95ceb:FF=0:LD=en:NR=100:TM=1206481493:LM=1355271328:FV=2:GM=1:IG=3:S=O7mIFn_kInevikqr; HSID=Ax9aZIxyX_vMmzWI2; APISID=WZar1cZiLRo74Q69/A0lQVUQ2WxaTgXSLU; NID=67=v-J_Owu2yFYVTxMhZdoDRdhHIJnnh949vJqtt1358nyZ9uBkvodlw1jEST9EX7d33cqmLpmbFjn9-ZBwz6ImFi03cjYmikme6Ie1jZ0WFt4fdp6dtRnVxuNUwrYkwQ3aKA4KHPQRrG415sQUzEXternbEqr_pEXvo04NYdA7KTq6MAnohbP6IEyDl8I-NM1UR8lP_lOIu4rE8wipgJLWI9mJqQ; GDSESS=ID=c8414aa65f561eb3:TM=1365540266:C=c:IP=192.12.184.7-:S=APGng0slWIivZnLftrCbLGCna7GqtR8a_g; SID=DQAAAMwAAABwR3XBxthKKuQRKbbOrszF92IJppFNh075BhK3bbtzQVJ3Hy_IbGqjLQHd-80ZGPADBLoHW3UCYNlILVlhnK--3n1oh9IwHgTXPPcwJiMbd18W4swC2r_XyvzzHVGdNJBXrBq8W4gf2GK0bJe5tEtwgDBMJCkWyU-63JRlocSG9DoIxKGLK0F6FTv-jFXWivDigO7WjTprYkxeDElrsggpujG9h4GBCeAWAk5kv3RwQwhY22lo4wxcE4sJCKYIBETJq8-LflDsw_eABdtYGxz5'}
		#HEADERS = {'User-Agent' : 'Opera/9.80 (X11; Linux i686; U; en) Presto/2.6.30 Version/10.63','Cookie' : 'GSP=ID=%s:CF=4' % google_id }
	    elif agent == 1:
		HEADERS = {'User-Agent' : 'Mozilla/4.0','Cookie' : 'GSP=ID=%s:CF=4' % google_id }
	    elif agent == 2:
		HEADERS = {'User-Agent' : 'Mozilla/5.0','Cookie' : 'GSP=ID=%s:CF=4' % google_id }
	    elif agent == 3:
		HEADERS = {'User-Agent' : 'Opera 11.50 Beta 1','Cookie' : 'GSP=ID=%s:CF=4' % google_id }
	    elif agent == 4:
		HEADERS = {'User-Agent' : 'mozilla/5.0 (windows; u; windows nt 5.1; en-us; rv:1.7.13) gecko/20060414','Cookie' : 'GSP=ID=%s:CF=4' % google_id }
	    request = urllib2.Request(url, headers=HEADERS)
	    logging.debug("url: %s" % url)
	    logging.debug("headers: %s" % HEADERS)
            response = urllib2.urlopen(request)
            break
        except urllib2.URLError, e:
            sleep_secs = attempt ** 4
            print >> sys.stderr, 'ERROR: %s.\nRetrying in %s seconds...' % (e, sleep_secs)            
            time.sleep(sleep_secs)    
                                                  
                                                  
    # response = urllib2.urlopen(request)
    logging.debug("response: %s" % response)
    html = response.read()
    html = html.decode('ascii', 'ignore') 
    # grab the bibtex links
    tmp = get_biblinks(html)
    pub_tmp = get_publinks(html)
    cite_tmp = get_citations(html)
    citelink_tmp = get_citation_links(html)
    #logging.debug("publinks: %s" % pub_tmp)
    #logging.debug("citations: %s" % cite_tmp)
    
    logging.debug("\n\nWe have read %s links in our list." % len(pub_tmp))
    # follow the bibtex links to get the bibtex entries
    result = list()
    if allresults == False and len(tmp) != 0:
        tmp = [tmp[0]]
    i = 0
    for link in tmp:
	# sleep a second to prevent google from thinking we're a robot...
	# one second is not always enough, still get caught as a robot
	# four seconds gives occasional trouble
	# five seconds seems to work for one query, but then it fails
	# for the random numbers, a multipier of 10 does not work
	# 20 lets google find us, too
	# 10 plus up to 30 seconds wait time works...
	sleep_time = 10+random.random()*30
	logging.debug("\n\nWaiting a %s seconds to stay friends with The Mighty Google..." % sleep_time)
	time.sleep(sleep_time)  
        url = GOOGLE_SCHOLAR_URL+link
	logging.debug("Sending request: %s" % url)
        request = urllib2.Request(url, headers=HEADERS)
        response = urllib2.urlopen(request)
        bib = response.read()
	bib = bib.decode('ascii', 'ignore') 
	logging.debug("Entry number: %s of %s " %  (i,len(pub_tmp)-1))
	logging.debug("Received entry:\n %s" %  bib)
	logging.debug("Corresponding link: %s" % pub_tmp[i])
	# insert pub links
	if bib.rfind("}")>0 :
	  if i<len(pub_tmp):
	    # add a few fields for our purpose
	    if written_by != "False" :
	      bib=bib[0:bib.rfind("}")-1]+",\n  citations={"+'{:04d}'.format(cite_tmp[i])+"},\n  citelinks={"+GOOGLE_SCHOLAR_URL+citelink_tmp[i]+"},\n  URL={"+pub_tmp[i]+"},\n  query={"+written_by+"},\n  falsehit={no},\n  instrument={"+instrument+"},\n  facility={"+facility+"}\n}"
	    else:
	      bib=bib[0:bib.rfind("}")-1]+",\n  citations={"+'{:04d}'.format(cite_tmp[i])+"},\n  citelinks={"+GOOGLE_SCHOLAR_URL+citelink_tmp[i]+"},\n  URL={"+pub_tmp[i]+"},\n  query={"+shortstr_short+"},\n  falsehit={no},\n  instrument={"+instrument+"},\n  facility={"+facility+"}\n}"
	  else:
	    print "PROBLEM: I ran out of links before the list of references was over!!!!!!!!!!!!"
        result.append(bib)
        i=i+1
    return result


def get_biblinks(html):
    """Return a list of biblinks from the html."""
    bibre = re.compile(r'<a href="(/scholar\.bib\?[^>]*)">')
    biblist = bibre.findall(html)
    # escape html enteties
    biblist = [re.sub('&(%s);' % '|'.join(name2codepoint), lambda m:
        unichr(name2codepoint[m.group(1)]), s) for s in biblist]
    return biblist

def get_publinks(html):
    """Return a list of publinks from the html."""
    # Regular expression (re) is
    # occurence of "<h3>"
    # ... followed by as few characters as possible ...
    # ... before the string "<a href=" ...
    # ... followed by any character in the set of [ ' " ] , e.g. single or double quote, but with only a single occurence (indicated by the ?)
    # ... followed by "("
    # ... followed by any character of the set of newline, single quote, double quote, space or >, each of which can occur multiple times (+ character)
    # pubre = re.compile(r'<h3>.*?<a href=[\'"]?([^\'" >]+)')
    pubre = re.compile(r'<h3 class="gs_rt">.*?<a href=[\'"]?([^\'" >]+)')
    publist = pubre.findall(html)
    # escape html enteties
    # substitute (.sub), 
    # - first arg is pattern to be replaced, here <'&(%s);' % '|'.join(name2codepoint)>
    # - second arg is replacement, here <lambda m: unichr(name2codepoint[m.group(1)])> 
    # - third arg is string to be worked on, here <s>
    # - fourth argument is number of replacements, for 0 all will be replaced
    # - fifth argument are flags
    publist = [re.sub('&(%s);' % '|'.join(name2codepoint), lambda m:
        unichr(name2codepoint[m.group(1)]), s) for s in publist]
    return publist


def get_citations(html):
    """Return the number of citations from the html."""
    # extract all "<span class=gs_fl> ... </span>" sections, which contains the "Cited by..." code
    # citere = re.compile(r'<span class=gs_fl>.*?</span>')
    citere = re.compile(r'<div class="gs_fl">.*?</a>')
    citelist = citere.findall(html)
    # works, extracts all segments from <span> to </span>
    logging.debug("citelist: %s" % citelist)	
    
    # scan again and extract citations
    # escape html enteties
    citere = re.compile(r'Cited by (\d+)')
    citelist = [citere.search(s) for s in citelist]
    logging.debug("citelist: %s" % citelist)

    i = 0
    citere = re.compile(r'(\d+)')
    for m in citelist :
      if m != None :
	m=citere.search(m.group(0))
	#logging.debug("group(0): %s" % m.group(0))
	#logging.debug("m: %s" % m)
	m=int(m.group(0))
      else:
	m=0
      citelist[i]=m
      i=i+1
    logging.debug("citelist: %s" % citelist)
    return citelist

def get_citation_links(html):
    """Return the number of citations from the html."""
    # extract all "<span class=gs_fl> ... </span>" sections, which contains the "Cited by..." code
    citere = re.compile(r'<div class="gs_fl"><a href=[\'"]?([^\'" >]+).*?</a>')
    citelist = citere.findall(html)
    # works, extracts all segments from <span> to </span>
    logging.debug("citelist: %s" % citelist)	
    
    # escape html enteties
    # substitute (.sub), 
    # - first arg is pattern to be replaced, here <'&(%s);' % '|'.join(name2codepoint)>
    # - second arg is replacement, here <lambda m: unichr(name2codepoint[m.group(1)])> 
    # - third arg is string to be worked on, here <s>
    # - fourth argument is number of replacements, for 0 all will be replaced
    # - fifth argument are flags
    citelist = [re.sub('&(%s);' % '|'.join(name2codepoint), lambda m:
        unichr(name2codepoint[m.group(1)]), s) for s in citelist]
    logging.debug("citelist: %s" % citelist)

    return citelist


def convert_pdf_to_txt(pdf):
    """Convert a pdf file to txet and return the text.

    This method requires pdftotext to be installed.
    """
    stdout = subprocess.Popen(["pdftotext", "-q", pdf, "-"], stdout=subprocess.PIPE).communicate()[0]
    return stdout


def pdflookup(pdf, allresults):
    """Look a pdf up on google scholar and return bibtex items."""
    txt = convert_pdf_to_txt(pdf)
    # remove all non alphanumeric characters
    txt = re.sub("\W", " ", txt)
    words = txt.strip().split()[:20]
    gsquery = " ".join(words)
    bibtexlist = query(gsquery, allresults)
    return bibtexlist


def _get_bib_element(bibitem, element):
    """Return element from bibitem or None."""
    lst = [i.strip() for i in bibitem.split("\n")]
    for i in lst:
        if i.startswith(element):
            value = i.split("=", 1)[-1]
            value = value.strip()
            while value.endswith(','):
                value = value[:-1]
            while value.startswith('{') or value.startswith('"'):
                value = value[1:-1]
            return value
    return None


def rename_file(pdf, bibitem):
    """Attempt to rename pdf according to bibitem."""
    year = _get_bib_element(bibitem, "year")
    author = _get_bib_element(bibitem, "author")
    if author:
        author = author.split(",")[0]
    title = _get_bib_element(bibitem, "title")
    l = []
    for i in year, author, title:
        if i: 
            l.append(i)
    filename =  " - ".join(l) + ".pdf"
    newfile = pdf.replace(os.path.basename(pdf), filename)
    print
    print "Will rename:"
    print
    print "  %s" % pdf
    print 
    print "to"
    print 
    print "  %s" % newfile
    print 
    print "Proceed? [y/N]"
    answer = raw_input()
    if answer == 'y':
        print "Renaming %s to %s" % (pdf, newfile)
        os.rename(pdf, newfile)
    else:
        print "Aborting."


if __name__ == "__main__":
    usage = 'Usage: %prog [options] {pdf | "search terms"}'
    parser = optparse.OptionParser(usage)
    parser.add_option("-a", "--all", action="store_true", dest="all", 
                      default="False", help="show all bibtex results")
    parser.add_option("-c", "--facility", dest="facility", 
                      default="False", help="generate facility entry in bibtex output with value FACILITY", metavar="FACILITY")
    parser.add_option("-d", "--debug", action="store_true", dest="debug",
                      default="False", help="show debugging output")
    parser.add_option("-e", "--exact", dest="exact_phrase",
                      default="False", help="require exact phrase (e.g. SMARTS, but not smart")
    parser.add_option("-f", "--year_from",  dest="query_year_from",
                      default="False", help="Start output with year YEAR_FROM", metavar="YEAR_FROM")
    parser.add_option("-i", "--insert",  dest="insert_file",
                      default="False", help="Insert output into BiBTeX INSERT_FILE", metavar="INSERT_FILE")
    parser.add_option("-n", "--instrument", dest="instrument", 
                      default="False", help="generate instrument entry in bibtex output with value INSTRUMENT", metavar="INSTRUMENT")
    parser.add_option("-r", "--rename", action="store_true", dest="rename",
                      default="False", help="rename file (asks before doing it)")
    parser.add_option("-t", "--year_t",  dest="query_year_to",
                      default="False", help="End output with year YEAR_TO", metavar="YEAR_TO")
    parser.add_option("-w", "--written_by",  dest="written_by",
                      default="False", help="Output papers written by WRITTEN_BY", metavar="WRITTEN_BY")
    (options, args) = parser.parse_args()
    if options.debug == True:
        logging.basicConfig(level=logging.DEBUG)
    logging.debug("Here are the options: %s." % options)
    logging.debug("Here are the unparsed arguments: %s." % args)
    if len(args) != 1:
        parser.error("No argument given, nothing to do.")
        sys.exit(1)
    args = args[0]
    pdfmode = False
    if os.path.exists(args):
        logging.debug("File exist, assuming you want me to lookup the pdf: %s." % args)
        pdfmode = True
        biblist = pdflookup(args, all)
    else:
        logging.debug("Assuming you want me to lookup the query: %s." % args)
	# Do we need to query from a year only?
        if options.query_year_from != "False":
	  # if so - did we get a years
	  logging.debug("Querying publications from year: %s." % options.query_year_from)
        if options.query_year_to != "False":
	  # if so - did we get a years
	  logging.debug("Querying publications to year: %s." % options.query_year_to)
        if options.written_by != "False":
	  # if so - did we get a name
	  logging.debug("Querying publications written by: %s." % options.written_by)
        biblist = query(args, options.query_year_from, options.query_year_to, options.exact_phrase, options.all,options.written_by,options.instrument,options.facility)
    if len(biblist) < 1:
        print "No results found, try again with a different query!"
        sys.exit(1)
    if options.all == True:
        logging.debug("All results:")
        for item in biblist:
	  # do we need to add to BiBTeX file?
	  if options.insert_file != "False":
	    # yes, we do!
	    # define a search string
	    searchstring = item[0:item.find(",\n")]
	    # modify the first line of the bib entry to make the index more unique
	    vol    = _get_bib_element(item, "volume")
	    number = _get_bib_element(item, "number")
	    pages  = _get_bib_element(item, "pages")
	    if pages:
		pages  = pages.replace("--","to")

	    for i in vol, number, pages:
		if i: 
		    searchstring = searchstring + "_" + i
	    logging.debug("Searchstring: %s" % searchstring)
	    # assemble a new entry with the new first line
	    item = searchstring + ",\n"+item[item.find("\n")+1:]
	    # check if the provided BiBTeX file exists
	    if os.path.isfile(options.insert_file) != True:
	      # we need to make it
	      FILE = open(options.insert_file,"w")
	      # Write all the lines at once:
	      FILE.writelines("% This is a BiBTeX file created by gscholar.py, contact sven at lanl.gov for problems.\n")
	      FILE.writelines("% Download JabREF to view this file.\n")
	      FILE.close()
	      
	    # Check if entry exists and add only if not
	    for line in open(options.insert_file):
	      if line.find(searchstring)>-1:
		# we found it!
		logging.debug("Found line %s" % line)
		break
	    # if we are he we either went through the file or we had the find and hit break, let's check
	    if line.find(searchstring)>-1:
	      # we really found it
	      logging.debug("Entry exists!")
	    else:
	      # we went through the file and did not find it
	      logging.debug("Appending entry to %s..." % options.insert_file)
	      FILE = open(options.insert_file,"a")
	      FILE.writelines("\n"+item+"\n")
    else:
        logging.debug("First result:")
        print biblist[0]
    if options.rename == True:
        if not pdfmode:
            print "You asked me to rename the pdf but didn't tell me which file to rename, aborting."
            sys.exit(1)
        else:
            rename_file(args, biblist[0])
