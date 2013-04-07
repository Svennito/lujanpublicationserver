
<%@ page import="bibtex.Bibtab" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'bibtab.label', default: 'Bibtab')}" />
<!-- SV120719
		<title><g:message code="default.show.label" args="[entityName]" /></title> -->
		<title>Show Publication</title>
	</head>
	<body>
		<a href="#show-bibtab" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
<!-- SV 120709 Make links more readable
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
-->
				<li><g:link class="list" action="list">Publication List</g:link></li>
				<li><g:link class="create" action="create">New Publication</g:link></li>
			</ul>
		</div>
		<div id="show-bibtab" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list bibtab">
			
				<g:if test="${bibtabInstance?.author}">
				<li class="fieldcontain">
					<span id="author-label" class="property-label"><g:message code="bibtab.author.label" default="Author" /></span>
					
						<span class="property-value" aria-labelledby="author-label"><g:fieldValue bean="${bibtabInstance}" field="author"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.title}">
				<li class="fieldcontain">
					<span id="title-label" class="property-label"><g:message code="bibtab.title.label" default="Title" /></span>
					
						<span class="property-value" aria-labelledby="title-label"><g:fieldValue bean="${bibtabInstance}" field="title"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.bibtype}">
				<li class="fieldcontain">
					<span id="bibtype-label" class="property-label"><g:message code="bibtab.bibtype.label" default="Bibtype" /></span>
					
						<span class="property-value" aria-labelledby="bibtype-label"><g:fieldValue bean="${bibtabInstance}" field="bibtype"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.year}">
				<li class="fieldcontain">
					<span id="year-label" class="property-label"><g:message code="bibtab.year.label" default="Year" /></span>
					<span class="property-value" aria-labelledby="year-label"><g:fieldValue bean="${bibtabInstance}" field="year"/></span>
				</li>
				</g:if>
			
