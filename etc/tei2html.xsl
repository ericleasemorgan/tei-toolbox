<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

<!--

    tei2htm.xsl - transform TEI file to simple HTML file
	
    Eric Lease Morgan (eric_morgan@infomotions.com)
    August 18, 2005

-->

	<xsl:output 
	  method='xml'
	  omit-xml-declaration='no'
	  indent='yes'
	  doctype-public='-//W3C//DTD XHTML 1.0 Transitional//EN' 
	  doctype-system='http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd' />
  	
	<xsl:template match='TEI'>
		<html>
		
			<head>
	
				<!-- title tag -->
				<title> 
					<xsl:for-each select="teiHeader/fileDesc/titleStmt/title">
						<xsl:if test='./@type = "main"'>
							<xsl:value-of select='.' />
						</xsl:if>
					</xsl:for-each>
					<xsl:text> / </xsl:text>
					<xsl:for-each select="teiHeader/fileDesc/titleStmt/author/name">
						<xsl:if test='./@type = "main"'>
							<xsl:value-of select='.' />
						</xsl:if>
					</xsl:for-each>
					<xsl:text> </xsl:text>
					<xsl:value-of select="teiHeader/fileDesc/titleStmt/author/dateRange"/>
				</title> 
	
				<xsl:comment>Dublin Core elements</xsl:comment>

				<!-- title -->
				<xsl:for-each select="teiHeader/fileDesc/titleStmt/title">
					<xsl:if test='./@type = "main"'>
						<meta>
							<xsl:attribute name='name'>title</xsl:attribute>
							<xsl:attribute name='content'><xsl:value-of select='.' /></xsl:attribute>
						</meta>
					</xsl:if>
				</xsl:for-each>
	
				<!-- creator -->
				<meta>
					<xsl:attribute name='name'>creator</xsl:attribute>
					<xsl:for-each select="teiHeader/fileDesc/titleStmt/author/name">
						<xsl:if test='./@type = "main"'>
							<xsl:attribute name='content'><xsl:value-of select='.' /></xsl:attribute>
						</xsl:if>
					</xsl:for-each>
				</meta>
	
				<!-- subjects -->
				<xsl:for-each select='teiHeader/profileDesc/textClass/keywords/list/item'>
					<meta>
						<xsl:attribute name='name'>subject</xsl:attribute>
						<xsl:attribute name='content'><xsl:value-of select='normalize-space(.)' /></xsl:attribute>
					</meta>
				 </xsl:for-each>
        
				<!-- description -->
				<xsl:for-each select="/TEI/teiHeader/fileDesc/notesStmt/note">
					<xsl:if test='./@type = "description"'>
						<meta>
							<xsl:attribute name='name'>description</xsl:attribute>
							<xsl:attribute name='content'><xsl:value-of select='.' /></xsl:attribute>
						</meta>
					</xsl:if>
				</xsl:for-each>					
	
				<!-- publisher -->
				<meta>
					<xsl:attribute name='name'>publisher</xsl:attribute>
					<xsl:attribute name='content'><xsl:value-of select='normalize-space(teiHeader/fileDesc/publicationStmt/publisher)' /></xsl:attribute>
				</meta>
	
				<!-- contributor -->
				<xsl:for-each select="teiHeader/fileDesc/titleStmt/respStmt/name">
					<xsl:if test='./@type = "contributor"'>
						<meta>
							<xsl:attribute name='name'>contributor</xsl:attribute>
							<xsl:attribute name='content'><xsl:value-of select='.' /></xsl:attribute>
						</meta>
					</xsl:if>
				</xsl:for-each>					

				<!-- date -->
				<meta>
					<xsl:attribute name='name'>date</xsl:attribute>
					<xsl:attribute name='content'><xsl:value-of select='normalize-space(teiHeader/profileDesc/creation/date)' /></xsl:attribute>
				</meta>
	
				<!-- type -->
				<meta>
					<xsl:attribute name='name'>type</xsl:attribute>
					<xsl:attribute name='content'>Text</xsl:attribute>
				</meta>
	
				<!-- format -->
				<meta>
					<xsl:attribute name='name'>format</xsl:attribute>
					<xsl:attribute name='content'>text/html</xsl:attribute>
				</meta>
	
				<!-- identifier -->
				<meta>
					<xsl:attribute name='name'>identifier</xsl:attribute>
					<xsl:attribute name='content'><xsl:value-of select='normalize-space(teiHeader/fileDesc/publicationStmt/idno)' /></xsl:attribute>
				</meta>
	
				<!-- source -->
				<meta>
					<xsl:attribute name='name'>source</xsl:attribute>
					<xsl:attribute name='content'>
						<xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/xptr/@url"><xsl:value-of select='normalize-space(.)'/></xsl:for-each>
					</xsl:attribute>
				</meta>
	
				<!-- language -->
				<meta>
					<xsl:attribute name='name'>language</xsl:attribute>
					<xsl:attribute name='content'><xsl:value-of select='normalize-space(teiHeader/profileDesc/langUsage/language)' /></xsl:attribute>
				</meta>
	
				<!-- relation -->
				<meta>
					<xsl:attribute name='name'>relation</xsl:attribute>
					<xsl:attribute name='content'>http://infomotions.com/alex/</xsl:attribute>
				</meta>
	
				<!-- coverage -->
				
				<!-- rights -->
				<meta>
					<xsl:attribute name='name'>rights</xsl:attribute>
					<xsl:attribute name='content'><xsl:value-of select='normalize-space(teiHeader/fileDesc/publicationStmt/availability/p)' /></xsl:attribute>
				</meta>
				
				<xsl:comment>Alex Catalogue metadata elements</xsl:comment>

				<!-- sort author -->
				<meta>
					<xsl:attribute name='name'>sort_creator</xsl:attribute>
					<xsl:for-each select="teiHeader/fileDesc/titleStmt/author/name">
						<xsl:if test='./@type = "sort"'>
							<xsl:attribute name='content'><xsl:value-of select='.' /></xsl:attribute>
						</xsl:if>
					</xsl:for-each>
				</meta>
	
	
				<!-- sort title -->
				<meta>
					<xsl:attribute name='name'>sort_title</xsl:attribute>
					<xsl:for-each select="teiHeader/fileDesc/titleStmt/title">
						<xsl:if test='./@type = "sort"'>
							<xsl:attribute name='content'><xsl:value-of select='.' /></xsl:attribute>
						</xsl:if>
					</xsl:for-each>
				</meta>
	
				<!-- title tag, again -->
				<meta>
					<xsl:attribute name='name'>brief</xsl:attribute>
					<xsl:attribute name='content'>
										<xsl:for-each select="teiHeader/fileDesc/titleStmt/title">
						<xsl:if test='./@type = "main"'>
							<xsl:value-of select='.' />
						</xsl:if>
					</xsl:for-each>
					<xsl:text> / </xsl:text>
					<xsl:for-each select="teiHeader/fileDesc/titleStmt/author/name">
						<xsl:if test='./@type = "main"'>
							<xsl:value-of select='.' />
						</xsl:if>
					</xsl:for-each>
					<xsl:text> </xsl:text>
					<xsl:value-of select="teiHeader/fileDesc/titleStmt/author/dateRange"/>

					</xsl:attribute>
				</meta>
	
				<!-- date -->
				<meta>
					<xsl:attribute name='name'>sort_date</xsl:attribute>
					<xsl:attribute name='content'><xsl:value-of select='normalize-space(teiHeader/profileDesc/creation/date/@value)' /></xsl:attribute>
				</meta>
	
				<style type='text/css'>h1, h2, h3, h4, h5, h6 { font-family : sans-serif; }
				p.fiction { margin-top: 0em; margin-bottom: 0em;}</style>
				
			</head>
			
			<body style='margin:5%;'>
				
				<!-- "title" page -->
				<h1 style='text-align:center'><xsl:value-of select='teiHeader/fileDesc/titleStmt/title' /></h1>
				<p style='text-align:center'><xsl:value-of select='/TEI/text/front/titlePage/byline' /></p>
				<p style='text-align:center'><xsl:value-of select='/TEI/text/front/titlePage/docImprint' /><xsl:value-of select='/TEI/text/front/titlePage/imprimatur' /></p>
				<hr />

				<!-- cool table of contents -->
				<xsl:if test='/TEI/text/body/div'>
					<h2>Table of contents</h2>
					<p>
					<xsl:for-each select="/TEI/text/*/div">
						<xsl:if test='./@type != "colophon"'>
						<a><xsl:attribute name="href">#<xsl:value-of select='./@id' /></xsl:attribute><xsl:value-of select='./head' /></a><br />
						</xsl:if>
					</xsl:for-each>
					</p>
				</xsl:if>
				
				<!-- do the heavy lifting -->
				<xsl:apply-templates/>
						
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

	<!-- division #2 (div2) -->
	<xsl:template match="div2">
		<h3><xsl:value-of select='./@type' /><xsl:text> </xsl:text><xsl:value-of select='./@n' /><xsl:text>. </xsl:text><xsl:value-of select='./head' /></h3>
		<xsl:apply-templates />
	</xsl:template>

	<!-- division #3 (div3) -->
	<xsl:template match="div3">
		<h4><xsl:value-of select='./@type' /><xsl:text> </xsl:text><xsl:value-of select='./@n' /><xsl:text>. </xsl:text><xsl:value-of select='./head' /></h4>
		<xsl:apply-templates />
	</xsl:template>

	<!-- division #4 (div4) -->
	<xsl:template match="div4">
		<h5><xsl:value-of select='./@type' /><xsl:text> </xsl:text><xsl:value-of select='./@n' /><xsl:text>. </xsl:text><xsl:value-of select='./head' /></h5>
		<xsl:apply-templates />
	</xsl:template>

	<!-- division #5 (div5) -->
	<xsl:template match="div5">
		<h6><xsl:value-of select='./@type' /><xsl:text> </xsl:text><xsl:value-of select='./@n' /><xsl:text>. </xsl:text><xsl:value-of select='./head' /></h6>
		<xsl:apply-templates />
	</xsl:template>

	<!-- images (figure) -->
	<xsl:template match="figure">
	<img>
	<xsl:attribute name='src'><xsl:value-of select='./@url' /></xsl:attribute>
	<xsl:choose>
	<xsl:when test='./figDesc'>
		<xsl:attribute name='alt'><xsl:value-of select='normalize-space(./figDesc)' /></xsl:attribute>
	</xsl:when>
	<xsl:otherwise>
			<xsl:attribute name='alt'><xsl:value-of select='./@url' /></xsl:attribute>
	</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test='./@rend = "top"'>
		<xsl:attribute name='align'><xsl:value-of select='./@rend' /></xsl:attribute>
		</xsl:when>
		<xsl:when test='./@rend = "middle"'>
		<xsl:attribute name='align'><xsl:value-of select='./@rend' /></xsl:attribute>
		</xsl:when>
		<xsl:when test='./@rend = "bottom"'>
		<xsl:attribute name='align'><xsl:value-of select='./@rend' /></xsl:attribute>
		</xsl:when>
		<xsl:when test='./@rend = "left"'>
		<xsl:attribute name='align'><xsl:value-of select='./@rend' /></xsl:attribute>
		</xsl:when>
		<xsl:when test='./@rend = "right"'>
		<xsl:attribute name='align'><xsl:value-of select='./@rend' /></xsl:attribute>
		</xsl:when>
		<xsl:otherwise />
	</xsl:choose>
	</img>
	<xsl:apply-templates/>
	</xsl:template>

	<!-- figure description (figDesc) -->
	<xsl:template match='figDesc'>
	<span class='caption'><xsl:apply-templates/></span>
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
		<p><xsl:apply-templates /></p>
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
