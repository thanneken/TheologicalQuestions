<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="tei" version="2.0">
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
		<desc>
			<p>CC BY-NC</p>
			<p>Author: Todd Hanneken</p>
		</desc>
	</doc>
	<xsl:import href="../../../epub3/tei-to-epub3.xsl"/>
	<!-- exporting to epub similar to but not identical with html5 -->
	<!-- quotation marks are typed in the source, do not add -->
	<xsl:param name="preQuote"/>
	<xsl:param name="postQuote"/>
	<!-- add css (tagsDecl is really supposed be descriptive of source, not prescriptive of derivative) -->
	<xsl:template name="cssHook">
		<xsl:element name="style" xmlns="http://www.w3.org/1999/xhtml">
			span.bibl{font-style:normal;}
			.caption{color:darkred;font-style:normal;max-width:100%;}
			.chapter{clear:right;page-break-before:always;}
			.cit{padding-left:3em;padding-bottom:0;margin-bottom:1em;}
			div.citquote{margin-left:0;margin-right:0;}
			.doubleunderline{text-decoration:underline;text-decoration-style:double;}
			.float{float:right;clear:right;max-width:3in;}
			.floatingHead{margin:0;font-weight:bold;}
			.floatingText{padding:0.5em;color:darkblue;}
			.graphic{width:100%;}
			.hi{font-weight:bold;font-style:normal;}
			.maintitle{text-align:center;}
			.notitalic{font-style:normal;}
			.ref::after{content:")";}
			.ref::before{content:"(";}
			.section{clear:right;}
			.toc{padding-inline-start:0.4em;}
			.vs{color:#747474;font-size:75%;line-height:0;position:relative;vertical-align:baseline;top:-0.5em;padding-right:0.3em;}
			.wide{margin:0;width:6.5in;max-width:100%;}
			span.distinct{font-style:normal;color:maroon;}
			figure{margin:6pt;}
			<!-- not proud of this hack but it gets the job done -->
			#p3-2-4-2,#p4-1-2-3,#p4-4-1-9-1,#p5-4-2-5-1{clear:right;}
		</xsl:element>
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

</xsl:stylesheet>
