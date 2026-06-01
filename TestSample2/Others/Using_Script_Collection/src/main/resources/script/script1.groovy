/* Refer the link below to learn more about the use cases of script.
https://help.sap.com/viewer/368c481cd6954bdfa5d0435479fd4eaf/Cloud/en-US/148851bf8192412cba1f9d2c17f4bd25.html

If you want to know more about the SCRIPT APIs, refer the link below
https://help.sap.com/doc/a56f52e1a58e4e2bac7f7adbf45b2e26/Cloud/en-US/index.html */
// import com.sap.gateway.ip.core.customdev.util.Message;
// import groovy.util.XmlSlurper;

// def Message processData(Message message)
// {
//     def body = message.getBody(java.lang.String)
//     def node = new XmlSlurper()
//     def obj = node.parseText(body)
//     def id_val = obj.employee[0].id
//     def emp_no = obj.employee[2].@no
//     def emp_name= obj.employee[2].fname
//     def val = obj.employee[1].id.@val
//     def fname = obj.employee.fname
//     def add = obj.employee.address

//     message.setProperty("Value1", id_val)
//      message.setProperty("Value2", emp_no)
//      message.setProperty("Value3", emp_name)
//      message.setProperty("Value4", val)
//      message.setProperty("Value6", fname)
//      message.setProperty("Value5", add)
//   return message;

// import com.sap.gateway.ip.core.customdev.util.Message;
// import com.sap.it.api.mapping.*;

// def String getMessageProcessingLogID(String header,MappingContext context)
// {
//         String mplId = context.getHeader("SAP_MessageProcessingLogID").toString();
//         return mplId;

import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;
def Message processData(Message message)
{
    def removal=message.getBody(java.lang.String) as String;
    removal = removal.replaceFirst(/\s*<\?xml.*?\?>/, "")
    message.setBody(removal);
    return message;
}
