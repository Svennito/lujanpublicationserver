### -*-awk-*-
### modified by Sven Vogel (sven@lanl.gov) for use of reference managment at Lujan
### modifications should be indicated by SV YYMMDD comments, start and end markers if multiple lines
### added new fields for citelinks
###
###
### /u/sy/beebe/tex/bibsql/bibsql-0.00/bibtosql.awk, Thu Oct 23 07:28:21 2008
### Edit by Nelson H. F. Beebe <beebe@math.utah.edu>
### ====================================================================
###  @Awk-file{
###     author          = "Nelson H. F. Beebe",
###     version         = "0.01",
###     date            = "24 March 2010",
###     time            = "12:13:18 MDT",
###     filename        = "bibtosql.awk",
###     address         = "University of Utah
###                        Department of Mathematics, 110 LCB
###                        155 S 1400 E RM 233
###                        Salt Lake City, UT 84112-0090
###                        USA",
###     telephone       = "+1 801 581 5254",
###     FAX             = "+1 801 581 4148",
###     URL             = "http://www.math.utah.edu/~beebe",
###     checksum        = "39110 1476 5760 38727",
###     email           = "beebe@math.utah.edu, beebe@acm.org,
###                        beebe@computer.org (Internet)",
###     codetable       = "ISO/ASCII",
###     keywords        = "bibliography; BibTeX; database; MySQL;
###                        PostgreSQL; SQL; SQLite; Structured Query
###                        language; relational database",
###     license         = "GNU General Public License (version 2 or
###                        later)",
###     supported       = "yes",
###     docstring       = "The checksum field above contains a CRC-16
###                        checksum as the first value, followed by the
###                        equivalent of the standard UNIX wc (word
###                        count) utility output of lines, words, and
###                        characters.  This is produced by Robert
###                        Solovay's checksum utility.",
###  }
### ====================================================================

### ====================================================================
### Convert a conventionally-formatted (via bibclean) BibTeX file
### stream to input for an SQLite (or compatible) database.
###
### Usage:
###	gawk -f bibtosql.awk \
###	    [ -v CREATEDB=1 ] \
###	    [ -v DATABASE=dbname ] \
###	    [ -v SERVER=database ] \
###	    BibTeX-file(s) > db-SQL-input-file
###
### In most case, the output can be sent directly to the
### database program:
###
###	gawk -f bibtosql.awk -v CREATEDB=1 *.bib | mysql foo.db
###	gawk -f bibtosql.awk -v CREATEDB=1 *.bib | psql foo.db
###	gawk -f bibtosql.awk -v CREATEDB=1 *.bib | sqlite foo.db
###
### If CREATEDB is set nonzero, the output contains additional
### information to create the database.  Otherwise, it just
### contains commands to add new records to the database.
###
### The default value of SERVER is SQLite, but MySQL and PSQL (or
### its alias, PostgreSQL) are also supported.
###
### For search purposes, the author, editor, title, and abstract
### string values have TeX accents and control words (e.g., \\)
### removed, and any remaining TeX control sequences reduced to their
### macro name (\TeX -> TeX).  However, the entry string contains the
### original BibTeX entry verbatim, with all TeX markup intact.
###
### In addition, ISBN, ISBN-13, and ISSN string values are augmented
### with copies of the original string with hyphens removed, allowing
### search input to be properly hyphenated, or hyphen free.
###
### Author, editor, and page count fields in the database are set to
### -1, rather than 0, to indicate missing data.
###
### The database created has three tables, bibtab, namtab, and strtab,
### with these named fields:
###
###	% sqlite3 foo.db
###	sqlite> .schema
###	CREATE TABLE bibtab (
###	        authorcount  INTEGER,
###	        editorcount  INTEGER,
###	        pagecount    INTEGER,
###	        bibtype      TEXT,
###	        filename     TEXT,
###	        label        TEXT,
###	        author       TEXT,
###	        editor       TEXT,
###	        booktitle    TEXT,
###	        title        TEXT,
###	        crossref     TEXT,
###	        chapter      TEXT,
###	        journal      TEXT,
###	        volume       TEXT,
###	        type         TEXT,
###	        number       TEXT,
###	        institution  TEXT,
###	        organization TEXT,
###	        publisher    TEXT,
###	        school       TEXT,
###	        address      TEXT,
###	        edition      TEXT,
###	        pages        TEXT,
###	        day          TEXT,
###	        month        TEXT,
###	        monthnumber  TEXT,
###	        year         TEXT,
###	        CODEN        TEXT,
###	        DOI          TEXT,
###	        ISBN         TEXT,
###	        ISBN13       TEXT,
###	        ISSN         TEXT,
###	        LCCN         TEXT,
###	        MRclass      TEXT,
###	        MRnumber     TEXT,
###	        MRreviewer   TEXT,
###	        bibdate      TEXT,
###	        bibsource    TEXT,
###	        bibtimestamp TEXT,
###	        note         TEXT,
###	        series       TEXT,
###	        URL          TEXT,
###	        abstract     TEXT,
###	        keywords     TEXT,
###	        remark       TEXT,
###	        subject      TEXT,
###	        TOC          TEXT,
###	        ZMnumber     TEXT,
###	        entry        TEXT NOT NULL UNIQUE
###	);
###
###	CREATE TABLE namtab (
###	        name         TEXT NOT NULL UNIQUE,
###	        count        INTEGER
###	);
###
###	CREATE TABLE strtab (
###	        key          TEXT,
###	        value        TEXT,
###	        entry        TEXT NOT NULL UNIQUE
###	);
###
### The bibtab table contains BibTeX document entry data, the namtab
### table contains author and editor names and their usage counts, and
### the strtab table contains @String{key = value} data.  BibTeX
### @Preamble{...}  material and BibTeX comments are not recorded in
### the SQL database tables.
###
### Except in the entry columns of the tables, consecutive whitespace in
### the original data is collapsed to a single space, TeX macros are
### simplified or removed, and TeX accents and braces are stripped.
### This reduction facilitates later lookups: a search for "New York"
### will not miss entries that had "New  York" (two spaces), and a search
### for Paul Erd{\H{o}s can be done with the pattern "%P%Erdos%",
### and books with {\TeX}book in their titles can be found with the
### pattern "%texbook%".
###
### Sample database creation:
###
###	% mysql --socket=/var/lib/mysql/mysql.sock -u bibtex < foo.sql
###
###	% psql mytest -U bibtex < foo.sql
###
###	% psql mytest -U bibtex
###	psql=> \i foo.sql
###
###	% sqlite3 mybibtex.db < foo.sql
###
###	% sqlite3 mybibtex.db
###	sqlite> .read foo.sql
###	sqlite> .exit
###
### Sample database searches:
###
###	% sqlite3 mybibtex.db
###	sqlite> select Entry from bibtab where year = 2008 and type = 'Book';
###	sqlite> select Entry from bibtab where ISBN like '%0-201-15790-X%';
###	sqlite> select Entry from bibtab where ISBN like '%020115790X%';
###	sqlite> select Entry from bibtab where ISBN like '%0201%';
###	sqlite> select Entry from bibtab where publisher = "pub-AW" and year > 2006;
###	sqlite> select Entry from bibtab where authorcount > 12;
###	sqlite> select publisher from bibtab where editorcount > 6;
###	sqlite> select title from bibtab where isbn like '%0-89871-294-7%';
###	sqlite> select title from bibtab where title like '%floating%' or title like '%arithmetic%';
###	sqlite> select author, title, volume from bibtab where title like '%computer arithmetic%';
###	sqlite> select author, title, year from bibtab where label like "%:192%";
###	sqlite> select count(*) from bibtab;
###	sqlite> select avg(year) from bibtab;
###	sqlite> select year,title,author,editor from bibtab where abstract like '% decimal%'
###	...>    or keywords like '% decimal%' or toc like '% decimal%' order by year desc;
###	sqlite> select distinct series from bibtab where series like 'ser-%' order by series;
###	sqlite> select distinct publisher from bibtab where publisher glob 'pub-[XYZ]*';
###
###	sqlite> select name from namtab where name like '%Knuth%';
###	sqlite> select count, name from namtab where name like '%D%Knuth%' order by count;
###
###	sqlite> select entry from strtab where key like 'pub-%MCGRAW%';
###	sqlite> select entry from strtab where value like '%New York%';
###
### [23-Oct-2008]
### ====================================================================

