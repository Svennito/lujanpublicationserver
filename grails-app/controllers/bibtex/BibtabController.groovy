package bibtex

import org.springframework.dao.DataIntegrityViolationException

class BibtabController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)	
        [bibtabInstanceList: Bibtab.list(params), bibtabInstanceTotal: Bibtab.count()]
    }


    def list_without_falsehits() {
        params.max = Math.min(params.max ? params.int('max') : 20, 100)
        [bibtabInstanceList_without_falsehits: Bibtab.createCriteria().list(params) {
	    and {
	        eq("falsehit", false)
	    }},
	    bibtabInstanceTotal_without_falsehits: Bibtab.createCriteria().count() {
	    and {
		// list everyone who is either declared NOT to be falsehit or falsehit is undefined
	        eq("falsehit", false)
	        isNull("falsehit")
	    }}]
	println "without falsehit:", Bibtab.createCriteria().count() {
	    and {
		// list everyone who is either declared NOT to be falsehit or falsehit is undefined
	        eq("falsehit", false)
	        isNull("falsehit")
	    }}
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
}
