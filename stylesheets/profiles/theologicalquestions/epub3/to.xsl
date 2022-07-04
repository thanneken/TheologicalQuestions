<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:oxy="http://www.oxygenxml.com/ns/doc/xsl" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:html="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="tei" version="2.0">
	<oxy:doc scope="stylesheet" type="stylesheet"><desc>CC BY-NC Author: Todd Hanneken</desc></oxy:doc>
	<xsl:import href="../../../epub3/tei-to-epub3.xsl"/>
	<xsl:strip-space elements="*"/>
	<xsl:preserve-space elements="tei:bibl"/>
	<!-- quotation marks are typed in the source, do not add -->
	<xsl:param name="preQuote"/>
	<xsl:param name="postQuote"/>

	<xsl:template name="cssHook">
		<xsl:element name="style" xmlns="http://www.w3.org/1999/xhtml">
			span.bibl{font-style:normal;}
			.caption{color:darkred;font-style:normal;max-width:100%;}
			.chapter{clear:left;clear:right;border-top:2pxdottedblue;margin-top:2em;}
			.cit{padding-left:3em;padding-bottom:0;margin-bottom:1em;}
			div.citquote{margin-left:0;margin-right:0;}
			.doubleunderline{text-decoration:underline;text-decoration-style:double;}
			figure{margin:6pt;}
			.float{float:right;clear:right;max-width:3in;}
			.floatingHead{margin:0;font-weight:bold;}
			.floatingText{padding:0.5em;color:darkblue;}
			.graphic{width:100%;}
			.hi{font-weight:bold;font-style:normal;}
			.maintitle{text-align:center;}
			.notitalic{font-style:normal;}
			.section{clear:right;}
			.toc{padding-inline-start:0.4em;}
			.vs{color:#747474;font-size:75%;line-height:0;position:relative;vertical-align:baseline;top:-0.5em;padding-right:0.3em;}
			.wide{margin:0;width:6.5in;max-width:100%;}
			span.distinct{font-style:normal;color:maroon;}
			figure{margin:6pt;}
			<!-- not proud of this hack but it gets the job done -->
			#p3-2-4-2,#p4-1-2-3,#p4-4-1-9-1,#p5-4-2-5-1,#p6-1-1-6{clear:right;}
			div.l{margin-left:0;}
			div.figurelistitem{clear:left;padding-top:10px;}
			div.figurelisthead{font-size:1.5em;margin-top:0.83em;font-weight: bold;}
			p.bibliography{font-size:85%;}
		</xsl:element>
	</xsl:template>
	<!-- css does not suffice to add parentheses around ref in ePub version -->
  <xsl:template match="tei:ref[not(@target)]">
		<xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
	</xsl:template>
	<!-- allow verse milestones to be formatted as biblicists expect --> 
	<xsl:template match="tei:milestone">
		<xsl:if test="@unit='vs'">
			<xsl:element name="span" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:attribute name="class">vs</xsl:attribute>
				<xsl:value-of select="@n"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<!-- specify that a floating text head is html h4, not h1 -->
	<!-- h4 throws an error because does not nest under h3, just call it a div -->
	<xsl:template match="tei:floatingText/tei:body/tei:head">
		<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="class">floatingHead</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<!-- allow floating text to have attributes (fixes a bug) --> 
	<xsl:template match="tei:floatingText">
		<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="class">floatingText <xsl:call-template name="makeRendition"/></xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="tei:s">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<!-- it appears to be necessary to copy the whole opfmetadata template from the teic stylesheet to add metadata -->
  <xsl:template name="opfmetadata">
    <xsl:param name="author"/>
    <xsl:param name="printAuthor"/>
    <xsl:param name="coverImageOutside"/>
    <xsl:attribute name="prefix">
      <xsl:text>rendition: http://www.idpf.org/vocab/rendition#</xsl:text>
    </xsl:attribute>
    <metadata xmlns="http://www.idpf.org/2007/opf"
	      xmlns:dc="http://purl.org/dc/elements/1.1/"
	      xmlns:dcterms="http://purl.org/dc/terms/" 
	      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	      xmlns:opf="http://www.idpf.org/2007/opf">
      <dc:title id="title">
				<xsl:sequence select="tei:generateSimpleTitle(.)"/>
      </dc:title>
      <xsl:choose>
				<xsl:when test="$filePerPage='true'">
					<meta property="rendition:layout">pre-paginated</meta>
					<meta property="rendition:orientation">auto</meta>
					<meta property="rendition:spread">both</meta>
				</xsl:when>
				<xsl:otherwise>
					<meta property="rendition:layout">reflowable</meta>
					<meta property="rendition:spread">auto</meta>
				</xsl:otherwise>
      </xsl:choose>
      <meta refines="#title" property="title-type">main</meta>
      <dc:creator id="creator">
				<xsl:sequence select="if ($printAuthor !='') then $printAuthor
			      else 'not recorded'"/>
      </dc:creator>
      <meta refines="#creator" property="file-as">
				<xsl:sequence select="if ($author !='') then $author
			      else 'not recorded'"/>
      </meta>
      <meta refines="#creator" property="role" scheme="marc:relators">aut</meta>
				<dc:language>
					<xsl:call-template name="generateLanguage"/>
				</dc:language>
      <xsl:call-template name="generateSubject"/>
				<dc:identifier id="pub-id">
					<xsl:call-template name="generateID"/>
				</dc:identifier>
      <meta refines="#pub-id" property="identifier-type" scheme="onix:codelist5">15</meta>
      <dc:description>
				<xsl:sequence select="tei:generateSimpleTitle(.)"/>
				<xsl:text> / </xsl:text>
				<xsl:value-of select="$author"/>
      </dc:description>
      <dc:publisher>
				<xsl:sequence select="tei:generatePublisher(.,$publisher)"/>
      </dc:publisher>
      <xsl:for-each select="tei:teiHeader/tei:profileDesc/tei:creation/tei:date[@notAfter]">
				<dc:date id="creation">
					<xsl:value-of select="@notAfter"/>
				</dc:date>
      </xsl:for-each>
      <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:sourceDesc//tei:date[@when][1]">
				<dc:date id="original-publication">
					<xsl:value-of select="@when"/>
				</dc:date>
      </xsl:for-each>
      <dc:date id="epub-publication">
				<xsl:sequence select="replace(tei:generateDate(.)[1],'[^0-9\-]+','')"/>
      </dc:date>
      <dc:rights>
				<xsl:call-template name="generateLicence"/>
      </dc:rights>
      <xsl:if test="not($coverImageOutside='')">
				<meta name="cover" content="cover-image"/>
      </xsl:if>	
      <meta property="dcterms:modified">
				<xsl:sequence select="tei:whatsTheDate()"/>
      </meta>
			<meta property="schema:accessibilitySummary">This publication conforms to WCAG 2.0 Level AA.</meta>
			<meta property="schema:accessMode">textual</meta>
			<meta property="schema:accessMode">visual</meta>
			<meta property="schema:accessModeSufficient">textual,visual</meta>
			<meta property="schema:accessModeSufficient">textual</meta>
			<meta property="schema:accessibilityFeature">structuralNavigation</meta>
			<meta property="schema:accessibilityFeature">alternativeText</meta>
			<meta property="schema:accessibilityFeature">longDescription</meta>
			<meta property="schema:accessibilityHazard">noFlashingHazard</meta>
			<meta property="schema:accessibilityHazard">noSoundHazard</meta>
			<meta property="schema:accessibilityHazard">noMotionSimulationHazard</meta>
    </metadata>
	</xsl:template>

<!-- bug fix, see below -->
	<xsl:template name="addLangAtt">
		<xsl:variable name="documentationLanguage">
			<xsl:choose>
				<xsl:when test="string-length($doclang) &gt; 0">
					<xsl:value-of select="$doclang"/>
				</xsl:when>
				<xsl:when test="ancestor-or-self::tei:schemaSpec/@docLang">
					<xsl:value-of select="//tei:schemaSpec[1]/@docLang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>en</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="supplied">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::tei:*[@xml:lang]">
					<xsl:value-of select="ancestor-or-self::tei:*[@xml:lang][1]/@xml:lang"/>
				</xsl:when>
				<xsl:when test="ancestor-or-self::tei:*[@lang]">
					<xsl:value-of select="ancestor-or-self::tei:*[@lang][1]/@lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$documentationLanguage"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$outputTarget = 'html'">
				<xsl:attribute name="xml:lang">
					<xsl:value-of select="$supplied"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:when test="$outputTarget = 'html5'">
				<xsl:attribute name="lang">
					<xsl:value-of select="$supplied"/>
				</xsl:attribute>
			</xsl:when>
			<!-- such a stupid bug but adding the otherwise scenario puts lang tag in epub3 index.html so passes Daisy validator -->
			<xsl:otherwise>
				<xsl:attribute name="lang">
					<xsl:value-of select="$supplied"/>
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <oxy:doc class="numbering"><desc>[common] How to number sections in back matter</desc></oxy:doc>
  <xsl:template name="numberBackDiv">
    <xsl:if test="not($numberBackHeadings='')">
      <xsl:number count="tei:div" format="A.1.1.1.1.1:" level="multiple"/>
    </xsl:if>
  </xsl:template>

	<oxy:doc><desc>Backmatter</desc></oxy:doc>
	<xsl:template match="tei:back/tei:div">
		<xsl:choose>
			<xsl:when test="@xml:id='listfigures'">
				<xsl:result-document href="{concat($directory,'/OPS/listfigures.html')}" method="xml">
					<xsl:element name="html" xmlns="http://www.w3.org/1999/xhtml">
						<xsl:attribute name="xml:lang"><xsl:text>en</xsl:text></xsl:attribute>
						<xsl:element name="head" xmlns="http://www.w3.org/1999/xhtml">
							<xsl:call-template name="metaHTML">
								<xsl:with-param name="title">listfigures</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="linkCSS">
								<xsl:with-param name="file">stylesheet.css</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="cssHook"/>
							<xsl:element name="title" xmlns="http://www.w3.org/1999/xhtml">
								<xsl:text>listfigures</xsl:text>
							</xsl:element>
						</xsl:element>
						<xsl:element name="body" xmlns="http://www.w3.org/1999/xhtml">
							<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
								<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
								<xsl:element name="html:div">
									<xsl:attribute name="class"><xsl:text>figurelisthead</xsl:text></xsl:attribute>
									<xsl:value-of select="tei:head"/>
								</xsl:element>
								<xsl:for-each select="//tei:graphic">
									<xsl:apply-templates select="." mode="listfig"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:result-document>
			</xsl:when>
			<xsl:when test="@xml:id='listsupplements'">
				<xsl:result-document href="{concat($directory,'/OPS/listsupplements.html')}" method="xml">
					<xsl:element name="html" xmlns="http://www.w3.org/1999/xhtml">
						<xsl:attribute name="xml:lang"><xsl:text>en</xsl:text></xsl:attribute>
						<xsl:element name="head" xmlns="http://www.w3.org/1999/xhtml">
							<xsl:call-template name="metaHTML">
								<xsl:with-param name="title">listsupplements</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="linkCSS">
								<xsl:with-param name="file">stylesheet.css</xsl:with-param>
							</xsl:call-template>
							<xsl:call-template name="cssHook"/>
							<xsl:element name="title" xmlns="http://www.w3.org/1999/xhtml">
								<xsl:text>listsupplements</xsl:text>
							</xsl:element>
						</xsl:element>
						<xsl:element name="body" xmlns="http://www.w3.org/1999/xhtml">
							<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
								<xsl:attribute name="class"><xsl:text>figurelisthead</xsl:text></xsl:attribute>
								<xsl:value-of select="tei:head"/>
							</xsl:element>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:element>
				</xsl:result-document>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Unanticipated Scenario in Backmatter</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>List of Figures (preserving tei:desc/tei:label required adding node() along with @* to copy-of in epub-preflight.xsl)</desc></oxy:doc>
	<xsl:template match="tei:graphic" mode="listfig">
		<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="class">figurelistitem</xsl:attribute>
			<xsl:element name="img" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:choose>
						<xsl:when test="tei:desc/tei:label">
							<xsl:value-of select="tei:desc/tei:label/text()"/>
						</xsl:when>
						<xsl:when test="../tei:head">
							<xsl:value-of select="../tei:head/text()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>No alternate text has been provided, either as a figure head or as desc label</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="style"><xsl:text>float:left;width:1in;margin-right:10px;</xsl:text></xsl:attribute>
			</xsl:element>
			<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:attribute name="class"><xsl:text>figlistcaption</xsl:text></xsl:attribute>
				<xsl:value-of select="tei:desc/tei:label"/>
				<xsl:if test="tei:desc/tei:label and ../tei:head">
					<xsl:text>. </xsl:text>
				</xsl:if>
				<xsl:value-of select="../tei:head"/>
			</xsl:element>
			<xsl:element name="p" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:for-each select="tei:desc/tei:bibl">
					<xsl:attribute name="class"><xsl:text>bibliography</xsl:text></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<oxy:doc><desc>Format bibliography, particularly in list of figures</desc></oxy:doc>
	<xsl:template match="tei:bibl/tei:author">
		<xsl:value-of select="."/>
		<xsl:text>, </xsl:text>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:title">
		<xsl:element name="i" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:value-of select="."/>
		</xsl:element>
		<xsl:if test="not(..[@rend='inline'])">
			<xsl:text>. </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:pubPlace">
		<xsl:value-of select="."/>
		<xsl:if test="following-sibling::*[1] = following-sibling::tei:distributor">
			<xsl:text>: </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:distributor">
		<xsl:value-of select="."/>
		<xsl:if test="following-sibling::*[1] = following-sibling::tei:date">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:date">
		<xsl:value-of select="."/>
		<xsl:text>. </xsl:text>
	</xsl:template>
	<xsl:template match="tei:ptr">
		<xsl:text>&lt;</xsl:text>
		<xsl:element name="a" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
			<xsl:value-of disable-output-escaping="yes" select="replace(@target,'([A-z]|[0-9])([/_])','$1&#8203;$2')"/>
		</xsl:element>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:availability/tei:ab">
		<xsl:value-of select="."/>
		<xsl:text>. </xsl:text>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:availability/tei:licence">
		<xsl:element name="a" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
		<xsl:text>. </xsl:text>
	</xsl:template>

</xsl:stylesheet>
