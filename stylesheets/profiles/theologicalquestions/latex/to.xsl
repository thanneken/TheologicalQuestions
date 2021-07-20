<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:oxy="http://www.oxygenxml.com/ns/doc/xsl" 
	exclude-result-prefixes="tei" version="2.0">
	<oxy:doc scope="stylesheet" type="stylesheet"><desc>CC BY-NC Author: Todd Hanneken</desc></oxy:doc>
	<xsl:import href="../../../latex/latex.xsl"/>

	<oxy:doc><desc>set parameters welcomed by teic stylesheets</desc></oxy:doc>
	<xsl:param name="preQuote"/>
	<xsl:param name="postQuote"/>
	<xsl:param name="captionInlineFigures">true</xsl:param>
	<xsl:param name="showFloatHead">true</xsl:param>
	<xsl:param name="showFloatLabel">true</xsl:param>
	<xsl:param name="latexPaperSize">letterpaper</xsl:param>
	<xsl:param name="classParameters">11pt,twoside</xsl:param>
	<xsl:param name="romanFont">DejaVu Serif</xsl:param>
	<xsl:param name="sansFont">DejaVu Sans</xsl:param>

	<oxy:doc><desc>add definitions to latex header</desc></oxy:doc>
	<xsl:template name="latexPreambleHook">
		\definecolor{darkblue}{RGB}{0,0,128} 
		\definecolor{darkred}{RGB}{128,0,0}
		\usepackage{fontspec}
		\usepackage{setspace}
		\usepackage{float}
		\usepackage{wrapfig}
		\usepackage[rightcaption]{sidecap}
		\renewcommand\fbox{\fcolorbox{darkblue}{white}}
		\renewcommand{\baselinestretch}{1.2}
		\newfontfamily\hebrewfont{SBL BibLit}
		\usepackage{hyperref}
		\hypersetup{
			pdftitle={<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>},
			pdfauthor={<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>},
			breaklinks=TRUE}
		\usepackage{array}
		\usepackage{tabularx}
	</xsl:template>

	<oxy:doc><desc>front matter</desc></oxy:doc>
	<xsl:template name="printTitleAndLogo"> 
		<xsl:text>&#10;\topskip0pt &#10;\vspace*{\fill}&#10;\begin{minipage}{\textwidth}&#10;\begin{center}&#10;\begin{spacing}{2.0}</xsl:text>
		<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
			<xsl:text>&#10;\noindent\par{</xsl:text><xsl:value-of select="."/><xsl:text> (author)}</xsl:text>
		</xsl:for-each>
		<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
			<xsl:text>&#10;\noindent\par{</xsl:text><xsl:value-of select="."/><xsl:text> (</xsl:text><xsl:value-of select="@role"/><xsl:text>)}</xsl:text>
		</xsl:for-each>
		<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:funder">
			<xsl:text>&#10;\noindent\par{</xsl:text><xsl:value-of select="."/><xsl:text> (funder)}</xsl:text>
		</xsl:for-each>
		<xsl:text>&#10;\vskip20pt</xsl:text>
		<xsl:text>&#10;\makeatletter</xsl:text>
		<xsl:text>&#10;\noindent\par{\fontsize{24pt}{24pt}\bfseries \@title}</xsl:text>
		<xsl:text>&#10;\makeatother </xsl:text>
		<xsl:text>&#10;\vspace{18pt} </xsl:text>
		<xsl:text>&#10;\noindent\par{</xsl:text><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/tei:title"/><xsl:text>} </xsl:text>
		<xsl:text>&#10;\noindent\par{</xsl:text><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:distributor"/><xsl:text>} </xsl:text>
		<xsl:text>&#10;\noindent\par{</xsl:text><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace"/><xsl:text>} </xsl:text>
		<xsl:text>&#10;\noindent\par{\TheDate}</xsl:text>
		<xsl:text>&#10;\noindent\par{doi: \href{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='uri']"/>
		<xsl:text>}{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='doi']"/>
		<xsl:text>}} </xsl:text>
		<xsl:text>&#10;\noindent\par{\href{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/@target"/>
		<xsl:text>}{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/text()"/>
		<xsl:text>} </xsl:text>
		<xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:ab"/>
		<xsl:text>}</xsl:text>
		<xsl:text>&#10;\noindent\par{</xsl:text><xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt/tei:note"/><xsl:text>} </xsl:text>
		<xsl:text>&#10;\vspace{90pt} &#10;\end{spacing} &#10;\end{center} &#10;\end{minipage} &#10;\vfill </xsl:text>
	</xsl:template>

	<oxy:doc><desc>don't need to print top level head in addition to front matter</desc></oxy:doc>
	<xsl:template match="/tei:TEI/tei:text/tei:body/tei:head"/>

	<oxy:doc><desc>only title italicized in bibl</desc></oxy:doc>
	<xsl:template match="tei:bibl">
		<xsl:text>\textup{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="tei:title[@rend='italic']">
		<xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
	</xsl:template>

	<oxy:doc><desc>Foreign</desc></oxy:doc>
	<xsl:template match="tei:foreign">
		<xsl:choose>
			<xsl:when test="tei:match(@rend,'notitalic') or tei:match(@xml:lang,'el')">
				<xsl:text>\textup{</xsl:text>
				<xsl:if test="tei:match(@xml:lang,'he')">
					<xsl:text>\hebrewfont </xsl:text>
				</xsl:if>
				<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>if highlight rendering is not specified it should be bold</desc></oxy:doc>
  <xsl:template match="tei:hi[not(@rend)]">
		<xsl:text>\textbf{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>

	<oxy:doc><desc>format vs milestones as biblicists expect</desc></oxy:doc>
	<xsl:template match="tei:milestone">
		<xsl:if test="@unit='vs'">
			<xsl:text>\textsuperscript{\textcolor{gray}{</xsl:text><xsl:value-of select="@n"/><xsl:text>}}</xsl:text>
		</xsl:if>
	</xsl:template>

	<oxy:doc><desc>clearpage with every unit chapter that is not the first in the unit</desc></oxy:doc>
	<xsl:template match="tei:div">
		<xsl:choose>
			<xsl:when test="tei:match(@type,'unit')">
				<xsl:text>\clearpage</xsl:text>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="tei:match(@type,'chapter') and not(@n=1)">
				<xsl:text>\clearpage</xsl:text>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>format floating texts</desc></oxy:doc>
	<xsl:template match="tei:floatingText">
		<xsl:choose>
			<xsl:when test="tei:match(@rend,'float')">
				&#10;&#10;\begin{wrapfigure}{R}{3in}
					\fbox{
						\begin{minipage}{3in}
						\color{darkblue}
						\sffamily
						<xsl:apply-templates/>
						\end{minipage}
					}
				\end{wrapfigure}
			</xsl:when>
			<xsl:otherwise>
				&#10;&#10;\fbox{
					\begin{minipage}{\textwidth}
						\color{darkblue}
						\sffamily
						<xsl:apply-templates/>
					\end{minipage}
				}
				\vskip6pt
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>floatingText head is smaller than body text first heading</desc></oxy:doc>
	<xsl:template match="tei:floatingText/tei:body/tei:head">
		<xsl:text>&#10;&#10;\par\textbf{</xsl:text><xsl:apply-templates/><xsl:text>}&#10;&#10;</xsl:text>
	</xsl:template>

	<oxy:doc><desc>figure head is smaller than body text first heading</desc></oxy:doc>
	<xsl:template match="tei:figure/tei:head">
		<xsl:text>&#10;&#10;\vspace{-10pt}&#10;\par&#10;</xsl:text>
	</xsl:template>

	<oxy:doc><desc>Adapted [latex] Make figure (start)
		Redefine default figure to distinguish narrow as floating right, 3 inches wide, dark red, sans</desc></oxy:doc>
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"> <desc>
	</desc> </doc>
	<xsl:template name="makeFigureStart">
		<xsl:choose>
			<xsl:when test="@place='inline' and tei:head">
				<xsl:text>\begin{figure}[H]&#10;</xsl:text>
			</xsl:when>
			<xsl:when test="tei:match(@rend,'display') or not(@place='inline') or tei:head or tei:p">
				<xsl:choose>
					<!-- can't wrap a list around a figure; if there's no difference between scenario 1 and 3 they can be consolidated -->
					<xsl:when test="parent::tei:item or tei:match(@rend,'wide')">
						<xsl:text>&#10;\begin{figure}[h!tp]&#10;\begin{center} &#10;\color{darkred}&#10;\sffamily&#10;</xsl:text>
					</xsl:when>
					<xsl:when test="tei:match(@rend,'float')">
						<xsl:text>&#10;\begin{wrapfigure}{R}{</xsl:text><xsl:value-of select="./tei:graphic/@width"/><xsl:text>}&#10;\color{darkred}&#10;\sffamily&#10;</xsl:text> 
					</xsl:when>
					<xsl:otherwise>
						<!-- new 20210511 H (in place of h!tp) with usepackage{float} fixes error with Books theologians read -->
						<xsl:text>&#10;\begin{figure}[H]&#10;\begin{center} &#10;\color{darkred}&#10;\sffamily&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="tei:match(@rend,'center')">
				<xsl:text>\begin{center}</xsl:text>
			</xsl:when>
			<xsl:otherwise>\noindent</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>Adapted [latex] Make figure (end)-small adjustment to wrap text around figures</desc></oxy:doc>
	<xsl:template name="makeFigureEnd">
		<xsl:choose>
			<xsl:when test="tei:head or tei:p">
				<xsl:text>&#10;\caption{ </xsl:text>
				<xsl:sequence select="tei:makeHyperTarget(@xml:id)"/>
				<xsl:for-each select="tei:head">
					<xsl:apply-templates/>
				</xsl:for-each>
				<xsl:text>}</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="tei:match(@rend,'center')">
			<xsl:text>\end{center}</xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@place='inline' and tei:head">
				<xsl:text>\end{figure}&#10;</xsl:text>
			</xsl:when>
			<xsl:when test="tei:match(@rend,'display') or not(@place='inline')">
				<xsl:choose>
					<xsl:when test="parent::tei:item">
						<xsl:text>&#10;\end{center} &#10;\color{black}&#10;\end{figure}&#10;</xsl:text>
					</xsl:when>
					<xsl:when test="tei:match(@rend,'float')">
						<xsl:text>&#10;\color{black}&#10;\end{wrapfigure}&#10;</xsl:text> 
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#10;\end{center} &#10;\color{black}&#10;\end{figure}&#10;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>all this just to adjust footer</desc></oxy:doc>
   <xsl:template name="latexBegin">
      <xsl:text>
				\makeatletter
				\newcommand*{\cleartoleftpage}{%
					\clearpage
						\if@twoside
						\ifodd\c@page
							\hbox{}\newpage
							\if@twocolumn
								\hbox{}\newpage
							\fi
						\fi
					\fi
				}
				\makeatother
				\makeatletter
				\thispagestyle{empty}
				\markright{\@title}\markboth{\@title}{\@author}
				\renewcommand\small{\@setfontsize\small{9pt}{11pt}\abovedisplayskip 8.5\p@ plus3\p@ minus4\p@
				\belowdisplayskip \abovedisplayskip
				\abovedisplayshortskip \z@ plus2\p@
				\belowdisplayshortskip 4\p@ plus2\p@ minus2\p@
				\def\@listi{\leftmargin\leftmargini
											 \topsep 2\p@ plus1\p@ minus1\p@
											 \parsep 2\p@ plus\p@ minus\p@
											 \itemsep 1pt}
				}
				\makeatother
				\fvset{frame=single,numberblanklines=false,xleftmargin=5mm,xrightmargin=5mm}
				\fancyhf{} 
				\setlength{\headheight}{14pt}
				\fancyhead[LE]{\bfseries\leftmark} 
				\fancyhead[RO]{\bfseries\rightmark} 
				\fancyfoot[RO]{}
				\fancyfoot[CO]{\thepage}
				\fancyfoot[LO]{}
				\fancyfoot[LE]{}
				\fancyfoot[CE]{\thepage}
				\fancyfoot[RE]{}
				\hypersetup{</xsl:text><xsl:value-of select="$hyperSetup"/><xsl:text>}
				\fancypagestyle{plain}{\fancyhead{}\renewcommand{\headrulewidth}{0pt}}
		</xsl:text>
	</xsl:template>

	<oxy:doc><desc>templates related to block quotations</desc></oxy:doc>
	<xsl:template match="tei:div/tei:quote">
		<xsl:text>&#10;\begin{quote}&#10;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;\end{quote}&#10;</xsl:text>
	</xsl:template>
	<xsl:template match="tei:cit">
		<xsl:choose>
			<xsl:when test="tei:quote">
				<xsl:text>&#10;\begin{quote}&#10;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>&#10;\end{quote}&#10;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  <xsl:template match="tei:ref[not(@target)]">
		<xsl:text> (</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
	</xsl:template>
	<xsl:template match="tei:s">
		<xsl:apply-templates/><xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="tei:ptr">
		<xsl:text>&lt;</xsl:text>
		<xsl:text>\url{</xsl:text>
		<xsl:value-of select="tei:escapeChars(normalize-space(@target),@target)"/>
		<xsl:text>}</xsl:text>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

  <oxy:doc class="numbering"><desc>[common] How to number sections in back matter</desc></oxy:doc>
  <xsl:template name="numberBackDiv">
    <xsl:if test="not($numberBackHeadings='')">
      <xsl:number count="tei:div" format="A.1.1.1.1.1:" level="multiple"/>
    </xsl:if>
  </xsl:template>

	<oxy:doc><desc>Backmatter</desc></oxy:doc>
	<!--
		special characters are % $ {} _ & <>
	-->
	<xsl:template match="tei:back/tei:div">
		<xsl:choose>
			<xsl:when test="@xml:id='listfigures'">
				<xsl:apply-templates select="tei:head"/>
				<xsl:for-each select="//tei:graphic">

					<!--
					<xsl:text>\noindent\par{</xsl:text>
					<xsl:text>&#10;\includegraphics[width=1in]{</xsl:text>
					<xsl:value-of select="@url"/>
					<xsl:text>}</xsl:text>
					<xsl:for-each select="tei:desc/tei:label">
						<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
					</xsl:for-each>
					<xsl:if test="tei:desc/tei:label and ../tei:head">
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:for-each select="../tei:head">
						<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
					</xsl:for-each>
					<xsl:text>}\noindent\par\small{</xsl:text>
						<xsl:apply-templates select="tei:desc/tei:bibl"/>
					<xsl:text>}&#10;</xsl:text>
					-->

					<!--
					<xsl:text>&#10;\begin{wrapfigure}{l}{1in}\fbox{\begin{minipage}{1in}&#10;</xsl:text>
					<xsl:text>&#10;\includegraphics[width=1in]{</xsl:text>
					<xsl:value-of select="@url"/>
					<xsl:text>}</xsl:text>
					<xsl:text>\end{minipage}}&#10;\end{wrapfigure}&#10;</xsl:text>
					<xsl:text>\noindent\par{</xsl:text>
					<xsl:for-each select="tei:desc/tei:label">
						<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
					</xsl:for-each>
					<xsl:if test="tei:desc/tei:label and ../tei:head">
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:for-each select="../tei:head">
						<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
					</xsl:for-each>
					<xsl:text>}\noindent\par\small{</xsl:text>
						<xsl:apply-templates select="tei:desc/tei:bibl"/>
					<xsl:text>}&#10;</xsl:text>
					-->

					<xsl:text>&#10;\noindent\begin{tabularx}{\textwidth}{p{0.15\textwidth} p{0.85\textwidth}}&#10;</xsl:text>
					<xsl:text>&#10;\begin{minipage}{1in}\includegraphics[width=1in]{</xsl:text>
					<xsl:value-of select="@url"/>
					<xsl:text>}\end{minipage} &amp; \begin{minipage}{5in}&#10;</xsl:text>
					<xsl:for-each select="tei:desc/tei:label">
						<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
					</xsl:for-each>
					<xsl:if test="tei:desc/tei:label and ../tei:head">
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:for-each select="../tei:head">
						<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
					</xsl:for-each>
					<xsl:text> \noindent\par\small{</xsl:text>
						<xsl:apply-templates select="tei:desc/tei:bibl"/>
					<xsl:text>}\end{minipage}\\&#10;\end{tabularx}&#10;</xsl:text>
					<xsl:text>&#10;\vspace{18pt} </xsl:text>
					<!--
					-->
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Unanticipated Scenario in Backmatter</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>Format bibliography, particularly in list of figures</desc></oxy:doc>
	<xsl:template match="tei:bibl/tei:author">
		<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
		<xsl:text>, </xsl:text>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:title">
		<xsl:text>\textit{</xsl:text>
			<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
		<xsl:text>}</xsl:text>
		<xsl:if test="not(..[@rend='inline'])">
			<xsl:text>. </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:pubPlace">
		<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
		<xsl:if test="following-sibling::*[1] = following-sibling::tei:distributor">
			<xsl:text>: </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:distributor">
		<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
		<xsl:if test="following-sibling::*[1] = following-sibling::tei:date">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:date">
		<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
		<xsl:text>. </xsl:text>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:availability/tei:ab">
		<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
		<xsl:text>. </xsl:text>
	</xsl:template>
	<xsl:template match="tei:bibl/tei:availability/tei:licence">
		<xsl:text>\href{</xsl:text>
		<xsl:value-of select="tei:escapeChars(normalize-space(@target),@target)"/>
		<xsl:text>}{</xsl:text>
		<xsl:value-of select="tei:escapeChars(normalize-space(.),.)"/>
		<xsl:text>}. </xsl:text>
	</xsl:template>
</xsl:stylesheet>

