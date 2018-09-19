<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Collections;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections.Generic;

public class Handler : IHttpHandler {

    public string targetIpAddress = "127.0.0.1";

    public Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
    public string rawCommand = "";

    private string returnStr;

    public void ProcessRequest (HttpContext context) {



        context.Response.ContentType = "text/plain";
        returnStr = string.Empty;

        if(context.Request["cmd"]!=null)
        {
            //rawCommand = context.Request["cmd"];
            rawCommand = context.Request["cmd"].ToString();
            try
            {
                returnStr += CmdHandler(targetIpAddress, rawCommand);
            }
            catch
            {
                returnStr += "cmd format error";
            }
            finally
            {
                context.Response.Write(rawCommand + " return " + returnStr);
            }


        }

    }


    private string CmdHandler(string ipStr, string cmdStr)
    {
        try
        {
            IPAddress targetIp;
            if(IPAddress.TryParse(ipStr,out targetIp))
            {
                try
                {

                    IPEndPoint ep = new IPEndPoint(targetIp, 6320);  //暂时端口写死
                    TcpClient tcpClient = new TcpClient();
                    tcpClient.Connect(ep);
                    NetworkStream ns = tcpClient.GetStream();
                    byte[] buffer2send = new byte[cmdStr.Length];
                    buffer2send = Encoding.UTF8.GetBytes(cmdStr);
                    ns.Write(buffer2send, 0, buffer2send.Length);
                    tcpClient.Close();

                }
                catch
                {
                    return "catch error1";
                }

            }
            else
            {
                return "error ip address";
            }
        }
        catch
        {
            return "catch error";
        }
        return true.ToString();

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}