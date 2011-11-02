<?xml version="1.0" encoding="UTF-8"?>

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


<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:srw_dc="http://purl.org/dc/elements/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:srw="http://www.loc.gov/zing/srw/"
    xmlns:tel="http://krait.kb.nl/coop/tel/handbook/telterms.html"
    xmlns:dcx="http://krait.kb.nl/coop/tel/handbook/telterms.html"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:diag="http://www.loc.gov/zing/srw/diagnostic/">

    <xsl:output method="html" omit-xml-declaration="yes" standalone="yes" encoding='utf-8'/>

    <xsl:variable name="query" select="//srw:query"></xsl:variable>

    <xsl:variable name="totalNumberOfRecords" select="//srw:numberOfRecords">
    </xsl:variable>

    <xsl:variable name="currentNumberOfRecords" select="descendant::srw:recordPosition[last()]">
    </xsl:variable>

    <xsl:template match="srw:record">
        <div><xsl:attribute name="id">record<xsl:value-of select="srw:recordPosition mod 2" /></xsl:attribute>
         <xsl:apply-templates select="srw:recordData" >
            <xsl:with-param name="POSITION" select="srw:recordPosition" />
        </xsl:apply-templates>
        </div>
    </xsl:template>

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
    Biografieën (vorm) 
        <div style="background: #fffff;">
            <form action="/mobileSearch/search" method="get">

            <a><xsl:attribute name="href">/mobileSearch/</xsl:attribute>
            <img src="logo_kb_home.gif" alt="kb logo" border="0" /> </a>

            <xsl:element name="input">
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:attribute name="name">q</xsl:attribute>
                <xsl:attribute name="id">query</xsl:attribute>
                <xsl:attribute name="size">50</xsl:attribute>
                <xsl:attribute name="value"><xsl:value-of select="$query" /> </xsl:attribute>
            </xsl:element>

            <input type="submit" value="Zoek" />
            <input type="hidden" name="startrecord" id="startrecord" value="1" />
            </form>
        </div>

        <div id="sep">
            <xsl:choose>
                <xsl:when test="//srw:recordPosition - //srw:maximumRecords &gt; 0">
                <a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="//srw:recordPosition - //srw:maximumRecords" /></xsl:attribute>&lt; Vorige</a>
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
                 <a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$currentNumberOfRecords + 1"/></xsl:attribute>Volgende &gt;</a>
                </xsl:when>
                <xsl:otherwise>
                Volgende &gt;
                </xsl:otherwise>
            </xsl:choose>
        &#xA0;&#xA0;
        Resultaten : <xsl:value-of select="//srw:recordPosition" /> - <xsl:value-of select="$currentNumberOfRecords" /> van de <b> <xsl:value-of select="$totalNumberOfRecords" /> </b>
        </div>

        <xsl:apply-templates select="//srw:record" />

        <div id="sep1">
            <xsl:choose>
                <xsl:when test="//srw:recordPosition - //srw:maximumRecords &gt; 0">
                <a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="//srw:recordPosition - //srw:maximumRecords" /></xsl:attribute>&lt; Vorige</a>
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
                 <a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$currentNumberOfRecords + 1"/></xsl:attribute>Volgende &gt;</a>
                </xsl:when>
                <xsl:otherwise>
                
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="//srw:facets" />
        </div>
      </body>
     </html>
    </xsl:template>

    
        <xsl:template match="srw:facets">
    <xsl:variable name="sign">"</xsl:variable> 
    <p style="margin: 0px; padding: 0px;">
    Toon : 
    <xsl:for-each select="srw:facet">
                <xsl:for-each select="srw:facetValue">
                <xsl:if test="./srw:valueString/text()='boek'">
                    <xsl:variable name="boek_count" select="./srw:count"></xsl:variable>
                    <xsl:choose>
                    <xsl:when test="not($boek_count=$totalNumberOfRecords)">
                        <xsl:if test="not(contains($query, $sign))">
                        <b> Boeken </b><a><xsl:attribute name="href">search?cql="<xsl:value-of select="$query"/>"+AND+type_str="boek"</xsl:attribute>(<xsl:value-of select="$boek_count"/>)</a>
                        </xsl:if>
                        <xsl:if test="contains($query, $sign)">
                        <b> Boeken </b><a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>+AND+type_str="boek"</xsl:attribute>(<xsl:value-of select="$boek_count"/>)</a>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="contains($query, ' AND type_str=')">
                         <b><a><xsl:attribute name="href">search?cql=<xsl:value-of select="substring-before($query, ' AND')"/></xsl:attribute>Alles</a></b>
                        </xsl:if>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>

                <xsl:if test="./srw:valueString/text()='tijdschrift/serie'">
                    <xsl:variable name="tijd_count" select="./srw:count"></xsl:variable> 
                    <xsl:choose>
                    <xsl:when test="not($tijd_count=$totalNumberOfRecords)">
                        <xsl:if test="not(contains($query, $sign))">
                        <b> Tijdschriften </b><a><xsl:attribute name="href">search?cql="<xsl:value-of select="$query"/>"+AND+type_str="tijdschrift/serie"</xsl:attribute>(<xsl:value-of select="$tijd_count"/>)</a>
                        </xsl:if>
                        <xsl:if test="contains($query, $sign)">
                        <b> Tijdschriften </b><a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>+AND+type_str="tijdschrift/serie"</xsl:attribute>(<xsl:value-of select="$tijd_count"/>)</a>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="contains($query, ' AND type_str=')">
                          <b><a><xsl:attribute name="href">search?cql=<xsl:value-of select="substring-before($query, ' AND')"/></xsl:attribute>Alles</a></b>
                        </xsl:if>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>

                <xsl:if test="./srw:valueString/text()='Sound'">
                    <xsl:variable name="sound_count" select="./srw:count"></xsl:variable> 
                    <xsl:choose>
                    <xsl:when test="not($sound_count=$totalNumberOfRecords)">
                        <xsl:if test="not(contains($query, $sign))">
                        <b> Geluid </b><a><xsl:attribute name="href">search?cql="<xsl:value-of select="$query"/>"+AND+type_str="Sound"</xsl:attribute>(<xsl:value-of select="$sound_count"/>)</a>
                        </xsl:if>
                        <xsl:if test="contains($query, $sign)">
                        <b> Geluid </b><a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>+AND+type_str="Sound"</xsl:attribute>(<xsl:value-of select="$sound_count"/>)</a>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="contains($query, ' AND type_str=')">
                          <b><a><xsl:attribute name="href">search?cql=<xsl:value-of select="substring-before($query, ' AND')"/></xsl:attribute>Alles</a></b>
                        </xsl:if>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>


                <xsl:if test="./srw:valueString/text()='StillImage'">
                    <xsl:variable name="stillimg_count" select="./srw:count"></xsl:variable>
                </xsl:if>

                <xsl:if test="./srw:valueString/text()='image'">
                    <xsl:variable name="img_count" select="./srw:count"></xsl:variable> 
                <xsl:choose>
                <xsl:when test="not($img_count=$totalNumberOfRecords)">
                    <xsl:if test="not(contains($query, $sign))">
                    <b> Afbeeldingen </b><a><xsl:attribute name="href">search?cql="<xsl:value-of select="$query"/>"+AND+type_str="image"</xsl:attribute>(<xsl:value-of select="$img_count"/>)</a>
                    </xsl:if>
                    <xsl:if test="contains($query, $sign)">
                    <b> Afbeeldingen </b><a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>+AND+type_str="image"</xsl:attribute>(<xsl:value-of select="$img_count"/>)</a>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="contains($query, ' AND type_str=')">
                        <b><a><xsl:attribute name="href">search?cql=<xsl:value-of select="substring-before($query, ' AND')"/></xsl:attribute>Alles</a></b>
                    </xsl:if>
                </xsl:otherwise>
                </xsl:choose>
             </xsl:if>
                </xsl:for-each>

    </xsl:for-each>
    </p>
    </xsl:template>


    <xsl:template match="srw:recordData">
        <xsl:param name="POSITION" select="1" />

        <xsl:if test="count(.//dc:title) &gt; 0">
            <table>
            <tr><td valign="top" width="40" align="center">
            <xsl:value-of select="$POSITION" />
            </td><td>
            <xsl:choose>
                <xsl:when test="string-length(substring-before(.//dc:title, ' /')) &lt; 50">
                    <a class="title"><xsl:attribute name="href">view?q=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$POSITION" /></xsl:attribute>
                    <xsl:choose>
                    <xsl:when test="contains(.//dc:title, ' /')">
                        <xsl:value-of select="substring-before(.//dc:title, ' /')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(.//dc:title, 1,50)" />
                    </xsl:otherwise>
                    </xsl:choose>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <a class="title"><xsl:attribute name="href">view?q=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$POSITION" /></xsl:attribute><xsl:value-of select="substring(substring-before(.//dc:title,' /'), 1,50)" />..(meer)</a>
                </xsl:otherwise>
            </xsl:choose>
            </td></tr>
            </table>
        </xsl:if>

 
        <!--

        <xsl:if test="count(.//dc:creator) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Auteur :</td><td>
            <xsl:for-each select=".//dc:creator">
                <xsl:value-of select="." /> <br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dc:subject) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Onderwerp :</td><td>
            <xsl:for-each select=".//dc:subject">
                <xsl:value-of select="." /> <br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>



        <xsl:if test="count(.//dc:contributor) &gt; 0">
            Medewerker : 
            <xsl:for-each select=".//dc:contributor">
                <xsl:value-of select="." />
            </xsl:for-each>
        </xsl:if>


        <xsl:for-each select=".">
            <div style="width: 100%;"><span style="width: 150px;">
            <b><xsl:value-of select="name()" /> : </b></span>
            <xsl:value-of select="." /> </div>
        </xsl:for-each>

        -->
    </xsl:template>

</xsl:stylesheet>
