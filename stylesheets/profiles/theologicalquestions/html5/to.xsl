<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="tei" version="2.0">
	<xsl:import href="../../../html5/html5.xsl"/>
	<doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
		<desc>
			<p>CC BY-NC</p>
			<p>Author: Todd Hanneken</p>
		</desc>
	</doc>
	<!-- strip space fixes <p> </p> between block quotes; -->
	<!-- may be necessary to use <xsl:preserve-space elements="something"/> in the future -->
	<!-- alternatively, could use xml:space="preserve" in the xml when space is meaningful -->
	<xsl:strip-space elements="*"/>
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
	<!-- add css (tagsDecl is really supposed be descriptive of source, not prescriptive of derivative) -->
	<xsl:template name="cssHook">
		<xsl:element name="style" xmlns="http://www.w3.org/1999/xhtml">
			span.bibl{font-style:normal;}
			.caption{color:darkred;font-style:normal;max-width:100%;}
			.chapter{clear:right;border-top:2pxdottedblue;margin-top:2em;}
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
			.vs{color:gray;font-size:75%;line-height:0;position:relative;vertical-align:baseline;top:-0.5em;padding-right:0.3em;}
			.wide{margin:0;width:6.5in;max-width:100%;}
			span.distinct{font-style:normal;color:maroon;}
		</xsl:element>
	</xsl:template>
	<!-- add credits to footer -->
	<xsl:template name="stdfooter">
		<xsl:element name="div" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="class">stdfooter</xsl:attribute>
			<xsl:element name="h2" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
			</xsl:element>
			<xsl:element name="p" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/tei:title"/>
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
				<xsl:text>Publication</xsl:text>
			</xsl:element>
			<xsl:element name="p" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace"/><xsl:text>: </xsl:text>
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:distributor"/><xsl:text> </xsl:text>
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/><xsl:text>. </xsl:text>
				<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/tei:ref"/><xsl:text> </xsl:text>
				<xsl:element name="a" xmlns="http://www.w3.org/1999/xhtml">
					<xsl:attribute name="href">
						<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='uri']"/>
					</xsl:attribute>
					<xsl:text>doi:</xsl:text>
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='doi']"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="p" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:text>See the TEI  header for complete publication information.</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- cause each image to become a link to the full-size version of itself -->
	<xsl:template match="tei:graphic">
			<xsl:element name="a" xmlns="http://www.w3.org/1999/xhtml">
				<xsl:attribute name="href">
					<xsl:value-of select="@url"/>
				</xsl:attribute>
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
</xsl:stylesheet>
