<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<fullname> <xsl:value-of select="concat(root/fname,root/lname)"/> </fullname>
	</xsl:template>
</xsl:stylesheet>