<!-- If we have a journal name, then we have volume, number, publisher -->
				<g:if test="${bibtabInstance?.journal}">
				<li class="fieldcontain">
					<span id="journal-label" class="property-label"><g:message code="bibtab.journal.label" default="Journal" /></span>
					<span class="property-value" aria-labelledby="journal-label"><g:fieldValue bean="${bibtabInstance}" field="journal"/></span>
					
					<g:if test="${bibtabInstance?.volume}">
						<span id="volume-label" class="property-label"><g:message code="bibtab.volume.label" default="Volume" /></span>
						<span class="property-value" aria-labelledby="volume-label"><g:fieldValue bean="${bibtabInstance}" field="volume"/></span>
					</g:if>
					<g:if test="${bibtabInstance?.number}">
						<span id="number-label" class="property-label"><g:message code="bibtab.number.label" default="Number" /></span>
						<span class="property-value" aria-labelledby="number-label"><g:fieldValue bean="${bibtabInstance}" field="number"/></span>
					</g:if>
				</li>
				</g:if>
						
				<g:if test="${bibtabInstance?.publisher}">
				<li class="fieldcontain">
					<span id="publisher-label" class="property-label"><g:message code="bibtab.publisher.label" default="Publisher" /></span>
					<span class="property-value" aria-labelledby="publisher-label"><g:fieldValue bean="${bibtabInstance}" field="publisher"/></span>
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.institution}">
				<li class="fieldcontain">
					<span id="institution-label" class="property-label"><g:message code="bibtab.institution.label" default="Institution" /></span>
					
						<span class="property-value" aria-labelledby="institution-label"><g:fieldValue bean="${bibtabInstance}" field="institution"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.organization}">
				<li class="fieldcontain">
					<span id="organization-label" class="property-label"><g:message code="bibtab.organization.label" default="Organization" /></span>
					
						<span class="property-value" aria-labelledby="organization-label"><g:fieldValue bean="${bibtabInstance}" field="organization"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.school}">
				<li class="fieldcontain">
					<span id="school-label" class="property-label"><g:message code="bibtab.school.label" default="School" /></span>
					
						<span class="property-value" aria-labelledby="school-label"><g:fieldValue bean="${bibtabInstance}" field="school"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.address}">
				<li class="fieldcontain">
					<span id="address-label" class="property-label"><g:message code="bibtab.address.label" default="Address" /></span>
					
						<span class="property-value" aria-labelledby="address-label"><g:fieldValue bean="${bibtabInstance}" field="address"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.edition}">
				<li class="fieldcontain">
					<span id="edition-label" class="property-label"><g:message code="bibtab.edition.label" default="Edition" /></span>
					
						<span class="property-value" aria-labelledby="edition-label"><g:fieldValue bean="${bibtabInstance}" field="edition"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.pages}">
				<li class="fieldcontain">
					<span id="pages-label" class="property-label"><g:message code="bibtab.pages.label" default="Pages" /></span>
					
						<span class="property-value" aria-labelledby="pages-label"><g:fieldValue bean="${bibtabInstance}" field="pages"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.day}">
				<li class="fieldcontain">
					<span id="day-label" class="property-label"><g:message code="bibtab.day.label" default="Day" /></span>
					
						<span class="property-value" aria-labelledby="day-label"><g:fieldValue bean="${bibtabInstance}" field="day"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.month}">
				<li class="fieldcontain">
					<span id="month-label" class="property-label"><g:message code="bibtab.month.label" default="Month" /></span>
					
						<span class="property-value" aria-labelledby="month-label"><g:fieldValue bean="${bibtabInstance}" field="month"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.monthnumber}">
				<li class="fieldcontain">
					<span id="monthnumber-label" class="property-label"><g:message code="bibtab.monthnumber.label" default="Monthnumber" /></span>
					
						<span class="property-value" aria-labelledby="monthnumber-label"><g:fieldValue bean="${bibtabInstance}" field="monthnumber"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.instrument}">
				<li class="fieldcontain">
					<span id="instrument-label" class="property-label"><g:message code="bibtab.instrument.label" default="Instrument" /></span>
					
						<span class="property-value" aria-labelledby="instrument-label"><g:fieldValue bean="${bibtabInstance}" field="instrument"/></span>
					
				</li>
				</g:if>
			
				<li class="fieldcontain">
					At least one authors is:<br>
					<span id="lc_staff-label" class="property-label"><g:message code="bibtab.lc_staff.label" default="Lujan Staff" /></span>
					<span class="property-value" aria-labelledby="lc_staff-label"><g:formatBoolean boolean="${bibtabInstance?.lc_staff}" /></span>
					
					<span id="academia-label" class="property-label"><g:message code="bibtab.academia.label" default="Academia" /></span>
					<span class="property-value" aria-labelledby="academia-label"><g:formatBoolean boolean="${bibtabInstance?.academia}" /></span>

					<span id="nationallab-label" class="property-label"><g:message code="bibtab.nationallab.label" default="National Lab" /></span>
					<span class="property-value" aria-labelledby="nationallab-label"><g:formatBoolean boolean="${bibtabInstance?.nationallab}" /></span>

					<span id="industry-label" class="property-label"><g:message code="bibtab.industry.label" default="Industry" /></span>
					<span class="property-value" aria-labelledby="industry-label"><g:formatBoolean boolean="${bibtabInstance?.industry}" /></span>
					
					<span id="non_us-label" class="property-label"><g:message code="bibtab.non_us.label" default="Foreign" /></span>
					<span class="property-value" aria-labelledby="non_us-label"><g:formatBoolean boolean="${bibtabInstance?.non_us}" /></span>

				</li>
				<g:form>
					<fieldset class="buttons"> Toggles: 
						<g:hiddenField name="id" value="${bibtabInstance?.id}" />
						<g:actionSubmit class="delete" action="toggle_lujan_staff" params="${flash}" value="Lujan Staff" onclick="return true;" />
						<g:actionSubmit class="delete" action="toggle_academia" params="${flash}" value="Academia" onclick="return true;" />
						<g:actionSubmit class="delete" action="toggle_nationallab" params="${flash}" value="National Lab" onclick="return true;" />
						<g:actionSubmit class="delete" action="toggle_industry" params="${flash}" value="Industry" onclick="return true;" />
						<g:actionSubmit class="delete" action="toggle_foreign" params="${flash}" value="Foreign" onclick="return true;" />
					</fieldset>
				</g:form>
		
				<li class="fieldcontain">
					The journal is considered/the paper contains data collected at Lujan:<br>
					<span id="high_impact-label" class="property-label"><g:message code="bibtab.high_impact.label" default="High impact" /></span>
					<span class="property-value" aria-labelledby="high_impact-label"><g:formatBoolean boolean="${bibtabInstance?.high_impact}" /></span>
					
					<span id="high_profile-label" class="property-label"><g:message code="bibtab.high_profile.label" default="High profile" /></span>
					<span class="property-value" aria-labelledby="high_profile-label"><g:formatBoolean boolean="${bibtabInstance?.high_profile}" /></span>

					<span id="refereed-label" class="property-label"><g:message code="bibtab.refereed.label" default="Refereed" /></span>
					<span class="property-value" aria-labelledby="refereed-label"><g:formatBoolean boolean="${bibtabInstance?.refereed}" /></span>

					<span id="primarydata-label" class="property-label"><g:message code="bibtab.primarydata.label" default="Primary Data" /></span>
					<span class="property-value" aria-labelledby="primarydata-label"><g:formatBoolean boolean="${bibtabInstance?.primarydata}" /></span>
				</li>
				<g:form>
					<fieldset class="buttons"> Toggles: 
						<g:hiddenField name="id" value="${bibtabInstance?.id}" />
						<g:actionSubmit class="delete" action="toggle_high_impact" params="${flash}" value="High Impact" onclick="return true;" />
						<g:actionSubmit class="delete" action="toggle_high_profile" params="${flash}" value="High Profile" onclick="return true;" />
						<g:actionSubmit class="delete" action="toggle_refereed" params="${flash}" value="Refereed" onclick="return true;" />
						<g:actionSubmit class="delete" action="toggle_primarydata" params="${flash}" value="Primary Data" onclick="return true;" />
					</fieldset>
				</g:form>
