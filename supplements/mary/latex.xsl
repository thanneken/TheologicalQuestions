<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:oxy="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"                
	xsi:schemaLocation="http://www.w3.org/1999/XSL/Transform
										 https://www.w3.org/2007/schema-for-xslt20.xsd
										 http://www.w3.org/1999/XSL/Format
										 https://svn.apache.org/repos/asf/xmlgraphics/fop/trunk/fop/src/foschema/fop.xsd">
  <xsl:output method="text" encoding="utf8"/>

	<oxy:doc><desc>Escape special characters, borrowed from TEIC</desc></oxy:doc>
  <xsl:function name="tei:escapeChars" as="xs:string" override-extension-function="yes">
    <xsl:param name="letters"/>
    <xsl:param name="context"/>
      <xsl:value-of
			select="replace(replace(replace(replace(replace(translate($letters,'ſ&#10;','s '), 
		  '\\','\\textbackslash '),
		  '_','\\textunderscore '),
		  '\^','\\textasciicircum '),
		  '~','\\textasciitilde '),
		  '([\}\{%&amp;\$#])','\\$1')"/>
  </xsl:function>

	<oxy:doc><desc>Space is tricky in Latex</desc></oxy:doc>
	<xsl:strip-space elements="tei:*" />
	<xsl:preserve-space elements="tei:s" />
	<!--
	<xsl:template match="text()">
		<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
	</xsl:template>
	<xsl:template match="text()"><xsl:value-of select="normalize-space(.)"/></xsl:template>
	<xsl:preserve-space elements="tei:p" />
	-->

	<oxy:doc><desc>top level, set up html header, toc, and citation footer</desc></oxy:doc>
	<xsl:template match="/tei:TEI">
		<xsl:text>\documentclass[11pt,letterpaper]{article}&#10;</xsl:text>
		<xsl:text>\makeatletter&#10;</xsl:text>
		<xsl:text>\usepackage{geometry}&#10;</xsl:text>
		<xsl:text>\geometry{letterpaper,margin=1in}</xsl:text>
		<xsl:text>\setlength{\parskip}{0.3\baselineskip}</xsl:text>
		<xsl:text>\usepackage{tabulary}&#10;</xsl:text>
		<xsl:text>\usepackage{bookmark}&#10;</xsl:text>
		<xsl:text>\usepackage{graphicx}&#10;</xsl:text>
		<xsl:text>\usepackage[english,bidi=default]{babel}&#10;</xsl:text>
		<xsl:text>\babelfont{rm}[Language=Default]{DejaVu Serif}&#10;</xsl:text>
		<xsl:text>\babelfont{sf}[Language=Default]{DejaVu Sans}&#10;</xsl:text>
		<xsl:text>\babelfont{tt}[Language=Default]{DejaVu Sans Mono}&#10;</xsl:text>
		<xsl:text>\babelfont[hebrew]{rm}[Language=Default]{SBL BibLit}&#10;</xsl:text>
		<xsl:text>\babelfont[hebrew]{sf}[Language=Default]{SBL BibLit}&#10;</xsl:text>
		<xsl:text>\babelfont[hebrew]{tt}[Language=Default]{SBL BibLit}&#10;</xsl:text>
		<xsl:text>\usepackage{csquotes}&#10;</xsl:text>
		<xsl:text>\usepackage{titlesec}&#10;</xsl:text>
		<xsl:text>\titleformat{\section}[hang]{\normalfont\bfseries}{\thesection}{1em}{}&#10;</xsl:text>
		<xsl:text>\titleformat{\subsection}[hang]{\normalfont\bfseries}{\thesubsection}{1em}{}&#10;</xsl:text>
		<xsl:text>\titleformat{\subsubsection}[hang]{\normalfont\bfseries}{\thesubsubsection}{1em}{}&#10;</xsl:text>
		<xsl:text>\title{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\author{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:distributor"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\date{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\usepackage{xurl}&#10;</xsl:text>
		<xsl:text>\usepackage{hyperref}&#10;</xsl:text>
		<xsl:text>\hypersetup{</xsl:text>
		<xsl:text>pdftitle={</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
		<xsl:text>},</xsl:text>
		<xsl:text>pdfauthor={</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
		<xsl:text>},</xsl:text>
		<xsl:text>breaklinks=TRUE</xsl:text>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\usepackage{hanging}&#10;</xsl:text>
		<xsl:text>\begin{document}&#10;</xsl:text>
		<xsl:text>\maketitle&#10;</xsl:text>
		<xsl:text>\tableofcontents{}&#10;</xsl:text>
		<xsl:text>\par\noindent\rule{\textwidth}{0.2pt}&#10;</xsl:text>
		<xsl:apply-templates select="tei:text/tei:body"/>
		<xsl:apply-templates select="tei:text/tei:back"/>
		<xsl:text>&#10;\end{document}&#10;</xsl:text>
	</xsl:template>

	<oxy:doc><desc>sections and headings</desc></oxy:doc>
	<xsl:template match="/tei:TEI/tei:text/tei:body/tei:div">
		<xsl:text>&#10;\section[{</xsl:text>
		<xsl:apply-templates select="tei:head[1]"/>
		<xsl:text>}]{</xsl:text>
		<xsl:apply-templates select="tei:head[1]"/>
		<xsl:text>}</xsl:text>
		<xsl:apply-templates select="*[position() > 1]"/>
	</xsl:template>
	<xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div">
		<xsl:text>&#10;\subsection[{</xsl:text>
		<xsl:apply-templates select="tei:head"/>
		<xsl:text>}]{</xsl:text>
		<xsl:apply-templates select="tei:head"/>
		<xsl:text>}</xsl:text>
		<xsl:apply-templates select="*[position() > 1]"/>
	</xsl:template>
	<xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:div">
		<xsl:text>&#10;\subsubsection[{</xsl:text>
		<xsl:apply-templates select="tei:head"/>
		<xsl:text>}]{</xsl:text>
		<xsl:apply-templates select="tei:head"/>
		<xsl:text>}</xsl:text>
		<xsl:apply-templates select="*[position() > 1]"/>
	</xsl:template>
	<xsl:template match="/tei:TEI/tei:text/tei:back/tei:div">
		<xsl:text>&#10;\section[{</xsl:text>
		<xsl:apply-templates select="tei:head[1]"/>
		<xsl:text>}]{</xsl:text>
		<xsl:apply-templates select="tei:head[1]"/>
		<xsl:text>}</xsl:text>
		<xsl:apply-templates select="*[position() > 1]"/>
	</xsl:template>

	<oxy:doc><desc>Paragraphs: indented if following another paragraph, notes follow paragraph</desc></oxy:doc>
	<xsl:template match="tei:p">
		<xsl:choose>
			<xsl:when test="preceding-sibling::tei:p or preceding-sibling::tei:list">&#10;\par&#10;</xsl:when>
			<xsl:when test="parent::tei:note"/>
			<xsl:otherwise><xsl:text>&#10;\par\noindent&#10;</xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>

	<oxy:doc><desc>Notes assume footnotes</desc></oxy:doc>
	<xsl:template match="tei:note">
		<xsl:text>\footnote{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<oxy:doc><desc>foreign for Greek, Hebrew, and other</desc></oxy:doc>
	<xsl:template match="tei:foreign">
		<xsl:choose>
			<xsl:when test="@xml:lang='el'">
				<xsl:apply-templates/>
			</xsl:when>	
			<xsl:when test="@xml:lang='he'">
				<xsl:text>\foreignlanguage{hebrew}{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:when>	
			<xsl:otherwise>
				<xsl:text>\textit{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>hi uses class from rend unless unspecified, then default defined in css as bold</desc></oxy:doc>
  <xsl:template match="tei:hi[not(@rend)]">
		<xsl:text>\textbf{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<oxy:doc><desc>Italicize title in the context of a bibl</desc></oxy:doc>
	<xsl:template match="tei:title">
		<xsl:choose>
			<xsl:when test="@level='m' or @level='j' or parent::tei:bibl or ../tei:title[@level='m']">
				<xsl:text>\textit{</xsl:text>
					<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>Cit Quote Ref</desc></oxy:doc>
	<xsl:template match="tei:cit/tei:ref">
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::tei:quote)">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:cit/tei:quote">
		<xsl:if test="@rend='rtl'">
			<xsl:text>&#10;\selectlanguage{hebrew}</xsl:text>
		</xsl:if>
		<xsl:text>&#10;\begin{displayquote}&#10;</xsl:text>
			<xsl:apply-templates/>
			<xsl:if test="following-sibling::*[1] = following-sibling::tei:ref">
				<xsl:text> </xsl:text>
				<xsl:value-of select="following-sibling::tei:ref"/>
			</xsl:if>
		<xsl:text>&#10;\end{displayquote}&#10;</xsl:text>
		<xsl:if test="@rend='rtl'">
			<xsl:text>&#10;\selectlanguage{english}</xsl:text>
		</xsl:if>
	</xsl:template>

	<oxy:doc><desc>Add a space between sentences</desc></oxy:doc>
	<xsl:template match="tei:s">
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<oxy:doc><desc>Verse milestones</desc></oxy:doc>
	<xsl:template match="tei:milestone">
		<xsl:if test="@unit='vs'">
			<xsl:text> \textsuperscript{</xsl:text><xsl:value-of select="@n"/><xsl:text>}</xsl:text>
		</xsl:if>
	</xsl:template>

	<oxy:doc><desc>Figures and Graphics (will width always work as entered in the xml?)</desc></oxy:doc>
	<xsl:template match="tei:figure">
		<xsl:text>&#10;\begin{figure}[h!t]&#10;\centering&#10;</xsl:text>
		<xsl:apply-templates select="tei:graphic | tei:head"/>
		<xsl:text>&#10;\end{figure}&#10;</xsl:text>
	</xsl:template>
	<xsl:template match="tei:figure/tei:graphic">
		<xsl:text>&#10;\includegraphics[width=</xsl:text>
		<xsl:value-of select="@width"/>
		<xsl:text>]{</xsl:text>
		<xsl:value-of select="@url"/>
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="tei:figure/tei:head">
		<xsl:text>&#10;\caption{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<oxy:doc><desc>ref@target to a@href</desc></oxy:doc>
	<xsl:template match="tei:ref[@target]">
		<xsl:text>\href{</xsl:text>
		<xsl:value-of select="tei:escapeChars(normalize-space(@target),@target)"/>
		<xsl:text>}{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="tei:ptr[@target]">
		<xsl:choose>
			<xsl:when test="contains(substring(@target,1,4),'http')">
				<xsl:text> \url{</xsl:text>
				<xsl:value-of select="tei:escapeChars(normalize-space(@target),@target)"/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:when test="contains(substring(@target,1,1),'#')">
				<xsl:for-each select="id(substring-after(@target,'#'))">
					<xsl:value-of select="*/tei:author/tei:surname"/>
					<xsl:text>, </xsl:text>
					<xsl:choose>
						<xsl:when test="tei:monogr/tei:title[@level='m'] and tei:monogr/tei:title[@type='short']">
							<xsl:apply-templates select="tei:monogr/tei:title[@type='short']"/>
						</xsl:when>
						<xsl:when test="tei:analytic/tei:title[@type='short']">
							<xsl:text>“</xsl:text>
							<xsl:apply-templates select="tei:analytic/tei:title[@type='short']"/>
						</xsl:when>
						<xsl:when test="tei:analytic/tei:title">
							<xsl:text>“</xsl:text>
							<xsl:apply-templates select="tei:analytic/tei:title[@level='a']"/>
						</xsl:when>
						<xsl:when test="tei:monogr/tei:title[@level='m']">
							<xsl:apply-templates select="tei:monogr/tei:title[@level='m']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>UNANTICIPATED SITUATION</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>[UNANTICIPATED SCENARIO]</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>Backmatter</desc></oxy:doc>
	<xsl:template match="tei:back">
		<xsl:text>&#10;\appendix&#10;</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<oxy:doc><desc>Bibliography List (do nothing for now but for large projects consider creating a .bib file)</desc></oxy:doc>
	<xsl:template match="tei:listBibl">
		<xsl:apply-templates/>
	</xsl:template>
	<oxy:doc><desc>Structured Bibliography Item</desc></oxy:doc>
	<xsl:template match="tei:biblStruct">
		<xsl:text>&#10;\begin{hangparas}{0.5in}{1}&#10;</xsl:text>
			<xsl:choose>
				<xsl:when test="count(*/tei:author) = 0"/>
				<xsl:when test="count(*/tei:author) = 1">
					<xsl:value-of select="*/tei:author[1]/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="*/tei:author[1]/tei:surname"/>
				</xsl:when>
				<xsl:when test="count(*/tei:author) = 2">
					<xsl:value-of select="*/tei:author[1]/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="*/tei:author[1]/tei:surname"/>
					<xsl:text> and </xsl:text>
					<xsl:value-of select="*/tei:author[2]/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="*/tei:author[2]/tei:surname"/>
				</xsl:when>
				<xsl:when test="count(*/tei:author) > 2 ">
					<xsl:value-of select="*/tei:author[1]/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="*/tei:author[1]/tei:surname"/>
					<xsl:text> et al.</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>UNANTICIPATED SITUATION</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>, </xsl:text>
			<xsl:choose>
				<xsl:when test="@type='book'">
					<xsl:apply-templates select="tei:monogr/tei:title[@level='m']"/>
					<xsl:text> (</xsl:text>
					<xsl:apply-templates select="tei:series"/>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:pubPlace"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:publisher"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
					<xsl:text>).</xsl:text>
				</xsl:when>
				<xsl:when test="@type='journalArticle'">
					<xsl:text>“</xsl:text>
					<xsl:apply-templates select="tei:analytic/tei:title[@level='a']"/>
					<xsl:text>,” </xsl:text>
					<xsl:apply-templates select="tei:monogr/tei:title"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='volume']"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
					<xsl:text>): </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/>
					<xsl:text>.</xsl:text>
				</xsl:when>
				<xsl:when test="@type='bookSection'">
					<xsl:text>“</xsl:text>
					<xsl:apply-templates select="tei:analytic/tei:title[@level='a']"/>
					<xsl:text>,” in </xsl:text>
					<xsl:apply-templates select="tei:monogr/tei:title[@level='m']"/>
					<xsl:text> (</xsl:text>
					<xsl:choose>
						<xsl:when test="count(tei:monogr/tei:editor) = 0"/>
						<xsl:when test="count(tei:monogr/tei:editor) = 1">
							<xsl:text>ed. </xsl:text>
							<xsl:value-of select="tei:monogr/tei:editor[1]/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="tei:monogr/tei:editor[1]/tei:surname"/>
							<xsl:text>; </xsl:text>
						</xsl:when>
						<xsl:when test="count(tei:monogr/tei:editor) = 2">
							<xsl:text>ed. </xsl:text>
							<xsl:value-of select="tei:monogr/tei:editor[1]/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="tei:monogr/tei:editor[1]/tei:surname"/>
							<xsl:text> and </xsl:text>
							<xsl:value-of select="tei:monogr/tei:editor[2]/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="tei:monogr/tei:editor[2]/tei:surname"/>
							<xsl:text>; </xsl:text>
						</xsl:when>
						<xsl:when test="count(tei:monogr/tei:editor) > 2 ">
							<xsl:text>ed. </xsl:text>
							<xsl:value-of select="tei:monogr/tei:editor[1]/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="tei:monogr/tei:editor[1]/tei:surname"/>
							<xsl:text> et al.; </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>UNANTICIPATED SITUATION</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="tei:series"/>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:pubPlace"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:publisher"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
					<xsl:text>) </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/>
					<xsl:text>.</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>UNANTICIPATED TYPE</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		<xsl:text>&#10;\end{hangparas}&#10;</xsl:text>
	</xsl:template>
	<xsl:template match="tei:series">
		<xsl:apply-templates select="tei:title"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="tei:biblScope[@unit='volume']"/>
		<xsl:text>; </xsl:text>
	</xsl:template>

	<oxy:doc><desc>Lists</desc></oxy:doc>
	<xsl:template match="tei:list">
		<xsl:if test="tei:head">
			<xsl:text>&#10;\par\noindent&#10;</xsl:text>
			<xsl:apply-templates select="tei:head"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@rend='numbered'">
				<xsl:text>&#10;\begin{enumerate}</xsl:text>
					<xsl:for-each select="tei:item">
						<xsl:text>&#10;\item </xsl:text>
						<xsl:apply-templates/>
					</xsl:for-each>
				<xsl:text>&#10;\end{enumerate}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&#10;\begin{itemize}</xsl:text>
					<xsl:for-each select="tei:item">
						<xsl:text>&#10;\item </xsl:text>
						<xsl:apply-templates/>
					</xsl:for-each>
				<xsl:text>&#10;\end{itemize}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>Tables</desc></oxy:doc>
	<xsl:template match="tei:table">
		<xsl:text>&#10;\begin{table}[h!]&#10;</xsl:text>
		<xsl:apply-templates select="tei:head"/>
		<xsl:text>\begin{tabulary}{\textwidth}{</xsl:text>
		<xsl:for-each select="tei:row[1]/tei:cell">
			<xsl:text>|L</xsl:text>
		</xsl:for-each>
		<xsl:text>|}&#10;</xsl:text>
		<xsl:apply-templates select="tei:row"/>
		<xsl:text>\hline&#10;</xsl:text>
		<xsl:text>\end{tabulary}&#10;\end{table}&#10;</xsl:text>
	</xsl:template>
	<xsl:template match="tei:table/tei:head">
		<xsl:text>\caption{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}&#10;</xsl:text>
	</xsl:template>
	<xsl:template match="tei:row">
		<xsl:text>\hline&#10;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text> \\&#10;</xsl:text>
	</xsl:template>
	<xsl:template match="tei:cell">
		<xsl:choose>
			<xsl:when test="@role='label' or ../@role='label'">
				<xsl:text>\textbf{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
					<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="following-sibling::tei:cell">
			<xsl:text> &amp; </xsl:text>
		</xsl:if>
	</xsl:template>

	<oxy:doc><desc>Misc</desc></oxy:doc>
	<xsl:template match="tei:lb">
		<xsl:text>\newline&#10;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
