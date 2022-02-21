<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:oxy="http://www.oxygenxml.com/ns/doc/xsl"
	xsi:schemaLocation="http://www.w3.org/1999/XSL/Transform
										 https://www.w3.org/2007/schema-for-xslt20.xsd
										 http://www.w3.org/1999/XSL/Format
										 https://svn.apache.org/repos/asf/xmlgraphics/fop/trunk/fop/src/foschema/fop.xsd">
	<xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>

	<oxy:doc><desc>abandoned, could be useful later</desc></oxy:doc>
	<!--
	<xsl:strip-space elements="*" />
	<xsl:preserve-space elements="" />
			<fo:block>
			</fo:block>
			<xsl:variable name="i" select="position()"/>
			<xsl:value-of select="$i"/>
			<xsl:with-param name="parentposition" select="9"/>
			https://www.w3.org/TR/1999/REC-xslt-19991116#number
				<xsl:element name="div">
					<xsl:attribute name="class">toc</xsl:attribute>
					<xsl:element name="ol">
						<xsl:for-each select="/tei:TEI/tei:text/tei:body/tei:div/tei:head">
							<xsl:element name="li">
								<xsl:apply-templates/>
								<xsl:element name="ol" type="1.1">
									<xsl:for-each select="../tei:div/tei:head">
										<xsl:element name="li">
											<xsl:apply-templates/>
										</xsl:element>
									</xsl:for-each>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
				<xsl:element name="script">
					<xsl:attribute name="type">text/javascript</xsl:attribute>
					<xsl:text>document.getElementsByClassName("note")[0].innerHTML = document.getElementsByClassName("note")[0].innerHTML.replace(/'”/g , ',”');</xsl:text>
					<xsl:text disable-output-escaping="yes">document.body.innerHTML = document.body.innerHTML.replace(/'”/g , ',”');</xsl:text>
				</xsl:element>
	-->

	<oxy:doc><desc>top level, set up html header, toc, and citation footer</desc></oxy:doc>
	<xsl:template match="/tei:TEI">
		<xsl:element name="html">
			<xsl:attribute name="lang">en</xsl:attribute>
			<xsl:element name="head">
				<xsl:element name="title">
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</xsl:element>
				<xsl:element name="meta">
					<xsl:attribute name="name">Author</xsl:attribute>
					<xsl:attribute name="content">
						<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
					</xsl:attribute>
				</xsl:element>
				<xsl:element name="style">
					<xsl:value-of select="unparsed-text('style.css', 'utf-8')"/>
					<xsl:value-of select="unparsed-text('dark.css', 'utf-8')"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="body">
				<xsl:element name="h1">
					<xsl:attribute name="class">title</xsl:attribute>
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</xsl:element>
				<xsl:element name="p">
					<xsl:attribute name="class">title</xsl:attribute>
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:distributor"/>
				</xsl:element>
				<xsl:element name="div">
					<xsl:attribute name="class">tocbox</xsl:attribute>
					<xsl:element name="p">
						<xsl:text>Table of Contents</xsl:text>
					</xsl:element>
					<xsl:for-each select="/tei:TEI/tei:text/tei:body//tei:div/tei:head">
						<xsl:element name="p">
							<xsl:attribute name="class">
								<xsl:text>tocl</xsl:text>
								<xsl:value-of select="count(ancestor::tei:div)"/>
							</xsl:attribute>
							<xsl:number level="multiple" from="tei:body" count="tei:div" format="1.1. "/>
							<xsl:element name="a">
								<xsl:attribute name="class">toclink</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#div</xsl:text>
									<xsl:number level="multiple" from="tei:body" count="tei:div" format="1-1"/>
								</xsl:attribute>
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
					<xsl:for-each select="/tei:TEI/tei:text/tei:back//tei:div/tei:head">
						<xsl:element name="p">
							<xsl:attribute name="class">
								<xsl:text>tocl</xsl:text>
								<xsl:value-of select="count(ancestor::tei:div)"/>
							</xsl:attribute>
							<xsl:number level="multiple" from="tei:back" count="tei:div" format="Appendix A.1. "/>
							<xsl:element name="a">
								<xsl:attribute name="class">toclink</xsl:attribute>
								<xsl:attribute name="href">
									<xsl:text>#appendix</xsl:text>
									<xsl:number level="multiple" from="tei:back" count="tei:div" format="A-1"/>
								</xsl:attribute>
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
				<xsl:apply-templates select="/tei:TEI/tei:text/tei:body"/>
				<xsl:apply-templates select="/tei:TEI/tei:text/tei:back"/>
				<xsl:element name="hr"/>
				<xsl:element name="p">
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
					<xsl:text>, “</xsl:text>
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
					<xsl:text>.” </xsl:text>
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:distributor"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/>
					<xsl:text>.</xsl:text>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<oxy:doc><desc>divs take class from type, id automatically generated</desc></oxy:doc>
	<xsl:template match="tei:div">
		<xsl:element name="div">
			<xsl:if test="@type">
				<xsl:attribute name="class">
					<xsl:value-of select="@type"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="id">
				<xsl:choose>
					<xsl:when test="ancestor::tei:body">
						<xsl:text>div</xsl:text>
						<xsl:number level="multiple" from="tei:body" count="tei:div" format="1-1"/>
					</xsl:when>
					<xsl:when test="ancestor::tei:back">
						<xsl:text>appendix</xsl:text>
						<xsl:number level="multiple" from="tei:back" count="tei:div" format="A-1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>UNANTICIPATED</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<oxy:doc><desc>Paragraphs: indented if following another paragraph, notes follow paragraph</desc></oxy:doc>
	<xsl:template match="tei:p">
		<xsl:element name="p">
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
				</xsl:when>
				<xsl:when test="preceding-sibling::tei:p or preceding-sibling::tei:list">
					<xsl:attribute name="class">firstindent</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<!-- would be good to make room for declared rend. The TEIC stylesheets certainly illustrate a good way to do this -->
			<xsl:apply-templates/>
		</xsl:element>
		<xsl:if test=".//tei:note">
			<xsl:element name="div">
				<xsl:attribute name="class">noteblock</xsl:attribute>
				<xsl:element name="hr">
					<xsl:attribute name="class">note</xsl:attribute>
				</xsl:element>
				<xsl:for-each select=".//tei:note">
					<xsl:for-each select="tei:p">
						<xsl:element name="p">
							<xsl:attribute name="class">note</xsl:attribute>
							<xsl:if test="position() = 1">
								<xsl:element name="sup">
									<xsl:number level="any" from="tei:body" count="tei:note" format="1 "/>
								</xsl:element>
							</xsl:if>
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<oxy:doc><desc>Notes numbered from beginning of body</desc></oxy:doc>
	<xsl:template match="tei:note">
		<xsl:element name="sup">
			<xsl:number level="any" from="tei:body" count="tei:note" format="1"/>
		</xsl:element>
	</xsl:template>

	<oxy:doc><desc>Heading levels numbered, derived from depth in divs</desc></oxy:doc>
	<xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:head">
		<xsl:element name="h2">
			<xsl:number level="single" from="/tei:TEI/tei:text/tei:body" count="tei:div" format="1. "/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:head">
		<xsl:element name="h3">
			<xsl:number level="multiple" from="tei:body" count="tei:div|tei:div" format="1.1. "/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="/tei:TEI/tei:text/tei:body/tei:div/tei:div/tei:div/tei:head">
		<xsl:element name="h4">
			<xsl:number level="multiple" from="tei:body" count="tei:div|tei:div|tei:div" format="1.1. "/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="/tei:TEI/tei:text/tei:back/tei:div/tei:head">
		<xsl:element name="h2">
			<xsl:text>Appendix </xsl:text>
			<xsl:number level="single" from="/tei:TEI/tei:text/tei:back" count="tei:div" format="A.1. "/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<oxy:doc><desc>foreign for Greek, Hebrew, and other</desc></oxy:doc>
	<xsl:template match="tei:foreign">
		<xsl:choose>
			<xsl:when test="@xml:lang='el'">
				<xsl:element name="span">
					<xsl:attribute name="class">greek</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>	
			<xsl:when test="@xml:lang='he'">
				<xsl:element name="span">
					<xsl:attribute name="class">hebrew</xsl:attribute>
					<xsl:text disable-output-escaping="yes">&amp;rlm;</xsl:text>
						<xsl:value-of select="normalize-space()"/>
					<xsl:text disable-output-escaping="yes">&amp;lrm;</xsl:text>
				</xsl:element>
			</xsl:when>	
			<xsl:otherwise>
				<xsl:element name="i">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>hi uses class from rend unless unspecified, then default defined in css as bold</desc></oxy:doc>
	<xsl:template match="tei:hi">
		<xsl:element name="span">
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">
						<xsl:text>defaultHi</xsl:text>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<oxy:doc><desc>Italicize title in the context of a bibl</desc></oxy:doc>
	<xsl:template match="tei:title">
		<xsl:choose>
			<xsl:when test="@level='m' or @level='j' or parent::tei:bibl or ../tei:title[@level='m']">
				<xsl:element name="i">
					<xsl:apply-templates/>
				</xsl:element>
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
				<xsl:element name="span">
					<xsl:attribute name="class"><xsl:text>ref</xsl:text></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:cit/tei:quote">
		<!-- this is adding extra p tags between consecutive quote elements, not terrible -->
		<xsl:if test="../../self::tei:p">
			<xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
		</xsl:if>
		<xsl:element name="blockquote">
			<xsl:if test="@rend">
				<xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:if test="following-sibling::*[1] = following-sibling::tei:ref">
				<xsl:value-of select="following-sibling::tei:ref"/>
			</xsl:if>
		</xsl:element>
		<xsl:if test="../../self::tei:p">
			<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
		</xsl:if>
	</xsl:template>

	<oxy:doc><desc>Figures and Graphics</desc></oxy:doc>
	<xsl:template match="tei:figure">
		<xsl:if test="../self::tei:p">
			<xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
		</xsl:if>
		<xsl:element name="figure">
			<xsl:apply-templates select="tei:graphic | tei:head"/>
		</xsl:element>
		<xsl:if test="../self::tei:p">
			<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:figure/tei:graphic">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="../tei:head">
						<xsl:attribute name="alt"><xsl:value-of select="../tei:head"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="tei:desc/tei:label">
						<xsl:attribute name="alt"><xsl:value-of select="tei:desc/tei:label"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="tei:desc">
						<xsl:attribute name="alt"><xsl:value-of select="tei:desc"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="alt">No alt text available for this image</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:attribute name="style"><xsl:text>max-width:</xsl:text><xsl:value-of select="@width"/><xsl:text>;</xsl:text></xsl:attribute>
			</xsl:element>
	</xsl:template>
	<xsl:template match="tei:figure/tei:head">
		<xsl:element name="figcaption">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<oxy:doc><desc>ref@target to a@href (function replace that works in saxon seems not to work in xmlstarlet or chrome, so risk long urls or put optional word breaks into xml)</desc></oxy:doc>
	<xsl:template match="tei:ref[@target]">
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<oxy:doc><desc>PTR can be an external url or an internal reference to bibliography</desc></oxy:doc>
	<xsl:template match="tei:ptr[@target]">
		<xsl:choose>
			<!-- this is going to break non-saxon transformation -->
			<xsl:when test="contains(substring(@target,1,4),'http')">
				<!-- ptr is an external url -->
				<xsl:element name="a">
					<xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
					<xsl:value-of disable-output-escaping="yes" select="replace(@target,'([A-z]|[0-9])([/_])','$1&#8203;$2')"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="contains(substring(@target,1,1),'#')">
				<!-- ptr is an internal reference -->
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
				<xsl:choose>
					<xsl:when test="@n">
						<xsl:text>,</xsl:text>
							<xsl:for-each select="id(substring-after(@target,'#'))">
								<xsl:if test="tei:analytic">
									<xsl:text>”</xsl:text>
								</xsl:if>
							</xsl:for-each>
						<xsl:text> </xsl:text>
						<xsl:value-of select="@n"/>
						<xsl:choose>
							<xsl:when test="@rend='final'">
								<xsl:text>.</xsl:text>
							</xsl:when>
							<xsl:when test="@rend='nonfinal'">
								<xsl:text>;</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="@rend='final'">
								<xsl:text>.</xsl:text>
							</xsl:when>
							<xsl:when test="@rend='nonfinal'">
								<xsl:text>;</xsl:text>
							</xsl:when>
						</xsl:choose>
							<xsl:for-each select="id(substring-after(@target,'#'))">
								<xsl:if test="tei:analytic">
									<xsl:text>”</xsl:text>
								</xsl:if>
							</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>UNANTICIPATED SITUATION</xsl:text> 
			</xsl:otherwise> 
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>Backmatter</desc></oxy:doc>
	<xsl:template match="tei:back">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:listBibl">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:biblStruct">
		<xsl:element name="p">
			<xsl:attribute name="class"><xsl:text>bibliography</xsl:text></xsl:attribute>
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
					<!-- might want to distinguish journal title abbreviations here -->
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
		</xsl:element>
	</xsl:template>
	<xsl:template match="tei:series">
		<xsl:apply-templates select="tei:title"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="tei:biblScope[@unit='volume']"/>
		<xsl:text>; </xsl:text>
	</xsl:template>

	<oxy:doc><desc>Verse milestones</desc></oxy:doc>
	<xsl:template match="tei:milestone">
		<xsl:if test="@unit='vs'">
			<xsl:element name="span">
				<xsl:attribute name="class">vs</xsl:attribute>
				<xsl:value-of select="@n"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<oxy:doc><desc>Lists</desc></oxy:doc>
	<xsl:template match="tei:list">
		<xsl:if test="tei:head">
			<xsl:element name="p">
				<xsl:attribute name="class">listhead</xsl:attribute>
				<xsl:apply-templates select="tei:head"/>
			</xsl:element>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@rend='numbered'">
				<xsl:element name="ol">
					<xsl:for-each select="tei:item">
						<xsl:element name="li">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="ul">
					<xsl:for-each select="tei:item">
						<xsl:element name="li">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>Tables</desc></oxy:doc>
	<xsl:template match="tei:table">
		<xsl:element name="table">
			<xsl:if test="@xml:id">
				<xsl:attribute name="id">
					<xsl:value-of select="@xml:id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rend">
				<xsl:attribute name="class">
					<xsl:value-of select="@rend"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="tei:table/tei:head">
		<xsl:element name="caption">
			<xsl:attribute name="class">tablehead</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="tei:row">
		<xsl:element name="tr">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="tei:cell">
		<xsl:choose>
			<xsl:when test="@role='label' or ../@role='label'">
				<xsl:element name="th">
					<xsl:if test="@rend">
						<xsl:attribute name="class">
							<xsl:value-of select="@rend"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="td">
					<xsl:if test="@rend">
						<xsl:attribute name="class">
							<xsl:value-of select="@rend"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<oxy:doc><desc>Misc</desc></oxy:doc>
	<xsl:template match="tei:lb">
		<xsl:element name="br"/>
	</xsl:template>
</xsl:stylesheet>