BEGIN 		{ initialize() }

/^%/		{ next }

/^@String/	{ collect_str($0) }

/^@Preamble/	{ next }

/^@/,/^}/	{ collect_entry($0) }

END		{ terminate() }

### ====================================================================

function collect_entry(s)
{
    if (substr(s,1,1) == "@")
    {
	Entry = s

	Label = s
	sub("^[^{]*{", "", Label)
	sub(",.*$", "", Label)

	## Standardize Bibtype to lowercase form: article, book, etc.
	## to ease searching
	Bibtype = substr(s,2)
	sub("{.*$", "", Bibtype)
	Bibtype = tolower(Bibtype)

	Abstract = ""
	Address = ""
	Author = ""
	Bibdate = ""
	Bibsource = ""
	Booktitle = ""
	Chapter = ""
	CODEN = ""
	Crossref = ""
	Day = ""
	DOI = ""
	Editor = ""
	Edition = ""
	Institution = ""
	ISBN = ""
	ISBN13 = ""
	ISSN = ""
	Journal = ""
	Keywords = ""
	LCCN = ""
	Month = ""
	MRclass = ""
	MRnumber = ""
	MRreviewer = ""
	Note = ""
	Number = ""
	Organization = ""
	Publisher = ""
	Remark = ""
	School = ""
	Subject = ""
	Title = ""
	Type = ""
	TOC = ""
	URL = ""
	Volume = ""
	Year = ""
 	Series = ""
 	ZMnumber = ""
#SV120707 adding fields
	citations = 0
	citelinks = ""
	query = ""
	instrument = ""
	facilitiy = ""
	falseHit = ""
	primaryData = ""
	dateCreated = ""
	lastUpdated = ""
#SV120707 done

	In_abstract = 0
	In_author = 0
	In_bibdate = 0
	In_bibsource = 0
	In_booktitle = 0
	In_chapter = 0
	In_CODEN = 0
	In_crossref = 0
	In_DOI = 0
	In_editor = 0
	In_edition = 0
	In_institution = 0
	In_ISBN = 0
	In_ISBN13 = 0
	In_ISSN = 0
	In_journal = 0
	In_keywords = 0
	In_LCCN = 0
	In_month = 0
	In_MRclass = 0
	In_MRnumber = 0
	In_note = 0
	In_number = 0
	In_organization = 0
	In_pages = 0
	In_publisher = 0
	In_remark = 0
	In_school = 0
	In_address = 0
	In_series = 0
	In_subject = 0
	In_title = 0
	In_type = 0
	In_TOC = 0
	In_URL = 0
	In_volume = 0
	In_year = 0
	In_ZMnumber = 0
#SV120707 Adding our fields
	In_citations = 0
	In_citelinks = 0
	In_query = 0
	In_instrument = 0
	In_facility = 0
	In_falseHit = 0
	In_primaryData = 0
	In_dateCreated = 0
	In_lastUpdated = 0
     }
#SV120707 done
    else
	Entry = (Entry "\n" s)

    if (s ~ "^ *abstract *=")
    {
	Abstract = s
	In_abstract = (s !~ "\", *$")
    }
    else if (In_abstract)
    {
	Abstract = Abstract " " s
	if (s ~ "\", *$")
	    In_abstract = 0
    }
    else if (s ~ "^ *author *=")
    {
	Author = s
	In_author = (s !~ "\", *$")
    }
    else if (In_author)
    {
	Author = Author " " s
	if (s ~ "\", *$")
	    In_author = 0
    }
    else if (s ~ "^ *editor *=")
    {
	Editor = s
	In_editor = (s !~ "\", *$")
    }
    else if (In_editor)
    {
	Editor = Editor " " s
	if (s ~ "\", *$")
	    In_editor = 0
    }
    else if (s ~ "^ *booktitle *=")
    {
	Booktitle = s
	In_booktitle = (s !~ "\", *$")
    }
    else if (In_booktitle)
    {
	Booktitle = Booktitle " " s
	if (s ~ "\", *$")
	    In_booktitle = 0
    }
    else if (s ~ "^ *title *=")
    {
	Title = s
	In_title = (s !~ "\", *$")
    }
    else if (In_title)
    {
	Title = Title " " s
	if (s ~ "\", *$")
	    In_title = 0
    }
    else if (s ~ "^ *edition *=")
    {
	Edition = s
	In_edition = (s !~ "\", *$")
    }
    else if (In_edition)
    {
	Edition = Edition " " s
	if (s ~ "\", *$")
	    In_edition = 0
    }
    else if (s ~ "^ *type *=")
    {
	Type = s
	In_type = (s !~ "\", *$")
    }
    else if (In_type)
    {
	Type = Type " " s
	if (s ~ "\", *$")
	    In_type = 0
    }
    else if (s ~ "^ *institution *=")
    {
	Institution = s
	if (s ~ "\"")
	    In_institution = (s !~ "\", *$")
	else
	    In_institution = (s !~ ", *$")
    }
    else if (In_institution)
    {
	Institution = Institution " " s
	if (s ~ "\", *$")
	    In_institution = 0
    }
    else if (s ~ "^ *journal *=")
    {
	Journal = s
	if (s ~ "\"")
	    In_journal = (s !~ "\", *$")
	else
	    In_journal = (s !~ ", *$")
    }
    else if (In_journal)
    {
	Journal = Journal " " s
	if (s ~ "\", *$")
	    In_journal = 0
    }
    else if (s ~ "^ *organization *=")
    {
	Organization = s
	if (s ~ "\"")
	    In_organization = (s !~ "\", *$")
	else
	    In_organization = (s !~ ", *$")
    }
    else if (In_organization)
    {
	Organization = Organization " " s
	if (s ~ "\", *$")
	    In_organization = 0
    }
    else if (s ~ "^ *publisher *=")
    {
	Publisher = s
	if (s ~ "\"")
	    In_publisher = (s !~ "\", *$")
	else
	    In_publisher = (s !~ ", *$")
    }
    else if (In_publisher)
    {
	Publisher = Publisher " " s
	if (s ~ "\", *$")
	    In_publisher = 0
    }
    else if (s ~ "^ *school *=")
    {
	School = s
	if (s ~ "\"")
	    In_school = (s !~ "\", *$")
	else
	    In_school = (s !~ ", *$")
    }
    else if (In_school)
    {
	School = School " " s
	if (s ~ "\", *$")
	    In_school = 0
    }
    else if (s ~ "^ *address *=")
    {
	Address = s
	if (s ~ "\"")
	    In_address = (s !~ "\", *$")
	else
	    In_address = (s !~ ", *$")
    }
    else if (In_address)
    {
	Address = Address " " s
	if (s ~ "\", *$")
	    In_address = 0
    }
    else if (s ~ "^ *crossref *=")
    {
	Crossref = s
	In_crossref = (s !~ "\", *$")
    }
    else if (In_crossref)
    {
	Crossref = Crossref " " s
	if (s ~ "\", *$")
	    In_crossref = 0
    }
    else if (s ~ "^ *bibdate *=")
    {
	Bibdate = s
	In_bibdate = (s !~ "\", *$")
    }
    else if (In_bibdate)
    {
	Bibdate = Bibdate " " s
	if (s ~ "\", *$")
	    In_bibdate = 0
    }
    else if (s ~ "^ *bibsource *=")
    {
	Bibsource = s
	In_bibsource = (s !~ "\", *$")
    }
    else if (In_bibsource)
    {
	Bibsource = Bibsource " " s
	if (s ~ "\", *$")
	    In_bibsource = 0
    }
    else if (s ~ "^ *chapter *=")
    {
	Chapter = s
	In_chapter = (s !~ "\", *$")
    }
    else if (In_chapter)
    {
	Chapter = Chapter " " s
	if (s ~ "\", *$")
	    In_chapter = 0
    }
    else if (s ~ "^ *keywords *=")
    {
	Keywords = s
	In_keywords = (s !~ "\", *$")
    }
    else if (In_keywords)
    {
	Keywords = Keywords " " s
	if (s ~ "\", *$")
	    In_keywords = 0
    }
    else if (s ~ "^ *year *=")
    {
	Year = s
	In_year = (s !~ "\", *$")
    }
    else if (In_year)
    {
	Year = Year " " s
	if (s ~ "\", *$")
	    In_year = 0
    }
    else if (s ~ "^ *ISBN *=")
    {
	ISBN = s
	In_ISBN = (s !~ "\", *$")
    }
    else if (In_ISBN)
    {
	ISBN = ISBN " " s
	if (s ~ "\", *$")
	    In_ISBN = 0
    }
    else if (s ~ "^ *ISBN-13 *=")
    {
	ISBN13 = s
	In_ISBN13 = (s !~ "\", *$")
    }
    else if (In_ISBN13)
    {
	ISBN13 = ISBN13 " " s
	if (s ~ "\", *$")
	    In_ISBN13 = 0
    }
    else if (s ~ "^ *ISSN *=")
    {
	ISSN = s
	In_ISSN = (s !~ "\", *$")
    }
    else if (In_ISSN)
    {
	ISSN = ISSN " " s
	if (s ~ "\", *$")
	    In_ISSN = 0
    }
    else if (s ~ "^ *LCCN *=")
    {
	LCCN = s
	In_LCCN = (s !~ "\", *$")
    }
    else if (In_LCCN)
    {
	LCCN = LCCN " " s
	if (s ~ "\", *$")
	    In_LCCN = 0
    }
    else if (s ~ "^ *CODEN *=")
    {
	CODEN = s
	In_CODEN = (s !~ "\", *$")
    }
    else if (In_CODEN)
    {
	CODEN = CODEN " " s
	if (s ~ "\", *$")
	    In_CODEN = 0
    }
    else if (s ~ "^ *DOI *=")
    {
	DOI = s
	In_DOI = (s !~ "\", *$")
    }
    else if (In_DOI)
    {
	DOI = DOI " " s
	if (s ~ "\", *$")
	    In_DOI = 0
    }
    else if (s ~ "^ *volume *=")
    {
	Volume = s
	In_volume = (s !~ "\", *$")
    }
    else if (In_volume)
    {
	Volume = Volume " " s
	if (s ~ "\", *$")
	    In_volume = 0
    }
    else if (s ~ "^ *number *=")
    {
	Number = s
	In_number = (s !~ "\", *$")
    }
    else if (In_number)
    {
	Number = Number " " s
	if (s ~ "\", *$")
	    In_number = 0
    }
    else if (s ~ "^ *pages *=")
    {
	Pages = s
	In_pages = (s !~ "\", *$")
    }
    else if (In_pages)
    {
	Pages = Pages " " s
	if (s ~ "\", *$")
	    In_pages = 0
    }
    else if (s ~ "^ *day *=")
    {
	Day = s
	In_day = (s !~ "\", *$")
    }
    else if (In_day)
    {
	Day = Day " " s
	if (s ~ "\", *$")
	    In_day = 0
    }
    else if (s ~ "^ *month *=")
    {
	Month = s
	if (s ~ "\"")
	    In_month = (s !~ "\", *$")
	else
	    In_month = (s !~ ", *$")
    }
    else if (In_month)
    {
	Month = Month " " s
	if (s ~ "\", *$")
	    In_month = 0
    }
    else if (s ~ "^ *MRclass *=")
    {
	MRclass = s
	In_MRclass = (s !~ "\", *$")
    }
    else if (In_MRclass)
    {
	MRclass = MRclass " " s
	if (s ~ "\", *$")
	    In_MRclass = 0
    }
    else if (s ~ "^ *MRnumber *=")
    {
	MRnumber = s
	In_MRnumber = (s !~ "\", *$")
    }
    else if (In_MRnumber)
    {
	MRnumber = MRnumber " " s
	if (s ~ "\", *$")
	    In_MRnumber = 0
    }
    else if (s ~ "^ *MRreviewer *=")
    {
	MRreviewer = s
	In_MRreviewer = (s !~ "\", *$")
    }
    else if (In_MRreviewer)
    {
	MRreviewer = MRreviewer " " s
	if (s ~ "\", *$")
	    In_MRreviewer = 0
    }
    else if (s ~ "^ *note *=")
    {
	Note = s
	In_note = (s !~ "\", *$")
    }
    else if (In_note)
    {
	Note = Note " " s
	if (s ~ "\", *$")
	    In_note = 0
    }
    else if (s ~ "^ *remark *=")
    {
	Remark = s
	In_remark = (s !~ "\", *$")
    }
    else if (In_remark)
    {
	Remark = Remark " " s
	if (s ~ "\", *$")
	    In_remark = 0
    }
    else if (s ~ "^ *series *=")
    {
	Series = s
	if (s ~ "\"")
	    In_series = (s !~ "\", *$")
	else
	    In_series = (s !~ ", *$")
    }
    else if (In_series)
    {
	Series = Series " " s
	if (s ~ "\", *$")
	    In_series = 0
    }
    else if (s ~ "^ *subject *=")
    {
	Subject = s
	In_subject = (s !~ "\", *$")
    }
    else if (In_subject)
    {
	Subject = Subject " " s
	if (s ~ "\", *$")
	    In_subject = 0
    }
    else if (s ~ "^ *tableofcontents *=")
    {
	TOC = s
	In_TOC = (s !~ "\", *$")
    }
    else if (In_TOC)
    {
	TOC = TOC " " s
	if (s ~ "\", *$")
	    In_TOC = 0
    }
    else if (s ~ "^ *URL *=")
    {
	URL = s
	In_URL = (s !~ "\", *$")
    }
    else if (In_URL)
    {
	URL = URL " " s
	if (s ~ "\", *$")
	    In_URL = 0
    }
    else if (s ~ "^ *ZMnumber *=")
    {
	ZMnumber = s
	In_ZMnumber = (s !~ "\", *$")
    }
    else if (In_ZMnumber)
    {
	ZMnumber = ZMnumber " " s
	if (s ~ "\", *$")
	    In_ZMnumber = 0
    }
#SV120707 adding our fields as needed
    else if (s ~ "^ *citations *=")
    {
	citations = s
	In_citations = (s !~ "\", *$")
    }
    else if (In_citations)
    {
	citations = citations " " s
	if (s ~ "\", *$")
	    In_citations = 0
    }
    else if (s ~ "^ *citelinks *=")
    {
	citelinks = s
	In_citelinks = (s !~ "\", *$")
    }
    else if (In_citelinks)
    {
	citelinks = citelinks " " s
	if (s ~ "\", *$")
	    In_citelinks = 0
    }
    else if (s ~ "^ *query *=")
    {
	query = s
	In_query = (s !~ "\", *$")
    }
    else if (In_query)
    {
	query = query " " s
	if (s ~ "\", *$")
	    In_query = 0
    }
    else if (s ~ "^ *instrument *=")
    {
	instrument = s
	In_instrument = (s !~ "\", *$")
    }
    else if (In_instrument)
    {
	instrument = instrument " " s
	if (s ~ "\", *$")
	    In_instrument = 0
    }
    else if (s ~ "^ *facility *=")
    {
	facility = s
	In_facility = (s !~ "\", *$")
    }
    else if (In_facility)
    {
	facility = facility " " s
	if (s ~ "\", *$")
	    In_facility = 0
    }
#SV120707 done
    if (substr(s,1,1) == "}")
	do_entry()
}

