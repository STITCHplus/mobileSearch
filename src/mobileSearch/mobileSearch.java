/*
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

*/

package mobileSearch;

import mobileSearch.helpers;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;
import java.io.FileInputStream;
import java.io.File;

import java.util.*;
import java.net.*;

import javax.xml.transform.*;
import javax.xml.transform.stream.*;

import org.apache.log4j.Logger;
import org.apache.log4j.BasicConfigurator;


public class mobileSearch extends HttpServlet {

    final private static String RESPONSE_HEADER = "text/html; charset=UTF-8";

    private static Properties config = new Properties();
    private static String config_path = "";

    public Logger log = Logger.getLogger(mobileSearch.class);
    private static String baseURL = "";
    private static String SRUbaseURL = "";

    public void init() throws ServletException {
        final String CONFIG_PATH = getServletContext().getRealPath("/");
        this.config_path = CONFIG_PATH;

        final String APPLICATION_NAME = getServletContext().getServletContextName();

        BasicConfigurator.configure();
        
        FileInputStream config_file = null;
        File config = new File(CONFIG_PATH+"config.ini");
        
        if (config.canRead()) {
            log.debug("Parsing "+CONFIG_PATH+"config.ini");
            try {
                config_file = new FileInputStream(CONFIG_PATH+"config.ini");
            } catch (java.io.FileNotFoundException e) {
                throw new ServletException(e);
            }

            Properties config_prop = new Properties();

            try {
                config_prop.load((config_file));
            } catch (java.io.IOException e) {
                throw new ServletException(e);
            }
            this.config = config_prop;

            log.debug("Parsing finished");
        } else {
            log.fatal("Error, cannot read "+ CONFIG_PATH + "config.ini" );
        }

        this.baseURL=this.config.getProperty("baseurl"); 
        this.SRUbaseURL=this.config.getProperty("sru_baseurl"); 

        log.debug("Baseurl: "+ this.baseURL);
        log.debug("Init fase done");
    }

    public String query2CQL(String query, String field, String collection, String startRecord, String numRecords, Boolean Sort) {
        String q=query.trim();
        
        if (! (field == null) ) {
            if (field.length() > 0) {
                q=field+ "="+ (helpers.urlEncode(query));
            } else {
                q=helpers.urlEncode(query);
            }
        } else {
        	if (!(q.startsWith("\""))) {
                //q='"'+q+'"';
                q=helpers.urlEncode(q)+"&facet=type";
                //+"&facet=date,type,language,subject,creator,ispartof";
            } else {
                log.debug("\n Do not urlencode : "+ q + "\n");
                log.debug("\n This would result in  : "+ helpers.urlEncode(q) + "\n");
                q=helpers.urlEncode(q);
            }

        }
       
        if (( collection == null  )  ||  ( collection.length() == 0) ){ 
            q+="&maximumRecords="+numRecords+"&startRecord="+startRecord+"&x-collection="+this.config.getProperty("collections")+"&recordSchema=dc&operation=searchRetrieve&version=1.1";
        } else {
            q+=" AND "+collection+"&maximumRecords="+numRecords+"&startRecord="+startRecord+"&recordSchema=dc";
        }

        return(q);
    }


    public StringBuffer getSRUdata(String cqlquery) 
    throws MalformedURLException {
        URL url = new URL(this.SRUbaseURL+"?query="+cqlquery);

        StringBuffer result = new StringBuffer ("");
        try {
           BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
           String readin;
           while ((readin = in.readLine()) != null) {
            result.append(readin); 
        } }catch (MalformedURLException e) { }
        catch (IOException e) { }
	if ( result.length() == 0 ) {
		this.log.debug("No data from sru source : "+ url);
	} else {
	 	this.log.debug("Done getting data from source : "+ url);
	}
        return(result);
    }


    public String parseSRU2html(StringBuffer data, Boolean fullrecord) 
    throws FileNotFoundException {

        StringReader data1 = new StringReader(data.toString());
        StreamSource style = null;
        
        if ( !fullrecord ) {
            style = new StreamSource(new FileInputStream((this.config_path+this.config.getProperty("xsl_normal"))));
        } else {
            style = new StreamSource(new FileInputStream((this.config_path+this.config.getProperty("xsl_detail"))));
        }
    
        StreamSource source = new StreamSource(data1);
        TransformerFactory tFact = TransformerFactory.newInstance();
        ByteArrayOutputStream out1 = new ByteArrayOutputStream();
        StreamResult out = new StreamResult(out1);
        Writer out2 = new StringWriter();
        out.setWriter(out2);

        try {
            Transformer transformer = tFact.newTransformer(style);
            transformer.transform(source, out);

        } catch (Exception e) {
            log.debug(e.getCause());
            return("err");
        }
        return(out2.toString());
    }


    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException {

        response.setContentType(RESPONSE_HEADER);
        request.setCharacterEncoding("UTF-8");

        PrintWriter out = new PrintWriter(
                new OutputStreamWriter(response.getOutputStream(), "UTF8"), true);
        
        String query = request.getParameter("query");

        if ( query==null ) {
            query=request.getParameter("q");
        }


        if (query == null) {
            response.sendRedirect(response.encodeRedirectURL(this.baseURL));
        }

        if (query.length() <=0) {
            response.sendRedirect(response.encodeRedirectURL(this.baseURL));
        }

        out.println(query);
        String nquery = "";
        if (query.indexOf("creator:") > -1 ) {
            out.println(query.indexOf("creator:"));
        } 

        URL url = new URL("http://www.kbresearch.nl/tpxslt/?xml=http://www.kbresearch.nl/kbSRU/?q="+helpers.urlEncode(query)+"&xsl=http://www.kbresearch.nl/mobileSearch/results-template.xsl");

        try {
           BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(),  "UTF-8"));
           String readin;
           while ((readin = in.readLine()) != null) {
            out.println(readin);
        } }catch (MalformedURLException e) { } catch (IOException e) { }

        }

    public void doPost(HttpServletRequest request, HttpServletResponse response) 
    throws IOException, ServletException
    {
        doGet(request, response);
    }
}
