<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:srw_dc="http://purl.org/dc/elements/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcx="http://krait.kb.nl/coop/tel/handbook/telterms.html"
    xmlns:srw="http://www.loc.gov/zing/srw/"
    xmlns:facets="info:srw/extension/4/facets" 
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/">


    <!-- 

    Copyright (c) 2010-2012 KB, Koninklijke Bibliotheek.

    author: Willem Jan Faber.
    requestor: Theo van Veen.

    mobileSearch is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    mobileSearch is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with mobileSearch. If not, see <http://www.gnu.org/licenses/>.

    -->



    <xsl:output method="html" omit-xml-declaration="yes" standalone="yes" encoding='utf-8'/>

    <xsl:variable name="query" select="//srw:query">
    </xsl:variable>

    <xsl:variable name="totalNumberOfRecords" select="//srw:numberOfRecords">
    </xsl:variable>

    <xsl:variable name="currentNumberOfRecords" select="descendant::srw:recordPosition[last()]">
    </xsl:variable>

    <xsl:template match="/">
     <html>
      <head>
      <title>KmoBi | <xsl:value-of select="$query" /></title>
        <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=UTF-8" />
        <meta http-equiv="Cache-Control" content="no-cache" />
        <meta name="HandheldFriendly" content="true" />
        <link rel="alternate" media="handheld" href="" />
        <link type="text/css" rel="stylesheet" href="style.css"/>
      </head>
      <body>

        <div>
            <form action="/mobileSearch/search" method="get">

            <a><xsl:attribute name="href">/mobileSearch/</xsl:attribute>
            <img src="kb_logo_20.gif" alt="kb logo" height="20" border="0" /> </a>

            <xsl:element name="input">
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:attribute name="name">q</xsl:attribute>
                <xsl:attribute name="id">query</xsl:attribute>
                <xsl:attribute name="size">28</xsl:attribute>
                <xsl:attribute name="value"><xsl:value-of select="$query" /> </xsl:attribute>
            </xsl:element>
            <input type="submit" value="Zoek" />
            <input type="hidden" name="startrecord" id="startrecord" value="1" />
            </form>
        </div>
        <div id="sep">
            <xsl:choose>
                <xsl:when test="//srw:recordPosition - //srw:maximumRecords &gt; 0">
                <a><xsl:attribute name="href">view?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="//srw:recordPosition - //srw:maximumRecords" /></xsl:attribute>&lt; Vorige</a>
                </xsl:when>
                <xsl:otherwise>
                &lt; Vorige
                </xsl:otherwise>
            </xsl:choose>
            &#xA0; 
            &#xA0; 
            &#xA0; 
            <xsl:choose>
                <xsl:when test="$currentNumberOfRecords &lt; $totalNumberOfRecords">
                 <a><xsl:attribute name="href">view?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$currentNumberOfRecords + 1"/></xsl:attribute>Volgende &gt;</a>
                </xsl:when>
                <xsl:otherwise>
                Volgende &gt;
                </xsl:otherwise>
            </xsl:choose>
        &#xA0;&#xA0;
        Details record : <xsl:value-of select="//srw:recordPosition" /> van de <b> <xsl:value-of select="$totalNumberOfRecords" /> </b>
        </div>

        <xsl:apply-templates select="//srw:record" />

        <div id="sep1">
            <xsl:choose>
                <xsl:when test="//srw:recordPosition - //srw:maximumRecords &gt; 0">
                <a><xsl:attribute name="href">view?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="//srw:recordPosition - //srw:maximumRecords" /></xsl:attribute>&lt; Vorige</a>
                </xsl:when>
                <xsl:otherwise>
                &lt; vorige
                </xsl:otherwise>
            </xsl:choose>
            &#xA0; 
            &#xA0; 
            &#xA0; 
            <xsl:choose>
                <xsl:when test="$currentNumberOfRecords &lt; $totalNumberOfRecords">
                 <a><xsl:attribute name="href">view?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$currentNumberOfRecords + 1"/></xsl:attribute>Volgende &gt;</a>
                </xsl:when>
                <xsl:otherwise>
                
                </xsl:otherwise>
            </xsl:choose>
        </div>

      </body>
     </html>
    </xsl:template>


    <xsl:template match="srw:record">
        <div><xsl:attribute name="id">record1</xsl:attribute>
         <xsl:apply-templates select="srw:recordData" >
            <xsl:with-param name="POSITION" select="srw:recordPosition" />
        </xsl:apply-templates>
        <br />
        </div>
    </xsl:template>

    <xsl:template match="srw:recordData">
        <xsl:param name="POSITION" select="1" />

        <xsl:if test="count(.//dc:title) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Titel :</td><td>
            <xsl:for-each select=".//dc:title">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.title</xsl:text></xsl:attribute><xsl:value-of select="." /></a> <br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>


        <xsl:if test="count(.//dc:creator) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Auteur :</td><td>
            <xsl:for-each select=".//dc:creator">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.creator</xsl:text></xsl:attribute><xsl:value-of select="." /></a> <br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dc:subject) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Onderwerp :</td><td>
            <xsl:for-each select=".//dc:subject">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.subject</xsl:text></xsl:attribute><xsl:value-of select="." /></a><br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dc:annotation) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Annotatie :</td><td>
            <xsl:for-each select=".//dc:annotation">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.annotation</xsl:text></xsl:attribute><xsl:value-of select="." /></a><br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dc:publisher) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Uitgever :</td><td>
            <xsl:for-each select=".//dc:publisher">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.publisher</xsl:text></xsl:attribute><xsl:value-of select="." /></a><br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dc:date) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Datum :</td><td>
            <xsl:for-each select=".//dc:date">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.date</xsl:text></xsl:attribute><xsl:value-of select="." /></a><br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dc:type) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Type :</td><td>
            <xsl:for-each select=".//dc:type">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.type</xsl:text></xsl:attribute><xsl:value-of select="." /></a><br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>


        <!-- Thumbails / image -->
        <xsl:if test="string-length(.//dcx:thumbnail) &gt; 0">
            <a><xsl:attribute name="href">#</xsl:attribute>
                <img border='0'>
                    <xsl:attribute name="src"><xsl:value-of select=".//dcx:thumbnail" /></xsl:attribute>
                    <xsl:attribute name="alt"><xsl:value-of select=".//dc:title" /></xsl:attribute>
                </img>
            </a>
        </xsl:if>


        <xsl:if test="count(.//dc:contributor) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Medewerker :</td><td>
            <xsl:for-each select=".//dc:contributor">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.contributor</xsl:text></xsl:attribute><xsl:value-of select="." /></a><br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dc:language) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Taal :</td><td>
            <xsl:for-each select=".//dc:language">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.language</xsl:text></xsl:attribute><xsl:value-of select="." /></a><br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dcterms:isPartOf) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Collectie :</td><td>
            <xsl:for-each select=".//dcterms:isPartOf">
                <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dcterms.ispartof_str</xsl:text></xsl:attribute><xsl:value-of select="." /></a><br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dcterms:abstract) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Samenvatting :</td><td>
            <xsl:for-each select=".//dcterms:abstract">
                <xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dcterms.abstract</xsl:text></xsl:attribute><xsl:value-of select="." /><br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dc:identifier) &gt; 0">
            <xsl:for-each select=".//dc:identifier/@*">
                <xsl:if test=".='dcterms:ISBN'">
                <table><tr><td valign="top" width="100"> ISBN:</td><td>
                        <xsl:value-of select="../." />
                </td></tr>
                </table>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>


    </xsl:template>

</xsl:stylesheet>
