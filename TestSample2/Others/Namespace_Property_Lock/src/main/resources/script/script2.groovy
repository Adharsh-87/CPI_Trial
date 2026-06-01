/* Refer the link below to learn more about the use cases of script.
https://help.sap.com/viewer/368c481cd6954bdfa5d0435479fd4eaf/Cloud/en-US/148851bf8192412cba1f9d2c17f4bd25.html

If you want to know more about the SCRIPT APIs, refer the link below
https://help.sap.com/doc/a56f52e1a58e4e2bac7f7adbf45b2e26/Cloud/en-US/index.html */
import com.sap.gateway.ip.core.customdev.util.Message;

def Message processData(Message message) {

    def body = message.getBody(String)

    def intMatcher = body =~ /<int>(.*?)<\/int>/
    if(intMatcher.find()) {
        message.setProperty("int", intMatcher.group(1))
    }

    def webOrderMatcher = body =~ /<ns5:webOrderNumber>(.*?)<\/ns5:webOrderNumber>/
    if(webOrderMatcher.find()) {
        message.setProperty("webOrderNumber", webOrderMatcher.group(1))
    }

    def lineMatcher = body =~ /<ns5:lineNumber>(.*?)<\/ns5:lineNumber>/
    if(lineMatcher.find()) {
        message.setProperty("lineNumber", lineMatcher.group(1))
    }

    return message
}