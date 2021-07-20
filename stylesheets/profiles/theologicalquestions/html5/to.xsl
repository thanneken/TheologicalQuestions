<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:oxy="http://www.oxygenxml.com/ns/doc/xsl" 
	exclude-result-prefixes="tei" version="2.0">
	<xsl:import href="../../../html5/html5.xsl"/>
	<oxy:doc scope="stylesheet" type="stylesheet">
		<desc>
			<p>CC BY-NC</p>
			<p>Author: Todd Hanneken</p>
		</desc>
	</oxy:doc>
	<!-- strip space fixes <p> </p> between block quotes; -->
	<!-- may be necessary to use <xsl:preserve-space elements="something"/> in the future -->
	<!-- alternatively, could use xml:space="preserve" in the xml when space is meaningful -->
	<xsl:strip-space elements="*"/>
	<xsl:preserve-space elements="tei:bibl"/>
	<!-- quotation marks are typed in the source, do not add -->
	<xsl:param name="preQuote"/>
	<xsl:param name="postQuote"/>
	<!-- add viewport specification to the html head, otherwise fonts scale inconsistently in Chrome on Android -->
  <xsl:template name="headHook">
		<xsl:element name="meta" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="name">viewport</xsl:attribute>
			<xsl:attribute name="content">width=device-width, initial-scale=1</xsl:attribute>
		</xsl:element>
  </xsl:template>

	<oxy:doc><desc>Cascading Style Sheets</desc></oxy:doc>
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
			.ref::after{content:")";}
			.ref::before{content:"(";}
			.section{clear:right;}
			.toc{padding-inline-start:0.4em;}
			.unit{border-top:3pxsolidblue;margin-top:3em;}
			.vs{color:#747474;font-size:75%;line-height:0;position:relative;vertical-align:baseline;top:-0.5em;padding-right:0.3em;}
			.wide{margin:0;width:6.5in;max-width:100%;}
			span.distinct{font-style:normal;color:maroon;}
			div.l{margin-left:0;}
			div.figurelistitem{clear:left;padding-top:10px;}
			p.bibliography{font-size:85%;}
			@media (orientation:landscape){
				body#TOP.simple{max-width:7in;margin-left:auto;margin-right:auto;}
			}
		</xsl:element>
	</xsl:template>
	<!-- add list of figures and credits to footer -->
	<xsl:template name="stdfooter">
		<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="class">stdfooter</xsl:attribute>
			<xsl:element name="p" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author[1]"/><xsl:text>, </xsl:text>
				<xsl:element name="i" xmlns="http://www.w3.org/1999/xhtml">
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</xsl:element><xsl:text>. </xsl:text>
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/tei:title"/><xsl:text>. </xsl:text>
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace"/><xsl:text>: </xsl:text>
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:distributor"/><xsl:text> </xsl:text>
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/><xsl:text>. </xsl:text>
				<xsl:element name="a" xmlns="http://www.w3.org/1999/xhtml">
					<xsl:attribute name="href">
						<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='uri']"/>
					</xsl:attribute>
					<xsl:text>doi:</xsl:text>
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='doi']"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="h3" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:text>Contributors</xsl:text>
			</xsl:element>
			<xsl:element name="ul" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
					<xsl:element name="li" xmlns="http://www.w3.org/1999/xhtml">
						<xsl:value-of select="."/>
						<xsl:text> (author)</xsl:text>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor">
					<xsl:element name="li" xmlns="http://www.w3.org/1999/xhtml">
						<xsl:value-of select="."/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@role"/>
						<xsl:text>)</xsl:text>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:funder">
					<xsl:element name="li" xmlns="http://www.w3.org/1999/xhtml">
						<xsl:value-of select="."/>
						<xsl:text> (funder)</xsl:text>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
			<xsl:element name="h3" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:text>License</xsl:text>
			</xsl:element>
			<xsl:element name="p" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:element name="a" xmlns="http://www.w3.org/1999/xhtml">
					<xsl:attribute name="href">
						<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/@target"/>
					</xsl:attribute>
					<xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence"/>
				</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:ab/text()"/>
			</xsl:element>
			<xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt/tei:note"/>
		</xsl:element>
	</xsl:template>

	<!-- cause each image to become a link to the full-size version of itself -->
	<xsl:template match="tei:graphic">
			<xsl:element name="a" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:attribute name="href">
					<xsl:value-of select="@url"/>
				</xsl:attribute>
				 <!-- slight modification made to html_figures.xsl to specify only the label, not all of the desc -->
				 <xsl:call-template name="showGraphic"/>
			</xsl:element>
	</xsl:template>
	<!-- allow floating text to have attributes (fixes a bug) --> 
	<xsl:template match="tei:floatingText">
		<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="class">floatingText <xsl:call-template name="makeRendition"/></xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<!-- specify that a floating text head is html h4, not h1 -->
	<xsl:template match="tei:floatingText/tei:body/tei:head">
		<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="class">floatingHead</xsl:attribute>
			<xsl:value-of select="."/>
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
	<xsl:template match="tei:s">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>
	<!-- override elaborate formatting for note -->
	<xsl:template match="tei:note">
		<xsl:apply-templates/>
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
				<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
					<xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
					<!--
					putting the heading in the xml rather than here causes it to be included in the TOC, advantageous or internationalization
					-->
					<xsl:apply-templates select="tei:head"/>
					<xsl:for-each select="//tei:graphic">
						<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
							<xsl:attribute name="class">figurelistitem</xsl:attribute>
							<xsl:element name="img" xmlns="http://www.w3.org/1999/xhtml">
								<xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute>
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
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Unanticipated Scenario in Backmatter</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
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
