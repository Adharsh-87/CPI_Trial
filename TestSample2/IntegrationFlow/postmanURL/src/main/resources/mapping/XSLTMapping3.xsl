<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    <xsl:param name="Id"/>
    <xsl:param name="age"/>
	<xsl:template match="/">
		<fullname>
		     <xsl:value-of select="concat(root/fname,root/lname)"/>
		     </fullname>
		
		<dob>
    <xsl:variable name = "day" select = "substring(root/dob,1,2)"/>
    <xsl:variable name = "month" select = "substring(root/dob,4,2)"/>
    <xsl:variable name = "year" select = "substring(root/dob,7,4)"/>
    <xsl:value-of select="concat($day, '/', $month,'/', $year)"/> 
    </dob>

    <names_join>
    <xsl:value-of select="string-join((root/fname,root/lname),',')"/>
    </names_join>
    <address_updated><xsl:value-of select="replace(root/address,'Hyderabad','warangal')"/>
    </address_updated>
	<id> <xsl:value-of select = "$Id"/> </id>
	<age> <xsl:value-of select = "$age"/> </age>
	</xsl:template>
    </xsl:stylesheet>
