<!--  Controls display of the list, also has includes -->
<%@ page import="bibtex.Bibtab" %>
<!doctype html>
<html>
	<head>
		<r:require module="export"/>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'bibtab.label', default: 'Bibtab')}" />
<!--  SV120708 Show nicer title and give some hints on how to use this...
		<title><g:message code="default.list.label" args="[entityName]" /></title>
-->
		<title>Publication List</title>
<!--  SV120722 Define function to set cookie once the filter action is triggered
		use grails tag to read it 
-->
		<script type="text/javascript">
		  function setCookie(c_name,value,exdays) {
		    var exdate=new Date();
		    exdate.setDate(exdate.getDate() + exdays);
		    var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
		    document.cookie=c_name + "=" + c_value;
		  }
		  function saveFilter() {
		    setCookie("LPS_filter_facility",document.filter.FilterFacility.value,365)
		    setCookie("LPS_filter_name",document.filter.FilterName.value,365)
		    setCookie("LPS_filter_year",document.filter.FilterYear.value,365)
		    setCookie("LPS_filter_instr",document.filter.FilterInst.value,365)
		  }
		  // save filter values also to flash memory
// 		  document.flash.FilterFacility 	= document.filter.FilterFacility.value
// 		  document.flash.FilterName	= document.filter.FilterName.value
// 		  document.flash.FilterYear	= document.filter.FilterYear.value
// 		  document.flash.FilterInst	= document.filter.FilterInst.value
		</script>
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
<!--       http://kiwigrails.blogspot.com/2008/07/filtering-list.html -->
			<div class="body">
			    <g:form action="list" method="post" name="filter">
				<div class="dialog">
				    <table>
					<tbody>
					    <tr class='prop'>
						    <td valign='top' class='name'>
							    <label for='FilterFacility'>Facility:</label>
						    </td>
						    <td valign='top' class='value'>
<!--  assign filter values from cookies to flash -->
<!--<select name="FilterFacility" id="FilterFacility" name="FilterFacility" value="${flash.FilterFacility}">
<option value=""        ${flash.FilterFacility== '' ? 'selected="selected="' : ''}      >any</option>
<option value="LUJAN"   ${flash.FilterFacility== 'LUJAN' ? 'selected="selected="' : ''}"    >Lujan</option>
<option value="WNR"     ${flash.FilterFacility== 'WNR' ? 'selected="selected="' : ''}"      >WNR</option>
</select>-->
<select name="FilterFacility" id="FilterFacility" name="FilterFacility" value="${flash.FilterFacility}">
<option value=""        ${g.cookie(name:"LPS_filter_facility") == '' ? 'selected="selected="' : ''}      >any</option>
<option value="LUJAN"   ${g.cookie(name:"LPS_filter_facility") == 'LUJAN' ? 'selected="selected="' : ''}"    >Lujan</option>
<option value="WNR"     ${g.cookie(name:"LPS_filter_facility") == 'WNR' ? 'selected="selected="' : ''}"      >WNR</option>
</select>
						    </td>
						    <td valign='top' class='name'>
							    <label for='FilterName'>Name:</label>
						    </td>
						    <td valign='top' class='value'>
							    <input type="text" id="FilterName" size="8" name="FilterName" value="${flash.FilterName=g.cookie(name:"LPS_filter_name")}"/>
		    
						    </td>
						    <td valign='top' class='name'>
							    <label for='FilterYear'>Year:</label>
						    </td>
						    <td valign='top' class='value'>
							    <input type="text" id="FilterYear" size="4" name="FilterYear" value="${flash.FilterYear=g.cookie(name:"LPS_filter_year")}"/>
						    </td>
						    <td valign='top' class='name'>
							    <label for='FilterInst'>Instrument:</label>
						    </td>
						    <td valign='top' class='value'>
<!--
							    <input type="text" id="FilterInst" name="FilterInst" value="${flash.FilterInst}"/>
-->
<g:if test="${flash.FilterFacility == 'WNR'}">
    <select name="FilterInst" id="FilterInst" name="FilterInst" value="${flash.FilterInst}">
    <option value=""        ${g.cookie(name:"LPS_filter_instr") == '' ? 'selected="selected="' : ''}         >any</option>
    <option value="1FP12"   ${g.cookie(name:"LPS_filter_instr") == '1FP12' ? 'selected="selected="' : ''}"   >1FP12</option>
    <option value="4FP15R"  ${g.cookie(name:"LPS_filter_instr") == '4FP15R' ? 'selected="selected="' : ''}"  >4FP15R</option>
    <option value="DANCE"   ${g.cookie(name:"LPS_filter_instr") == 'DANCE' ? 'selected="selected="' : ''}"   >DANCE</option>
    <option value="FIGARO"  ${g.cookie(name:"LPS_filter_instr") == 'FIGARO' ? 'selected="selected="' : ''}"  >FIGARO</option>
    <option value="GEANIE"  ${g.cookie(name:"LPS_filter_instr") == 'GEANIE' ? 'selected="selected="' : ''}"  >GEANIE</option>
    <option value="WNR"     ${g.cookie(name:"LPS_filter_instr") == 'WNR' ? 'selected="selected="' : ''}"     >WNR</option>
