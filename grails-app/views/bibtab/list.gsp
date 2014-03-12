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
		    setCookie("LPS_filter_year_to",document.filter.FilterYearTo.value,365)
		    setCookie("LPS_filter_instr",document.filter.FilterInst.value,365)
		    setCookie("LPS_filter_type",document.filter.FilterType.value,365)
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
			<h1>Publication List (${bibtabInstanceList.getTotalCount()} items with current filter) <br> Click author to edit, click title to see paper, click column headers to sort</h1>
<!--       http://kiwigrails.blogspot.com/2008/07/filtering-list.html -->
			<div class="body">
			    <g:form action="list" method="post" name="filter">
				<div class="dialog">
				    <table>
					<tbody>
					    <tr class='prop'>
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
							    <input type="text" id="FilterYear" size="3" name="FilterYear" value="${flash.FilterYear=g.cookie(name:"LPS_filter_year")}"/>
						    </td>
						    <td valign='top' class='name'>
							    <label for='FilterYearTo'>To:</label>
						    </td>
						    <td valign='top' class='value'>
							    <input type="text" id="FilterYearTo" size="3" name="FilterYearTo" value="${flash.FilterYearTo=g.cookie(name:"LPS_filter_year_to")}"/>
						    </td>
					    </tr>
					    <tr>
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
							    <label for='Type'>Type:</label>
						    </td>
						    <td valign='top' class='value'>
							  <select name="FilterType" id="FilterType" name="FilterType" value="${flash.FilterType}">
							  <option value=""                  ${g.cookie(name:"LPS_filter_type") == '' ? 'selected="selected="' : ''}      		>any</option>
							  <option value="article"     	    ${g.cookie(name:"LPS_filter_type") == 'article' ? 'selected="selected="' : ''}"    		>article</option>
							  <option value="inproceedings"     ${g.cookie(name:"LPS_filter_type") == 'inproceedings' ? 'selected="selected="' : ''}"      	>inproceedings</option>
							  <option value="phdthesis"	    ${g.cookie(name:"LPS_filter_type") == 'phdthesis' ? 'selected="selected="' : ''}"      	>phdthesis</option>
							  <option value="book"     	    ${g.cookie(name:"LPS_filter_type") == 'book' ? 'selected="selected="' : ''}"      		>book</option>
							  <option value="techreport"	    ${g.cookie(name:"LPS_filter_type") == 'techreport' ? 'selected="selected="' : ''}"      	>techreport</option>
							  <option value="misc"     	    ${g.cookie(name:"LPS_filter_type") == 'misc' ? 'selected="selected="' : ''}"      		>misc</option>
							  <option value="incollection"      ${g.cookie(name:"LPS_filter_type") == 'incollection' ? 'selected="selected="' : ''}"      	>incollection</option>
							  </select>
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
					
						<g:sortableColumn property="lc_staff" action="sort_clicked" title="LC"  defaultOrder="desc"/>
					
						<g:sortableColumn property="primarydata" action="sort_clicked" title="PD"  defaultOrder="desc"/>
					
						<g:sortableColumn property="refereed" action="sort_clicked" title="R"  defaultOrder="desc"/>
					
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

						<td>${fieldValue(bean: bibtabInstance, field: "lc_staff")}</td>
					
						<td>${fieldValue(bean: bibtabInstance, field: "primarydata")}</td>

						<td>${fieldValue(bean: bibtabInstance, field: "refereed")}</td>

					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
<!--				<g:paginate total="${bibtabInstanceList.getTotalCount()}" params="${flash}"/> -->
				<g:paginate total="${bibtabInstanceList.getTotalCount()}"/>
			</div>
		</div>
		<div class="paginateButtons">
		<h1>
		Export current selection: <export:formats formats="['csv', 'excel', 'ods', 'pdf', 'rtf', 'xml']" params="${flash}"/>
		</h1>
		</div>
	</body>
</html>