function collect_str(s,    t)
{
    ## Collect @String{name = "value"} entries, and save in
    ## Strings[1:NS] those that have not been seen before, ignoring
    ## differences in whitespace

    while (s !~ "\" *} *$")	# collect multiline @String{...}
    {
	getline t
	s = (s "\n" t)
    }

    t = s
    gsub("  +", " ", t)

    if (!(t in KnownString))	# then have new @String{...}
    {
	String[++NS] = s
	KnownString[t]++
    }
}

function dehyphen(s)
{   ## Reduce, e.g., 0-201-15790-X to 020115790X
    gsub("-", "", s)
    return (s)
}

function do_entry(    month_number,page_count)
{
    month_number = get_month_number(get_month_value(Month))
    page_count = get_pagecount(get_value(Pages))

#SV120708 figure out the instrument from the query string
    if (index(toupper(get_value(query)),"HIPPO") != 0) {
      instrument = "HIPPO"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"NPDF") != 0) {
      instrument = "NPDF"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"SMARTS") != 0) {
      instrument = "SMARTS"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"HIPD") != 0) {
      instrument = "HIPD"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"FP5") != 0) {
      instrument = "FP5"
      facility 	 = "WNR"
    } else if (index(toupper(get_value(query)),"SCD") != 0) {
      instrument = "SCD"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"FDS") != 0) {
      instrument = "FDS"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"SPEAR") != 0) {
      instrument = "SPEAR"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"LQD") != 0) {
      instrument = "LQD"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"ASTERIX") != 0) {
      instrument = "ASTERIX"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"PCS") != 0) {
      instrument = "PCS"
      facility 	 = "LUJAN"
    } else if (index(toupper(get_value(query)),"PHAROS") != 0) {
      instrument = "PHAROS"
      facility 	 = "LUJAN"
    ## WNR instruments
    } else if (index(toupper(get_value(query)),"1FP12") != 0) {
      instrument = "1FP12"
      facility 	 = "WNR"
    } else if (index(toupper(get_value(query)),"4FP15R") != 0) {
      instrument = "4FP15R"
      facility 	 = "WNR"
    } else if (index(toupper(get_value(query)),"DANCE") != 0) {
      instrument = "DANCE"
      facility 	 = "WNR"
    } else if (index(toupper(get_value(query)),"FIGARO") != 0) {
      instrument = "FIGARO"
      facility 	 = "WNR"
    } else if (index(toupper(get_value(query)),"GEANIE") != 0) {
      instrument = "GEANIE"
      facility 	 = "WNR"
    } else if (index(toupper(get_value(query)),"WNR") != 0) {
      instrument = "WNR"
      facility 	 = "WNR"
    } 
    # if the instument and facility fields are populated in the bib file, use them
    if (get_value(instrument) != "") {
      instrument = get_value(instrument)
    }
    if (get_value(facility) != "") {
      facility = get_value(facility)
    }

