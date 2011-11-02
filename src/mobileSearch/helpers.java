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

import java.io.*;
import java.io.File;
import java.util.*;
import java.net.*;
import org.apache.log4j.Logger;


public class helpers {


    public static String getReservationInfo(String ppn, Logger log)
    throws MalformedURLException
    {
        String buffer ="";
        URL url = new URL("http://opc4.kb.nl/DB=1/CMD?ACT=SRCH&IKT=1016&SRT=RLV&TRM="+ppn);
        try {
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
            String readin;
            while ((readin = in.readLine()) != null) {
                buffer=buffer+readin;
            }

        } catch (MalformedURLException e) {} catch (IOException e) {}
        return(buffer);
    }

    public static String getOAIdcx(String oai_url, Logger log) 
    throws MalformedURLException
    {

        String buffer="";
        URL url = new URL(oai_url);

        try {
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
            String readin; 
            Boolean go=false;
            while ((readin = in.readLine()) != null) {
                if ( (!(readin.trim().startsWith("<?xml"))) && ( !(readin.trim().startsWith("</srw_dc:dc>"))) && ( !(readin.trim().startsWith("</metadata>"))) && (!(readin.trim().startsWith("<srw_dc:dc ")))   ) {
                    buffer=buffer+readin;
                }
            }    
        } catch (MalformedURLException e) {}
          catch (IOException e) {}
        return(buffer);
    }

    public static String urlEncode(String s) {
        boolean      changed=false;
        char         c;
        StringBuffer sb=null;
        for(int i=0; i<s.length(); i++) {
            c=s.charAt(i);
            if(c==' ' || c=='+' || c=='<' || c=='&' || c=='>' || c=='"' ||
               c=='\'' || c=='#' || c>0x7f) {
                if(!changed) {
                    if(i>0)
                        sb=new StringBuffer(s.substring(0, i));
                    else
                        sb=new StringBuffer();
                    changed=true;
                }
                sb.append('%').append(Integer.toHexString(c));
            }
            else
                if(changed)
                    sb.append(c);
        }
        if(!changed)
            return s;
        return sb.toString();
    }

    public static String xmlEncode(String s) {
        boolean      changed=false;
        char         c;
        StringBuffer sb=null;
        for(int i=0; i<s.length(); i++) {
            c=s.charAt(i);
            if(c<0xa) {
                if(!changed) {
                    if(i>0)
                        sb=new StringBuffer(s.substring(0, i));
                    else
                        sb=new StringBuffer();
                    changed=true;
                }
                sb.append("&#x").append(Integer.toHexString(c)).append(';');
            }
            else if(c=='<') {
                if(!changed) {
                    if(i>0)
                        sb=new StringBuffer(s.substring(0, i));
                    else
                        sb=new StringBuffer();
                    changed=true;
                }
                sb.append("&lt;");
            }
            else if(c=='>') {
                if(!changed) {
                    if(i>0)
                        sb=new StringBuffer(s.substring(0, i));
                    else
                        sb=new StringBuffer();
                    changed=true;
                }
                sb.append("&gt;");
            }
            else if(c=='"') {
                if(!changed) {
                    if(i>0)
                        sb=new StringBuffer(s.substring(0, i));
                    else
                        sb=new StringBuffer();
                    changed=true;
                }
                sb.append("&quot;");
            }
            else if(c=='&') {
                if(!changed) {
                    if(i>0)
                        sb=new StringBuffer(s.substring(0, i));
                    else
                        sb=new StringBuffer();
                        changed=true;
                }
                sb.append("&amp;");
            }
            else  if(c=='\'') {
                if(!changed) {
                    if(i>0)
                        sb=new StringBuffer(s.substring(0, i));
                    else
                        sb=new StringBuffer();
                    changed=true;
                }
                sb.append("&apos;");
            }
            else
                if(changed)
                    sb.append(c);
        }
        if(!changed)
            return s;
        return sb.toString();
    }
}
