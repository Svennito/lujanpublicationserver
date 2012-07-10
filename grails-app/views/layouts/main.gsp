<!doctype html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
		<g:layoutHead/>
        <r:layoutResources />
	</head>
	<body>
		<div id="LANL-Links">
		  <a title="Los Alamos National Laboratory world view home" href="https://www.lanl.gov/" accesskey="h">
		    <img alt="Los Alamos National Laboratory" height="66" width="181" src="http://www.lanl.gov/images/4.0/ylanlbanner_www.jpg" border="0" />
		  </a>
		  <a title="Los Alamos Neutron Science Center" href="http://www.lansce.lanl.gov/" accesskey="h">
		    <img src='http://www.lanl.gov/orgs/lansce/images/lanscelogo_smaller.png' height='50' width='158' class='logo' alt='logo' />
		  </a>
		</div>

		<g:layoutBody/>
		<div class="footer" role="contentinfo">&copy; 2012 Sven Vogel, LANSCE-LC, for problems, questions, ideas, etc. please send email to <a href="mailto:sven@lanl.gov?Subject=Publication%20Database">sven@lanl.gov</a></div>
		<div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt" default="Loading&hellip;"/></div>
		<g:javascript library="application"/>
        <r:layoutResources />
	</body>
</html>