#SV120708 done

    print "INSERT INTO bibtab"
    print "\t(authorcount, editorcount, pagecount, bibtype, filename, id,"
    print "\tauthor, editor, booktitle, title, crossref, chapter, journal, volume,"
    print "\ttype, number, institution, organization, publisher, school,"
    print "\taddress, edition, pages, day, month, monthnumber, year, CODEN,"
    print "\tDOI, ISBN, ISBN13, ISSN, LCCN, MRclass, MRnumber, MRreviewer,"
    print "\tbibdate, bibsource, bibtimestamp, note, series, URL, abstract,"
#SV 120707 adding extra fields
    print "\tkeywords, remark, subject, TOC, ZMnumber, citations, citelinks, query, instrument, facility, falsehit, primarydata, date_created, last_updated, entry)"
    print "\tVALUES ("
    printf("\t%s,\n", get_namecount(get_value(Author)))
    printf("\t%s,\n", get_namecount(get_value(Editor)))
    printf("\t%s,\n", (page_count <= 0) ? "NULL" : ("" page_count))
    printf("\t%s,\n", protect(Bibtype))
    printf("\t%s,\n", protect(get_filename(FILENAME)))
    printf("\t%s,\n", protect(Label))
    printf("\t%s,\n", protect(untexify(get_value(Author))))
    printf("\t%s,\n", protect(untexify(get_value(Editor))))
    printf("\t%s,\n", protect(untexify(get_value(Booktitle))))
    printf("\t%s,\n", protect(untexify(get_value(Title))))
    printf("\t%s,\n", protect(get_value(Crossref)))
    printf("\t%s,\n", protect(untexify(get_value(Chapter))))
    printf("\t%s,\n", protect(untexify(get_value(Journal))))
    printf("\t%s,\n", protect(get_value(Volume)))
    printf("\t%s,\n", protect(untexify(get_value(Type))))
    printf("\t%s,\n", protect(get_value(Number)))
    printf("\t%s,\n", protect(untexify(get_value(Institution))))
    printf("\t%s,\n", protect(untexify(get_value(Organization))))
    printf("\t%s,\n", protect(untexify(get_value(Publisher))))
    printf("\t%s,\n", protect(untexify(get_value(School))))
    printf("\t%s,\n", protect(untexify(get_value(Address))))
    printf("\t%s,\n", protect(untexify(get_value(Edition))))
    printf("\t%s,\n", protect(get_value(Pages)))
    printf("\t%s,\n", protect(get_month_value(Day)))
    printf("\t%s,\n", protect(get_month_value(Month)))
    printf("\t%s,\n", ((month_number <= 0) || (12 < month_number)) ? "NULL" : ("'" month_number "'"))
    printf("\t%s,\n", protect(get_value(Year)))
    printf("\t%s,\n", protect(get_value(CODEN)))
    printf("\t%s,\n", protect(get_value(DOI)))
    printf("\t%s,\n", protect(simplify(get_value(ISBN) " OR " dehyphen(get_value(ISBN)))))
    printf("\t%s,\n", protect(simplify(get_value(ISBN13) " OR " dehyphen(get_value(ISBN13)))))
    printf("\t%s,\n", protect(simplify(get_value(ISSN) " OR " dehyphen(get_value(ISSN)))))
    printf("\t%s,\n", protect(get_value(LCCN)))
    printf("\t%s,\n", protect(get_value(MRclass)))
    printf("\t%s,\n", protect(get_value(MRnumber)))
    printf("\t%s,\n", protect(get_value(MRreviewer)))
    printf("\t%s,\n", protect(get_value(Bibdate)))
    printf("\t%s,\n", protect(get_value(Bibsource)))
    printf("\t%s,\n", protect(get_bibtimestamp(get_value(Bibdate))))
    printf("\t%s,\n", protect(untexify(get_value(Note))))
    printf("\t%s,\n", protect(untexify(get_value(Series))))
    printf("\t%s,\n", protect(get_value(URL)))
    printf("\t%s,\n", protect(untexify(get_value(Abstract))))
    printf("\t%s,\n", protect(untexify(get_value(Keywords))))
    printf("\t%s,\n", protect(untexify(get_value(Remark))))
    printf("\t%s,\n", protect(untexify(get_value(Subject))))
    printf("\t%s,\n", protect(untexify(get_value(TOC))))
    printf("\t%s,\n", protect(get_value(ZMnumber)))
