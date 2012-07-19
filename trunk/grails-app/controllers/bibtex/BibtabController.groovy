package bibtex

import org.springframework.dao.DataIntegrityViolationException

class BibtabController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
	// SV 120714 Trying filter, following http://kiwigrails.blogspot.com/2008/07/filtering-list.html
	if (!params.FilterFacility) {
	  params.FilterFacility = ""
	}
	if (!params.FilterName) {
	  params.FilterName = ""
	}
	if (!params.FilterYear) {
	  params.FilterYear= ""
	}
	if (!params.FilterInst) {
	  params.FilterInst = ""
	}
	flash.FilterFacility = params.FilterFacility
	flash.FilterName = params.FilterName
	flash.FilterYear = params.FilterYear
	flash.FilterInst = params.FilterInst
	// end
        params.max = Math.min(params.max ? params.int('max') : 10, 100)	

	// SV 120714 Trying filter, following http://kiwigrails.blogspot.com/2008/07/filtering-list.html
	def query
	def criteria = Bibtab.createCriteria()
	def results

	println "FilterFacility: <"+params.FilterFacility+">"
	println "FilterName: <"+params.FilterName+">"
	println "FilterYear: <"+params.FilterYear+">"
	println "FilterInst: <"+params.FilterInst+">"
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
	
	results = criteria.list(params, query)
	println "results.count: <"+results.getTotalCount()+">"
	render(view:'list', model:[ bibtabInstanceList: results ])
	// end
        // [bibtabInstanceList: Bibtab.list(params), bibtabInstanceTotal: Bibtab.count()] // SV 120717 removed
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
	    
	    if (!bibtabInstance.save(flush: true)) {
		render(view: "edit", model: [bibtabInstance: bibtabInstance])
		return
	    }

		    flash.message = message(code: 'default.updated.message', args: [message(code: 'bibtab.label', default: 'Bibtab'), bibtabInstance.id])
	    redirect(action: "list")
	}
    }
}
