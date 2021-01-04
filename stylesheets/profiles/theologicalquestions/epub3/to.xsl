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
			.cit{padding-left:3em;padding-bottom:0.3em;}
			div.citquote{margin-left:0;margin-right:0;}
			.doubleunderline{text-decoration:underline;text-decoration-style:double;}
			.float{float:right;clear:right;max-width:3in;}
			.floatingHead{margin:0;}
			.floatingText{padding:0.5em;color:darkblue;}
			.graphic{width:100%;}
			.hi{font-weight:bold;font-style:normal;}
			.maintitle{text-align:center;}
			.notitalic{font-style:normal;}
			.ref::after{content:")";}
			.ref::before{content:"(";}
			.section{clear:right;}
			.toc{padding-inline-start:0.4em;}
			.vs{color:gray;font-size:75%;line-height:0;position:relative;vertical-align:baseline;top:-0.5em;}
			.wide{margin:0;width:6.5in;max-width:100%;}
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
	<xsl:template match="tei:floatingText/tei:body/tei:head">
		<xsl:element name="h4" xmlns="http://www.w3.org/1999/xhtml">
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
</xsl:stylesheet>