#SV120707	adding extra fields
    printf("\t%s,\n", protect(get_value(citations)))
    printf("\t%s,\n", protect(get_value(citelinks)))
    printf("\t%s,\n", protect(get_value(query)))
    printf("\t%s,\n", protect(instrument))
    printf("\t%s,\n", protect(facility))
    printf("\t%s,\n", protect(get_value(falseHit)))
    printf("\t%s,\n", protect(get_value(primaryData)))
    printf("\t%s,\n", protect(get_value(dateCreated)))
    printf("\t%s,\n", protect(get_value(lastUpdated)))
#SV120707 done
    printf("\t%s\n",  protect("\n" Entry))
#    print ");\n"	#SV120707 don't need semicolon yet
#SV120707 add ON DUPLICATE KEY UPDATE clause to update in case the key already exists
    printf("\t) ON DUPLICATE KEY UPDATE citations=%s,citelinks=%s;\n\n", protect(get_value(citations)), protect(get_value(citelinks)))
#SV120707 done

    do_names(get_value(Author))
    do_names(get_value(Editor))
}

function do_names(s,    k,n,parts,t)
{
    if (s != "")
    {
	n = split(s, parts, " and ")

	for (k = 1; k <= n; ++k)
	{
	    t = untexify(parts[k])
	    if (t == "")
		warning("Empty name in s = [" s "]: biblabel = " Biblabel)
	    else
		Names[t]++
	    ## if (parts[k] ~ "Armido") print "DEBUG: [" parts[k] "] - > [" untexify(parts[k]) "]" > "/dev/stderr"
	    ## print "DEBUG: [" parts[k] "] - > [" untexify(parts[k]) "]" > "/dev/stderr"
	}
    }
}

function get_bibtimestamp(s,    n, parts,t)
{   ## convert "Wed Sep 3 17:06:29 MDT 2003" to "2003.09.03 17:06:29 MDT"
    ## to provide a string in odometer order suitable for sorting
    if (s == "")
	t = ""
    else
    {
	n = split(s, parts, " ")	# "Wed Sep 3 17:06:29 MDT 2003"
	if (n == 6)
	    t = sprintf("%04d.%02d.%02d %s %s",
			0 + parts[6],
			get_month_number(parts[2]),
			0 + parts[3],
			parts[4],
			parts[5])
	else if (n == 5)		# "Wed Sep 3 17:06:29 2003"
	    t = sprintf("%04d.%02d.%02d %s %s",
			0 + parts[5],
			get_month_number(parts[2]),
			0 + parts[3],
			parts[4],
			"???")
	else
	    t = ""
    }

    return (t)
}