</g:if>
<g:else>
    <g:if test="${flash.FilterFacility == 'LUJAN'}">
	<select name="FilterInst" id="FilterInst" name="FilterInst" value="${flash.FilterInst}">
	<option value=""        ${g.cookie(name:"LPS_filter_instr") == '' ? 'selected="selected="' : ''}         >any</option>
	<option value="NPDF"    ${g.cookie(name:"LPS_filter_instr") == 'NPDF' ? 'selected="selected="' : ''}"    >NPDF</option>
	<option value="SMARTS"  ${g.cookie(name:"LPS_filter_instr") == 'SMARTS' ? 'selected="selected="' : ''}"  >SMARTS</option>
	<option value="HIPD"    ${g.cookie(name:"LPS_filter_instr") == 'HIPD' ? 'selected="selected="' : ''}"    >HIPD</option>
	<option value="HIPPO"   ${g.cookie(name:"LPS_filter_instr") == 'HIPPO' ? 'selected="selected="' : ''}"   >HIPPO</option>
	<option value="FP5"     ${g.cookie(name:"LPS_filter_instr") == 'FP5' ? 'selected="selected="' : ''}"     >FP5</option>
	<option value="SCD"     ${g.cookie(name:"LPS_filter_instr") == 'SCD' ? 'selected="selected="' : ''}"     >SCD</option>
	<option value="FDS"     ${g.cookie(name:"LPS_filter_instr") == 'FDS' ? 'selected="selected="' : ''}"     >FDS</option>
	<option value="SPEAR"   ${g.cookie(name:"LPS_filter_instr") == 'SPEAR' ? 'selected="selected="' : ''}"   >SPEAR</option>
	<option value="LQD"     ${g.cookie(name:"LPS_filter_instr") == 'LQD' ? 'selected="selected="' : ''}"     >LQD</option>
	<option value="ASTERIX" ${g.cookie(name:"LPS_filter_instr") == 'ASTERIX' ? 'selected="selected="' : ''}" >ASTERIX</option>
	<option value="PCS"     ${g.cookie(name:"LPS_filter_instr") == 'PCS' ? 'selected="selected="' : ''}"     >PCS</option>
	<option value="PHAROS"  ${g.cookie(name:"LPS_filter_instr") == 'PHAROS' ? 'selected="selected="' : ''}"  >PHAROS</option>
	<option value="MANAGEMENT"  ${g.cookie(name:"LPS_filter_instr") == 'MANAGEMENT' ? 'selected="selected="' : ''}"  >Management</option>
	<option value="SPALLATION"  ${g.cookie(name:"LPS_filter_instr") == 'SPALLATION' ? 'selected="selected="' : ''}"  >Spallation</option>
	</select>
    </g:if>
    <g:else>
	<select name="FilterInst" id="FilterInst" name="FilterInst" value="${flash.FilterInst}">
	<option value=""        ${g.cookie(name:"LPS_filter_instr") == '' ? 'selected="selected="' : ''}         >any</option>
	<option value="NPDF"    ${g.cookie(name:"LPS_filter_instr") == 'NPDF' ? 'selected="selected="' : ''}"    >NPDF</option>
	<option value="SMARTS"  ${g.cookie(name:"LPS_filter_instr") == 'SMARTS' ? 'selected="selected="' : ''}"  >SMARTS</option>
	<option value="HIPD"    ${g.cookie(name:"LPS_filter_instr") == 'HIPD' ? 'selected="selected="' : ''}"    >HIPD</option>
	<option value="HIPPO"   ${g.cookie(name:"LPS_filter_instr") == 'HIPPO' ? 'selected="selected="' : ''}"   >HIPPO</option>
	<option value="FP5"     ${g.cookie(name:"LPS_filter_instr") == 'FP5' ? 'selected="selected="' : ''}"     >FP5</option>
	<option value="SCD"     ${g.cookie(name:"LPS_filter_instr") == 'SCD' ? 'selected="selected="' : ''}"     >SCD</option>
	<option value="FDS"     ${g.cookie(name:"LPS_filter_instr") == 'FDS' ? 'selected="selected="' : ''}"     >FDS</option>
	<option value="SPEAR"   ${g.cookie(name:"LPS_filter_instr") == 'SPEAR' ? 'selected="selected="' : ''}"   >SPEAR</option>
	<option value="LQD"     ${g.cookie(name:"LPS_filter_instr") == 'LQD' ? 'selected="selected="' : ''}"     >LQD</option>
	<option value="ASTERIX" ${g.cookie(name:"LPS_filter_instr") == 'ASTERIX' ? 'selected="selected="' : ''}" >ASTERIX</option>
	<option value="PCS"     ${g.cookie(name:"LPS_filter_instr") == 'PCS' ? 'selected="selected="' : ''}"     >PCS</option>
	<option value="PHAROS"  ${g.cookie(name:"LPS_filter_instr") == 'PHAROS' ? 'selected="selected="' : ''}"  >PHAROS</option>
	<option value="MANAGEMENT"  ${g.cookie(name:"LPS_filter_instr") == 'MANAGEMENT' ? 'selected="selected="' : ''}"  >Management</option>
	<option value="SPALLATION"  ${g.cookie(name:"LPS_filter_instr") == 'SPALLATION' ? 'selected="selected="' : ''}"  >Spallation</option>
	<option value="1FP12"   ${g.cookie(name:"LPS_filter_instr") == '1FP12' ? 'selected="selected="' : ''}"   >1FP12</option>
	<option value="4FP15R"  ${g.cookie(name:"LPS_filter_instr") == '4FP15R' ? 'selected="selected="' : ''}"  >4FP15R</option>
	<option value="DANCE"   ${g.cookie(name:"LPS_filter_instr") == 'DANCE' ? 'selected="selected="' : ''}"   >DANCE</option>
	<option value="FIGARO"  ${g.cookie(name:"LPS_filter_instr") == 'FIGARO' ? 'selected="selected="' : ''}"  >FIGARO</option>
	<option value="GEANIE"  ${g.cookie(name:"LPS_filter_instr") == 'GEANIE' ? 'selected="selected="' : ''}"  >GEANIE</option>
	<option value="WNR"     ${g.cookie(name:"LPS_filter_instr") == 'WNR' ? 'selected="selected="' : ''}"     >WNR</option>
	</select>
    </g:else>
