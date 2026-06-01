/* Refer the link below to learn more about the use cases of script.
https://help.sap.com/viewer/368c481cd6954bdfa5d0435479fd4eaf/Cloud/en-US/148851bf8192412cba1f9d2c17f4bd25.html

If you want to know more about the SCRIPT APIs, refer the link below
https://help.sap.com/doc/a56f52e1a58e4e2bac7f7adbf45b2e26/Cloud/en-US/index.html */
import com.sap.gateway.ip.core.customdev.util.Message;

def Message processData(Message message) {

    //To set or modify the body, you can use the following methods.
    // def body = message.getBody();
    // message.setBody(body);
    
    //To set or modify the headers, you can use the following methods.
    /* message.setHeader("oldHeader", value + " Sunchu");
      message.setHeader("newHeader", "CPI"); 

    //To set or modify the properties, you can use the following methods.
    def properties = message.getProperties();
    value = properties.get("oldProperty");
    message.setProperty("oldProperty", value + " Busisness Consulting");
    message.setProperty("newProperty", "Hyderabad"); */
    
    //def headers = message.getHeaders();
    //def value = headers.get("oldname");
    //message.setHeader("oldname")
    //println value;
    // return message;
    
    //println message.getHeader("oldname");
     def headers = [
          "Location": "Delhi",
         "Employee": "Rahul",
        "Company": "PBC",
        "Salary":"40000" 
    ] 

    // // def headers = message.getHeaders()
    // // headers.putAll(headersMap)

    message.setHeaders(headers)
    return message;
}