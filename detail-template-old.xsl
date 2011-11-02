<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:srw_dc="http://purl.org/dc/elements/1.1/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcx="http://krait.kb.nl/coop/tel/handbook/telterms.html"
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


<xsl:variable name="thumbnail" select="//dcx:thumbnail">
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
            body {font-size:small;font-family:Arial, Helvetica, sans-serif; padding: 0px; margin: 8px; }
            div { margin: 0px; padding: 0px; display: block; clear: both; }
            .center {text-align:center;}
            #logo { text-align: center; }

            #container { text-align: center; }

            img { margin : 0; border: 0px; vertical-align: middle; margin-bottom: 2px; }

            #query {border: 1px solid #7aa5d6; margin-left: 2px; margin-right: 2px;}

            #sep {background-color: #EFEBF9; margin: 0px 0 10px 0px; width: 100%;padding: 2px 2px 4px 0px; border-top: 1px solid #3366CC; }
            #sep1 {background-color: #EFEBF9; margin: 10px 0 0px 0px; width: 100%;padding: 2px 2px 4px 0px; border-top: 1px solid #3366CC; }

            li { list-style-type : none; margin-left: 140px; }

            #record1{background-color: #FFFFFF;display: block; }
            #record0{background-color: #EFEFEF;display: block; }

            #block { margin-left: 10px; float: left; clear: right;  }
            #value { margin-left: 100px; float: left; clear: right; }
    </style>
 </head>
 <body>
    <div>

        <form action="/mobileSearch/search" method="get">

        <a><xsl:attribute name="href">/mobileSearch/</xsl:attribute>
        <img src="kb_logo_20.gif" alt="kb logo" height="20" /> </a>

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

        Details : <b><xsl:value-of select="//dc:title" /></b> 

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
        <xsl:apply-templates select="srw:recordData" >
            <xsl:with-param name="POSITION" select="srw:recordPosition" />
        </xsl:apply-templates>
        <br />
    </xsl:template>

    <xsl:template match="srw:recordData">
        <xsl:param name="POSITION" select="1" />
        &#xA0;<a><xsl:attribute name="href">view?q=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$POSITION" /></xsl:attribute><xsl:value-of select=".//dc:title" /></a> <br /><br />


        <div id="block">
        <xsl:if test="(count(//dc:creator) &gt; 0)" >
            Auteur :
        </xsl:if>
        <xsl:template match="//dc:creator">
            <xsl:apply-templates select="//dc:creator">
            </xsl:apply-templates>
        </xsl:template>


        <xsl:if test="(count(//dc:subject) &gt; 0)" >
            Onderwerp :
        </xsl:if>
        <xsl:template match="//dc:subject">
            <xsl:apply-templates select="//dc:subject">
            </xsl:apply-templates>
        </xsl:template>

        <xsl:if test="(count(//dc:language) &gt; 0)" >
            <div style="float:left; display:inline;">Taal :</div>
        </xsl:if>
        <xsl:template match="//dc:language">
            <xsl:apply-templates select="//dc:language">
            </xsl:apply-templates>
        </xsl:template>

        <xsl:if test="(count(//dc:date) &gt; 0)" >
            <div style="float:left; display:inline;">Datum :</div>
        </xsl:if>        
        <xsl:template match="//dc:date">
            <xsl:apply-templates select="//dc:date">
            </xsl:apply-templates>
        </xsl:template>

        <xsl:if test="(count(//dc:contributor) &gt; 0)" >
            <div style="float:left; display:inline;">Medewerker :</div>
        </xsl:if>
        <xsl:template match="//dc:contributor">
            <xsl:apply-templates select="//dc:contributor">
            </xsl:apply-templates>
        </xsl:template>


        <xsl:if test="(count(//dc:publisher) &gt; 0)" >
            <div style="float:left; display:inline;">Uitgever :</div>
        </xsl:if>
        <xsl:template match="//dc:publisher">
            <xsl:apply-templates select="//dc:publisher">
            </xsl:apply-templates>
        </xsl:template>


        <xsl:if test="(count(//dc:annotation) &gt; 0)" >
            <div style="float:left; display:inline;">Annotatie :</div>
        </xsl:if>
        <xsl:template match="//dc:annotation">
            <xsl:apply-templates select="//dc:annotation">
            </xsl:apply-templates>
        </xsl:template>


        <xsl:if test="(count(//dc:type) &gt; 0)" >
            <div style="float:left; display:inline;">Type :</div>
        </xsl:if>
        <xsl:template match="//dc:type">
            <xsl:apply-templates select="//dc:type">
            </xsl:apply-templates>
        </xsl:template>

        <xsl:template match="//dc:identifier">
            <xsl:apply-templates select="//dc:identifier">
            </xsl:apply-templates>
        </xsl:template>

      
        <xsl:if test="string-length($thumbnail) &gt; 0">

        <a><xsl:attribute name="href">#</xsl:attribute>
        <img><xsl:attribute name="src"><xsl:value-of select="$thumbnail" /></xsl:attribute></img></a>
        
        </xsl:if>
        </div>

    </xsl:template>


    <xsl:template match="//dc:creator">
        <xsl:for-each select=".">
        <div id="value">
        <a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.creator</xsl:text></xsl:attribute><xsl:value-of select="." /></a>
        </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="//dc:subject">
        <xsl:for-each select=".">
        <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.subject</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
        </xsl:for-each>
    </xsl:template>



    <xsl:template match="//dc:language">
        <xsl:for-each select=".">
        <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.language</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="//dc:date">
        <xsl:for-each select=".">
        <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.date</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="//dc:contributor">
        <xsl:for-each select=".">
        <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.contributor</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="//dc:publisher">
        <xsl:for-each select=".">
        <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.publisher</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="//dc:annotation">
        <xsl:for-each select=".">
        <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.annotation</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
        </xsl:for-each>
    </xsl:template>



    <xsl:template match="dc:type">
        <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.type</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
    </xsl:template>
    

    <xsl:template match="dc:identifier">
        <xsl:for-each select="@*">
            <xsl:if test=".='dcterms:ISBN'">
                <div style="float:left; display:inline;">ISBN :</div>
                <li><xsl:value-of select="../." /></li>  <!-- ISBN -->
            </xsl:if> 
            <xsl:if test=".='dcterms:URI'">
                <div style="float:left; display:inline;">Uitleen status:</div>
                <li><a><xsl:attribute name="href"><xsl:text>http://www.google.com/gwt/n?u=</xsl:text><xsl:value-of select="../." /></xsl:attribute>Beschikbaarheid opvragen</a></li>
            </xsl:if> 
            <xsl:value-of select="." />
            <xsl:value-of select="name()" />
        </xsl:for-each>
    </xsl:template>



</xsl:stylesheet>