function get_filename(s,    n,parts)
{   ## return filename from slash-separated pathname
    n = split(s, parts, "/")
    return (parts[n])
}

function get_month_number(s)
{
    return (int(index("xxx jan feb mar apr may jun jul aug sep oct nov dec ",
		      (" " substr(tolower(s),1,3) " ")) / 4))
}

function get_month_value(s)
{   ## Reduce 'month = oct,' to 'oct' and 'month = "October",' to 'oct'

    ## print "DEBUG 1: get_month_value(): s = [" s "]"
    s = get_value(s)

    ## print "DEBUG 2: get_month_value(): s = [" s "]"

    gsub("^ *month *= *", "", s)
    gsub("\"", "", s)
    gsub(", *$", "", s)

    ## print "DEBUG 3: get_month_value(): s = [" s "]"

    if (s in Month_Names)
	s = tolower(substr(s,1,3))

    ## print "DEBUG 4: get_month_value(): s = [" s "]"

    return (s)
}

function get_namecount(s,    n,parts)
{   ## return a single-quoted string with the count of author/editor
    ## names in s, or the string "NULL"
    return ((s == "") ? "NULL" : ("" split(s, parts, " +and +")))
}

function get_pagecount(s,    count,j,k,m,n,parts,pages,pages_alt)
{   ## reduce "20--32" and "17:1--17:13" to 13, "2C6.9--2C6.12" to 4,
    ## "20--32, 35, 37" to 15, "xxiv + 324" to 348, and "20--??" and
    ## others to -1 (indicating unknown value)

    gsub("[0-9]+[/:.]", "", s)	# remove ACM-style article numbers
    n = split(s, parts, " *, *")
    count = 0

    for (k = 1; k <= n; ++k)
    {
	if (parts[k] ~ "^[ivxlcd]+ *[+] *[0-9]+")	# expect roman + arabic + ...
	{
	    ## Sample values:
	    ##	xxvi + 438 + A182 + B62 + C6 + D4 + E4
	    ##	xxiii + 760 + A-77 + B-47 + C-26 + D-26 + E-13 + R-16 + I-14"
	    ##  xi + 603 + 18 + 41
	    ##	ix + 701--1359 + 18 + 41
	    m = split(parts[k], pages, " *[+] *")
	    count += roman_to_integer(pages[1])
	    for (j = 2; j <= m; ++j)
	    {
		sub("^[A-Z]-*", "", pages[j]) # reduce A-17 and A17 to 17

		if (pages[j] ~ "^[0-9]+-+[0-9]+$")
		{
		    split(pages[j], pages_alt, "-+")
		    count += 1 + (pages_alt[2] - pages_alt[1])
		}
		else
		    count += pages[j]
	    }
	}
	else			# expect n1--n2, n3--n4, n5, n6, ...
	{
	    m = split(parts[k], pages, "-+")

	    if (m == 2)
	    {
		sub("[^0-9]", "", pages[1])
		sub("[^0-9]", "", pages[2])
		if ( (pages[1] ~ "[0-9]") && (pages[2] ~ "[0-9]") )
		    count += 1 + (pages[2] - pages[1])
	    }
	    else if (m == 1)
	    {
		sub("[^0-9]", "", pages[1])
		count += (n > 1)	# single page number counted only if in comma-separated list
	    }
	}
    }

    return ((count > 0) ? count : -1)
}

function get_value(s)
{   ## Reduce 'name = "value",' to 'value', and 'name = macro,'
    ## to 'macro', collapsing consecutive whitespace to single spaces
    ## and trimming leading and trailing space

    if (s ~ "^[^=]*= *[A-Za-z]")	# have name = macro
    {
	sub("^[^=]*= ", "", s)
	sub(", *", "", s)
    }
    else				# expect name = "value"
    {
	sub("^[^\"]*\"", "", s)
	sub("\", *$", "", s)
	gsub("[ \t\n][ \t\n]+", " ", s)

	if (s ~ "^[?]+$")	# convert question mark filler to empty string
	    s = ""
    }

    sub("^ +", "", s)		# trim leading space
    sub(" +$", "", s)		# trim trailing space

    return (s)
}

