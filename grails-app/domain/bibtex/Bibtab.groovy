package bibtex
/*
 * To do:
 * - set default filter settings
 * - disable edit of citations
/**
 * The Bibtab entity.
 *
 * @author  Sven Vogel  LANL
 *
 *
 */
class Bibtab {
    static searchable = true

    static mapping = {
         table 'bibtab'
         // version is set to false, because this isn't available by default for legacy databases
	 // SV 120709 If this is commented out, updates etc. fail
         version false
         // id generator:'identity', column:'label'
         // id column:'label', name:'label'
    }
    String id
    Integer authorcount
    Integer editorcount
    Integer pagecount
    String bibtype	// article, phdthesis etc.
    String filename
    String author
    String editor
    String booktitle
    String title
    String crossref
    String chapter
    String journal
    String volume
    String type
    String number
    String institution
    String organization
    String publisher
    String school
    String address
    String edition
    String pages  
    String day
    String month
    String monthnumber
    String year
    String coden
    String doi
    String isbn
    String isbn13
    String issn
    String lccn
    String mrclass
    String mrnumber
    String mrreviewer
    String bibdate
    String bibsource
    String bibtimestamp
    String note
    String series
    String url
    //String abstract
    String keywords
    String remark
    String subject
    String toc
    String zmnumber
    Integer citations
    String citelinks
    String query
    String instrument
    String facility
    Boolean falsehit
    Boolean primarydata
    Date dateCreated
    Date lastUpdated
    String entry

    static constraints = {
        id(size: 1..100, blank: false, nullable:true)
        author()
        title()
        year()
	// instruments need also be present in bibtosql_sv.awk
        instrument(inList:["NPDF","SMARTS","HIPD","HIPPO","FP5","SCD","FDS","SPEAR","LQD","ASTERIX","PCS","PHAROS","MANAGEMENT","SPALLATION","1FP12","4FP15R","DANCE","FIGARO","GEANIE","WNR",""])
	facility(inList:["LUJAN","WNR",""])
        citations(nullable: true, max: 2147483647)
        url(nullable:true)
        citelinks(nullable:true)
        authorcount(nullable: true, max: 2147483647)
        editorcount(nullable: true, max: 2147483647)
        pagecount(nullable: true, max: 2147483647)
        bibtype(inList:["article","inproceedings","phdthesis","book","techreport","misc"])
        filename(nullable:true)
        editor(nullable:true)
        booktitle(nullable:true)
        crossref(nullable:true)
        chapter(nullable:true)
        journal(nullable:true)
        volume(nullable:true)
        type(nullable:true)
        number(nullable:true)
        institution(nullable:true)
        organization(nullable:true)
        publisher(nullable:true)
        school(nullable:true)
        address(nullable:true)
        edition(nullable:true)
        pages(nullable:true)
        day(nullable:true)
        month(nullable:true)
        monthnumber(nullable:true)
        coden(nullable:true)
        doi(nullable:true)
        isbn(nullable:true)
        isbn13(nullable:true)
        issn(nullable:true)
        lccn(nullable:true)
        mrclass(nullable:true)
        mrnumber(nullable:true)
        mrreviewer(nullable:true)
        bibdate(nullable:true)
        bibsource(nullable:true)
        bibtimestamp(nullable:true)
        note(nullable:true)
        series(nullable:true)
        //abstract()
        keywords(nullable:true)
        remark(nullable:true)
        subject(nullable:true)
        toc(nullable:true)
        zmnumber(nullable:true)
        query(nullable:true)
        falsehit(nullable: true)
        primarydata(nullable: true)
        dateCreated(nullable: true)
        lastUpdated(nullable: true)
        entry(blank: false)
    }
    String toString() {
        return "${id}" 
    }
}
