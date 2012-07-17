
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
<!-- FIltering list following 
      http://kiwigrails.blogspot.com/2008/07/filtering-list.html
-->
			<div class="body">
			    <g:form action="list" method="post" >
				<div class="dialog">
				    <table>
					<tbody>
					    <tr class='prop'>
						    <td valign='top' class='name'>
							    <label for='FilterName'>Name:</label>
						    </td>
						    <td valign='top' class='value'>
							    <input type="text" id="FilterName" name="FilterName" value="${flash.FilterName}"/>
		    
						    </td>
						    <td valign='top' class='name'>
							    <label for='FilterYear'>Year:</label>
						    </td>
						    <td valign='top' class='value'>
							    <input type="text" id="FilterYear" size="4" name="FilterYear" value="${flash.FilterYear}"/>
						    </td>
						    <td valign='top' class='name'>
							    <label for='FilterInst'>Instrument:</label>
						    </td>
						    <td valign='top' class='value'>
<!--
							    <input type="text" id="FilterInst" name="FilterInst" value="${flash.FilterInst}"/>
-->
<select name="FilterInst" id="FilterInst" name="FilterInst" value="${flash.FilterInst}">
<option value=""        ${flash.FilterInst == '' ? 'selected="selected="' : ''}         >any</option>
<option value="NPDF"    ${flash.FilterInst == 'NPDF' ? 'selected="selected="' : ''}"    >NPDF</option>
<option value="SMARTS"  ${flash.FilterInst == 'SMARTS' ? 'selected="selected="' : ''}"  >SMARTS</option>
<option value="HIPD"    ${flash.FilterInst == 'HIPD' ? 'selected="selected="' : ''}"    >HIPD</option>
<option value="HIPPO"   ${flash.FilterInst == 'HIPPO' ? 'selected="selected="' : ''}"   >HIPPO</option>
<option value="FP5"     ${flash.FilterInst == 'FP5' ? 'selected="selected="' : ''}"     >FP5</option>
<option value="SCD"     ${flash.FilterInst == 'SCD' ? 'selected="selected="' : ''}"     >SCD</option>
<option value="FDS"     ${flash.FilterInst == 'FDS' ? 'selected="selected="' : ''}"     >FDS</option>
<option value="SPEAR"   ${flash.FilterInst == 'SPEAR' ? 'selected="selected="' : ''}"   >SPEAR</option>
<option value="LQD"     ${flash.FilterInst == 'LQD' ? 'selected="selected="' : ''}"     >LQD</option>
<option value="ASTERIX" ${flash.FilterInst == 'ASTERIX' ? 'selected="selected="' : ''}" >ASTERIX</option>
<option value="PCS"     ${flash.FilterInst == 'PCS' ? 'selected="selected="' : ''}"     >PCS</option>
<option value="PHAROS"  ${flash.FilterInst == 'PHAROS' ? 'selected="selected="' : ''}"  >PHAROS</option>
</select>
						    </td>
						    <td valign='top' class='button'>
						      <span class="button"><input class="save" type="submit" value="Filter" /></span>
						    </td>
						    <td>
						      ${bibtabInstanceList.getTotalCount()} items
						    </td>
					    </tr>
					</tbody>
				    </table>
				</div>
			    </g:form>	
			</div>
		
<!-- end -->
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="author" title="${message(code: 'bibtab.author.label', default: 'Author')}"  params="${flash}"/>
					
						<g:sortableColumn property="title" title="${message(code: 'bibtab.title.label', default: 'Title')}"  params="${flash}"/>
					
						<g:sortableColumn property="year" title="${message(code: 'bibtab.year.label', default: 'Year')}"  params="${flash}"/>
					
						<g:sortableColumn property="journal" title="${message(code: 'bibtab.year.label', default: 'Journal')}"  params="${flash}"/>
					
						<g:sortableColumn property="instrument" title="${message(code: 'bibtab.instrument.label', default: 'Instrument')}"  params="${flash}"/>
					
					<!-- SV 120708 Make Citations into "Cited"
						<g:sortableColumn property="citations" title="${message(code: 'bibtab.citations.label', default: 'Citations')}" />
					-->
						<g:sortableColumn property="citations" title="Cited"  defaultOrder="desc" params="${flash}"/>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${bibtabInstanceList}" status="i" var="bibtabInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
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
				<g:paginate total="${bibtabInstanceList.getTotalCount()}" params="${flash}"/>
			</div>
		</div>
<!-- SV120713 Adding export options using jasper
      http://grails.org/plugin/jasper/
      jasper= argument is a report named report_name.jasper" (use IReport) in "bibtex/web-app/reports/".
-->
		<div class="paginateButtons">
		<h1>
		Print reports (Enter instrument in capital letters, year with four digits, click PDF icon):
		</h1>
		<g:jasperReport
		  jasper="PublicationList_Instr"
		  format="PDF"
		  name="By instrument">
		  Instrument: <input type="text" name="Instrument"/>
		</g:jasperReport>
		<g:jasperReport
		  jasper="PublicationList_Year"
		  format="PDF"
		  name="By year">
		  Year: <input type="text" name="Year"/>
		</g:jasperReport>
		<g:jasperReport
		  jasper="PublicationList_InstrAndYear"
		  format="PDF"
		  name="By instrument and year">
		  Instrument: <input type="text" name="Instrument"/>
		  Year: <input type="text" name="Year"/>
		</g:jasperReport>
		</div>
	</body>
</html>
