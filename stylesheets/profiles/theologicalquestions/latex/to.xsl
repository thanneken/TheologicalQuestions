<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="tei" version="2.0">
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
		<desc>
			<p>CC BY-NC</p>
			<p>Author: Todd Hanneken</p>
		</desc>
	</doc>
	<xsl:import href="../../../latex/latex.xsl"/>
	<!-- set parameters welcomed by teic stylesheets -->
	<xsl:param name="preQuote"/>
	<xsl:param name="postQuote"/>
	<xsl:param name="captionInlineFigures">true</xsl:param>
	<xsl:param name="showFloatHead">true</xsl:param>
	<xsl:param name="showFloatLabel">true</xsl:param>
	<xsl:param name="latexPaperSize">letterpaper</xsl:param>
	<xsl:param name="classParameters">11pt,twoside</xsl:param>
	<!-- add definitions to latex header -->
	<xsl:template name="latexPreambleHook">
		\definecolor{darkblue}{RGB}{0,0,128} 
		\definecolor{darkred}{RGB}{128,0,0}
		\renewcommand\fbox{\fcolorbox{darkblue}{white}}
		\renewcommand{\baselinestretch}{1.2}
		\setromanfont{DejaVuSerif}
		\setsansfont{DejaVuSans}
		\newfontfamily\HebrewFont{SBL BibLit}
		\usepackage{setspace}
	</xsl:template>
	<!-- front matter --> 
	<xsl:template name="printTitleAndLogo"> 
		<!--
		-->
		<xsl:text>&#10;\topskip0pt &#10;\vspace*{\fill}&#10;\begin{minipage}{\textwidth}&#10;\begin{center}&#10;\begin{spacing}{2.2}</xsl:text>
		<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
			<xsl:text>&#10;\par{</xsl:text><xsl:value-of select="."/><xsl:text> (author)}</xsl:text>
		</xsl:for-each>
		<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
			<xsl:text>&#10;\par{</xsl:text><xsl:value-of select="."/><xsl:text> (</xsl:text><xsl:value-of select="@role"/><xsl:text>)}</xsl:text>
		</xsl:for-each>
		<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:funder">
			<xsl:text>&#10;\par{</xsl:text><xsl:value-of select="."/><xsl:text> (funder)}</xsl:text>
		</xsl:for-each>
		<xsl:text>&#10;\vskip20pt</xsl:text>
		<xsl:text>&#10;\makeatletter</xsl:text>
		<xsl:text>&#10;\par{\fontsize{24pt}{24pt}\bfseries \@title}</xsl:text>
		<xsl:text>&#10;\makeatother </xsl:text>
		<xsl:text>&#10;\vspace{18pt} </xsl:text>
		<xsl:text>&#10;\par{</xsl:text><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/tei:title"/><xsl:text>} </xsl:text>
		<xsl:text>&#10;\par{</xsl:text><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace"/><xsl:text>} </xsl:text>
		<xsl:text>&#10;\par{</xsl:text><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:distributor"/><xsl:text>} </xsl:text>
		<xsl:text>&#10;\par{\TheDate}</xsl:text>
		<xsl:text>&#10;\par{</xsl:text><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/tei:ref"/><xsl:text>} </xsl:text>
		<xsl:text>&#10;\par{</xsl:text><xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno/tei:ptr"/><xsl:text>} </xsl:text>
		<xsl:text>&#10;\vspace{90pt} &#10;\end{spacing} &#10;\end{center} &#10;\end{minipage} &#10;\vfill </xsl:text>
	</xsl:template>
	<!-- not in use, see front matter -->
	<xsl:template name="beginDocumentHook">
	</xsl:template>
	<!-- don't need to print top level head in addition to front matter -->
	<xsl:template match="/tei:TEI/tei:text/tei:body/tei:head"/>
	<!-- only title italicized in bibl -->
	<xsl:template match="tei:bibl">
		<xsl:text>\textup{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
	</xsl:template>
	<!-- foreign -->
	<xsl:template match="tei:foreign">
		<xsl:choose>
			<xsl:when test="tei:match(@lang,'xml:he')">
				<xsl:text>\textup{\HebrewFont </xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:when test="tei:match(@rend,'notitalic') or tei:match(@lang,'xml:el')">
				<xsl:text>\textup{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- if highlight rendering is not specified it should be bold -->
  <xsl:template match="tei:hi[not(@rend)]">
		<xsl:text>\textbf{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
  </xsl:template>
	<!-- format vs milestones as biblicists expect -->
	<xsl:template match="tei:milestone">
		<xsl:if test="@unit='vs'">
			<xsl:text>\textsuperscript{\textcolor{gray}{</xsl:text><xsl:value-of select="@n"/><xsl:text>}}</xsl:text>
		</xsl:if>
	</xsl:template>
	<!-- clearpage with every unit chapter that is not the first in the unit -->
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
	<!-- format floating texts  -->
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
	<!-- figure head is smaller than body text first heading -->
	<xsl:template match="tei:floatingText/tei:body/tei:head">
		<xsl:text>&#10;&#10;\par\textbf{</xsl:text><xsl:apply-templates/><xsl:text>}&#10;&#10;</xsl:text>
	</xsl:template>
	<!-- Redefine default figure to distinguish narrow as floating right, 3 inches wide, dark red, sans -->
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"> <desc>Adapted [latex] Make figure (start)</desc> </doc>
	<xsl:template name="makeFigureStart">
		<xsl:choose>
			<xsl:when test="@place='inline' and tei:head">
				<xsl:text>\begin{figure}[H]&#10;</xsl:text>
			</xsl:when>
			<xsl:when test="tei:match(@rend,'display') or not(@place='inline') or tei:head or tei:p">
				<xsl:choose>
					<!-- can't wrap a list around a figure; if there's no difference between scenario 1 and 3 they can be consolidated -->
					<xsl:when test="parent::tei:item">
						<xsl:text>&#10;\begin{figure}[h!tp]&#10;\begin{center} &#10;\color{darkred}&#10;\sffamily&#10;</xsl:text>
					</xsl:when>
					<xsl:when test="tei:match(@rend,'float')">
						<xsl:text>&#10;\begin{wrapfigure}{R}{</xsl:text><xsl:value-of select="./tei:graphic/@width"/><xsl:text>}&#10;\color{darkred}&#10;\sffamily&#10;</xsl:text> 
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#10;\begin{figure}[h!tp]&#10;\begin{center} &#10;\color{darkred}&#10;\sffamily&#10;</xsl:text>
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
	<!-- small adjustment to wrap text around figures -->
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"> <desc>Adapted [latex] Make figure (end)</desc> </doc>
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
	<!-- all this just to adjust footer -->
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
	<!-- templates related to block quotations -->
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
	<xsl:template match="tei:ref">
		<xsl:text> (</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
	</xsl:template>
	<xsl:template match="tei:p[@type='continuation']">
		<xsl:text>&#10;\noindent&#10;</xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:s">
		<xsl:apply-templates/><xsl:text> </xsl:text>
	</xsl:template>
</xsl:stylesheet>

