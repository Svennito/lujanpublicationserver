// controls the operations (list, update, delete etc.)
package bibtex

import org.springframework.dao.DataIntegrityViolationException
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class BibtabController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    // SV 120719 export functions
    def exportService 

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
	// SV 120714 Trying filter, following http://kiwigrails.blogspot.com/2008/07/filtering-list.html
	// each time we hit the filter button, the values are written to the cookies
	// if a record was deleted or so, the cookies have the last valid entries
	// so we can always read the cookies
	params.FilterFacility	= g.cookie(name:"LPS_filter_facility")
	params.FilterName	= g.cookie(name:"LPS_filter_name")
	params.FilterYear	= g.cookie(name:"LPS_filter_year")
	params.FilterInst	= g.cookie(name:"LPS_filter_instr")
	// if we received an offset from flash (previous redirect), make it a parameter
	if (flash.offset) { params.offset = flash.offset }

	// transfer settings to flash so we can use it again
	flash.FilterFacility	= params.FilterFacility
	flash.FilterName	= params.FilterName
	flash.FilterYear	= params.FilterYear
	flash.FilterInst	= params.FilterInst
	println "flash: <"+flash+">"
	flash.offset		= params.offset
	println "flash: <"+flash+">"
	// end
        params.max = Math.min(params.max ? params.int('max') : 10, 100)	

	// SV 120714 Trying filter, following http://kiwigrails.blogspot.com/2008/07/filtering-list.html
	def query
	def criteria = Bibtab.createCriteria()
	def results

	println "FilterFacility: <"+params.FilterFacility+"> + Cookie: <"+g.cookie(name:"LPS_filter_facility")+"> + flash: <"+flash.FilterFacility+">"
	println "FilterName: <"+params.FilterName+"> + Cookie: <"+g.cookie(name:"LPS_filter_name")+"> + flash: <"+flash.FilterName+">"
	println "FilterYear: <"+params.FilterYear+"> + Cookie: <"+g.cookie(name:"LPS_filter_year")+"> + flash: <"+flash.FilterYear+">"
	println "FilterInst: <"+params.FilterInst+"> + Cookie: <"+g.cookie(name:"LPS_filter_instr")+"> + flash: <"+flash.FilterInst+">"
	
	query = {
	  and {
	    like("facility", '%'+params.FilterFacility + '%')
	    like("author", '%'+params.FilterName + '%')
	    like("year", '%'+params.FilterYear + '%')
	    like("instrument", '%'+params.FilterInst + '%')
	    or {
	      eq("falsehit", false)
	      isNull("falsehit")
	    }
	    
	  }
	}
	
	if(params?.format && params.format != "html"){
		// we're exporting, params.max needs to be set before query is executed
		println "We're exporting, setting max to 1000..."
		params.max = 1000
	}
	
	results = criteria.list(params, query)
	println "results.count: <"+results.getTotalCount()+">"
	println "params: <"+params+">"
	println "flash: <"+flash+">"
	
	// are we outputting anything else than HTML? 
	if(params?.format && params.format != "html"){
		// we're exporting
		println "We're exporting..."
		response.contentType = ConfigurationHolder.config.grails.mime.types[params.format]
		response.setHeader("Content-disposition", "attachment; filename=${params.FilterFacility}_${params.FilterInst}_${params.FilterName}_${params.FilterYear}.${params.extension}")
		
		List fields = ["author", "title", "journal","year","bibtype","instrument","citations"]
		Map labels = ["author": "Author", "title": "Title", "journal":"Journal", "year":"Year", "bibtype":"Type", "instrument":"Instrument","citations":"Citations"]
		// Formatter closure
		def replace_and = { domain, value ->
			return value.replaceAll(" and ", ", ")
		}

		def assemble_cite = { domain, value ->
			return domain.journal+", "+domain.volume+", "+domain.pages.replaceAll("--", "-")+" ("+domain.year+")"
		}

		Map formatters = [author: replace_and, journal: assemble_cite]		
		Map parameters = ["column.widths": [0.5, 0.9, 0.5, 0.25, 0.25, 0.25, 0.25]]
		params.max = results.getTotalCount()
		exportService.export(params.format, response.outputStream, results, fields, labels, formatters, parameters)
	} 
	render(view:'list', model:[ bibtabInstanceList: results ])
	// end - uncomment following line and comment previous to see unfiltered
        //[bibtabInstanceList: Bibtab.list(params), bibtabInstanceTotal: Bibtab.count()] // SV 120717 removed
    }

    def create() {
        [bibtabInstance: new Bibtab(params)]
    }

    def save() {
        def bibtabInstance = new Bibtab(params)
        if (!bibtabInstance.save(flush: true)) {
            render(view: "create", model: [bibtabInstance: bibtabInstance])
            return
        }

		flash.message = message(code: 'default.created.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), bibtabInstance.id])
        redirect(action: "show", id: bibtabInstance.id)
    }

    def show() {
	println "params: <"+params+">"
	println "flash: <"+flash+">"
        def bibtabInstance = Bibtab.get(params.id)
        if (!bibtabInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), params.id])
            redirect(action: "list")
            return
        }

        [bibtabInstance: bibtabInstance]
    }

    def edit() {
        def bibtabInstance = Bibtab.get(params.id)
        if (!bibtabInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), params.id])
            redirect(action: "list")
            return
        }

        [bibtabInstance: bibtabInstance]
    }

    def update() {
        def bibtabInstance = Bibtab.get(params.id)
        if (!bibtabInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), params.id])
            redirect(action: "list")
            return
        }

        if (params.version) {
            def version = params.version.toLong()
            if (bibtabInstance.version > version) {
                bibtabInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'bibtab.label', default: 'Bibtab')] as Object[],
                          "Another user has updated this Bibtab while you were editing")
                render(view: "edit", model: [bibtabInstance: bibtabInstance])
                return
            }
        }

        bibtabInstance.properties = params

        if (!bibtabInstance.save(flush: true)) {
            render(view: "edit", model: [bibtabInstance: bibtabInstance])
            return
        }

		flash.message = message(code: 'default.updated.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), bibtabInstance.id])
        redirect(action: "show", id: bibtabInstance.id)
    }

    def delete() {
        def bibtabInstance = Bibtab.get(params.id)
        if (!bibtabInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), params.id])
            redirect(action: "list")
            return
        }

        try {
            bibtabInstance.delete(flush: true)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), params.id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
			flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), params.id])
            redirect(action: "show", id: params.id)
        }
    }

    def sort_clicked() {
      // sortable header was clicked, reset the offset
      println "Sortable column was triggered, resetting the offset"
      params.offset = 0
      println "flash: <"+flash+">"
      println "params: <"+params+">"

      redirect(action: "list", params: params)      
    }
    
    // SV 120719 replace delete with false hit
    def set_falsehit() {

	Bibtab.withTransaction { status ->
	    def bibtabInstance = Bibtab.get(params.id)
	    if (!bibtabInstance) {
			    flash.message = message(code: 'default.not.found.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), params.id])
		redirect(action: "list")
		return
	    }

	    if (params.version) {
		def version = params.version.toLong()
		if (bibtabInstance.version > version) {
		    bibtabInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
			      [message(code: 'bibtab.label', default: 'Bibtab')] as Object[],
			      "Another user has updated this Bibtab while you were editing")
		    render(view: "edit", model: [bibtabInstance: bibtabInstance])
		    return
		}
	    }

	    bibtabInstance.properties = params

	    bibtabInstance.falsehit = true
	    println "bibtabInstance.falsehit of "+bibtabInstance.id+": <"+bibtabInstance.falsehit+">"
	    println "params: <"+params+">"
	    println "flash: <"+flash+">"
	    
	    if (!bibtabInstance.save(flush: true)) {
		render(view: "edit", model: [bibtabInstance: bibtabInstance])
		return
	    }

	    flash.message = message(code: 'default.updated.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), bibtabInstance.id])
	    flash.offset  = params.offset
	    println "flash: <"+flash+">"
	    redirect(action: "list")
	}
    }

    // SV 130406 define toggle_lujan_staff
    def toggle_flag(toggle_field) {

	def bibtabInstance = Bibtab.get(params.id)
	if (!bibtabInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), params.id])
	    redirect(action: "list")
	    return
	}
	
	Bibtab.withTransaction { status ->

	    if (params.version) {
		def version = params.version.toLong()
		if (bibtabInstance.version > version) {
		    bibtabInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
			      [message(code: 'bibtab.label', default: 'Bibtab')] as Object[],
			      "Another user has updated this Bibtab while you were editing")
		    render(view: "edit", model: [bibtabInstance: bibtabInstance])
		    return
		}
	    }

	    bibtabInstance.properties = params
	    println "toggle_field: <"+toggle_field+">"

	    if (toggle_field == "lujan_staff") {
		bibtabInstance.lc_staff = !bibtabInstance.lc_staff
		println "bibtabInstance.lc_staff of "+bibtabInstance.id+": <"+bibtabInstance.lc_staff+">"
	    }
	    if (toggle_field == "academia") {
		bibtabInstance.academia = !bibtabInstance.academia
		println "bibtabInstance.academia of "+bibtabInstance.id+": <"+bibtabInstance.academia+">"
	    }
	    if (toggle_field == "nationallab") {
		bibtabInstance.nationallab = !bibtabInstance.nationallab
		println "bibtabInstance.nationallab of "+bibtabInstance.id+": <"+bibtabInstance.nationallab+">"
	    }
	    if (toggle_field == "industry") {
		bibtabInstance.industry = !bibtabInstance.industry
		println "bibtabInstance.industry of "+bibtabInstance.id+": <"+bibtabInstance.industry+">"
	    }
	    if (toggle_field == "foreign") {
		bibtabInstance.non_us = !bibtabInstance.non_us
		println "bibtabInstance.non_us of "+bibtabInstance.id+": <"+bibtabInstance.non_us+">"
	    }
	    if (toggle_field == "high_impact") {
		bibtabInstance.high_impact = !bibtabInstance.high_impact
		println "bibtabInstance.high_impact of "+bibtabInstance.id+": <"+bibtabInstance.high_impact+">"
	    }
	    if (toggle_field == "high_profile") {
		bibtabInstance.high_profile = !bibtabInstance.high_profile
		println "bibtabInstance.high_profile of "+bibtabInstance.id+": <"+bibtabInstance.high_profile+">"
	    }
	    if (toggle_field == "refereed") {
		bibtabInstance.refereed = !bibtabInstance.refereed
		println "bibtabInstance.refereed of "+bibtabInstance.id+": <"+bibtabInstance.refereed+">"
	    }
	    if (toggle_field == "primarydata") {
		bibtabInstance.primarydata = !bibtabInstance.primarydata
		println "bibtabInstance.primarydata of "+bibtabInstance.id+": <"+bibtabInstance.primarydata+">"
	    }
	    if (!bibtabInstance.save(flush: true)) {
		render(view: "show", model: [bibtabInstance: bibtabInstance])
		return
	    }

	    flash.message = message(code: 'default.updated.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), bibtabInstance.id])
	}
        redirect(action: "show", id: bibtabInstance.id)
    }

    def toggle_lujan_staff() {
	toggle_flag("lujan_staff")
    }
    def toggle_academia() {
	toggle_flag("academia")
    }
    def toggle_nationallab() {
	toggle_flag("nationallab")
    }
    def toggle_industry() {
	toggle_flag("industry")
    }
    def toggle_foreign() {
	toggle_flag("foreign")
    }
    def toggle_high_impact() {
	toggle_flag("high_impact")
    }
    def toggle_high_profile() {
	toggle_flag("high_profile")
    }
    def toggle_refereed() {
	toggle_flag("refereed")
    }
    def toggle_primarydata() {
	toggle_flag("primarydata")
    }
}
