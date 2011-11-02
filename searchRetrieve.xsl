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


<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:srw_dc="info:srw/schema/1/dc-v1.1" xmlns:srw="http://www.loc.gov/zing/srw/" xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>
    <xsl:output method='html' omit-xml-declaration='yes' encoding='utf-8'/>
    <xsl:template match='/'>
        <html>
            <head>
                <title>Simple SRU server implemented with WebService::Solr</title>
                <link type="text/css" rel="stylesheet" href="style.css" />
            </head>
            <body>
                <h1>Search results</h1>
 				
 				<!-- the search form -->
 				<xsl:copy-of select="document('form.xml')" />
 				
                <!-- echo the query and number of hits returned -->
                <p>
                    <xsl:text>Your search -- </xsl:text>
                    <strong>
                    <xsl:value-of select='srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:query' />
                    </strong>
                    <xsl:text> -- matched </xsl:text>
                    <xsl:value-of select='srw:searchRetrieveResponse/srw:numberOfRecords' />
                    <xsl:text> record(s).</xsl:text>
                </p>
                
                <!-- list the records -->
                <ol><xsl:attribute name='start'><xsl:value-of select='srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:startRecord'/></xsl:attribute>
                    <xsl:for-each select='//srw_dc:dc'>
                        <li class='record'>
                            <a>
                                <xsl:attribute name='href'>
                                    <xsl:value-of select='dc:identifier' />
                                </xsl:attribute>
                                <xsl:value-of select='dc:title' />
                            </a>
                            <ul class='detaillist'>
                                <xsl:for-each select='dc:creator'>
                                	<li>
                                		<span class='bold'>creator</span> - 
                                		<xsl:value-of select='.' />
                                	</li>
                                </xsl:for-each>
                                <xsl:for-each select='dc:subject'>
                                	<li>
                                		<span class='bold'>subject</span> - 
                                		<xsl:value-of select='.' />
                                	</li>
                                </xsl:for-each>
                                <li>
                                <span class='bold'>contributor</span> - 
                                <xsl:value-of select='dc:contributor' /></li>
                                <li>
                                <span class='bold'>publisher</span> - 
                                <xsl:value-of select='dc:publisher' /></li>
                                <li>
                                <span class='bold'>relation</span> - 
                                <xsl:value-of select='dc:relation' /></li>
                                <li>
                                <span class='bold'>format</span> - 
                                <xsl:value-of select='dc:format' /></li>
                                <li>
                                <span class='bold'>type</span> - 
                                <xsl:value-of select='dc:type' /></li>
                                <li>
                                <span class='bold'>ID</span> - 
                                <xsl:value-of select='dc:identifier' /></li>
                                <li><span class='bold'>description</span> - 
                                <xsl:value-of select='dc:description' /></li>
                            </ul>
                        </li>
                    </xsl:for-each>
                </ol>
                
                <!-- pager -->
                <xsl:variable name="link" select="concat('./server.cgi?version=1.1&amp;operation=searchRetrieve&amp;query=', srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:query, '&amp;maximumRecords=', srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:maximumRecords, '&amp;stylesheet=', srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:stylesheet, '&amp;startRecord=' )"/>
                <xsl:variable name='start' select='srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:startRecord'/>
                <xsl:variable name="max" select='srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:maximumRecords'/>
                <xsl:variable name="previous" select='concat($link, ($start - $max))'/>
                <xsl:variable name="next" select='concat($link, ($start + $max))'/>
                <p style='text-align: center'>
                <xsl:if test="($start - $max) &gt; 0" >
                <a><xsl:attribute name='href'><xsl:value-of select='$previous'/></xsl:attribute>Previous</a>&#xA0;&#xA0;
                </xsl:if>
                <xsl:if test="($start + $max) &lt; srw:searchRetrieveResponse/srw:numberOfRecords" >
                &#xA0;&#xA0;<a><xsl:attribute name='href'><xsl:value-of select='$next'/></xsl:attribute>Next</a>
                </xsl:if>
                </p>
                <!-- footer -->
 				<xsl:copy-of select="document('footer.xml')" />

            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
