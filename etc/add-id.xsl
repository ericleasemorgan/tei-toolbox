<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Copy anything as it is -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text">
        <text>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="id" select="count(preceding::text) + 1"/>
            <xsl:apply-templates select="node()"/>
        </text>
    </xsl:template>
</xsl:stylesheet>