</g:else>
						    </td>
						    <td valign='top' class='button'>
<!-- 						      <span class="button"><input class="save" type="submit" value="Filter" onClick="SaveFilter("${flash.FilterFacility}","${flash.FilterInst}","${flash.FilterName}","${flash.FilterYear}")"/></span> -->
						      <span class="button"><input class="save" type="submit" value="Filter" onClick="saveFilter();${flash.offset=0}"/></span> 
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
			<div class="pagination">
<!--				<g:paginate total="${bibtabInstanceList.getTotalCount()}" params="${flash}"/> -->
				<g:paginate total="${bibtabInstanceList.getTotalCount()}"/>
			</div>
			<br>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="author" action="sort_clicked" title="${message(code: 'bibtab.author.label', default: 'Author')}" />
					
						<g:sortableColumn property="title" action="sort_clicked" title="${message(code: 'bibtab.title.label', default: 'Title')}" />
					
						<g:sortableColumn property="year" action="sort_clicked" title="${message(code: 'bibtab.year.label', default: 'Year')}" />
					
						<g:sortableColumn property="journal" action="sort_clicked" title="${message(code: 'bibtab.year.label', default: 'Journal')}" />


						<g:sortableColumn property="bibtype" action="sort_clicked" title="${message(code: 'bibtab.year.label', default: 'Type')}" />
					
						<g:sortableColumn property="instrument" action="sort_clicked" title="${message(code: 'bibtab.instrument.label', default: 'Instrument')}" />
					
					<!-- SV 120708 Make Citations into "Cited"
						<g:sortableColumn property="citations" title="${message(code: 'bibtab.citations.label', default: 'Citations')}" />
					-->
						<g:sortableColumn property="citations" action="sort_clicked" title="Cited"  defaultOrder="desc"/>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${bibtabInstanceList}" status="i" var="bibtabInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show"  params="${flash}" id="${bibtabInstance.id}">${fieldValue(bean: bibtabInstance, field: "author")}</g:link></td>
					<!-- make title the link to the paper
						<td>${fieldValue(bean: bibtabInstance, field: "title")}</td>
					-->
						<td><a href="${fieldValue(bean: bibtabInstance, field: "url")}" target="_blank" >${fieldValue(bean: bibtabInstance, field: "title")}</a></td>
					
						<td>${fieldValue(bean: bibtabInstance, field: "year")}</td>
					
						<td>${fieldValue(bean: bibtabInstance, field: "journal")}</td>
					
						<td>${fieldValue(bean: bibtabInstance, field: "bibtype")}</td>
					
						<td>${fieldValue(bean: bibtabInstance, field: "instrument")}</td>
					
						<td><a href="${fieldValue(bean: bibtabInstance, field: "citelinks")}" target="_blank" >${fieldValue(bean: bibtabInstance, field: "citations")}</a></td>


					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
<!--				<g:paginate total="${bibtabInstanceList.getTotalCount()}" params="${flash}"/> -->
				<g:paginate total="${bibtabInstanceList.getTotalCount()}"/>
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
		<h1>
		Export current selection:
		</h1>
		    <export:formats formats="['csv', 'excel', 'ods', 'pdf', 'rtf', 'xml']" params="${flash}"/>
		</div>
	</body>
</html>

