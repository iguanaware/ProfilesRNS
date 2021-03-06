﻿/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Xsl;



using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.PassiveList
{
    public partial class PassiveList : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public PassiveList() { }

        public PassiveList(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
        }
        public void DrawProfilesModule()
        {
            DateTime d = DateTime.Now;

            //If your module performs a data request, based on the DataURI parameter then call ReLoadBaseData
            base.GetDataByURI();

            XmlDocument document = new XmlDocument();
            XsltArgumentList args = new XsltArgumentList();
            bool networkexists = false;

            System.Text.StringBuilder documentdata = new System.Text.StringBuilder();

            
            documentdata.Append("<PassiveList");
            documentdata.Append(" InfoCaption=\"");
            documentdata.Append(base.GetModuleParamString("InfoCaption"));
            documentdata.Append("\"");
            documentdata.Append(" Description=\"");
            documentdata.Append(base.GetModuleParamString("Description"));
            documentdata.Append("\"");
            documentdata.Append(" ID=\"");
            documentdata.Append(Guid.NewGuid().ToString());
            documentdata.Append("\"");
            documentdata.Append(" MoreText=\"");
            documentdata.Append(CustomParse.Parse(base.GetModuleParamString("MoreText"), base.BaseData, base.Namespaces));

            documentdata.Append("\"");

            documentdata.Append(" MoreURL=\"");
            if (base.GetModuleParamString("MoreURL").Contains("&"))
                documentdata.Append(Root.Domain + CustomParse.Parse(base.GetModuleParamString("MoreURL"), base.BaseData, base.Namespaces).Replace("&", "&amp;"));
            else
                documentdata.Append(CustomParse.Parse(base.GetModuleParamString("MoreURL"), base.BaseData, base.Namespaces));
            documentdata.Append("\"");

            documentdata.Append(">");
            documentdata.Append("<ItemList>");

            string path = base.GetModuleParamString("ListNode");
            //path = path.Substring(path.LastIndexOf("@rdf:about=") + 12);
            //path = path.Substring(0, path.Length - 1);
            try
            {
                XmlNodeList items = this.BaseData.SelectNodes(path, this.Namespaces);
                int remainingItems = Convert.ToInt16(base.GetModuleParamString("MaxDisplay"));
                foreach (XmlNode i in items)
                {
                    if (remainingItems == 0) break;
                    remainingItems--;

                    XmlNode networknode = this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about=\"" + i.Value + "\"]", this.Namespaces);

                    string itemurl = CustomParse.Parse(base.GetModuleParamString("ItemURL"), networknode, this.Namespaces);
                    string itemurltext = CustomParse.Parse(base.GetModuleParamString("ItemURLText"), networknode, this.Namespaces);
                    string item = CustomParse.Parse(base.GetModuleParamString("ItemText"), networknode, this.Namespaces);

                    networkexists = true;

                    documentdata.Append("<Item");

                    if (base.GetModuleParamString("ItemURL") != string.Empty)
                    {
                        documentdata.Append(" ItemURL=\"" + itemurl);
                        documentdata.Append("\"");
                        if (!itemurltext.Equals("")) documentdata.Append(" ItemURLText=\"" + itemurltext);
                        else documentdata.Append(" ItemURLText=\"" + CustomParse.Parse("{{{//rdf:Description[@rdf:about='" + itemurl + "']/rdfs:label}}}", this.BaseData, this.Namespaces));
                        documentdata.Append("\"");
                    }
                    documentdata.Append(">");
                    documentdata.Append(item);
                    documentdata.Append("</Item>");
                }
            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace); }
/*
           try
            {
                var items = from XmlNode networknode in this.BaseData.SelectNodes(base.GetModuleParamString("ListNode") + "[position() < " + Math.BigMul((Convert.ToInt16(base.GetModuleParamString("MaxDisplay")) + 1), 1).ToString() + "]", this.Namespaces)                                                        
                            select new
                            {
                                itemurl = CustomParse.Parse(base.GetModuleParamString("ItemURL"), networknode, this.Namespaces),
                                itemurltext = CustomParse.Parse(base.GetModuleParamString("ItemURLText"), networknode, this.Namespaces),
                                item = CustomParse.Parse(base.GetModuleParamString("ItemText"), networknode, this.Namespaces)
                            };

                foreach (var i in items)
                {
                    networkexists = true;

                    documentdata.Append("<Item");

                    if (base.GetModuleParamString("ItemURL") != string.Empty)
                    {
                        documentdata.Append(" ItemURL=\"" + i.itemurl);
                        documentdata.Append("\"");
                        if (!i.itemurltext.Equals("")) documentdata.Append(" ItemURLText=\"" + i.itemurltext);
                        else documentdata.Append(" ItemURLText=\"" + CustomParse.Parse("{{{//rdf:Description[@rdf:about='"+ i.itemurl + "']/rdfs:label}}}", this.BaseData, this.Namespaces));
                        documentdata.Append("\"");
                    }
                    documentdata.Append(">");
                    documentdata.Append(i.item);
                    documentdata.Append("</Item>");
                }

            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace); }
*/
            documentdata.Append("</ItemList>");
            documentdata.Append("</PassiveList>");

            if (networkexists)
            {
                document.LoadXml(documentdata.ToString());


                args.AddParam("root", "", Root.Domain);
                args.AddParam("ListNode", "", base.GetModuleParamString("ListNode"));
                args.AddParam("InfoCaption", "", base.GetModuleParamString("InfoCaption"));
                args.AddParam("Description", "", base.GetModuleParamString("Description"));
                args.AddParam("MoreUrl", "", base.GetModuleParamString("ListNode"));



                litPassiveNetworkList.Text = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/PassiveList/PassiveList.xslt"), args, document.OuterXml);

                Framework.Utilities.DebugLogging.Log("PASSIVE MODULE end Milliseconds:" + (DateTime.Now - d).TotalSeconds);
            }
        }
    }
}



















