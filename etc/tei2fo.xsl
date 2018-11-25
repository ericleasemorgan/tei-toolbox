<?xml version='1.0'?>
<xsl:stylesheet version='1.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:fo='http://www.w3.org/1999/XSL/Format'>

  <xsl:output indent='yes'/>

  <xsl:template match='TEI'>
  
    <fo:root xmlns:fo='http://www.w3.org/1999/XSL/Format'>

      <fo:layout-master-set>
      
         <fo:simple-page-master master-name='odd-layout'>
    		<fo:region-body   margin-top='1.5in' margin-bottom='1.5in' margin-left='2in' margin-right='1.5in' />
    		<fo:region-before extent='1.5in' />
    		<fo:region-after  extent='1.5in'/> 
 			<fo:region-start  extent='1.5in' />
    		<fo:region-end    extent='1.5in' />
        </fo:simple-page-master>
         
         <fo:simple-page-master master-name='even-layout'>
    		<fo:region-body   margin-top='1.5in' margin-bottom='1.5in' margin-left='1.5in' margin-right='2in' />
    		<fo:region-before extent='1.5in' />
    		<fo:region-after  extent='1.5in'/> 
			<fo:region-start  extent='1.5in' />
     		<fo:region-end    extent='1.5in' />
        </fo:simple-page-master>
         
         <fo:page-sequence-master master-name='odd-even'>
         	<fo:repeatable-page-master-alternatives>
         		<fo:conditional-page-master-reference odd-or-even='odd' master-reference='odd-layout'/>
         		<fo:conditional-page-master-reference odd-or-even='even' master-reference='even-layout'/>
         	</fo:repeatable-page-master-alternatives>
         </fo:page-sequence-master>
         
      </fo:layout-master-set>

      <fo:page-sequence master-reference='odd-even'>
        
        <!-- region after -->
        <fo:static-content flow-name='xsl-region-after'>
          	<fo:block font-size='10pt' font-family='serif' text-align='center' space-before='3em'>
          		<fo:page-number/>
          	</fo:block>
        </fo:static-content> 
        
        <!-- region body -->
        <fo:flow flow-name='xsl-region-body' font-size='12pt' font-family='serif'>
          
		<fo:block font-size='18pt' font-family='sans-serif' font-weight='bold' space-before='5em' text-align='center' space-after='1em'>
			<xsl:value-of select='teiHeader/fileDesc/titleStmt/title'/>
		</fo:block>
		
		<fo:block font-size='16pt' font-family='serif' text-align='center' space-after='1em'>
			<xsl:value-of select='/TEI/text/front/titlePage/byline' />
		</fo:block>

		<fo:block font-size='16pt' font-family='serif' text-align='center' space-after='1em'>
			<xsl:value-of select='/TEI/text/front/titlePage/docImprint' /><xsl:value-of select='/TEI/text/front/titlePage/imprimatur' />
		</fo:block>
		
		<!-- cool table of contents -->
		<xsl:if test='/TEI/text/body/div'>
				<fo:block font-size='16pt' font-family='sans-serif' font-weight='bold' space-before='5em' space-after='1em' break-before='odd-page'>
					<xsl:text>Table of contents</xsl:text>
				</fo:block>
			<xsl:for-each select="/TEI/text/*/div">
				<xsl:if test='./@type != "colophon"'>
					<fo:block font-size='10pt' font-family='serif'>
						<xsl:value-of select='./head' />
					</fo:block>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>

		<xsl:apply-templates />

	</fo:flow>

 	</fo:page-sequence>

    </fo:root>
    
  </xsl:template>

	<!-- paragraph (p) -->
	<xsl:template match="p">
		<xsl:choose>
			<xsl:when test='./@rend = "right"'>
				<fo:block text-align='right' space-after='1em' space-before='1em'>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test='./@rend = "center"'>
				<fo:block text-align='center' space-after='1em' space-before='1em'>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test='./@rend = "fiction"'>
				<fo:block text-indent='1em'>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:when test='./@rend = "pre"'>
				<fo:block font-family='monospace' white-space-collapse="false" linefeed-treatment='preserve'>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block space-after='1em' space-before='1em'>
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- division #0 (div) -->
	<xsl:template match="div">
		<xsl:choose>
			<xsl:when test='./@type = "colophon"'>
    			<fo:block font-size='16pt' font-family='sans-serif' font-weight='bold' space-before='5em' space-after='1em' break-before='odd-page' >
      				<xsl:value-of select='./head' />
     			</fo:block>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates />
	</xsl:template>

 	<xsl:template match="div">
		<fo:block font-size='16pt' font-family='sans-serif' font-weight='bold'  space-before='5em' space-after='1em'  break-before='odd-page'>
			<xsl:value-of select='./head' />
		</fo:block>
		<xsl:apply-templates />
	</xsl:template>


	<!-- images (figure) -->
	<xsl:template match="graphic">
	<fo:external-graphic space-before='2em'>
	<xsl:attribute name='src'><xsl:value-of select='@url'/></xsl:attribute>
	</fo:external-graphic>
				<fo:block space-before='1em'>
				<xsl:apply-templates />
				</fo:block>
	</xsl:template>

	<xsl:template match='epigraph'>
		<fo:block margin-left='1em' margin-right='1em'>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match='quote'>
		<fo:block margin-left='2em' margin-right='2em' font-size='10pt' space-before='1em' space-after='1em'>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match='lg'>
		<fo:block space-after='1em' space-before='1em'>
			<xsl:apply-templates />
		</fo:block>
	</xsl:template>

	<xsl:template match='l'>
		<xsl:choose>
			<xsl:when test='@rend="indent"'>
				<fo:block text-indent='1em'>
					<xsl:apply-templates />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:apply-templates />
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- line break (lb) -->
	<xsl:template match='lb'>
	<fo:block/><xsl:apply-templates />
	</xsl:template>

	<!-- lists -->
	<xsl:template match="list[@type='ordered']">
	  <fo:list-block start-indent='1em' provisional-distance-between-starts='2em'>
	  	<xsl:apply-templates/>
	  </fo:list-block>
	</xsl:template>
	
	<!-- lists -->
	<xsl:template match="list[@type='bulleted']">
	  <fo:list-block start-indent='1em' provisional-distance-between-starts='2em'>
	  	<xsl:apply-templates/>
	  </fo:list-block>
	</xsl:template>
	
	<!-- lists -->
	<xsl:template match="item[parent::list[@type='bulleted']]">
	  <fo:list-item>
	  	<fo:list-item-label end-indent='label-end()'>
	  		<fo:block><xsl:text>&#x2022;</xsl:text></fo:block>
	  	</fo:list-item-label>
	  	<fo:list-item-body start-indent='body-start()'>
	  		<fo:block><xsl:apply-templates/></fo:block>
	  	</fo:list-item-body>
	  </fo:list-item>
	</xsl:template>

	<xsl:template match="item[parent::list[@type='ordered']]">
	  <fo:list-item>
	  	<fo:list-item-label end-indent='label-end()'>
	  		<fo:block><xsl:number/></fo:block>
	  	</fo:list-item-label>
	  	<fo:list-item-body start-indent='body-start()'>
	  		<fo:block><xsl:apply-templates/></fo:block>
	  	</fo:list-item-body>
	  </fo:list-item>
	</xsl:template>
		

 	<!-- table (table) -->
	<xsl:template match="table">
		<xsl:choose>
			<xsl:when test='./@rend = "left"'>
				<fo:table table-layout="fixed">
					<fo:table-body><xsl:apply-templates /></fo:table-body></fo:table>
			</xsl:when>
			<xsl:when test='./@rend = "right"'>
				<fo:table table-layout="fixed">
					<fo:table-body><xsl:apply-templates /></fo:table-body></fo:table>
			</xsl:when>
			<xsl:when test='./@rend = "center"'>
				<fo:table table-layout="fixed">
					<fo:table-body><xsl:apply-templates /></fo:table-body></fo:table>
			</xsl:when>
			<xsl:otherwise>
				<fo:table table-layout="fixed">
					<fo:table-column column-number='1' column-width='5em'/>
					<fo:table-column column-number='2' column-width='5em'/>
					<fo:table-column column-number='3' column-width='5em'/>
					<fo:table-column column-number='4' column-width='5em'/>
					<fo:table-column column-number='5' column-width='5em'/>
					<fo:table-body><xsl:apply-templates /></fo:table-body></fo:table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- table row (row) -->
	<xsl:template match="row">
		<xsl:choose>
			<xsl:when test='./@rend = "left"'>
				<fo:table-row><xsl:apply-templates /></fo:table-row>
			</xsl:when>
			<xsl:when test='./@rend = "right"'>
				<fo:table-row><xsl:apply-templates /></fo:table-row>
			</xsl:when>
			<xsl:when test='./@rend = "center"'>
				<fo:table-row><xsl:apply-templates /></fo:table-row>
			</xsl:when>
			<xsl:when test='./@rend = "justify"'>
				<fo:table-row><xsl:apply-templates /></fo:table-row>
			</xsl:when>
			<xsl:otherwise>
				<fo:table-row><xsl:apply-templates /></fo:table-row>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- table row (cell) -->
	<xsl:template match="cell">
		<xsl:choose>
			<xsl:when test='./@rend = "left"'>
				<fo:table-cell><fo:block><xsl:apply-templates /></fo:block></fo:table-cell>
			</xsl:when>
			<xsl:when test='./@rend = "right"'>
				<fo:table-cell><fo:block><xsl:apply-templates /></fo:block></fo:table-cell>
			</xsl:when>
			<xsl:when test='./@rend = "center"'>
				<fo:table-cell><fo:block><xsl:apply-templates /></fo:block></fo:table-cell>
			</xsl:when>
			<xsl:when test='./@rend = "justify"'>
				<fo:table-cell><fo:block><xsl:apply-templates /></fo:block></fo:table-cell>
			</xsl:when>
			<xsl:otherwise>
				<fo:table-cell><fo:block><xsl:apply-templates /></fo:block></fo:table-cell>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- do nothing templates -->

	<!-- teiheader (do nothing) -->
	<xsl:template match="teiHeader" />
	
	<!-- teiheader (do nothing) -->
	<xsl:template match="front/titlePage" />
		
	<!-- head (head) -->
	<xsl:template match="head" />


</xsl:stylesheet> 