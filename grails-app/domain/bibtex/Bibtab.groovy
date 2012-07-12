package bibtex
/*
 * To do:
 * - don't show falsehits in list, but when flagging one, double-check
 * - make users who can see only their instruments
 * - implement search
 * - filter single instrument
 * - disable edit of citations
/**
 * The Bibtab entity.
 *
 * @author  Sven Vogel  LANL
 *
 *
 */
class Bibtab {
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
    String bibtype
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
    String query
    String instrument
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
        instrument(inList:["NPDF","SMARTS","HIPD","HIPPO","FP5","SCD","FDS","SPEAR","LQD","ASTERIX","PCS","PHAROS","1FP12","4FP15R","DANCE","FIGARO","GEANIE",""])
        citations(nullable: true, max: 2147483647)
        url()
        authorcount(nullable: true, max: 2147483647)
        editorcount(nullable: true, max: 2147483647)
        pagecount(nullable: true, max: 2147483647)
        bibtype(inList:["Article","In Proceedings","PhD Thesis","Book","Tech Report"])
        filename()
        editor()
        booktitle()
        crossref()
        chapter()
        journal()
        volume()
        type()
        number()
        institution()
        organization()
        publisher()
        school()
        address()
        edition()
        pages()
        day()
        month()
        monthnumber()
        coden()
        doi()
        isbn()
        isbn13()
        issn()
        lccn()
        mrclass()
        mrnumber()
        mrreviewer()
        bibdate()
        bibsource()
        bibtimestamp()
        note()
        series()
        //abstract()
        keywords()
        remark()
        subject()
        toc()
        zmnumber()
        query()
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
