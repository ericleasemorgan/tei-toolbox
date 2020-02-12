<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>

<!--

    tei2txt.xsl - transform TEI file to a plain text file
	
    Eric Lease Morgan (eric_morgan@infomotions.com)
    November 20, 2018

-->
  
	<xsl:output method="text" />

	<xsl:template match='TEI'>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="teiHeader" />
	<xsl:template match="text/front" />

	<xsl:template match='body'>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match='p | head | lg | quote' >
		<xsl:value-of select='.' /><xsl:text>&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="text/back" />

</xsl:stylesheet>