function initialize(    k)
{
    PROGRAM_NAME    = "bibtosql"
    PROGRAM_VERSION = "0.01"
    PROGRAM_DATE    = "24-Mar-2010"

    if (SERVER == "")
	SERVER = "SQLite"

    gsub("[^-_A-Za-z0-9]", "", SERVER) # sanitize server name

    SERVER = tolower(SERVER)

    if (SERVER == "psql")
	SERVER = "postgresql"

    if (!( (SERVER == "mysql") || (SERVER == "postgresql") || (SERVER == "sqlite") ))
    {
	warning("Unsupported or unrecognized database server [" SERVER "]")
	exit(1)
    }

    if (SERVER == "mysql")
    {
	BACKSLASH_IN = "\\\\"		# regexp
	BACKSLASH_OUT = "\\\\"
	QUOTE_IN = "'"			# regexp
	QUOTE_OUT = "\\'"
    }
    else
    {
	BACKSLASH_IN = "\\\\"		# regexp
	BACKSLASH_OUT = "\\"
	QUOTE_IN = "'"			# regexp
	QUOTE_OUT = "''"
    }

    if (DATABASE == "")
	DATABASE = "bibtex"

    gsub("[^-_A-Za-z0-9]", "", DATABASE) # sanitize database name

    CREATEDB += 0

    "date" | getline today
    close("date")

    ## The PostgresSQL manual says in section 2.3, page 7:
    ##     Two dashes ( -- ) introduce comments. Whatever follows them is ignored
    ##     up to the end of the line.
    ##
    ## The MySQL 5.1 manual says in section 1.8.5.6 on pp. 24--25
    ##
    ##     Standard SQL uses the C syntax /* this is a comment */ for
    ##     comments, and MySQL Server supports this syntax as
    ##     well. MySQL also support extensions to this syntax that
    ##     allow MySQL-specific SQL to be embedded in the comment, as
    ##     described in Section 8.5, Comment Syntax.
    ##
    ##     Standard SQL uses "--" as a start-comment sequence. MySQL
    ##     Server uses # as the start comment character. MySQL Server
    ##     3.23.3 and up also supports a variant of the "--" comment
    ##     style. That is, the "--" start-comment sequence must be
    ##     followed by a space (or by a control character such as a
    ##     newline). The space is required to prevent problems with
    ##     automatically generated SQL queries that use constructs
    ##     such as the following, where we automatically insert the
    ##     value of the payment for payment:
    ##
    ##     UPDATE account SET credit=credit-payment
    ##
    ##     Consider about what happens if payment has a negative value
    ##     such as -1:
    ##
    ##     UPDATE account SET credit=credit--1 credit--1
    ##
    ##     is a legal expression in SQL, but "--" is interpreted as
    ##     the start of a comment, part of the expression is
    ##     discarded. The result is a statement that has a completely
    ##     different meaning than intended:
    ##
    ##     UPDATE account SET credit=credit
    ##
    ##     The statement produces no change in value at all. This
    ##     illustrates that allowing comments to start with
    ##     "--" can have serious consequences.
    ##
    ##     Using our implementation requires a space following the
    ##     "--" in order for it to be recognized as a start-comment
    ##     sequence in MySQL Server 3.23.3 and newer. Therefore,
    ##     credit--1 is safe to use.
    ##
    ##     Another safe feature is that the mysql command-line client
    ##     ignores lines that start with "--" .
    ##
    ## That last paragraph suggests that a line of dashes is a
    ## comment, but it is not: it gets treated as an illegal command.
    ## We therefore need to insert a space after the initial "--".

    print "-- ---------------------------------------------------------------------"
    print "-- Do NOT edit this file.  It was created automatically for use with the"
    print "--", SERVER, "SQL database system by", PROGRAM_NAME, "version", PROGRAM_VERSION, PROGRAM_DATE
    print "-- by", ENVIRON["USER"] "@" ENVIRON["HOST"]
    print "-- on", today
    print "-- in", ENVIRON["PWD"]
    print "-- from", (ARGC > 1) ? "these BibTeX files:" : "data on stdin."

    for (k = 1; k < ARGC; ++k)
    {
	s = ARGV[k]
	gsub("[^-/._A-Za-z0-9]", "", s)	# protect against nonstandard characters in filenames
	print "--\t" s
    }

    print "-- ---------------------------------------------------------------------"
    print ""

    if (CREATEDB)
    {
	if (SERVER == "mysql")
	{
	    print "USE " DATABASE ";" # SV120707	seems to be necessary to select first, then drop
	    print ""
	    print "DROP TABLE IF EXISTS bibtab;"
	    print ""
	    print "DROP TABLE IF EXISTS namtab;"
	    print ""
	    print "DROP TABLE IF EXISTS strtab;"
	    print ""
	    print "DROP DATABASE IF EXISTS " DATABASE ";"
	    print ""
	    print "CREATE DATABASE " DATABASE ";"
	    print ""
	    print "USE " DATABASE ";"
	    print ""
	}
	else if (SERVER == "postgresql")
	{
	    print "DROP TABLE IF EXISTS bibtab;"
	    print ""
	    print "DROP TABLE IF EXISTS namtab;"
	    print ""
	    print "DROP TABLE IF EXISTS strtab;"
	    print ""
	    print "DROP DATABASE IF EXISTS " DATABASE ";"
	    print ""
	    print "CREATE DATABASE " DATABASE ";"
	    print ""
	}
	else if (SERVER == "sqlite")
	{
	    ## CREATE/DROP DATABASE not recognized in SQLite
	    print "DROP TABLE IF EXISTS bibtab;"
	    print ""
	    print "DROP TABLE IF EXISTS namtab;"
	    print ""
	    print "DROP TABLE IF EXISTS strtab;"
	    print ""
	}

	if (SERVER == "mysql")
	{
	    TEXT = "TEXT(32767)"	# TEXT requires a typical length (which can be somewhat exceeded)
	    UNIQUE = ""			# UNIQUE not supported
	}
	else if (SERVER == "postgresql")
	{
	    TEXT = "TEXT"
	    UNIQUE = ""			# UNIQUE not supported
	}
	else				# SQLITE (and others) have both TEXT and UNIQUE
	{
	    TEXT = "TEXT"
	    UNIQUE = "UNIQUE"
	}

	## We drop the UNIQUE attribute for PostgreSQL because it then
	## terminates input at the first duplicate entry, sigh ... what
	## a silly practice in software that supports automated import
	## of large amounts of data!

	print "CREATE TABLE strtab ("

	if (SERVER == "mysql")	# key is a reserved word: protect it with backquotes
	    print "\t`key`        " TEXT ","
	else
	    print "\tkey          " TEXT ","

	print "\tvalue        " TEXT ","
	print "\tentry        " TEXT " NOT NULL " UNIQUE
	print ");\n"

	print "CREATE TABLE namtab ("
	print "\tname         " TEXT " NOT NULL " UNIQUE ","
	print "\tcount        INTEGER"
	print ");\n"

	print "CREATE TABLE bibtab ("
	print "\tauthorcount  INTEGER,"
	print "\teditorcount  INTEGER,"
	print "\tpagecount    INTEGER,"
	print "\tbibtype      " TEXT ","
	print "\tfilename     " TEXT ","
# SV120707 make label a VARCHAR(100) to have a key of limited length, rename to id for grails compatibility
	print "\tid        VARCHAR(100),"
#	print "\tlabel        " TEXT ","
# SV120707 Make label primary key so we can find previous entries
	print "\tPRIMARY KEY (`id`)," 
# SV120708 Insert field version for grails lock mechanism
	print "\tversion      INTEGER,"
	print "\tauthor       " TEXT ","
	print "\teditor       " TEXT ","
	print "\tbooktitle    " TEXT ","
	print "\ttitle        " TEXT ","
	print "\tcrossref     " TEXT ","
	print "\tchapter      " TEXT ","
	print "\tjournal      " TEXT ","
	print "\tvolume       " TEXT ","
	print "\ttype         " TEXT ","
	print "\tnumber       " TEXT ","
	print "\tinstitution  " TEXT ","
	print "\torganization " TEXT ","
	print "\tpublisher    " TEXT ","
	print "\tschool       " TEXT ","
	print "\taddress      " TEXT ","
	print "\tedition      " TEXT ","
	print "\tpages        " TEXT ","
	print "\tday          " TEXT ","
	print "\tmonth        " TEXT ","
	print "\tmonthnumber  " TEXT ","
	print "\tyear         " TEXT ","
	print "\tCODEN        " TEXT ","
	print "\tDOI          " TEXT ","
	print "\tISBN         " TEXT ","
	print "\tISBN13       " TEXT ","
	print "\tISSN         " TEXT ","
	print "\tLCCN         " TEXT ","
	print "\tMRclass      " TEXT ","
	print "\tMRnumber     " TEXT ","
	print "\tMRreviewer   " TEXT ","
	print "\tbibdate      " TEXT ","
	print "\tbibsource    " TEXT ","
	print "\tbibtimestamp " TEXT ","
	print "\tnote         " TEXT ","
	print "\tseries       " TEXT ","
	print "\tURL          " TEXT ","
	print "\tabstract     " TEXT ","
	print "\tkeywords     " TEXT ","
	print "\tremark       " TEXT ","
	print "\tsubject      " TEXT ","
	print "\tTOC          " TEXT ","
	print "\tZMnumber     " TEXT ","
#SV 120707 start
	print "\tcitations    INTEGER,"
	print "\tcitelinks    " TEXT ","
	print "\tquery        " TEXT ","
	print "\tInstrument   " TEXT ","
	print "\tFacility     " TEXT ","
	print "\tfalsehit     BOOLEAN,"
	print "\tprimarydata  BOOLEAN,"
	print "\tacademia     BOOLEAN,"
	print "\tnationallab  BOOLEAN,"
	print "\tindustry     BOOLEAN,"
	print "\tforeign      BOOLEAN,"
	print "\trefereed     BOOLEAN,"
	print "\thigh_profile BOOLEAN,"
	print "\thigh_impact  BOOLEAN,"
	print "\tstaff_involved BOOLEAN,"
	print "\tdate_created  DATE,"
	print "\tlast_updated  DATE,"
#SV 120707 end
	print "\tentry        " TEXT " NOT NULL " UNIQUE
	print ");\n"
    }

    if (SERVER == "postgresql")
    {
	print "SET standard_conforming_strings = on;"	# important -- suppresses interpretation of backslash in strings
	print ""
    }

    if (SERVER == "mysql")
	print "START TRANSACTION;\n"
    else if (SERVER == "postgresql")
	print "START TRANSACTION;\n"
    else if (SERVER == "sqlite")
	print "BEGIN TRANSACTION;\n"

    Month_Names["January"]	= 1
    Month_Names["February"]	= 1
    Month_Names["March"]	= 1
    Month_Names["April"]	= 1
    Month_Names["May"]		= 1
    Month_Names["June"]		= 1
    Month_Names["July"]		= 1
    Month_Names["August"]	= 1
    Month_Names["September"]	= 1
    Month_Names["October"]	= 1
    Month_Names["November"]	= 1
    Month_Names["December"]	= 1
}

