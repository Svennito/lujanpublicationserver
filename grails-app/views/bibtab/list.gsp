
<%@ page import="bibtex.Bibtab" %>
<!doctype html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'bibtab.label', default: 'Bibtab')}" />
<!--  SV120708 Show nicer title and give some hints on how to use this...
		<title><g:message code="default.list.label" args="[entityName]" /></title>
-->
		<title>Publication List</title>
	</head>
	<body>
		<a href="#list-bibtab" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
<!--	SV120708 Make nicer Create Item link
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
-->
				<li><g:link class="create" action="create">New Publication</g:link></li>
			</ul>
		</div>
		<div id="list-bibtab" class="content scaffold-list" role="main">
<!-- SV120708 Make nicer header...
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
-->
			<h1>Publication List - Click author to edit, click title to see paper, click headers to sort</h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="falsehit" title="${message(code: 'bibtab.author.label', default: 'FH')}" />
					
						<g:sortableColumn property="author" title="${message(code: 'bibtab.author.label', default: 'Author')}" />
					
						<g:sortableColumn property="title" title="${message(code: 'bibtab.title.label', default: 'Title')}" />
					
						<g:sortableColumn property="year" title="${message(code: 'bibtab.year.label', default: 'Year')}" />
					
						<g:sortableColumn property="journal" title="${message(code: 'bibtab.year.label', default: 'Journal')}" />
					
						<g:sortableColumn property="instrument" title="${message(code: 'bibtab.instrument.label', default: 'Instrument')}" />
					
					<!-- SV 120708 Make Citations into "Cited"
						<g:sortableColumn property="citations" title="${message(code: 'bibtab.citations.label', default: 'Citations')}" />
					-->
						<g:sortableColumn property="citations" title="Cited" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${bibtabInstanceList}" status="i" var="bibtabInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td>${fieldValue(bean: bibtabInstance, field: "falsehit")}</td>
					
						<td><g:link action="show" id="${bibtabInstance.id}">${fieldValue(bean: bibtabInstance, field: "author")}</g:link></td>
					<!-- make title the link to the paper
						<td>${fieldValue(bean: bibtabInstance, field: "title")}</td>
					-->
						<td><a href="${fieldValue(bean: bibtabInstance, field: "url")}" target="_blank" >${fieldValue(bean: bibtabInstance, field: "title")}</a></td>
					
						<td>${fieldValue(bean: bibtabInstance, field: "year")}</td>
					
						<td>${fieldValue(bean: bibtabInstance, field: "journal")}</td>
					
						<td>${fieldValue(bean: bibtabInstance, field: "instrument")}</td>
					
						<td>${fieldValue(bean: bibtabInstance, field: "citations")}</td>

					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${bibtabInstanceTotal}" />
			</div>
		</div>
	</body>
</html>
