<%@ page import="bibtex.Bibtab" %>



<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'author', 'error')} ">
	<label for="author">
		<g:message code="bibtab.author.label" default="Author" />
		
	</label>
	<g:textField name="author" value="${bibtabInstance?.author}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'title', 'error')} ">
	<label for="title">
		<g:message code="bibtab.title.label" default="Title" />
		
	</label>
	<g:textField name="title" value="${bibtabInstance?.title}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'year', 'error')} ">
	<label for="year">
		<g:message code="bibtab.year.label" default="Year" />
		
	</label>
	<g:textField name="year" value="${bibtabInstance?.year}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'instrument', 'error')} ">
	<label for="instrument">
		<g:message code="bibtab.instrument.label" default="Instrument" />
		
	</label>
	<g:select name="instrument" from="${bibtabInstance.constraints.instrument.inList}" value="${bibtabInstance?.instrument}" valueMessagePrefix="bibtab.instrument" noSelection="['': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'citations', 'error')} ">
	<label for="citations">
		<g:message code="bibtab.citations.label" default="Citations" />
		
	</label>
	<g:field type="number" name="citations" max="2147483647" value="${bibtabInstance.citations}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'url', 'error')} ">
	<label for="url">
		<g:message code="bibtab.url.label" default="Url" />
		
	</label>
	<g:textField name="url" value="${bibtabInstance?.url}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'authorcount', 'error')} ">
	<label for="authorcount">
		<g:message code="bibtab.authorcount.label" default="Authorcount" />
		
	</label>
	<g:field type="number" name="authorcount" max="2147483647" value="${bibtabInstance.authorcount}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'editorcount', 'error')} ">
	<label for="editorcount">
		<g:message code="bibtab.editorcount.label" default="Editorcount" />
		
	</label>
	<g:field type="number" name="editorcount" max="2147483647" value="${bibtabInstance.editorcount}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'pagecount', 'error')} ">
	<label for="pagecount">
		<g:message code="bibtab.pagecount.label" default="Pagecount" />
		
	</label>
	<g:field type="number" name="pagecount" max="2147483647" value="${bibtabInstance.pagecount}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'bibtype', 'error')} ">
	<label for="bibtype">
		<g:message code="bibtab.bibtype.label" default="Bibtype" />
		
	</label>
	<g:select name="bibtype" from="${bibtabInstance.constraints.bibtype.inList}" value="${bibtabInstance?.bibtype}" valueMessagePrefix="bibtab.bibtype" noSelection="['': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'filename', 'error')} ">
	<label for="filename">
		<g:message code="bibtab.filename.label" default="Filename" />
		
	</label>
	<g:textField name="filename" value="${bibtabInstance?.filename}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'editor', 'error')} ">
	<label for="editor">
		<g:message code="bibtab.editor.label" default="Editor" />
		
	</label>
	<g:textField name="editor" value="${bibtabInstance?.editor}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'booktitle', 'error')} ">
	<label for="booktitle">
		<g:message code="bibtab.booktitle.label" default="Booktitle" />
		
	</label>
	<g:textField name="booktitle" value="${bibtabInstance?.booktitle}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'crossref', 'error')} ">
	<label for="crossref">
		<g:message code="bibtab.crossref.label" default="Crossref" />
		
	</label>
	<g:textField name="crossref" value="${bibtabInstance?.crossref}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'chapter', 'error')} ">
	<label for="chapter">
		<g:message code="bibtab.chapter.label" default="Chapter" />
		
	</label>
	<g:textField name="chapter" value="${bibtabInstance?.chapter}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'journal', 'error')} ">
	<label for="journal">
		<g:message code="bibtab.journal.label" default="Journal" />
		
	</label>
	<g:textField name="journal" value="${bibtabInstance?.journal}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'volume', 'error')} ">
	<label for="volume">
		<g:message code="bibtab.volume.label" default="Volume" />
		
	</label>
	<g:textField name="volume" value="${bibtabInstance?.volume}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'type', 'error')} ">
	<label for="type">
		<g:message code="bibtab.type.label" default="Type" />
		
	</label>
	<g:textField name="type" value="${bibtabInstance?.type}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'number', 'error')} ">
	<label for="number">
		<g:message code="bibtab.number.label" default="Number" />
		
	</label>
	<g:textField name="number" value="${bibtabInstance?.number}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'institution', 'error')} ">
	<label for="institution">
		<g:message code="bibtab.institution.label" default="Institution" />
		
	</label>
	<g:textField name="institution" value="${bibtabInstance?.institution}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'organization', 'error')} ">
	<label for="organization">
		<g:message code="bibtab.organization.label" default="Organization" />
		
	</label>
	<g:textField name="organization" value="${bibtabInstance?.organization}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'publisher', 'error')} ">
	<label for="publisher">
		<g:message code="bibtab.publisher.label" default="Publisher" />
		
	</label>
	<g:textField name="publisher" value="${bibtabInstance?.publisher}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'school', 'error')} ">
	<label for="school">
		<g:message code="bibtab.school.label" default="School" />
		
	</label>
	<g:textField name="school" value="${bibtabInstance?.school}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'address', 'error')} ">
	<label for="address">
		<g:message code="bibtab.address.label" default="Address" />
		
	</label>
	<g:textField name="address" value="${bibtabInstance?.address}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'edition', 'error')} ">
	<label for="edition">
		<g:message code="bibtab.edition.label" default="Edition" />
		
	</label>
	<g:textField name="edition" value="${bibtabInstance?.edition}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'pages', 'error')} ">
	<label for="pages">
		<g:message code="bibtab.pages.label" default="Pages" />
		
	</label>
	<g:textField name="pages" value="${bibtabInstance?.pages}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'day', 'error')} ">
	<label for="day">
		<g:message code="bibtab.day.label" default="Day" />
		
	</label>
	<g:textField name="day" value="${bibtabInstance?.day}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'month', 'error')} ">
	<label for="month">
		<g:message code="bibtab.month.label" default="Month" />
		
	</label>
	<g:textField name="month" value="${bibtabInstance?.month}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'monthnumber', 'error')} ">
	<label for="monthnumber">
		<g:message code="bibtab.monthnumber.label" default="Monthnumber" />
		
	</label>
	<g:textField name="monthnumber" value="${bibtabInstance?.monthnumber}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'coden', 'error')} ">
	<label for="coden">
		<g:message code="bibtab.coden.label" default="Coden" />
		
	</label>
	<g:textField name="coden" value="${bibtabInstance?.coden}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'doi', 'error')} ">
	<label for="doi">
		<g:message code="bibtab.doi.label" default="Doi" />
		
	</label>
	<g:textField name="doi" value="${bibtabInstance?.doi}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'isbn', 'error')} ">
	<label for="isbn">
		<g:message code="bibtab.isbn.label" default="Isbn" />
		
	</label>
	<g:textField name="isbn" value="${bibtabInstance?.isbn}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'isbn13', 'error')} ">
	<label for="isbn13">
		<g:message code="bibtab.isbn13.label" default="Isbn13" />
		
	</label>
	<g:textField name="isbn13" value="${bibtabInstance?.isbn13}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'issn', 'error')} ">
	<label for="issn">
		<g:message code="bibtab.issn.label" default="Issn" />
		
	</label>
	<g:textField name="issn" value="${bibtabInstance?.issn}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'lccn', 'error')} ">
	<label for="lccn">
		<g:message code="bibtab.lccn.label" default="Lccn" />
		
	</label>
	<g:textField name="lccn" value="${bibtabInstance?.lccn}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'mrclass', 'error')} ">
	<label for="mrclass">
		<g:message code="bibtab.mrclass.label" default="Mrclass" />
		
	</label>
	<g:textField name="mrclass" value="${bibtabInstance?.mrclass}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'mrnumber', 'error')} ">
	<label for="mrnumber">
		<g:message code="bibtab.mrnumber.label" default="Mrnumber" />
		
	</label>
	<g:textField name="mrnumber" value="${bibtabInstance?.mrnumber}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'mrreviewer', 'error')} ">
	<label for="mrreviewer">
		<g:message code="bibtab.mrreviewer.label" default="Mrreviewer" />
		
	</label>
	<g:textField name="mrreviewer" value="${bibtabInstance?.mrreviewer}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'bibdate', 'error')} ">
	<label for="bibdate">
		<g:message code="bibtab.bibdate.label" default="Bibdate" />
		
	</label>
	<g:textField name="bibdate" value="${bibtabInstance?.bibdate}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'bibsource', 'error')} ">
	<label for="bibsource">
		<g:message code="bibtab.bibsource.label" default="Bibsource" />
		
	</label>
	<g:textField name="bibsource" value="${bibtabInstance?.bibsource}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'bibtimestamp', 'error')} ">
	<label for="bibtimestamp">
		<g:message code="bibtab.bibtimestamp.label" default="Bibtimestamp" />
		
	</label>
	<g:textField name="bibtimestamp" value="${bibtabInstance?.bibtimestamp}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'note', 'error')} ">
	<label for="note">
		<g:message code="bibtab.note.label" default="Note" />
		
	</label>
	<g:textField name="note" value="${bibtabInstance?.note}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'series', 'error')} ">
	<label for="series">
		<g:message code="bibtab.series.label" default="Series" />
		
	</label>
	<g:textField name="series" value="${bibtabInstance?.series}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'keywords', 'error')} ">
	<label for="keywords">
		<g:message code="bibtab.keywords.label" default="Keywords" />
		
	</label>
	<g:textField name="keywords" value="${bibtabInstance?.keywords}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'remark', 'error')} ">
	<label for="remark">
		<g:message code="bibtab.remark.label" default="Remark" />
		
	</label>
	<g:textField name="remark" value="${bibtabInstance?.remark}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'subject', 'error')} ">
	<label for="subject">
		<g:message code="bibtab.subject.label" default="Subject" />
		
	</label>
	<g:textField name="subject" value="${bibtabInstance?.subject}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'toc', 'error')} ">
	<label for="toc">
		<g:message code="bibtab.toc.label" default="Toc" />
		
	</label>
	<g:textField name="toc" value="${bibtabInstance?.toc}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'zmnumber', 'error')} ">
	<label for="zmnumber">
		<g:message code="bibtab.zmnumber.label" default="Zmnumber" />
		
	</label>
	<g:textField name="zmnumber" value="${bibtabInstance?.zmnumber}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'query', 'error')} ">
	<label for="query">
		<g:message code="bibtab.query.label" default="Query" />
		
	</label>
	<g:textField name="query" value="${bibtabInstance?.query}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'falsehit', 'error')} ">
	<label for="falsehit">
		<g:message code="bibtab.falsehit.label" default="Falsehit" />
		
	</label>
	<g:checkBox name="falsehit" value="${bibtabInstance?.falsehit}" />
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'primarydata', 'error')} ">
	<label for="primarydata">
		<g:message code="bibtab.primarydata.label" default="Primarydata" />
		
	</label>
	<g:checkBox name="primarydata" value="${bibtabInstance?.primarydata}" />
</div>

<div class="fieldcontain ${hasErrors(bean: bibtabInstance, field: 'entry', 'error')} required">
	<label for="entry">
		<g:message code="bibtab.entry.label" default="Entry" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="entry" required="" value="${bibtabInstance?.entry}"/>
</div>