function output_names(    k,key,t,value)
{
    for (key in Names)
	printf("INSERT INTO namtab (name, count) VALUES(%s,\t%d);\n\n",
	       protect(key), Names[key])
}

function output_strings(    k,key,t,value)
{
    for (k = 1; k <= NS; ++k)
    {
	t = String[k]
	sub("^@[Ss][Tt][Rr][Ii][Nn][Gg]", "@String", t)
	t = trim(t)

	key = t
	value = t

	sub("^[^{]+{ *", "", key)
	sub(" *=.*$", "", key)
	key = trim(key)

	sub("^[^=]+= *\"", "", value)
	sub(" *\" *}$", "", value)
	value = trim(squeeze_whitespace(value))

	if (SERVER == "mysql")	# key is a reserved word: protect it with backquotes
	    printf("INSERT INTO strtab\n\t(`key`, value, entry)\n")
	else
	    printf("INSERT INTO strtab\n\t(key, value, entry)\n")

	printf("\tVALUES(\n\t%s,\n\t%s,\n\t%s\n\t);\n\n",
	       protect(key),
	       protect(untexify(value)),
	       protect(t))
    }
}

function protect(s)
{   ## Convert single quotes to pairs of single quotes
    ## (Fortran/Pascal-style) for representation as 'value'.
    ## MySQL uses backslashed quotes instead.  The result
    ## is either that string surrounded by single quotes,
    ## or else the string "NULL".
    gsub(BACKSLASH_IN, BACKSLASH_OUT, s)
    gsub(QUOTE_IN, QUOTE_OUT, s)
    return ((s == "") ? "NULL" : ("'" s "'"))
}

function roman_digit_value(c, value)
{
    ## This code is a translation of C function roman_digit_value() in bibclean.
    if (c == "i")
	value = 1
    else if (c == "v")
	value = 5
    else if (c == "x")
	value = 10
    else if (c == "l")
	value = 50
    else if (c == "c")
	value = 100
    else if (c == "d")
	value = 500
    else if (c == "m")
	value = 1000
    else
	value = 0
    return (value)
}

function roman_to_integer(s, k,last_value,n,number,value)
{
    ## This code is a translation of C function romtol() in bibclean.
    gsub("[ \t]","",s)
    s = tolower(s)
    last_value = 0
    number = 0
    if (!match(s,"^[ivxlcdm]+$"))
	warning("invalid roman digit in [" s "]: string converted to 0")
    else
    {
	n = length(s)
	for (k = 1; k <= n; ++k)
	{
	    value = roman_digit_value(substr(s,k,1))
	    if (value == 0)
	    {
		warning("internal confusion: [" substr(s,k,1) "] is not a roman digit")
		break
	    }
	    if (value > last_value)
		number -= last_value
	    else
		number += last_value
	    last_value = value
	}
	number += last_value
    }
    ## Checked: 16 unique entries in advquantumchem.bib were correctly converted
    ## print "DEBUG: roman_to_integer(" s ") -> " number > "/tmp/foo.debug"
    return (number)
}
function simplify(s)
{
    return ((s == " OR ") ? "" : s)
}

function squeeze_whitespace(s)
{
    gsub(/[ \t\n][ \t\n]+/, " ", s)
    return (s)
}


function terminate()
{
    output_strings();
    output_names();
    print "COMMIT;"
}

function trim(s)
{
    gsub(/^[ \t]+/,"",s)
    gsub(/[ \t]+$/,"",s)
    return (s)
}

function untexify(s)
{    ## Remove accent control sequences and braces

    s = gensub("\\\\([#$%&_{}])", "\\1", "g", s)		# unprotect LaTeX's seven protected symbols: \% -> % etc
    gsub(" *\\\\endash *", " -- ", s)
    gsub(" *\\\\emdash *", " --- ", s)
    gsub(" *\\\\slash *", " / ", s)
    s = gensub("(\\\\)([IOLiol])([^A-Za-z])", "\\2\\3", "g", s)	# \I -> I, \O -> O, \L -> l
    s = gensub("\\\\[A-Za-z]([^A-Za-z])", "\\1", "g", s)	# \H{o} -> o
    s = gensub("\\\\([A-Za-z]+)", "\\1 ", "g", s)		# \BibTeX -> BibTeX<space>
    gsub("\\\\[^a-zA-Z]", "", s)				# drop all remaining control sequences
    gsub("[{}]", "", s)						# discard remaining braces
    gsub("  +", " ", s)						# reduce consecutive spaces
    return (s)
}

function warning(message)
{
    fflush("")
    print ((Filename != "") ? Filename : FILENAME) ":" FNR ":%%" message > "/dev/stderr"
    fflush("")
}
