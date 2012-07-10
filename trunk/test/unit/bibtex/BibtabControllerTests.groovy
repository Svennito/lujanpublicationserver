package bibtex



import org.junit.*
import grails.test.mixin.*

@TestFor(BibtabController)
@Mock(Bibtab)
class BibtabControllerTests {


    def populateValidParams(params) {
      assert params != null
      // TODO: Populate valid properties like...
      //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/bibtab/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.bibtabInstanceList.size() == 0
        assert model.bibtabInstanceTotal == 0
    }

    void testCreate() {
       def model = controller.create()

       assert model.bibtabInstance != null
    }

    void testSave() {
        controller.save()

        assert model.bibtabInstance != null
        assert view == '/bibtab/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/bibtab/show/1'
        assert controller.flash.message != null
        assert Bibtab.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/bibtab/list'


        populateValidParams(params)
        def bibtab = new Bibtab(params)

        assert bibtab.save() != null

        params.id = bibtab.id

        def model = controller.show()

        assert model.bibtabInstance == bibtab
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/bibtab/list'


        populateValidParams(params)
        def bibtab = new Bibtab(params)

        assert bibtab.save() != null

        params.id = bibtab.id

        def model = controller.edit()

        assert model.bibtabInstance == bibtab
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/bibtab/list'

        response.reset()


        populateValidParams(params)
        def bibtab = new Bibtab(params)

        assert bibtab.save() != null

        // test invalid parameters in update
        params.id = bibtab.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/bibtab/edit"
        assert model.bibtabInstance != null

        bibtab.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/bibtab/show/$bibtab.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        bibtab.clearErrors()

        populateValidParams(params)
        params.id = bibtab.id
        params.version = -1
        controller.update()

        assert view == "/bibtab/edit"
        assert model.bibtabInstance != null
        assert model.bibtabInstance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/bibtab/list'

        response.reset()

        populateValidParams(params)
        def bibtab = new Bibtab(params)

        assert bibtab.save() != null
        assert Bibtab.count() == 1

        params.id = bibtab.id

        controller.delete()

        assert Bibtab.count() == 0
        assert Bibtab.get(bibtab.id) == null
        assert response.redirectedUrl == '/bibtab/list'
    }
}
