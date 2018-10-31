<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

	<xsl:output 
	  method='xml'
	  omit-xml-declaration='no'
	  indent='yes'
	  doctype-public='-//W3C//DTD XHTML 1.0 Transitional//EN' 
	  doctype-system='http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd' />
  	
	<xsl:template match='TEI.2'>
		<html>
		
			<head>
	
				<!-- title tag -->
				<title> 
					<xsl:for-each select="teiHeader/fileDesc/titleStmt/title">
							<xsl:value-of select='.' />
					</xsl:for-each>
					<xsl:text> / </xsl:text>
					<xsl:for-each select="teiHeader/fileDesc/titleStmt/author/name">
							<xsl:value-of select='.' />
					</xsl:for-each>
					<xsl:text> </xsl:text>
					<xsl:value-of select="teiHeader/fileDesc/titleStmt/author/dateRange"/>
				</title> 
	
				
			</head>
			
			<body>
				
    <!-- content -->
    <div>

				<!-- "title" page -->
				<h1><xsl:value-of select='teiHeader/fileDesc/titleStmt/title' /></h1>
				<p><xsl:value-of select='/TEI.2/text/front/titlePage/byline' /></p>
				<p><xsl:value-of select='/TEI.2/text/front/titlePage/docImprint' /><xsl:value-of select='/TEI.2/text/front/titlePage/imprimatur' /></p>
				<hr />

				<!-- cool table of contents -->
				<xsl:if test='/TEI.2/text/body/div'>
					<h2>Table of contents</h2>
					<p>
					<xsl:for-each select="/TEI.2/text/*/div">
						<xsl:if test='./@type != "colophon"'>
						<a><xsl:attribute name="href">#<xsl:value-of select='./@id' /></xsl:attribute><xsl:value-of select='./head' /></a><br />
						</xsl:if>
					</xsl:for-each>
					</p>
				</xsl:if>
				
				<!-- do the heavy lifting -->
				<xsl:apply-templates/>
						
    </div>

			</body>
			
		</html>
		
	</xsl:template>
	
	<!-- division #0 (div) -->
	<xsl:template match="div">
		<xsl:choose>
			<xsl:when test='./@type = "colophon"'>
				<hr />
				<h2><xsl:value-of select='./head' /></h2> 
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="div">
		<xsl:choose>
			<xsl:when test='./@type = "colophon"'>
				<hr />
			</xsl:when>
		</xsl:choose>
		<h2><a><xsl:attribute name="name"><xsl:value-of select='./@id' /></xsl:attribute><xsl:value-of select='./head' /></a></h2>
		<xsl:apply-templates />
	</xsl:template>

	
	<!-- line break (lb) -->
	<xsl:template match='lb'>
	<br /><xsl:apply-templates />
	</xsl:template>

	<!-- paragraph (p) -->
	<xsl:template match="p">
		<xsl:choose>
			<xsl:when test='./@rend = "right"'>
				<p style='text-align:right'><xsl:apply-templates /></p>
			</xsl:when>
			<xsl:when test='./@rend = "center"'>
				<p style='text-align:center'><xsl:apply-templates /></p>
			</xsl:when>
			<xsl:when test='./@rend = "fiction"'>
				<p class='fiction'><xsl:text>&#160;&#160;&#160;&#160;</xsl:text><xsl:apply-templates /></p>
			</xsl:when>
			<xsl:when test='./@rend = "pre"'>
				<pre><xsl:apply-templates /></pre>
			</xsl:when>
			<xsl:otherwise>
				<p><xsl:apply-templates /></p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- quote (quote) -->
	<xsl:template match="quote">
		<blockquote><xsl:apply-templates /></blockquote>
	</xsl:template>

	<!-- line group (lg) -->
	<xsl:template match="lg">
		<p style='margin-left: 2em'><xsl:apply-templates /></p>
	</xsl:template>

	<!-- line (l) -->
	<xsl:template match="l">
		<xsl:if test='@rend = "indent"'>
			<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
		</xsl:if>
		<xsl:apply-templates /><br />
	</xsl:template>

	<!-- hypertext reference (xref) -->
	<xsl:template match="xref">
	<a><xsl:attribute name='href'><xsl:value-of select='./@url' /></xsl:attribute><xsl:apply-templates /></a>
	</xsl:template>

 	<!-- table (table) -->
	<xsl:template match="table">
		<xsl:choose>
			<xsl:when test='./@rend = "left"'>
				<table border='0' align='left'><xsl:apply-templates /></table>
			</xsl:when>
			<xsl:when test='./@rend = "right"'>
				<table border='0' align='right'><xsl:apply-templates /></table>
			</xsl:when>
			<xsl:when test='./@rend = "center"'>
				<table border='0' align='center'><xsl:apply-templates /></table>
			</xsl:when>
			<xsl:otherwise>
				<table border='0'><xsl:apply-templates /></table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- table row (row) -->
	<xsl:template match="row">
		<xsl:choose>
			<xsl:when test='./@rend = "left"'>
				<tr align='left' valign='top'><xsl:apply-templates /></tr>
			</xsl:when>
			<xsl:when test='./@rend = "right"'>
				<tr align='right' valign='top'><xsl:apply-templates /></tr>
			</xsl:when>
			<xsl:when test='./@rend = "center"'>
				<tr align='center' valign='top'><xsl:apply-templates /></tr>
			</xsl:when>
			<xsl:when test='./@rend = "justify"'>
				<tr align='justify' valign='top'><xsl:apply-templates /></tr>
			</xsl:when>
			<xsl:otherwise>
				<tr valign='top'><xsl:apply-templates /></tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- table row (cell) -->
	<xsl:template match="cell">
		<xsl:choose>
			<xsl:when test='./@rend = "left"'>
				<td align='left'><xsl:attribute name='colspan'><xsl:value-of select='@cols' /></xsl:attribute><xsl:apply-templates /></td>
			</xsl:when>
			<xsl:when test='./@rend = "right"'>
				<td align='right'><xsl:attribute name='colspan'><xsl:value-of select='@cols' /></xsl:attribute><xsl:apply-templates /></td>
			</xsl:when>
			<xsl:when test='./@rend = "center"'>
				<td align='center'><xsl:attribute name='colspan'><xsl:value-of select='@cols' /></xsl:attribute><xsl:apply-templates /></td>
			</xsl:when>
			<xsl:when test='./@rend = "justify"'>
				<td align='justify'><xsl:attribute name='colspan'><xsl:value-of select='@cols' /></xsl:attribute><xsl:apply-templates /></td>
			</xsl:when>
			<xsl:otherwise>
				<td><xsl:attribute name='colspan'><xsl:value-of select='@cols' /></xsl:attribute><xsl:apply-templates /></td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- lists -->
	<!-- cool XPath expressions and logic by bodard gabriel <gabriel.bodard@kcl.ac.uk> -->
	<xsl:template match="list[@type='gloss']">
	  <dl><xsl:apply-templates/></dl>
	</xsl:template>
	
	<xsl:template match="list[@type='ordered']">
	  <ol><xsl:apply-templates/></ol>
	</xsl:template>
	
	<xsl:template match="list[@type='bulleted']">
	  <ul><xsl:apply-templates/></ul>
	</xsl:template>
	
	<xsl:template match="list[@type='simple']">
	  <ul style='list-style-type: none'><xsl:apply-templates/></ul>
	</xsl:template>
	
	<xsl:template match="label[parent::list[@type='gloss']]">
	  <dt><xsl:apply-templates/></dt>
	</xsl:template>
	
	<xsl:template match="item[parent::list[@type='gloss']]">
	  <dd><xsl:apply-templates/></dd>
	</xsl:template>
	
	<xsl:template match="item[parent::list[@type='bulleted']]">
	  <li><xsl:apply-templates/></li>
	</xsl:template>
	
	<xsl:template match="item[parent::list[@type='simple']]">
	  <li><xsl:apply-templates/></li>
	</xsl:template>
	
	<xsl:template match="item[parent::list[@type='ordered']]">
	  <li><xsl:apply-templates/></li>
	</xsl:template>


	<!-- do nothing templates -->

	<!-- teiheader (do nothing) -->
	<xsl:template match="teiHeader" />
	
	<!-- teiheader (do nothing) -->
	<xsl:template match="front/titlePage" />
		
	<!-- head (head) -->
	<xsl:template match="head" />

</xsl:stylesheet>