`			
				<g:if test="${bibtabInstance?.facility}">
				<li class="fieldcontain">
					<span id="facility-label" class="property-label"><g:message code="bibtab.facility.label" default="Facility" /></span>
					
						<span class="property-value" aria-labelledby="facility-label"><g:fieldValue bean="${bibtabInstance}" field="facility"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.citations}">
				<li class="fieldcontain">
					<span id="citations-label" class="property-label"><g:message code="bibtab.citations.label" default="Citations" /></span>
					
						<span class="property-value" aria-labelledby="citations-label"><g:fieldValue bean="${bibtabInstance}" field="citations"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.url}">
				<li class="fieldcontain">
					<span id="url-label" class="property-label"><g:message code="bibtab.url.label" default="Url" /></span>
					
						<span class="property-value" aria-labelledby="url-label"><g:fieldValue bean="${bibtabInstance}" field="url"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.citelinks}">
				<li class="fieldcontain">
					<span id="citelinks-label" class="property-label"><g:message code="bibtab.citelinks.label" default="Citelinks" /></span>
					
						<span class="property-value" aria-labelledby="citelinks-label"><g:fieldValue bean="${bibtabInstance}" field="citelinks"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.authorcount}">
				<li class="fieldcontain">
					<span id="authorcount-label" class="property-label"><g:message code="bibtab.authorcount.label" default="Authorcount" /></span>
					
						<span class="property-value" aria-labelledby="authorcount-label"><g:fieldValue bean="${bibtabInstance}" field="authorcount"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.editorcount}">
				<li class="fieldcontain">
					<span id="editorcount-label" class="property-label"><g:message code="bibtab.editorcount.label" default="Editorcount" /></span>
					
						<span class="property-value" aria-labelledby="editorcount-label"><g:fieldValue bean="${bibtabInstance}" field="editorcount"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.pagecount}">
				<li class="fieldcontain">
					<span id="pagecount-label" class="property-label"><g:message code="bibtab.pagecount.label" default="Pagecount" /></span>
					
						<span class="property-value" aria-labelledby="pagecount-label"><g:fieldValue bean="${bibtabInstance}" field="pagecount"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.filename}">
				<li class="fieldcontain">
					<span id="filename-label" class="property-label"><g:message code="bibtab.filename.label" default="Filename" /></span>
					
						<span class="property-value" aria-labelledby="filename-label"><g:fieldValue bean="${bibtabInstance}" field="filename"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.editor}">
				<li class="fieldcontain">
					<span id="editor-label" class="property-label"><g:message code="bibtab.editor.label" default="Editor" /></span>
					
						<span class="property-value" aria-labelledby="editor-label"><g:fieldValue bean="${bibtabInstance}" field="editor"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.booktitle}">
				<li class="fieldcontain">
					<span id="booktitle-label" class="property-label"><g:message code="bibtab.booktitle.label" default="Booktitle" /></span>
					
						<span class="property-value" aria-labelledby="booktitle-label"><g:fieldValue bean="${bibtabInstance}" field="booktitle"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.crossref}">
				<li class="fieldcontain">
					<span id="crossref-label" class="property-label"><g:message code="bibtab.crossref.label" default="Crossref" /></span>
					
						<span class="property-value" aria-labelledby="crossref-label"><g:fieldValue bean="${bibtabInstance}" field="crossref"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.chapter}">
				<li class="fieldcontain">
					<span id="chapter-label" class="property-label"><g:message code="bibtab.chapter.label" default="Chapter" /></span>
					
						<span class="property-value" aria-labelledby="chapter-label"><g:fieldValue bean="${bibtabInstance}" field="chapter"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.type}">
				<li class="fieldcontain">
					<span id="type-label" class="property-label"><g:message code="bibtab.type.label" default="Type" /></span>
					
						<span class="property-value" aria-labelledby="type-label"><g:fieldValue bean="${bibtabInstance}" field="type"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.coden}">
				<li class="fieldcontain">
					<span id="coden-label" class="property-label"><g:message code="bibtab.coden.label" default="Coden" /></span>
					
						<span class="property-value" aria-labelledby="coden-label"><g:fieldValue bean="${bibtabInstance}" field="coden"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.doi}">
				<li class="fieldcontain">
					<span id="doi-label" class="property-label"><g:message code="bibtab.doi.label" default="Doi" /></span>
					
						<span class="property-value" aria-labelledby="doi-label"><g:fieldValue bean="${bibtabInstance}" field="doi"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.isbn}">
				<li class="fieldcontain">
					<span id="isbn-label" class="property-label"><g:message code="bibtab.isbn.label" default="Isbn" /></span>
					
						<span class="property-value" aria-labelledby="isbn-label"><g:fieldValue bean="${bibtabInstance}" field="isbn"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.isbn13}">
				<li class="fieldcontain">
					<span id="isbn13-label" class="property-label"><g:message code="bibtab.isbn13.label" default="Isbn13" /></span>
					
						<span class="property-value" aria-labelledby="isbn13-label"><g:fieldValue bean="${bibtabInstance}" field="isbn13"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.issn}">
				<li class="fieldcontain">
					<span id="issn-label" class="property-label"><g:message code="bibtab.issn.label" default="Issn" /></span>
					
						<span class="property-value" aria-labelledby="issn-label"><g:fieldValue bean="${bibtabInstance}" field="issn"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.lccn}">
				<li class="fieldcontain">
					<span id="lccn-label" class="property-label"><g:message code="bibtab.lccn.label" default="Lccn" /></span>
					
						<span class="property-value" aria-labelledby="lccn-label"><g:fieldValue bean="${bibtabInstance}" field="lccn"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.mrclass}">
				<li class="fieldcontain">
					<span id="mrclass-label" class="property-label"><g:message code="bibtab.mrclass.label" default="Mrclass" /></span>
					
						<span class="property-value" aria-labelledby="mrclass-label"><g:fieldValue bean="${bibtabInstance}" field="mrclass"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.mrnumber}">
				<li class="fieldcontain">
					<span id="mrnumber-label" class="property-label"><g:message code="bibtab.mrnumber.label" default="Mrnumber" /></span>
					
						<span class="property-value" aria-labelledby="mrnumber-label"><g:fieldValue bean="${bibtabInstance}" field="mrnumber"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.mrreviewer}">
				<li class="fieldcontain">
					<span id="mrreviewer-label" class="property-label"><g:message code="bibtab.mrreviewer.label" default="Mrreviewer" /></span>
					
						<span class="property-value" aria-labelledby="mrreviewer-label"><g:fieldValue bean="${bibtabInstance}" field="mrreviewer"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.bibdate}">
				<li class="fieldcontain">
					<span id="bibdate-label" class="property-label"><g:message code="bibtab.bibdate.label" default="Bibdate" /></span>
					
						<span class="property-value" aria-labelledby="bibdate-label"><g:fieldValue bean="${bibtabInstance}" field="bibdate"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.bibsource}">
				<li class="fieldcontain">
					<span id="bibsource-label" class="property-label"><g:message code="bibtab.bibsource.label" default="Bibsource" /></span>
					
						<span class="property-value" aria-labelledby="bibsource-label"><g:fieldValue bean="${bibtabInstance}" field="bibsource"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.bibtimestamp}">
				<li class="fieldcontain">
					<span id="bibtimestamp-label" class="property-label"><g:message code="bibtab.bibtimestamp.label" default="Bibtimestamp" /></span>
					
						<span class="property-value" aria-labelledby="bibtimestamp-label"><g:fieldValue bean="${bibtabInstance}" field="bibtimestamp"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.note}">
				<li class="fieldcontain">
					<span id="note-label" class="property-label"><g:message code="bibtab.note.label" default="Note" /></span>
					
						<span class="property-value" aria-labelledby="note-label"><g:fieldValue bean="${bibtabInstance}" field="note"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.series}">
				<li class="fieldcontain">
					<span id="series-label" class="property-label"><g:message code="bibtab.series.label" default="Series" /></span>
					
						<span class="property-value" aria-labelledby="series-label"><g:fieldValue bean="${bibtabInstance}" field="series"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.keywords}">
				<li class="fieldcontain">
					<span id="keywords-label" class="property-label"><g:message code="bibtab.keywords.label" default="Keywords" /></span>
					
						<span class="property-value" aria-labelledby="keywords-label"><g:fieldValue bean="${bibtabInstance}" field="keywords"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.remark}">
				<li class="fieldcontain">
					<span id="remark-label" class="property-label"><g:message code="bibtab.remark.label" default="Remark" /></span>
					
						<span class="property-value" aria-labelledby="remark-label"><g:fieldValue bean="${bibtabInstance}" field="remark"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.subject}">
				<li class="fieldcontain">
					<span id="subject-label" class="property-label"><g:message code="bibtab.subject.label" default="Subject" /></span>
					
						<span class="property-value" aria-labelledby="subject-label"><g:fieldValue bean="${bibtabInstance}" field="subject"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.toc}">
				<li class="fieldcontain">
					<span id="toc-label" class="property-label"><g:message code="bibtab.toc.label" default="Toc" /></span>
					
						<span class="property-value" aria-labelledby="toc-label"><g:fieldValue bean="${bibtabInstance}" field="toc"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.zmnumber}">
				<li class="fieldcontain">
					<span id="zmnumber-label" class="property-label"><g:message code="bibtab.zmnumber.label" default="Zmnumber" /></span>
					
						<span class="property-value" aria-labelledby="zmnumber-label"><g:fieldValue bean="${bibtabInstance}" field="zmnumber"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.query}">
				<li class="fieldcontain">
					<span id="query-label" class="property-label"><g:message code="bibtab.query.label" default="Query" /></span>
					
						<span class="property-value" aria-labelledby="query-label"><g:fieldValue bean="${bibtabInstance}" field="query"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.falsehit}">
				<li class="fieldcontain">
					<span id="falsehit-label" class="property-label"><g:message code="bibtab.falsehit.label" default="Falsehit" /></span>
					
						<span class="property-value" aria-labelledby="falsehit-label"><g:formatBoolean boolean="${bibtabInstance?.falsehit}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.dateCreated}">
				<li class="fieldcontain">
					<span id="dateCreated-label" class="property-label"><g:message code="bibtab.dateCreated.label" default="Date Created" /></span>
					
						<span class="property-value" aria-labelledby="dateCreated-label"><g:formatDate date="${bibtabInstance?.dateCreated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.lastUpdated}">
				<li class="fieldcontain">
					<span id="lastUpdated-label" class="property-label"><g:message code="bibtab.lastUpdated.label" default="Last Updated" /></span>
					
						<span class="property-value" aria-labelledby="lastUpdated-label"><g:formatDate date="${bibtabInstance?.lastUpdated}" /></span>
					
				</li>
				</g:if>
			
				<g:if test="${bibtabInstance?.entry}">
				<li class="fieldcontain">
					<span id="entry-label" class="property-label"><g:message code="bibtab.entry.label" default="Entry" /></span>
					
						<span class="property-value" aria-labelledby="entry-label"><g:fieldValue bean="${bibtabInstance}" field="entry"/></span>
					
				</li>
				</g:if>
			
			
			</ol>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${bibtabInstance?.id}" />
					<g:hiddenField name="offset" value="${flash.offset}" />
					<g:link class="edit" action="edit" id="${bibtabInstance?.id}"><g:message code="default.button.edit.label"  params="${flash}" default="Edit" /></g:link>
<!--  SV 120709 We shouldn't delete, but rather mark as falsehit -->
<!-- 					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /> -->


					<g:actionSubmit class="delete" action="set_falsehit"  params="${flash}" value="False Hit" onclick="return confirm('This publication will be marked as a false hit and you will never see it again. Proceed?');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
