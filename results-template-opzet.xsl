<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:srw_dc="http://purl.org/dc/elements/1.1/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:srw="http://www.loc.gov/zing/srw/"
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
        <style type="text/css">
                * {font-size:small;font-family:Arial, Helvetica, sans-serif; padding: 0px; margin: 0px; }
                body {font-size:small;font-family:Arial, Helvetica, sans-serif; padding: 0px; margin: 0px; }
        </style>
      </head>
      <body>
        <xsl:apply-templates select="//srw:record" />
      </body>
     </html>
    </xsl:template>


    <xsl:template match="srw:record">
        <div><xsl:attribute name="id">record<xsl:value-of select="srw:recordPosition mod 2" /></xsl:attribute>
         <xsl:value-of select="srw:recordPosition" />.
         <xsl:apply-templates select="srw:recordData" >
            <xsl:with-param name="POSITION" select="srw:recordPosition" />
        </xsl:apply-templates>
        <br />
        </div>
    </xsl:template>

    <xsl:template match="srw:recordData">
        <xsl:param name="POSITION" select="1" />

        <xsl:if test="count(.//dc:creator) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Auteur :</td><td>
            <xsl:for-each select=".//dc:creator">
                <xsl:value-of select="." /> <br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>

        <xsl:if test="count(.//dc:creator) &gt; 0">
            <table>
            <tr><td valign="top" width="100"> Auteur :</td><td>
            <xsl:for-each select=".//dc:creator">
                <xsl:value-of select="." /> <br />
            </xsl:for-each>
            </td></tr>
            </table>
        </xsl:if>


        <!--

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
