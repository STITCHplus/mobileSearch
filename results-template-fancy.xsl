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

<xsl:variable name="next" select="/srw:searchRetrieveResponse/srw:nextRecordPosition">
</xsl:variable>

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
            body {font-size:small;font-family:Arial, Helvetica, sans-serif; padding: 0px; margin: 8px; }
            div { margin: 0px; padding: 0px; }
            .center {text-align:center;}
            #logo { text-align: center; }
            #container { text-align: center; }
            img { margin : 0; border: 0px; vertical-align: middle; margin-bottom: 2px; }
            #query {border: 1px solid #7aa5d6; margin-left: 2px; margin-right: 2px;}

            #sep {background-color: #EFEBF9; margin: 0px 0 10px 0px; width: 100%;padding: 2px 2px 4px 0px; border-top: 1px solid #3366CC; }
            #sep1 {background-color: #EFEBF9; margin: 10px 0 0px 0px; width: 100%;padding: 2px 2px 4px 0px; border-top: 1px solid #3366CC; }

            #prefix {margin-left: 10px; display: inline; }
            #value  {position: absolute; left: 0px; margin-left:120px; }

            li { list-style-type : none; margin-left: 70px; }

            #record1{background-color: #FFFFFF;display: block; }
            #record0{background-color: #EFEFEF;display: block; }
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

    <xsl:if test="($totalNumberOfRecords &gt; 0)">
    <div id="sep">

        Resultaten : <xsl:value-of select="//srw:recordPosition" /> - <xsl:value-of select="$currentNumberOfRecords" /> van de <b> <xsl:value-of select="$totalNumberOfRecords" /> </b>
        &#xA0; 
        ||
        &#xA0; 

        <xsl:choose>
            <xsl:when test="//srw:recordPosition - //srw:maximumRecords &gt; 0">
            <a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="//srw:recordPosition - 4" />&amp;maximumRecords=4</xsl:attribute>&lt; Vorige</a>
            </xsl:when>
            <xsl:otherwise>
                
            </xsl:otherwise>
        </xsl:choose>
        &#xA0; 
        &#xA0; 
        &#xA0; 

        <xsl:choose>
            <xsl:when test="$next &gt; 0">
             <a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$next"/>&amp;maximumRecords=8</xsl:attribute>Volgende &gt;</a>
            </xsl:when>
            <xsl:otherwise>
            
            </xsl:otherwise>
        </xsl:choose>

    </div>

        <xsl:apply-templates select="//srw:record" />
        

    <div id="sep1">
        <xsl:choose>
            <xsl:when test="//srw:recordPosition - //srw:maximumRecords &gt; 0">
            <a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="//srw:recordPosition - 4" />&amp;maximumRecords=4</xsl:attribute>&lt; Vorige</a>
            </xsl:when>
            <xsl:otherwise>
            &lt; vorige
            </xsl:otherwise>
        </xsl:choose>
        &#xA0; 
        &#xA0; 
        &#xA0; 
        <xsl:choose>
            <xsl:when test="$next &gt; 0">
             <a><xsl:attribute name="href">search?cql=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$next"/>&amp;maximumRecords=8</xsl:attribute>Volgende &gt;</a>
            </xsl:when>
            <xsl:otherwise>
             volgende &gt;
            </xsl:otherwise>
        </xsl:choose>
    </div>
    </xsl:if>

    <xsl:if test="($totalNumberOfRecords=0)">
    <div id="sep">
        Resultaten : <b> 0</b> records gevonden voor : <xsl:value-of select="$query"/>
    </div>
        <br />
        Geen resultaten gevonden, probeer het opnieuw <br />
        Keer terug naar het <a><xsl:attribute name="href">/mobileSearch/</xsl:attribute>zoek</a> scherm.<br />
        <br />
    <div id="sep1">
        &#xA0;
    </div>
    </xsl:if>

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
        &#xA0;<a><xsl:attribute name="href">view?q=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$POSITION" /></xsl:attribute><xsl:value-of select=".//dc:title" /></a> <br />

        <xsl:if test="(count(.//dc:creator) &gt; 0)" >
        <div style="float:left; display:inline;">Door :</div>

        <xsl:choose>
            <xsl:when test="count(.//dc:creator) &lt; 4">
                <xsl:for-each select=".//dc:creator">
                   <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.creator</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
                </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <li><a><xsl:attribute name="href">search?q="<xsl:value-of select=".//dc:creator[1]" /><xsl:text>"&amp;field=dc.creator</xsl:text></xsl:attribute><xsl:value-of select=".//dc:creator[1]" /></a></li>
            <li><a><xsl:attribute name="href">search?q="<xsl:value-of select=".//dc:creator[1]" /><xsl:text>"&amp;field=dc.creator</xsl:text></xsl:attribute><xsl:value-of select=".//dc:creator[2]" /></a></li>
            <li><a><xsl:attribute name="href">search?q="<xsl:value-of select=".//dc:creator[1]" /><xsl:text>"&amp;field=dc.creator</xsl:text></xsl:attribute><xsl:value-of select=".//dc:creator[3]" /></a></li>
            <li> <a><xsl:attribute name="href">view?q=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$POSITION" /></xsl:attribute>(meer..)</a></li>
        </xsl:otherwise>
        </xsl:choose>
        </xsl:if>

        <xsl:for-each select=".//dc:date">
        <div style="float:left; display:inline;">Datum :</div>
            <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.date</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
        </xsl:for-each>
    
        <xsl:for-each select=".//dc:publisher">
        <div style="float:left; display:inline;">Uitgever :</div>
            <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.publisher</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
        </xsl:for-each>

        <div style="float:left; display:inline;">Type :</div>
            <li><a><xsl:attribute name="href">search?q="<xsl:value-of select=".//dc:type" /><xsl:text>"&amp;field=dc.type</xsl:text></xsl:attribute><xsl:value-of select=".//dc:type" /></a></li>


        <xsl:if test=".//dc:type = 'image' ">
        <xsl:for-each select=".//dc:identifier">
        <xsl:if test="starts-with(., 'http')">
        <img style="margin-left: 70px; "><xsl:attribute name="src"><xsl:value-of select="." />&amp;role=thumbnail</xsl:attribute><xsl:attribute name="width">75</xsl:attribute></img>
        </xsl:if>
        </xsl:for-each>
        </xsl:if>

        <xsl:if test="(count(.//dc:subject) &gt; 0)" >
        <div style="float:left; display:inline;">Onderwerp :</div>

        <xsl:choose>
            <xsl:when test="count(.//dc:subject) &lt; 4">
                <xsl:for-each select=".//dc:subject">
                   <li><a><xsl:attribute name="href">search?q="<xsl:value-of select="." /><xsl:text>"&amp;field=dc.subject</xsl:text></xsl:attribute><xsl:value-of select="." /></a></li>
                </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <li><a><xsl:attribute name="href">search?q="<xsl:value-of select=".//dc:subject[1]" /><xsl:text>"&amp;field=dc.subject</xsl:text></xsl:attribute><xsl:value-of select=".//dc:subject[1]" /></a></li>
            <li><a><xsl:attribute name="href">search?q="<xsl:value-of select=".//dc:subject[1]" /><xsl:text>"&amp;field=dc.subject</xsl:text></xsl:attribute><xsl:value-of select=".//dc:subject[2]" /></a></li>
            <li><a><xsl:attribute name="href">search?q="<xsl:value-of select=".//dc:subject[1]" /><xsl:text>"&amp;field=dc.subject</xsl:text></xsl:attribute><xsl:value-of select=".//dc:subject[3]" /></a></li>
            <li> <a><xsl:attribute name="href">view?q=<xsl:value-of select="$query"/>&amp;startRecord=<xsl:value-of select="$POSITION" /></xsl:attribute>(meer..)</a></li>
        </xsl:otherwise>
        </xsl:choose>
        </xsl:if>

 

    

    </xsl:template>


</xsl:stylesheet>
